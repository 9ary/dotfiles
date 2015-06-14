#!/usr/bin/env python3

import i3ipc
from gi.repository import Notify

# Create the Connection object that can be used to send commands and subscribe
# to events.
conn = i3ipc.Connection()

# Window event callback
def on_window(self, e):
    if e.container.focused:
        if e.container.fullscreen_mode:
            notify_pause.show()
        else:
            notify_unpause.show()
        

# Subscribe to the window event
conn.on('window', on_window)

# Initialize libnotify
Notify.init("i3-dunst-autopause")
notify_pause = Notify.Notification.new("DUNST_COMMAND_PAUSE", "", "dialog-information")
notify_unpause = Notify.Notification.new("DUNST_COMMAND_RESUME", "", "dialog-information")

# Start the main loop and wait for events to come in.
conn.main()

