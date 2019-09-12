#!/usr/bin/env python3

try:
    import weechat
except ModuleNotFoundError:
    weechat = None
import json
import socket
import subprocess
import os

def mpv_query():
    try:
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
            client.connect(os.path.join(os.getenv("HOME"), ".mpv/socket"))

            res = {}
            for prop in ("media-title", "pause"):
                req = {"command": ["get_property", prop]}
                client.send(f"{json.dumps(req)}\n".encode())
                res[prop] = json.loads(client.recv(1024).decode()).get("data")

        return not res["pause"], res["media-title"]
    except socket.error:
        return False, None

def mpd_command(client, cmd):
    client.send(f"{cmd}\n".encode())
    response = client.recv(1024).decode().split("\n")

    def pairs(lines):
        for line in lines:
            if line == "OK":
                return
            yield line.split(": ", 1)

    return {k: v for k, v in pairs(response)}

def mpd_query():
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.connect(os.path.join(os.getenv("HOME"), ".mpd/socket"))
        client.recv(1024) # Discard the initial message

        song = mpd_command(client, "currentsong")
        title = song.get("Title")
        artist = song.get("Artist")
        status = mpd_command(client, "status")

        client.send("close\n".encode())

        return status["state"] == "play", f"{artist} - {title}"

def get_title():
    for playing, title in (mpd_query(), mpv_query()):
        if playing and title is not None:
            break
    if title is not None:
        return f"/me np: {title}"

def copy_title():
    title = get_title()
    if title is not None:
        subprocess.run(["xsel", "-b"], input=title.encode(), check=True)

def weechat_np(data, buffer, args):
    title = get_title()
    if title is not None:
        weechat.command(buffer, title)
    return weechat.WEECHAT_RC_OK

if weechat is not None:
    weechat.register(
        "nowplaying",
        "Streetwalrus",
        "0.1",
        "The game",
        "Now playing",
        "",
        ""
    )
    weechat.hook_command(
        "np",
        "Now playing",
        "",
        "",
        "",
        "weechat_np",
        ""
    )
elif __name__ == "__main__":
    copy_title()
