"""Wrap a .lua file as execute_luau args for mcpcli: python cmd/runlua.py fix/pass13.lua <studio_id> -> cmd/<name>.json"""
import json, sys, os
src, sid = sys.argv[1], sys.argv[2]
out = os.path.join("cmd", os.path.splitext(os.path.basename(src))[0] + ".json")
json.dump({"studio_id": sid, "datamodel_type": "Edit", "code": open(src, encoding="utf-8").read()}, open(out, "w", encoding="utf-8"))
print(out)
