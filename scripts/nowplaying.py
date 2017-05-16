#!/usr/bin/env python3

import json
import socket
import subprocess
import os

def mpv_query():
    try:
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
            client.connect(os.path.join(os.getenv("HOME"), ".mpv/socket"))

            res = {}
            for i in ['media-title', 'pause']:
                req = '{"command": ["get_property", "%s"]}\n' %i
                client.send(req.encode("utf-8"))
                try:
                    res[i] = json.loads(client.recv(1024).decode("utf-8"))['data']
                except KeyError:
                    res[i] = None

        return res['pause'], res['media-title']
    except socket.error:
        return True, None

def mpd_command(client, cmd):
    client.send((cmd + "\n").encode("utf-8"))
    response = client.recv(1024).decode().split("\n")

    res = {}
    for line in response:
        line = line.split(": ")
        res[line[0]] = ": ".join(line[1:])

    return res

def mpd_query():
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.connect(os.path.join(os.getenv("HOME"), ".mpd/socket"))

        # Discard the initial message
        client.recv(1024)

        status = mpd_command(client, "status")

        song = mpd_command(client, "currentsong")

        try:
            title = song["Title"]
        except:
            title = "Null"

        try:
            artist = song["Artist"]
        except:
            artist = "Null"

        client.send("close\n".encode("utf-8"))

        if status["state"] != "play":
            return True, None
        else:
            return False, f"{artist} - {title}"

def copy_title(title):
    title = f"/me np: {title}".encode()
    #subprocess.run(["xsel", "-x"], check=True)
    subprocess.run(["xsel", "-b"], input=title, check=True)
    subprocess.run(["xdotool", "keyup", "--clearmodifiers", "Return"], check=True)
    subprocess.run(["xdotool", "key", "--clearmodifiers", "ctrl+v"], check=True)
    #subprocess.run(["xsel", "-x"], check=True)

def main():
    mpd_pause, mpd_title = mpd_query()
    mpv_pause, mpv_title = mpv_query()
    if not mpd_pause and mpd_title is not None:
        copy_title(mpd_title)
        return
    if mpv_title is not None:
        copy_title(mpv_title)

main()
