#!/bin/sh
# usage: tools/set_chunk.sh "<chunk name>"   (export copy only)
cd /c/Users/aroki/Documents/animeexp_practice
python - "$1" <<'PY'
import json,sys
code=open('tools/chunk.lua',encoding='utf-8').read().replace('__CHUNK__',sys.argv[1])
json.dump({'studio_id':open('cmd/export_id.txt').read().strip(),'datamodel_type':'Edit','code':code},open('cmd/chunk.json','w'))
PY
PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau cmd/chunk.json > /dev/null && echo "chunk set: $1"
