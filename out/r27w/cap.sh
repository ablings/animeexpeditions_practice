#!/bin/sh
# cap.sh <cam> <tag>: two practice captures -> out/r27w/<tag>(_a).png, v24 boxes + metrics on the second
cd /c/Users/aroki/Documents/animeexp_practice
J=$(python -c "import json,sys;c=json.load(open('cams_practice.json'))['$1'];print(json.dumps({'camera_position':c[0],'look_at_position':c[1]})[1:-1])")
for i in 1 2; do PYTHONIOENCODING=utf-8 python mcpcli.py call screen_capture "{\"studio_id\":\"93d2d4f5-c7e7-40ed-bb6f-cd6824f11572\",\"capture_id\":\"$2_$i\",$J}" >/dev/null 2>&1; done
cp out/$2_1_1.png out/r27w/$2_a.png; cp out/$2_2_1.png out/r27w/$2.png; rm -f out/$2_1_1.png out/$2_2_1.png
python out/r27w/norm.py out/r27w/$2.png out/r27w/$2_a.png >/dev/null; python out/r27w/box27.py $1 out/r27w/$2.png 2>/dev/null
true
