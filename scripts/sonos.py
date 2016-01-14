#!/usr/bin/env python3

from soco.core import SoCo
from sys import argv

sonos = SoCo("10.0.0.11")
vol_step = 5

if argv[1] == "line_in":
    sonos.switch_to_line_in()
    sonos.play()

if argv[1] == "+":
    sonos.volume += vol_step

if argv[1] == "-":
    sonos.volume -= vol_step

if argv[1] == "mute":
    sonos.mute = not(sonos.mute)

