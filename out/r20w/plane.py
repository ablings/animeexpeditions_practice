"""plane.py <cam> W x,y ...: where the practice-camera ray through a pixel meets the NE arch front plane (x - z)/sqrt2 = W;
prints (u, y) in the arch frame (u = (x + z)/sqrt2 is the across-arch coordinate)."""
import sys, json, numpy as np
c = json.load(open("cams_practice.json"))[sys.argv[1]]; W = float(sys.argv[2])
cam, at = np.array(c[0], float), np.array(c[1], float)
fwd = (at - cam) / np.linalg.norm(at - cam); right = np.cross(fwd, [0, 1, 0]); right /= np.linalg.norm(right); up = np.cross(right, fwd)
f = 396.5 / np.tan(np.radians(35)); n = np.array([1, 0, -1]) / np.sqrt(2)
for a in sys.argv[3:]:
    x, y = map(float, a.split(","))
    d = fwd + right * (x - 726) / f + up * (396.5 - y) / f
    t = (W - cam @ n) / (d @ n); p = cam + d * t
    print(a, "-> u %.2f y %.2f" % ((p[0] + p[2]) / np.sqrt(2), p[1]))
