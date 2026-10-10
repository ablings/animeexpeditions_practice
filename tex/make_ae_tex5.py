"""Pass 5 own skybox (no reference images): sky/ae_sky5_{up,dn,ft,bk,lf,rt}.png.
Fixes the pass-4 artefact (a pale diamond at screen centre in c3): the up face had clouds right up to its edges while
the side faces were plain blue at the top, so every cube corner showed a cloud patch cut off along the seam.
Here the side faces share ONE panorama noise (Ft | Rt | Bk | Lf, wrapping), the cloud band sits in the lower third and
fades out well before the top edge, and the up face is a plain gradient with no clouds at all."""
import numpy as np, os
from PIL import Image
OUT = os.path.dirname(os.path.abspath(__file__)); N = 512

def pano_noise(w, h, period, octaves, seed, pers=0.55):
    """Value noise tileable in x over w (the 4 side faces), not tiled in y."""
    r = np.random.default_rng(seed); out = np.zeros((h, w), np.float32); amp = 1; tot = 0; p = period
    for _ in range(octaves):
        py = max(2, p * h // w + 1)
        g = r.random((py + 1, p + 1)).astype(np.float32); g[:, -1] = g[:, 0]
        xs = np.arange(w) * p / w; ys = np.arange(h) * (py - 1) / h
        ix = np.floor(xs).astype(int); fx = xs - ix; fx = fx * fx * (3 - 2 * fx)
        iy = np.floor(ys).astype(int); fy = ys - iy; fy = fy * fy * (3 - 2 * fy)
        a = g[iy][:, ix] * (1 - fx) + g[iy][:, ix + 1] * fx
        b = g[iy + 1][:, ix] * (1 - fx) + g[iy + 1][:, ix + 1] * fx
        out += (a * (1 - fy)[:, None] + b * fy[:, None]) * amp; tot += amp; amp *= pers; p *= 2
    return out / tot

def sky():
    os.makedirs(os.path.join(OUT, "sky"), exist_ok=True)
    top = np.array([0.36, 0.64, 0.92]); hor = np.array([0.70, 0.84, 0.96])   # base about (110,185,240) mid-face
    W = 4 * N
    y = np.linspace(0, 1, N)[:, None]                                       # 0 = top edge of a side face
    base = top[None, None, :] * (1 - y[..., None] ** 1.4) + hor[None, None, :] * y[..., None] ** 1.4
    base = np.repeat(base, W, axis=1)
    c = pano_noise(W, N, 10, 5, 5) * 0.7 + pano_noise(W, N, 28, 3, 6) * 0.3
    band = np.exp(-((y - 0.68) / 0.17) ** 2) * (y < 0.93)                   # cumulus in the lower third, gone by the top
    cl = np.clip((c - 0.40) * 3.2, 0, 1) * band
    shade = 0.80 + 0.20 * np.clip((0.78 - y) / 0.2, 0, 1)                   # grey cloud bottoms, white tops
    col = np.stack([shade * 0.94, shade * 0.97, shade * 1.0], -1)
    pano = base * (1 - cl[..., None]) + col * cl[..., None]
    faces = {k: pano[:, i * N:(i + 1) * N] for i, k in enumerate(("ft", "rt", "bk", "lf"))}
    faces["up"] = np.ones((N, N, 3)) * top; faces["dn"] = np.ones((N, N, 3)) * hor
    for k, v in faces.items():
        Image.fromarray((np.clip(v, 0, 1) * 255).astype(np.uint8)).save(os.path.join(OUT, "sky", f"ae_sky5_{k}.png"))

sky(); print("ok")
