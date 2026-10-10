"""Offline inspector for a Roblox binary place (.rbxl). Reads chunk headers, decompresses INST/PROP chunks
(LZ4 or Zstd) and reports: class counts, the biggest PROP payloads by class/property (MeshData, PhysicalConfigData,
ChildData of unions, etc.), and per-class totals. Read-only; never writes the place.
Usage: python -I rbxl_inspect.py <place.rbxl> [extra sys.path for lz4/zstandard]"""
import sys, struct, collections
if len(sys.argv) > 2:
    sys.path.insert(0, sys.argv[2])
import lz4.block, zstandard

path = sys.argv[1]
data = open(path, "rb").read()
assert data[:8] == b"<roblox!", "not a binary place"
n_types, n_inst = struct.unpack_from("<ii", data, 16)
pos = 32
classes = {}          # classID -> (name, count)
prop_sizes = collections.Counter()    # (class, prop) -> bytes
chunk_stats = collections.Counter()
zd = zstandard.ZstdDecompressor()

def read_str(b, o):
    n = struct.unpack_from("<I", b, o)[0]
    return b[o + 4:o + 4 + n].decode("utf-8", "replace"), o + 4 + n

while pos < len(data):
    name = data[pos:pos + 4]; clen, ulen = struct.unpack_from("<II", data, pos + 4)
    pos += 16
    if clen == 0:
        raw = data[pos:pos + ulen]; pos += ulen
    else:
        comp = data[pos:pos + clen]; pos += clen
        raw = zd.decompress(comp, max_output_size=ulen) if comp[:4] == b"\x28\xb5\x2f\xfd" else lz4.block.decompress(comp, uncompressed_size=ulen)
    chunk_stats[name.decode("latin1")] += len(raw)
    if name == b"INST":
        cid = struct.unpack_from("<I", raw, 0)[0]
        cname, o = read_str(raw, 4)
        o += 1  # object format
        count = struct.unpack_from("<I", raw, o)[0]
        classes[cid] = [cname, count]
    elif name == b"PROP":
        cid = struct.unpack_from("<I", raw, 0)[0]
        pname, o = read_str(raw, 4)
        cname = classes.get(cid, ["?", 0])[0]
        prop_sizes[(cname, pname)] += len(raw) - o
    elif name == b"END\x00":
        break

print(f"file {len(data)/1e6:.2f} MB, types {n_types}, instances {n_inst}")
print("\nchunk payload totals (uncompressed):")
for k, v in chunk_stats.most_common(): print(f"  {k:5s} {v/1e6:8.2f} MB")
print("\nclasses by count:")
for cid, (cn, c) in sorted(classes.items(), key=lambda kv: -kv[1][1])[:30]: print(f"  {c:7d}  {cn}")
print("\nbiggest properties (class.prop, uncompressed bytes):")
for (cn, pn), v in prop_sizes.most_common(25): print(f"  {v/1e6:8.2f} MB  {cn}.{pn}")
