"""satbreak.py img...: top-half saturation contribution (sum S / Npix) per hue class."""
import sys, numpy as np
from PIL import Image
K = {"red": lambda h: (h <= 12) | (h >= 240), "gold": lambda h: (h > 12) & (h < 43), "green": lambda h: (h >= 43) & (h < 110),
     "cyan": lambda h: (h >= 110) & (h < 140), "blue": lambda h: (h >= 140) & (h < 175), "purple": lambda h: (h >= 175) & (h < 240)}
for f in sys.argv[1:]:
    im = Image.open(f).convert("RGB"); a = np.asarray(im.convert("HSV")).astype(float)[: im.height // 2]
    h, s = a[..., 0], a[..., 1]; n = h.size
    print(f"{f[-26:]:26s} tot {s.mean():5.1f} " + " ".join(f"{k} {s[fn(h)].sum()/n:5.1f}" for k, fn in K.items()))
