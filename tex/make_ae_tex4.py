"""Pass 4 own textures (no reference images).
ae_floor_soft.png: pale stone slabs, 2x2 slabs per tile (tile = 12 studs -> 6-stud slabs), low-contrast grout
(grout about 0.86 of the slab value instead of 0.42), slight per-slab tone and soft mottling.
sky/ae_sky_{up,dn,ft,bk,lf,rt}.png: own cloudy day skybox (blue gradient, soft white cumulus band)."""
import numpy as np, os
from PIL import Image, ImageFilter
OUT = os.path.dirname(os.path.abspath(__file__)); N = 512

def pnoise(n, period, octaves, seed, pers=0.55):
    r = np.random.default_rng(seed); out = np.zeros((n, n), np.float32); amp = 1; tot = 0; p = period
    for _ in range(octaves):
        g = r.random((p + 1, p + 1)).astype(np.float32); xs = np.arange(n) * p / n
        i = np.floor(xs).astype(int); f = xs - i; f = f * f * (3 - 2 * f)
        g[:, -1] = g[:, 0]; g[-1, :] = g[0, :]                     # tileable
        a = g[i][:, i] * (1 - f)[None, :] + g[i][:, i + 1] * f[None, :]
        b = g[i + 1][:, i] * (1 - f)[None, :] + g[i + 1][:, i + 1] * f[None, :]
        out += (a * (1 - f)[:, None] + b * f[:, None]) * amp; tot += amp; amp *= pers; p *= 2
    return out / tot

def floor():
    r = np.random.default_rng(3); img = np.zeros((N, N), np.float32); t = N // 2
    for i in range(2):
        for j in range(2):
            yy, xx = np.mgrid[0:t, 0:t] / t
            img[i * t:(i + 1) * t, j * t:(j + 1) * t] = 0.93 + r.uniform(-0.03, 0.02) + 0.03 * (1 - yy) - 0.02 * xx
    img *= 0.96 + 0.06 * pnoise(N, 4, 4, 9)
    g = 4
    for k in range(3):
        img[max(0, k * t - g):k * t + g, :] *= 0.86; img[:, max(0, k * t - g):k * t + g] *= 0.86
    img = np.array(Image.fromarray((np.clip(img, 0, 1) * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(1.5)))
    Image.fromarray(np.stack([img, img, np.clip(img * 1.02, 0, 255).astype(np.uint8)], -1)).save(os.path.join(OUT, "ae_floor_soft.png"))

def sky():
    os.makedirs(os.path.join(OUT, "sky"), exist_ok=True)
    top = np.array([0.30, 0.58, 0.95]); hor = np.array([0.72, 0.86, 1.0])
    def side(seed):
        y = np.linspace(0, 1, N)[:, None, None]                    # 0 top of face, 1 bottom
        base = top * (1 - y ** 1.6) + hor * y ** 1.6
        c = pnoise(N, 3, 5, seed, 0.55); c2 = pnoise(N, 6, 3, seed + 7, 0.5)
        band = np.exp(-((y[..., 0] - 0.62) / 0.16) ** 2)           # cumulus band above the horizon
        cl = np.clip((c * 0.7 + c2 * 0.3 - 0.47) * 4.5, 0, 1) * band
        shade = 0.82 + 0.18 * (1 - y[..., 0])                      # cloud bottoms a bit grey
        img = base * (1 - cl[..., None]) + (np.ones(3) * shade[..., None]) * cl[..., None]
        img = np.where(y > 0.5, img * (1 - 0.0 * y) + 0 , img)
        return np.clip(img, 0, 1)
    up = np.ones((N, N, 3)) * top; cu = np.clip((pnoise(N, 3, 5, 77) - 0.55) * 3.0, 0, 1)
    up = up * (1 - cu[..., None] * 0.6) + cu[..., None] * 0.6
    faces = {"up": up, "dn": np.ones((N, N, 3)) * hor, "ft": side(21), "bk": side(31), "lf": side(41), "rt": side(51)}
    for k, v in faces.items():
        Image.fromarray((v * 255).astype(np.uint8)).save(os.path.join(OUT, "sky", f"ae_sky_{k}.png"))

floor(); sky(); print("ok")
