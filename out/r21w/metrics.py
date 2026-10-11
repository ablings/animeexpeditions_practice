"""metrics.py <cam> <png>: top-half mean HSV saturation, and blue cover in the review rectangles (p7/p8)."""
import sys, numpy as np
from PIL import Image
def sat(im):
    a = np.asarray(im.convert("HSV"))[: im.height // 2, :, 1]; return a.mean()
def blue(im, box, rule):
    a = np.asarray(im.convert("RGB")).astype(int)[box[1]:box[3], box[0]:box[2]]
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    m = (b > r + rule[0]) & (b > g + rule[1]) & (b > rule[2])
    return m.mean() * 100
RECT = {"p8_top": (0, 150, 420, 650), "p7_high": (0, 100, 450, 700)}
if __name__ == "__main__":
    cam = sys.argv[1]
    for f in sys.argv[2:]:
        im = Image.open(f); s = f"{f[-28:]:28s} sat {sat(im):5.1f}"
        if cam in RECT:
            s += "  blue " + " ".join(f"{blue(im, RECT[cam], r):4.1f}" for r in [(40, 20, 120), (60, 30, 120), (80, 40, 140)])
        print(s)
