#!/bin/bash

card=Live
control=Master

volume=$(amixer -c "$card" sget "$control" | awk '/Front Left:/{ print $4 }')

[[ $1 == "down" ]] && let volume--
[[ $1 == "up"   ]] && let volume++
[[ $1 == "mute" ]] && amixer -q -c "$card" sset "$control" toggle

amixer -q -c "$card" sset "$control" $volume
