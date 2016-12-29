#!/usr/bin/env python3

import fcntl
import json
import locale
import socket
import struct
import sys

from soco.core import SoCo

locale_encoding = locale.nl_langinfo(locale.CODESET)

iface = struct.pack("256s", "eno1".encode(locale_encoding))
own_ip = socket.inet_aton("10.0.0.10")
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
if own_ip == fcntl.ioctl(s, 0x8915, iface)[20:24]: # SIOCGIFADDR
    sonos = SoCo("10.0.0.11")

color_good = "#38C060"
color_degraded = "#C0C030"
color_bad = "#C03030"

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + "\n")
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == "__main__":
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ""
        # ignore comma at start of lines
        if line.startswith(","):
            line, prefix = line[1:], ","

        j = json.loads(line)

        # Truncate music titles
        j[1]["short_text"] = j[1]["full_text"][:160] + "..."

        try:
            block = { "name": "sonos" }
            volume = sonos.volume
            mute = sonos.mute
            icon = "♫"
            if mute:
                icon = "✕"
                block["color"] = color_degraded
            block["full_text"] = "{} {}%".format(icon, volume)
            j.insert(0, block)
        except:
            pass

        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
