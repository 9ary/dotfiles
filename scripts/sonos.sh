#!/bin/sh

exec nc -NU /run/user/$UID/sonos_volume <<< $1
