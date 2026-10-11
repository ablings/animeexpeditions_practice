#!/bin/sh
cd /c/Users/Shadow/Documents/animeexp_practice
python cmd/runlua.py fix/pass23.lua 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885 >/dev/null && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau cmd/pass23.json | tail -3
