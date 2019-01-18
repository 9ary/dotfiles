#!/usr/bin/env python3

# Very simple script to generate Xresources colors

import colorsys
from pathlib import Path

base16 = []

ramp_hue = 0 / 360
ramp_sat = 0
for i in range(8):
    v = (i + 2) / 10
    base16.append(colorsys.hsv_to_rgb(ramp_hue, ramp_sat, v))

colors_sat = .55
colors_v = .7
colors = [
    0,  # Red
    18,  # Orange/salmon
    60,  # Yellow
    110,  # Green
    160,  # Cyan
    210,  # Blue
    300,  # Magenta/pink
    34,  # Brown/orange
]
for c in colors:
    base16.append(colorsys.hsv_to_rgb(c / 360, colors_sat, colors_v))

ansi_map = [
    0x00,
    0x08,
    0x0B,
    0x0A,
    0x0D,
    0x0E,
    0x0C,
    0x05,
    0x03,
    0x09,
    0x01,
    0x02,
    0x04,
    0x06,
    0x0F,
    0x07,
]
fg_map = ansi_map[7]
bg_map = ansi_map[0]
cur_map = fg_map


def base16_to_rgb(i):
    c = base16[i]
    r = int(c[0] * 255)
    g = int(c[1] * 255)
    b = int(c[2] * 255)
    return f"#{r:0{2}X}{g:0{2}X}{b:0{2}X}"


with Path("~/dotfiles/x/colors.xresources").expanduser().open("w") as f:
    f.write(f"*foreground: {base16_to_rgb(fg_map)}\n")
    f.write(f"*background: [background_opacity]{base16_to_rgb(bg_map)}\n")
    f.write(f"*cursorColor: {base16_to_rgb(cur_map)}\n")
    for n, c in enumerate(ansi_map):
        f.write(f"*color{n}: {base16_to_rgb(c)}\n")

with Path("~/dotfiles/i3/colors").expanduser().open("w") as f:
    for i in range(16):
        f.write(f"set $base{i:0{2}X} {base16_to_rgb(i)}\n")
