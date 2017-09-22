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

    # Use the *fsglobal mark to transparently handle windows needing to be
    # fullscreened globally or not
    #print(e.change, e.container.name, e.container.fullscreen_mode, e.container.focused, e.container.marks)
    if e.container.fullscreen_mode == 1 and e.container.focused and "*fsglobal" in e.container.marks:
        e.container.command("fullscreen enable global")
    if e.container.fullscreen_mode == 2 and "*fsglobal" not in e.container.marks:
        e.container.command("fullscreen enable")

conn = i3ipc.Connection()
conn.on('window', on_window)
conn.main()
