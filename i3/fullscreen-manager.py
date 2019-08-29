#!/usr/bin/env python3

import i3ipc
from gi.repository import Notify

Notify.init("i3-fullscreen-manager")
notify_pause = Notify.Notification.new("DUNST_COMMAND_PAUSE", "", "dialog-information")
notify_unpause = Notify.Notification.new("DUNST_COMMAND_RESUME", "", "dialog-information")

def on_window(self, e):
    if e.container.window_class == "TelegramDesktop" \
            and e.container.name == "Media viewer":
        e.container.command("fullscreen disable")
        e.container.command("move absolute position center")
        return

    if e.container.focused:
        if e.container.fullscreen_mode:
            notify_pause.show()
        else:
            notify_unpause.show()

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
