import asyncio
import os


class MpdClient:
    def __init__(self):
        self.host = os.getenv("MPD_HOST", "localhost")
        self.port = os.getenv("MPD_PORT", 6600)
        self.queue = None
        self._r = None

    async def _read(self):
        line = await self._r.readline()
        if not line:
            raise ConnectionError
        return line.decode("UTF-8").rstrip("\n")

    async def _read_pairs(self):
        while True:
            line = await self._read()
            if line == "OK":
                return
            yield tuple(line.split(": ", 1))

    async def _read_dict(self):
        return {k.lower(): v async for k, v in self._read_pairs()}

    async def _read_list(self):
        return {v async for k, v in self._read_pairs()}

    def _command(self, cmd, parser):
        if self.queue is None:
            self.queue = asyncio.Queue()
            asyncio.create_task(self._event_loop())

        fut = asyncio.Future()
        self.queue.put_nowait((cmd, fut, parser))
        return fut

    def idle(self, *subsystems):
        subsystems = " ".join(subsystems)
        return self._command(f"idle {subsystems}", self._read_list)

    def status(self):
        return self._command("status", self._read_dict)

    def currentsong(self):
        return self._command("currentsong", self._read_dict)

    async def _event_loop(self):
        while True:
            try:
                if "/" in self.host:
                    self._r, w = await asyncio.open_unix_connection(self.host)
                else:
                    self._r, w = await asyncio.open_connection(
                            self.host, self.port)
                break
            except (ConnectionRefusedError, FileNotFoundError):
                await asyncio.sleep(1)

        # mpd's hello, discard it
        await self._read()

        while True:
            cmd, fut, parser = await self.queue.get()
            try:
                w.write(f"{cmd}\n".encode("UTF-8"))
                fut.set_result(await parser())
            except ConnectionError:
                # Queue that command again and reconnect
                self.queue.put_nowait((cmd, fut, parser))
                asyncio.create_task(self._event_loop())
                return
            finally:
                self.queue.task_done()
