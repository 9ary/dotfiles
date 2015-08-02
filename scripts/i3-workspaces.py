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

# Look for the first free slot
max_number = 1
for ws in wslist:
    try:
        if ":" in ws:
            max_number_new = int(ws.split(":")[0])
        else:
            max_number_new = int(ws)
        if max_number_new == max_number:
            max_number += 1
    except ValueError:
        pass


if sys.argv[1] == "-s":
    name = dmenu("SwitchTo", wslist)
    if len(name):
        if not(":" in name):
            name = str(max_number) + ":" + name
        conn.command("workspace" + name)

if sys.argv[1] == "-m":
    name = dmenu("MoveTo", wslist)
    if len(name):
        if not(":" in name):
            name = str(max_number) + ":" + name
        conn.command("move container to workspace" + name)

if sys.argv[1] == "-r":
    cur_number = 0
    cur_name = ""
    if ":" in active_ws:
        active_ws = active_ws.split(":")
        cur_name = active_ws[1]
        cur_number = active_ws[0]
    else:
        cur_number = active_ws

    name = dmenu("Rename", [cur_name])
    if len(name):
        if not(":" in name):
            name = cur_number + ":" + name
        name = '"' + name + '"'
        conn.command("rename workspace to" + name)

