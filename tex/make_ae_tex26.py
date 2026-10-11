"""Pass 26 own skybox (no reference images): tex/sky/ae_sky26<v>_{up,dn,ft,bk,lf,rt}.png.
Brief 26 item 1: our pass-12 sky rendered cyan (60,196,240) at p2 box 760-764/20-24 where the reference reads pale hazy
blue with cloud (172,215,236). Player cameras look near-horizontal, so the top half of every frame shows elevations 0-35 deg:
that is where the pass-12 ramp had already reached its cyan MID. Here the pale haze climbs to ~20 deg, the clear sky
turns azure (less green) higher up, and the cloud deck is densest at 3-40 deg with whiter cores.
Same direction-based method and face table as tex/make_ae_tex12.py (seamless faces; layout measured in pass 12).
Usage: python tex/make_ae_tex26.py <variant letter>  (parameters per variant below; fitted by capture, see notes/fix26_plaza.md)"""
import numpy as np, os, sys
from PIL import Image
OUT = os.path.dirname(os.path.abspath(__file__)); N = 512
V = sys.argv[1] if len(sys.argv) > 1 else "a"
P = {   # HOR (0 deg), HAZE (HZE deg), MID (35 deg), TOP (80 deg), cloud threshold low/high elevation, cloud colours
 "a": dict(HOR=(0.88, 0.92, 0.95), HAZE=(0.72, 0.85, 0.95), HZE=16, MID=(0.42, 0.69, 0.94), TOP=(0.24, 0.55, 0.93),
           THL=0.40, THH=0.47, CLW=(1.0, 1.0, 1.0), CLS=(0.86, 0.90, 0.95), CLEL=48),
}
for k in "bcdefgh":
    P.setdefault(k, dict(P["a"]))
P["b"].update(HOR=(0.90, 0.93, 0.95), HAZE=(0.78, 0.88, 0.95), HZE=20, MID=(0.50, 0.74, 0.94), THL=0.37, THH=0.45)
P["c"].update(HOR=(0.92, 0.94, 0.95), HAZE=(0.82, 0.90, 0.95), HZE=24, MID=(0.56, 0.77, 0.94), THL=0.35, THH=0.44)
P["d"].update(HOR=(0.86, 0.91, 0.95), HAZE=(0.64, 0.80, 0.95), HZE=10, MID=(0.38, 0.62, 0.95), TOP=(0.24, 0.50, 0.94), THL=0.41, THH=0.47)
p = {k: (np.array(v) if isinstance(v, tuple) else v) for k, v in P[V].items()}

d0, d1, U = np.array([1., 0, 0]), np.array([0., 0, 1]), np.array([0., 1, 0])
SIDES = {"lf": (d0, d1), "bk": (d1, -d0), "rt": (-d0, -d1), "ft": (-d1, d0)}   # centre, right (pass-12 measured layout)
rng = np.random.default_rng(26); G = 32
LAT = rng.random((G, G, G)).astype(np.float32)

def vnoise(q):
    i = np.floor(q).astype(int); f = q - i; f = f * f * (3 - 2 * f); out = 0
    for dx in (0, 1):
        for dy in (0, 1):
            for dz in (0, 1):
                w = (f[..., 0] if dx else 1 - f[..., 0]) * (f[..., 1] if dy else 1 - f[..., 1]) * (f[..., 2] if dz else 1 - f[..., 2])
                out = out + w * LAT[(i[..., 0] + dx) % G, (i[..., 1] + dy) % G, (i[..., 2] + dz) % G]
    return out

def fbm(q, oct=5):
    a, t, s = 1.0, 0.0, 0.0
    for k in range(oct):
        s = s + a * vnoise(q * (2 ** k) + k * 7.3); t += a; a *= 0.5
    return s / t

def lerp(a, b, t): return a * (1 - t) + b * t

def shade(dirs):
    d = dirs / np.linalg.norm(dirs, axis=-1, keepdims=True)
    e = np.degrees(np.arcsin(np.clip(d[..., 1], -1, 1)))
    hz = p["HZE"]
    t1 = np.clip(e / hz, 0, 1)[..., None]; t2 = np.clip((e - hz) / (35 - hz), 0, 1)[..., None]; t3 = np.clip((e - 35) / 45, 0, 1)[..., None]
    base = lerp(lerp(lerp(p["HOR"], p["HAZE"], t1 ** 1.3), p["MID"], t2), p["TOP"], t3)
    q = d / np.maximum(d[..., 1:2], 0.08) * np.array([1, 0, 1]) * 0.9 + d * 2.2
    c = fbm(q * 0.75 + 3.1, 4)
    th = p["THL"] + (p["THH"] - p["THL"]) * np.clip((e - 10) / (p["CLEL"] - 10), 0, 1)
    band = np.clip((e - 1) / 5, 0, 1) * np.clip((80 - e) / 30, 0, 1)
    cl = (np.clip((c - th) * 6.0, 0, 1) * band)[..., None]
    lit = np.clip((c - th - 0.02) * 3.0, 0, 1)[..., None]
    col = lerp(p["CLS"], p["CLW"], lit)
    return lerp(base, col, cl)

def face(center, right, up):
    s = (np.arange(N) + 0.5) / N * 2 - 1
    uu, vv = np.meshgrid(s, s)
    return shade(center + uu[..., None] * right + (-vv)[..., None] * up)

if __name__ == "__main__":
    os.makedirs(os.path.join(OUT, "sky"), exist_ok=True)
    faces = {k: face(c, r, U) for k, (c, r) in SIDES.items()}
    faces["up"] = face(U, -d1, d0)
    faces["dn"] = np.ones((N, N, 3)) * p["HOR"]
    for k, v in faces.items():
        Image.fromarray((np.clip(v, 0, 1) * 255).astype(np.uint8)).save(os.path.join(OUT, "sky", f"ae_sky26{V}_{k}.png"))
    print("ok", V)
