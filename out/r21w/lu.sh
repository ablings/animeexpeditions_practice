#!/bin/sh
# lu.sh <file.lua>: run a Luau file in the practice studio and print the result
cd /c/Users/Shadow/Documents/animeexp_practice
J=$(python cmd/runlua.py "$1" 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885)
PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau "$J"
