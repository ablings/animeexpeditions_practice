#!/bin/sh
# all.sh <tag>: capture all 12 cams (second frame) to out/r25w/<tag>_<cam>.png and print the saturation summary
cd /c/Users/Shadow/Documents/animeexp_practice
for c in p1_spawn_n p2_spawn_s p3_spawn_e p4_spawn_w p5_diag_ne p6_diag_sw p7_high p8_top c1_wall c2_fountain c3_pavilion c4_stairs; do sh out/r25w/cap.sh $c $1_$c >/dev/null; done
python out/r25w/satall.py $1
