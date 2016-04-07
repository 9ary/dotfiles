#!/usr/bin/env python3

import locale
import re
import shlex
import subprocess as sp
import sys

cmd_git_status = "git status --porcelain --branch"
cmd_git_commit = "git rev-parse --short HEAD"

encoding = locale.nl_langinfo(locale.CODESET)

def call_sp(cmd):
    try:
        out = sp.check_output(shlex.split(cmd), stderr = sp.DEVNULL)
        return out.decode(encoding).splitlines()
    except sp.CalledProcessError:
        sys.exit()

def color(c, bold = False):
    ret = "%{\x1b[0"
    if c >= 0:
        ret += ";38;5;{}".format(c)
    if bold:
        ret += ";1"
    ret += "m%}"
    return ret

git_status = call_sp(cmd_git_status)

branchline = git_status[0][3:]
branch_new = "Initial commit on "
if branchline[:len(branch_new)] == branch_new:
    branchline = branchline[len(branch_new):]

ahead, behind = 0, 0

if branchline == "HEAD (no branch)":
    revision = ":" + call_sp(cmd_git_commit)[0]
else:
    branchline = re.match("^(?P<branch>.+?(?=\.\.\.|$))(?:.+?(?= |$)(?: \[(?P<distance>.+)\])?)?", branchline)
    revision = branchline.group("branch")
    distance = branchline.group("distance")
    if distance is not None:
        branch_ahead = "ahead "
        branch_behind = "behind "
        for d in distance.split(", "):
            if d[:len(branch_ahead)] == branch_ahead:
                ahead = int(d[len(branch_ahead):])
            if d[:len(branch_behind)] == branch_behind:
                behind = int(d[len(branch_behind):])


untracked = 0
changed = 0
deleted = 0
conflict = 0
staged = 0
for f in git_status[1:]:
    index, work = f[0], f[1]
    if index == "?":
        untracked += 1
    if work == "M":
        changed += 1
    if index != "D" and work == "D":
        deleted += 1
    if index == "U" or work == "U" or (index == "A" and work == "A") or (index == "D" and work == "D"):
        conflict += 1
    if index in "MRC" or (index == "D" and work != "D") or (index == "A" and work != "A"):
        staged += 1


# Put it all together
status = "(" + color(15, True) + revision

if ahead:
    status += color(-1) + "↑" + str(ahead)
if behind:
    status += color(-1) + "↓" + str(behind)

if untracked or changed or deleted or conflict or staged:
    status += color(-1) + "|"

if untracked:
    status += color(2) + "+" + str(untracked)
if changed:
    status += color(5) + "~" + str(changed)
if deleted:
    status += color(1) + "-" + str(deleted)
if conflict:
    status += color(3) + "x" + str(conflict)
if staged:
    status += color(4) + "●" + str(staged)

status += color(-1) + ")"


print(status)

