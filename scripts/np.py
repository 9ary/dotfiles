#!/usr/bin/env python3

import json
import socket
import subprocess

def mpv():
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.connect("/tmp/mpvsocket")

        res = {}
        for i in ['filename', 'media-title', 'playback-time', 'length']:
            req = '{"command": ["get_property", "%s"]}\n' %i
            client.send(req.encode("utf-8"))
            res[i] = json.loads(client.recv(1024).decode("utf-8"))['data']

        return res['media-title']

def mpd_command(client, cmd):
    client.send((cmd + "\n").encode("utf-8"))
    response = client.recv(1024).decode().split("\n")

    res = {}
    for line in response:
        line = line.split(": ")
        res[line[0]] = ": ".join(line[1:])

    return res

def mpd():
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.connect("/home/streetwalrus/.mpd/socket")

        # Discard the initial message
        client.recv(1024)

        status = mpd_command(client, "status")
        if status["state"] != "play":
            return ""

        song = mpd_command(client, "currentsong")

        try:
            title = song["Title"]
        except:
            title = "Null"

        try:
            artist = song["Artist"]
        except:
            artist = "Null"

        return "{} - {}".format(artist, title)

try:
    title = mpv()
except socket.error:
    title = mpd()

if title != "":
    subprocess.call(["xdotool", "type", "/me np: " + title])
