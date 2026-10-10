"""Walkability overlap: expand an RLE scan to x,z,y lines and compare two scans cell by cell.
Usage: python -I nav_compare.py <ref.txt|ref.rle> <mine.txt|mine.rle> [out_diff.txt]
Cell format: x,z,y with x,z = studio/2 (2-stud grid), y = round(studioY*2).
RLE format: "x:z0-z1=y,z=y;x:..." (same values)."""
import sys, os

def load(path):
    d = {}
    txt = open(path).read().strip()
    if path.endswith('.rle'):
        for col in txt.split(';'):
            if not col: continue
            x, segs = col.split(':')
            x = int(x)
            for s in segs.split(','):
                zr, y = s.split('=')
                y = int(y)
                if '-' in zr[1:]:
                    i = zr.index('-', 1); z0, z1 = int(zr[:i]), int(zr[i+1:])
                else:
                    z0 = z1 = int(zr)
                for z in range(z0, z1 + 1): d[(x, z)] = y
    else:
        for line in txt.splitlines():
            a = line.strip().split(',')
            if len(a) == 3: d[(int(a[0]), int(a[1]))] = int(a[2])
    return d

def dump(d, path):
    with open(path, 'w') as f:
        for (x, z) in sorted(d): f.write(f"{x},{z},{d[(x,z)]}\n")

def main():
    ref, mine = load(sys.argv[1]), load(sys.argv[2])
    both = set(ref) & set(mine)
    dy = {c: mine[c] - ref[c] for c in both}
    ok = sum(1 for c in both if abs(dy[c]) <= 2)  # within 1 stud (values are 2x)
    ref_only = sorted(set(ref) - set(mine)); mine_only = sorted(set(mine) - set(ref))
    print(f"ref cells {len(ref)}  mine cells {len(mine)}  both {len(both)}")
    print(f"overlap (both/ref) {len(both)/len(ref):.4f}   jaccard {len(both)/len(set(ref)|set(mine)):.4f}")
    print(f"height within 1 stud: {ok}/{len(both)} ({ok/len(both):.4f}); max |dy| {max(abs(v) for v in dy.values())/2:.1f} studs")
    print(f"ref-only {len(ref_only)}  mine-only {len(mine_only)}")
    # cluster ref-only / mine-only by 10x10 cell blocks (20x20 studs) to localise
    from collections import Counter
    def blocks(cells):
        c = Counter((x // 10 * 20, z // 10 * 20) for x, z in cells)
        return sorted(c.items(), key=lambda kv: -kv[1])[:12]
    print("ref-only hotspots (studio x,z of 20x20 block, count):", blocks(ref_only))
    print("mine-only hotspots:", blocks(mine_only))
    bad = sorted((c for c in both if abs(dy[c]) > 2), key=lambda c: -abs(dy[c]))
    print("height-mismatch hotspots:", blocks(bad), "n", len(bad))
    if len(sys.argv) > 3:
        with open(sys.argv[3], 'w') as f:
            for c in ref_only: f.write(f"ref-only {c[0]*2},{c[1]*2} y {ref[c]/2}\n")
            for c in mine_only: f.write(f"mine-only {c[0]*2},{c[1]*2} y {mine[c]/2}\n")
            for c in bad: f.write(f"dy {c[0]*2},{c[1]*2} ref {ref[c]/2} mine {mine[c]/2}\n")

if __name__ == '__main__':
    main()
