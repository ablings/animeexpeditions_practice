"""box27.py <cam> <png>...: 5x5 means at the round-24 review boxes (notes/verify24_plaza.md), given as (measure centre, target centre).
Targets are re-sampled from out/verify24/v24_<cam>_ref.jpg on every run. Also top-half saturation + coverage metrics (round-23 thresholds)."""
import sys, numpy as np
from PIL import Image
B = {
 "p1_spawn_n": {"island": ((620, 30),)*2, "bolHead": ((449, 497), (440, 500))},
 "p2_spawn_s": {"sky": ((762, 22),)*2, "crown": ((594, 60),)*2, "panel": ((642, 302), (658, 300))},
 "p3_spawn_e": {"glow": ((642, 172), (600, 220))},
 "p4_spawn_w": {"ring": ((685, 347), (676, 297))},
 "p5_diag_ne": {"Ygold": ((152, 502),)*2, "Ycore": ((172, 502), (202, 502))},
 "p7_high": {"lawnS": ((900, 620),)*2},
 "c1_wall": {"blueLit": ((294, 615), (347, 647)), "blueSh": ((324, 635), (347, 647)), "red": ((1104, 605), (1157, 632))},
 "c2_fountain": {"fern": ((872, 557), (930, 590))},
 "c3_pavilion": {"island": ((42, 62), (152, 102)), "raid": ((1362, 272), (1350, 280))},
 "c4_stairs": {"riser": ((402, 507), (430, 648)), "tread": ((400, 690),)*2, "rimGold": ((462, 710), (541, 677)), "canopy": ((612, 42), (702, 62))},
}
XO = 84  # main PC frames are 1284 wide (1452 on the Shadow PC): same vertical FOV, 84 px cropped each side
def m(im, x, y):
    x -= XO
    a = np.asarray(im)[y - 2:y + 3, x - 2:x + 3].reshape(-1, 3).mean(0); return tuple(int(round(v)) for v in a)
def sat(im): return np.asarray(im.convert("HSV"))[: im.height // 2, :, 1].mean()
def blue(a): r, g, b = a[..., 0], a[..., 1], a[..., 2]; return ((b > r + 40) & (b > g + 20) & (b > 120)).mean() * 100
def hcov(im, box, kind, smin=60):
    box = (max(0, box[0] - XO), box[1], min(im.width, box[2] - XO), box[3])
    a = np.asarray(im.convert("HSV")).astype(int)[box[1]:box[3], box[0]:box[2]]; h, s = a[..., 0], a[..., 1]
    mm = ((h >= 43) & (h <= 102)) if kind == "g" else ((h <= 13) | (h >= 242)); return (mm & (s > smin)).mean() * 100
WB = {"p8_top": (0, 150, 420, 650), "p7_high": (0, 100, 450, 700)}
EB = {"p8_top": (1000, 100, 1452, 700), "p7_high": (1000, 100, 1452, 700)}
def metr(im, cam):
    s = f"sat {sat(im):5.1f}"
    if cam in WB: b = (max(0, WB[cam][0] - XO), WB[cam][1], WB[cam][2] - XO, WB[cam][3]); s += f" Wblue {blue(np.asarray(im).astype(int)[b[1]:b[3], b[0]:b[2]]):4.1f}"
    if cam in EB: s += f" Egreen {hcov(im, EB[cam], 'g'):4.1f} Ered {hcov(im, EB[cam], 'r'):4.1f}"
    if cam == "c2_fountain": s += f" stairGreen {hcov(im, (800, 400, 1452, 793), 'g'):4.1f}"
    return s
if __name__ == "__main__":
    cam = sys.argv[1]; Bx = B.get(cam, {})
    ref = Image.open(f"out/verify24/v24_{cam}_ref.jpg").convert("RGB")
    ims = [Image.open(f).convert("RGB") for f in sys.argv[2:]]
    for k, (mx, tx) in Bx.items():
        T = m(ref, *tx); row = f"{k:9s} {str(T):15s}"
        for im in ims:
            v = m(im, *mx); d = max(abs(a - b) for a, b in zip(v, T)); row += f"  {str(v):15s}{d:4d}"
        print(row)
    print("ref     ", metr(ref, cam))
    for f, im in zip(sys.argv[2:], ims): print(f"{f[-24:]:24s}", metr(im, cam))
