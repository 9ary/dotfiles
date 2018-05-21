#!/bin/sh

echo -n $1 | nc -NU /run/user/$UID/sonos_volume

