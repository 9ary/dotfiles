#!/usr/bin/env python3

from urllib import parse
import os, subprocess
from subprocess import DEVNULL
import http.server, socketserver

import ytdl_config as config

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed_params = parse.urlparse(self.path)
        parsed_query = parse.parse_qs(parsed_params.query)
        video_url = parsed_query['i'][0]

        command = list(map(str, config.PLAYER.split(' ')))
        command.append(video_url)

        player = subprocess.Popen(command, stdout=DEVNULL, stderr=DEVNULL)

        self.send_response(204)

        player.wait()

    def log_message(self, format, *args):
        # Disable debug output
        return

class ThreadedHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    # This class allows to handle requests in separated threads.
    pass

httpd = ThreadedHTTPServer((config.HOST, config.PORT), MyHandler)
httpd.serve_forever()
