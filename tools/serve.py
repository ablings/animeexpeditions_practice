"""Standalone file server for this repo at http://127.0.0.1:8766/ (same API as blender_http_server.py, no Blender needed).
GET /<path> serves a file; POST /<path> writes the body there. Localhost only. Run: python tools/serve.py"""
import os, http.server
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); PORT = 8766
class H(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **k): super().__init__(*a, directory=ROOT, **k)
    def do_POST(self):
        rel = self.path.lstrip("/").split("?")[0]; path = os.path.normpath(os.path.join(ROOT, rel))
        if not path.startswith(os.path.normpath(ROOT)): self.send_response(403); self.end_headers(); return
        data = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        os.makedirs(os.path.dirname(path), exist_ok=True); open(path, "wb").write(data)
        self.send_response(200); self.end_headers(); self.wfile.write(b"ok")
    def log_message(self, *a): pass
http.server.ThreadingHTTPServer(("127.0.0.1", PORT), H).serve_forever()
