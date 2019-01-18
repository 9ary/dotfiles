#!/usr/bin/env python3

block = chr(0x2588) * 3


def color_range(start, bold=False, prefix=""):
    bold = ";1" if bold else ""
    line = "".join(
        f"[{prefix}{i}{bold}m{block}" for i in range(start, start + 8))
    return f"{line}[0m"


print("Normal")
print(color_range(30))

print("Intense")
print(color_range(90))

print("256")
print(color_range(0, prefix="38;5;"))

print("Normal bold")
print(color_range(30, True))

print("Intense bold")
print(color_range(90, True))

print("256 bold")
print(color_range(0, True, prefix="38;5;"))

