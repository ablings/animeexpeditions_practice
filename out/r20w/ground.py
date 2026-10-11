"""ground.py <cam> y x,y ...: where a practice-camera ray through each pixel meets the plane Y=y (no Studio call)"""
import sys, json, numpy as np
c = json.load(open("cams_practice.json"))[sys.argv[1]]; Y = float(sys.argv[2])
cam, at = np.array(c[0], float), np.array(c[1], float)
fwd = (at - cam) / np.linalg.norm(at - cam); right = np.cross(fwd, [0, 1, 0]); right /= np.linalg.norm(right); up = np.cross(right, fwd)
f = 396.5 / np.tan(np.radians(35))
for a in sys.argv[3:]:
    x, y = map(float, a.split(","))
    d = fwd + right * (x - 726) / f + up * (396.5 - y) / f
    t = (Y - cam[1]) / d[1]; p = cam + d * t
    print(a, "->", np.round(p, 1))
