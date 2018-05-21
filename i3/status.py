#!/usr/bin/env python3

import asyncio
from concurrent.futures import ThreadPoolExecutor
import glob
import json
import os
import platform
import sys
import time

import psutil
import soco

import mpd

HOST = platform.node()
INTERVAL = 1
COLOR_GOOD = "#38C060"
COLOR_DEGRADED = "#C0C030"
COLOR_BAD = "#C03030"


class CpuLoad:
    def render(self):
        p = int(psutil.cpu_percent())
        return {"full_text": f"CPU:{p:02}%"}


class Temperature:
    def __init__(self, label, path):
        self.label = label
        self.file = open(glob.glob(path)[0])

    def render(self):
        self.file.seek(0, 0)
        t = int(self.file.read().strip()) // 1000
        return {
                "instance": self.label,
                "full_text": f"{self.label}:{t:02}°C"}


class Time:
    def __init__(self, format):
        self.format = format

    def render(self):
        return {"full_text": time.strftime(self.format)}


class Mpd:
    def __init__(self):
        self.mpd = mpd.MpdClient()
        self.first_update = True
        self.state = "stop"

    async def update(self):
        if not self.first_update:
            await self.mpd.idle("player")
        self.first_update = False
        status, song = await asyncio.gather(
                self.mpd.status(),
                self.mpd.currentsong())
        self.state = status.get("state")
        self.title = song.get("title")
        self.artist = song.get("artist")
        self.album = song.get("album")
        return self

    def render(self):
        if self.state != "stop":
            full = f"♫ {self.artist} - {self.title} ({self.album})"
        else:
            full = "♫ -"
        short = f"{full[:160]}..."
        color = COLOR_GOOD if self.state == "play" else COLOR_DEGRADED
        return {"full_text": full, "short_text": short, "color": color}


class SonosVolume:
    VOLUME_STEP = 5

    def __init__(self, zone):
        self.volume = None
        self.device = soco.discovery.by_name(zone)
        self.rendering_control = self.device.renderingControl.subscribe(
                auto_renew=True)
        self.executor = ThreadPoolExecutor(max_workers=1)
        self.volume_server = asyncio.get_event_loop().create_task(
                asyncio.start_unix_server(
                    self.volume_client_connnected,
                    path=f"/run/user/{os.getuid()}/sonos_volume"))

    async def volume_client_connnected(self, r, w):
        data = await r.read()
        for byte in data:
            if byte == ord("+"):
                self.device.volume = (
                    (self.volume // self.VOLUME_STEP + 1) * self.VOLUME_STEP)
            elif byte == ord("-"):
                self.device.volume = (
                    (self.volume // self.VOLUME_STEP - 1) * self.VOLUME_STEP)
            elif byte == ord("x"):
                self.device.mute = not self.mute
            elif byte == ord("l"):
                self.device.switch_to_line_in()
                self.device.play()
        w.write_eof()

    async def update(self):
        event = await asyncio.get_event_loop().run_in_executor(
                self.executor, self.rendering_control.events.get)
        volume = event.variables.get("volume")
        if volume is not None:
            self.volume = int(volume["Master"])
        mute = event.variables.get("mute")
        if mute is not None:
            self.mute = bool(int(mute["Master"]))
        return self

    def __del__(self):
        self.rendering_control.unsubscribe()
        soco.events.event_listener.stop()

    def render(self):
        if self.volume is not None:
            return {
                    "full_text": f"♫ {self.volume}%",
                    "color": COLOR_DEGRADED if self.mute else None}


blocks = []

if HOST == "Akatsuki":
    blocks.append(SonosVolume("La Grotte"))
    blocks.append(Mpd())

blocks.append(CpuLoad())
blocks.append(Temperature(
        "CPU", "/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input"))
if HOST == "Akatsuki":
    blocks.append(Temperature(
            "GPU",
            "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0"
            "/hwmon/hwmon*/temp1_input"))

blocks.append(Time("%a %d %b %H:%M"))


def print_unbuffered(*lines):
    for line in lines:
        sys.stdout.write(line + "\n")
    sys.stdout.flush()


async def main():
    # Queue updates for all async blocks
    updates = []
    for block in blocks:
        try:
            updates.append(asyncio.ensure_future(block.update()))
        except AttributeError:
            pass

    header = {"version": 1}
    print_unbuffered(json.dumps(header), "[")

    while True:
        render = []
        for block in blocks:
            r = block.render()
            if r is not None:
                r["name"] = block.__class__.__name__
                render.append(r)
        print_unbuffered(json.dumps(render) + ",")

        if not updates:
            await asyncio.sleep(INTERVAL)
            continue
        done, pending = await asyncio.wait(
                updates, timeout=INTERVAL, return_when=asyncio.FIRST_COMPLETED)
        for update in done:
            # Updates return the block they belong to so it's easier to queue
            # a new update again
            updates.append(asyncio.ensure_future(update.result().update()))
            updates.remove(update)


asyncio.get_event_loop().run_until_complete(main())
