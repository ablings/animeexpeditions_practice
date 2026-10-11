"""Own glow-card texture for pass 25: white soft haze with ragged fBm edges (alpha falloff), tinted in Studio by Decal.Color3."""
import numpy as np
from PIL import Image
rng = np.random.default_rng(25); N = 256
def noise(oct=5):
    out = np.zeros((N, N))
    for o in range(oct):
        k = 4 * 2 ** o; g = rng.random((k + 1, k + 1))
        im = Image.fromarray((g * 255).astype(np.uint8)).resize((N, N), Image.BICUBIC)
        out += np.asarray(im, float) / 255 / 2 ** o
    return out / out.max()
y, x = np.mgrid[0:N, 0:N] / (N - 1) * 2 - 1
r = np.sqrt(x ** 2 + (y * 1.1) ** 2) + (noise() - 0.5) * 0.55
a = np.clip(1 - r, 0, 1) ** 1.6
a *= 0.75 + 0.25 * noise(4)
rgba = np.dstack([np.full((N, N), 255), np.full((N, N), 255), np.full((N, N), 255), np.clip(a * 255, 0, 255)]).astype(np.uint8)
Image.fromarray(rgba, "RGBA").save("tex/ae_glow25.png")
print("ok", a.max(), a.mean())
