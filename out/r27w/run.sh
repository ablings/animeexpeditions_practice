#!/bin/sh
cd /c/Users/aroki/Documents/animeexp_practice
python cmd/runlua.py fix/pass27.lua 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 >/dev/null && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau cmd/pass27.json 2>&1 | tail -3
