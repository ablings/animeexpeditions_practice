"""Pass 12 own skybox (no reference images): sky/ae_sky12_{up,dn,ft,bk,lf,rt}.png.
Brief 12 item 1: the reference sky is deep cyan high up but pale and hazy toward the horizon, with large soft white
cumulus also high in the sky (c3). Pass 5 drew one panorama across the side faces and left the up face plain, so no cloud
could sit above 45 degrees. Here every face pixel is turned into a 3D view direction and the sky is a function of that
direction (elevation gradient + 3D value-noise clouds), so the six faces join without seams and clouds cross onto the up face.

Face layout measured in Studio with a debug skybox (coloured edge bars, pass 12):
- side faces read left-to-right in the order Lf | Bk | Rt | Ft | (Lf); the image top is up;
- the Up image's top edge meets Lf, its right edge Ft, bottom edge Rt, left edge Bk.
Colours fitted by rendering and 5x5-sampling against the reference frames (see notes/fix12_plaza.md)."""
import numpy as np, os
from PIL import Image
OUT = os.path.dirname(os.path.abspath(__file__)); N = 512
TOP = np.array([0.16, 0.60, 0.93])    # zenith; (0.34,0.67,0.925) rendered (135,203,232): deepened
MID = np.array([0.30, 0.70, 0.94])    # ~30 degrees
HOR = np.array([0.80, 0.87, 0.92])    # pale haze at the horizon
CLW = np.array([0.98, 0.99, 1.00])    # cloud tops
CLS = np.array([0.78, 0.83, 0.90])    # cloud bottoms

d0, d1, U = np.array([1., 0, 0]), np.array([0., 0, 1]), np.array([0., 1, 0])
SIDES = {"lf": (d0, d1), "bk": (d1, -d0), "rt": (-d0, -d1), "ft": (-d1, d0)}   # centre, right

rng = np.random.default_rng(12); G = 32
LAT = rng.random((G, G, G)).astype(np.float32)

def vnoise(p):
    """Trilinear value noise on a wrapping lattice; p (...,3) in lattice units."""
    i = np.floor(p).astype(int); f = p - i; f = f * f * (3 - 2 * f)
    out = 0
    for dx in (0, 1):
        for dy in (0, 1):
            for dz in (0, 1):
                w = (f[..., 0] if dx else 1 - f[..., 0]) * (f[..., 1] if dy else 1 - f[..., 1]) * (f[..., 2] if dz else 1 - f[..., 2])
                out = out + w * LAT[(i[..., 0] + dx) % G, (i[..., 1] + dy) % G, (i[..., 2] + dz) % G]
    return out

def fbm(p, oct=5):
    a, t, s = 1.0, 0.0, 0.0
    for k in range(oct):
        s = s + a * vnoise(p * (2 ** k) + k * 7.3); t += a; a *= 0.5
    return s / t

def shade(dirs):
    d = dirs / np.linalg.norm(dirs, axis=-1, keepdims=True)
    e = np.degrees(np.arcsin(np.clip(d[..., 1], -1, 1)))               # elevation
    t_hi = np.clip((e - 30) / 50, 0, 1)[..., None]                     # 30..80 deg: MID -> TOP
    t_lo = (np.clip((30 - e) / 30, 0, 1) ** 1.6)[..., None]            # 30..0 deg: MID -> HOR
    base = MID * (1 - t_hi) + TOP * t_hi
    base = base * (1 - t_lo) + HOR * t_lo
    # clouds: flatten the direction toward a cloud deck so puffs stretch near the horizon
    q = d / np.maximum(d[..., 1:2], 0.08) * np.array([1, 0, 1]) * 0.9 + d * 2.2
    c = fbm(q * 0.75 + 3.1, 4)
    band = np.clip((e - 2) / 8, 0, 1) * np.clip((78 - e) / 25, 0, 1)
    cl = (np.clip((c - 0.46) * 6.0, 0, 1) * band)[..., None]
    lit = np.clip((c - 0.48) * 3.0, 0, 1)[..., None]                   # dense cores lit white, thin edges grey-blue
    col = CLS * (1 - lit) + CLW * lit
    return base * (1 - cl) + col * cl

def face(center, right, up):
    s = (np.arange(N) + 0.5) / N * 2 - 1
    uu, vv = np.meshgrid(s, s)                                         # uu left->right, vv top->bottom
    dirs = center + uu[..., None] * right + (-vv)[..., None] * up
    return shade(dirs)

def sky():
    os.makedirs(os.path.join(OUT, "sky"), exist_ok=True)
    faces = {k: face(c, r, U) for k, (c, r) in SIDES.items()}
    faces["up"] = face(U, -d1, d0)   # image right -> Ft (-d1), image top -> Lf (d0)
    faces["dn"] = np.ones((N, N, 3)) * HOR
    for k, v in faces.items():
        Image.fromarray((np.clip(v, 0, 1) * 255).astype(np.uint8)).save(os.path.join(OUT, "sky", f"ae_sky12_{k}.png"))

if __name__ == "__main__":
    sky(); print("ok")
