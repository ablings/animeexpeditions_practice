"""Capture every camera in cams.json twice in one studio (second frame kept as <tag>_<cam>.png in out/refset/ or out/<dir>).
Usage: python capture_set.py <studio_id> <tag> [outdir] [cam,cam,...]   (screen_capture only; safe in the reference)"""
import json, subprocess, sys, os, shutil
sid, tag = sys.argv[1], sys.argv[2]
outdir = sys.argv[3] if len(sys.argv) > 3 else "out/refset"
only = set(sys.argv[4].split(",")) if len(sys.argv) > 4 else None
cams = {k: v for k, v in json.load(open(os.environ.get("CAMS","cams.json"))).items() if not k.startswith("_") and (not only or k in only)}
os.makedirs(outdir, exist_ok=True); env = dict(os.environ, PYTHONIOENCODING="utf-8")
for name, (pos, look) in cams.items():
    for i in (1, 2):
        cid = f"{tag}_{name}_{i}"
        args = json.dumps({"studio_id": sid, "capture_id": cid, "camera_position": pos, "look_at_position": look})
        r = subprocess.run([sys.executable, "mcpcli.py", "call", "screen_capture", args], capture_output=True, text=True, env=env)
    src = os.path.join("out", f"{cid}_1.png")
    if os.path.exists(src):
        shutil.copy(src, os.path.join(outdir, f"{tag}_{name}.png")); print("ok", name)
    else:
        print("FAIL", name, r.stdout[-200:], r.stderr[-200:])
