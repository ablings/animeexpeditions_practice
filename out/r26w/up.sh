#!/bin/sh
# up.sh <variant>: upload tex/sky/ae_sky26<v>_*.png (3 per call) and print the id map
cd /c/Users/Shadow/Documents/animeexp_practice
for g in "up ft bk" "lf rt dn"; do
  L=""; for k in $g; do L="$L\"http://127.0.0.1:8767/tex/sky/ae_sky26$1_$k.png\","; done
  PYTHONIOENCODING=utf-8 timeout 300 python mcpcli.py call upload_image "{\"studio_id\":\"8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885\",\"imagePaths\":[${L%,}]}" 2>&1 | tail -3
done
