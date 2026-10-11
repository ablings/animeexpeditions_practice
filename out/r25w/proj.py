import math, numpy as np
def surf(d, d0=17.0, dk=28.0, d1=48.4, y0=0.55, yk=0.9, y1=6.35):
    return y0 + (yk - y0) * max(0.0, d - d0) / (dk - d0) if d <= dk else yk + (y1 - yk) * (d - dk) / (d1 - dk)
def proj(cam, look, P, W=1452, H=793, fov=70):
    cam, look, P = (np.array(a, float) for a in (cam, look, P)); f = look - cam; f /= np.linalg.norm(f)
    r = np.cross(f, [0, 1, 0]); r /= np.linalg.norm(r); u = np.cross(r, f)
    v = P - cam; z = v @ f; t = math.tan(math.radians(fov / 2))
    return W / 2 + (v @ r) / z / t * H / 2, H / 2 - (v @ u) / z / t * H / 2
if __name__ == "__main__":
    C = ((0, 6, -25), (0, 13, -85))
    for d in (20.6, 26, 30, 33.5, 35, 38.2, 40, 44, 48.4):
        print(d, [tuple(round(c) for c in proj(*C, (x, surf(d) + 0.2 + 0.0, -d))) for x in (0, 2.9, 3.45, 4.3)])
def unproj(cam, look, px, py, yplane=6.0, W=1452, H=793, fov=70):
    cam, look = np.array(cam, float), np.array(look, float); f = look - cam; f /= np.linalg.norm(f)
    r = np.cross(f, [0, 1, 0]); r /= np.linalg.norm(r); u = np.cross(r, f); t = math.tan(math.radians(fov / 2))
    d = f + r * (px - W / 2) / (H / 2) * t + u * (H / 2 - py) / (H / 2) * t
    s = (yplane - cam[1]) / d[1]; return cam + s * d
