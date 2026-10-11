"""python out/r23w/box23.py <cam> <png>... : 5x5 means at the round-20 review boxes (verify20_plaza.md). Each entry is
(measure xy, target xy) as box centres; the target is re-sampled from out/verify20/v20_<cam>_ref.jpg on every run."""
import sys
from PIL import Image
B = {
 "p1_spawn_n": {"fall": ((737, 115), (753, 140)), "mist": ((620, 30),)*2, "bolHead": ((447, 490), (440, 500)), "bolBase": ((447, 530), (440, 575))},
 "p2_spawn_s": {"lawn": ((600, 378), (560, 378))},
 "p3_spawn_e": {"skull": ((722, 40),)*2, "haze": ((620, 180), (600, 220))},
 "p4_spawn_w": {"trunk": ((700, 170), (700, 150))},
 "p5_diag_ne": {"rim": ((285, 480), (262, 500)), "runner": ((80, 470), (150, 410))},
 "p6_diag_sw": {"door": ((110, 300), (130, 320))},
 "p7_high": {"lawnS": ((900, 620),)*2},
 "p8_top": {"lawnE": ((982, 384), (990, 300))},
 "c1_wall": {"pods": ((690, 262), (688, 262)), "tunnel": ((900, 430), (880, 470)), "pale": ((556, 330), (556, 351))},
 "c2_fountain": {"fern": ((880, 290), (930, 590))},
 "c3_pavilion": {"raid": ((1350, 280),)*2},
 "c4_stairs": {"tread": ((400, 690),)*2, "riser": ((430, 655),)*2, "runner": ((660, 700),)*2, "pine": ((200, 420), (190, 410))},
}
def m(im, x, y):
    px = [im.getpixel((x + i, y + j)) for i in range(-2, 3) for j in range(-2, 3)]
    return tuple(round(sum(p[k] for p in px) / 25) for k in range(3))
cam = sys.argv[1]; Bx = B.get(cam, {})
ref = Image.open(f"out/verify20/v20_{cam}_ref.jpg").convert("RGB")
files = sys.argv[2:]
ims = [Image.open(f).convert("RGB") for f in files]
print("box        target          " + "  ".join(f[-18:] for f in files))
for k, (mx, tx) in Bx.items():
    T = m(ref, *tx); row = f"{k:10s} {str(T):15s}"
    for im in ims:
        v = m(im, *mx); d = max(abs(a - b) for a, b in zip(v, T)); row += f"  {str(v):15s}{d:4d}"
    print(row)
