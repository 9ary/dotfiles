#!/usr/bin/env python3

from soco.core import SoCo
from sys import argv

sonos = SoCo("192.0.0.11")
vol_step = 5

if argv[1] == "line_in":
    sonos.switch_to_line_in()
    sonos.play()

if argv[1] == "+":
    sonos.volume = (int(sonos.volume / vol_step) + 1) * vol_step

if argv[1] == "-":
    sonos.volume = (int(sonos.volume / vol_step) - 1) * vol_step

if argv[1] == "set":
    sonos.volume = int(argv[2])

if argv[1] == "mute":
    sonos.mute = not(sonos.mute)

