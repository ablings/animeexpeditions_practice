"""rayz.py <cam> <axis x|y|z> <value> px,py ...: where the practice-camera ray through a pixel meets the plane axis=value"""
import sys, json, numpy as np
c = json.load(open("cams_practice.json"))[sys.argv[1]]; ax = "xyz".index(sys.argv[2]); V = float(sys.argv[3])
cam, at = np.array(c[0], float), np.array(c[1], float)
fwd = (at - cam) / np.linalg.norm(at - cam); right = np.cross(fwd, [0, 1, 0]); right /= np.linalg.norm(right); up = np.cross(right, fwd)
f = 396.5 / np.tan(np.radians(35))
for a in sys.argv[4:]:
    x, y = map(float, a.split(","))
    d = fwd + right * (x - 726) / f + up * (396.5 - y) / f
    t = (V - cam[ax]) / d[ax]; print(a, "->", np.round(cam + d * t, 1))
