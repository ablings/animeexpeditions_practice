"""Own stylised textures for the plaza practice (no reference images): a big-tile stone floor with soft painted
gradient per tile and dark grout, and a step-face stone. Near-mid greys so the part colour can tint."""
import numpy as np, os
from PIL import Image, ImageFilter
OUT = os.path.dirname(os.path.abspath(__file__)); N = 512; rng = np.random.default_rng(5)
def tiles(n_tiles, grout=0.035, seed=1):
    r = np.random.default_rng(seed); img = np.zeros((N, N), np.float32)
    t = N // n_tiles
    for i in range(n_tiles):
        for j in range(n_tiles):
            base = 0.80 + r.uniform(-0.06, 0.05)
            yy, xx = np.mgrid[0:t, 0:t] / t
            grad = base + 0.08 * (1 - yy) - 0.05 * xx          # painted top-left light, bottom-right shade
            img[i * t:(i + 1) * t, j * t:(j + 1) * t] = grad
    g = int(N * grout / n_tiles * n_tiles) or 3
    for k in range(n_tiles + 1):
        img[max(0, k * t - g):k * t + g, :] = 0.42; img[:, max(0, k * t - g):k * t + g] = 0.42
    img = np.array(Image.fromarray((np.clip(img, 0, 1) * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(1.2)))
    return img
f = tiles(4, seed=1); Image.fromarray(np.stack([f, f, (f * 1.04).clip(0, 255).astype(np.uint8)], -1)).save(os.path.join(OUT, "ae_floor_tiles.png"))
s = tiles(2, grout=0.02, seed=2); Image.fromarray(np.stack([s, s, s], -1)).save(os.path.join(OUT, "ae_stone_blocks.png"))
print("ok")
