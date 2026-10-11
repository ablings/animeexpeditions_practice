"""Pass 13: own leaf textures for the soft foliage kit (painted here, nothing from the reference).
leaf13_sprig.png  256x512: a stem up the middle with ~24 rounded oval leaves, alternate, angled out and up; grey-white
                  leaves (tinted in Studio), transparent background. Mapped on every drooping leaf card (U across, V along).
leaf13_pad.png    512x512: a dense round heap of ~260 small oval leaves with a ragged leafy edge, shaded darker toward the
                  middle and bottom. Mapped on crossed cards (cypress columns) and clump filler cards.
Leaf value 150-255 so a tint keeps two tones inside one card (dark leaf bases, light tips)."""
import math, random, os
from PIL import Image, ImageDraw, ImageFilter

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "leaf13")
os.makedirs(OUT, exist_ok=True)
SS = 2  # supersample


def leaf(dr, cx, cy, ang, L, W, val, edge=0.82):
    """One rounded oval leaf from its base (cx, cy) along ang: a pointed-oval polygon, a darker rim, a light midrib."""
    pts = []
    for i in range(25):
        t = i / 24.0
        w = W * math.sin(math.pi * t) ** 0.8 * (1.0 - 0.25 * t)
        pts.append((t * L, w))
    for i in range(24, -1, -1):
        t = i / 24.0
        w = W * math.sin(math.pi * t) ** 0.8 * (1.0 - 0.25 * t)
        pts.append((t * L, -w))
    ca, sa = math.cos(ang), math.sin(ang)
    P = [(cx + x * ca - y * sa, cy + x * sa + y * ca) for x, y in pts]
    dr.polygon(P, fill=(int(val * edge),) * 3 + (255,))
    Pin = [(cx + (x * 0.92 + L * 0.04) * ca - y * 0.72 * sa, cy + (x * 0.92 + L * 0.04) * sa + y * 0.72 * ca) for x, y in pts]
    dr.polygon(Pin, fill=(val, val, val, 255))
    v2 = min(255, val + 25)
    dr.line([(cx + L * 0.1 * ca, cy + L * 0.1 * sa), (cx + L * 0.8 * ca, cy + L * 0.8 * sa)], fill=(v2, v2, v2, 255), width=max(1, int(W * 0.12)))


def sprig(seed=13, w=256, h=512):
    random.seed(seed)
    im = Image.new("RGBA", (w * SS, h * SS), (0, 0, 0, 0)); dr = ImageDraw.Draw(im)
    W, H = w * SS, h * SS
    # stem: bottom centre to near the top, slight wave
    stem = [(W / 2 + 6 * SS * math.sin(t * 3.0), H - t * H * 0.94) for t in [i / 40 for i in range(41)]]
    dr.line(stem, fill=(120, 120, 120, 255), width=5 * SS)
    n = 24
    for i in range(n):
        t = 0.06 + 0.9 * i / n
        sx, sy = stem[int(t * 40)]
        side = 1 if i % 2 else -1
        L = (0.42 - 0.22 * t) * W * random.uniform(0.85, 1.1)
        Wd = L * random.uniform(0.36, 0.44)
        ang = -math.pi / 2 + side * random.uniform(0.75, 1.15)
        val = int(150 + 100 * t + random.uniform(-12, 12))
        leaf(dr, sx, sy, ang, L, Wd, min(255, val))
    tx, ty = stem[-1]
    leaf(dr, tx, ty + 10 * SS, -math.pi / 2, 0.2 * W, 0.08 * W, 250)
    im = im.resize((w, h), Image.LANCZOS)
    im.save(os.path.join(OUT, "leaf13_sprig.png"))


def pad(seed=17, s=512, n=650):
    random.seed(seed)
    im = Image.new("RGBA", (s * SS, s * SS), (0, 0, 0, 0)); dr = ImageDraw.Draw(im)
    S = s * SS; c = S / 2
    items = []
    for i in range(n):
        r = 0.4 * S * math.sqrt(random.random()); a = random.uniform(0, 2 * math.pi)
        x, y = c + r * math.cos(a), c + r * math.sin(a) * 1.0
        out = math.atan2(y - c, x - c) + random.uniform(-0.9, 0.9) if r > 0.12 * S else random.uniform(0, 2 * math.pi)
        x, y = (x - 0.04 * S * math.cos(out), y - 0.04 * S * math.sin(out)) if r > 0.12 * S else (x, y)
        L = S * random.uniform(0.06, 0.1); Wd = L * random.uniform(0.38, 0.46)
        # lighter toward the top and the rim (sunlit), darker toward the middle and bottom
        top = 1 - y / S; rim = r / (0.4 * S)
        val = int(150 + 55 * top + 50 * rim + random.uniform(-10, 10))
        items.append((rim, x, y, out, L, Wd, min(255, val)))
    items.sort()  # inner (darker) first, rim leaves drawn over them
    for rim, x, y, out, L, Wd, val in items:
        leaf(dr, x, y, out, L, Wd, val)
    im = im.resize((s, s), Image.LANCZOS)
    im.save(os.path.join(OUT, "leaf13_pad.png"))


if __name__ == "__main__":
    sprig(); pad(); print("ok", os.listdir(OUT))
