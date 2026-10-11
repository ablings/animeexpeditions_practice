#!/bin/sh
# lrun.sh <file.lua>: run a lua file in the practice studio
cd /c/Users/Shadow/Documents/animeexp_practice
f=$(python cmd/runlua.py $1 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885) && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau $f 2>&1 | tail -${2:-60}
