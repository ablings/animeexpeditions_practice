"""Make an EXPORT-ONLY scratch copy of a reference place with every SurfaceAppearance.TexturePack id blanked.

Why (Anime Expeditions, 2026-10-10: MaterialVariant.TexturePack ids hang the exporter the same way, so all classes are blanked). In the Sniper Duels reference, Studio's .obj/.glTF export (File > Export as .obj, or Explorer > Save/Export >
Export as Obj) hangs forever ("Not Responding", CPU idle, no file) -- even for one brand-new Part -- as long as the
place has SurfaceAppearances whose TexturePack id is set (1,325 of 2,237 here). Blanking only TexturePack (the
ColorMap/NormalMap/... ids stay) makes the same export finish in seconds; the whole Lobby exports in ~30 s.
RIVALS (105 SurfaceAppearances, all with packs) exports fine, so the packs themselves (not the count) are the trigger:
most likely Studio waits on texture-pack assets this account cannot fetch.

Rules: the reference file is only READ. The copy goes to a scratch/ignored folder, is opened only to export geometry,
is never saved from Studio, never published, and is deleted after. Exports stay in kit/ref_export/ (gitignored).
Usage: python -I tools/strip_texturepacks.py <reference.rbxl> <out_copy.rbxl> [extra sys.path with lz4+zstandard]
"""
import sys, struct
if len(sys.argv) > 3:
    sys.path.insert(0, sys.argv[3])
import lz4.block, zstandard

src, dst = sys.argv[1], sys.argv[2]
assert src != dst, "never write over the reference"
data = open(src, "rb").read()
assert data[:8] == b"<roblox!", "not a binary place"
zd = zstandard.ZstdDecompressor()
chunks, pos = [], 32
while pos < len(data):
    name = data[pos:pos + 4]; clen, ulen = struct.unpack_from("<II", data, pos + 4); pos += 16
    if clen == 0:
        raw = data[pos:pos + ulen]; pos += ulen
    else:
        c = data[pos:pos + clen]; pos += clen
        raw = zd.decompress(c, max_output_size=ulen) if c[:4] == b"\x28\xb5\x2f\xfd" else lz4.block.decompress(c, uncompressed_size=ulen)
    chunks.append([name, raw])
    if name == b"END\x00":
        break

def rs(b, o):
    n = struct.unpack_from("<I", b, o)[0]; return b[o + 4:o + 4 + n], o + 4 + n

classes = {}
for name, raw in chunks:
    if name == b"INST":
        cid = struct.unpack_from("<I", raw, 0)[0]; cn, o = rs(raw, 4)
        classes[cid] = (cn, struct.unpack_from("<I", raw, o + 1)[0])
blanked = 0
for ch in chunks:
    name, raw = ch
    if name != b"PROP":
        continue
    cid = struct.unpack_from("<I", raw, 0)[0]; pn, o = rs(raw, 4); cn, cnt = classes[cid]
    if pn != b"TexturePack" or raw[o] != 1:   # any class: SurfaceAppearance, MaterialVariant, Decal, Texture
        continue
    head, o = raw[:o + 1], o + 1
    for _ in range(cnt):
        v, o = rs(raw, o); blanked += bool(v)
    ch[1] = head + struct.pack("<I", 0) * cnt + raw[o:]
with open(dst, "wb") as f:
    f.write(data[:32])
    for name, raw in chunks:          # chunks re-emitted uncompressed (valid: compressed length 0)
        f.write(name + struct.pack("<III", 0, len(raw), 0) + raw)
print(f"wrote {dst}: blanked {blanked} TexturePack ids (all classes)")
