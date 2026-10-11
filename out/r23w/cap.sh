#!/bin/sh
# cap.sh <cam> <tag>: two practice captures -> out/r23w/<tag>(_a).png, v20 boxes + metrics on the second
cd /c/Users/Shadow/Documents/animeexp_practice
J=$(python -c "import json,sys;c=json.load(open('cams_practice.json'))['$1'];print(json.dumps({'camera_position':c[0],'look_at_position':c[1]})[1:-1])")
for i in 1 2; do PYTHONIOENCODING=utf-8 python mcpcli.py call screen_capture "{\"studio_id\":\"8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885\",\"capture_id\":\"$2_$i\",$J}" >/dev/null 2>&1; done
cp out/$2_1_1.png out/r23w/$2_a.png; cp out/$2_2_1.png out/r23w/$2.png; rm -f out/$2_1_1.png out/$2_2_1.png
python out/r23w/box23.py $1 out/r23w/$2.png 2>/dev/null
python out/r22w/metrics22.py $1 out/r23w/$2.png
true
