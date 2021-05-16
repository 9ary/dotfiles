#!/usr/bin/env python3

import i3ipc
import subprocess

def on_window(self, e):
    if e.container.focused:
        if e.container.fullscreen_mode:
            subprocess.run(["dunstctl", "set-paused", "true"], check=True)
        else:
            subprocess.run(["dunstctl", "set-paused", "false"], check=True)

conn = i3ipc.Connection()
conn.on('window', on_window)
conn.main()
