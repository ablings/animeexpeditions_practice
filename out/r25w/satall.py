"""satall.py <tag>: top-half saturation of out/r25w/<tag>_<cam>.png for all 12 cams vs v22 ref; prints mean |rep-ref| and mean signed."""
import sys, numpy as np
from PIL import Image
C = ['p1_spawn_n','p2_spawn_s','p3_spawn_e','p4_spawn_w','p5_diag_ne','p6_diag_sw','p7_high','p8_top','c1_wall','c2_fountain','c3_pavilion','c4_stairs']
def sat(f): im = Image.open(f); return np.asarray(im.convert("HSV"))[: im.height // 2, :, 1].mean()
for tag in sys.argv[1:]:
    d = []; s = ""
    for c in C:
        r = sat(f"out/verify22/v22_{c}_ref.jpg"); p = sat(f"out/r25w/{tag}_{c}.png"); d.append(p - r); s += f" {c[:2]} {p:5.1f}/{r:5.1f}"
    print(f"{tag}: mean|d| {np.mean(np.abs(d)):5.1f}  mean d {np.mean(d):+5.1f}  rep avg {np.mean([x for x in d]):+.1f}\n  {s}")
