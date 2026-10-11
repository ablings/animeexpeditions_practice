#!/bin/sh
# refcap.sh <tag> cx,cy,cz lx,ly,lz : screen_capture ONLY of the live reference studio -> out/r21w/ref_<tag>.png
cd /c/Users/Shadow/Documents/animeexp_practice
PYTHONIOENCODING=utf-8 python mcpcli.py call screen_capture "{\"studio_id\":\"1c7bc18a-1703-489c-bdcf-e4ced52e2a1b\",\"capture_id\":\"rf_$1\",\"camera_position\":[$2],\"look_at_position\":[$3]}" >/dev/null 2>&1
PYTHONIOENCODING=utf-8 python mcpcli.py call screen_capture "{\"studio_id\":\"1c7bc18a-1703-489c-bdcf-e4ced52e2a1b\",\"capture_id\":\"rf_$1\",\"camera_position\":[$2],\"look_at_position\":[$3]}" >/dev/null 2>&1
mv out/rf_$1_1.png out/r21w/ref_$1.png; ls out/rf_$1* 2>/dev/null; rm -f out/rf_$1*
