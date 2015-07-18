#!/usr/bin/env python3

import i3ipc
from subprocess import Popen, PIPE
import sys

def dmenu(prompt, options):
    command = ["dmenu"]

    if len(prompt):
        command += ["-p", prompt]

    pipe_in = "\n".join(options).encode()

    proc = Popen(command, stdout=PIPE, stdin=PIPE)
    return proc.communicate(pipe_in)[0].decode().strip()

# Create the Connection object that can be used to send commands and subscribe
# to events.
conn = i3ipc.Connection()

# Get and sort the workspace list
wss = conn.get_workspaces()
wslist = []
active_ws = ""
for ws in wss:
    wslist += [ws.name]
    if ws.focused:
        active_ws = ws.name
wslist.sort()

if sys.argv[1] == "-s":
    name = dmenu("SwitchTo", wslist)
    if len(name):
        if not(name in wslist):
            name = str(len(wslist) + 1) + ":" + name
        conn.command("workspace" + name)

if sys.argv[1] == "-m":
    name = dmenu("MoveTo", wslist)
    if len(name):
        conn.command("move container to workspace" + name)

if sys.argv[1] == "-r":
    name = dmenu("Rename", [active_ws.split(":")[1]])
    if len(name):
        name = active_ws.split(":")[0] + ":" + name
        conn.command("rename workspace to" + name)

