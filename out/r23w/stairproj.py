"""stairproj.py: project riser faces (y range in px) of a flight through the c4 practice camera.
Flight along -z, starts at d0, N risers of rise R, tread T, base y0. Prints the riser px band (top..bottom) per step."""
import sys, json, numpy as np
c = json.load(open("cams_practice.json"))["c4_stairs"]
cam, at = np.array(c[0], float), np.array(c[1], float)
fwd = (at - cam) / np.linalg.norm(at - cam); right = np.cross(fwd, [0, 1, 0]); right /= np.linalg.norm(right); up = np.cross(right, fwd)
f = 396.5 / np.tan(np.radians(35))
def py(p):
    v = np.array(p, float) - cam; z = v @ fwd; return 396.5 - (v @ up) / z * f
def flight(N, R, T, d0, y0, lat=12.0):
    out = []
    for k in range(N):
        d = d0 + k * T
        out.append((round(py((lat, y0 + (k + 1) * R, -d))), round(py((lat, y0 + k * R, -d)))))
    return out
if __name__ == "__main__":
    N, R, T, d0, y0 = int(sys.argv[1]), *map(float, sys.argv[2:6])
    lat = float(sys.argv[6]) if len(sys.argv) > 6 else 12
    print(f"N={N} R={R} T={T} d0={d0} y0={y0}:", " ".join(f"{a}-{b}" for a, b in flight(N, R, T, d0, y0, lat)))
