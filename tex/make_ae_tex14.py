"""Pass 14: finer own leaf textures (painted here, nothing from the reference). Answers verify11 item 1: the pass-13 cards
carried one big leaf shape each and read as crumpled paper; the reference reads as high-frequency speckle of 0.3-0.5 stud
leaves with a dark core and bright tips and no specular.

leaf14_spray_<fam>.png  256x512: a branching twig spray carrying ~26 small rounded leaves, each ~0.18 of the card length
                        (a 2-stud card -> 0.35-stud leaves). Mapped on the drooping cards (U across, V base->tip).
leaf14_pad_<fam>.png    1024x1024: a round heap of ~2600 small leaves (~1/32 of the width: on a 10-14 stud filler card
                        that is 0.3-0.45 studs) with a ragged edge.
The colour gradient is BAKED in (dark core -> bright tips, per family) so the SurfaceAppearance Color stays white:
  blue (10,40,150)->(60,150,255), gold (170,120,30)->(250,210,90), purple (110,70,170)->(200,160,245)
and a grey version (value 0.45 -> 1.0) for the tinted families (green, teal, red).
leaf14_rough.png 64x64 white (roughness 1) and leaf14_metal.png 64x64 black (metalness 0): no glint."""
import math, random, os
from PIL import Image, ImageDraw

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "leaf14")
os.makedirs(OUT, exist_ok=True)
SS = 2  # supersample

FAMS = {
    "blue": ((10, 40, 150), (60, 150, 255)),
    "gold": ((170, 120, 30), (250, 210, 90)),
    "purple": ((110, 70, 170), (200, 160, 245)),
    "grey": ((115, 115, 115), (255, 255, 255)),
}


def col(fam, t, shade=1.0):
    """t 0 = core colour, 1 = tip colour; shade darkens a leaf's rim."""
    a, b = FAMS[fam]; t = max(0.0, min(1.0, t))
    return tuple(int(min(255, (a[i] + (b[i] - a[i]) * t) * shade)) for i in range(3)) + (255,)


def leaf(dr, cx, cy, ang, L, W, fam, t):
    """One small rounded leaf from its base: a pointed oval, a slightly darker rim (0.8) and a lighter fill. No midrib
    (at 0.3-0.5 studs a vein only reads as noise)."""
    pts = []
    for i in range(13):
        s = i / 12.0; w = W * math.sin(math.pi * s) ** 0.75 * (1.0 - 0.2 * s); pts.append((s * L, w))
    for i in range(12, -1, -1):
        s = i / 12.0; w = W * math.sin(math.pi * s) ** 0.75 * (1.0 - 0.2 * s); pts.append((s * L, -w))
    ca, sa = math.cos(ang), math.sin(ang)
    P = [(cx + x * ca - y * sa, cy + x * sa + y * ca) for x, y in pts]
    dr.polygon(P, fill=col(fam, t - 0.12, 0.85))
    Pin = [(cx + (x * 0.9 + L * 0.06) * ca - y * 0.65 * sa, cy + (x * 0.9 + L * 0.06) * sa + y * 0.65 * ca) for x, y in pts]
    dr.polygon(Pin, fill=col(fam, t + 0.08))


def spray(fam, seed=14, w=256, h=512):
    """A twig from the bottom centre fanning into 5 side twigs that reach the card edges; ~26 small leaves along them
    (pointing out along the twig +-0.6 rad), crowded and brighter toward the tip, with gaps between, so the card outline
    is a ragged leafy spray instead of one leaf."""
    random.seed(seed)
    W, H = w * SS, h * SS
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0)); dr = ImageDraw.Draw(im)
    base = (W / 2, H * 0.99); tip = (W / 2 + random.uniform(-0.05, 0.05) * W, H * 0.06)
    main = [(base[0] + (tip[0] - base[0]) * t + 0.04 * W * math.sin(t * 5), base[1] + (tip[1] - base[1]) * t) for t in [i / 30 for i in range(31)]]
    twigs = [(main, 0.0)]
    for k, t0 in enumerate((0.12, 0.26, 0.4, 0.54, 0.68)):
        sx, sy = main[int(t0 * 30)]; side = 1 if k % 2 else -1
        ex = W / 2 + side * random.uniform(0.2, 0.26) * W; ey = sy - random.uniform(0.12, 0.2) * H
        twigs.append(([(sx + (ex - sx) * s, sy + (ey - sy) * s - 0.03 * H * math.sin(s * math.pi)) for s in [i / 10 for i in range(11)]], t0))
    for pts, t0 in twigs:
        dr.line(pts, fill=col(fam, 0.0, 0.6), width=max(2, int(1.5 * SS)))
    items = []
    for ti, (pts, t0) in enumerate(twigs):
        n = 10 if ti == 0 else 5
        for i in range(n):
            s = (0.1 if ti == 0 else 0.3) + (0.9 if ti == 0 else 0.7) * i / max(1, n - 1)
            j = min(len(pts) - 2, int(s * (len(pts) - 1)))
            x, y = pts[j]; dx, dy = pts[j + 1][0] - x, pts[j + 1][1] - y
            ang = math.atan2(dy, dx) + random.choice((-1, 1)) * random.uniform(0.35, 0.8)
            tt = (t0 + (1 - t0) * s) if ti == 0 else min(1.0, t0 + 0.25 + 0.45 * s)
            L = H * random.uniform(0.11, 0.14)
            items.append((tt, x, y, ang, L, L * random.uniform(0.4, 0.48)))
    items.sort()  # base (dark) leaves first, tips over them
    for tt, x, y, ang, L, Wd in items:
        leaf(dr, x, y, ang, L, Wd, fam, tt + random.uniform(-0.1, 0.1))
    im = im.resize((w, h), Image.LANCZOS)
    im.save(os.path.join(OUT, f"leaf14_spray_{fam}.png")); return len(items)


def pad(fam, seed=17, s=1024, n=2600):
    random.seed(seed)
    S = s * SS; c = S / 2
    im = Image.new("RGBA", (S, S), (0, 0, 0, 0)); dr = ImageDraw.Draw(im)
    items = []
    for i in range(n):
        r = 0.42 * S * math.sqrt(random.random()); a = random.uniform(0, 2 * math.pi)
        x, y = c + r * math.cos(a), c + r * math.sin(a)
        out = math.atan2(y - c, x - c) + random.uniform(-1.0, 1.0)
        L = S * random.uniform(0.026, 0.036); Wd = L * random.uniform(0.42, 0.5)
        top = 1 - y / S; rim = r / (0.42 * S)
        t = 0.15 + 0.45 * rim ** 1.5 + 0.35 * top + random.uniform(-0.12, 0.12)  # dark core, bright rim and top
        items.append((rim, x, y, out, L, Wd, t))
    items.sort()
    for rim, x, y, out, L, Wd, t in items:
        leaf(dr, x, y, out, L, Wd, fam, t)
    im = im.resize((s, s), Image.LANCZOS)
    im.save(os.path.join(OUT, f"leaf14_pad_{fam}.png")); return n


if __name__ == "__main__":
    for f in FAMS:
        print(f, spray(f), pad(f))
    Image.new("RGBA", (64, 64), (255, 255, 255, 255)).save(os.path.join(OUT, "leaf14_rough.png"))
    Image.new("RGBA", (64, 64), (0, 0, 0, 255)).save(os.path.join(OUT, "leaf14_metal.png"))
    # preview on green
    prev = Image.new("RGBA", (1024 + 4 * 256, 1024), (60, 110, 60, 255))
    for k, f in enumerate(("blue", "gold", "purple", "grey")):
        sp = Image.open(os.path.join(OUT, f"leaf14_spray_{f}.png")); prev.alpha_composite(sp, (1024 + k * 256, 0))
    pb = Image.open(os.path.join(OUT, "leaf14_pad_blue.png")); prev.alpha_composite(pb, (0, 0))
    prev.convert("RGB").save(os.path.join(os.path.dirname(OUT), "..", "out", "r14w", "tex14_preview.png"))
    print(os.listdir(OUT))
