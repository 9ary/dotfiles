#!/usr/bin/env python3

import i3ipc
import sys

conn = i3ipc.Connection()

workspaces = conn.get_workspaces()
ws_max = 0
ws_tree = {}
for ws in workspaces:
    if ws.num > ws_max:
        ws_max = ws.num

    if ws.output in ws_tree:
        ws_tree[ws.output] += [ ws ]
    else:
        ws_tree[ws.output] = [ ws ]

    if ws.focused:
        ws_cur = ws
        out_cur = ws_tree[ws.output]
        ws_cur_index = len(out_cur) - 1

if sys.argv[1] == "next":
    if not(ws_cur_index == (len(out_cur) - 1)):
        conn.command("workspace" + out_cur[ws_cur_index + 1].name)
    elif conn.get_tree().find_focused().window == None:
        conn.command("workspace" + out_cur[0].name)
    else:
        conn.command("workspace" + str(ws_max + 1))

if sys.argv[1] == "prev":
    if ws_cur_index == 0:
        conn.command("workspace" + str(ws_max + 1))
    else:
        conn.command("workspace" + out_cur[ws_cur_index - 1].name)

if sys.argv[1] == "move":
    if sys.argv[2] == "next":
        if not(ws_cur_index == (len(out_cur) - 1)):
            conn.command("move container to workspace" + out_cur[ws_cur_index + 1].name)
        else:
            conn.command("move container to workspace" + str(ws_max + 1))

    if sys.argv[2] == "prev":
        if ws_cur_index == 0:
            conn.command("move container to workspace" + str(ws_max + 1))
        else:
            conn.command("move container to workspace" + out_cur[ws_cur_index - 1].name)
