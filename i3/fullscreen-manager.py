#!/usr/bin/env python3

import i3ipc

def on_window(self, e):
    if e.container.window_class == "TelegramDesktop" \
            and e.container.name == "Media viewer":
        e.container.command("fullscreen disable")
        e.container.command("move absolute position center")
        return

    screenrect = conn.get_outputs()[0].rect
    w, h = screenrect.width, screenrect.height

    if e.container.floating.endswith("on") \
            and e.container.fullscreen_mode == 0 \
            and e.container.window_rect.width == w \
            and e.container.window_rect.height == h:
        e.container.command("fullscreen enable")

conn = i3ipc.Connection()
conn.on('window', on_window)
conn.main()
