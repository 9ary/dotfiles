#!/usr/bin/env python3

import asyncio
from concurrent.futures import ThreadPoolExecutor
import glob
import json
import os
import platform
from queue import Empty
import sys
import time

import alsaaudio
import psutil
import soco

import mpd

HOST = platform.node()
INTERVAL = 1
COLOR_GOOD = "#1D9700"
COLOR_DEGRADED = "#C49700"
COLOR_BAD = "#D6000C"
BACKGROUND = "#CDCDCD"
BLOCK_MARGIN = 4
SEPARATOR_WIDTH = 6


class FdWatcher:
    def __init__(self, fd):
        self.fd = fd
        self.queue = asyncio.Queue()
        def done():
            while not self.queue.empty():
                self.queue.get_nowait().set_result(None)
                self.queue.task_done()
        self.loop = asyncio.get_running_loop()
        self.loop.add_reader(self.fd, done)

    def __del__(self):
        self.loop.remove_reader(self.fd)

    def poll(self):
        fut = asyncio.Future()
        self.queue.put_nowait(fut)
        return fut


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


class Battery:
    BATTERY_STATUSES = {
            "Charging": "C",
            "Full": "F",
            "Discharging": "B"}

    def __init__(self, path):
        self.file = open(path)

    def render(self):
        charge = None
        charge_rel = None
        charge_full = None
        charge_full_design = None
        watts = None
        discharge_rate = None
        voltage = None
        status = "?"

        self.file.seek(0, 0)
        for line in self.file.readlines():
            k, v = line.rstrip("\n").split("=", 1)
            k = k.replace("POWER_SUPPLY_", "")
            if k in ("ENERGY_NOW", "CHARGE_NOW"):
                charge = int(v)
            elif k.endswith("_FULL"):
                charge_full = int(v)
            elif k.endswith("_FULL_DESIGN"):
                charge_full_design = int(v)
            elif k == "CAPACITY":
                charge_rel = int(v) / 100
            elif k in ("POWER_NOW", "CURRENT_NOW"):
                watts = k.startswith("POWER")
                discharge_rate = int(v) / 1e6
            elif k == "VOLTAGE_NOW":
                voltage = int(v) / 1e3
            elif k == "STATUS":
                status = self.BATTERY_STATUSES.get(v, "?")

        full = charge_full_design or charge_full
        if charge is not None and full is not None:
            charge_rel = charge / full

        if not watts and discharge_rate is not None and voltage is not None:
            discharge_rate *= voltage

        return {
                "full_text":
                        f"{status}:{charge_rel:.0%} {discharge_rate:.2f}W",
                "color": COLOR_BAD if charge_rel <= .2 else None}


class AlsaVolume:
    def __init__(self):
        self.mixer = None
        self.watcher = None
        self.volume = None

    async def update(self):
        if self.mixer is None:
            try:
                self.mixer = alsaaudio.Mixer()
            except alsaaudio.ALSAAudioError:
                await asyncio.sleep(1)
                return self
        if self.watcher is None:
            self.watcher = FdWatcher(self.mixer.polldescriptors()[0][0])
        await self.watcher.poll()
        self.mixer.handleevents()
        self.volume = self.mixer.getvolume()[0]
        self.mute = bool(self.mixer.getmute()[0])
        return self

    def render(self):
        if self.volume is not None:
            if not self.mute:
                return {"full_text": f"♫ {self.volume}%"}
            else:
                return {"full_text": f"♫ ×", "color": COLOR_DEGRADED}


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
        self.zone = zone
        self.device = None
        self.executor = ThreadPoolExecutor(max_workers=1)
        self.volume_server = None

    async def _connect(self):
        self._disconnect()
        while True:
            try:
                #self.device = soco.discovery.by_name(self.zone)
                device = soco.SoCo("10.0.3.138")
                if device is not None:
                    self.rendering_control = device.renderingControl.subscribe(
                            auto_renew=True)
                    self.device = device
                    break
            except:
                await asyncio.sleep(1)

        if self.volume_server is None:
            self.volume_server = await asyncio.start_unix_server(
                    self._volume_client_connnected,
                    path=f"/run/user/{os.getuid()}/sonos_volume")

    def _disconnect(self):
        if self.device is not None:
            self.rendering_control.unsubscribe()
            soco.events.event_listener.stop()

    async def _volume_client_connnected(self, r, w):
        data = await r.read()
        for byte in data:
            if byte == ord("+"):
                self.volume = (
                    (self.volume // self.VOLUME_STEP + 1) * self.VOLUME_STEP)
                self.device.volume = self.volume
            elif byte == ord("-"):
                self.volume = (
                    (self.volume // self.VOLUME_STEP - 1) * self.VOLUME_STEP)
                self.device.volume = self.volume
            elif byte == ord("x"):
                self.mute = not self.mute
                self.device.mute = self.mute
            elif byte == ord("l"):
                self.device.switch_to_line_in()
                self.device.play()
        w.write_eof()

    async def update(self):
        if self.device is None:
            await self._connect()

        try:
            event = await asyncio.get_running_loop().run_in_executor(
                    self.executor,
                    lambda: self.rendering_control.events.get(timeout=5))
        except Empty:
            if self.rendering_control.time_left == 0:
                await self._connect()
            return self

        volume = event.variables.get("volume")
        if volume is not None:
            self.volume = int(volume["Master"])
        mute = event.variables.get("mute")
        if mute is not None:
            self.mute = bool(int(mute["Master"]))
        return self

    def __del__(self):
        self._disconnect()

    def render(self):
        if self.volume is not None:
            if not self.mute:
                return {"full_text": f"♫ {self.volume}%"}
            else:
                return {"full_text": f"♫ ×", "color": COLOR_DEGRADED}


blocks = []

blocks.append(AlsaVolume())

if HOST == "Akatsuki":
    blocks.append(SonosVolume("La Grotte"))
    blocks.append(Mpd())

blocks.append(CpuLoad())
if HOST == "Akatsuki":
    blocks.append(Temperature(
            "CPU",
            "/sys/bus/pci/drivers/k10temp/0000:*/hwmon/hwmon*/temp1_input"))
    blocks.append(Temperature(
            "GPU",
            "/sys/bus/pci/drivers/amdgpu/0000:*/hwmon/hwmon*/temp1_input"))
else:
    blocks.append(Temperature(
            "CPU",
            "/sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input"))

if HOST == "Hitagi":
    blocks.append(Battery("/sys/class/power_supply/BAT1/uevent"))

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

    header = {
            "version": 1,
            "stop_signal": 0,
            "cont_signal": 0}
    print_unbuffered(json.dumps(header), "[")

    while True:
        render = []
        for block in blocks:
            r = block.render()
            if r is not None:
                render.append({
                    "name": block.__class__.__name__,
                    "background": BACKGROUND,
                    "border": BACKGROUND,
                    "border_left": BLOCK_MARGIN,
                    "border_right": BLOCK_MARGIN,
                    "separator_block_width": SEPARATOR_WIDTH,
                    "separator": False,
                    **r,
                })
        render[-1]["separator_block_width"] = 0
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


asyncio.run(main())
