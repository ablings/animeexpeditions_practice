"""skystat.py <img>...: in the top 40% find sky-like pixels (b>=200, b>=r, b>=g-5); report fraction, share that is 'clear blue' (S>120), mean RGB of clear, of cloud."""
import sys, numpy as np
from PIL import Image
for f in sys.argv[1:]:
    im = Image.open(f).convert("RGB"); a = np.asarray(im).astype(int)[: int(im.height * .4)]
    h = np.asarray(im.convert("HSV")).astype(int)[: int(im.height * .4)]
    r, g, b = a[..., 0], a[..., 1], a[..., 2]; s = h[..., 1]
    sky = (b >= 200) & (b >= r) & (b >= g - 5)
    cl = sky & (s > 120); cw = sky & (s <= 60)
    mc = a[cl].mean(0).astype(int) if cl.any() else None; mw = a[cw].mean(0).astype(int) if cw.any() else None
    print(f"{f[-28:]:28s} sky {sky.mean()*100:5.1f}%  clear {cl.sum()/max(sky.sum(),1)*100:5.1f}% {mc}  white {cw.sum()/max(sky.sum(),1)*100:5.1f}% {mw}  satSky {s[sky].mean():5.1f}")
