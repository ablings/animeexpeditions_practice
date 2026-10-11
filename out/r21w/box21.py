"""python out/r21w/box21.py <cam> <png>... : 5x5 means at the round-18 review boxes (verify18_plaza.md). Each entry is
(measure xy, target xy); the target is re-sampled from out/verify18/v18_<cam>_ref.jpg on every run (never typed)."""
import sys
from PIL import Image
B = {
 "c1_wall": {"notch": ((720, 290),)*2, "slate": ((408, 351), (471, 351)), "pale": ((556, 330), (556, 351)),
             "ledge": ((560, 442),)*2, "tunnel": ((900, 420), (880, 470)), "splatL": ((400, 690), (340, 670)),
             "splatR": ((1100, 700), (1120, 630))},
 "c4_stairs": {"riser": ((245, 655), (430, 655)), "tread": ((245, 730), (400, 690)), "runner": ((640, 700), (660, 700)),
               "pine": ((200, 400), (190, 410))},
 "c2_fountain": {"grass": ((930, 590),)*2, "basin": ((510, 430), (520, 465))},
 "c3_pavilion": {"haze": ((1350, 280),)*2},
 "p1_spawn_n": {"bolHead": ((440, 485), (440, 500)), "landing": ((720, 460), (720, 450)), "paving": ((1000, 720),)*2},
 "p2_spawn_s": {"lawn": ((560, 378),)*2, "sky": ((820, 100),)*2},
 "p3_spawn_e": {"door": ((690, 330), (695, 300)), "haze": ((620, 200),)*2},
 "p4_spawn_w": {"portal": ((720, 330),)*2},
 "p5_diag_ne": {"rim": ((150, 500),)*2, "runner": ((150, 410),)*2},
 "p7_high": {"basin": ((380, 540), (920, 470))},
 "p8_top": {"red": ((1100, 300), (1250, 300)), "greenhole": ((1000, 200), (990, 300))},
}
def m(im, x, y):
    px = [im.getpixel((x + i, y + j)) for i in range(-2, 3) for j in range(-2, 3)]
    return tuple(round(sum(p[k] for p in px) / 25) for k in range(3))
cam = sys.argv[1]; Bx = B.get(cam, {})
ref = Image.open(f"out/verify18/v18_{cam}_ref.jpg").convert("RGB")
files = sys.argv[2:]
ims = [Image.open(f).convert("RGB") for f in files]
print("box        target          " + "  ".join(f[-18:] for f in files))
for k, (mx, tx) in Bx.items():
    T = m(ref, *tx); row = f"{k:10s} {str(T):15s}"
    for im in ims:
        v = m(im, *mx); d = max(abs(a - b) for a, b in zip(v, T)); row += f"  {str(v):15s}{d:4d}"
    print(row)
