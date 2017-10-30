#!/usr/bin/env python3

import i3ipc
from gi.repository import Notify

Notify.init("i3-fullscreen-manager")
notify_pause = Notify.Notification.new("DUNST_COMMAND_PAUSE", "", "dialog-information")
notify_unpause = Notify.Notification.new("DUNST_COMMAND_RESUME", "", "dialog-information")

def on_window(self, e):
    if e.container.focused:
        if e.container.fullscreen_mode:
            notify_pause.show()
        else:
            notify_unpause.show()

conn = i3ipc.Connection()
conn.on('window', on_window)
conn.main()
