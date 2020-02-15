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
COLOR_GOOD = "#60B250"
COLOR_DEGRADED = "#B2B250"
COLOR_BAD = "#B25050"


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
        self.mixer = alsaaudio.Mixer()
        self.watcher = None
        self.volume = None

    async def update(self):
        if self.watcher is None:
            self.watcher = FdWatcher(self.mixer.polldescriptors()[0][0])
        await self.watcher.poll()
        self.mixer.handleevents()
        self.volume = self.mixer.getvolume()[0]
        self.mute = bool(self.mixer.getmute()[0])
        return self

    def render(self):
        if self.volume is not None:
            return {
                    "full_text": f"♫ {self.volume}%",
                    "color": COLOR_DEGRADED if self.mute else None}


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
        self.fifo = None

    async def _connect(self):
        self._disconnect()
        while True:
            try:
                self.device = soco.discovery.by_name(self.zone)
                break
            except (OSError, TypeError):
                await asyncio.sleep(1)
        self.rendering_control = self.device.renderingControl.subscribe(
                auto_renew=True)

        if self.fifo is None:
            fifo_path = f"/run/user/{os.getuid()}/sonos_volume"
            try:
                os.remove(fifo_path)
            except FileNotFoundError:
                pass
            os.mkfifo(fifo_path)
            # We need to open the FIFO this way for two reasons:
            # - open() will block until someone else opens the FIFO for
            #   writing, unless we use O_NONBLOCK
            # - add_reader() takes a raw fd rather than a file object
            fifo_fd = os.open(fifo_path, os.O_NONBLOCK)
            asyncio.get_running_loop().add_reader(
                    fifo_fd, self._process_volume_commands)
            self.fifo = os.fdopen(fifo_fd, "rb")

    def _disconnect(self):
        if self.device is not None:
            self.rendering_control.unsubscribe()
            soco.events.event_listener.stop()

    def _process_volume_commands(self):
        if (data := self.fifo.read()) is None:
            return
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
            return {
                    "full_text": f"♫ {self.volume}%",
                    "color": COLOR_DEGRADED if self.mute else None}


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


asyncio.run(main())
