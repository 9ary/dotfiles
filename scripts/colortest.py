#!/usr/bin/env python3

import itertools

def stripes(iterable):
    ret = "".join(f"\x1b[48;5;{i}m   \x1b[0m" for i in iterable)
    return f"{ret}\n{ret}"

standard_colors = itertools.chain(range(8), (16, 17))
bright_colors = itertools.chain(range(8, 16), (18, 19))

print(stripes(standard_colors))
print(stripes(bright_colors))
