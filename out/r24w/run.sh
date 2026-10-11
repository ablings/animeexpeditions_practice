#!/bin/sh
cd /c/Users/Shadow/Documents/animeexp_practice
python cmd/runlua.py fix/pass24.lua 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885 >/dev/null && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau cmd/pass24.json 2>&1 | tail -3
