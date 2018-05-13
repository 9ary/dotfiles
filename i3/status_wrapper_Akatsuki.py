#!/usr/bin/env python

import status_wrapper

from soco.core import SoCo

sonos = SoCo("10.0.0.11")

def wrap(j):
    # Truncate music titles
    j[1]["short_text"] = j[1]["full_text"][:160] + "..."

    try:
        block = { "name": "sonos" }
        volume = sonos.volume
        mute = sonos.mute
        icon = "♫"
        if mute:
            block["color"] = status_wrapper.color_degraded
        block["full_text"] = "{} {}%".format(icon, volume)
        j.insert(0, block)
    except:
        pass

    return j

status_wrapper.mainloop(wrap)
