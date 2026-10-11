"""Own freestyle kit for the Anime Expeditions spawn-plaza practice (no reference geometry used).
Run inside Blender: runpy.run_path(r"...\tools\ae_kit.py"). Builds each piece in collection KIT at the origin,
named K_<piece>_<colour>, where <colour> is the material split (stone, gold, blue, glass, water, wood, leaf...).
Sizes in studs (1 Blender unit = 1 stud), Y-up handled at export (FBX axis_up='Y')."""
import bpy, bmesh, math
from mathutils import Vector, Matrix

def coll():
    c = bpy.data.collections.get("KIT")
    if not c:
        c = bpy.data.collections.new("KIT"); bpy.context.scene.collection.children.link(c)
    return c

def clear_piece(prefix):
    for o in list(bpy.data.objects):
        if o.name.startswith(prefix): bpy.data.objects.remove(o, do_unlink=True)

def mesh_obj(name, bm, smooth=True, auto_angle=40):
    me = bpy.data.meshes.new(name); bm.to_mesh(me); bm.free()
    if smooth:
        for p in me.polygons: p.use_smooth = True
    o = bpy.data.objects.new(name, me); coll().objects.link(o)
    if smooth:
        try:
            m = o.modifiers.new("ss", "SMOOTH_BY_ANGLE"); m["Input_1"] = math.radians(auto_angle)
        except Exception: pass
    return o

def lathe(name, prof, seg=32, angle=2 * math.pi, start=0.0, cap=False, smooth=True):
    """prof: list of (r, y) points, revolved around Y (up). Partial angles make arcs."""
    bm = bmesh.new(); rings = []
    full = abs(angle - 2 * math.pi) < 1e-6; n = seg if full else seg + 1
    for i in range(n):
        a = start + angle * i / seg
        rings.append([bm.verts.new((r * math.cos(a), y, r * math.sin(a))) for r, y in prof])
    for i in range(seg):
        r0, r1 = rings[i], rings[(i + 1) % n if full else i + 1]
        for j in range(len(prof) - 1):
            bm.faces.new((r0[j], r1[j], r1[j + 1], r0[j + 1]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return mesh_obj(name, bm, smooth)

def rbox(name, sx, sy, sz, bevel=0.3, segs=3, loc=(0, 0, 0)):
    """Rounded (bevelled) box, the chunky stylised block."""
    bm = bmesh.new(); bmesh.ops.create_cube(bm, size=1.0)
    for v in bm.verts: v.co = Vector((v.co.x * sx, v.co.y * sy, v.co.z * sz)) + Vector(loc)
    bmesh.ops.bevel(bm, geom=list(bm.edges), offset=min(bevel, min(sx, sy, sz) * 0.45), segments=segs, affect='EDGES', profile=0.5)
    return mesh_obj(name, bm, True, 60)

def tube_along(name, pts, radius=0.35, closed=False, res=6):
    """Rounded trim band: a curve with round bevel converted to mesh (the thick gold outline look)."""
    cu = bpy.data.curves.new(name + "_c", "CURVE"); cu.dimensions = '3D'; cu.bevel_depth = radius; cu.bevel_resolution = 2
    cu.use_fill_caps = True
    sp = cu.splines.new('POLY'); sp.points.add(len(pts) - 1)
    for p, c in zip(sp.points, pts): p.co = (c[0], c[1], c[2], 1)
    sp.use_cyclic_u = closed
    o = bpy.data.objects.new(name + "_tmp", cu); coll().objects.link(o)
    dg = bpy.context.evaluated_depsgraph_get(); me = bpy.data.meshes.new_from_object(o.evaluated_get(dg))
    bpy.data.objects.remove(o, do_unlink=True); bpy.data.curves.remove(cu)
    ob = bpy.data.objects.new(name, me); coll().objects.link(ob)
    for p in me.polygons: p.use_smooth = True
    return ob

def extrude_outline(name, outline2d, depth, bevel=0.25):
    """Flat 2D outline (x, y) extruded along Z by depth, edges bevelled."""
    bm = bmesh.new(); vs = [bm.verts.new((x, y, -depth / 2)) for x, y in outline2d]
    f = bm.faces.new(vs)
    r = bmesh.ops.extrude_face_region(bm, geom=[f])
    for v in [e for e in r["geom"] if isinstance(e, bmesh.types.BMVert)]: v.co.z += depth
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    if bevel > 0:
        bmesh.ops.bevel(bm, geom=[e for e in bm.edges if abs(e.verts[0].co.z - e.verts[1].co.z) < 1e-6], offset=bevel, segments=2, affect='EDGES', profile=0.5)
    return mesh_obj(name, bm, True, 50)

def arc_pts(cx, cy, r, a0, a1, n):
    return [(cx + r * math.cos(a0 + (a1 - a0) * i / n), cy + r * math.sin(a0 + (a1 - a0) * i / n)) for i in range(n + 1)]

# ---------------------------------------------------------------- pieces (sizes from the picture set, freestyle)
def build_hood():
    """Corner fountain hood: a curved wall (crescent in plan, ~200 deg) behind the fountain, flat top, horned front ends,
    thick gold trim on its top and front edges. Opening faces -Z (toward the plaza)."""
    clear_piece("K_Hood")
    a0, a1 = math.radians(-10), math.radians(190)          # open side toward -Z after rotation below
    prof = [(10.0, 0.0), (13.0, 0.0), (13.0, 14.0), (12.4, 14.6), (10.6, 14.6), (10.0, 14.0), (10.0, 0.0)]
    o = lathe("K_Hood_stone", prof, seg=28, angle=a1 - a0, start=a0, smooth=True)
    gold = []
    gold.append(tube_along("K_Hood_goldA", [(11.5 * math.cos(a0 + (a1 - a0) * i / 40), 14.75, 11.5 * math.sin(a0 + (a1 - a0) * i / 40)) for i in range(41)], 0.55))
    for a in (a0, a1):
        ca, sa = math.cos(a), math.sin(a)
        gold.append(tube_along(f"K_Hood_goldE{len(gold)}", [(10.0 * ca, 0.2, 10.0 * sa), (10.0 * ca, 14.6, 10.0 * sa), (13.0 * ca, 14.6, 13.0 * sa), (13.0 * ca, 0.2, 13.0 * sa)], 0.45))
        h = rbox(f"K_Hood_horn{len(gold)}", 2.2, 3.2, 2.2, bevel=0.8, loc=(11.5 * ca, 16.2, 11.5 * sa))
        h.name = f"K_Hood_stoneHorn{len(gold)}"
    base = lathe("K_Hood_stoneBase", [(0, 0.0), (14.5, 0.0), (14.5, 1.0), (0, 1.0)], seg=32)
    return o

def build_fountain():
    clear_piece("K_Fountain")
    lathe("K_Fountain_stone", [(0, 0), (7.0, 0), (7.0, 2.2), (6.3, 2.2), (6.3, 1.2), (3.0, 1.2), (3.0, 3.8), (2.3, 3.8), (2.3, 3.0), (1.0, 3.0), (1.0, 5.4), (0.6, 5.4), (0, 5.4)], seg=36)
    tube_along("K_Fountain_goldA", [(7.0 * math.cos(2 * math.pi * i / 48), 2.25, 7.0 * math.sin(2 * math.pi * i / 48)) for i in range(48)], 0.32, closed=True)
    tube_along("K_Fountain_goldB", [(3.0 * math.cos(2 * math.pi * i / 36), 3.85, 3.0 * math.sin(2 * math.pi * i / 36)) for i in range(36)], 0.26, closed=True)
    lathe("K_Fountain_water", [(0, 1.9), (6.3, 1.9)], seg=36)
    lathe("K_Fountain_water2", [(0, 3.5), (2.3, 3.5)], seg=24)
    lathe("K_Fountain_glassJet", [(0, 5.4), (0.5, 5.6), (0.35, 7.6), (0.0, 8.2)], seg=12)

def build_pavilion():
    clear_piece("K_Pav")
    lathe("K_Pav_stone", [(0, 0), (4.2, 0), (4.2, 1.6), (3.6, 1.8), (3.6, 2.2), (0, 2.2)], seg=24)
    lathe("K_Pav_glass", [(3.0, 2.2), (3.0, 7.4)], seg=24)
    lathe("K_Pav_glassCore", [(0, 2.2), (1.4, 2.6), (1.6, 5.0), (1.0, 6.8), (0, 7.2)], seg=12)
    for i in range(6):
        a = 2 * math.pi * i / 6
        lathe(f"K_Pav_goldCol{i}", [(0.0, 2.2), (0.32, 2.2), (0.32, 7.4), (0.0, 7.4)], seg=8).location = (3.35 * math.cos(a), 0, 3.35 * math.sin(a))
    lathe("K_Pav_goldRing", [(2.6, 7.4), (4.1, 7.4), (4.1, 8.2), (2.6, 8.2)], seg=24)
    lathe("K_Pav_blueDome", [(3.9, 8.2)] + [(3.9 * math.cos(t), 8.2 + 4.2 * math.sin(t)) for t in [math.pi / 2 * k / 8 for k in range(1, 9)]], seg=24)
    lathe("K_Pav_goldFinial", [(0, 12.3), (0.7, 12.5), (0.5, 13.2), (0.9, 13.8), (0, 15.0)], seg=12)

def build_step(length=30.0):
    clear_piece("K_Step")
    rbox("K_Step_stone", length, 1.0, 1.7, bevel=0.22, loc=(0, 0.5, 0))

def build_channel(length=50.0, width=8.0):
    clear_piece("K_Channel")
    rbox("K_Channel_blue", width, 0.6, length, bevel=0.2, loc=(0, 0.3, 0))
    hw, hl = width / 2, length / 2
    tube_along("K_Channel_goldFrame", [(-hw, 0.62, -hl), (hw, 0.62, -hl), (hw, 0.62, hl), (-hw, 0.62, hl)], 0.35, closed=True)
    tube_along("K_Channel_goldY", [(0, 0.62, -hl + 2), (0, 0.62, hl - 6), (-hw + 1.2, 0.62, hl - 1.5)], 0.22)
    tube_along("K_Channel_goldY2", [(0, 0.62, hl - 6), (hw - 1.2, 0.62, hl - 1.5)], 0.22)

def build_medallion():
    clear_piece("K_Medal")
    lathe("K_Medal_stone", [(0, 0), (9.6, 0), (9.6, 0.4), (0, 0.4)], seg=48)
    star = []
    for i in range(24):
        a = 2 * math.pi * i / 24; r = 7.4 if i % 2 == 0 else 4.2
        a2 = a + (0.12 if i % 2 == 0 else 0)
        star.append((r * math.cos(a2), r * math.sin(a2)))
    o = extrude_outline("K_Medal_darkSun", star, 0.25, bevel=0.0); o.rotation_euler = (math.radians(90), 0, 0); o.location = (0, 0.45, 0)
    for r, w, nm in ((9.6, 0.4, "A"), (3.0, 0.3, "B")):
        tube_along(f"K_Medal_gold{nm}", [(r * math.cos(2 * math.pi * i / 64), 0.45, r * math.sin(2 * math.pi * i / 64)) for i in range(64)], w, closed=True)
    lathe("K_Medal_goldCore", [(0, 0.45), (2.2, 0.45), (2.0, 0.85), (0, 0.95)], seg=24)

def build_bollard():
    clear_piece("K_Bollard")
    lathe("K_Bollard_stone", [(0, 0), (1.3, 0), (1.3, 1.6), (1.0, 1.8), (0, 1.8)], seg=16)
    lathe("K_Bollard_gold", [(1.0, 1.8)] + [(1.0 * math.cos(t), 1.8 + 1.2 * math.sin(t)) for t in [math.pi / 2 * k / 6 for k in range(1, 7)]], seg=16)

def build_plinth():
    clear_piece("K_Plinth")
    rbox("K_Plinth_blue", 6.0, 7.0, 2.0, bevel=0.35, loc=(0, 3.5, 0))
    tube_along("K_Plinth_goldFrame", [(-3.0, 0.3, -1.05), (3.0, 0.3, -1.05), (3.0, 7.0, -1.05), (-3.0, 7.0, -1.05)], 0.32, closed=True)
    bm = bmesh.new(); bmesh.ops.create_icosphere(bm, subdivisions=1, radius=0.9)
    g = mesh_obj("K_Plinth_glassGem", bm, False); g.location = (0, 3.0, -1.2)

def build_puff_tree(seed=1):
    import random; random.seed(seed)
    clear_piece("K_PuffTree")
    tube_along("K_PuffTree_wood", [(0, 0, 0), (0.4, 5, 0.2), (0.2, 9, -0.3)], 0.7)
    for i in range(7):
        bm = bmesh.new(); bmesh.ops.create_icosphere(bm, subdivisions=2, radius=random.uniform(2.6, 3.6))
        for v in bm.verts: v.co *= 1 + random.uniform(-0.12, 0.12)
        o = mesh_obj(f"K_PuffTree_leaf{i}", bm, True, 80)
        a = 2 * math.pi * i / 7; o.location = (2.4 * math.cos(a) * (i > 0), 10 + random.uniform(-1, 2.5), 2.4 * math.sin(a) * (i > 0))

def build_palm(seed=2):
    import random; random.seed(seed)
    clear_piece("K_Palm")
    pts = [(0.25 * t * t * 0.08, t, 0.0) for t in [0, 3, 6, 9, 12, 14]]
    tube_along("K_Palm_wood", pts, 0.55)
    top = Vector(pts[-1])
    for i in range(9):
        a = 2 * math.pi * i / 9
        d = Vector((math.cos(a), 0, math.sin(a)))
        bm = bmesh.new(); L = 7.0
        rows = []
        for k in range(6):
            t = k / 5; c = top + d * (L * t) + Vector((0, 1.2 * math.sin(math.pi * t) - 2.4 * t * t, 0))
            side = Vector((-d.z, 0, d.x)) * (1.3 * math.sin(math.pi * min(1, t * 1.4)) + 0.05)
            rows.append((bm.verts.new(c - side), bm.verts.new(c), bm.verts.new(c + side + Vector((0, 0.25, 0)))))
        for k in range(5):
            bm.faces.new((rows[k][0], rows[k + 1][0], rows[k + 1][1], rows[k][1])); bm.faces.new((rows[k][1], rows[k + 1][1], rows[k + 1][2], rows[k][2]))
        mesh_obj(f"K_Palm_leaf{i}", bm, True, 70)

def build_all():
    for f in (build_hood, build_fountain, build_pavilion, build_step, build_channel, build_medallion, build_bollard, build_plinth, build_puff_tree, build_palm):
        f()
    return sorted(o.name for o in bpy.data.objects if o.name.startswith("K_"))

# ---------------------------------------------------------------- pass 2
def build_hood2():
    """Upright horseshoe arch over the fountain: tall crescent wall (stone outside, dark inner face) plus a canopy
    leaning over the fountain, gold rounded trim on the front edges and canopy lip, two horn knobs at the front top."""
    clear_piece("K_Hood")
    a0, a1 = math.radians(-15), math.radians(195)
    lathe("K_Hood_stone", [(12.6, 0.0), (13.6, 0.0), (13.6, 19.0), (13.0, 20.2)], seg=32, angle=a1 - a0, start=a0)
    lathe("K_Hood_darkIn", [(12.6, 0.0), (12.6, 19.0)], seg=32, angle=a1 - a0, start=a0)
    lathe("K_Hood_stoneCanopy", [(13.0, 20.2), (13.6, 21.6), (7.5, 21.0), (6.8, 19.6), (12.6, 19.0)], seg=32, angle=a1 - a0, start=a0)
    lathe("K_Hood_darkUnder", [(6.8, 19.55), (12.6, 18.95)], seg=32, angle=a1 - a0, start=a0)
    N = 48
    tube_along("K_Hood_goldLip", [(6.9 * math.cos(a0 + (a1 - a0) * i / N), 19.7, 6.9 * math.sin(a0 + (a1 - a0) * i / N)) for i in range(N + 1)], 0.5)
    tube_along("K_Hood_goldTop", [(13.6 * math.cos(a0 + (a1 - a0) * i / N), 21.7, 13.6 * math.sin(a0 + (a1 - a0) * i / N)) for i in range(N + 1)], 0.45)
    for k, a in enumerate((a0, a1)):
        ca, sa = math.cos(a), math.sin(a)
        tube_along(f"K_Hood_goldEdge{k}", [(12.6 * ca, 0.3, 12.6 * sa), (12.6 * ca, 19.0, 12.6 * sa), (6.9 * ca, 19.7, 6.9 * sa)], 0.5)
        tube_along(f"K_Hood_goldEdgeO{k}", [(13.6 * ca, 0.3, 13.6 * sa), (13.6 * ca, 21.6, 13.6 * sa)], 0.5)
        rbox(f"K_Hood_stoneHorn{k}", 2.4, 4.0, 2.4, bevel=0.9, loc=(13.1 * ca, 23.2, 13.1 * sa))
    lathe("K_Hood_stoneBase", [(0, 0.0), (15.0, 0.0), (15.0, 1.0), (0, 1.0)], seg=36)
    tube_along("K_Hood_goldBase", [(15.0 * math.cos(2 * math.pi * i / 64), 1.0, 15.0 * math.sin(2 * math.pi * i / 64)) for i in range(64)], 0.4, closed=True)

def build_bush(seed=3, tag="blueBush", n=9, r=1.6):
    """Stylised clump: overlapping low-poly blobs, flattened, for scatter planting."""
    import random; random.seed(seed)
    clear_piece(f"K_{tag}")
    for i in range(n):
        bm = bmesh.new(); bmesh.ops.create_icosphere(bm, subdivisions=1, radius=r * random.uniform(0.7, 1.2))
        for v in bm.verts: v.co.y *= 0.7; v.co *= 1 + random.uniform(-0.15, 0.15)
        o = mesh_obj(f"K_{tag}_leaf{i}", bm, True, 80)
        a = random.uniform(0, 2 * math.pi); d = random.uniform(0, r * 1.6)
        o.location = (d * math.cos(a), r * 0.6 + random.uniform(0, r * 0.5), d * math.sin(a))

def build_grass(seed=4):
    import random; random.seed(seed)
    clear_piece("K_Grass")
    bm = bmesh.new()
    for i in range(14):
        a = random.uniform(0, 2 * math.pi); d = random.uniform(0, 1.2); h = random.uniform(1.2, 2.4)
        b = Vector((d * math.cos(a), 0, d * math.sin(a))); side = Vector((-math.sin(a), 0, math.cos(a))) * 0.18
        tip = b + Vector((0.5 * math.cos(a), h, 0.5 * math.sin(a)))
        vs = [bm.verts.new(b - side), bm.verts.new(b + side), bm.verts.new(tip)]
        bm.faces.new(vs); bm.faces.new(list(reversed([bm.verts.new(v.co) for v in vs])))
    mesh_obj("K_Grass_leaf", bm, False)

def build_all2():
    build_hood2(); build_bush(3, "BushBlue"); build_bush(5, "BushRed", 8, 1.4); build_grass()
    return sorted(o.name for o in bpy.data.objects if o.name.startswith("K_"))

def to_zup_and_uv():
    """Y-up authored pieces -> Blender Z-up (rotate data once), then a cube-projection UV on every piece."""
    R = Matrix.Rotation(math.radians(90), 4, 'X')
    for o in bpy.data.objects:
        if o.name.startswith("K_") and o.type == 'MESH' and not o.get("zup"):
            o.data.transform(R); o.location = R @ o.location; o["zup"] = 1
    for o in bpy.data.objects:
        if o.name.startswith("K_") and o.type == 'MESH' and not o.data.uv_layers:
            bm = bmesh.new(); bm.from_mesh(o.data); uv = bm.loops.layers.uv.new("UVMap")
            for f in bm.faces:
                n = f.normal; ax = max(range(3), key=lambda i: abs(n[i]))
                for l in f.loops:
                    c = l.vert.co; u, v = [(c.y, c.z), (c.x, c.z), (c.x, c.y)][ax]
                    l[uv].uv = (u / 8.0, v / 8.0)
            bm.to_mesh(o.data); bm.free()

# ---------------------------------------------------------------- pass 3
def lathe_solid(name, prof, seg, angle, start):
    """Closed-profile lathe with end caps: a solid that renders from every side (Roblox culls back faces)."""
    o = lathe(name, prof + [prof[0]], seg=seg, angle=angle, start=start)
    bm = bmesh.new(); bm.from_mesh(o.data)
    ends = []
    for i in (0, seg):  # cap the two ends of a partial revolve
        a = start + angle * i / seg
        vs = [v for v in bm.verts if abs(math.atan2(v.co.z, v.co.x) - math.atan2(math.sin(a), math.cos(a))) < 1e-4]
        if len(vs) >= 3:
            c = sum((v.co for v in vs), Vector()) / len(vs)
            vs.sort(key=lambda v: math.atan2((v.co - c).y, (v.co - c).dot(Vector((math.cos(a), 0, math.sin(a))))))
            try: bm.faces.new(vs)
            except ValueError: pass
    bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=1e-5)
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    bm.to_mesh(o.data); bm.free(); return o

def flip_toward_axis(o):
    """Make a thin inner shell face the axis (seen from inside the crescent)."""
    bm = bmesh.new(); bm.from_mesh(o.data)
    for f in bm.faces:
        c = f.calc_center_median(); radial = Vector((c.x, 0, c.z))
        if f.normal.dot(radial) > 0: f.normal_flip()
    bm.to_mesh(o.data); bm.free()

def build_hood3():
    clear_piece("K_Hood")
    a0, a1 = math.radians(-15), math.radians(195); A = a1 - a0
    lathe_solid("K_Hood_stone", [(12.6, 0.0), (13.8, 0.0), (13.8, 15.0), (13.2, 16.2), (12.6, 15.0)], 32, A, a0)
    d = lathe("K_Hood_darkIn", [(12.55, 0.3), (12.55, 14.8)], seg=32, angle=A, start=a0); flip_toward_axis(d)
    lathe_solid("K_Hood_stoneCanopy", [(12.6, 15.0), (13.2, 16.2), (7.6, 16.8), (7.0, 15.6)], 32, A, a0)
    u = lathe("K_Hood_darkUnder", [(7.1, 15.5), (12.5, 14.95)], seg=32, angle=A, start=a0)
    bm = bmesh.new(); bm.from_mesh(u.data)
    for f in bm.faces:
        if f.normal.y > 0: f.normal_flip()
    bm.to_mesh(u.data); bm.free()
    N = 48
    tube_along("K_Hood_goldLip", [(7.1 * math.cos(a0 + A * i / N), 15.8, 7.1 * math.sin(a0 + A * i / N)) for i in range(N + 1)], 0.5)
    tube_along("K_Hood_goldTop", [(13.8 * math.cos(a0 + A * i / N), 16.3, 13.8 * math.sin(a0 + A * i / N)) for i in range(N + 1)], 0.45)
    for k, a in enumerate((a0, a1)):
        ca, sa = math.cos(a), math.sin(a)
        tube_along(f"K_Hood_goldEdge{k}", [(12.6 * ca, 0.3, 12.6 * sa), (12.6 * ca, 15.0, 12.6 * sa), (7.1 * ca, 15.8, 7.1 * sa)], 0.5)
        tube_along(f"K_Hood_goldEdgeO{k}", [(13.8 * ca, 0.3, 13.8 * sa), (13.8 * ca, 16.2, 13.8 * sa)], 0.5)
        rbox(f"K_Hood_stoneHorn{k}", 2.4, 3.6, 2.4, bevel=0.9, loc=(13.2 * ca, 17.8, 13.2 * sa))
    lathe_solid("K_Hood_stoneBase", [(0.01, 0.0), (15.0, 0.0), (15.0, 1.0), (0.01, 1.0)], 36, 2 * math.pi - 1e-3, 0)
    tube_along("K_Hood_goldBase", [(15.0 * math.cos(2 * math.pi * i / 64), 1.0, 15.0 * math.sin(2 * math.pi * i / 64)) for i in range(64)], 0.4, closed=True)

def build_channel_ramp():
    """The channel as it runs down the 8-step flight: its own piece at the true ramp length (no stretching in Studio)."""
    clear_piece("K_ChanRamp")
    L = math.sqrt(8 ** 2 + 13.6 ** 2); hw, hl = 4.0, L / 2
    rbox("K_ChanRamp_blue", 8.0, 0.6, L, bevel=0.2, loc=(0, 0.3, 0))
    tube_along("K_ChanRamp_goldFrame", [(-hw, 0.62, -hl), (hw, 0.62, -hl), (hw, 0.62, hl), (-hw, 0.62, hl)], 0.35, closed=True)
    tube_along("K_ChanRamp_goldY", [(0, 0.62, -hl + 1.5), (0, 0.62, hl - 1.5)], 0.22)

def build_all3():
    build_hood3(); build_channel_ramp()


# ---------------------------------------------------------------- pass 4: quarter-and-mirror hero piece
# Plaza frame (studs, Y-up, Roblox axes: -Z = north). Lower plaza floor y=0, terrace y=6 (8 steps x 0.75).
# Stair foot at d=28, top at d=48, flights 34 wide. Corner piece authored for NE (x>0, z<0) in a diagonal frame:
# w = distance out along the diagonal, u = lateral (toward +x+z). Mirrored in X and Z into one mesh per material.
R2 = math.sqrt(2.0)
def P(u, y, w):
    return ((w + u) / R2, y, (u - w) / R2)

def flat(o):
    for p in o.data.polygons: p.use_smooth = False
    for m in list(o.modifiers): o.modifiers.remove(m)
    return o

def extrude_plan(name, pts_xz, y0, y1):
    """Plan polygon (x, z) extruded from y0 to y1: a solid block (flat shaded)."""
    bm = bmesh.new(); vs = [bm.verts.new((x, y0, z)) for x, z in pts_xz]
    f = bm.faces.new(vs)
    r = bmesh.ops.extrude_face_region(bm, geom=[f])
    for v in [e for e in r["geom"] if isinstance(e, bmesh.types.BMVert)]: v.co.y = y1
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return flat(mesh_obj(name, bm, False))

def extrude_side(name, pts_dy, lat0, lat1):
    """Side profile (d, y) extruded across lateral lat0..lat1 for a north flight (d along -Z, lateral along X)."""
    bm = bmesh.new(); vs = [bm.verts.new((lat0, y, -d)) for d, y in pts_dy]
    f = bm.faces.new(vs)
    r = bmesh.ops.extrude_face_region(bm, geom=[f])
    for v in [e for e in r["geom"] if isinstance(e, bmesh.types.BMVert)]: v.co.x = lat1
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return flat(mesh_obj(name, bm, False))

def arch_outline(hw, hs, ry, nleg=3, narc=24):
    pts = [(-hw, hs * i / nleg) for i in range(nleg)]
    pts += [(hw * math.cos(math.pi - math.pi * k / narc), hs + ry * math.sin(math.pi - math.pi * k / narc)) for k in range(narc + 1)]
    pts += [(hw, hs * (nleg - 1 - i) / nleg) for i in range(nleg)]
    return pts

def arch_band(name, outer, inner, w0, w1):
    """Solid arch band between two outlines with the same point count, in the (u, y) plane, from depth w0 to w1."""
    bm = bmesh.new()
    Of = [bm.verts.new(P(u, y, w0)) for u, y in outer]; Ob = [bm.verts.new(P(u, y, w1)) for u, y in outer]
    If = [bm.verts.new(P(u, y, w0)) for u, y in inner]; Ib = [bm.verts.new(P(u, y, w1)) for u, y in inner]
    n = len(outer)
    for i in range(n - 1):
        bm.faces.new((Of[i], Of[i + 1], If[i + 1], If[i])); bm.faces.new((Ob[i], Ib[i], Ib[i + 1], Ob[i + 1]))
        bm.faces.new((Of[i], Ob[i], Ob[i + 1], Of[i + 1])); bm.faces.new((If[i], If[i + 1], Ib[i + 1], Ib[i]))
    for i in (0, n - 1):
        bm.faces.new((Of[i], If[i], Ib[i], Ob[i]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return flat(mesh_obj(name, bm, False))

def rbox_rot(name, sx, sy, sz, loc, rot_y, bevel=0.3, segs=2):
    o = rbox(name, sx, sy, sz, bevel=bevel, segs=segs); o.location = loc; o.rotation_euler = (0, rot_y, 0); return o

def lathe_at(name, prof, loc, seg=32, smooth=True):
    o = lathe(name, prof, seg=seg, smooth=smooth); o.location = loc; return o

def merge_objs(name, objs, mirror4=False, rot4=False):
    """Bake objs (loc/rot) into one mesh; optionally add the X/Z mirrors (4 corners) or the 4 rotations about Y."""
    src = bmesh.new()
    for o in objs:
        me = o.data.copy(); me.transform(o.matrix_basis); src.from_mesh(me); bpy.data.meshes.remove(me)
    out = bmesh.new()
    mats = [Matrix.Identity(4)]
    if mirror4: mats = [Matrix.Diagonal((sx, 1, sz, 1)) for sx, sz in ((1, 1), (-1, 1), (1, -1), (-1, -1))]
    if rot4: mats = [Matrix.Rotation(math.radians(90 * k), 4, 'Y') for k in range(4)]
    tmp = bpy.data.meshes.new("tmp"); src.to_mesh(tmp)
    for M in mats:
        me = tmp.copy(); me.transform(M)
        if M.determinant() < 0: me.flip_normals()
        out.from_mesh(me); bpy.data.meshes.remove(me)
    bpy.data.meshes.remove(tmp); src.free()
    for o in objs: bpy.data.objects.remove(o, do_unlink=True)
    # triangulate here: concave n-gons (hooked blades, notched block top) lose their caps in the Studio importer
    bmesh.ops.triangulate(out, faces=out.faces[:], quad_method='BEAUTY', ngon_method='BEAUTY')
    me = bpy.data.meshes.new(name); out.to_mesh(me); out.free()
    ob = bpy.data.objects.new(name, me); coll().objects.link(ob)
    return ob

def lantern_parts(tag, loc, base_y):
    """Lantern pavilion: stone pedestal, 6 gold columns round a cyan core, gold ring, ribbed blue dome, gold spike."""
    x, _, z = loc; y = base_y; out = {"stone": [], "gold": [], "blue": [], "glass": []}
    out["stone"].append(lathe_at(f"{tag}_ped", [(0, 0), (2.9, 0), (2.9, 0.6), (2.4, 0.9), (2.2, 4.0), (2.8, 4.4), (2.8, 5.0), (0, 5.0)], (x, y, z), 24))
    out["gold"].append(lathe_at(f"{tag}_band", [(2.95, 4.3), (3.0, 4.3), (3.0, 5.1), (2.95, 5.1)], (x, y, z), 24))
    out["glass"].append(lathe_at(f"{tag}_core", [(0, 5.0), (1.2, 5.3), (1.5, 7.8), (1.0, 10.0), (0, 10.4)], (x, y, z), 12))
    for i in range(6):
        a = 2 * math.pi * i / 6 + math.pi / 6
        out["gold"].append(lathe_at(f"{tag}_col{i}", [(0, 5.0), (0.32, 5.0), (0.24, 5.4), (0.24, 10.2), (0.36, 10.5), (0, 10.5)], (x + 2.15 * math.cos(a), y, z + 2.15 * math.sin(a)), 8))
    out["gold"].append(lathe_at(f"{tag}_ring", [(0, 10.4), (3.2, 10.4), (3.3, 10.8), (3.0, 11.2), (0, 11.2)], (x, y, z), 24))
    # ribbed dome: radius modulated by 12 ribs
    bm = bmesh.new(); seg, rows = 48, 10; ring = []
    for j in range(rows + 1):
        t = j / rows; ph = math.pi / 2 * t; r0 = 3.0 * math.cos(ph) * (1 + 0.12 * math.sin(math.pi * t)); yy = 11.2 + 3.9 * math.sin(ph)
        row = []
        for i in range(seg):
            a = 2 * math.pi * i / seg; rr = r0 * (1 + 0.06 * abs(math.cos(6 * a)))
            row.append(bm.verts.new((x + rr * math.cos(a), y + yy, z + rr * math.sin(a))))
        ring.append(row)
    for j in range(rows):
        for i in range(seg):
            bm.faces.new((ring[j][i], ring[j][(i + 1) % seg], ring[j + 1][(i + 1) % seg], ring[j + 1][i]))
    bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=1e-4); bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    out["blue"].append(mesh_obj(f"{tag}_dome", bm, True, 70))
    out["gold"].append(lathe_at(f"{tag}_spike", [(0, 14.9), (0.7, 15.0), (0.5, 15.6), (0.75, 16.0), (0.2, 17.4), (0, 18.2)], (x, y, z), 12))
    return out

def prism(name, quad, off):
    """Quad (4 points, any plane) swept by an offset vector: a slab with a sloping edge (wings, kerbs)."""
    bm = bmesh.new(); a = [bm.verts.new(p) for p in quad]; b = [bm.verts.new(Vector(p) + Vector(off)) for p in quad]
    bm.faces.new(a); bm.faces.new(list(reversed(b)))
    for i in range(4):
        j = (i + 1) % 4; bm.faces.new((a[i], b[i], b[j], a[j]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return flat(mesh_obj(name, bm, False))

def build_hero4():
    """One corner of the plaza hero piece (arched fountain gate + corner block + pool + lanterns), mirrored to 4."""
    clear_piece("K_Hero"); clear_piece("Q_")
    G = {"stone": [], "darkStone": [], "gold": [], "goldLan": [], "blue": [], "glass": [], "water": []}
    W0, W1 = 33.0, 36.0                       # arch band depth along the diagonal
    outer = arch_outline(10.0, 6.0, 6.0); inner = arch_outline(5.5, 5.0, 3.5)
    G["stone"].append(arch_band("Q_arch", outer, inner, W0, W1))
    G["gold"].append(tube_along("Q_gArchO", [P(u, y, W0 - 0.05) for u, y in outer], 0.38))
    G["gold"].append(tube_along("Q_gArchI", [P(u, y, W0 - 0.05) for u, y in inner], 0.34))
    G["gold"].append(tube_along("Q_gArchB", [P(u, y, W1 + 0.05) for u, y in outer], 0.3))
    # M crest: two horns with a 4-stud slot, gold outlined
    for s in (-1, 1):
        G["stone"].append(rbox_rot(f"Q_horn{s}", 4.0, 6.8, 3.0, P(s * 4.0, 13.1, (W0 + W1) / 2), math.radians(-45), 0.5, 2))
        hu0, hu1 = s * 2.0, s * 6.0
        G["gold"].append(tube_along(f"Q_gHorn{s}", [P(hu0, 11.6, W0 - 0.05), P(hu0, 16.5, W0 - 0.05), P(hu1, 16.5, W0 - 0.05), P(hu1, 10.6, W0 - 0.05)], 0.3))
    # shoulder wings: thick sloping walls from the arch shoulders back along the flight sides to the stair tops
    G["stone"].append(prism("Q_wingL", [(17, 6.0, -31.1), (17, 11.0, -31.1), (17, 7.2, -48), (17, 6.0, -48)], (2.6, 0, 0)))
    G["stone"].append(prism("Q_wingR", [(31.1, 6.0, -17), (31.1, 11.0, -17), (48, 7.2, -17), (48, 6.0, -17)], (0, 0, -2.6)))
    G["gold"].append(tube_along("Q_gWingL", [(16.95, 11.05, -31.1), (16.95, 7.25, -48)], 0.32))
    G["gold"].append(tube_along("Q_gWingR", [(31.1, 11.05, -16.95), (48, 7.25, -16.95)], 0.32))
    # niche: dark slate back wall, sides and top; gold shelf; glass fall
    G["darkStone"].append(rbox_rot("Q_nicheBack", 11.2, 11.0, 0.8, P(0, 5.5, 39.4), math.radians(-45), 0.2, 1))
    for s in (-1, 1):
        G["darkStone"].append(rbox_rot(f"Q_nicheSide{s}", 0.8, 11.0, 4.0, P(s * 5.6, 5.5, 37.5), math.radians(-45), 0.2, 1))
    G["darkStone"].append(rbox_rot("Q_nicheTop", 11.2, 0.8, 4.0, P(0, 10.6, 37.5), math.radians(-45), 0.2, 1))
    G["gold"].append(rbox_rot("Q_shelf", 10.6, 0.6, 1.6, P(0, 6.2, 38.4), math.radians(-45), 0.2, 1))
    G["glass"].append(rbox_rot("Q_fall", 3.0, 5.2, 0.5, P(0, 4.0, 38.6), math.radians(-45), 0.2, 1))
    # corner block (terrace mass, y 0..6) with a notch behind the arch opening
    poly = [P(-10, 0, 34), P(-5.5, 0, 34), P(-5.5, 0, 39), P(5.5, 0, 39), P(5.5, 0, 34), P(10, 0, 34), (62, 0, -17), (62, 0, -62), (17, 0, -62)]
    G["stone"].append(extrude_plan("Q_block", [(p[0], p[2]) for p in poly], 0.0, 6.0))
    G["gold"].append(tube_along("Q_gTopL", [(17, 6.05, -62), (17, 6.05, -31.1), P(-10, 6.05, 34), P(-5.5, 6.05, 34)], 0.3))
    G["gold"].append(tube_along("Q_gTopR", [(62, 6.05, -17), (31.1, 6.05, -17), P(10, 6.05, 34), P(5.5, 6.05, 34)], 0.3))
    G["gold"].append(tube_along("Q_gStrL", [(17.05, 0.9, -28), (17.05, 6.6, -48)], 0.28))
    G["gold"].append(tube_along("Q_gStrR", [(28, 0.9, -17.05), (48, 6.6, -17.05)], 0.28))
    # two-tier basin in front of the arch
    bx, _, bz = P(0, 0, 27.5)
    G["gold"].append(lathe_at("Q_basinFoot", [(0, 0), (6.3, 0), (6.3, 0.5), (0, 0.5)], (bx, 0, bz), 40, False))
    G["stone"].append(lathe_at("Q_basin", [(0, 0.5), (5.6, 0.5), (5.6, 2.5), (4.9, 2.5), (4.9, 1.6), (3.0, 1.6), (3.0, 3.9), (2.5, 3.9), (2.5, 3.3), (0, 3.3)], (bx, 0, bz), 40))
    G["gold"].append(tube_along("Q_gBasinA", [(bx + 5.25 * math.cos(2 * math.pi * i / 48), 2.55, bz + 5.25 * math.sin(2 * math.pi * i / 48)) for i in range(48)], 0.36, closed=True))
    G["gold"].append(tube_along("Q_gBasinB", [(bx + 2.75 * math.cos(2 * math.pi * i / 32), 3.95, bz + 2.75 * math.sin(2 * math.pi * i / 32)) for i in range(32)], 0.28, closed=True))
    G["water"].append(lathe_at("Q_wBasinA", [(0, 2.15), (4.95, 2.15)], (bx, 0, bz), 40))
    G["water"].append(lathe_at("Q_wBasinB", [(0, 3.65), (2.55, 3.65)], (bx, 0, bz), 24))
    G["glass"].append(lathe_at("Q_jet", [(0, 3.6), (0.7, 3.8), (0.45, 5.6), (0.0, 6.4)], (bx, 0, bz), 12))
    # raised pool behind the arch: round rim, water 1 below the rim top, rock island
    px, _, pz = P(0, 0, 56.6)
    G["stone"].append(lathe_at("Q_poolRim", [(14.4, 6.0), (16.6, 6.0), (16.6, 7.6), (16.2, 8.0), (14.8, 8.0), (14.4, 7.6), (14.4, 6.0)], (px, 0, pz), 48))
    G["gold"].append(tube_along("Q_gPool", [(px + 16.6 * math.cos(2 * math.pi * i / 64), 7.7, pz + 16.6 * math.sin(2 * math.pi * i / 64)) for i in range(64)], 0.3, closed=True))
    G["water"].append(lathe_at("Q_wPool", [(0, 7.0), (14.45, 7.0)], (px, 0, pz), 48))
    G["darkStone"].append(lathe_at("Q_rock", [(0, 6.0), (5.0, 6.0), (4.6, 7.8), (3.2, 9.2), (1.2, 9.8), (0, 9.8)], (px, 0, pz), 9, False))
    for s in (-1, 1):
        L = lantern_parts(f"Q_lan{s}", P(s * 14.0, 0, 52.0), 6.0)
        for k, v in L.items(): G["goldLan" if k == "gold" else k] += v  # split: one gold mesh would pass 20k tris
    out = []
    for k, objs in G.items():
        if objs: out.append(merge_objs(f"K_Hero_{k}", objs, mirror4=True).name)
    return out

def build_stairs4():
    """Four 8-step flights (foot d=28, top d=48, 34 wide) with a sunken blue ramp runner, gold kerbs and Y chevron."""
    clear_piece("K_Stairs"); clear_piece("Q_")
    G = {"stone": [], "blue": [], "gold": [], "glass": []}
    rise, tread, d0, n = 0.75, 2.5, 28.0, 8
    for i in range(n):
        h = rise * (i + 1); dc = d0 + tread * i + tread / 2
        widths = [4.5, 4.5, 4.4] if i % 2 == 0 else [2.25, 4.5, 4.5, 2.15]
        for s in (-1, 1):
            x = 4.1
            for wdt in widths:
                o = rbox(f"Q_st{i}_{s}_{x:.1f}", wdt - 0.08, h, tread - 0.05, bevel=0.18, segs=1, loc=(s * (x + wdt / 2), h / 2, -dc))
                G["stone"].append(flat(o)); x += wdt
    ramp = lambda d: 0.4 + (d - d0) * (6.0 - 0.4) / (tread * n)
    G["blue"].append(extrude_side("Q_ramp", [(d0, 0), (d0, ramp(d0)), (d0 + 20, ramp(d0 + 20)), (d0 + 20, 0)], -3.5, 3.5))
    for s in (-1, 1):
        G["gold"].append(extrude_side(f"Q_kerb{s}", [(d0 - 0.3, 0), (d0 - 0.3, 0.75), (d0 + 20, 6.3), (d0 + 20, 0)], s * 3.5, s * 4.1))
    yy = lambda d: ramp(d) + 0.04
    G["gold"].append(tube_along("Q_Ystem", [(0, yy(d), -d) for d in (31.5, 40.0)], 0.24))
    for s in (-1, 1):
        G["gold"].append(tube_along(f"Q_Yarm{s}", [(0, yy(40.0), -40.0), (s * 2.7, yy(46.5), -46.5), (s * 2.7, yy(47.8), -47.8)], 0.24))
        G["gold"].append(tube_along(f"Q_Yside{s}", [(s * 2.8, yy(d), -d) for d in (29.5, 44.0)], 0.16))
    G["glass"].append(lathe_at("Q_gem", [(0, 0), (1.2, 0), (1.0, 0.18), (0, 0.22)], (0, ramp(29.6) + 0.04, -29.6), 16))
    return [merge_objs(f"K_Stairs_{k}", objs, rot4=True).name for k, objs in G.items()]

def blade_outline(a0, r0=2.3, r1=7.0, sweep=1.15, w=1.25, n=14):
    L, R = [], []
    for k in range(n + 1):
        t = k / n; r = r0 + (r1 - r0) * t; th = a0 + sweep * t ** 1.5
        hw = w * (1 - t) ** 0.7 + 0.04; d = hw / r
        L.append((r * math.cos(th + d), r * math.sin(th + d))); R.append((r * math.cos(th - d), r * math.sin(th - d)))
    tip = (r1 * 0.93 * math.cos(a0 + sweep + 0.32), r1 * 0.93 * math.sin(a0 + sweep + 0.32))  # hooked tip
    return L + [tip] + list(reversed(R))

def build_floor4():
    """Floor inlays and medallion: centre diamond dais, slate bands, flush gold inlays, 8 hooked blades, gold disc."""
    clear_piece("K_Medal"); clear_piece("Q_")
    G = {"pale": [], "slate": [], "gold": [], "blue": [], "darkStone": []}
    dia = lambda r: [(0, -r), (r, 0), (0, r), (-r, 0)]
    G["pale"].append(extrude_plan("Q_dais", dia(20.0), 0.0, 0.3))
    for k in range(4):
        a, b = dia(20.0)[k], dia(20.0)[(k + 1) % 4]; A, B = dia(23.5)[k], dia(23.5)[(k + 1) % 4]
        G["slate"].append(extrude_plan(f"Q_band{k}", [a, b, B, A], 0.0, 0.04))
    for r, nm in ((20.0, "a"), (23.5, "b"), (17.6, "c")):
        G["gold"].append(tube_along(f"Q_gDia{nm}", [(x, 0.3 if r < 21 else 0.04, z) for x, z in dia(r)], 0.22 if r != 17.6 else 0.15, closed=True))
    G["pale"].append(lathe_at("Q_medal", [(0, 0.3), (7.6, 0.3), (7.6, 0.42), (0, 0.42)], (0, 0, 0), 64, False))
    G["gold"].append(tube_along("Q_gMedal", [(7.6 * math.cos(2 * math.pi * i / 64), 0.42, 7.6 * math.sin(2 * math.pi * i / 64)) for i in range(64)], 0.3, closed=True))
    for i in range(8):
        o = extrude_outline(f"Q_blade{i}", blade_outline(2 * math.pi * i / 8), 0.1, bevel=0.0)
        o.rotation_euler = (math.radians(90), 0, 0); o.location = (0, 0.46, 0); flat(o)
        o.data.flip_normals()  # the hooked outline comes out inside-out from extrude_outline: checked top faces pointed down
        G["darkStone"].append(o)
        a = 2 * math.pi * (i + 0.5) / 8
        G["gold"].append(lathe_at(f"Q_stud{i}", [(0, 0.42), (0.45, 0.42), (0.3, 0.62), (0, 0.66)], (6.6 * math.cos(a), 0, 6.6 * math.sin(a)), 10))
    G["gold"].append(lathe_at("Q_disc", [(0, 0.42), (2.0, 0.42), (2.0, 0.66), (1.8, 0.74), (0, 0.74)], (0, 0, 0), 32))
    G["darkStone"].append(lathe_at("Q_discRing", [(0.9, 0.745), (1.25, 0.745)], (0, 0, 0), 24, False))
    # per arm (north authored, rotated x4): flush runner inlay from the dais tip to the stair foot, slate foot band
    G["blue"].append(extrude_plan("Q_run", [(-3.5, -19.5), (3.5, -19.5), (3.5, -28.2), (-3.5, -28.2)], 0.0, 0.06))
    for s in (-1, 1):
        G["gold"].append(extrude_plan(f"Q_runK{s}", [(s * 3.5, -19.0), (s * 4.0, -19.0), (s * 4.0, -28.2), (s * 3.5, -28.2)], 0.0, 0.08))
    G["slate"].append(extrude_plan("Q_foot", [(-17, -25.0), (17, -25.0), (17, -28.0), (-17, -28.0)], 0.0, 0.04))
    G["gold"].append(tube_along("Q_gFoot", [(-17, 0.04, -24.9), (-4.0, 0.04, -24.9)], 0.18)); G["gold"].append(tube_along("Q_gFoot2", [(4.0, 0.04, -24.9), (17, 0.04, -24.9)], 0.18))
    out = []
    for k, objs in G.items():
        arm = [o for o in objs if o.name.startswith(("Q_run", "Q_foot", "Q_gFoot"))]
        one = [o for o in objs if o not in arm]
        parts = []
        if one: parts.append(merge_objs(f"Q1_{k}", one))
        if arm: parts.append(merge_objs(f"Q4_{k}", arm, rot4=True))
        out.append(merge_objs(f"K_Medal_{k}", parts).name)
    return out

def build_bollard4():
    clear_piece("K_Bollard")
    flat(rbox("K_Bollard_white", 2.5, 1.2, 2.5, bevel=0.2, segs=2, loc=(0, 0.6, 0)))
    lathe("K_Bollard_gold", [(0, 1.2), (0.85, 1.2), (0.85, 1.4)] + [(0.8 * math.cos(t), 1.4 + 0.9 * math.sin(t)) for t in [math.pi / 2 * k / 6 for k in range(1, 7)]] + [(0, 2.6)], seg=16)

def build_all4():
    names = build_hero4() + build_stairs4() + build_floor4(); build_bollard4()
    return names

# ---------------------------------------------------------------- pass 5: deeper gate + U crest, foliage kit, islands
# Freestyle from the picture set and the round-2 review. Same plaza frame as pass 4.
import random

def ds_quad(bm, pts, off=0.03):
    """Double-sided polygon: the face plus a reversed copy pushed back along its normal (Roblox culls back faces)."""
    vs = [bm.verts.new(p) for p in pts]
    f = bm.faces.new(vs); f.normal_update(); n = f.normal.copy()
    bm.faces.new([bm.verts.new(Vector(p) - n * off) for p in reversed(pts)])

def card(bmA, bmB, b, d, L, W, droop=0.25, roll=0.0, prof=(0.08, 0.5, 0.42, 0.22, 0.0), ts=(0, 0.3, 0.6, 0.85, 1.0), nA=2):
    """Spiky leaf card from base b along unit d: drooping midrib, pointed tip. First nA segments go to bmA (leaf), the
    rest to bmB (lighter rim colour), so each card shades from base to tip."""
    b = Vector(b); d = Vector(d).normalized()
    ref = Vector((0, 1, 0)) if abs(d.y) < 0.9 else Vector((1, 0, 0))
    s = d.cross(ref).normalized()
    if roll: s = Matrix.Rotation(roll, 3, d) @ s
    down = Vector((0, -1, 0))
    C = [b + d * (L * t) + down * (droop * L * t * t) for t in ts]
    Lp = [c + s * (W * w) for c, w in zip(C, prof)]; Rp = [c - s * (W * w) for c, w in zip(C, prof)]
    for i in range(len(ts) - 1):
        bm = bmA if i < nA else bmB
        if prof[i + 1] == 0: ds_quad(bm, [Lp[i], C[i + 1], Rp[i]])
        else: ds_quad(bm, [Lp[i], Lp[i + 1], Rp[i + 1], Rp[i]])

def bm_obj(name, bm, smooth=False):
    o = mesh_obj(name, bm, smooth, 60)
    if not smooth: flat(o)
    return o

def ico(bm, c, r, sub=1, sq=(1, 1, 1)):
    tmp = bmesh.new(); bmesh.ops.create_icosphere(tmp, subdivisions=sub, radius=r)
    me = bpy.data.meshes.new("tmp")
    for v in tmp.verts: v.co = Vector((v.co.x * sq[0], v.co.y * sq[1], v.co.z * sq[2])) + Vector(c)
    tmp.to_mesh(me); tmp.free(); bm.from_mesh(me); bpy.data.meshes.remove(me)

def build_cardtree(tag, seed, H=20.0, R=8.0, nclus=9, ncard=16, trunk_r=0.9, cl=4.0):
    """Spiky leaf-card tree: curved trunk + branches, canopy of card clusters round small dark cores.
    Meshes: K_<tag>_wood, K_<tag>_leaf (core + card bases), K_<tag>_leafRim (card tips, lighter)."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    A, B = bmesh.new(), bmesh.new(); wood = []
    lean = random.uniform(-0.12, 0.12) * H
    C = Vector((lean, H - R * 0.5, random.uniform(-0.05, 0.05) * H))
    wood.append(tube_along("Q_trunk", [(0, -0.5, 0), (0.05 * lean, H * 0.25, 0), (0.5 * lean, H * 0.5, C.z * 0.5), (C.x, C.y - R * 0.15, C.z)], trunk_r))
    wood.append(lathe_at("Q_flare", [(0, 0), (trunk_r * 2.2, 0), (trunk_r * 1.1, trunk_r * 1.6), (0, trunk_r * 2.5)], (0, -0.3, 0), 10, False))
    cents = [C + Vector((0, R * 0.42, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.3, 0.3); e = random.uniform(-0.45, 0.6)
        cents.append(C + Vector((R * 0.62 * math.cos(a) * math.cos(e), R * 0.42 * math.sin(e), R * 0.62 * math.sin(a) * math.cos(e))))
    for k, c in enumerate(cents[1:]):
        if k % 2 == 0: wood.append(tube_along(f"Q_br{k}", [tuple(C - Vector((0, R * 0.35, 0))), tuple(c.lerp(C, 0.25))], trunk_r * 0.4))
    for c in cents:
        ico(A, c, cl * 0.55, 1, (1, 0.75, 1))
        out = (c - C); out = out.normalized() if out.length > 0.1 else Vector((0, 1, 0))
        for j in range(ncard):
            rd = Vector((random.gauss(0, 1), random.gauss(0, 1), random.gauss(0, 1))).normalized()
            d = (out * 0.9 + rd).normalized(); d.y = max(d.y, -0.35); d.normalize()
            L = cl * random.uniform(0.8, 1.25)
            card(A, B, c + d * cl * 0.25, d, L, L * 0.3, 0.22, random.uniform(-0.6, 0.6))
    o1 = merge_objs(f"K_{tag}_wood", wood); bm_obj(f"K_{tag}_leaf", A); bm_obj(f"K_{tag}_leafRim", B)
    return o1

def build_palm5(tag, seed, H=25.0, nf=9, FL=9.0, bend=3.5):
    """Palm: curved trunk with ring bulges, crown of nf arched fronds with spiky leaflet cards on both sides."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    A, B = bmesh.new(), bmesh.new(); wood = []
    tp = lambda t: Vector((bend * t * t, H * t, 0.3 * bend * t * t))
    wood.append(tube_along("Q_trunk", [tuple(tp(i / 10)) for i in range(11)], 0.7))
    for i in range(1, 14):
        p = tp(i / 14); wood.append(lathe_at(f"Q_ring{i}", [(0, -0.25), (0.95, -0.1), (0.95, 0.1), (0, 0.25)], tuple(p), 8, False))
    top = tp(1.0); wood.append(lathe_at("Q_boss", [(0, -1.0), (1.1, -0.6), (1.2, 0.3), (0.5, 0.9), (0, 1.0)], tuple(top), 10, False))
    for i in range(nf):
        a = 2 * math.pi * i / nf + random.uniform(-0.2, 0.2); hz = Vector((math.cos(a), 0, math.sin(a)))
        fl = FL * random.uniform(0.85, 1.1); rise = random.uniform(0.35, 0.6)
        q = lambda s: top + hz * (fl * s) + Vector((0, fl * (rise * s - 0.85 * s * s), 0))
        side = hz.cross(Vector((0, 1, 0))).normalized()
        for k in range(1, 15):
            s = k / 15; p = q(s); tan = (q(min(1, s + 0.05)) - q(max(0, s - 0.05))).normalized()
            ll = fl * (0.36 * math.sin(math.pi * min(1.0, s * 1.15)) + 0.06)
            for sg in (-1, 1):
                d = (side * sg + tan * 0.75 + Vector((0, -0.35, 0))).normalized()
                card(A if s < 0.55 else B, B, p, d, ll, 0.36, 0.15, 0.4 * sg, (0.15, 0.6, 0.5, 0.3, 0.0), nA=2 if s < 0.55 else 0)
        for k in range(14):  # rachis strip
            p0, p1 = q(k / 14), q((k + 1) / 14)
            ds_quad(A if k < 7 else B, [p0 - side * 0.18, p1 - side * 0.12, p1 + side * 0.12, p0 + side * 0.18])
    merge_objs(f"K_{tag}_wood", wood); bm_obj(f"K_{tag}_leaf", A); bm_obj(f"K_{tag}_leafRim", B)

def build_cypress5(tag="Cypress", seed=7, H=12.0, Rb=1.6):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    A, B = bmesh.new(), bmesh.new()
    wood = [tube_along("Q_trunk", [(0, -0.3, 0), (0, 2.0, 0)], 0.35)]
    core = lathe_at("Q_core", [(0, 1.2), (Rb * 0.8, 1.6), (Rb * 0.55, H * 0.6), (0, H)], (0, 0, 0), 10, False)
    for j in range(12):
        t = j / 12; y = 1.6 + t * (H - 2.4); r = Rb * (1 - t) * 0.8 + 0.15
        for i in range(9):
            a = 2 * math.pi * (i + 0.5 * (j % 2)) / 9 + random.uniform(-0.2, 0.2)
            d = Vector((math.cos(a) * 0.55, 1.0, math.sin(a) * 0.55)).normalized()
            card(A, B, (r * 0.7 * math.cos(a), y, r * 0.7 * math.sin(a)), d, 2.3 * (1 - 0.4 * t), 0.7 * (1 - 0.3 * t), -0.05, 0)
    merge_objs(f"K_{tag}_wood", wood); lo = merge_objs("Q_l", [core])
    bmA = bmesh.new(); bmA.from_mesh(lo.data); bpy.data.objects.remove(lo, do_unlink=True)
    tmp = bpy.data.meshes.new("t"); A.to_mesh(tmp); A.free(); bmA.from_mesh(tmp); bpy.data.meshes.remove(tmp)
    bm_obj(f"K_{tag}_leaf", bmA); bm_obj(f"K_{tag}_leafRim", B)

def build_fern5(tag="Fern", seed=9, n=13):
    """Flat fern clump about 3.4 across x 0.7 tall: radiating drooping spiky cards (one tint per zone at placement)."""
    random.seed(seed); clear_piece(f"K_{tag}_")
    A, B = bmesh.new(), bmesh.new()
    for i in range(n):
        a = 2 * math.pi * i / n + random.uniform(-0.2, 0.2)
        d = Vector((math.cos(a), random.uniform(0.35, 0.7), math.sin(a))).normalized()
        card(A, B, (0, 0.05, 0), d, random.uniform(1.4, 1.9), 0.42, 0.45, random.uniform(-0.5, 0.5))
    for i in range(5):
        a = random.uniform(0, 2 * math.pi); d = Vector((math.cos(a) * 0.5, 1, math.sin(a) * 0.5)).normalized()
        card(A, B, (0, 0.05, 0), d, 1.1, 0.35, 0.35, random.uniform(-1, 1))
    bm_obj(f"K_{tag}_leaf", A); bm_obj(f"K_{tag}_leafRim", B)

def build_crystal5():
    clear_piece("K_Crystal_"); objs = []
    for k, (h, r, tilt, ox) in enumerate(((5.0, 1.0, 0.0, 0.0), (3.4, 0.75, 0.45, 1.3), (2.8, 0.6, -0.5, -1.1))):
        o = lathe(f"Q_cr{k}", [(0, 0), (r, 0.5), (r, h * 0.75), (0, h)], seg=6, smooth=False)
        o.location = (ox, -0.3, 0.3 * k); o.rotation_euler = (0, k * 0.7, tilt); flat(o); objs.append(o)
    merge_objs("K_Crystal_glass", objs)

def build_island5(seed=21, R=36.0):
    """Floating island ~72 across: faceted rock underside, grass cap, two ruin towers, a domed shrine, two waterfalls."""
    random.seed(seed); clear_piece("K_Island_"); clear_piece("Q_")
    prof = [(0, -30), (4, -27), (9, -21), (15, -15), (22, -9), (29, -4), (R, -0.5), (R, 0.2)]
    rock = lathe("Q_rock", prof, seg=18, smooth=False)
    for v in rock.data.vertices:
        if v.co.y < -0.3:
            f = 1 + random.uniform(-0.12, 0.12); v.co.x *= f; v.co.z *= f; v.co.y += random.uniform(-1.5, 1.5)
    grass = [lathe_at("Q_cap", [(0, 0.2), (R + 0.6, 0.2), (R + 0.6, 1.2), (R - 1.5, 2.2), (0, 2.2)], (0, 0, 0), 24, False)]
    stone = []
    for k, (x, z, h) in enumerate(((11, -9, 15.0), (-16, 5, 10.0), (4, 16, 7.0))):
        stone.append(lathe_at(f"Q_tw{k}", [(0, 0), (3.6, 0), (3.6, 1), (3.0, 1.3), (3.0, h), (3.5, h + 0.5), (3.5, h + 1.6), (0, h + 1.6)], (x, 2.0, z), 10, False))
        for j in range(4):  # broken crenels
            a = 2 * math.pi * j / 4 + k
            if random.random() < 0.75: stone.append(rbox_rot(f"Q_cr{k}{j}", 1.4, 1.5, 1.4, (x + 3.0 * math.cos(a), 2.0 + h + 2.2, z + 3.0 * math.sin(a)), a, 0.15, 1))
    stone.append(lathe_at("Q_shrine", [(0, 0), (6.5, 0), (6.5, 1), (5.5, 1.3), (5.5, 7.5), (6.2, 8.0), (0, 8.0)], (-4, 2.0, -14), 16, False))
    dome = [lathe_at("Q_dome", [(5.8 * math.cos(t), 10.0 + 5.2 * math.sin(t)) for t in [math.pi / 2 * i / 6 for i in range(7)]], (-4, 0, -14), 16, False)]
    fall = []
    for k, a in enumerate((0.35, 2.4)):
        x, z = (R + 0.4) * math.cos(a), (R + 0.4) * math.sin(a)
        fall.append(rbox_rot(f"Q_fall{k}", 4.5, 55.0, 0.8, (x, -26.0, z), -a + math.pi / 2, 0.3, 1))
        fall.append(lathe_at(f"Q_lip{k}", [(0, 0), (2.6, 0.2), (2.4, 1.0), (0, 1.2)], (x, 0.6, z), 8, False))
    merge_objs("K_Island_rock", [rock]); merge_objs("K_Island_grass", grass); merge_objs("K_Island_stone", stone)
    merge_objs("K_Island_gold", dome); merge_objs("K_Island_foam", fall)

def build_ring5():
    """Story portal ring, vertical, facing +X: silver torus 12 across x 2 thick with a gold crown of 5 spikes."""
    clear_piece("K_Ring_"); clear_piece("Q_")
    t = lathe("Q_torus", [(5.0 + 1.0 * math.cos(a), 1.0 * math.sin(a)) for a in [2 * math.pi * i / 12 for i in range(13)]], seg=40)
    t.rotation_euler = (0, 0, math.radians(90)); t.location = (0, 7.5, 0)
    gold = []
    for k in range(5):
        a = math.radians(90 + (k - 2) * 22); h = 2.6 if k == 2 else 1.7
        o = lathe(f"Q_sp{k}", [(0, 0), (0.6, 0), (0.15, h), (0, h + 0.2)], seg=6, smooth=False)
        o.rotation_euler = (a - math.pi / 2, 0, 0); o.location = (0, 7.5 + 6.6 * math.sin(a), 6.6 * math.cos(a)); gold.append(o)
    b = lathe("Q_band", [(5.9 + 0.35 * math.cos(a), 0.35 * math.sin(a)) for a in [2 * math.pi * i / 8 for i in range(9)]], seg=40)
    b.rotation_euler = (0, 0, math.radians(90)); b.location = (0, 7.5, 0); gold.append(b)
    merge_objs("K_Ring_silver", [t]); merge_objs("K_Ring_gold", gold)

def split_by_normal(o, new_name, keep=lambda n: abs(n.y) > 0.7):
    """Move faces that fail keep(normal) into a new object (e.g. stair risers vs treads), Y-up data."""
    bm = bmesh.new(); bm.from_mesh(o.data); bm2 = bm.copy()
    bmesh.ops.delete(bm, geom=[f for f in bm.faces if not keep(f.normal)], context='FACES')
    bmesh.ops.delete(bm2, geom=[f for f in bm2.faces if keep(f.normal)], context='FACES')
    bm.to_mesh(o.data); bm.free()
    me = bpy.data.meshes.new(new_name); bm2.to_mesh(me); bm2.free()
    ob = bpy.data.objects.new(new_name, me); coll().objects.link(ob); return ob

def extrude_uy(name, outline_uy, w0, w1):
    """(u, y) outline in the gate plane extruded along the diagonal from depth w0 to w1 (solid, flat)."""
    bm = bmesh.new(); F = [bm.verts.new(P(u, y, w0)) for u, y in outline_uy]; Bk = [bm.verts.new(P(u, y, w1)) for u, y in outline_uy]
    bm.faces.new(F); bm.faces.new(list(reversed(Bk))); n = len(F)
    for i in range(n):
        j = (i + 1) % n; bm.faces.new((F[i], Bk[i], Bk[j], F[j]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return flat(mesh_obj(name, bm, False))

def lantern5(tag, loc, base_y, sc=1.4):
    """Pass-4 lantern scaled 1.4x about its base: the 5-tall pedestal becomes a 7-tall drum; tip at base + 25.5."""
    L = lantern_parts(tag, (0, 0, 0), 0.0)
    for objs in L.values():
        for o in objs:
            o.location = Vector((loc[0], base_y, loc[2])) + Vector(o.location) * sc
            o.scale = (sc, sc, sc)
    return L

def build_hero5():
    """Corner hero piece, pass 5: 20x10 gate with a 6.5-deep stepped vault (2 ribs), squared-U crest to 13.5,
    basin moved out under the arch with a gold bar grille, foamy cascade, lanterns 1.4x on drums, pool pulled in.
    Gold is split gold / goldBas (basin) / goldLan (lanterns) to keep each MeshPart under 20k triangles."""
    clear_piece("K_Hero"); clear_piece("Q_")
    G = {"stone": [], "rib": [], "darkStone": [], "gold": [], "goldBas": [], "goldLan": [], "blue": [], "glass": [], "water": [], "foam": []}
    W0, W1 = 33.0, 39.5
    outer = arch_outline(10.0, 5.0, 5.0); in1 = arch_outline(7.6, 4.2, 4.0); in2 = arch_outline(7.0, 4.0, 3.6); in3 = arch_outline(6.5, 3.8, 3.2)
    G["stone"].append(arch_band("Q_arch", outer, in1, W0, W1))
    G["rib"].append(arch_band("Q_rib1", in1, in2, W0 + 0.7, W1))
    G["darkStone"].append(arch_band("Q_rib2", in2, in3, W0 + 1.4, W1))
    G["gold"].append(tube_along("Q_gArchO", [P(u, y, W0 - 0.05) for u, y in outer], 0.4))
    G["gold"].append(tube_along("Q_gArchI", [P(u, y, W0 - 0.05) for u, y in in1], 0.32))
    G["gold"].append(tube_along("Q_gArchB", [P(u, y, W1 + 0.05) for u, y in outer], 0.3))
    # squared-U crest: two 3-wide pillars and a bottom bar, slot 2 wide, top 13.5, one continuous gold outline
    U = [(-4.2, 8.6), (-4.2, 13.5), (-1.0, 13.5), (-1.0, 10.8), (1.0, 10.8), (1.0, 13.5), (4.2, 13.5), (4.2, 8.6)]
    G["stone"].append(extrude_uy("Q_crest", U, W0 + 0.4, W0 + 3.6))
    G["gold"].append(tube_along("Q_gCrest", [P(u, max(y, 9.45), W0 + 0.35) for u, y in U], 0.32))
    G["gold"].append(tube_along("Q_gCrestB", [P(u, max(y, 9.45), W0 + 3.65) for u, y in U], 0.26))
    # shoulder wings (as pass 4, lowered to the new band top)
    G["stone"].append(prism("Q_wingL", [(17, 6.0, -31.1), (17, 10.0, -31.1), (17, 7.2, -48), (17, 6.0, -48)], (2.6, 0, 0)))
    G["stone"].append(prism("Q_wingR", [(31.1, 6.0, -17), (31.1, 10.0, -17), (48, 7.2, -17), (48, 6.0, -17)], (0, 0, -2.6)))
    G["gold"].append(tube_along("Q_gWingL", [(16.95, 10.05, -31.1), (16.95, 7.25, -48)], 0.32))
    G["gold"].append(tube_along("Q_gWingR", [(31.1, 10.05, -16.95), (48, 7.25, -16.95)], 0.32))
    # vault interior: dark back wall, gold shelf, foamy cascade into the upper basin
    G["darkStone"].append(rbox_rot("Q_nicheBack", 13.4, 7.4, 0.8, P(0, 3.7, 40.2), math.radians(-45), 0.2, 1))
    G["darkStone"].append(rbox_rot("Q_nicheTop", 13.4, 0.8, 1.6, P(0, 7.2, 40.0), math.radians(-45), 0.2, 1))
    G["gold"].append(rbox_rot("Q_shelf", 12.6, 0.5, 1.4, P(0, 5.0, 39.3), math.radians(-45), 0.2, 1))
    G["darkStone"].append(rbox_rot("Q_shelfBk", 12.6, 0.8, 0.8, P(0, 6.0, 39.6), math.radians(-45), 0.2, 1))
    G["foam"].append(prism("Q_fall", [P(-1.5, 5.3, 38.6), P(1.5, 5.3, 38.6), P(1.5, 3.9, 34.4), P(-1.5, 3.9, 34.4)], (0, -0.35, 0)))
    G["foam"].append(lathe_at("Q_splash", [(0, 3.85), (1.6, 3.85), (1.2, 4.5), (0.4, 4.9), (0, 4.95)], P(0, 0, 33.6), 10, False))
    # corner block (y 0..6) with a deeper notch behind the vault
    poly = [P(-10, 0, 34), P(-6.5, 0, 34), P(-6.5, 0, 41), P(6.5, 0, 41), P(6.5, 0, 34), P(10, 0, 34), (62, 0, -17), (62, 0, -62), (17, 0, -62)]
    G["stone"].append(extrude_plan("Q_block", [(p[0], p[2]) for p in poly], 0.0, 6.0))
    G["gold"].append(tube_along("Q_gTopL", [(17, 6.05, -62), (17, 6.05, -31.1), P(-10, 6.05, 34)], 0.3))
    G["gold"].append(tube_along("Q_gTopR", [(62, 6.05, -17), (31.1, 6.05, -17), P(10, 6.05, 34)], 0.3))
    G["gold"].append(tube_along("Q_gStrL", [(17.05, 0.9, -28), (17.05, 6.6, -48)], 0.28))
    G["gold"].append(tube_along("Q_gStrR", [(28, 0.9, -17.05), (48, 6.6, -17.05)], 0.28))
    # two-tier basin, moved out so its back rim sits under the arch; gold bar grille round the upper tier
    bx, _, bz = P(0, 0, 31.6)
    G["goldBas"].append(lathe_at("Q_basinFoot", [(0, 0), (6.4, 0), (6.4, 0.45), (6.0, 0.6), (0, 0.6)], (bx, 0, bz), 40, False))
    G["stone"].append(lathe_at("Q_basin", [(0, 0.6), (5.6, 0.6), (5.6, 2.4), (4.9, 2.4), (4.9, 1.6), (3.0, 1.6), (3.0, 3.9), (2.5, 3.9), (2.5, 3.3), (0, 3.3)], (bx, 0, bz), 40))
    G["rib"].append(lathe_at("Q_basinBand", [(5.65, 0.9), (5.75, 1.0), (5.75, 1.6), (5.65, 1.7)], (bx, 0, bz), 40))
    G["goldBas"].append(tube_along("Q_gBasinA", [(bx + 5.25 * math.cos(2 * math.pi * i / 48), 2.45, bz + 5.25 * math.sin(2 * math.pi * i / 48)) for i in range(48)], 0.38, closed=True))
    G["goldBas"].append(tube_along("Q_gBasinB", [(bx + 2.75 * math.cos(2 * math.pi * i / 32), 3.95, bz + 2.75 * math.sin(2 * math.pi * i / 32)) for i in range(32)], 0.28, closed=True))
    for i in range(16):
        a = 2 * math.pi * i / 16
        G["goldBas"].append(rbox(f"Q_bar{i}", 0.22, 1.3, 0.22, 0.05, 1, (bx + 3.08 * math.cos(a), 2.6, bz + 3.08 * math.sin(a))))
    G["water"].append(lathe_at("Q_wBasinA", [(0, 2.05), (4.95, 2.05)], (bx, 0, bz), 40))
    G["water"].append(lathe_at("Q_wBasinB", [(0, 3.65), (2.55, 3.65)], (bx, 0, bz), 24))
    # raised pool behind the gate, pulled in 1.6 and narrowed to r 14.5
    px, _, pz = P(0, 0, 55.0)
    G["stone"].append(lathe_at("Q_poolRim", [(12.4, 6.0), (14.5, 6.0), (14.5, 7.6), (14.1, 8.0), (12.8, 8.0), (12.4, 7.6), (12.4, 6.0)], (px, 0, pz), 48))
    G["gold"].append(tube_along("Q_gPool", [(px + 14.5 * math.cos(2 * math.pi * i / 64), 7.7, pz + 14.5 * math.sin(2 * math.pi * i / 64)) for i in range(64)], 0.3, closed=True))
    G["water"].append(lathe_at("Q_wPool", [(0, 7.0), (12.45, 7.0)], (px, 0, pz), 48))
    G["darkStone"].append(lathe_at("Q_rock", [(0, 6.0), (4.5, 6.0), (4.1, 7.8), (2.8, 9.2), (1.0, 9.8), (0, 9.8)], (px, 0, pz), 9, False))
    for s in (-1, 1):
        L = lantern5(f"Q_lan{s}", P(s * 14.0, 0, 52.0), 6.0)
        for k, v in L.items(): G["goldLan" if k == "gold" else k] += v
    out = []
    for k, objs in G.items():
        if objs: out.append(merge_objs(f"K_Hero_{k}", objs, mirror4=True).name)
    # turf: the corner-block top faces (y = 6, facing up) become a separate grass mesh
    st = bpy.data.objects["K_Hero_stone"]
    bm = bmesh.new(); bm.from_mesh(st.data); bm2 = bm.copy()
    def top(f):
        c = f.calc_center_median()
        return f.normal.y > 0.9 and all(abs(v.co.y - 6.0) < 0.01 for v in f.verts) and abs(c.x) > 16.9 and abs(c.z) > 16.9
    bmesh.ops.delete(bm, geom=[f for f in bm.faces if top(f)], context='FACES'); bm.to_mesh(st.data); bm.free()
    bmesh.ops.delete(bm2, geom=[f for f in bm2.faces if not top(f)], context='FACES')
    me = bpy.data.meshes.new("K_Hero_turf"); bm2.to_mesh(me); bm2.free(); ob = bpy.data.objects.new("K_Hero_turf", me); coll().objects.link(ob)
    return out + ["K_Hero_turf"]

def build_stairs5():
    """Pass-4 flights plus: riser faces split out (darker), 3-wide navy centre panel on the runner, double-line Y,
    white kerbs standing proud with gold top rails."""
    clear_piece("K_Stairs"); clear_piece("Q_")
    G = {"stone": [], "blue": [], "navy": [], "gold": [], "white": [], "glass": []}
    rise, tread, d0, n = 0.75, 2.5, 28.0, 8
    for i in range(n):
        h = rise * (i + 1); dc = d0 + tread * i + tread / 2
        widths = [4.5, 4.5, 4.4] if i % 2 == 0 else [2.25, 4.5, 4.5, 2.15]
        for s in (-1, 1):
            x = 4.3
            for wdt in widths:
                o = rbox(f"Q_st{i}_{s}_{x:.1f}", wdt - 0.08, h, tread - 0.05, bevel=0.18, segs=1, loc=(s * (x + wdt / 2), h / 2, -dc))
                G["stone"].append(flat(o)); x += wdt
    ramp = lambda d: 0.4 + (d - d0) * (6.0 - 0.4) / (tread * n)
    G["blue"].append(extrude_side("Q_ramp", [(d0, 0), (d0, ramp(d0)), (d0 + 20, ramp(d0 + 20)), (d0 + 20, 0)], -3.5, 3.5))
    G["navy"].append(extrude_side("Q_panel", [(d0 + 0.6, ramp(d0 + 0.6) - 0.1), (d0 + 0.6, ramp(d0 + 0.6) + 0.05), (d0 + 19.6, ramp(d0 + 19.6) + 0.05), (d0 + 19.6, ramp(d0 + 19.6) - 0.1)], -1.5, 1.5))
    for s in (-1, 1):
        G["white"].append(extrude_side(f"Q_kerb{s}", [(d0 - 0.3, 0), (d0 - 0.3, 1.0), (d0 + 20, 6.6), (d0 + 20, 0)], s * 3.5, s * 4.3))
        for e in (3.55, 4.25):
            G["gold"].append(tube_along(f"Q_rail{s}{e}", [(s * e, 1.0, -(d0 - 0.3)), (s * e, 6.6, -(d0 + 20))], 0.16))
    yy = lambda d: ramp(d) + 0.1
    for o in (-0.32, 0.32):
        G["gold"].append(tube_along(f"Q_Ystem{o}", [(o, yy(d), -d) for d in (30.5, 40.0)], 0.12))
    for s in (-1, 1):
        for o in (-0.3, 0.3):
            G["gold"].append(tube_along(f"Q_Yarm{s}{o}", [(s * o, yy(40.0), -40.0), (s * (2.4 + o), yy(46.3), -46.3), (s * (2.4 + o), yy(47.8), -47.8)], 0.12))
    G["glass"].append(lathe_at("Q_gem", [(0, 0), (1.0, 0), (0.8, 0.18), (0, 0.22)], (0, ramp(29.4) + 0.08, -29.4), 16))
    out = [merge_objs(f"K_Stairs_{k}", objs, rot4=True).name for k, objs in G.items()]
    split_by_normal(bpy.data.objects["K_Stairs_stone"], "K_Stairs_riser")
    return out + ["K_Stairs_riser"]

def build_floor5():
    """Floor/medallion pass 5: thinner dark hooked blades on pale stone, small gold disc with a dark ring, raised gold
    ring (r 9, 1 wide, 0.4 proud), dark slate band r 9.5-12.5 with a gold edge, dais diamond bands raised to 0.1."""
    clear_piece("K_Medal"); clear_piece("Q_")
    G = {"pale": [], "slate": [], "gold": [], "blue": [], "darkStone": []}
    dia = lambda r: [(0, -r), (r, 0), (0, r), (-r, 0)]
    G["pale"].append(extrude_plan("Q_dais", dia(20.0), 0.0, 0.3))
    for k in range(4):
        a, b = dia(20.0)[k], dia(20.0)[(k + 1) % 4]; A, B = dia(23.5)[k], dia(23.5)[(k + 1) % 4]
        G["slate"].append(extrude_plan(f"Q_band{k}", [a, b, B, A], 0.0, 0.1))
    for r in (20.0, 23.5):
        G["gold"].append(tube_along(f"Q_gDia{int(r)}", [(x, 0.3 if r < 21 else 0.1, z) for x, z in dia(r)], 0.22, closed=True))
    ring = lambda r, y: [(r * math.cos(2 * math.pi * i / 72), y, r * math.sin(2 * math.pi * i / 72)) for i in range(72)]
    G["slate"].append(lathe_at("Q_sband", [(9.4, 0.3), (12.5, 0.3), (12.5, 0.36), (9.4, 0.36)], (0, 0, 0), 72, False))
    G["gold"].append(tube_along("Q_gSband", ring(12.5, 0.36), 0.2, closed=True))
    G["gold"].append(lathe_at("Q_gRing", [(8.5, 0.3), (9.5, 0.3), (9.5, 0.62), (9.35, 0.72), (8.65, 0.72), (8.5, 0.62), (8.5, 0.3)], (0, 0, 0), 72, False))
    G["pale"].append(lathe_at("Q_medal", [(0, 0.3), (8.5, 0.3), (8.5, 0.4), (0, 0.4)], (0, 0, 0), 64, False))
    for i in range(8):
        o = extrude_outline(f"Q_blade{i}", blade_outline(2 * math.pi * i / 8, r0=2.2, r1=8.0, sweep=1.05, w=0.5), 0.1, bevel=0.0)
        o.rotation_euler = (math.radians(90), 0, 0); o.location = (0, 0.44, 0); flat(o)
        o.data.flip_normals()
        G["darkStone"].append(o)
    G["gold"].append(lathe_at("Q_disc", [(0, 0.4), (1.6, 0.4), (1.6, 0.62), (1.45, 0.7), (0, 0.7)], (0, 0, 0), 32))
    G["darkStone"].append(lathe_at("Q_discRing", [(0.7, 0.705), (1.05, 0.705)], (0, 0, 0), 24, False))
    G["darkStone"].append(lathe_at("Q_discRing2", [(1.6, 0.4), (2.1, 0.4), (2.1, 0.46), (1.6, 0.46)], (0, 0, 0), 32, False))
    G["blue"].append(extrude_plan("Q_run", [(-3.5, -19.5), (3.5, -19.5), (3.5, -28.2), (-3.5, -28.2)], 0.0, 0.08))
    for s in (-1, 1):
        G["gold"].append(extrude_plan(f"Q_runK{s}", [(s * 3.5, -19.0), (s * 4.0, -19.0), (s * 4.0, -28.2), (s * 3.5, -28.2)], 0.0, 0.1))
    G["slate"].append(extrude_plan("Q_foot", [(-17, -25.0), (17, -25.0), (17, -28.0), (-17, -28.0)], 0.0, 0.08))
    G["gold"].append(tube_along("Q_gFoot", [(-17, 0.08, -24.9), (-4.0, 0.08, -24.9)], 0.18)); G["gold"].append(tube_along("Q_gFoot2", [(4.0, 0.08, -24.9), (17, 0.08, -24.9)], 0.18))
    out = []
    for k, objs in G.items():
        arm = [o for o in objs if o.name.startswith(("Q_run", "Q_foot", "Q_gFoot"))]
        one = [o for o in objs if o not in arm]
        parts = []
        if one: parts.append(merge_objs(f"Q1_{k}", one))
        if arm: parts.append(merge_objs(f"Q4_{k}", arm, rot4=True))
        out.append(merge_objs(f"K_Medal_{k}", parts).name)
    return out

def build_bollard5():
    """Diagonal bollard: stepped plinth 3.5 x 0.4, tapering white pedestal 2.5 -> 2.0 x 2.3, gold dome cap 1.8 with a dark slot."""
    clear_piece("K_Bollard"); clear_piece("Q_")
    sq = lambda name, prof: flat(lathe(name, prof, seg=4, start=math.pi / 4, smooth=False))
    white = [sq("Q_pl1", [(0, 0), (2.47, 0), (2.47, 0.4), (0, 0.4)]), sq("Q_pl2", [(0, 0.4), (2.05, 0.4), (2.05, 0.65), (0, 0.65)]),
             sq("Q_ped", [(0, 0.65), (1.77, 0.65), (1.45, 2.75), (1.6, 2.95), (0, 2.95)])]
    gold = [lathe("Q_cap", [(0, 2.95), (1.0, 2.95), (1.0, 3.15)] + [(0.9 * math.cos(t), 3.15 + 0.85 * math.sin(t)) for t in [math.pi / 2 * k / 6 for k in range(1, 7)]], seg=20)]
    dark = [rbox("Q_slot", 0.25, 0.5, 1.9, 0.05, 1, (0, 3.6, 0))]
    merge_objs("K_Bollard_white", white); merge_objs("K_Bollard_gold", gold); merge_objs("K_Bollard_darkStone", dark)

FOLIAGE5 = [("TreeA", 101, dict(H=20, R=8, nclus=9, ncard=16, trunk_r=0.8, cl=4.0)),
            ("TreeB", 202, dict(H=23, R=9.5, nclus=11, ncard=15, trunk_r=0.9, cl=4.4)),
            ("TreeC", 303, dict(H=17, R=7, nclus=7, ncard=18, trunk_r=0.7, cl=3.6)),
            ("GiantTree", 404, dict(H=64, R=30, nclus=22, ncard=22, trunk_r=5.5, cl=9.0))]

def build_all5():
    names = build_hero5() + build_stairs5() + build_floor5(); build_bollard5()
    for tag, seed, kw in FOLIAGE5: build_cardtree(tag, seed, **kw)
    build_palm5("PalmA", 11, H=25, nf=9, FL=9.5, bend=3.5); build_palm5("PalmB", 12, H=24, nf=10, FL=8.5, bend=-2.5)
    build_cypress5(); build_fern5(); build_crystal5(); build_island5(); build_ring5()
    return names

R5_PREFIXES = ("K_Hero_", "K_Stairs_", "K_Medal_", "K_Bollard_", "K_TreeA_", "K_TreeB_", "K_TreeC_", "K_GiantTree_", "K_PalmA_",
               "K_PalmB_", "K_Cypress_", "K_Fern_", "K_Crystal_", "K_Island_", "K_Ring_", "K_Grass_")

def export_r5(path):
    """Z-up + UVs, then export only the pass-5 kit (the export call used since r3)."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R5_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]


# ---------------------------------------------------------------- pass 6: crown crest, flat gold bands, tree mix, islands, patches
# Freestyle from the picture set and the round-3 review. Same plaza frame as passes 4-5.
def _area2(pts):
    return sum(pts[i][0] * pts[(i + 1) % len(pts)][1] - pts[(i + 1) % len(pts)][0] * pts[i][1] for i in range(len(pts)))

def ribbon_uy(name, pts, width, w0, thick=0.14, closed=False):
    """Flat inset band (the reference's gold trim): a strip following a (u, y) outline on its INSIDE, width studs wide,
    standing thick proud of the face at depth w0 (toward the viewer, i.e. lower w). Solid, flat shaded."""
    n = len(pts); sgn = 1 if _area2(pts) > 0 else -1
    inner = []
    for i in range(n):
        p = Vector(pts[i])
        a = Vector(pts[i - 1]) if (closed or i > 0) else None
        b = Vector(pts[(i + 1) % n]) if (closed or i < n - 1) else None
        segs = []
        if a is not None: segs.append((p - a).normalized())
        if b is not None: segs.append((b - p).normalized())
        nn = [Vector((-t.y, t.x)) * sgn for t in segs]
        m = sum(nn, Vector((0, 0))).normalized()
        k = max(0.5, m.dot(nn[0]))
        inner.append(p + m * (width / k))
    bm = bmesh.new()
    O = [[bm.verts.new(P(u, y, w)) for (u, y) in pts] for w in (w0 - thick, w0 + 0.05)]
    I = [[bm.verts.new(P(v.x, v.y, w)) for v in inner] for w in (w0 - thick, w0 + 0.05)]
    rng_ = range(n) if closed else range(n - 1)
    for i in rng_:
        j = (i + 1) % n
        bm.faces.new((O[0][i], O[0][j], I[0][j], I[0][i]))
        bm.faces.new((O[1][i], I[1][i], I[1][j], O[1][j]))
        bm.faces.new((O[0][i], O[1][i], O[1][j], O[0][j]))
        bm.faces.new((I[0][i], I[0][j], I[1][j], I[1][i]))
    if not closed:
        for i in (0, n - 1):
            bm.faces.new((O[0][i], I[0][i], I[1][i], O[1][i]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return flat(mesh_obj(name, bm, False))

def ribbon_xz(name, pts, width, y, thick=0.12):
    """Flat band lying on a horizontal face, offset to one side of the polyline (x, z) by width (sign picks the side)."""
    bm = bmesh.new(); L = []
    for i, p in enumerate(pts):
        a = Vector(pts[max(0, i - 1)]); b = Vector(pts[min(len(pts) - 1, i + 1)]); t = (b - a).normalized()
        L.append(Vector(p) + Vector((-t.y, t.x)) * width)
    T = [[bm.verts.new((p[0], y + h, p[1])) for p in pts] for h in (0, thick)]
    U = [[bm.verts.new((p.x, y + h, p.y)) for p in L] for h in (0, thick)]
    for i in range(len(pts) - 1):
        bm.faces.new((T[1][i], T[1][i + 1], U[1][i + 1], U[1][i])); bm.faces.new((T[0][i], U[0][i], U[0][i + 1], T[0][i + 1]))
        bm.faces.new((T[0][i], T[0][i + 1], T[1][i + 1], T[1][i])); bm.faces.new((U[0][i], U[1][i], U[1][i + 1], U[0][i + 1]))
    for i in (0, len(pts) - 1):
        bm.faces.new((T[0][i], T[1][i], U[1][i], U[0][i]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return flat(mesh_obj(name, bm, False))

def lantern6(tag, loc, base_y, sc=1.4):
    """Pass-5 lantern (1.4x) with 10 gold dome ribs and a small bright core inside the glass; placed 2 lower by the caller."""
    L = lantern5(tag, loc, base_y, sc); L["core"] = []
    x, z = loc[0], loc[2]
    for i in range(10):
        a = 2 * math.pi * i / 10; pts = []
        for j in range(9):
            t = j / 8; ph = math.pi / 2 * t; r0 = 3.0 * math.cos(ph) * (1 + 0.12 * math.sin(math.pi * t)) * 1.06 + 0.05
            pts.append((x + sc * r0 * math.cos(a), base_y + sc * (11.2 + 3.9 * math.sin(ph)), z + sc * r0 * math.sin(a)))
        L["gold"].append(tube_along(f"{tag}_rib{i}", pts, 0.14))
    L["core"].append(lathe_at(f"{tag}_hot", [(0, 5.6 * sc), (0.55 * sc, 6.0 * sc), (0.7 * sc, 7.6 * sc), (0.45 * sc, 9.2 * sc), (0, 9.6 * sc)], (x, base_y, z), 10))
    return L

def build_hero6():
    """Corner hero piece, pass 6: crown crest (wide see-through window, 3-wide hooked arms, sloping shoulders), flat inset
    gold bands instead of round tubes on the gate, basin 2 further forward, curved water sheet instead of the slab,
    lanterns 2 lower with ribbed domes and hot cores."""
    clear_piece("K_Hero"); clear_piece("Q_")
    G = {"stone": [], "rib": [], "darkStone": [], "gold": [], "goldBas": [], "goldLan": [], "blue": [], "glass": [], "core": [],
         "water": [], "sheet": [], "foam": [], "vault": []}
    W0, W1 = 33.0, 39.5
    outer = arch_outline(10.0, 5.0, 5.0); in1 = arch_outline(7.6, 4.2, 4.0); in2 = arch_outline(7.0, 4.0, 3.6); in3 = arch_outline(6.5, 3.8, 3.2)
    G["stone"].append(arch_band("Q_arch", outer, in1, W0, W1))
    G["rib"].append(arch_band("Q_rib1", in1, in2, W0 + 0.7, W1))
    G["darkStone"].append(arch_band("Q_rib2", in2, in3, W0 + 1.4, W1))
    G["gold"].append(ribbon_uy("Q_gArchO", outer, 0.55, W0))
    G["gold"].append(ribbon_uy("Q_gArchI", arch_outline(8.25, 4.35, 4.6), 0.45, W0))
    G["gold"].append(ribbon_uy("Q_gArchR", in1, 0.3, W0 + 0.7))
    # crown crest: sloping shoulders from the band, two 3-wide arms with a chamfered (hooked) outer top corner, a 4.8-wide window
    C = [(-8.0, 7.9), (8.0, 7.9), (5.7, 10.7), (5.7, 12.5), (4.8, 13.5), (2.4, 13.5), (2.4, 9.4), (-2.4, 9.4), (-2.4, 13.5), (-4.8, 13.5), (-5.7, 12.5), (-5.7, 10.7)]
    G["stone"].append(extrude_uy("Q_crest", C, W0 + 0.3, W0 + 3.8))
    G["gold"].append(ribbon_uy("Q_gCrest", C[1:] + C[:1], 0.42, W0 + 0.3, closed=True))
    G["vault"].append(extrude_uy("Q_crestWin", [(-2.4, 9.4), (2.4, 9.4), (2.4, 9.9), (-2.4, 9.9)], W0 + 0.6, W0 + 3.5))
    # shoulder wings (as pass 5) with flat gold top strips
    G["stone"].append(prism("Q_wingL", [(17, 6.0, -31.1), (17, 10.0, -31.1), (17, 7.2, -48), (17, 6.0, -48)], (2.6, 0, 0)))
    G["stone"].append(prism("Q_wingR", [(31.1, 6.0, -17), (31.1, 10.0, -17), (48, 7.2, -17), (48, 6.0, -17)], (0, 0, -2.6)))
    G["gold"].append(prism("Q_gWingL", [(16.85, 9.45, -31.1), (16.85, 10.05, -31.1), (16.85, 7.25, -48), (16.85, 6.65, -48)], (0.2, 0, 0)))
    G["gold"].append(prism("Q_gWingR", [(31.1, 9.45, -16.85), (31.1, 10.05, -16.85), (48, 7.25, -16.85), (48, 6.65, -16.85)], (0, 0, -0.2)))
    # vault interior (lighter slate), gold shelf, curved water sheet from the shelf into the upper bowl
    G["vault"].append(rbox_rot("Q_nicheBack", 13.4, 7.4, 0.8, P(0, 3.7, 40.2), math.radians(-45), 0.2, 1))
    G["vault"].append(rbox_rot("Q_nicheTop", 13.4, 0.8, 1.6, P(0, 7.2, 40.0), math.radians(-45), 0.2, 1))
    G["gold"].append(rbox_rot("Q_shelf", 12.6, 0.5, 1.4, P(0, 5.0, 39.3), math.radians(-45), 0.2, 1))
    G["vault"].append(rbox_rot("Q_shelfBk", 12.6, 0.8, 0.8, P(0, 6.0, 39.6), math.radians(-45), 0.2, 1))
    bw = 29.6; bx, _, bz = P(0, 0, bw)
    bm = bmesh.new(); prev = None
    for k in range(13):  # arc from the shelf lip (w 38.6, y 5.3) out and down into the upper bowl
        t = k / 12; w = 38.6 + (bw + 1.2 - 38.6) * t; y = 5.3 + 0.9 * math.sin(math.pi * t * 0.5) - 2.5 * t * t
        hw = 1.3 + 0.5 * t
        row = [P(-hw, y, w), P(hw, y, w)]
        if prev:
            ds_quad(bm, [prev[0], prev[1], row[1], row[0]], 0.04)
        prev = row
    G["sheet"].append(bm_obj("Q_sheet", bm))
    G["foam"].append(lathe_at("Q_splash", [(0, 3.7), (1.5, 3.7), (1.1, 4.3), (0.4, 4.7), (0, 4.75)], P(0, 0, bw + 0.6), 10, False))
    # corner block (y 0..6), notch behind the vault
    poly = [P(-10, 0, 34), P(-6.5, 0, 34), P(-6.5, 0, 41), P(6.5, 0, 41), P(6.5, 0, 34), P(10, 0, 34), (62, 0, -17), (62, 0, -62), (17, 0, -62)]
    G["stone"].append(extrude_plan("Q_block", [(p[0], p[2]) for p in poly], 0.0, 6.0))
    G["gold"].append(ribbon_xz("Q_gTopL", [(17.0, -62), (17.0, -31.1)], -0.5, 6.0))
    G["gold"].append(ribbon_xz("Q_gTopR", [(62, -17.0), (31.1, -17.0)], -0.5, 6.0))
    G["gold"].append(prism("Q_gStrL", [(16.85, 0.5, -28), (16.85, 1.1, -28), (16.85, 6.6, -48), (16.85, 6.0, -48)], (0.2, 0, 0)))
    G["gold"].append(prism("Q_gStrR", [(28, 0.5, -16.85), (28, 1.1, -16.85), (48, 6.6, -16.85), (48, 6.0, -16.85)], (0, 0, -0.2)))
    # two-tier basin standing forward of the arch (centre w 29.6, was 31.6)
    G["goldBas"].append(lathe_at("Q_basinFoot", [(0, 0), (6.4, 0), (6.4, 0.45), (6.0, 0.6), (0, 0.6)], (bx, 0, bz), 40, False))
    G["stone"].append(lathe_at("Q_basin", [(0, 0.6), (5.6, 0.6), (5.6, 2.4), (4.9, 2.4), (4.9, 1.6), (3.0, 1.6), (3.0, 3.9), (2.5, 3.9), (2.5, 3.3), (0, 3.3)], (bx, 0, bz), 40))
    G["rib"].append(lathe_at("Q_basinBand", [(5.65, 0.9), (5.75, 1.0), (5.75, 1.6), (5.65, 1.7)], (bx, 0, bz), 40))
    G["goldBas"].append(lathe_at("Q_gBasinA", [(4.95, 2.4), (5.65, 2.4), (5.65, 2.55), (4.95, 2.55)], (bx, 0, bz), 40, False))
    G["goldBas"].append(lathe_at("Q_gBasinB", [(2.5, 3.9), (3.05, 3.9), (3.05, 4.02), (2.5, 4.02)], (bx, 0, bz), 32, False))
    for i in range(16):
        a = 2 * math.pi * i / 16
        G["goldBas"].append(rbox(f"Q_bar{i}", 0.22, 1.3, 0.22, 0.05, 1, (bx + 3.08 * math.cos(a), 2.6, bz + 3.08 * math.sin(a))))
    G["water"].append(lathe_at("Q_wBasinA", [(0, 2.05), (4.95, 2.05)], (bx, 0, bz), 40))
    G["water"].append(lathe_at("Q_wBasinB", [(0, 3.65), (2.55, 3.65)], (bx, 0, bz), 24))
    # raised pool behind the gate (as pass 5)
    px, _, pz = P(0, 0, 55.0)
    G["stone"].append(lathe_at("Q_poolRim", [(12.4, 6.0), (14.5, 6.0), (14.5, 7.6), (14.1, 8.0), (12.8, 8.0), (12.4, 7.6), (12.4, 6.0)], (px, 0, pz), 48))
    G["gold"].append(lathe_at("Q_gPool", [(13.0, 8.0), (13.9, 8.0), (13.9, 8.1), (13.0, 8.1)], (px, 0, pz), 64, False))
    G["water"].append(lathe_at("Q_wPool", [(0, 7.0), (12.45, 7.0)], (px, 0, pz), 48))
    G["darkStone"].append(lathe_at("Q_rock", [(0, 6.0), (4.5, 6.0), (4.1, 7.8), (2.8, 9.2), (1.0, 9.8), (0, 9.8)], (px, 0, pz), 9, False))
    for s in (-1, 1):
        L = lantern6(f"Q_lan{s}", P(s * 14.0, 0, 52.0), 4.0)   # 2 lower: the drum bottom sinks into the block
        for k, v in L.items(): G["goldLan" if k == "gold" else k] += v
    out = []
    for k, objs in G.items():
        if objs: out.append(merge_objs(f"K_Hero_{k}", objs, mirror4=True).name)
    st = bpy.data.objects["K_Hero_stone"]
    bm = bmesh.new(); bm.from_mesh(st.data); bm2 = bm.copy()
    def top(f):
        c = f.calc_center_median()
        return f.normal.y > 0.9 and all(abs(v.co.y - 6.0) < 0.01 for v in f.verts) and abs(c.x) > 16.9 and abs(c.z) > 16.9
    bmesh.ops.delete(bm, geom=[f for f in bm.faces if top(f)], context='FACES'); bm.to_mesh(st.data); bm.free()
    bmesh.ops.delete(bm2, geom=[f for f in bm2.faces if not top(f)], context='FACES')
    me = bpy.data.meshes.new("K_Hero_turf"); bm2.to_mesh(me); bm2.free(); ob = bpy.data.objects.new("K_Hero_turf", me); coll().objects.link(ob)
    return out + ["K_Hero_turf"]

def build_palm6(tag, seed, H=22.0, nf=8, FL=10.0, bend=3.0):
    """Ref-style palm: tan trunk with soft ring bulges, crown of 8 BROAD arched fronds (wide leaflet cards, fewer of them)."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    A, B = bmesh.new(), bmesh.new(); wood = []
    tp = lambda t: Vector((bend * t * t, H * t, 0.0))
    wood.append(tube_along("Q_trunk", [tuple(tp(i / 10)) for i in range(11)], 0.85))
    for i in range(1, 12):
        p = tp(i / 12); wood.append(lathe_at(f"Q_ring{i}", [(0, -0.45), (1.05, -0.2), (1.0, 0.25), (0, 0.4)], tuple(p), 8, False))
    top = tp(1.0); wood.append(lathe_at("Q_boss", [(0, -1.2), (1.3, -0.7), (1.4, 0.3), (0.6, 1.0), (0, 1.1)], tuple(top), 10, False))
    for i in range(nf):
        a = 2 * math.pi * i / nf + random.uniform(-0.15, 0.15); hz = Vector((math.cos(a), 0, math.sin(a)))
        fl = FL * random.uniform(0.9, 1.1); rise = random.uniform(0.3, 0.5)
        q = lambda s: top + hz * (fl * s) + Vector((0, fl * (rise * s - 0.8 * s * s), 0))
        side = hz.cross(Vector((0, 1, 0))).normalized()
        for k in range(1, 9):
            s = k / 9; p = q(s); tan = (q(min(1, s + 0.05)) - q(max(0, s - 0.05))).normalized()
            ll = fl * (0.33 * math.sin(math.pi * min(1.0, s * 1.1)) + 0.08)
            for sg in (-1, 1):
                d = (side * sg + tan * 0.9 + Vector((0, -0.3, 0))).normalized()
                card(A, B, p, d, ll, 0.95, 0.12, 0.3 * sg, (0.25, 0.75, 0.6, 0.35, 0.0), nA=2)
        for k in range(10):
            p0, p1 = q(k / 10), q((k + 1) / 10)
            ds_quad(A, [p0 - side * 0.3, p1 - side * 0.22, p1 + side * 0.22, p0 + side * 0.3])
    merge_objs(f"K_{tag}_wood", wood); bm_obj(f"K_{tag}_leaf", A); bm_obj(f"K_{tag}_leafRim", B)

def build_fluffy6(tag, seed, H=16.0, R=12.5, nclus=18, ncard=30, trunk_r=1.3, cl=2.8, hang=0):
    """Fluffy broadleaf tree (gold / blue / purple in the ref): a round canopy of many small leaf-card puffs on dark
    cores, a thick root-flared trunk; hang>0 adds weeping strands (wisteria)."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    A, B = bmesh.new(), bmesh.new(); wood = []
    C = Vector((random.uniform(-0.6, 0.6), H, 0))
    wood.append(tube_along("Q_trunk", [(0, -0.5, 0), (0.2, H * 0.35, 0.1), (C.x * 0.6, H * 0.7, 0), (C.x, H - 1.0, 0)], trunk_r))
    wood.append(lathe_at("Q_flare", [(0, 0), (trunk_r * 2.6, 0), (trunk_r * 1.5, trunk_r * 1.2), (trunk_r * 1.05, trunk_r * 3.0), (0, trunk_r * 3.2)], (0, -0.3, 0), 12, False))
    cents = []
    for i in range(nclus):
        y = random.uniform(-0.45, 0.95); rr = math.sqrt(max(0.0, 1 - y * y)); a = random.uniform(0, 2 * math.pi)
        cents.append(C + Vector((R * 0.7 * rr * math.cos(a), R * 0.45 * y, R * 0.7 * rr * math.sin(a))))
    for k, c in enumerate(cents[:6]):
        wood.append(tube_along(f"Q_br{k}", [tuple(C - Vector((0, 2.5, 0))), tuple(c.lerp(C, 0.3))], trunk_r * 0.45))
    for c in cents:
        ico(A, c, cl * 0.9, 1, (1, 0.8, 1))
        out = (c - C); out = out.normalized() if out.length > 0.1 else Vector((0, 1, 0))
        for j in range(ncard):
            rd = Vector((random.gauss(0, 1), random.gauss(0, 1), random.gauss(0, 1))).normalized()
            d = (out * 0.8 + rd).normalized()
            L = cl * random.uniform(0.7, 1.15)
            card(A, B, c + d * cl * 0.55, d, L, L * 0.38, 0.15, random.uniform(-0.8, 0.8))
    for h in range(hang):
        a = random.uniform(0, 2 * math.pi); r = R * random.uniform(0.45, 0.75)
        b = C + Vector((r * math.cos(a), -R * 0.15, r * math.sin(a))); Lh = random.uniform(3.0, 6.0)
        for k in range(5):
            p = b + Vector((0, -Lh * k / 5, 0)); dd = Vector((math.cos(a + k), -0.6, math.sin(a + k))).normalized()
            card(A, B, p, dd, 1.6, 0.7, 0.3, 0, nA=1)
    o1 = merge_objs(f"K_{tag}_wood", wood); bm_obj(f"K_{tag}_leaf", A); bm_obj(f"K_{tag}_leafRim", B)
    return o1

def build_deadtree6(tag="DeadTree", seed=31, H=14.0):
    """Bare twisted tree (the Raid side): recursive branching tubes, wood only."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    parts = []
    def br(p, d, L, r, depth):
        pts = [p]; q = Vector(p)
        for k in range(4):
            d = (d + Vector((random.uniform(-0.35, 0.35), random.uniform(-0.1, 0.25), random.uniform(-0.35, 0.35)))).normalized()
            q = q + d * (L / 4); pts.append(q.copy())
        parts.append(tube_along(f"Q_b{len(parts)}", [tuple(x) for x in pts], r))
        if depth > 0:
            for k in range(random.choice((2, 3))):
                nd = (d + Vector((random.uniform(-1, 1), random.uniform(0.0, 0.6), random.uniform(-1, 1)))).normalized()
                br(q, nd, L * 0.62, r * 0.6, depth - 1)
    br(Vector((0, -0.5, 0)), Vector((0, 1, 0)), H * 0.55, 0.8, 3)
    parts.append(lathe_at("Q_flare", [(0, 0), (1.9, 0), (1.0, 0.9), (0.8, 2.0), (0, 2.1)], (0, -0.3, 0), 8, False))
    merge_objs(f"K_{tag}_wood", parts)

def build_island6(seed=61, R=40.0):
    """Floating island, pass 6: grey faceted rock underside 34 deep, THICK green cap with an overhanging lip, 40 hanging
    vine strips, a tall ruined white tower, a second tower and a broken arcade, two thin waterfalls."""
    random.seed(seed); clear_piece("K_Isl6_"); clear_piece("Q_")
    prof = [(0, -34), (5, -30), (10, -24), (17, -17), (24, -10), (31, -5), (R - 2, -1.5), (R, 0.0)]
    rock = lathe("Q_rock", prof, seg=20, smooth=False)
    for v in rock.data.vertices:
        if v.co.y < -0.6:
            f = 1 + random.uniform(-0.15, 0.15); v.co.x *= f; v.co.z *= f; v.co.y += random.uniform(-2.0, 2.0)
    capP = [(0, 3.6), (R * 0.5, 3.4), (R - 2, 3.0), (R + 1.0, 2.2), (R + 1.4, 0.6), (R + 0.8, -1.4), (R - 0.5, -1.0)]
    grass = [lathe_at("Q_cap", capP, (0, 0, 0), 32, False)]
    vines = bmesh.new()
    for k in range(40):
        a = 2 * math.pi * k / 40 + random.uniform(-0.05, 0.05); r = R + 0.9; L = random.uniform(5, 14)
        c = Vector((r * math.cos(a), -1.2, r * math.sin(a))); t = Vector((-math.sin(a), 0, math.cos(a))) * 0.45
        ds_quad(vines, [c - t, c + t, c + t * 0.4 + Vector((0, -L, 0)), c - t * 0.4 + Vector((0, -L, 0))])
    stone = []
    tx, tz, th = 12, -8, 34.0
    stone.append(lathe_at("Q_tower", [(0, 0), (4.6, 0), (4.6, 1.2), (4.0, 1.6), (4.0, th), (4.6, th + 0.6), (4.6, th + 2.0), (0, th + 2.0)], (tx, 3.4, tz), 12, False))
    for j in range(6):
        a = 2 * math.pi * j / 6
        if random.random() < 0.7: stone.append(rbox_rot(f"Q_cren{j}", 1.6, random.uniform(1.4, 3.0), 1.6, (tx + 4.0 * math.cos(a), 3.4 + th + 3.0, tz + 4.0 * math.sin(a)), a, 0.15, 1))
    stone.append(lathe_at("Q_tower2", [(0, 0), (3.4, 0), (3.0, 0.8), (3.0, 20), (3.5, 20.6), (0, 20.6)], (-14, 3.4, 6), 10, False))
    for k in range(4):
        x = 6 - 6 * k; stone.append(rbox_rot(f"Q_pier{k}", 1.8, 12, 1.8, (x, 3.4 + 6, -4 + 3 * k), 0.4, 0.2, 1))
    stone.append(rbox_rot("Q_lintel", 20, 1.6, 2.0, (-3, 3.4 + 12.5, 0.5), math.atan2(9, -18) * -1, 0.2, 1))
    fall = []
    for k, a in enumerate((0.5, 2.6)):
        x, z = (R + 1.0) * math.cos(a), (R + 1.0) * math.sin(a)
        fall.append(rbox_rot(f"Q_fall{k}", 3.0, 60.0, 0.5, (x, -29.0, z), -a + math.pi / 2, 0.2, 1))
    merge_objs("K_Isl6_rock", [rock]); merge_objs("K_Isl6_grass", grass); bm_obj("K_Isl6_vine", vines)
    merge_objs("K_Isl6_white", stone); merge_objs("K_Isl6_foam", fall)

def build_patch6(tag, seed, R=20.0, k=1.0, n=40, thick=0.16):
    """Organic ground patch: a flat noisy blob (radius R, aspect k) for zoning without straight edges; tinted at placement."""
    random.seed(seed); clear_piece(f"K_{tag}_")
    bm = bmesh.new(); ph = [random.uniform(0, 6.28) for _ in range(4)]
    rs = []
    for i in range(n):
        a = 2 * math.pi * i / n
        f = 1 + 0.18 * math.sin(2 * a + ph[0]) + 0.12 * math.sin(3 * a + ph[1]) + 0.08 * math.sin(5 * a + ph[2]) + random.uniform(-0.05, 0.05)
        rs.append((R * f * math.cos(a), R * k * f * math.sin(a)))
    top = [bm.verts.new((x, thick, z)) for x, z in rs]; bot = [bm.verts.new((x, 0, z)) for x, z in rs]
    c = bm.verts.new((0, thick, 0))
    for i in range(n):
        j = (i + 1) % n
        bm.faces.new((c, top[j], top[i])); bm.faces.new((top[i], top[j], bot[j], bot[i]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    bm_obj(f"K_{tag}_patch", bm)

def build_litter6(tag="Litter", seed=41, R=4.0, n=46):
    """Leaf litter: small leaf cards lying almost flat over a disc, tinted at placement (red E, blue N, green S/W)."""
    random.seed(seed); clear_piece(f"K_{tag}_")
    A, B = bmesh.new(), bmesh.new()
    for i in range(n):
        a = random.uniform(0, 2 * math.pi); r = R * math.sqrt(random.random())
        b = Vector((r * math.cos(a), 0.06, r * math.sin(a))); d = Vector((math.cos(a * 3), random.uniform(0.05, 0.25), math.sin(a * 3))).normalized()
        card(A, B, b, d, random.uniform(0.9, 1.5), 0.45, 0.02, 0, (0.15, 0.55, 0.45, 0.25, 0.0))
    bm_obj(f"K_{tag}_leaf", A); bm_obj(f"K_{tag}_leafRim", B)

def _band_xy(name, o, i, d0, d1, axis):
    """Solid band between two (lateral, y) outlines; axis 'x' extrudes along X (lateral on Z), 'z' along Z (lateral on X)."""
    bm = bmesh.new()
    V = (lambda u, y, d: (d, y, u)) if axis == 'x' else (lambda u, y, d: (u, y, d))
    Of = [bm.verts.new(V(u, y, d0)) for u, y in o]; Ob = [bm.verts.new(V(u, y, d1)) for u, y in o]
    If = [bm.verts.new(V(u, y, d0)) for u, y in i]; Ib = [bm.verts.new(V(u, y, d1)) for u, y in i]
    for k in range(len(o) - 1):
        bm.faces.new((Of[k], Of[k + 1], If[k + 1], If[k])); bm.faces.new((Ob[k], Ib[k], Ib[k + 1], Ob[k + 1]))
        bm.faces.new((Of[k], Ob[k], Ob[k + 1], Of[k + 1])); bm.faces.new((If[k], If[k + 1], Ib[k + 1], Ib[k]))
    for k in (0, len(o) - 1): bm.faces.new((Of[k], If[k], Ib[k], Ob[k]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces); return flat(mesh_obj(name, bm, False))

def pointed_outline(hw, hs, n=12):
    cx = hw * 0.6; r = hw + cx
    L = [(-hw, 0.0), (-hw, hs * 0.5)]
    for k in range(0, n + 1):
        t = k / n; a = math.pi - t * math.acos(cx / r)
        L.append((cx + r * math.cos(a), hs + r * math.sin(a)))
    return L + [(-u, y) for u, y in reversed(L)][1:]

def build_gothic6():
    """Raid gate: pointed arch, opening 8.4 wide x about 15 tall, stepped double band, two columns with pinnacles,
    a back wall, a gable with a round window. Faces -X (the plaza): x = depth, z = lateral."""
    clear_piece("K_Gothic_"); clear_piece("Q_")
    stone = [_band_xy("Q_b1", pointed_outline(7.0, 8.0), pointed_outline(5.4, 8.0), -1.0, 2.0, 'x'),
             _band_xy("Q_b2", pointed_outline(5.4, 8.0), pointed_outline(4.2, 8.0), -0.4, 2.0, 'x')]
    dark = [rbox("Q_door", 1.0, 15.0, 8.6, 0.1, 1, (1.6, 7.5, 0))]
    for s in (-1, 1):
        stone.append(lathe_at(f"Q_col{s}", [(0, 0), (1.3, 0), (1.3, 0.8), (0.9, 1.2), (0.8, 10.5), (1.3, 11.0), (1.4, 11.8), (0, 11.8)], (-2.0, 0, s * 8.6), 12))
        stone.append(lathe_at(f"Q_pin{s}", [(0, 0), (1.0, 0), (0.0, 7.0)], (-2.0, 11.8, s * 8.6), 6, False))
    stone.append(rbox("Q_wall", 3.0, 26.0, 24.0, 0.3, 1, (3.5, 13.0, 0)))
    stone.append(prism("Q_gable", [(-1.2, 19.5, -10.5), (-1.2, 19.5, 10.5), (-1.2, 28.5, 0.6), (-1.2, 28.5, -0.6)], (3.0, 0, 0)))
    g = lathe("Q_rose", [(0, 0), (2.0, 0), (2.0, 0.3), (0, 0.3)], seg=20, smooth=False)
    g.rotation_euler = (0, 0, math.radians(90)); g.location = (-1.25, 23.0, 0)
    merge_objs("K_Gothic_stone", stone); merge_objs("K_Gothic_darkStone", dark); merge_objs("K_Gothic_gold", [g])

def build_spire6():
    """Gothic spire 25 tall: square base, octagonal shaft, cone with a ball finial."""
    clear_piece("K_Spire_"); clear_piece("Q_")
    s = [flat(lathe("Q_base", [(0, 0), (3.4, 0), (3.4, 6.0), (3.0, 6.5), (0, 6.5)], seg=4, start=math.pi / 4, smooth=False)),
         flat(lathe("Q_shaft", [(0, 6.5), (2.4, 6.5), (2.4, 13.0), (2.7, 13.5), (0, 13.5)], seg=8, smooth=False)),
         flat(lathe("Q_cone", [(0, 13.5), (2.5, 13.5), (0.3, 24.0), (0, 24.2)], seg=8, smooth=False))]
    d = [lathe("Q_ball", [(0.7 * math.sin(t), 24.9 - 0.7 * math.cos(t)) for t in [math.pi * k / 6 for k in range(7)]], seg=10)]
    merge_objs("K_Spire_stone", s); merge_objs("K_Spire_darkStone", d)

def build_exparch6():
    """Expeditions portal: round arch on two columns, top about 17.5, stepped trim, urns, sign tablet, finial, glass
    field. Faces -Z: x = lateral, z = depth."""
    clear_piece("K_ExpArch_"); clear_piece("Q_")
    teal = [_band_xy("Q_arch", arch_outline(8.5, 9.0, 8.5), arch_outline(6.6, 9.0, 6.6), -1.5, 1.5, 'z')]
    pale = [_band_xy("Q_trim", arch_outline(6.6, 9.0, 6.6), arch_outline(6.0, 9.0, 6.0), -1.0, 1.0, 'z')]
    for s in (-1, 1):
        pale.append(lathe_at(f"Q_col{s}", [(0, 0), (1.6, 0), (1.6, 1.0), (1.1, 1.5), (1.0, 12.0), (1.6, 12.6), (1.7, 13.4), (0, 13.4)], (s * 10.6, 0, 0), 12))
        pale.append(lathe_at(f"Q_urn{s}", [(0, 13.4), (1.2, 13.6), (1.5, 14.6), (0.6, 15.6), (0, 16.6)], (s * 10.6, 0, 0), 10))
    pale.append(rbox("Q_sign", 9.0, 2.6, 0.8, 0.3, 1, (0, 19.0, -1.6)))
    pale.append(lathe_at("Q_fin", [(0, 0), (1.3, 0), (0.2, 4.5), (0, 4.6)], (0, 17.3, 0), 8, False))
    field = [rbox("Q_field", 12.6, 15.0, 0.3, 0.05, 1, (0, 7.5, 0))]
    merge_objs("K_ExpArch_teal", teal); merge_objs("K_ExpArch_pale", pale); merge_objs("K_ExpArch_glass", field)

def build_all6():
    names = build_hero6()
    build_palm6("Palm6A", 61, H=22, nf=8, FL=10.0, bend=3.0); build_palm6("Palm6B", 62, H=20, nf=9, FL=9.0, bend=-2.4)
    build_fluffy6("Fluffy", 71, H=15, R=13, nclus=18, ncard=28, trunk_r=1.3, cl=2.9)
    build_fluffy6("FluffyS", 72, H=8, R=7, nclus=10, ncard=24, trunk_r=0.7, cl=2.0)
    build_fluffy6("Wisteria", 73, H=13, R=11, nclus=14, ncard=22, trunk_r=1.0, cl=2.6, hang=36)
    build_deadtree6(); build_island6()
    build_patch6("PatchA", 81, R=20, k=1.0); build_patch6("PatchB", 82, R=14, k=0.55); build_patch6("PatchC", 83, R=9, k=0.8)
    build_litter6(); build_gothic6(); build_spire6(); build_exparch6()
    return names

R6_PREFIXES = R5_PREFIXES + ("K_Palm6A_", "K_Palm6B_", "K_Fluffy_", "K_FluffyS_", "K_Wisteria_", "K_DeadTree_", "K_Isl6_", "K_PatchA_",
                             "K_PatchB_", "K_PatchC_", "K_Litter_", "K_Gothic_", "K_Spire_", "K_ExpArch_")

def export_r6(path):
    """Z-up + UVs, then export the pass-6 kit with the export call used since r3."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R6_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 7: slab islands, carved skull + Raid wings, clumps,
# Story tree, clouds, umbrellas. Freestyle from the picture set and the round-4 review (verify4_plaza.md).
def rect_like(inner, hw, top, cy):
    """Outer outline for a wall bay round an arch opening: each inner point pushed straight out (legs) or radially from
    (0, cy) onto the rectangle |u| <= hw, y <= top. Same point count as inner, so _band_xy can join them."""
    out = []
    for u, y in inner:
        if y <= cy + 1e-6:
            out.append((hw if u > 0 else -hw, y)); continue
        du, dy = u, y - cy
        t = min(hw / abs(du) if abs(du) > 1e-6 else 1e9, (top - cy) / dy if dy > 1e-6 else 1e9)
        out.append((du * t, cy + dy * t))
    return out

def bay(name, inner, hw, top, cy, d0, d1, axis, loc):
    o = _band_xy(name, rect_like(inner, hw, top, cy), inner, d0, d1, axis); o.location = loc; return o

def ruin_tower(tag, cx, cy, cz, H=40.0, w=8.0, seed=0):
    """Square ruined tower w x w x H: stacked 10-tall levels, every face a wall bay with a round-arched opening, a floor
    slab per level; the top level is broken (faces missing, uneven tops). Returns the stone objects."""
    rnd = random.Random(seed); hw = w / 2; t = 0.8; objs = []; nl = int(H // 10)
    inner = arch_outline(hw * 0.5, 4.6, hw * 0.5, 2, 10)
    for lv in range(nl):
        y0 = cy + 10 * lv; top = lv == nl - 1
        faces = [("z", -hw, -hw + t), ("z", hw - t, hw), ("x", -hw, -hw + t), ("x", hw - t, hw)]
        for k, (ax, d0, d1) in enumerate(faces):
            if top and rnd.random() < 0.4: continue
            o = bay(f"Q_{tag}b{lv}{k}", inner, hw, 10.0 if not top else rnd.uniform(7.0, 9.5), 4.6, d0, d1, ax, (cx, y0, cz))
            objs.append(o)
        objs.append(rbox(f"Q_{tag}f{lv}", w + 0.8, 0.7, w + 0.8, 0.15, 1, (cx, y0 + 0.35, cz)))
    return objs

def build_island7(seed=71, R=60.0, k=0.48, towers=2):
    """Floating island, pass 7: a WIDE irregular slab (120 x ~58 in plan, ~30 thick: about 4:1), grey faceted rock with a
    jagged underside and hanging rock spikes, a thick grass cap with an overhanging lip, 4 clustered vine curtains,
    ruined square towers 8 x 8 x 40 with arched openings, 3 wide (3.5) waterfall sheets."""
    random.seed(seed); clear_piece(f"K_Isl7{seed}_"); clear_piece("Q_")
    tag = f"Isl7{seed}"
    ph = [random.uniform(0, 6.28) for _ in range(3)]; n = 40
    fr = [1 + 0.16 * math.sin(2 * a + ph[0]) + 0.10 * math.sin(3 * a + ph[1]) + 0.07 * math.sin(5 * a + ph[2]) + random.uniform(-0.06, 0.06)
          for a in [2 * math.pi * i / n for i in range(n)]]
    rim = lambda i, s: (R * fr[i % n] * s * math.cos(2 * math.pi * i / n), R * k * fr[i % n] * s * math.sin(2 * math.pi * i / n))
    lev = [(1.0, 0.0), (0.97, -3.0), (0.86, -8.0), (0.66, -14.0), (0.44, -20.0), (0.2, -26.0)]
    bm = bmesh.new(); rings = []
    for li, (s, y) in enumerate(lev):
        ring = []
        for i in range(n):
            x, z = rim(i, s)
            if li >= 2:
                f = random.uniform(0.86, 1.12); x *= f; z *= f; yy = y + random.uniform(-3.0, 3.0)
            else:
                yy = y
            ring.append(bm.verts.new((x, yy, z)))
        rings.append(ring)
    bot = bm.verts.new((0, -30.0, 0)); topc = bm.verts.new((0, 0.0, 0))
    for li in range(len(rings) - 1):
        for i in range(n):
            j = (i + 1) % n; bm.faces.new((rings[li][i], rings[li][j], rings[li + 1][j], rings[li + 1][i]))
    for i in range(n):
        bm.faces.new((rings[-1][i], rings[-1][(i + 1) % n], bot)); bm.faces.new((rings[0][(i + 1) % n], rings[0][i], topc))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    rock = [flat(bm_obj("Q_rock", bm))]
    for kk in range(7):  # hanging rock spikes
        i = random.randrange(n); s = random.uniform(0.35, 0.75); x, z = rim(i, s); L = random.uniform(8, 18)
        y0 = -8 - 20 * (1 - s)
        rock.append(flat(lathe_at(f"Q_sp{kk}", [(0, y0 + 1), (random.uniform(3, 6), y0 + 1), (random.uniform(1.0, 2.0), y0 - L * 0.6), (0, y0 - L)], (x, 0, z), 5, False)))
    # grass cap with overhanging lip
    cap = bmesh.new(); ct = cap.verts.new((0, 2.8, 0)); R1, R2_, R3 = [], [], []
    for i in range(n):
        x, z = rim(i, 1.03); R1.append(cap.verts.new((x, 2.4, z)))
        x, z = rim(i, 1.055); R2_.append(cap.verts.new((x, 0.6, z)))
        x, z = rim(i, 1.02); R3.append(cap.verts.new((x, -1.4, z)))
    for i in range(n):
        j = (i + 1) % n
        cap.faces.new((ct, R1[j], R1[i])); cap.faces.new((R1[i], R1[j], R2_[j], R2_[i])); cap.faces.new((R2_[i], R2_[j], R3[j], R3[i]))
    bmesh.ops.recalc_face_normals(cap, faces=cap.faces)
    vines = bmesh.new()
    for c in range(4):  # 4 clustered curtains of 9 strips
        i0 = random.randrange(n)
        for m in range(9):
            a = 2 * math.pi * (i0 + (m - 4) * 0.22) / n
            f = 1 + 0.16 * math.sin(2 * a + ph[0]) + 0.10 * math.sin(3 * a + ph[1]) + 0.07 * math.sin(5 * a + ph[2])
            cx, cz = R * f * 1.05 * math.cos(a), R * k * f * 1.05 * math.sin(a)
            nrm = Vector((cx, 0, cz / (k * k))).normalized(); tg = Vector((-nrm.z, 0, nrm.x)) * 0.5
            L = random.uniform(8, 22) * (1 - abs(m - 4) / 7); c0 = Vector((cx, -1.0, cz))
            ds_quad(vines, [c0 - tg, c0 + tg, c0 + tg * 0.3 + Vector((0, -L, 0)) - nrm * 1.5, c0 - tg * 0.3 + Vector((0, -L, 0)) - nrm * 1.5])
    stone = []
    spots = [(R * 0.25, -R * k * 0.2, 40.0), (-R * 0.4, R * k * 0.15, 24.0)][:towers]
    for ti, (x, z, h) in enumerate(spots):
        stone += ruin_tower(f"t{ti}", x, 2.4, z, h, 8.0, seed + ti)
    if towers > 1:  # broken arcade between the towers
        inner = arch_outline(2.0, 5.0, 2.0, 2, 10)
        x0, z0 = spots[0][0], spots[0][1]; x1, z1 = spots[1][0], spots[1][1]
        for b in range(1, 4):
            t = b / 4; o = bay(f"Q_arc{b}", inner, 3.2, 9.0, 5.0, -0.8, 0.8, 'z', (x0 + (x1 - x0) * t, 2.4, z0 + (z1 - z0) * t))
            o.rotation_euler = (0, -math.atan2(z1 - z0, x1 - x0), 0); stone.append(o)
    fall = []
    for kk in range(3):
        i = random.randrange(n); x, z = rim(i, 1.06); a = math.atan2(z, x)
        fall.append(rbox_rot(f"Q_fall{kk}", 3.5, 70.0, 0.5, (x, -34.0, z), -a + math.pi / 2, 0.2, 1))
    merge_objs(f"K_{tag}_rock", rock); bm_obj(f"K_{tag}_grass", cap); bm_obj(f"K_{tag}_vine", vines)
    merge_objs(f"K_{tag}_white", stone); merge_objs(f"K_{tag}_fall", fall)

def build_cloud7(tag="Cloud7", seed=101):
    """Cumulus card: 11 overlapping soft spheres with a flat bottom, about 90 x 30 x 40."""
    random.seed(seed); clear_piece(f"K_{tag}_")
    bm = bmesh.new()
    for i in range(11):
        r = random.uniform(9, 20) * (1.25 if 3 <= i <= 6 else 1.0)
        c = (random.uniform(-38, 38) * (0.5 if 3 <= i <= 6 else 1.0), r * random.uniform(0.2, 0.6), random.uniform(-12, 12))
        ico(bm, c, r, 2, (1, 0.85, 1))
    for v in bm.verts:
        if v.co.y < 0: v.co.y = 0
    bm_obj(f"K_{tag}_cloud", bm, smooth=True)

def build_skull7():
    """Carved stone skull about 10 wide x 13 tall (with jaw), facing -X: a deformed sphere with deep eye sockets, a
    nose cavity and brow ridge, a jaw block with a row of teeth; the socket faces split out (dark) and two glowing
    eye cores. Pedestal: a tapered carved plinth below it."""
    clear_piece("K_Skull7_"); clear_piece("Q_")
    bm = bmesh.new(); bmesh.ops.create_uvsphere(bm, u_segments=36, v_segments=24, radius=1.0)
    eyes = [(0.4, -2.0), (0.4, 2.0)]; W = {}
    bm.verts.index_update()
    for v in bm.verts:
        x, y, z = v.co.x * 5.0, v.co.y * 6.0, v.co.z * 4.8
        if y < -1.0:
            t = min(1.0, (-y - 1.0) / 5.0); z *= 1 - 0.28 * t; x = x * (1 - 0.15 * t)
        if x < 0: x *= 0.86
        w = 0.0
        if x < -1.5:
            for ey, ez in eyes:
                d2 = ((y - ey) / 1.7) ** 2 + ((z - ez) / 1.5) ** 2; w = max(w, math.exp(-d2))
            x += 2.9 * w
            dn = math.exp(-(((y + 2.1) / 0.75) ** 2 + (z / 0.55) ** 2)); x += 1.4 * dn; w = max(w, dn)
            x -= 0.45 * math.exp(-(((y - 2.2) / 0.6) ** 2)) * (1 - w)   # brow ridge
        v.co = Vector((x, y, z)); W[v.index] = w
    dark = bmesh.new(); dfaces = [f for f in bm.faces if sum(W[v.index] for v in f.verts) / len(f.verts) > 0.33]
    for f in dfaces:
        dark.faces.new([dark.verts.new(v.co) for v in f.verts])
    bmesh.ops.delete(bm, geom=dfaces, context='FACES')
    bone = [bm_obj("Q_head", bm, smooth=True)]
    bone.append(rbox("Q_jaw", 6.0, 2.6, 7.0, 0.8, 2, (0.6, -6.0, 0)))
    for i in range(8):
        z = -2.45 + 0.7 * i
        bone.append(rbox(f"Q_tu{i}", 0.7, 1.1, 0.6, 0.15, 1, (-2.75, -4.85, z)))
        bone.append(rbox(f"Q_tl{i}", 0.7, 0.9, 0.6, 0.15, 1, (-2.55, -5.75, z)))
    bone.append(prism("Q_ped", [(-3.4, -7.3, -4.4), (-3.4, -7.3, 4.4), (-4.6, -20.0, 5.6), (-4.6, -20.0, -5.6)], (8.6, 0, 0)))
    eye = []
    for k, (ey, ez) in enumerate(eyes):
        eye.append(lathe_at(f"Q_eye{k}", [(0.85 * math.sin(t), -0.85 * math.cos(t)) for t in [math.pi * j / 6 for j in range(7)]], (-1.9, ey, ez), 10))
    o = merge_objs("K_Skull7_bone", bone); bm_obj("K_Skull7_dark", dark); merge_objs("K_Skull7_eye", eye)
    return o

def build_rtower7():
    """Raid side tower about 32 tall: round drum with a cornice, a slim upper drum with slit windows, an onion dome and
    a needle spire with a ball."""
    clear_piece("K_RTower7_"); clear_piece("Q_")
    st = [lathe_at("Q_drum", [(0, 0), (4.2, 0), (4.2, 1.2), (3.6, 1.8), (3.6, 15.0), (4.4, 15.6), (4.4, 16.6), (0, 16.6)], (0, 0, 0), 16, False),
          lathe_at("Q_up", [(0, 16.6), (2.9, 16.6), (2.9, 21.5), (3.3, 22.0), (0, 22.0)], (0, 0, 0), 16, False)]
    dk = []
    for i in range(6):
        a = 2 * math.pi * i / 6
        dk.append(rbox_rot(f"Q_slit{i}", 0.5, 3.0, 0.9, (2.85 * math.cos(a), 19.0, 2.85 * math.sin(a)), -a, 0.1, 1))
        dk.append(rbox_rot(f"Q_win{i}", 0.5, 4.5, 1.3, (3.55 * math.cos(a + 0.5), 9.0, 3.55 * math.sin(a + 0.5)), -a - 0.5, 0.1, 1))
    dome = [lathe_at("Q_dome", [(0, 22.0), (3.4, 22.0), (3.9, 23.6), (3.5, 25.4), (2.0, 27.0), (0.6, 28.4), (0.3, 30.4), (0, 31.6)], (0, 0, 0), 16)]
    g = [lathe_at("Q_ball", [(0.5 * math.sin(t), 32.0 - 0.5 * math.cos(t)) for t in [math.pi * j / 6 for j in range(7)]], (0, 0, 0), 8),
         lathe_at("Q_band", [(3.35, 21.9), (3.5, 22.0), (3.5, 22.3), (3.35, 22.4)], (0, 0, 0), 24, False)]
    merge_objs("K_RTower7_stone", st); merge_objs("K_RTower7_darkStone", dk); merge_objs("K_RTower7_dome", dome); merge_objs("K_RTower7_gold", g)

def build_arcade7():
    """Arcade wing 20 long x 12 tall, facing -X: 4 bays with pointed openings, a dark back wall, a parapet with merlons."""
    clear_piece("K_Arcade7_"); clear_piece("Q_")
    st = []; inner = pointed_outline(1.9, 5.0, 8)
    for b in range(4):
        st.append(bay(f"Q_bay{b}", inner, 2.5, 10.0, 5.0, -1.0, 1.0, 'x', (0, 0, -7.5 + 5 * b)))
    st.append(rbox("Q_cor", 2.6, 1.0, 20.6, 0.2, 1, (0, 10.5, 0)))
    for m in range(7):
        st.append(rbox(f"Q_mer{m}", 1.6, 1.6, 1.4, 0.15, 1, (0, 11.8, -9 + 3 * m)))
    st.append(rbox("Q_plinth", 2.8, 0.8, 20.6, 0.15, 1, (0, 0.4, 0)))
    dk = [rbox("Q_back", 0.6, 9.6, 20.0, 0.05, 1, (3.0, 4.8, 0))]
    merge_objs("K_Arcade7_stone", st); merge_objs("K_Arcade7_darkStone", dk)

def build_clump7(tag, seed, R=2.0, kind="grass", n=70):
    """Mounded clump of radius R: a low leafy mound (about 0.6 tall) bristling with cards. kind 'grass' = thin upright
    blades; 'bush' = broad leaf cards pointing up and out. Tinted per flight at placement."""
    random.seed(seed); clear_piece(f"K_{tag}_")
    A, B = bmesh.new(), bmesh.new()
    ico(A, (0, -0.15, 0), R, 2, (1, 0.38, 1))
    for i in range(n):
        a = random.uniform(0, 2 * math.pi); r = R * 0.95 * math.sqrt(random.random())
        y = 0.38 * R * math.sqrt(max(0.0, 1 - (r / R) ** 2)) - 0.25
        b = Vector((r * math.cos(a), y, r * math.sin(a))); out = Vector((math.cos(a), 0, math.sin(a)))
        if kind == "grass":
            d = (Vector((0, 1, 0)) + out * (0.25 + 0.6 * r / R) + Vector((random.gauss(0, 0.15), 0, random.gauss(0, 0.15)))).normalized()
            card(A, B, b, d, random.uniform(0.7, 1.3), 0.16, 0.35, random.uniform(-1, 1), (0.6, 0.8, 0.6, 0.35, 0.0))
        else:
            d = (Vector((0, 0.8, 0)) + out * (0.5 + 0.7 * r / R) + Vector((random.gauss(0, 0.3), random.gauss(0, 0.2), random.gauss(0, 0.3)))).normalized()
            card(A, B, b, d, random.uniform(0.8, 1.3), 0.42, 0.2, random.uniform(-0.8, 0.8))
    bm_obj(f"K_{tag}_leaf", A); bm_obj(f"K_{tag}_leafRim", B)

def build_bigtree7(seed=91, H=46.0, R=40.0, cl=7.0):
    """Story tree: a THICK tapering trunk (r 6.5 at the base) with a huge root flare and buttress roots, 5 twisting
    branches that carry the canopy, and a wide canopy of leaf-card puffs (about 80 across)."""
    random.seed(seed); clear_piece("K_BigTree7_"); clear_piece("Q_")
    A, Bm = bmesh.new(), bmesh.new(); wood = []
    tp = lambda t: Vector((3.0 * math.sin(2.2 * t), H * 0.62 * t, 2.0 * math.sin(1.4 * t + 0.5) - 1.0))
    for k, (t0, t1, r) in enumerate(((0.0, 0.4, 6.5), (0.35, 0.75, 5.2), (0.7, 1.0, 4.0))):
        pts = [tp(t0 + (t1 - t0) * i / 6) for i in range(7)]
        if k == 0: pts[0] = pts[0] + Vector((0, -0.5, 0))
        wood.append(tube_along(f"Q_tr{k}", [tuple(p) for p in pts], r))
    wood.append(lathe_at("Q_flare", [(0, 0), (15.0, 0), (10.0, 1.6), (7.5, 5.0), (6.6, 10.0), (0, 10.2)], (0, -0.3, 0), 14, False))
    for k in range(6):  # buttress roots
        a = 2 * math.pi * k / 6 + 0.4
        wood.append(tube_along(f"Q_root{k}", [(6.0 * math.cos(a), 7.0, 6.0 * math.sin(a)), (11.0 * math.cos(a + 0.15), 2.0, 11.0 * math.sin(a + 0.15)), (16.0 * math.cos(a + 0.3), -0.3, 16.0 * math.sin(a + 0.3))], 1.6))
    ends = []
    for b in range(5):
        a = 2 * math.pi * b / 5 + random.uniform(-0.2, 0.2); p0 = tp(random.uniform(0.6, 0.95)); Rb = R * random.uniform(0.45, 0.6)
        pts = [p0 + Vector((Rb * t * math.cos(a + 0.7 * t), H * 0.35 * t - 4 * t * t + 2 * math.sin(3 * t), Rb * t * math.sin(a + 0.7 * t))) for t in [i / 6 for i in range(7)]]
        wood.append(tube_along(f"Q_bA{b}", [tuple(p) for p in pts[:4]], 2.6)); wood.append(tube_along(f"Q_bB{b}", [tuple(p) for p in pts[3:]], 1.6))
        ends.append(pts[-1])
    C = Vector((0, H, 0)); cents = list(ends)
    for i in range(22):
        y = random.uniform(-0.35, 0.8); rr = math.sqrt(max(0.0, 1 - y * y)); a = random.uniform(0, 2 * math.pi)
        cents.append(C + Vector((R * 0.85 * rr * math.cos(a), R * 0.28 * y, R * 0.85 * rr * math.sin(a))))
    for c in cents:
        ico(A, c, cl * 0.95, 1, (1, 0.7, 1))
        out = (c - C); out = out.normalized() if out.length > 0.1 else Vector((0, 1, 0))
        for j in range(22):
            rd = Vector((random.gauss(0, 1), random.gauss(0, 1), random.gauss(0, 1))).normalized()
            d = (out * 0.7 + rd + Vector((0, 0.3, 0))).normalized(); L = cl * random.uniform(0.7, 1.1)
            card(A, Bm, c + d * cl * 0.55, d, L, L * 0.38, 0.15, random.uniform(-0.8, 0.8))
    merge_objs("K_BigTree7_wood", wood); bm_obj("K_BigTree7_leaf", A); bm_obj("K_BigTree7_leafRim", Bm)

def build_crown7():
    """Gold crown about 7 across x 5 tall for the Story sign: a band with 5 points tipped by balls, and a jewel."""
    clear_piece("K_Crown7_"); clear_piece("Q_")
    g = [lathe("Q_band", [(3.0, 0), (3.4, 0), (3.6, 1.6), (3.2, 1.6), (3.0, 0)], seg=30, smooth=True)]
    for k in range(5):
        a = 2 * math.pi * k / 5; x, z = 3.3 * math.cos(a), 3.3 * math.sin(a)
        g.append(lathe_at(f"Q_pt{k}", [(0, 1.4), (1.0, 1.4), (0.2, 4.2), (0, 4.4)], (x, 0, z), 6, False))
        g.append(lathe_at(f"Q_bl{k}", [(0.45 * math.sin(t), 4.6 - 0.45 * math.cos(t)) for t in [math.pi * j / 6 for j in range(7)]], (x, 0, z), 8))
    gem = [lathe_at("Q_gem", [(0, -0.9), (0.8, 0), (0, 0.9)], (-3.7, 0.8, 0), 6, False)]
    merge_objs("K_Crown7_gold", g); merge_objs("K_Crown7_glass", gem)

def build_umbrella7(tag="Umbrella7"):
    """Market umbrella 7 across x 7.5 tall: 8-panel canopy, pole, round stall table."""
    clear_piece(f"K_{tag}_"); clear_piece("Q_")
    can = [flat(lathe("Q_can", [(0, 7.2), (1.2, 6.9), (3.5, 5.8), (3.6, 5.5), (0.0, 5.55)], seg=8, smooth=False))]
    pole = [lathe_at("Q_pole", [(0, 0), (0.15, 0), (0.15, 7.4), (0, 7.5)], (0, 0, 0), 6, False),
            lathe_at("Q_tab", [(0, 2.6), (2.0, 2.6), (2.0, 2.9), (0, 2.9)], (0, 0, 0), 16, False)]
    merge_objs(f"K_{tag}_canopy", can); merge_objs(f"K_{tag}_white", pole)

def build_all7():
    for s in (71, 72, 73): build_island7(s, R=60.0 if s != 73 else 48.0, towers=2 if s != 72 else 1)
    build_cloud7("Cloud7", 101); build_cloud7("Cloud7B", 102)
    build_skull7(); build_rtower7(); build_arcade7()
    build_clump7("ClumpG", 111, 2.0, "grass", 80); build_clump7("ClumpB", 112, 2.0, "bush", 55)
    build_bigtree7(); build_crown7(); build_umbrella7()

R7_PREFIXES = R6_PREFIXES + ("K_Isl771_", "K_Isl772_", "K_Isl773_", "K_Cloud7_", "K_Cloud7B_", "K_Skull7_", "K_RTower7_", "K_Arcade7_",
                             "K_ClumpG_", "K_ClumpB_", "K_BigTree7_", "K_Crown7_", "K_Umbrella7_")

def export_r7(path):
    """Z-up + UVs (new pieces only; the pass-6 pieces already carry the zup flag), then the export call used since r3."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R7_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 8: waterfall curtains, big ruins, weathered skull,
# Expeditions crescent ring + ornate gate, thick Story tree. Freestyle from the picture set and the round-5 review
# (verify5_plaza.md). Only these pieces (plus a scale marker) go into ae_kit_r8.fbx; the r7 kit stays in Studio.
def build_scale8():
    """10 x 10 x 10 cube: the Studio side measures the import scale from it, then drops it."""
    clear_piece("K_Scale8_")
    o = rbox("K_Scale8_stone", 10.0, 10.0, 10.0, 0.01, 1); return o

def build_fall8(L=80.0, w0=4.5, w1=6.5, rows=14, cols=5):
    """Waterfall curtain: a bowed sheet 4.5 wide at the lip widening to 6.5 at the foot, L long (top at y 0), double
    sided, with a rounded foam lip at the top and a mist cluster (squashed spheres) at the foot. Faces -Z."""
    random.seed(81); clear_piece("K_Fall8_"); clear_piece("Q_")
    bm = bmesh.new(); F = []; B = []
    for r in range(rows + 1):
        t = r / rows; y = -L * t; w = w0 + (w1 - w0) * t
        rowF, rowB = [], []
        for c in range(cols + 1):
            u = c / cols - 0.5; x = u * w + 0.25 * math.sin(3 * t + c)
            z = -1.2 * math.cos(math.pi * u) - 1.5 * t * t  # bowed outward, drifting out as it falls
            rowF.append(bm.verts.new((x, y, z))); rowB.append(bm.verts.new((x, y, z + 0.18)))
        F.append(rowF); B.append(rowB)
    for r in range(rows):
        for c in range(cols):
            bm.faces.new((F[r][c], F[r][c + 1], F[r + 1][c + 1], F[r + 1][c]))
            bm.faces.new((B[r][c], B[r + 1][c], B[r + 1][c + 1], B[r][c + 1]))
    bm_obj("K_Fall8_fall", bm, smooth=True)
    foam = bmesh.new()
    for i in range(7):  # mist at the foot
        a = 2 * math.pi * i / 7; rr = random.uniform(3.0, 5.0)
        ico(foam, (2.5 * math.cos(a), -L - random.uniform(-1, 2), -2.5 + 2.5 * math.sin(a)), rr, 1, (1, 0.6, 1))
    ico(foam, (0, -L + 1.5, -2.5), 5.5, 1, (1.2, 0.7, 1))
    for i in range(3):  # foam lip where the water leaves the rim
        ico(foam, ((i - 1) * 1.7, 0.2, -1.4), 1.3, 1, (1.2, 0.6, 1))
    bm_obj("K_Fall8_foam", foam, smooth=True)

def build_ruin8():
    """Skyline ruins for the islands: an 8 x 8 x 40 arched square tower (4 levels, broken top) and a round domed tower
    (drum r 5 x 26 with 2 rows of 8 dark arched windows, cornice, dome, needle), so the islands carry towers AND domes."""
    clear_piece("K_Ruin8_"); clear_piece("K_Dome8_"); clear_piece("Q_")
    merge_objs("K_Ruin8_white", ruin_tower("r8", 0, 0, 0, 40.0, 8.0, 7))
    st = [lathe_at("Q_drum", [(0, 0), (5.6, 0), (5.6, 1.4), (5.0, 2.0), (5.0, 24.0), (5.8, 24.6), (5.8, 26.0), (0, 26.0)], (0, 0, 0), 24, False),
          lathe_at("Q_dome", [(0, 26.0), (5.2, 26.0), (5.0, 28.5), (4.0, 31.5), (2.2, 33.6), (0, 34.4)], (0, 0, 0), 24),
          lathe_at("Q_ndl", [(0, 34.0), (0.6, 34.0), (0.15, 39.0), (0, 39.2)], (0, 0, 0), 8, False)]
    dk = []
    for row, (yc, h) in enumerate(((8.0, 6.0), (17.5, 5.0))):
        for i in range(8):
            a = 2 * math.pi * (i + 0.5 * row) / 8
            dk.append(rbox_rot(f"Q_w{row}{i}", 0.8, h, 1.8, (4.85 * math.cos(a), yc, 4.85 * math.sin(a)), -a, 0.7, 2))
    merge_objs("K_Dome8_white", st); merge_objs("K_Dome8_darkStone", dk)

def build_skull8():
    """Weathered carved skull, about 11 wide x 14 tall with jaw, facing -X. Pass-7 sphere skull with 2-3 studs (at the
    1.5x placement) of real relief: a heavy brow ridge with a central notch, deeper sockets, cheekbones that stand out,
    temple hollows, a nose cavity, a chin-forward jaw with bigger teeth. Socket/nose faces split into a dark mesh; a
    stepped carved pedestal; two glowing eye cores."""
    clear_piece("K_Skull8_"); clear_piece("Q_")
    bm = bmesh.new(); bmesh.ops.create_uvsphere(bm, u_segments=48, v_segments=32, radius=1.0)
    eyes = [(0.4, -2.0), (0.4, 2.0)]; W = {}
    g = lambda a, b: math.exp(-(a * a + b * b))
    bm.verts.index_update()
    for v in bm.verts:
        x, y, z = v.co.x * 5.2, v.co.y * 6.0, v.co.z * 5.0
        if y < -1.0:
            t = min(1.0, (-y - 1.0) / 5.0); z *= 1 - 0.30 * t; x = x * (1 - 0.15 * t)
        if x < 0: x *= 0.86
        w = 0.0
        front = max(0.0, min(1.0, (-x - 0.5) / 2.0))  # 0 at the sides, 1 on the face
        if front > 0:
            for ey, ez in eyes:
                w = max(w, g((y - ey) / 1.6, (z - ez) / 1.4))
            x += 3.6 * w * front
            dn = g((y + 2.0) / 0.8, z / 0.6); x += 1.9 * dn * front; w = max(w, dn)
            x -= 1.7 * front * g((y - 2.2) / 0.75, 0) * (1 - w) * (1 if abs(z) < 4.2 else 0.3)  # brow ridge
            x += 0.7 * front * g(z / 0.55, (y - 2.6) / 1.0)                                       # brow notch
            for s in (-1, 1):
                ck = g((y + 1.0) / 0.8, (abs(z) - 3.2) / 1.0) if z * s > 0 else 0.0
                x -= 1.4 * ck * front; z += s * 0.5 * ck                                          # cheekbones
            x += 0.6 * front * g((y + 2.9) / 0.6, (abs(z) - 2.2) / 0.9)                           # under-cheek hollow
        if abs(z) > 3.0 and -0.5 < y < 3.5 and x < 1.5:
            z *= 1 - 0.07 * g((y - 1.2) / 1.2, (x + 1.0) / 1.5)                                  # temple hollow
        y += 0.25 * math.sin(3.1 * z + 1.3 * x) * max(0.0, y / 6.0)                               # weathered crown
        v.co = Vector((x, y, z)); W[v.index] = w
    dark = bmesh.new(); dfaces = [f for f in bm.faces if sum(W[v.index] for v in f.verts) / len(f.verts) > 0.3]
    for f in dfaces:
        dark.faces.new([dark.verts.new(v.co) for v in f.verts])
    bmesh.ops.delete(bm, geom=dfaces, context='FACES')
    bone = [bm_obj("Q_head", bm, smooth=True)]
    bone.append(rbox("Q_jaw", 6.4, 2.8, 7.4, 0.9, 2, (0.6, -6.1, 0)))
    bone.append(rbox("Q_chin", 2.2, 2.0, 3.6, 0.6, 2, (-2.4, -6.9, 0)))
    for i in range(8):
        z = -2.6 + 0.74 * i
        bone.append(rbox(f"Q_tu{i}", 0.9, 1.3, 0.62, 0.18, 1, (-2.9, -4.9, z)))
        bone.append(rbox(f"Q_tl{i}", 0.9, 1.0, 0.62, 0.18, 1, (-2.7, -5.9, z)))
    bone.append(prism("Q_ped", [(-3.4, -7.6, -4.6), (-3.4, -7.6, 4.6), (-4.6, -20.0, 5.8), (-4.6, -20.0, -5.8)], (8.6, 0, 0)))
    for k, (y, d) in enumerate(((-9.0, 0.7), (-13.5, 1.0), (-18.6, 1.3))):  # carved cornices on the pedestal
        bone.append(rbox(f"Q_cor{k}", 9.0 + d * 2, 1.0, 10.0 + d * 2 + (y + 20) * -0.2, 0.25, 1, (0.6, y, 0)))
    dk = []  # r8b: the pass-8 crack strips floated in front of the receding crown (read as black antennae): dropped
    eye = []
    for k, (ey, ez) in enumerate(eyes):
        eye.append(lathe_at(f"Q_eye{k}", [(0.9 * math.sin(t), -0.9 * math.cos(t)) for t in [math.pi * j / 6 for j in range(7)]], (-1.6, ey, ez), 10))
    o = merge_objs("K_Skull8_bone", bone)
    d = bm_obj("Q_dk", dark); merge_objs("K_Skull8_dark", [d] + dk); merge_objs("K_Skull8_eye", eye)
    return o

def build_expring8(R=12.0, n=8, span=0.52, depth=1.5):
    """Expeditions halo: n curved crescent shards on a ring of radius R in the XY plane (about 6 long x 1.5 thick each),
    each a crescent whose outer edge bulges and swirls ahead (a pinwheel), plus a 5 x 8 oval core. Faces -Z."""
    clear_piece("K_ExpRing8_"); clear_piece("Q_")
    bm = bmesh.new(); m = 14
    for k in range(n):
        a0 = 2 * math.pi * k / n; I, O = [], []
        for s in range(m + 1):
            t = s / m; pr = max(0.06, math.sin(math.pi * t)); th = a0 - span / 2 + span * t
            ri, ro = R - 0.35 * pr, R + 1.45 * pr; tho = th + 0.10 * pr
            I.append((ri * math.cos(th), ri * math.sin(th))); O.append((ro * math.cos(tho), ro * math.sin(tho)))
        zf, zb = -depth / 2, depth / 2
        If = [bm.verts.new((x, y, zf)) for x, y in I]; Ib = [bm.verts.new((x, y, zb)) for x, y in I]
        Of = [bm.verts.new((x, y, zf)) for x, y in O]; Ob = [bm.verts.new((x, y, zb)) for x, y in O]
        for s in range(m):
            bm.faces.new((If[s], Of[s], Of[s + 1], If[s + 1])); bm.faces.new((Ib[s], Ib[s + 1], Ob[s + 1], Ob[s]))
            bm.faces.new((Of[s], Ob[s], Ob[s + 1], Of[s + 1])); bm.faces.new((If[s], If[s + 1], Ib[s + 1], Ib[s]))
        for s in (0, m): bm.faces.new((If[s], Ib[s], Ob[s], Of[s]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    bm_obj("K_ExpRing8_stone", bm)
    c = bmesh.new(); bmesh.ops.create_uvsphere(c, u_segments=24, v_segments=16, radius=1.0)
    for v in c.verts: v.co = Vector((v.co.x * 2.5, v.co.y * 4.0, v.co.z * 0.6))
    bm_obj("K_ExpRing8_core", c, smooth=True)

def build_expgate8():
    """Ornate Expeditions gate, 1.5x the pass-6 arch: teal round-arch frame (opening 18 wide, top 25.5) with gold outer
    and inner trims, a teal stained-glass field split by gold mullions, a transom and a rose ring; two pale columns
    with gold capitals and small teal domes; a gold crest. Faces -Z: x lateral, z depth."""
    clear_piece("K_ExpGate8_"); clear_piece("Q_")
    teal = [_band_xy("Q_fr", arch_outline(12.0, 13.5, 12.0), arch_outline(9.6, 13.5, 9.6), -1.8, 1.8, 'z')]
    gold = [_band_xy("Q_go", arch_outline(12.7, 13.5, 12.7), arch_outline(12.0, 13.5, 12.0), -2.1, 2.1, 'z'),
            _band_xy("Q_gi", arch_outline(9.6, 13.5, 9.6), arch_outline(9.0, 13.5, 9.0), -1.3, 1.3, 'z')]
    glass = [extrude_outline("Q_field", arch_outline(9.0, 13.5, 9.0), 0.3, 0.0)]
    for x in (-4.5, 0.0, 4.5):
        top = 13.5 + math.sqrt(max(0.0, 9.0 ** 2 - x * x))
        gold.append(rbox(f"Q_mul{x}", 0.45, top, 0.7, 0.1, 1, (x, top / 2, 0)))
    gold.append(rbox("Q_tran", 18.0, 0.45, 0.7, 0.1, 1, (0, 13.5, 0)))
    gold.append(tube_along("Q_rose", [(3.4 * math.cos(2 * math.pi * i / 24), 17.2 + 3.4 * math.sin(2 * math.pi * i / 24), -0.35) for i in range(24)], 0.28, True))
    pale = []
    for s in (-1, 1):
        pale.append(lathe_at(f"Q_col{s}", [(0, 0), (2.2, 0), (2.2, 1.4), (1.6, 2.0), (1.45, 19.0), (0, 19.0)], (s * 15.2, 0, 0), 16))
        gold.append(lathe_at(f"Q_cap{s}", [(0, 19.0), (1.7, 19.0), (2.3, 20.0), (2.3, 20.8), (0, 20.8)], (s * 15.2, 0, 0), 16, False))
        gold.append(lathe_at(f"Q_ring{s}", [(1.5, 6.0), (1.75, 6.2), (1.75, 6.8), (1.5, 7.0)], (s * 15.2, 0, 0), 16, False))
        teal.append(lathe_at(f"Q_dome{s}", [(0, 20.8), (1.9, 20.8), (1.8, 22.2), (1.1, 23.6), (0, 24.2)], (s * 15.2, 0, 0), 16))
        gold.append(lathe_at(f"Q_fin{s}", [(0, 24.0), (0.35, 24.0), (0.08, 26.5), (0, 26.6)], (s * 15.2, 0, 0), 8, False))
        pale.append(rbox(f"Q_ped{s}", 5.0, 1.2, 5.0, 0.3, 1, (s * 15.2, 0.6, 0)))
    gold.append(lathe_at("Q_crest", [(0, 24.8), (1.6, 24.8), (0.9, 26.5), (1.3, 27.5), (0.2, 30.0), (0, 30.2)], (0, 0, 0), 10, False))
    merge_objs("K_ExpGate8_teal", teal); merge_objs("K_ExpGate8_gold", gold)
    merge_objs("K_ExpGate8_glass", glass); merge_objs("K_ExpGate8_pale", pale)

def build_bigtree8(seed=92, H=50.0, R=40.0, cl=7.0):
    """Story tree, pass 8: the trunk 1.6x thicker (r 10.5 at the base, 22-radius root flare) splitting LOW (from about
    16 up) into 7 thick twisting branches (r 4.2 then 2.8) that fan out under the canopy, so the wood shows between the
    sign and the leaves; a canopy of leaf-card puffs about 80 across with interior puffs so it does not go hollow."""
    random.seed(seed); clear_piece("K_BigTree8_"); clear_piece("Q_")
    A, Bm = bmesh.new(), bmesh.new(); wood = []
    tp = lambda t: Vector((2.5 * math.sin(2.0 * t), H * 0.5 * t, 1.6 * math.sin(1.4 * t + 0.5) - 0.8))
    for k, (t0, t1, r) in enumerate(((0.0, 0.45, 10.5), (0.4, 0.75, 8.2), (0.7, 1.0, 6.4))):
        pts = [tp(t0 + (t1 - t0) * i / 6) for i in range(7)]
        if k == 0: pts[0] = pts[0] + Vector((0, -0.5, 0))
        wood.append(tube_along(f"Q_tr{k}", [tuple(p) for p in pts], r, res=10))
    wood.append(lathe_at("Q_flare", [(0, 0), (22.0, 0), (15.0, 2.0), (11.5, 6.0), (10.5, 12.0), (0, 12.2)], (0, -0.3, 0), 18, False))
    for k in range(7):  # buttress roots
        a = 2 * math.pi * k / 7 + 0.3
        wood.append(tube_along(f"Q_root{k}", [(9.5 * math.cos(a), 9.0, 9.5 * math.sin(a)), (15.0 * math.cos(a + 0.15), 2.5, 15.0 * math.sin(a + 0.15)), (22.0 * math.cos(a + 0.3), -0.3, 22.0 * math.sin(a + 0.3))], 2.4))
    ends = []
    for b in range(7):
        a = 2 * math.pi * b / 7 + random.uniform(-0.2, 0.2); p0 = tp(random.uniform(0.62, 0.98)); Rb = R * random.uniform(0.42, 0.58)
        pts = [p0 + Vector((Rb * t * math.cos(a + 0.6 * t), H * 0.42 * t - 3 * t * t + 2 * math.sin(3 * t), Rb * t * math.sin(a + 0.6 * t))) for t in [i / 6 for i in range(7)]]
        wood.append(tube_along(f"Q_bA{b}", [tuple(p) for p in pts[:4]], 4.2, res=8)); wood.append(tube_along(f"Q_bB{b}", [tuple(p) for p in pts[3:]], 2.8))
        for tw in range(2):  # twigs into the canopy
            q = pts[3 + 2 * tw]; d = Vector((math.cos(a + 1.2 * (tw - 0.5)), 1.1, math.sin(a + 1.2 * (tw - 0.5)))).normalized()
            wood.append(tube_along(f"Q_tw{b}{tw}", [tuple(q), tuple(q + d * 6), tuple(q + d * 11 + Vector((0, 2, 0)))], 1.3))
        ends.append(pts[-1])
    C = Vector((0, H, 0)); cents = list(ends)
    for i in range(24):
        y = random.uniform(-0.3, 0.85); rr = math.sqrt(max(0.0, 1 - y * y)); a = random.uniform(0, 2 * math.pi)
        cents.append(C + Vector((R * 0.85 * rr * math.cos(a), R * 0.28 * y, R * 0.85 * rr * math.sin(a))))
    for i in range(9):  # interior puffs (lesson 4 of pass 7)
        a = random.uniform(0, 2 * math.pi); r = random.uniform(0, R * 0.45)
        cents.append(C + Vector((r * math.cos(a), random.uniform(0, 6), r * math.sin(a))))
    for c in cents:
        ico(A, c, cl * 0.95, 1, (1, 0.7, 1))
        out = (c - C); out = out.normalized() if out.length > 0.1 else Vector((0, 1, 0))
        for j in range(20):
            rd = Vector((random.gauss(0, 1), random.gauss(0, 1), random.gauss(0, 1))).normalized()
            d = (out * 0.7 + rd + Vector((0, 0.3, 0))).normalized(); L = cl * random.uniform(0.7, 1.1)
            card(A, Bm, c + d * cl * 0.55, d, L, L * 0.38, 0.15, random.uniform(-0.8, 0.8))
    merge_objs("K_BigTree8_wood", wood); bm_obj("K_BigTree8_leaf", A); bm_obj("K_BigTree8_leafRim", Bm)

def build_pod8():
    """Blue crystal pod (wall tops beside the lanterns, Story ring sides): a faceted 6-sided spindle about 4 x 6.5 with
    a gold cradle ring at the base."""
    clear_piece("K_Pod8_"); clear_piece("Q_")
    gl = [flat(lathe("Q_pod", [(0, 0), (1.4, 0.6), (2.0, 2.4), (1.9, 4.4), (1.0, 5.8), (0, 6.6)], seg=6, smooth=False))]
    gd = [lathe_at("Q_cradle", [(0, -0.4), (1.7, -0.4), (2.0, 0.4), (1.5, 0.9), (0, 0.9)], (0, 0, 0), 12, False)]
    merge_objs("K_Pod8_glass", gl); merge_objs("K_Pod8_gold", gd)

def build_all8():
    build_scale8(); build_fall8(); build_ruin8(); build_skull8(); build_expring8(); build_expgate8(); build_bigtree8(); build_pod8()

R8_PREFIXES = ("K_Scale8_", "K_Fall8_", "K_Ruin8_", "K_Dome8_", "K_Skull8_", "K_ExpRing8_", "K_ExpGate8_", "K_BigTree8_", "K_Pod8_")

def export_r8(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-8 pieces; Studio merges them into the r7 kit."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R8_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

R8B_PREFIXES = ("K_Scale8_", "K_Skull8_")

def export_r8b(path):
    """Re-export of the fixed skull only (plus the scale cube), merged into Kit by build_plaza.lua as ae_kit_r8b."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R8B_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 9: big lush close islands, aqueduct + rotunda ruins,
# wide falls, mid-distance architecture (Guild facade, domed palace, grey tower), Summon two-storey facade, thin Story
# ring, flat leaf spills, own 3D sign letters. Freestyle from the live-reference pictures and verify6_plaza.md.
# Only these pieces (plus the 10-stud cube) go into ae_kit_r9.fbx; build_plaza.lua merges them into Kit.
def build_island9(seed=91, R=50.0, k=0.56):
    """Floating island, pass 9: a 100 x ~56 slab (top at y 0) with a 26-deep faceted rock underside and hanging spikes,
    a THICK grass cap whose skirt droops 2-5 studs over the rim (jagged), and 7 dense vine curtains 10-20 long.
    Ruins, trees and falls are separate kit pieces placed on it in Studio."""
    random.seed(seed); clear_piece(f"K_Isl{seed}_"); clear_piece("Q_")
    ph = [random.uniform(0, 6.28) for _ in range(3)]; n = 44
    fr = [1 + 0.15 * math.sin(2 * a + ph[0]) + 0.10 * math.sin(3 * a + ph[1]) + 0.06 * math.sin(5 * a + ph[2]) + random.uniform(-0.05, 0.05)
          for a in [2 * math.pi * i / n for i in range(n)]]
    rim = lambda i, s: (R * fr[i % n] * s * math.cos(2 * math.pi * i / n), R * k * fr[i % n] * s * math.sin(2 * math.pi * i / n))
    lev = [(1.0, 0.0), (0.96, -4.0), (0.84, -9.0), (0.64, -15.0), (0.42, -21.0), (0.18, -26.0)]
    bm = bmesh.new(); rings = []
    for li, (s, y) in enumerate(lev):
        ring = []
        for i in range(n):
            x, z = rim(i, s)
            if li >= 2:
                f = random.uniform(0.88, 1.12); x *= f; z *= f; yy = y + random.uniform(-3.0, 3.0)
            else:
                yy = y
            ring.append(bm.verts.new((x, yy, z)))
        rings.append(ring)
    bot = bm.verts.new((0, -29.0, 0)); topc = bm.verts.new((0, 0.0, 0))
    for li in range(len(rings) - 1):
        for i in range(n):
            j = (i + 1) % n; bm.faces.new((rings[li][i], rings[li][j], rings[li + 1][j], rings[li + 1][i]))
    for i in range(n):
        bm.faces.new((rings[-1][i], rings[-1][(i + 1) % n], bot)); bm.faces.new((rings[0][(i + 1) % n], rings[0][i], topc))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    rock = [flat(bm_obj("Q_rock", bm))]
    for kk in range(9):
        i = random.randrange(n); s = random.uniform(0.3, 0.75); x, z = rim(i, s); L = random.uniform(8, 20)
        y0 = -8 - 18 * (1 - s)
        rock.append(flat(lathe_at(f"Q_sp{kk}", [(0, y0 + 1), (random.uniform(3, 6), y0 + 1), (random.uniform(1.0, 2.0), y0 - L * 0.6), (0, y0 - L)], (x, 0, z), 5, False)))
    cap = bmesh.new(); ct = cap.verts.new((0, 3.2, 0)); R1, R2_, R3, R4 = [], [], [], []
    for i in range(n):
        x, z = rim(i, 0.9); R1.append(cap.verts.new((x, 3.0 + random.uniform(-0.4, 0.6), z)))
        x, z = rim(i, 1.05); R2_.append(cap.verts.new((x, 1.6, z)))
        x, z = rim(i, 1.07); R3.append(cap.verts.new((x, -0.8, z)))
        x, z = rim(i, 1.035); R4.append(cap.verts.new((x, -random.uniform(2.0, 5.0), z)))  # jagged drooping skirt
    for i in range(n):
        j = (i + 1) % n
        cap.faces.new((ct, R1[j], R1[i])); cap.faces.new((R1[i], R1[j], R2_[j], R2_[i]))
        cap.faces.new((R2_[i], R2_[j], R3[j], R3[i])); cap.faces.new((R3[i], R3[j], R4[j], R4[i]))
    bmesh.ops.recalc_face_normals(cap, faces=cap.faces)
    vines = bmesh.new()
    for c in range(7):
        i0 = random.randrange(n)
        for m in range(11):
            a = 2 * math.pi * (i0 + (m - 5) * 0.25) / n
            f = 1 + 0.15 * math.sin(2 * a + ph[0]) + 0.10 * math.sin(3 * a + ph[1]) + 0.06 * math.sin(5 * a + ph[2])
            cx, cz = R * f * 1.06 * math.cos(a), R * k * f * 1.06 * math.sin(a)
            nrm = Vector((cx, 0, cz / (k * k))).normalized(); tg = Vector((-nrm.z, 0, nrm.x)) * 0.6
            L = random.uniform(10, 20) * (1 - abs(m - 5) / 9); c0 = Vector((cx, -1.0, cz))
            ds_quad(vines, [c0 - tg, c0 + tg, c0 + tg * 0.3 + Vector((0, -L, 0)) - nrm * 1.2, c0 - tg * 0.3 + Vector((0, -L, 0)) - nrm * 1.2])
    merge_objs(f"K_Isl{seed}_rock", rock); bm_obj(f"K_Isl{seed}_grass", cap, smooth=True); bm_obj(f"K_Isl{seed}_vine", vines)

def build_aque9():
    """Ruined aqueduct: 5 round-arched bays (8 wide, piers 13 tall), a deck with a parapet lip, the last bay broken.
    Faces -Z, x lateral, about 40 long x 3.6 deep x 15 tall."""
    clear_piece("K_Aque9_"); clear_piece("Q_")
    st = []; inner = arch_outline(2.9, 8.0, 2.9, 2, 12)
    for b in range(5):
        top = 13.0 if b < 4 else 10.5
        st.append(bay(f"Q_b{b}", inner, 4.0, top, 8.0, -1.8, 1.8, 'z', (-16 + 8 * b, 0, 0)))
    st.append(rbox("Q_deck", 32.6, 1.2, 4.2, 0.2, 1, (-4.0, 13.6, 0)))
    for s in (-1, 1): st.append(rbox(f"Q_lip{s}", 32.6, 0.9, 0.5, 0.1, 1, (-4.0, 14.6, s * 1.9)))
    st.append(rbox("Q_stub", 3.0, 2.0, 3.6, 0.3, 1, (14.5, 11.5, 0)))
    merge_objs("K_Aque9_white", st)

def build_rot9():
    """Domed rotunda: 2-step round base, 8 columns on r 6, an entablature ring and a dome, about 16 across x 24."""
    clear_piece("K_Rot9_"); clear_piece("Q_")
    st = [lathe_at("Q_base", [(0, 0), (8.0, 0), (8.0, 0.9), (7.2, 0.9), (7.2, 1.8), (0, 1.8)], (0, 0, 0), 32, False),
          lathe_at("Q_ent", [(0, 12.0), (7.3, 12.0), (7.3, 13.6), (7.6, 13.9), (7.6, 14.5), (0, 14.5)], (0, 0, 0), 32, False),
          lathe_at("Q_dome", [(0, 14.5), (6.8, 14.5), (6.4, 17.0), (5.0, 19.4), (2.8, 21.0), (0, 21.6)], (0, 0, 0), 32),
          lathe_at("Q_lan", [(0, 21.2), (1.1, 21.2), (1.1, 23.0), (1.4, 23.2), (0, 24.0)], (0, 0, 0), 12, False)]
    for i in range(8):
        a = 2 * math.pi * i / 8
        st.append(lathe_at(f"Q_c{i}", [(0, 1.8), (0.95, 1.8), (0.95, 2.4), (0.7, 2.8), (0.65, 11.2), (1.0, 11.6), (1.0, 12.0), (0, 12.0)], (6.0 * math.cos(a), 0, 6.0 * math.sin(a)), 10, False))
    merge_objs("K_Rot9_white", st)

def build_fall9(L=50.0, w0=7.0, w1=9.5, rows=12, cols=7):
    """Wide waterfall: bowed double-sided sheet 7 wide at the lip, 9.5 at the foot, L long (top at y 0), drifting out as it
    falls, with a broad foam lip and a mist cluster at the foot. Faces -Z."""
    random.seed(93); clear_piece("K_Fall9_"); clear_piece("Q_")
    bm = bmesh.new(); F = []; B = []
    for r in range(rows + 1):
        t = r / rows; y = -L * t; w = w0 + (w1 - w0) * t
        rowF, rowB = [], []
        for c in range(cols + 1):
            u = c / cols - 0.5; x = u * w + 0.3 * math.sin(3 * t + c)
            z = -1.6 * math.cos(math.pi * u) - 2.0 * t * t
            rowF.append(bm.verts.new((x, y, z))); rowB.append(bm.verts.new((x, y, z + 0.2)))
        F.append(rowF); B.append(rowB)
    for r in range(rows):
        for c in range(cols):
            bm.faces.new((F[r][c], F[r][c + 1], F[r + 1][c + 1], F[r + 1][c]))
            bm.faces.new((B[r][c], B[r + 1][c], B[r + 1][c + 1], B[r][c + 1]))
    bm_obj("K_Fall9_fall", bm, smooth=True)
    foam = bmesh.new()
    for i in range(9):
        a = 2 * math.pi * i / 9; rr = random.uniform(3.5, 6.0)
        ico(foam, (4.0 * math.cos(a), -L - random.uniform(-1, 2), -3.0 + 3.0 * math.sin(a)), rr, 1, (1, 0.6, 1))
    for i in range(4):
        ico(foam, ((i - 1.5) * 2.0, 0.2, -1.8), 1.5, 1, (1.2, 0.6, 1))
    bm_obj("K_Fall9_foam", foam, smooth=True)

def arch_win(name, hw, hs, ry, loc, depth=0.6):
    """Dark arched window/door slab (XY outline, extruded along Z), set just proud of a -Z facing wall."""
    o = extrude_outline(name, arch_outline(hw, hs, ry, 2, 10), depth, 0.0); o.location = loc; flat(o); return o

def build_guild9():
    """Guild hall facade, about 50 wide x 46 tall x 12 deep, facing -Z: cream body with pilasters, three gold cornices,
    a big arched portal, arched windows on 3 floors, a raised central attic with a pediment and two corner towers with
    blue domes."""
    clear_piece("K_Guild9_"); clear_piece("Q_")
    cr, gd, dk, bl = [], [], [], []
    cr.append(rbox("Q_body", 46.0, 33.0, 12.0, 0.4, 1, (0, 16.5, 6.0)))
    for x in (-19.5, -13, -6.5, 6.5, 13, 19.5):
        cr.append(rbox(f"Q_pil{x}", 1.8, 31.0, 1.0, 0.2, 1, (x, 16.0, -0.3)))
    for y in (11.5, 22.5, 33.0):
        gd.append(rbox(f"Q_cor{y}", 47.5, 1.0, 13.4, 0.2, 1, (0, y, 6.0)))
    dk.append(arch_win("Q_door", 4.0, 5.5, 4.0, (0, 0, -0.1), 0.8))
    gd.append(tube_along("Q_doorT", [(x, y, -0.6) for x, y in arch_outline(4.6, 5.5, 4.6, 2, 16)], 0.35))
    for i, x in enumerate((-16.2, -9.7, 9.7, 16.2)):
        dk.append(arch_win(f"Q_w1{i}", 1.6, 4.0, 1.6, (x, 2.5, -0.1)))
    for i in range(7):
        dk.append(arch_win(f"Q_w2{i}", 1.5, 4.5, 1.5, (-19.5 + 6.5 * i, 14.0, -0.1)))
    for i in range(9):
        dk.append(arch_win(f"Q_w3{i}", 1.0, 3.2, 1.0, (-20 + 5 * i, 25.0, -0.1)))
    cr.append(rbox("Q_attic", 20.0, 7.0, 10.0, 0.3, 1, (0, 37.0, 6.0)))
    cr.append(prism("Q_ped", [(-11, 40.5, 0.8), (11, 40.5, 0.8), (0.01, 46.0, 0.8), (-0.01, 46.0, 0.8)], (0, 0, 8.0)))
    gd.append(rbox("Q_attB", 21.5, 0.8, 11.0, 0.2, 1, (0, 40.6, 6.0)))
    gd.append(tube_along("Q_pedT", [(-11, 40.9, 0.6), (0, 46.3, 0.6), (11, 40.9, 0.6)], 0.4))
    for s in (-1, 1):
        cr.append(rbox(f"Q_tw{s}", 7.0, 40.0, 7.0, 0.3, 1, (s * 24.5, 20.0, 5.0)))
        gd.append(rbox(f"Q_twB{s}", 8.0, 0.8, 8.0, 0.2, 1, (s * 24.5, 40.2, 5.0)))
        bl.append(lathe_at(f"Q_twD{s}", [(0, 40.6), (3.6, 40.6), (3.4, 42.6), (2.4, 44.6), (0.8, 46.0), (0, 46.4)], (s * 24.5, 0, 5.0), 16))
        gd.append(lathe_at(f"Q_twF{s}", [(0, 46.2), (0.35, 46.2), (0.1, 49.0), (0, 49.2)], (s * 24.5, 0, 5.0), 8, False))
        for y in (8.0, 19.0, 30.0):
            dk.append(arch_win(f"Q_tww{s}{int(y)}", 1.1, 3.4, 1.1, (s * 24.5, y, 1.4)))
    merge_objs("K_Guild9_cream", cr); merge_objs("K_Guild9_gold", gd); merge_objs("K_Guild9_dark", dk); merge_objs("K_Guild9_blue", bl)

def build_palace9():
    """Domed palace, about 32 across x 48 tall: a cream block with arched windows on all 4 sides, a drum with windows,
    a big blue dome with a gold lantern, 4 corner turrets with small blue domes."""
    clear_piece("K_Palace9_"); clear_piece("Q_")
    cr, gd, dk, bl = [], [], [], []
    cr.append(rbox("Q_body", 24.0, 20.0, 24.0, 0.4, 1, (0, 10.0, 0)))
    gd.append(rbox("Q_cor", 25.4, 1.0, 25.4, 0.2, 1, (0, 20.2, 0)))
    gd.append(rbox("Q_cor2", 25.0, 0.7, 25.0, 0.2, 1, (0, 9.0, 0)))
    for f in range(4):
        a = math.pi / 2 * f
        for x in (-6.5, 0.0, 6.5):
            for y in (2.0, 11.5):
                o = arch_win(f"Q_w{f}{int(x)}{int(y)}", 1.5 if x else 2.2, 4.0, 1.5 if x else 2.2, (0, 0, 0))
                o.data.transform(Matrix.Rotation(a, 4, 'Y') @ Matrix.Translation((x, y, -12.05))); dk.append(o)
    cr.append(lathe_at("Q_drum", [(0, 20.6), (9.0, 20.6), (9.0, 29.0), (9.6, 29.4), (9.6, 30.2), (0, 30.2)], (0, 0, 0), 32, False))
    for i in range(12):
        a = 2 * math.pi * i / 12
        dk.append(rbox_rot(f"Q_dw{i}", 0.6, 5.0, 1.6, (8.85 * math.cos(a), 25.0, 8.85 * math.sin(a)), -a, 0.5, 2))
    bl.append(lathe_at("Q_dome", [(0, 30.2), (9.4, 30.2), (9.0, 34.0), (7.4, 38.0), (4.4, 41.4), (0, 43.0)], (0, 0, 0), 32))
    gd.append(lathe_at("Q_lan", [(0, 42.6), (1.2, 42.6), (1.2, 44.4), (0.5, 45.0), (0.15, 48.0), (0, 48.2)], (0, 0, 0), 12, False))
    for sx in (-1, 1):
        for sz in (-1, 1):
            c = (sx * 12.0, 0, sz * 12.0)
            cr.append(lathe_at(f"Q_t{sx}{sz}", [(0, 0), (3.2, 0), (3.2, 24.0), (3.6, 24.4), (3.6, 25.0), (0, 25.0)], c, 16, False))
            bl.append(lathe_at(f"Q_td{sx}{sz}", [(0, 25.0), (3.3, 25.0), (3.0, 27.0), (1.8, 29.0), (0, 30.4)], c, 16))
            gd.append(lathe_at(f"Q_tf{sx}{sz}", [(0, 30.2), (0.3, 30.2), (0.08, 32.4), (0, 32.5)], c, 6, False))
    merge_objs("K_Palace9_cream", cr); merge_objs("K_Palace9_gold", gd); merge_objs("K_Palace9_dark", dk); merge_objs("K_Palace9_blue", bl)

def build_tower9():
    """Slender grey tower 8 x 8 x 74: a square shaft with cornice bands every 13, arched windows on 4 faces per level,
    an open arched belfry and a steep 4-sided spire."""
    clear_piece("K_Tower9_"); clear_piece("Q_")
    st, dk, rf = [], [], []
    st.append(rbox("Q_shaft", 8.0, 52.0, 8.0, 0.3, 1, (0, 26.0, 0)))
    st.append(rbox("Q_plinth", 9.4, 2.0, 9.4, 0.2, 1, (0, 1.0, 0)))
    for y in (13.0, 26.0, 39.0, 52.0):
        st.append(rbox(f"Q_b{int(y)}", 9.0, 0.9, 9.0, 0.15, 1, (0, y, 0)))
    for f in range(4):
        a = math.pi / 2 * f
        for y in (16.0, 29.0, 42.0):
            o = arch_win(f"Q_w{f}{int(y)}", 1.1, 4.5, 1.1, (0, 0, 0))
            o.data.transform(Matrix.Rotation(a, 4, 'Y') @ Matrix.Translation((0, y, -4.05))); dk.append(o)
    inner = arch_outline(2.0, 4.0, 2.0, 2, 10)
    for k, (ax, d0, d1) in enumerate((("z", -4.0, -3.2), ("z", 3.2, 4.0), ("x", -4.0, -3.2), ("x", 3.2, 4.0))):
        st.append(bay(f"Q_bel{k}", inner, 4.0, 7.0, 4.0, d0, d1, ax, (0, 52.4, 0)))
    st.append(rbox("Q_belT", 9.0, 0.9, 9.0, 0.15, 1, (0, 59.8, 0)))
    sp = flat(lathe_at("Q_spire", [(0, 60.2), (6.0, 60.2), (0.2, 74.0), (0, 74.2)], (0, 0, 0), 4, False))
    sp.rotation_euler = (0, math.pi / 4, 0); rf.append(sp)
    merge_objs("K_Tower9_stone", st); merge_objs("K_Tower9_dark", dk); merge_objs("K_Tower9_roof", rf)

def build_summon9():
    """Summon hall, two-storey arcade facade 50 wide x 35 tall x 14 deep, facing -Z: 5 big arches below, 7 smaller above,
    a blue band between the storeys, a gold frieze and an attic with a central pediment, dark back wall and body."""
    clear_piece("K_Summon9_"); clear_piece("Q_")
    cr, gd, dk, bl = [], [], [], []
    inner1 = arch_outline(3.6, 6.0, 3.6, 2, 12)
    for b in range(5):
        cr.append(bay(f"Q_g{b}", inner1, 5.0, 12.0, 6.0, -1.2, 1.2, 'z', (-20 + 10 * b, 0, 0)))
    inner2 = arch_outline(2.3, 4.6, 2.3, 2, 10)
    hw2 = 50.0 / 14
    for b in range(7):
        cr.append(bay(f"Q_u{b}", inner2, hw2, 11.0, 4.6, -1.0, 1.0, 'z', (-25 + hw2 * (2 * b + 1), 13.4, 0)))
    bl.append(rbox("Q_band", 51.0, 1.4, 3.0, 0.2, 1, (0, 12.7, 0)))
    gd.append(rbox("Q_band2", 51.4, 0.4, 3.2, 0.1, 1, (0, 13.5, 0)))
    gd.append(rbox("Q_fr", 51.6, 1.0, 3.4, 0.2, 1, (0, 24.9, 0)))
    cr.append(rbox("Q_attic", 50.0, 4.0, 3.0, 0.3, 1, (0, 27.4, 0)))
    gd.append(rbox("Q_attT", 51.0, 0.6, 3.4, 0.1, 1, (0, 29.6, 0)))
    cr.append(prism("Q_ped", [(-9, 29.9, -1.2), (9, 29.9, -1.2), (0.01, 35.0, -1.2), (-0.01, 35.0, -1.2)], (0, 0, 2.4)))
    gd.append(tube_along("Q_pedT", [(-9.3, 30.0, -1.4), (0, 35.3, -1.4), (9.3, 30.0, -1.4)], 0.35))
    for x in (-25, -15, -5, 5, 15, 25):
        gd.append(rbox(f"Q_pin{x}", 1.0, 1.2, 1.0, 0.1, 1, (x, 30.5, 0)))
    dk.append(rbox("Q_back", 49.0, 28.0, 0.6, 0.1, 1, (0, 14.0, 4.0)))
    cr.append(rbox("Q_body", 50.0, 30.0, 10.0, 0.3, 1, (0, 15.0, 9.4)))
    merge_objs("K_Summon9_cream", cr); merge_objs("K_Summon9_gold", gd); merge_objs("K_Summon9_dark", dk); merge_objs("K_Summon9_blue", bl)

def build_ring9():
    """Story portal ring, thin ornate frame: inner r 7.4, outer r 9.4, 2.4 deep (the pass-7 ring read as a cannon
    side-on), gold inner and outer trims front and back, 8 gem studs, a fan crest with a gem on top, two feet, and a dark
    void disc. XY plane, faces -Z, centre y 10."""
    clear_piece("K_Ring9_"); clear_piece("Q_")
    C = 10.0; n = 64
    circ = lambda r, k: (r * math.cos(2 * math.pi * k / n), C + r * math.sin(2 * math.pi * k / n))
    sv = [_band_xy("Q_fr", [circ(9.4, k) for k in range(n + 1)], [circ(7.4, k) for k in range(n + 1)], -1.2, 1.2, 'z')]
    gd = []
    for z in (-1.3, 1.3):
        gd.append(tube_along(f"Q_ti{z}", [circ(7.4, k) + (z,) for k in range(n)], 0.35, True))
        gd.append(tube_along(f"Q_to{z}", [circ(9.4, k) + (z,) for k in range(n)], 0.35, True))
    gm = []
    for k in range(8):
        a = 2 * math.pi * k / 8 + math.pi / 8
        for z in (-1.4, 1.4):
            g = flat(lathe_at(f"Q_g{k}{z}", [(0, -0.7), (0.7, 0), (0, 0.7)], (8.4 * math.cos(a), C + 8.4 * math.sin(a), z), 6, False))
            g.rotation_euler = (math.pi / 2, 0, 0); gm.append(g)
    fan = [(0.0, C + 9.0)]
    for k in range(13):
        a = math.pi * (0.2 + 0.6 * k / 12); r = 6.0 if k % 2 == 0 else 4.2
        fan.append((r * math.cos(a), C + 9.0 + r * math.sin(a) * 0.9))
    sv.append(flat(extrude_outline("Q_crest", fan, 1.6, 0.0)))
    cg = flat(lathe_at("Q_cg", [(0, -1.2), (1.2, 0), (0, 1.2)], (0, C + 12.4, 0), 6, False)); cg.rotation_euler = (math.pi / 2, 0, 0); gm.append(cg)
    for s in (-1, 1):
        sv.append(prism(f"Q_ft{s}", [(s * 5.0, 0, -1.6), (s * 9.5, 0, -1.6), (s * 7.6, 3.4, -1.6), (s * 5.8, 3.0, -1.6)], (0, 0, 3.2)))
    vd = [extrude_outline("Q_void", [circ(7.45, k) for k in range(n)], 0.3, 0.0)]
    merge_objs("K_Ring9_silver", sv); merge_objs("K_Ring9_gold", gd); merge_objs("K_Ring9_gem", gm); merge_objs("K_Ring9_void", vd)

def build_spill9(tag="Spill9", seed=95, R=4.5, n=70):
    """Flat leaf spill (round 6: splashes, not mounds): a thin ragged base splash and leaf cards lying nearly flat, nothing
    taller than about 0.4; denser in the middle, thinning to a ragged edge. Tinted per zone at placement."""
    random.seed(seed); clear_piece(f"K_{tag}_")
    A, B = bmesh.new(), bmesh.new()
    m = 28; pts = []
    for i in range(m):
        a = 2 * math.pi * i / m; r = R * (0.55 + 0.25 * math.sin(3 * a + 1.0) + (0.25 if i % 2 else 0.0) * random.uniform(0.5, 1.0))
        pts.append((r * math.cos(a), r * 0.8 * math.sin(a)))
    ds_quad_fan = [A.verts.new((x, 0.08, z)) for x, z in pts]; c = A.verts.new((0, 0.1, 0))
    for i in range(m): A.faces.new((c, ds_quad_fan[(i + 1) % m], ds_quad_fan[i]))
    for i in range(n):
        a = random.uniform(0, 2 * math.pi); r = R * 0.95 * math.sqrt(random.random()) ** 1.3
        b = Vector((r * math.cos(a), 0.1, r * 0.8 * math.sin(a)))
        d = Vector((math.cos(a + random.uniform(-0.8, 0.8)), random.uniform(0.02, 0.1), math.sin(a + random.uniform(-0.8, 0.8)))).normalized()
        card(A, B, b, d, random.uniform(0.9, 1.6), 0.4, 0.02, 0, (0.15, 0.55, 0.45, 0.25, 0.0))
    bmesh.ops.recalc_face_normals(A, faces=A.faces)
    bm_obj(f"K_{tag}_leaf", A); bm_obj(f"K_{tag}_leafRim", B)

def build_text9(tag, text, height, depth=1.0, font_path=r"C:\Windows\Fonts\georgiab.ttf", bevel=0.12):
    """Own 3D sign letters: a Blender text object in a system font, extruded and bevelled, converted to mesh, centred on
    the origin, cap height about `height` studs, in the XY plane reading from -Z (y up)."""
    clear_piece(f"K_{tag}_")
    cu = bpy.data.curves.new(f"{tag}_txt", "FONT"); cu.body = text
    try: cu.font = bpy.data.fonts.load(font_path, check_existing=True)
    except Exception: pass
    cu.align_x = 'CENTER'; cu.align_y = 'CENTER'; cu.extrude = depth / 2; cu.bevel_depth = bevel; cu.bevel_resolution = 0
    cu.resolution_u = 4
    cu.size = height / 0.7
    ob = bpy.data.objects.new(f"{tag}_tmp", cu); coll().objects.link(ob)
    dg = bpy.context.evaluated_depsgraph_get(); me = bpy.data.meshes.new_from_object(ob.evaluated_get(dg))
    bpy.data.objects.remove(ob, do_unlink=True); bpy.data.curves.remove(cu)
    me.transform(Matrix.Rotation(math.pi, 4, 'Y'))  # text is authored reading from +Z: turn it to read from -Z
    bm = bmesh.new(); bm.from_mesh(me); bpy.data.meshes.remove(me)
    bmesh.ops.triangulate(bm, faces=bm.faces[:]); bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return bm_obj(f"K_{tag}_letters", bm)

def build_scale9():
    clear_piece("K_Scale9_"); return rbox("K_Scale9_stone", 10.0, 10.0, 10.0, 0.01, 1)

def build_all9():
    build_scale9()
    build_island9(91, 50.0); build_island9(92, 56.0, 0.5)
    build_aque9(); build_rot9(); build_fall9()
    build_guild9(); build_palace9(); build_tower9(); build_summon9(); build_ring9(); build_spill9()
    build_text9("TxtRaid9", "Raid", 5.6, 1.4); build_text9("TxtGuild9", "Guilds", 5.4, 1.2); build_text9("TxtSummon9", "Summon", 4.0)
    build_text9("TxtStory9", "Story", 4.4); build_text9("TxtExp9", "Expeditions", 3.0); build_text9("TxtBoss9", "Boss Rush", 2.6)

R9_PREFIXES = ("K_Scale9_", "K_Isl91_", "K_Isl92_", "K_Aque9_", "K_Rot9_", "K_Fall9_", "K_Guild9_", "K_Palace9_", "K_Tower9_",
               "K_Summon9_", "K_Ring9_", "K_Spill9_", "K_TxtRaid9_", "K_TxtGuild9_", "K_TxtSummon9_", "K_TxtStory9_", "K_TxtExp9_", "K_TxtBoss9_")

def export_r9(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-9 pieces; Studio merges them into Kit."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R9_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 10 (verify7_plaza.md, round 7 against the live
# reference): mostly Studio-side value corrections; the only new meshes are the hero with the smaller, recessed basin and
# the Expeditions triptych gate.
def build_hero10():
    """Corner hero piece, pass 10 (round-7 item 4): build_hero6 with the basin 15% smaller and 3.5 further back (centre
    w 33.1) so its back rim sits under the arch mouth, and WITHOUT the upper tier (pale 6-wide drum + gold bars), which
    was the oversized drum; the small 4 x 1.8 slatted drum is built from Parts in Studio. The curved sheet and splash
    are dropped too (hidden in Studio since pass 9)."""
    clear_piece("K_Hero"); clear_piece("Q_")
    G = {"stone": [], "rib": [], "darkStone": [], "gold": [], "goldBas": [], "goldLan": [], "blue": [], "glass": [], "core": [],
         "water": [], "sheet": [], "foam": [], "vault": []}
    W0, W1 = 33.0, 39.5
    outer = arch_outline(10.0, 5.0, 5.0); in1 = arch_outline(7.6, 4.2, 4.0); in2 = arch_outline(7.0, 4.0, 3.6); in3 = arch_outline(6.5, 3.8, 3.2)
    G["stone"].append(arch_band("Q_arch", outer, in1, W0, W1))
    G["rib"].append(arch_band("Q_rib1", in1, in2, W0 + 0.7, W1))
    G["darkStone"].append(arch_band("Q_rib2", in2, in3, W0 + 1.4, W1))
    G["gold"].append(ribbon_uy("Q_gArchO", outer, 0.55, W0))
    G["gold"].append(ribbon_uy("Q_gArchI", arch_outline(8.25, 4.35, 4.6), 0.45, W0))
    G["gold"].append(ribbon_uy("Q_gArchR", in1, 0.3, W0 + 0.7))
    # crown crest: sloping shoulders from the band, two 3-wide arms with a chamfered (hooked) outer top corner, a 4.8-wide window
    C = [(-8.0, 7.9), (8.0, 7.9), (5.7, 10.7), (5.7, 12.5), (4.8, 13.5), (2.4, 13.5), (2.4, 9.4), (-2.4, 9.4), (-2.4, 13.5), (-4.8, 13.5), (-5.7, 12.5), (-5.7, 10.7)]
    G["stone"].append(extrude_uy("Q_crest", C, W0 + 0.3, W0 + 3.8))
    G["gold"].append(ribbon_uy("Q_gCrest", C[1:] + C[:1], 0.42, W0 + 0.3, closed=True))
    G["vault"].append(extrude_uy("Q_crestWin", [(-2.4, 9.4), (2.4, 9.4), (2.4, 9.9), (-2.4, 9.9)], W0 + 0.6, W0 + 3.5))
    # shoulder wings (as pass 5) with flat gold top strips
    G["stone"].append(prism("Q_wingL", [(17, 6.0, -31.1), (17, 10.0, -31.1), (17, 7.2, -48), (17, 6.0, -48)], (2.6, 0, 0)))
    G["stone"].append(prism("Q_wingR", [(31.1, 6.0, -17), (31.1, 10.0, -17), (48, 7.2, -17), (48, 6.0, -17)], (0, 0, -2.6)))
    G["gold"].append(prism("Q_gWingL", [(16.85, 9.45, -31.1), (16.85, 10.05, -31.1), (16.85, 7.25, -48), (16.85, 6.65, -48)], (0.2, 0, 0)))
    G["gold"].append(prism("Q_gWingR", [(31.1, 9.45, -16.85), (31.1, 10.05, -16.85), (48, 7.25, -16.85), (48, 6.65, -16.85)], (0, 0, -0.2)))
    # vault interior (lighter slate), gold shelf, curved water sheet from the shelf into the upper bowl
    G["vault"].append(rbox_rot("Q_nicheBack", 13.4, 7.4, 0.8, P(0, 3.7, 40.2), math.radians(-45), 0.2, 1))
    G["vault"].append(rbox_rot("Q_nicheTop", 13.4, 0.8, 1.6, P(0, 7.2, 40.0), math.radians(-45), 0.2, 1))
    G["gold"].append(rbox_rot("Q_shelf", 12.6, 0.5, 1.4, P(0, 5.0, 39.3), math.radians(-45), 0.2, 1))
    G["vault"].append(rbox_rot("Q_shelfBk", 12.6, 0.8, 0.8, P(0, 6.0, 39.6), math.radians(-45), 0.2, 1))
    bw = 33.1; bx, _, bz = P(0, 0, bw)
    # corner block (y 0..6), notch behind the vault
    poly = [P(-10, 0, 34), P(-6.5, 0, 34), P(-6.5, 0, 41), P(6.5, 0, 41), P(6.5, 0, 34), P(10, 0, 34), (62, 0, -17), (62, 0, -62), (17, 0, -62)]
    G["stone"].append(extrude_plan("Q_block", [(p[0], p[2]) for p in poly], 0.0, 6.0))
    G["gold"].append(ribbon_xz("Q_gTopL", [(17.0, -62), (17.0, -31.1)], -0.5, 6.0))
    G["gold"].append(ribbon_xz("Q_gTopR", [(62, -17.0), (31.1, -17.0)], -0.5, 6.0))
    G["gold"].append(prism("Q_gStrL", [(16.85, 0.5, -28), (16.85, 1.1, -28), (16.85, 6.6, -48), (16.85, 6.0, -48)], (0.2, 0, 0)))
    G["gold"].append(prism("Q_gStrR", [(28, 0.5, -16.85), (28, 1.1, -16.85), (48, 6.6, -16.85), (48, 6.0, -16.85)], (0, 0, -0.2)))
    # single-tier basin, 0.85x, under the arch mouth (foot r 5.45, bowl r 4.75, water at 2.05)
    G["goldBas"].append(lathe_at("Q_basinFoot", [(0, 0), (5.45, 0), (5.45, 0.45), (5.1, 0.6), (0, 0.6)], (bx, 0, bz), 40, False))
    G["stone"].append(lathe_at("Q_basin", [(0, 0.6), (4.75, 0.6), (4.75, 2.4), (4.15, 2.4), (4.15, 1.6), (0, 1.6)], (bx, 0, bz), 40))
    G["rib"].append(lathe_at("Q_basinBand", [(4.8, 0.9), (4.9, 1.0), (4.9, 1.6), (4.8, 1.7)], (bx, 0, bz), 40))
    G["goldBas"].append(lathe_at("Q_gBasinA", [(4.15, 2.4), (4.8, 2.4), (4.8, 2.55), (4.15, 2.55)], (bx, 0, bz), 40, False))
    G["water"].append(lathe_at("Q_wBasinA", [(0, 2.05), (4.15, 2.05)], (bx, 0, bz), 40))
    # raised pool behind the gate (as pass 5)
    px, _, pz = P(0, 0, 55.0)
    G["stone"].append(lathe_at("Q_poolRim", [(12.4, 6.0), (14.5, 6.0), (14.5, 7.6), (14.1, 8.0), (12.8, 8.0), (12.4, 7.6), (12.4, 6.0)], (px, 0, pz), 48))
    G["gold"].append(lathe_at("Q_gPool", [(13.0, 8.0), (13.9, 8.0), (13.9, 8.1), (13.0, 8.1)], (px, 0, pz), 64, False))
    G["water"].append(lathe_at("Q_wPool", [(0, 7.0), (12.45, 7.0)], (px, 0, pz), 48))
    G["darkStone"].append(lathe_at("Q_rock", [(0, 6.0), (4.5, 6.0), (4.1, 7.8), (2.8, 9.2), (1.0, 9.8), (0, 9.8)], (px, 0, pz), 9, False))
    for s in (-1, 1):
        L = lantern6(f"Q_lan{s}", P(s * 14.0, 0, 52.0), 4.0)   # 2 lower: the drum bottom sinks into the block
        for k, v in L.items(): G["goldLan" if k == "gold" else k] += v
    out = []
    for k, objs in G.items():
        if objs: out.append(merge_objs(f"K_Hero_{k}", objs, mirror4=True).name)
    st = bpy.data.objects["K_Hero_stone"]
    bm = bmesh.new(); bm.from_mesh(st.data); bm2 = bm.copy()
    def top(f):
        c = f.calc_center_median()
        return f.normal.y > 0.9 and all(abs(v.co.y - 6.0) < 0.01 for v in f.verts) and abs(c.x) > 16.9 and abs(c.z) > 16.9
    bmesh.ops.delete(bm, geom=[f for f in bm.faces if top(f)], context='FACES'); bm.to_mesh(st.data); bm.free()
    bmesh.ops.delete(bm2, geom=[f for f in bm2.faces if not top(f)], context='FACES')
    me = bpy.data.meshes.new("K_Hero_turf"); bm2.to_mesh(me); bm2.free(); ob = bpy.data.objects.new("K_Hero_turf", me); coll().objects.link(ob)
    return out + ["K_Hero_turf"]

def build_trip10():
    """Expeditions triptych gate, faces -Z (x lateral, y up, z depth): a centre round arch 12 wide x 20 (opening 9 wide,
    springing 11) and two side arches 8 wide x 14 (opening 5.2), teal frames 3 deep with gold tube trims on the front,
    pale columns between them with urns, a dark-teal portal field with a 3-turn spiral (the swirl) and a pale statue on a
    plinth in the centre opening, teal glass in the side openings, a gold filigree crest."""
    clear_piece("K_Trip10_"); clear_piece("Q_")
    G = {"teal": [], "gold": [], "pale": [], "portal": [], "swirl": [], "glass": []}
    for cx, hw, ow, hs, top in ((0.0, 6.0, 4.5, 11.0, 20.0), (-10.5, 4.0, 2.6, 7.5, 14.0), (10.5, 4.0, 2.6, 7.5, 14.0)):
        inner = arch_outline(ow, hs, ow)
        G["teal"].append(bay(f"Q_bay{cx}", inner, hw, top, hs, -1.5, 1.5, 'z', (cx, 0, 0)))
        G["gold"].append(tube_along(f"Q_gIn{cx}", [(cx + u * 1.04, y, -1.6) for u, y in inner], 0.22))
        G["gold"].append(tube_along(f"Q_gTop{cx}", [(cx - hw, top - 0.3, -1.6), (cx + hw, top - 0.3, -1.6)], 0.25))
        fld = extrude_outline(f"Q_fld{cx}", [(cx + u, y) for u, y in inner], 0.3, 0.0); fld.location = (0, 0, 0.6)
        (G["portal"] if cx == 0 else G["glass"]).append(fld)
    sw = [(0.21 * t * math.cos(t * 1.0), 10.5 + 0.21 * t * math.sin(t * 1.0) * 1.1, 0.35) for t in [k * 0.25 for k in range(1, 76)]]
    G["swirl"].append(tube_along("Q_swirl", sw, 0.18))
    G["pale"].append(lathe_at("Q_statueBase", [(0, 0), (1.6, 0), (1.6, 1.4), (1.2, 1.6), (0, 1.6)], (0, 0, -0.4), 12, False))
    G["pale"].append(lathe_at("Q_statue", [(0, 1.6), (0.9, 1.6), (0.7, 4.0), (1.0, 5.6), (0.55, 6.6), (0.25, 6.8), (0.55, 7.2), (0.5, 7.8), (0, 8.0)], (0, 0, -0.4), 12))
    for x in (-15.2, -6.4, 6.4, 15.2):
        H = 15.0 if abs(x) < 10 else 11.0
        G["pale"].append(lathe_at(f"Q_col{x}", [(0, 0), (1.2, 0), (1.2, 0.8), (0.85, 1.2), (0.8, H - 1.0), (1.2, H - 0.5), (1.3, H), (0, H)], (x, 0, -1.7), 12))
        G["pale"].append(lathe_at(f"Q_urn{x}", [(0, H), (0.9, H + 0.2), (1.1, H + 1.0), (0.5, H + 1.8), (0, H + 2.6)], (x, 0, -1.7), 10))
    crest = [(-4.0, 20.0), (-2.6, 21.8), (-1.2, 22.4), (0.0, 24.2), (1.2, 22.4), (2.6, 21.8), (4.0, 20.0)]
    G["gold"].append(tube_along("Q_crest", [(u, y, -1.2) for u, y in crest], 0.3))
    for s in (-1, 1):
        G["gold"].append(tube_along(f"Q_curl{s}", [(s * (2.0 + 1.2 * math.cos(a)), 21.0 + 1.2 * math.sin(a), -1.6) for a in [k * 0.4 for k in range(16)]], 0.15))
    return [merge_objs(f"K_Trip10_{k}", v).name for k, v in G.items() if v]

def build_scale10():
    clear_piece("K_Scale10_"); return rbox("K_Scale10_stone", 10.0, 10.0, 10.0, 0.01, 1)

def build_all10():
    build_scale10(); n = build_hero10(); n += build_trip10(); return n

R10_PREFIXES = ("K_Scale10_", "K_Hero_", "K_Trip10_")

def export_r10(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-10 pieces plus the 10-stud cube; Studio merges them into Kit."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R10_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 13: soft leaf-clump foliage kit
# Freestyle from close captures of the live reference trees (out/r13w/ref_*.jpg): a reference canopy is NOT faceted
# geometry. It is dozens of flat cards carrying an alpha texture of many small rounded leaves, radiating out of each
# clump and drooping, two tones per clump; the cypress is crossed vertical cards (an X shows from the side). So every
# leaf mesh here is a set of UV-mapped double-sided cards, and Studio puts an OWN painted leaf texture on them
# (tex/make_ae_tex13.py: leaf13_sprig on the drooping cards, leaf13_pad on the crossed filler cards) through a
# SurfaceAppearance (AlphaMode Transparency) whose Color tints it per colour family.
# Meshes per tree: K_<tag>_wood, K_<tag>_leaf (inner, darker tint), K_<tag>_leafRim (outer, lighter tint),
# K_<tag>_leafPad (crossed filler cards, darker tint). Normals on every leaf card point out of its clump centre, so a
# clump shades like one soft ball instead of a starburst of facets.

class Leaves13:
    """Collects cards for one mesh: verts, faces, per-loop UVs and per-loop custom normals."""
    def __init__(self): self.v = []; self.f = []; self.uv = []; self.n = []
    def quad(self, p, uv, nrm):
        """p: 4 points, uv: 4 uvs, nrm: 4 normals; adds the face and its reversed twin 0.02 behind (Roblox culls back faces)."""
        e1 = Vector(p[1]) - Vector(p[0]); e2 = Vector(p[3]) - Vector(p[0]); fn = e1.cross(e2)
        fn = fn.normalized() if fn.length > 1e-9 else Vector((0, 1, 0))
        i = len(self.v); self.v += [tuple(x) for x in p]; self.f.append((i, i + 1, i + 2, i + 3)); self.uv += list(uv); self.n += list(nrm)
        j = len(self.v); self.v += [tuple(Vector(x) - fn * 0.02) for x in p]
        self.f.append((j + 3, j + 2, j + 1, j)); self.uv += [uv[3], uv[2], uv[1], uv[0]]; self.n += [nrm[3], nrm[2], nrm[1], nrm[0]]
    def obj(self, name):
        me = bpy.data.meshes.new(name); me.from_pydata(self.v, [], self.f); me.update()
        uvl = me.uv_layers.new(name="UVMap")
        for k, l in enumerate(me.loops): uvl.data[k].uv = self.uv[k]
        for p in me.polygons: p.use_smooth = True
        try: me.normals_split_custom_set([tuple(x) for x in self.n])
        except Exception: pass
        o = bpy.data.objects.new(name, me); coll().objects.link(o); return o

def soft_normal(p, c, fn, k=0.75):
    """Clump normal: mostly the direction out of the clump centre c, a little of the face normal."""
    out = Vector(p) - Vector(c); out = out.normalized() if out.length > 1e-6 else Vector((0, 1, 0))
    if fn.dot(out) < 0: fn = -fn
    return tuple((out * k + fn * (1 - k)).normalized())

def lcard13(LV, b, d, L, W, droop=0.35, roll=0.0, segs=3, c=None):
    """Drooping leaf card: a strip from base b along d, the centre line sagging droop*L*t^2, width W, U across (0..1),
    V along (0 at the base, 1 at the tip). The sprig texture's stem runs up V."""
    b = Vector(b); d = Vector(d).normalized()
    ref = Vector((0, 1, 0)) if abs(d.y) < 0.92 else Vector((1, 0, 0))
    s = d.cross(ref).normalized()
    if roll: s = Matrix.Rotation(roll, 3, d) @ s
    down = Vector((0, -1, 0)); c = Vector(c) if c is not None else b
    C = [b + d * (L * t) + down * (droop * L * t * t) for t in [k / segs for k in range(segs + 1)]]
    fn = d.cross(s).normalized()
    for k in range(segs):
        t0, t1 = k / segs, (k + 1) / segs
        w0, w1 = W * 0.5, W * 0.5
        p = [C[k] - s * w0, C[k + 1] - s * w1, C[k + 1] + s * w1, C[k] + s * w0]
        LV.quad(p, [(0, t0), (0, t1), (1, t1), (1, t0)], [soft_normal(q, c, fn) for q in p])

def padcard13(LV, c, w, h, yaw, tilt=0.0, nc=None):
    """Upright filler card (pad texture) centred at c, w wide, h tall, turned yaw about Y, leaned tilt."""
    c = Vector(c); a = Vector((math.cos(yaw), 0, math.sin(yaw))); u = Matrix.Rotation(tilt, 3, a) @ Vector((0, 1, 0))
    p = [c - a * w / 2 - u * h / 2, c - a * w / 2 + u * h / 2, c + a * w / 2 + u * h / 2, c + a * w / 2 - u * h / 2]
    fn = a.cross(u).normalized(); nc = nc if nc is not None else c
    LV.quad(p, [(0, 0), (0, 1), (1, 1), (1, 0)], [soft_normal(q, nc, fn, 0.6) for q in p])

def fib_dirs(n, ymin=-0.55, rnd=0.25):
    out = []
    for i in range(n):
        y = 1 - (i + 0.5) / n * (1 - ymin); r = math.sqrt(max(0.0, 1 - y * y)); a = i * 2.39996 + random.uniform(-rnd, rnd)
        out.append(Vector((r * math.cos(a), y, r * math.sin(a))))
    return out

def clump13(IN, OUT, PAD, c, r, n=28, flat=1.0, droop=0.4, Lk=1.0, pads=3):
    """One soft clump of radius r. Its body is `pads` crossed filler cards (the round pad texture, 2r across, turned 180/pads
    apart and leaned +-0.4 rad, so from any side at least one shows its round leafy silhouette) plus one level card
    0.8r out for the view from above. Round it, n drooping sprig cards radiate over the whole sphere (inner 40% shorter
    -> IN, darker; outer -> OUT, lighter) and break the outline into fuzz. flat < 1 squashes it into a pad."""
    c = Vector(c)
    for k, d in enumerate(fib_dirs(n, ymin=-0.35)):
        d = Vector((d.x, d.y * flat, d.z)).normalized()
        inner = (k % 5) in (1, 3)
        L = r * random.uniform(0.75, 1.0) * Lk * (0.75 if inner else 1.0)
        base = c + d * r * (0.2 if inner else 0.4)
        lcard13(IN if inner else OUT, base, d + Vector((0, 0.1, 0)), L, L * 0.6, droop * random.uniform(0.7, 1.2), random.uniform(-0.6, 0.6), 3, c)
    for k in range(pads):
        padcard13(PAD, c, 2.0 * r, 2.0 * r * max(0.6, flat), math.pi * k / pads + random.uniform(-0.2, 0.2), (0.4 if k % 2 else -0.4), c)
    if pads:
        a = Vector((1, 0, 0)); bvec = Vector((0, 0, 1)); q = c + Vector((0, 0.15 * r, 0)); h = 0.8 * r
        p = [q - a * h - bvec * h, q - a * h + bvec * h, q + a * h + bvec * h, q + a * h - bvec * h]
        PAD.quad(p, [(0, 0), (0, 1), (1, 1), (1, 0)], [soft_normal(x, c - Vector((0, r, 0)), Vector((0, 1, 0)), 0.6) for x in p])

def wood13(tag, segs, r0):
    """segs: list of point-lists (trunk first, then branches at 0.45 of its radius). Merged into K_<tag>_wood."""
    objs = []
    for k, pts in enumerate(segs):
        rr = r0 if k == 0 else r0 * 0.45
        objs.append(tube_along(f"Q_w{k}", [tuple(p) for p in pts], rr, res=4))
    objs.append(lathe_at("Q_flare", [(0, 0), (r0 * 2.3, 0), (r0 * 1.3, r0 * 1.0), (r0 * 1.0, r0 * 2.4), (0, r0 * 2.6)], (0, -0.3, 0), 8, False))
    return merge_objs(f"K_{tag}_wood", objs)

def finish13(tag, IN, OUT, PAD):
    IN.obj(f"K_{tag}_leaf"); OUT.obj(f"K_{tag}_leafRim")
    if PAD.f: PAD.obj(f"K_{tag}_leafPad")

def branch_to(C0, c, bend=0.25):
    m = C0.lerp(c, 0.5) + Vector((0, bend * (c - C0).length, 0))
    return [C0, m, c.lerp(m, 0.15)]

def build_round13(tag="Soft13R", seed=131, H=15.0, R=8.0, nclus=7, ncard=26, cr=3.6, trunk_r=0.8):
    """Round broadleaf: a leaning trunk forking into branches, nclus clumps on a dome (one on top)."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves13(), Leaves13(), Leaves13()
    top = Vector((random.uniform(-0.8, 0.8), H * 0.62, random.uniform(-0.8, 0.8)))
    trunk = [Vector((0, -0.3, 0)), Vector((0.3, H * 0.3, 0.1)), top]
    cents = [top + Vector((0, R * 0.55, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.25, 0.25)
        cents.append(top + Vector((R * 0.6 * math.cos(a), R * random.uniform(0.0, 0.35), R * 0.6 * math.sin(a))))
    segs = [trunk] + [branch_to(top, c) for c in cents[1:]]
    for c in cents: clump13(IN, OUT, PAD, c, cr * random.uniform(0.9, 1.1), ncard)
    wood13(tag, segs, trunk_r); finish13(tag, IN, OUT, PAD)

def build_cloud13(tag="Soft13C", seed=132, H=17.0, npad=5, ncard=22, cr=3.8, trunk_r=0.7):
    """Cloud / bonsai tree (the reference's blue arch tree): a twisting trunk, thin bare branches, and npad flattened
    horizontal pads at different heights, each a squashed clump of drooping cards."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves13(), Leaves13(), Leaves13()
    trunk = [Vector((0, -0.3, 0)), Vector((1.2, H * 0.25, 0.4)), Vector((-0.6, H * 0.55, -0.4)), Vector((0.5, H * 0.85, 0.3))]
    segs = [trunk]; cents = [Vector((0.5, H + 0.5, 0.3))]
    for i in range(npad - 1):
        t = 0.35 + 0.5 * i / (npad - 1); a = i * 2.2 + random.uniform(-0.3, 0.3)
        b0 = Vector((0, H * t, 0)); c = Vector((4.5 * math.cos(a), H * t + 1.5, 4.5 * math.sin(a)))
        segs.append([b0, b0.lerp(c, 0.5) + Vector((0, 1.0, 0)), c]); cents.append(c)
    segs.append([trunk[-1], cents[0]])
    for c in cents: clump13(IN, OUT, PAD, c, cr * random.uniform(0.85, 1.1), ncard, flat=0.5, droop=0.5)
    wood13(tag, segs, trunk_r); finish13(tag, IN, OUT, PAD)

def build_umb13(tag="Soft13U", seed=133, H=20.0, R=13.0, nclus=8, ncard=24, cr=4.4, trunk_r=1.2):
    """Umbrella / acacia (the gold mass behind Summon): a thick trunk splitting into limbs that carry a wide, flat-
    topped canopy of nclus slightly squashed clumps."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves13(), Leaves13(), Leaves13()
    fork = Vector((0, H * 0.45, 0)); segs = [[Vector((0, -0.3, 0)), Vector((0.4, H * 0.2, 0)), fork]]
    cents = [Vector((0, H, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.2, 0.2); rr = R * random.uniform(0.55, 0.8)
        cents.append(Vector((rr * math.cos(a), H - 1.2 + random.uniform(-0.8, 0.8), rr * math.sin(a))))
    for k, c in enumerate(cents[1:]):
        if k % 2 == 0: segs.append(branch_to(fork, c, 0.15))
    segs.append([fork, cents[0]])
    for c in cents: clump13(IN, OUT, PAD, c, cr * random.uniform(0.9, 1.1), ncard, flat=0.7, droop=0.45)
    wood13(tag, segs, trunk_r); finish13(tag, IN, OUT, PAD)

def build_wis13(tag="Soft13W", seed=134, H=13.0, R=7.0, nclus=6, ncard=18, cr=3.2, nhang=26, trunk_r=0.7):
    """Wisteria: a low spreading tree of clumps with nhang hanging strands (long sprig cards pointing nearly straight
    down from the clump undersides: they read as racemes)."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves13(), Leaves13(), Leaves13()
    top = Vector((0.5, H * 0.65, 0)); segs = [[Vector((0, -0.3, 0)), Vector((-0.6, H * 0.35, 0.3)), top]]
    cents = [top + Vector((0, R * 0.4, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.3, 0.3)
        cents.append(top + Vector((R * 0.7 * math.cos(a), R * random.uniform(0.05, 0.3), R * 0.7 * math.sin(a))))
    segs += [branch_to(top, c) for c in cents[1:]]
    for c in cents: clump13(IN, OUT, PAD, c, cr, ncard, flat=0.8)
    for h in range(nhang):
        c = random.choice(cents); a = random.uniform(0, 2 * math.pi); rr = cr * random.uniform(0.3, 0.9)
        b = c + Vector((rr * math.cos(a), -cr * 0.35, rr * math.sin(a)))
        d = Vector((0.15 * math.cos(a), -1, 0.15 * math.sin(a))); L = random.uniform(3.0, 5.5)
        lcard13(OUT, b, d, L, 1.5, 0.0, random.uniform(0, math.pi), 3, c - Vector((0, cr, 0)))
    wood13(tag, segs, trunk_r); finish13(tag, IN, OUT, PAD)

def build_cyp13(tag="Soft13Y", seed=135, H=16.0, Rb=2.6, ncard=40):
    """Cypress column: three crossed upright pad cards per tier in 3 overlapping tiers (the fuzzy X the reference
    shows), plus ncard short sprig cards pointing up and out round a tapering column."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves13(), Leaves13(), Leaves13()
    segs = [[Vector((0, -0.3, 0)), Vector((0, 2.5, 0))]]
    for t, (y0, y1, w) in enumerate(((1.2, 8.5, 2.1), (5.0, 12.5, 1.8), (9.0, H, 1.3))):
        for k in range(3):
            padcard13(PAD, (0, (y0 + y1) / 2, 0), w * Rb, y1 - y0, math.pi * k / 3 + t * 0.5, 0, Vector((0, (y0 + y1) / 2, 0)))
    for i in range(ncard):
        t = (i + 0.5) / ncard; y = 1.8 + t * (H - 3.0); r = Rb * (1 - t) ** 0.8 * 0.6 + 0.2
        a = i * 2.39996; d = Vector((math.cos(a) * 0.6, 1.0, math.sin(a) * 0.6))
        L = 2.6 * (1 - 0.45 * t)
        lcard13(OUT if i % 3 else IN, (r * 0.5 * math.cos(a), y, r * 0.5 * math.sin(a)), d, L, L * 0.6, -0.05, 0, 2, Vector((0, y, 0)))
    wood13(tag, segs, 0.45); finish13(tag, IN, OUT, PAD)

def build_palm13(tag="Soft13P", seed=136, H=20.0, nf=9, FL=9.5, bend=3.0):
    """Feather palm: ringed curved trunk; each frond is two long sprig cards in a shallow V (the sprig texture IS a
    pinnate frond), arched up then drooping."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves13(), Leaves13(), Leaves13(); wood = []
    tp = lambda t: Vector((bend * t * t, H * t, 0.3 * bend * t * t))
    wood.append(tube_along("Q_trunk", [tuple(tp(i / 6)) for i in range(7)], 0.65, res=4))
    for i in range(1, 11):
        wood.append(lathe_at(f"Q_ring{i}", [(0, -0.25), (0.85, -0.1), (0.85, 0.1), (0, 0.25)], tuple(tp(i / 11)), 6, False))
    top = tp(1.0); wood.append(lathe_at("Q_boss", [(0, -1.0), (1.0, -0.5), (1.1, 0.3), (0.4, 0.8), (0, 0.9)], tuple(top), 8, False))
    for i in range(nf):
        a = 2 * math.pi * i / nf + random.uniform(-0.2, 0.2); hz = Vector((math.cos(a), 0, math.sin(a)))
        fl = FL * random.uniform(0.85, 1.1); d = (hz + Vector((0, random.uniform(0.5, 0.9), 0))).normalized()
        for sg in (-1, 1):
            lcard13(OUT if i % 2 else IN, top, d, fl, 3.8, 0.85, sg * 0.6, 5, top - Vector((0, 2.0, 0)))
    merge_objs(f"K_{tag}_wood", wood); finish13(tag, IN, OUT, PAD)

def build_bush13(tag="Soft13B", seed=137, r=2.6, ncard=22):
    """Low bush / planting clump: one squashed clump sitting on the ground (no trunk)."""
    random.seed(seed); clear_piece(f"K_{tag}_")
    IN, OUT, PAD = Leaves13(), Leaves13(), Leaves13()
    clump13(IN, OUT, PAD, (0, r * 0.55, 0), r, ncard, flat=0.75, droop=0.5)
    finish13(tag, IN, OUT, PAD)

def build_clump13(tag="Soft13K", seed=138, r=4.0, ncard=30):
    """Loose clump (no trunk), 2r across: the unit for big canopies (Story tree, gold/purple masses, island tops)."""
    random.seed(seed); clear_piece(f"K_{tag}_")
    IN, OUT, PAD = Leaves13(), Leaves13(), Leaves13()
    clump13(IN, OUT, PAD, (0, 0, 0), r, ncard, droop=0.45, pads=3)
    finish13(tag, IN, OUT, PAD)

def build_scale13():
    clear_piece("K_Scale13_"); return rbox("K_Scale13_stone", 10.0, 10.0, 10.0, 0.01, 1)

R13_PREFIXES = ("K_Scale13_", "K_Soft13")

def tri_count(prefix):
    return sum(sum(len(p.vertices) - 2 for p in o.data.polygons) for o in bpy.data.objects if o.name.startswith(prefix) and o.type == 'MESH')

def build_all13():
    build_scale13(); build_round13(); build_cloud13(); build_umb13(); build_wis13(); build_cyp13(); build_palm13()
    build_bush13(); build_clump13()
    return {t: tri_count(f"K_{t}_") for t in ("Soft13R", "Soft13C", "Soft13U", "Soft13W", "Soft13Y", "Soft13P", "Soft13B", "Soft13K")}

def export_r13(path):
    """Z-up (+cube UVs on the wood and the cube only: leaf cards carry their own UVs), then export ONLY the pass-13 pieces
    plus the 10-stud cube; Studio merges them into Kit. Normals are exported (custom clump normals on the leaves)."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R13_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='OFF', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 14: finer leaf cards (verify11 item 1)
# Round 11: the pass-13 cards read 3-5 studs with one big leaf each, so a clump broke into a few flat planes ("crumpled
# paper"). Pass 14 keeps the method (cut-out leaf cards on clump normals) and makes it fine-grained:
#  - cards are an ABSOLUTE 1.4-1.9 studs long in the kit (kit trees are authored near their placed height, so the Studio
#    scale is 1.0-1.6 and a placed card is 1.5-2.5 studs), 40-80 per clump instead of 18-30;
#  - each card carries the own leaf14_spray texture (35 leaves of 0.3-0.5 studs on a twig spray), each filler card the
#    leaf14_pad heap (2600 leaves), colour gradient baked in (tex/make_ae_tex14.py);
#  - 2 segments per card (8 tris with the back twin), so a 7-clump tree stays under ~4k triangles;
#  - clump normals are biased upward (+0.35 Y) so the undersides do not sink into olive/navy shade.
class Leaves14(Leaves13):
    """Pass-14 card collector. The pass-13 class gave a card's back twin the SAME shading normals as its front, so seen from
    behind (or from below a canopy) the normal pointed away from the camera and Roblox drew the face as a pale white sheen
    (Fresnel/sky reflection) - the "white glints" of round 11 and the white planes of the first r14 test. Here each side's
    shading normal is kept in that side's own hemisphere: n.gn >= 0.35 (gn = the side's geometric normal); the clump
    direction survives in the tangent part, so the canopy still shades as one soft ball."""
    @staticmethod
    def side_n(n, gn, m=0.35):
        n = Vector(n); d = n.dot(gn)
        if d < m: n = n + gn * (m - d)
        return tuple(n.normalized())
    def quad(self, p, uv, nrm):
        e1 = Vector(p[1]) - Vector(p[0]); e2 = Vector(p[3]) - Vector(p[0]); fn = e1.cross(e2)
        fn = fn.normalized() if fn.length > 1e-9 else Vector((0, 1, 0))
        i = len(self.v); self.v += [tuple(x) for x in p]; self.f.append((i, i + 1, i + 2, i + 3)); self.uv += list(uv)
        self.n += [self.side_n(x, fn) for x in nrm]
        j = len(self.v); self.v += [tuple(Vector(x) - fn * 0.02) for x in p]
        self.f.append((j + 3, j + 2, j + 1, j)); self.uv += [uv[3], uv[2], uv[1], uv[0]]
        self.n += [self.side_n(x, -fn) for x in (nrm[3], nrm[2], nrm[1], nrm[0])]

def soft_normal14(p, c, fn, k=0.85, up=0.15):
    out = Vector(p) - Vector(c); out = out.normalized() if out.length > 1e-6 else Vector((0, 1, 0))
    if fn.dot(out) < 0: fn = -fn
    return tuple((out * k + fn * (1 - k) + Vector((0, up, 0))).normalized())

def lcard14(LV, b, d, L, W, droop=0.35, roll=0.0, segs=2, c=None, side=None):
    b = Vector(b); d = Vector(d).normalized()
    ref = Vector((0, 1, 0)) if abs(d.y) < 0.92 else Vector((1, 0, 0))
    s = Vector(side).normalized() if side is not None else d.cross(ref).normalized()
    if roll: s = Matrix.Rotation(roll, 3, d) @ s
    down = Vector((0, -1, 0)); c = Vector(c) if c is not None else b
    C = [b + d * (L * t) + down * (droop * L * t * t) for t in [k / segs for k in range(segs + 1)]]
    fn = d.cross(s).normalized()
    for k in range(segs):
        t0, t1 = k / segs, (k + 1) / segs
        p = [C[k] - s * W * 0.5, C[k + 1] - s * W * 0.5, C[k + 1] + s * W * 0.5, C[k] + s * W * 0.5]
        LV.quad(p, [(0, t0), (0, t1), (1, t1), (1, t0)], [soft_normal14(q, c, fn) for q in p])

def padcard14(LV, c, w, h, yaw, tilt=0.0, nc=None):
    c = Vector(c); a = Vector((math.cos(yaw), 0, math.sin(yaw))); u = Matrix.Rotation(tilt, 3, a) @ Vector((0, 1, 0))
    p = [c - a * w / 2 - u * h / 2, c - a * w / 2 + u * h / 2, c + a * w / 2 + u * h / 2, c + a * w / 2 - u * h / 2]
    fn = a.cross(u).normalized(); nc = nc if nc is not None else c
    LV.quad(p, [(0, 0), (0, 1), (1, 1), (1, 0)], [soft_normal14(q, nc, fn, 0.7) for q in p])

def clump14(IN, OUT, PAD, c, r, n=52, flat=1.0, droop=0.4, pads=3, Lc=(1.4, 1.9)):
    """Fine clump of radius r: `pads` crossed filler cards (2r across, pad heap texture) + a level card for the top, and n
    small spray cards (Lc studs) over a Fibonacci sphere:
      - 60% SHINGLES: lying in the shell (card normal = out of the clump), pointing down-and-around with a slight lift, so
        the cards facing the viewer show their leaves and cover the crossed pad cards (radial cards are seen end-on there
        and left the pads' X showing in the first pass-14 render);
      - 40% RADIAL: pointing out of the shell and drooping, for the fuzzy outline; half of them inner/shade (IN).
    Shingles use 1 segment (4 tris with the back twin), radial cards 2."""
    c = Vector(c); up = Vector((0, 1, 0))
    for k, d in enumerate(fib_dirs(n, ymin=-0.45, rnd=0.35)):
        d = Vector((d.x, d.y * flat, d.z)).normalized()
        L = random.uniform(*Lc)
        if k % 5 in (0, 2, 4):  # shingle
            tdown = (d.cross(up).cross(d)) if abs(d.y) < 0.97 else Vector((1, 0, 0))
            tdown = (-tdown).normalized() if tdown.length > 1e-6 else Vector((1, 0, 0))
            side_t = d.cross(tdown).normalized()
            dirv = (tdown * 0.75 + side_t * random.uniform(-0.6, 0.6) + d * 0.3).normalized()
            base = c + d * r * random.uniform(0.82, 0.98) - dirv * L * 0.4
            lcard14(OUT if k % 3 else IN, base, dirv, L, L * 0.6, 0.0, random.uniform(-0.25, 0.25), 1, c, side=d.cross(dirv))
        else:  # radial fringe
            inner = (k % 5) == 1
            L = L * (0.85 if inner else 1.0)
            base = c + d * r * (random.uniform(0.45, 0.65) if inner else random.uniform(0.75, 0.95)) - d * L * 0.3
            lcard14(IN if inner else OUT, base, d + Vector((0, 0.15, 0)), L, L * 0.55, droop * random.uniform(0.6, 1.2),
                    random.uniform(-0.8, 0.8), 2, c)
    for k in range(pads):
        padcard14(PAD, c, 2.0 * r, 2.0 * r * max(0.6, flat), math.pi * k / pads + random.uniform(-0.2, 0.2), (0.4 if k % 2 else -0.4), c)
    if pads:
        a = Vector((1, 0, 0)); bvec = Vector((0, 0, 1)); q = c + Vector((0, 0.2 * r * flat, 0)); h = 0.85 * r
        p = [q - a * h - bvec * h, q - a * h + bvec * h, q + a * h + bvec * h, q + a * h - bvec * h]
        PAD.quad(p, [(0, 0), (0, 1), (1, 1), (1, 0)], [soft_normal14(x, c - Vector((0, r, 0)), Vector((0, 1, 0)), 0.6) for x in p])

def ncards(r, k=3.2):
    """Card count from the clump surface: about k cards per 10 stud^2 of shell, clamped to 40-80."""
    return int(max(40, min(80, k * 4 * math.pi * r * r / 10)))

def build_round14(tag="Soft14R", seed=141, H=20.0, R=10.0, nclus=7, cr=4.4, trunk_r=1.0):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves14(), Leaves14(), Leaves14()
    top = Vector((random.uniform(-0.8, 0.8), H * 0.6, random.uniform(-0.8, 0.8)))
    trunk = [Vector((0, -0.3, 0)), Vector((0.4, H * 0.3, 0.1)), top]
    cents = [top + Vector((0, R * 0.5, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.25, 0.25)
        cents.append(top + Vector((R * 0.55 * math.cos(a), R * random.uniform(0.0, 0.3), R * 0.55 * math.sin(a))))
    segs = [trunk] + [branch_to(top, c) for c in cents[1:]]
    for c in cents: clump14(IN, OUT, PAD, c, cr * random.uniform(0.9, 1.1), ncards(cr, 3.0))
    wood13(tag, segs, trunk_r); finish13(tag, IN, OUT, PAD)

def build_cloud14(tag="Soft14C", seed=142, H=26.0, npad=5, cr=4.8, trunk_r=1.0):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves14(), Leaves14(), Leaves14()
    trunk = [Vector((0, -0.3, 0)), Vector((1.8, H * 0.25, 0.6)), Vector((-0.9, H * 0.55, -0.6)), Vector((0.7, H * 0.85, 0.4))]
    segs = [trunk]; cents = [Vector((0.7, H + 0.3, 0.4))]
    for i in range(npad - 1):
        t = 0.38 + 0.47 * i / (npad - 1); a = i * 2.2 + random.uniform(-0.3, 0.3)
        b0 = Vector((0, H * t, 0)); c = Vector((6.5 * math.cos(a), H * t + 2.0, 6.5 * math.sin(a)))
        segs.append([b0, b0.lerp(c, 0.5) + Vector((0, 1.4, 0)), c]); cents.append(c)
    segs.append([trunk[-1], cents[0]])
    for c in cents: clump14(IN, OUT, PAD, c, cr * random.uniform(0.9, 1.1), ncards(cr, 3.4), flat=0.55, droop=0.5)
    wood13(tag, segs, trunk_r); finish13(tag, IN, OUT, PAD)

def build_umb14(tag="Soft14U", seed=143, H=28.0, R=17.0, nclus=8, cr=5.2, trunk_r=1.6):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves14(), Leaves14(), Leaves14()
    fork = Vector((0, H * 0.45, 0)); segs = [[Vector((0, -0.3, 0)), Vector((0.5, H * 0.2, 0)), fork]]
    cents = [Vector((0, H, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.2, 0.2); rr = R * random.uniform(0.5, 0.72)
        cents.append(Vector((rr * math.cos(a), H - 1.6 + random.uniform(-1.0, 1.0), rr * math.sin(a))))
    for k, c in enumerate(cents[1:]):
        if k % 2 == 0: segs.append(branch_to(fork, c, 0.15))
    segs.append([fork, cents[0]])
    for c in cents: clump14(IN, OUT, PAD, c, cr * random.uniform(0.9, 1.1), ncards(cr, 2.0), flat=0.7, droop=0.45)
    wood13(tag, segs, trunk_r); finish13(tag, IN, OUT, PAD)

def build_wis14(tag="Soft14W", seed=144, H=20.0, R=10.0, nclus=6, cr=4.4, nhang=30, trunk_r=1.0):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves14(), Leaves14(), Leaves14()
    top = Vector((0.6, H * 0.62, 0)); segs = [[Vector((0, -0.3, 0)), Vector((-0.8, H * 0.35, 0.4)), top]]
    cents = [top + Vector((0, R * 0.4, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.3, 0.3)
        cents.append(top + Vector((R * 0.65 * math.cos(a), R * random.uniform(0.05, 0.3), R * 0.65 * math.sin(a))))
    segs += [branch_to(top, c) for c in cents[1:]]
    for c in cents: clump14(IN, OUT, PAD, c, cr, ncards(cr, 3.0), flat=0.8)
    for h in range(nhang):  # hanging racemes: long narrow spray cards pointing down (they worked in round 11)
        c = random.choice(cents); a = random.uniform(0, 2 * math.pi); rr = cr * random.uniform(0.3, 0.9)
        b = c + Vector((rr * math.cos(a), -cr * 0.35, rr * math.sin(a)))
        d = Vector((0.12 * math.cos(a), -1, 0.12 * math.sin(a))); L = random.uniform(3.5, 6.5)
        lcard14(OUT, b, d, L, 1.4, 0.0, random.uniform(0, math.pi), 3, c - Vector((0, cr, 0)))
    wood13(tag, segs, trunk_r); finish13(tag, IN, OUT, PAD)

def build_cyp14(tag="Soft14Y", seed=145, H=17.0, Rb=2.6, ncard=90):
    """Cypress: 3 tiers of 3 crossed pad cards + ncard small spray cards pointing up and out (the reference cypress is a
    dense fine-speckle column)."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT, PAD = Leaves14(), Leaves14(), Leaves14()
    segs = [[Vector((0, -0.3, 0)), Vector((0, 2.5, 0))]]
    for t, (y0, y1, w) in enumerate(((1.2, 9.0, 2.1), (5.5, 13.5, 1.8), (9.5, H, 1.3))):
        for k in range(3):
            padcard14(PAD, (0, (y0 + y1) / 2, 0), w * Rb, y1 - y0, math.pi * k / 3 + t * 0.5, 0, Vector((0, (y0 + y1) / 2, 0)))
    for i in range(ncard):
        t = (i + 0.5) / ncard; y = 1.6 + t * (H - 2.8); r = Rb * (1 - t) ** 0.8 * 0.9 + 0.3
        a = i * 2.39996; d = Vector((math.cos(a) * 0.7, 1.0, math.sin(a) * 0.7))
        L = 1.7 * (1 - 0.35 * t)
        lcard14(OUT if i % 3 else IN, (r * 0.55 * math.cos(a), y, r * 0.55 * math.sin(a)), d, L, L * 0.55, -0.05, random.uniform(-0.6, 0.6), 2, Vector((0, y, 0)))
    wood13(tag, segs, 0.45); finish13(tag, IN, OUT, PAD)

def build_clump14(tag="Soft14K", seed=148, r=4.0):
    random.seed(seed); clear_piece(f"K_{tag}_")
    IN, OUT, PAD = Leaves14(), Leaves14(), Leaves14()
    clump14(IN, OUT, PAD, (0, 0, 0), r, 64, droop=0.45, pads=3)
    finish13(tag, IN, OUT, PAD)

def build_bush14(tag="Soft14B", seed=147, r=2.6):
    random.seed(seed); clear_piece(f"K_{tag}_")
    IN, OUT, PAD = Leaves14(), Leaves14(), Leaves14()
    clump14(IN, OUT, PAD, (0, r * 0.55, 0), r, 44, flat=0.75, droop=0.5, Lc=(1.2, 1.6))
    finish13(tag, IN, OUT, PAD)

def build_scale14():
    clear_piece("K_Scale14_"); return rbox("K_Scale14_stone", 10.0, 10.0, 10.0, 0.01, 1)

R14_PREFIXES = ("K_Scale14_", "K_Soft14")
SOFT14 = ("Soft14R", "Soft14C", "Soft14U", "Soft14W", "Soft14Y", "Soft14K", "Soft14B")

def build_all14():
    """The palm (Soft13P) is kept from pass 13: its fronds are long sprig cards that read as fronds, not as leaf clumps."""
    build_scale14(); build_round14(); build_cloud14(); build_umb14(); build_wis14(); build_cyp14(); build_clump14(); build_bush14()
    return {t: tri_count(f"K_{t}_") for t in SOFT14}

def export_r14(path):
    """Z-up, then export ONLY the pass-14 pieces plus the 10-stud cube (merged into Kit in Studio)."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R14_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='OFF', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 15: clumps without interior facets (verify12 item 1)
# Round 12: inside each clump's outline the crossed filler cards (2r across, pad heap texture) and the level card still
# read as large flat triangular facets (3-5 studs, a crease down the middle): "faceted balls / cabbage heads". New close
# captures of the live reference (out/r15w/ref15_tree_close.png) show a reference clump is a loose burst of many small
# flat leaf sprays at every orientation, see-through at the edges, with NO shell or core plane at all.
# Pass 15 therefore:
#  - drops every filler / level card (no K_*_leafPad mesh at all) and every card over 2.5 studs;
#  - fills each clump with 120-200 spray cards of 1.3-2.2 studs (0.65-0.85 as wide), each at a random orientation (a random unit normal,
#    a random roll), so neighbours never share a plane; positions fill the volume biased toward the shell
#    (radius r * (0.35 + 0.65 * u^0.35)); inner cards (< 0.62 r) go to the darker IN mesh, so the core reads dark;
#  - outer cards get 35% of the radial direction blended into their random normal (never edge-on at the rim, lesson 4
#    of pass 14), inner cards are fully random;
#  - normals: out of the clump centre (spherical transfer, k 0.9), kept per side in the side's own hemisphere (Leaves14,
#    pass-14 lesson 1) with a lower floor (0.25), so the shading falls smoothly from the lit top to the dark core;
#  - 1 segment per card (4 tris with its back twin): each tree stays under ~5k triangles.
# Gold: build_gold15 is ONE continuous cloud canopy about 30 x 20 (11 overlapping clumps on an uneven ellipsoid) on a
# gnarled trunk splitting into limbs, for the mass behind Summon.

class Leaves15(Leaves14):
    @staticmethod
    def side_n(n, gn, m=0.25):
        n = Vector(n); d = n.dot(gn)
        if d < m: n = n + gn * (m - d)
        return tuple(n.normalized())

def rand_unit():
    while True:
        v = Vector((random.uniform(-1, 1), random.uniform(-1, 1), random.uniform(-1, 1)))
        if 0.05 < v.length <= 1: return v.normalized()

def card15(LV, p, nrm, L, W, c):
    """Flat spray card centred at p with face normal nrm (any orientation), random roll, L long, W wide; V runs along
    the card (the spray texture's stem), U across. Normals out of the clump centre c."""
    nrm = Vector(nrm).normalized(); p = Vector(p)
    ref = Vector((0, 1, 0)) if abs(nrm.y) < 0.9 else Vector((1, 0, 0))
    a = nrm.cross(ref).normalized(); a = Matrix.Rotation(random.uniform(0, 2 * math.pi), 3, nrm) @ a
    s = nrm.cross(a).normalized()
    b = p - a * L * 0.5
    q = [b - s * W * 0.5, b + a * L - s * W * 0.5, b + a * L + s * W * 0.5, b + s * W * 0.5]
    fn = (q[1] - q[0]).cross(q[3] - q[0]).normalized()
    LV.quad(q, [(0, 0), (0, 1), (1, 1), (1, 0)], [soft_normal14(x, c, fn, 0.9, 0.12) for x in q])

def clump15(IN, OUT, c, r, n=150, flat=1.0, Lc=(1.3, 2.2), core=0.62):
    """Clump of radius r: n small cards at random orientations through the volume (no filler shell). flat squashes Y."""
    c = Vector(c)
    for k in range(n):
        d = rand_unit(); d = Vector((d.x, d.y * flat, d.z))
        t = 0.35 + 0.65 * random.random() ** 0.35
        p = c + d * r * t
        L = random.uniform(*Lc); W = L * random.uniform(0.65, 0.85)
        nr = rand_unit()
        if t > core:
            out = d.normalized()
            if nr.dot(out) < 0: nr = -nr
            nr = (nr * 0.65 + out * 0.35).normalized()
        card15(IN if t < core else OUT, p, nr, L, W, c)

def finish15(tag, IN, OUT):
    IN.obj(f"K_{tag}_leaf"); OUT.obj(f"K_{tag}_leafRim")

def build_round15(tag="Soft15R", seed=151, H=20.0, R=10.0, nclus=7, cr=4.4, trunk_r=1.0, n=158):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT = Leaves15(), Leaves15()
    top = Vector((random.uniform(-0.8, 0.8), H * 0.6, random.uniform(-0.8, 0.8)))
    trunk = [Vector((0, -0.3, 0)), Vector((0.4, H * 0.3, 0.1)), top]
    cents = [top + Vector((0, R * 0.5, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.25, 0.25)
        cents.append(top + Vector((R * 0.55 * math.cos(a), R * random.uniform(0.0, 0.3), R * 0.55 * math.sin(a))))
    segs = [trunk] + [branch_to(top, c) for c in cents[1:]]
    for c in cents: clump15(IN, OUT, c, cr * random.uniform(0.9, 1.1), n)
    wood13(tag, segs, trunk_r); finish15(tag, IN, OUT)

def build_cloud15(tag="Soft15C", seed=152, H=26.0, npad=5, cr=4.8, trunk_r=1.0, n=190):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT = Leaves15(), Leaves15()
    trunk = [Vector((0, -0.3, 0)), Vector((1.8, H * 0.25, 0.6)), Vector((-0.9, H * 0.55, -0.6)), Vector((0.7, H * 0.85, 0.4))]
    segs = [trunk]; cents = [Vector((0.7, H + 0.3, 0.4))]
    for i in range(npad - 1):
        t = 0.38 + 0.47 * i / (npad - 1); a = i * 2.2 + random.uniform(-0.3, 0.3)
        b0 = Vector((0, H * t, 0)); c = Vector((6.5 * math.cos(a), H * t + 2.0, 6.5 * math.sin(a)))
        segs.append([b0, b0.lerp(c, 0.5) + Vector((0, 1.4, 0)), c]); cents.append(c)
    segs.append([trunk[-1], cents[0]])
    for c in cents: clump15(IN, OUT, c, cr * random.uniform(0.9, 1.1), n, flat=0.6)
    wood13(tag, segs, trunk_r); finish15(tag, IN, OUT)

def build_umb15(tag="Soft15U", seed=153, H=28.0, R=17.0, nclus=8, cr=5.2, trunk_r=1.6, n=145):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT = Leaves15(), Leaves15()
    fork = Vector((0, H * 0.45, 0)); segs = [[Vector((0, -0.3, 0)), Vector((0.5, H * 0.2, 0)), fork]]
    cents = [Vector((0, H, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.2, 0.2); rr = R * random.uniform(0.45, 0.62)
        cents.append(Vector((rr * math.cos(a), H - 1.6 + random.uniform(-1.0, 1.0), rr * math.sin(a))))
    for k, c in enumerate(cents[1:]):
        if k % 2 == 0: segs.append(branch_to(fork, c, 0.15))
    segs.append([fork, cents[0]])
    for c in cents: clump15(IN, OUT, c, cr * random.uniform(0.9, 1.1), n, flat=0.75)
    wood13(tag, segs, trunk_r); finish15(tag, IN, OUT)

def build_wis15(tag="Soft15W", seed=154, H=20.0, R=10.0, nclus=6, cr=4.4, nhang=30, trunk_r=1.0, n=150):
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT = Leaves15(), Leaves15()
    top = Vector((0.6, H * 0.62, 0)); segs = [[Vector((0, -0.3, 0)), Vector((-0.8, H * 0.35, 0.4)), top]]
    cents = [top + Vector((0, R * 0.4, 0))]
    for i in range(nclus - 1):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.3, 0.3)
        cents.append(top + Vector((R * 0.65 * math.cos(a), R * random.uniform(0.05, 0.3), R * 0.65 * math.sin(a))))
    segs += [branch_to(top, c) for c in cents[1:]]
    for c in cents: clump15(IN, OUT, c, cr, n, flat=0.85)
    for h in range(nhang):  # hanging racemes: chains of 2-3 small cards (no card over 2.5 studs)
        c = random.choice(cents); a = random.uniform(0, 2 * math.pi); rr = cr * random.uniform(0.3, 0.9)
        b = c + Vector((rr * math.cos(a), -cr * 0.4, rr * math.sin(a)))
        for j in range(random.randint(2, 3)):
            lcard14(OUT, b - Vector((0, 1.8 * j, 0)), Vector((0.12 * math.cos(a), -1, 0.12 * math.sin(a))), 2.0, 1.2, 0.0,
                    random.uniform(0, math.pi), 1, c - Vector((0, cr, 0)))
    wood13(tag, segs, trunk_r); finish15(tag, IN, OUT)

def build_cyp15(tag="Soft15Y", seed=155, H=17.0, Rb=2.6, n=260):
    """Cypress column with no crossed pad cards: n small cards at random orientations through a tapering column."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT = Leaves15(), Leaves15()
    segs = [[Vector((0, -0.3, 0)), Vector((0, 2.5, 0))]]
    for i in range(n):
        y = 1.4 + random.random() ** 0.9 * (H - 2.4); t = (y - 1.4) / (H - 2.4)
        rmax = Rb * (1 - t) ** 0.7 * 0.95 + 0.35
        a = random.uniform(0, 2 * math.pi); u = 0.25 + 0.75 * random.random() ** 0.5
        p = Vector((math.cos(a) * rmax * u, y, math.sin(a) * rmax * u)); cc = Vector((0, y, 0))
        out = Vector((math.cos(a), 0.25, math.sin(a))).normalized(); nr = rand_unit()
        if nr.dot(out) < 0: nr = -nr
        nr = (nr * 0.65 + out * 0.35).normalized()
        L = random.uniform(1.0, 1.7) * (1 - 0.3 * t)
        card15(IN if u < 0.6 else OUT, p, nr, L, L * 0.6, cc)
    wood13(tag, segs, 0.45); finish15(tag, IN, OUT)

def build_clump15(tag="Soft15K", seed=158, r=4.0, n=200):
    random.seed(seed); clear_piece(f"K_{tag}_")
    IN, OUT = Leaves15(), Leaves15()
    clump15(IN, OUT, (0, 0, 0), r, n)
    finish15(tag, IN, OUT)

def build_bush15(tag="Soft15B", seed=157, r=2.6, n=120):
    random.seed(seed); clear_piece(f"K_{tag}_")
    IN, OUT = Leaves15(), Leaves15()
    clump15(IN, OUT, (0, r * 0.55, 0), r, n, flat=0.75, Lc=(1.0, 1.6))
    finish15(tag, IN, OUT)

def build_gold15(tag="Soft15G", seed=159, W=30.0, Hc=20.0, base=13.0, nclus=11, n=106, trunk_r=1.5):
    """Gold cloud canopy (behind Summon): ONE continuous uneven mass ~W wide x Hc tall whose underside sits near `base`,
    made of nclus overlapping clumps (r 5-6.5) on an irregular ellipsoid, on a gnarled trunk splitting into limbs at
    about 0.62 of the base height. Clumps overlap ~40%, so no single ball outline survives."""
    random.seed(seed); clear_piece(f"K_{tag}_"); clear_piece("Q_")
    IN, OUT = Leaves15(), Leaves15()
    fork = Vector((0.8, base * 0.62, -0.4))
    segs = [[Vector((0, -0.3, 0)), Vector((-0.9, base * 0.3, 0.5)), fork]]
    cy = base + Hc * 0.4; cents = [Vector((0, base + Hc * 0.68, 0))]
    for i in range(1, nclus):
        a = 2 * math.pi * i / (nclus - 1) + random.uniform(-0.3, 0.3)
        rr = random.uniform(0.5, 0.8); tier = 1 if i % 3 == 0 else 0
        cents.append(Vector((W * 0.5 * rr * math.cos(a) * 0.82, cy + random.uniform(-2.0, 2.5) + tier * Hc * 0.25,
                             W * 0.5 * rr * math.sin(a) * 0.6)))
    for k, c in enumerate(cents[1:]):
        if k % 2 == 0:
            m = fork.lerp(c, 0.5) + Vector((random.uniform(-1.5, 1.5), 1.5, random.uniform(-1.5, 1.5)))
            segs.append([fork, m, c.lerp(m, 0.3)])
    segs.append([fork, cents[0] - Vector((0, 4, 0))])
    for c in cents: clump15(IN, OUT, c, random.uniform(5.0, 6.5), n, flat=0.8, Lc=(1.4, 2.2))
    wood13(tag, segs, trunk_r); finish15(tag, IN, OUT)

def build_skull15():
    """Raid skull, pass 15 (verify12 item 2): the pass-8 head and jaw WITHOUT the stepped pedestal (it read as a 2-tier pink
    toy plinth), on a tapering carved pillar in a separate mesh (K_Skull15_pillar, coloured like the facade in Studio), so
    the skull grows out of the tower as in the reference pictures. Pillar: an 8-sided tapered shaft from under the jaw
    (y -6.5) down to y -26, 8.5 -> 12 wide (deeper at the back), with 4 carved horizontal bands, 4 vertical ribs on the
    diagonals that flare out at the foot like roots, and a recessed channel down the front for the red beam."""
    clear_piece("K_Skull15_"); clear_piece("Q_")
    bm = bmesh.new(); bmesh.ops.create_uvsphere(bm, u_segments=48, v_segments=32, radius=1.0)
    eyes = [(0.4, -2.0), (0.4, 2.0)]; W = {}
    g = lambda a, b: math.exp(-(a * a + b * b))
    bm.verts.index_update()
    for v in bm.verts:
        x, y, z = v.co.x * 5.2, v.co.y * 6.0, v.co.z * 5.0
        if y < -1.0:
            t = min(1.0, (-y - 1.0) / 5.0); z *= 1 - 0.30 * t; x = x * (1 - 0.15 * t)
        if x < 0: x *= 0.86
        w = 0.0
        front = max(0.0, min(1.0, (-x - 0.5) / 2.0))  # 0 at the sides, 1 on the face
        if front > 0:
            for ey, ez in eyes:
                w = max(w, g((y - ey) / 1.6, (z - ez) / 1.4))
            x += 3.6 * w * front
            dn = g((y + 2.0) / 0.8, z / 0.6); x += 1.9 * dn * front; w = max(w, dn)
            x -= 1.7 * front * g((y - 2.2) / 0.75, 0) * (1 - w) * (1 if abs(z) < 4.2 else 0.3)  # brow ridge
            x += 0.7 * front * g(z / 0.55, (y - 2.6) / 1.0)                                       # brow notch
            for s in (-1, 1):
                ck = g((y + 1.0) / 0.8, (abs(z) - 3.2) / 1.0) if z * s > 0 else 0.0
                x -= 1.4 * ck * front; z += s * 0.5 * ck                                          # cheekbones
            x += 0.6 * front * g((y + 2.9) / 0.6, (abs(z) - 2.2) / 0.9)                           # under-cheek hollow
        if abs(z) > 3.0 and -0.5 < y < 3.5 and x < 1.5:
            z *= 1 - 0.07 * g((y - 1.2) / 1.2, (x + 1.0) / 1.5)                                  # temple hollow
        y += 0.25 * math.sin(3.1 * z + 1.3 * x) * max(0.0, y / 6.0)                               # weathered crown
        v.co = Vector((x, y, z)); W[v.index] = w
    dark = bmesh.new(); dfaces = [f for f in bm.faces if sum(W[v.index] for v in f.verts) / len(f.verts) > 0.3]
    for f in dfaces:
        dark.faces.new([dark.verts.new(v.co) for v in f.verts])
    bmesh.ops.delete(bm, geom=dfaces, context='FACES')
    bone = [bm_obj("Q_head", bm, smooth=True)]
    bone.append(rbox("Q_jaw", 6.4, 2.8, 7.4, 0.9, 2, (0.6, -6.1, 0)))
    bone.append(rbox("Q_chin", 2.2, 2.0, 3.6, 0.6, 2, (-2.4, -6.9, 0)))
    for i in range(8):
        z = -2.6 + 0.74 * i
        bone.append(rbox(f"Q_tu{i}", 0.9, 1.3, 0.62, 0.18, 1, (-2.9, -4.9, z)))
        bone.append(rbox(f"Q_tl{i}", 0.9, 1.0, 0.62, 0.18, 1, (-2.7, -5.9, z)))
    bone = [x for x in bone]
    dk = []  # r8b: the pass-8 crack strips floated in front of the receding crown (read as black antennae): dropped
    eye = []
    for k, (ey, ez) in enumerate(eyes):
        eye.append(lathe_at(f"Q_eye{k}", [(0.9 * math.sin(t), -0.9 * math.cos(t)) for t in [math.pi * j / 6 for j in range(7)]], (-1.6, ey, ez), 10))
    o = merge_objs("K_Skull15_bone", bone)
    d = bm_obj("Q_dk", dark); merge_objs("K_Skull15_dark", [d] + dk); merge_objs("K_Skull15_eye", eye)
    pil = []
    prof = [(0.0, -26.0), (6.2, -26.0), (6.2, -24.6), (5.6, -24.2), (5.5, -20.5), (5.9, -20.1), (5.9, -19.1), (5.2, -18.7),
            (5.0, -15.0), (5.4, -14.6), (5.4, -13.7), (4.8, -13.3), (4.6, -10.4), (5.0, -10.0), (5.0, -9.1), (4.4, -8.7),
            (4.3, -6.0), (0.0, -6.0)]
    pc = lathe("Q_shaft", prof, seg=8, smooth=False)
    for v in pc.data.vertices: v.co.z *= 1.12
    pc.rotation_euler = (0, math.radians(22.5), 0); pc.location = (0.8, 0, 0); pil.append(pc)
    for k in range(4):  # diagonal ribs flaring at the foot
        a = math.radians(45 + 90 * k); ca, sa = math.cos(a), math.sin(a)
        # ribs hug the shaft faces (apothem ~0.92 r): the first try stood 0.6 off the shaft and read as a birdcage
        rr = lambda r: (0.8 + r * ca, r * 1.12 * sa)
        pts = [(4.1, -7.2), (4.6, -13.0), (5.2, -19.5), (6.9, -25.8)]
        pil.append(tube_along(f"Q_rib{k}", [(rr(r)[0], y, rr(r)[1]) for r, y in pts], 0.95, res=3))
    pil.append(rbox("Q_chan_l", 1.0, 17.5, 0.9, 0.3, 1, (-4.1, -16.0, -1.5)))  # beam channel lips on the front face
    pil.append(rbox("Q_chan_r", 1.0, 17.5, 0.9, 0.3, 1, (-4.1, -16.0, 1.5)))
    pil.append(rbox("Q_collar", 8.0, 1.4, 9.4, 0.4, 2, (0.6, -6.6, 0)))
    merge_objs("K_Skull15_pillar", pil)
    return o

def build_scale15():
    clear_piece("K_Scale15_"); return rbox("K_Scale15_stone", 10.0, 10.0, 10.0, 0.01, 1)

R15_PREFIXES = ("K_Scale15_", "K_Soft15", "K_Skull15_")
SOFT15 = ("Soft15R", "Soft15C", "Soft15U", "Soft15W", "Soft15Y", "Soft15K", "Soft15B", "Soft15G")

def build_all15():
    build_scale15(); build_round15(); build_cloud15(); build_umb15(); build_wis15(); build_cyp15(); build_clump15()
    build_bush15(); build_gold15(); build_skull15()
    return {t: tri_count(f"K_{t}_") for t in SOFT15}

def export_r15(path):
    """Z-up, then export ONLY the pass-15 pieces plus the 10-stud cube (merged into Kit in Studio)."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R15_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='OFF', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 16 (verify13 items 3 and 4: medallion, bollard, Story trunk)
def build_scale16():
    clear_piece("K_Scale16_"); return rbox("K_Scale16_stone", 10.0, 10.0, 10.0, 0.01, 1)

def build_blades16():
    """Medallion shuriken (reference top capture ref16_medal_top: 8 short thick hooked blades, about 0.55 of the pale disc's
    radius, joined round a dark ring behind the gold hub). Authored flat at y 0..0.12, radius 4.9; Studio drops it on the disc."""
    clear_piece("K_Blade16"); clear_piece("Q_")
    objs = []
    for i in range(8):
        o = extrude_outline(f"Q_bl{i}", blade_outline(2 * math.pi * i / 8, r0=1.3, r1=4.9, sweep=0.62, w=0.95, n=12), 0.12, bevel=0.0)
        o.rotation_euler = (math.radians(90), 0, 0); o.location = (0, 0.06, 0); flat(o)
        o.data.flip_normals()
        objs.append(o)
    objs.append(flat(lathe("Q_ring", [(0, 0), (2.1, 0), (2.1, 0.12), (0, 0.12)], seg=32, smooth=False)))
    return merge_objs("K_Blade16_dark", objs)

def build_bollard16():
    """Squat square bollard (verify13 item 3): grey stone foot 3.0 wide x 0.5, tapered body 2.4 -> 2.0 up to 2.5, and a faceted
    pointed gold cap (a 4-sided lathe: square bishop's mitre) about 2 tall. Square sections = 4-segment lathe turned 45 deg."""
    clear_piece("K_Bollard16"); clear_piece("Q_")
    sq = lambda name, prof: flat(lathe(name, prof, seg=4, start=math.pi / 4, smooth=False))
    k = math.sqrt(2)
    stone = [sq("Q_foot", [(0, 0), (1.5 * k, 0), (1.5 * k, 0.5), (1.3 * k, 0.62), (0, 0.62)]),
             sq("Q_body", [(0, 0.62), (1.2 * k, 0.62), (1.0 * k, 2.3), (1.12 * k, 2.38), (1.12 * k, 2.5), (0, 2.5)])]
    prof = [(0, 2.5), (0.95 * k, 2.5), (0.95 * k, 2.72), (0.9 * k, 3.25), (0.72 * k, 3.75), (0.42 * k, 4.18), (0.0, 4.55)]
    gold = [sq("Q_cap", prof)]
    merge_objs("K_Bollard16_stone", stone); merge_objs("K_Bollard16_gold", gold)

def taper_tube(name, pts, radii, res=8, jitter=0.0, seed=0):
    """Tube along pts with a radius per point (closed end caps): gnarled limbs. jitter roughens the ring radii."""
    import random; rnd = random.Random(seed)
    bm = bmesh.new(); rings = []
    P = [Vector(p) for p in pts]
    up = Vector((0, 1, 0))
    for i, p in enumerate(P):
        t = (P[min(i + 1, len(P) - 1)] - P[max(i - 1, 0)]).normalized()
        a = t.cross(up if abs(t.dot(up)) < 0.95 else Vector((1, 0, 0))).normalized(); b = t.cross(a).normalized()
        ring = []
        for j in range(res):
            th = 2 * math.pi * j / res; r = radii[i] * (1 + rnd.uniform(-jitter, jitter))
            ring.append(bm.verts.new(p + (a * math.cos(th) + b * math.sin(th)) * r))
        rings.append(ring)
    for i in range(len(rings) - 1):
        for j in range(res):
            bm.faces.new((rings[i][j], rings[i][(j + 1) % res], rings[i + 1][(j + 1) % res], rings[i + 1][j]))
    bm.faces.new(list(reversed(rings[0]))); bm.faces.new(rings[-1])
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return mesh_obj(name, bm, True, 70)

def build_trunk16(seed=161):
    """Story tree trunk (verify13 item 4): a flared, twisting trunk that splits at about 2/3 height into 5 thick gnarled limbs
    reaching out and up into the canopy. Authored base at y 0, split at y 27, limb tips at y 44-52, 17-26 out. Studio scales it."""
    import random; rnd = random.Random(seed)
    clear_piece("K_Trunk16"); clear_piece("Q_")
    objs = []
    # trunk: 7 rings, slight twist/lean, root flare
    tp = [(0, -1.0, 0), (0.3, 3, 0.2), (0.8, 9, -0.4), (0.4, 15, 0.3), (-0.3, 21, 0.2), (0, 26, 0), (0, 29, 0)]
    tr = [8.5, 6.2, 5.2, 4.8, 4.6, 4.9, 4.4]
    objs.append(taper_tube("Q_trunk", tp, tr, res=10, jitter=0.08, seed=seed))
    # root buttresses
    for k in range(5):
        a = 2 * math.pi * k / 5 + 0.3
        objs.append(taper_tube(f"Q_root{k}", [(math.cos(a) * 4.5, 5.5, math.sin(a) * 4.5), (math.cos(a) * 8.0, 1.5, math.sin(a) * 8.0),
                                              (math.cos(a) * 10.5, -0.6, math.sin(a) * 10.5)], [2.2, 1.6, 0.9], res=7, jitter=0.1, seed=k))
    # 5 limbs from the split
    for k in range(5):
        a = 2 * math.pi * k / 5 + rnd.uniform(-0.25, 0.25)
        R = rnd.uniform(17, 26); H = rnd.uniform(44, 52)
        d = Vector((math.cos(a), 0, math.sin(a))); s = Vector((-d.z, 0, d.x)) * rnd.uniform(-3, 3)
        pts = [Vector((0, 25, 0)) + d * 1.2,
               Vector((0, 31, 0)) + d * (R * 0.25) + s * 0.4,
               Vector((0, 37, 0)) + d * (R * 0.52) - s * 0.5,
               Vector((0, 42, 0)) + d * (R * 0.78) + s,
               Vector((0, H, 0)) + d * R]
        objs.append(taper_tube(f"Q_limb{k}", [tuple(p) for p in pts], [3.0, 2.5, 2.0, 1.5, 0.9], res=8, jitter=0.1, seed=10 + k))
        # one side branch per limb
        m = pts[2]; d2 = (d + Vector((-d.z, 0, d.x)) * rnd.choice((-0.9, 0.9))).normalized()
        objs.append(taper_tube(f"Q_br{k}", [tuple(m), tuple(m + d2 * 5 + Vector((0, 4, 0))), tuple(m + d2 * 9 + Vector((0, 9, 0)))], [1.3, 0.9, 0.5], res=6, jitter=0.1, seed=20 + k))
    o = merge_objs("K_Trunk16_wood", objs)
    for p in o.data.polygons: p.use_smooth = True
    return o

R16_PREFIXES = ("K_Scale16_", "K_Blade16_", "K_Bollard16_", "K_Trunk16_")

def build_all16():
    build_scale16(); build_blades16(); build_bollard16(); build_trunk16()
    return {p: tri_count(p) for p in R16_PREFIXES}

def export_r16(path):
    """Z-up, then export ONLY the pass-16 pieces plus the 10-stud cube (merged into Kit in Studio)."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R16_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='OFF', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 17: wing flanks (scrolls in front of the arch), hero
# without the outward shoulder wings, leaf-splat card. Authored straight into Blender Z-up (flagged zup).
def _yup_to_b(x, y, z):
    return (x, -z, y)

def flank_top17(w, W0=25.0, W1=33.3):
    """Scroll top: 2 above the floor at the plaza end (w 25), 8 at the arch front (w 33.3), concave (t^1.7)."""
    t = max(0.0, min(1.0, (w - W0) / (W1 - W0)))
    return 2.0 + 6.0 * t ** 1.7

def sweep17(bm, ws, u0, u1, yb, yt, mirror):
    """Rectangle (u0..u1 x yb(w)..yt(w)) swept along the corner diagonal w, mirrored (mx, mz); closed solid."""
    rings = []
    for w in ws:
        a, b = yb(w), yt(w)
        ring = []
        for u, y in ((u0, a), (u1, a), (u1, b), (u0, b)):
            x, yy, z = P(u, y, w)
            ring.append(bm.verts.new(_yup_to_b(x * mirror[0], yy, z * mirror[1])))
        rings.append(ring)
    fs = []
    for i in range(len(rings) - 1):
        A, B = rings[i], rings[i + 1]
        for k in range(4):
            fs.append(bm.faces.new((A[k], A[(k + 1) % 4], B[(k + 1) % 4], B[k])))
    fs.append(bm.faces.new(rings[0])); fs.append(bm.faces.new(rings[-1][::-1]))
    bmesh.ops.recalc_face_normals(bm, faces=fs)

def _zup_obj(name, bm):
    clear_piece(name)
    me = bpy.data.meshes.new(name); bm.to_mesh(me); bm.free()
    for p in me.polygons: p.use_smooth = False
    ob = bpy.data.objects.new(name, me); ob["zup"] = 1; coll().objects.link(ob); return ob

def build_flank17(N=18, W0=25.0, W1=33.3):
    """8 scroll flanks (2 per corner) continuing the arch legs (u 7.6..10) forward to the plaza: slate body, gold top rim
    0.15 wider each side, two dark recessed bands (offset 1.15 and 2.35 below the top, 0.5 tall) on both faces."""
    ws = [W0 + (W1 - W0) * i / N for i in range(N + 1)]
    bms = {k: bmesh.new() for k in ("slate", "groove", "gold")}
    for mx in (1, -1):
        for mz in (1, -1):
            for s in (1, -1):
                lo, hi = sorted((s * 7.6, s * 10.0))
                sweep17(bms["slate"], ws, lo, hi, lambda w: 0.0, flank_top17, (mx, mz))
                sweep17(bms["gold"], ws, lo - 0.15, hi + 0.15, lambda w: flank_top17(w) - 0.05, lambda w: flank_top17(w) + 0.25, (mx, mz))
                for d in (1.15, 2.35):
                    wsg = [w for w in ws if flank_top17(w) - d - 0.5 > 0.25]
                    if len(wsg) < 2: continue
                    for uf in (lo, hi):
                        sweep17(bms["groove"], wsg, uf - 0.03, uf + 0.03, lambda w, d=d: flank_top17(w) - d - 0.5, lambda w, d=d: flank_top17(w) - d, (mx, mz))
    return [_zup_obj("K_Flank17_" + k, bm).name for k, bm in bms.items()]

def build_hero17():
    """K_Hero17_stone / _gold: copies of the (pass-10) K_Hero_stone / _gold with the 8 outward shoulder wings (Q_wingL/R and
    their gold strips) deleted: faces whose every vertex lies in a wing strip (|x| 16.9..19.7 by |z| 31..48 at y >= 6, or the
    swap; gold 16.8..17.1 at y >= 6.62)."""
    def wing_face(f, gold):
        for v in f.verts:
            x, y, z = v.co.x, v.co.z, -v.co.y
            ax, az = abs(x), abs(z)
            lo, hi = (16.8, 17.1) if gold else (16.9, 19.7)
            if y < (6.62 if gold else 5.99): return False
            if not ((lo <= ax <= hi and 31.0 <= az <= 48.05) or (lo <= az <= hi and 31.0 <= ax <= 48.05)): return False
        return True
    out = {}
    for tok in ("stone", "gold"):
        src = bpy.data.objects["K_Hero_" + tok]; name = "K_Hero17_" + tok
        clear_piece(name)
        me = src.data.copy(); me.name = name
        ob = bpy.data.objects.new(name, me); ob["zup"] = 1; coll().objects.link(ob); ob.matrix_world = src.matrix_world.copy()
        bm = bmesh.new(); bm.from_mesh(me)
        dead = [f for f in bm.faces if wing_face(f, tok == "gold")]
        bmesh.ops.delete(bm, geom=dead, context='FACES')
        bmesh.ops.delete(bm, geom=[v for v in bm.verts if not v.link_faces], context='VERTS')
        bm.to_mesh(me); bm.free(); out[name] = len(dead)
    return out

def build_splat17(seed=1717, n=48):
    """Ragged leaf splat about 4.6 across (Z-up, flat): a lobed core (r 1.55 +- 0.35, 3 lobes, jitter) 0.06 above a fringe
    disc whose radius alternates long/short teeth (+0.75 / +0.25, + up to 0.35). Both double-sided."""
    import random
    rng = random.Random(seed)
    core = [1.55 + 0.35 * math.sin(3 * 2 * math.pi * i / n + 0.7) + rng.uniform(-0.15, 0.15) for i in range(n)]
    rim = [core[i] + (0.75 if i % 2 == 0 else 0.25) + rng.uniform(0, 0.35) for i in range(n)]
    def disc(bm, rr, y, flip):
        c = bm.verts.new((0, 0, y))
        ring = [bm.verts.new((rr[i] * math.cos(2 * math.pi * i / n), rr[i] * math.sin(2 * math.pi * i / n), y)) for i in range(n)]
        for i in range(n):
            bm.faces.new((c, ring[(i + 1) % n], ring[i]) if flip else (c, ring[i], ring[(i + 1) % n]))
    names = []
    for k, rr, y in (("core", core, 0.06), ("rim", rim, 0.0)):
        bm = bmesh.new(); disc(bm, rr, y, False); disc(bm, rr, y - 0.02, True)
        names.append(_zup_obj("K_Splat17_" + k, bm).name)
    return names

def build_scale17():
    clear_piece("K_Scale17_")
    bm = bmesh.new(); bmesh.ops.create_cube(bm, size=10.0)
    return _zup_obj("K_Scale17_stone", bm).name

R17_PREFIXES = ("K_Scale17_", "K_Flank17_", "K_Hero17_", "K_Splat17_")

def build_all17():
    build_scale17(); h = build_hero17(); f = build_flank17(); s = build_splat17()
    return {"hero17_deleted": h, "flank": f, "splat": s}

def export_r17(path):
    """UVs on the new pieces (all authored Z-up), then export ONLY the pass-17 pieces plus the 10-stud cube."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R17_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='OFF', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 18: the arch's outer sweep band (replaces the pass-17
# forward scroll flanks). Read from the reference c1/c3 frontal frames and the refB17 side view: the dark "flank" is the arch's
# own outer band, ~3 thick, curving from the crest arms out and down to the floor beside the stair stringer, pale front face with
# two dark recessed grooves following the curve, a gold edge on the outer rim only. Authored Y-up in the pass-4 diagonal frame.
def sweep_outline18(f, s, n_arc=16, n_leg=3, cu=5.7, cy=4.5, a0=4.3, b0=4.5, T=3.0):
    """(u, y) outline at radial fraction f (0 inner, 1 outer) of the side-s band: quarter ellipse centred (s*cu, cy) from the
    top (u = s*cu) down to (s*(cu+a), cy), then the straight leg to the floor."""
    a, b = a0 + T * f, b0 + T * f
    pts = [(s * (cu + a * math.sin(math.pi / 2 * k / n_arc)), cy + b * math.cos(math.pi / 2 * k / n_arc)) for k in range(n_arc + 1)]
    pts += [(s * (cu + a), cy * (1 - k / n_leg)) for k in range(1, n_leg + 1)]
    return pts

def build_sweep18(W0=33.0, W1=36.5, rec=0.45):
    """K_Sweep18_stone / _groove / _gold: rings f 0-0.28, 0.38-0.62, 0.72-1 stone (front at W0); grooves 0.28-0.38 and 0.62-0.72
    recessed by rec; a gold tube along the outer front edge. Both sides of the arch, mirrored to the 4 corners."""
    clear_piece("K_Sweep18_"); clear_piece("Q_")
    G = {"stone": [], "groove": [], "gold": []}
    for s in (1, -1):
        for f0, f1, tok in ((0.0, 0.28, "stone"), (0.28, 0.38, "groove"), (0.38, 0.62, "stone"), (0.62, 0.72, "groove"), (0.72, 1.0, "stone")):
            G[tok].append(arch_band(f"Q_sw{s}_{f0}", sweep_outline18(f1, s), sweep_outline18(f0, s), W0 + (rec if tok == "groove" else 0.0), W1))
        G["gold"].append(tube_along(f"Q_swGold{s}", [P(u, y, W0 - 0.02) for u, y in sweep_outline18(1.0, s)], 0.22))
    return [merge_objs(f"K_Sweep18_{k}", v, mirror4=True).name for k, v in G.items() if v]

def build_scale18():
    clear_piece("K_Scale18_"); return rbox("K_Scale18_stone", 10.0, 10.0, 10.0, 0.01, 1)

R18_PREFIXES = ("K_Scale18_", "K_Sweep18_")

def build_all18():
    build_scale18(); return build_sweep18()

def export_r18(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-18 pieces plus the 10-stud cube."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R18_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 19: narrower, darker arch (verify16 item 1). Read from the
# reference c1 frame (camera 16 studs in front of the arch face, ~35.4 px/stud): a pale front band (intrados to ~u 8.1 at the
# legs, top ~9.7) whose crest rises into a U-handle (arms u 2.2..3.9, top ~12.5, rounded outer corners), and OUTSIDE it one
# dark-slate band (~1 thick, outer edge ~u 9.2 at the legs) with one groove, gold rims on every edge. The old hero arch band,
# crest and their gold ribbons are cut out of K_Hero17 (-> K_Hero19); the inner rib steps (K_Hero_rib / darkStone) stay as the lip.
SQ2 = math.sqrt(2.0)
def _uwy(co_world_b):
    """Blender Z-up world co -> (u, w, y) folded into the NE corner frame."""
    X, Y, Z = co_world_b.x, co_world_b.z, -co_world_b.y
    Xp, Zp = abs(X), -abs(Z)
    return ((Xp + Zp) / SQ2, (Xp - Zp) / SQ2, Y)

def build_hero19():
    """K_Hero19_stone / _gold: K_Hero17 with the arch band (Q_arch), the crest (Q_crest) and the arch/crest gold ribbons deleted."""
    def dead_stone(f, M):
        P3 = [_uwy(M @ v.co) for v in f.verts]
        if not all(32.9 <= w <= 39.6 and abs(u) <= 10.05 and y >= -0.01 for u, w, y in P3): return False
        if all(y <= 6.001 for u, w, y in P3) and min(w for u, w, y in P3) >= 33.99: return False   # corner block
        if any(math.hypot(u, w - 33.1) < 5.6 and y < 2.7 for u, w, y in P3): return False            # basin
        return True
    def dead_gold(f, M):
        P3 = [_uwy(M @ v.co) for v in f.verts]
        return all(32.5 <= w <= 37.5 and abs(u) <= 10.8 and y >= 0.3 for u, w, y in P3)
    out = {}
    for tok, fn in (("stone", dead_stone), ("gold", dead_gold)):
        src = bpy.data.objects["K_Hero17_" + tok]; name = "K_Hero19_" + tok
        clear_piece(name)
        me = src.data.copy(); me.name = name
        ob = bpy.data.objects.new(name, me); ob["zup"] = 1; coll().objects.link(ob); ob.matrix_world = src.matrix_world.copy()
        M = src.matrix_world
        bm = bmesh.new(); bm.from_mesh(me)
        dead = [f for f in bm.faces if fn(f, M)]
        bmesh.ops.delete(bm, geom=dead, context='FACES')
        bmesh.ops.delete(bm, geom=[v for v in bm.verts if not v.link_faces], context='VERTS')
        bm.to_mesh(me); bm.free(); out[name] = len(dead)
    return out

A19 = dict(hw_in=7.6, hs_in=4.2, ry_in=4.0, cu=3.9, cy=4.4, a_p=4.4, b_p=5.3, a_d=5.3, b_d=6.2, top=9.7,
           arm_in=2.2, arm_top=12.5, arm_r=1.1, W0=33.0, W1=39.5, Wd=33.3, Wg=33.65, Wa=36.5, n_arc=14, n_leg=3, n_pre=4)

def _arc19(a, b, s, A=A19):
    """Outer-edge arc of side s: quarter ellipse centred (s*cu, cy) from the top (u = s*cu) to (s*(cu+a), cy), then the leg."""
    n, L, cu, cy = A["n_arc"], A["n_leg"], A["cu"], A["cy"]
    pts = [(s * (cu + a * math.sin(math.pi / 2 * k / n)), cy + b * math.cos(math.pi / 2 * k / n)) for k in range(n + 1)]
    return pts + [(s * (cu + a), cy * (1 - k / L)) for k in range(1, L + 1)]

def _intrados19(s, A=A19, u_from=None):
    """Intrados (in1: hw 7.6, springing 4.2, rise 4.0) from u_from (default the arm line u = cu) down the side s, same count as _arc19."""
    n, L, hw, hs, ry = A["n_arc"], A["n_leg"], A["hw_in"], A["hs_in"], A["ry_in"]
    t0 = math.asin(min(1.0, (A["cu"] if u_from is None else u_from) / hw))
    pts = []
    for k in range(n + 1):
        t = t0 + (math.pi / 2 - t0) * k / n
        pts.append((s * hw * math.sin(t), hs + ry * math.cos(t)))
    return pts + [(s * hw, hs * (1 - k / L)) for k in range(1, L + 1)]

def build_arch19(A=A19):
    """K_Arch19_stone (pale band + U arms), _slate (outer band, 2 strips), _groove, _gold (rims). Y-up, NE corner, mirrored to 4."""
    clear_piece("K_Arch19_"); clear_piece("Q_")
    G = {"stone": [], "slate": [], "groove": [], "gold": []}
    W0, W1 = A["W0"], A["W1"]
    for s in (1, -1):
        po = _arc19(A["a_p"], A["b_p"], s); pi_ = _intrados19(s)
        G["stone"].append(arch_band(f"Q_pale{s}", po, pi_, W0, W1))
        do = _arc19(A["a_d"], A["b_d"], s)
        lerp = lambda f: [(p[0] + (q[0] - p[0]) * f, p[1] + (q[1] - p[1]) * f) for p, q in zip(po, do)]
        for f0, f1, tok, w in ((0.0, 0.42, "slate", A["Wd"]), (0.42, 0.58, "groove", A["Wg"]), (0.58, 1.0, "slate", A["Wd"])):
            G[tok].append(arch_band(f"Q_dk{s}_{f0}", lerp(f1), lerp(f0), w, W1))
        # U-handle arm: u arm_in..cu, from inside the band up to arm_top, outer top corner rounded (radius arm_r)
        r = A["arm_r"]; cu, ai, top = A["cu"], A["arm_in"], A["arm_top"]
        arm = [(ai, top - 3.9), (cu, top - 3.9), (cu, top - r)]
        arm += [(cu - r + r * math.cos(math.pi / 2 * k / 6), top - r + r * math.sin(math.pi / 2 * k / 6)) for k in range(1, 7)]
        arm += [(ai, top)]
        arm = [(s * u, y) for u, y in arm]
        if s < 0: arm = arm[::-1]
        G["stone"].append(extrude_uy(f"Q_arm{s}", arm, W0, A["Wa"]))
        # gold rims (front edges): intrados (from the crown), pale/slate boundary, slate outer edge, arm outline
        G["gold"].append(tube_along(f"Q_gIn{s}", [P(u, y, W0 - 0.02) for u, y in _intrados19(s, u_from=0.0)], 0.15))
        G["gold"].append(tube_along(f"Q_gMid{s}", [P(u, y, W0 - 0.02) for u, y in po], 0.15))
        G["gold"].append(tube_along(f"Q_gOut{s}", [P(u, y, A["Wd"] - 0.02) for u, y in do], 0.15))
        ao = [(s * ai, A["top"]), (s * ai, top)] + [(s * (cu - r + r * math.cos(math.pi / 2 * k / 6)), top - r + r * math.sin(math.pi / 2 * k / 6)) for k in range(6, -1, -1)] + [(s * cu, A["top"] + 0.3)]
        G["gold"].append(tube_along(f"Q_gArm{s}", [P(u, y, W0 - 0.02) for u, y in ao], 0.15))
    # pale band crown between the arms (u -cu..cu, from the intrados crown to the band top)
    crown_o = [(u, A["top"]) for u in [A["cu"] * (1 - 2 * k / 12) for k in range(13)]]
    crown_i = [(u, A["hs_in"] + A["ry_in"] * math.sqrt(max(0.0, 1 - (u / A["hw_in"]) ** 2))) for u, _ in crown_o]
    G["stone"].append(arch_band("Q_crown", crown_o, crown_i, W0, W1))
    G["gold"].append(tube_along("Q_gSill", [P(u, A["top"], W0 - 0.02) for u in (-A["arm_in"], A["arm_in"])], 0.15))
    return [merge_objs(f"K_Arch19_{k}", v, mirror4=True).name for k, v in G.items() if v]

def build_scale19():
    clear_piece("K_Scale19_"); return rbox("K_Scale19_stone", 10.0, 10.0, 10.0, 0.01, 1)

R19_PREFIXES = ("K_Scale19_", "K_Hero19_", "K_Arch19_")

def build_all19():
    build_scale19(); h = build_hero19(); a = build_arch19(); return {"hero19_deleted": h, "arch": a}

def export_r19(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-19 pieces plus the 10-stud cube."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R19_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 20 (verify17 items 2-3, 5): squat arch opening, stepped
# outer slate bands fanning onto the stair rail, sculpted splash, squat bollard, swim ring. Read from the reference c1 frame by
# projecting the inner-edge pixels onto the arch front plane (out/r20w/plane.py): the intrados is an ellipse hw 7.6 centred at
# y 1.1 with rise 5.4 (top 6.5; pass 19 had 8.2), the sill under the U-handle at ~8.9 (was 9.7), the handle top ~12.4.
A20 = dict(A19, hs_in=1.1, ry_in=5.4, top=9.0, b1=(5.2, 6.1, 1.3), b2=(6.4, 7.2, 3.0), Wb1=33.3, Wb2=33.75)

def _arc20(a, b, s, flare=0.0, A=A20):
    """_arc19 outline whose leg fans outward by 'flare' at the floor (concave, t^1.6): the band runs out onto the stair rail."""
    n, L, cu, cy = A["n_arc"], A["n_leg"], A["cu"], A["cy"]
    pts = [(s * (cu + a * math.sin(math.pi / 2 * k / n)), cy + b * math.cos(math.pi / 2 * k / n)) for k in range(n + 1)]
    return pts + [(s * (cu + a + flare * (k / L) ** 1.6), cy * (1 - k / L)) for k in range(1, L + 1)]

def build_arch20(A=A20):
    """K_Arch20_stone (pale band + U arms, squat opening), _slate (two stepped bands), _gold (rims on every band edge)."""
    clear_piece("K_Arch20_"); clear_piece("Q_")
    G = {"stone": [], "slate": [], "gold": []}
    W0, W1 = A["W0"], A["W1"]
    for s in (1, -1):
        po = _arc19(A["a_p"], A["b_p"], s, A); pi_ = _intrados19(s, A)
        G["stone"].append(arch_band(f"Q_pale{s}", po, pi_, W0, W1))
        a1, b1, f1 = A["b1"]; a2, b2, f2 = A["b2"]
        o1 = _arc20(a1, b1, s, f1); o2 = _arc20(a2, b2, s, f2)
        G["slate"].append(arch_band(f"Q_b1{s}", o1, po, A["Wb1"], W1))
        G["slate"].append(arch_band(f"Q_b2{s}", o2, o1, A["Wb2"], W1))
        G["gold"].append(tube_along(f"Q_gB1{s}", [P(u, y, A["Wb1"] - 0.02) for u, y in o1], 0.14))
        G["gold"].append(tube_along(f"Q_gB2{s}", [P(u, y, A["Wb2"] - 0.02) for u, y in o2], 0.14))
        r = A["arm_r"]; cu, ai, top = A["cu"], A["arm_in"], A["arm_top"]
        arm = [(ai, A["top"] - 0.4), (cu, A["top"] - 0.4), (cu, top - r)]
        arm += [(cu - r + r * math.cos(math.pi / 2 * k / 6), top - r + r * math.sin(math.pi / 2 * k / 6)) for k in range(1, 7)]
        arm += [(ai, top)]
        arm = [(s * u, y) for u, y in arm]
        if s < 0: arm = arm[::-1]
        G["stone"].append(extrude_uy(f"Q_arm{s}", arm, W0, A["Wa"]))
        G["gold"].append(tube_along(f"Q_gIn{s}", [P(u, y, W0 - 0.02) for u, y in _intrados19(s, A, u_from=0.0)], 0.15))
        G["gold"].append(tube_along(f"Q_gMid{s}", [P(u, y, W0 - 0.02) for u, y in po], 0.15))
        ao = [(s * ai, A["top"]), (s * ai, top)] + [(s * (cu - r + r * math.cos(math.pi / 2 * k / 6)), top - r + r * math.sin(math.pi / 2 * k / 6)) for k in range(6, -1, -1)] + [(s * cu, A["top"] + 0.3)]
        G["gold"].append(tube_along(f"Q_gArm{s}", [P(u, y, W0 - 0.02) for u, y in ao], 0.15))
    crown_o = [(u, A["top"]) for u in [A["cu"] * (1 - 2 * k / 12) for k in range(13)]]
    crown_i = [(u, A["hs_in"] + A["ry_in"] * math.sqrt(max(0.0, 1 - (u / A["hw_in"]) ** 2))) for u, _ in crown_o]
    G["stone"].append(arch_band("Q_crown", crown_o, crown_i, W0, W1))
    G["gold"].append(tube_along("Q_gSill", [P(u, A["top"], W0 - 0.02) for u in (-A["arm_in"], A["arm_in"])], 0.15))
    return [merge_objs(f"K_Arch20_{k}", v, mirror4=True).name for k, v in G.items() if v]

def build_splash20(H=3.0):
    """K_Splash20_water: a sculpted 3-lobe splash ~3 tall for the fountain drum (replaces the glass sheet). A lathe profile
    (narrow stem, swelling crown, curled lip) whose radius is modulated by 3 lobes that twist with height; the lobe tips droop
    (the water falls back over the lip). Authored at origin, base at y 0."""
    clear_piece("K_Splash20"); clear_piece("Q_")
    prof = [(0.0, 0.0), (0.9, 0.0), (0.55, 0.4), (0.45, 1.0), (0.6, 1.7), (0.95, 2.3), (1.25, 2.75), (1.2, 3.0), (0.85, 2.95),
            (0.5, 3.1), (0.2, 3.25), (0.0, 3.3)]
    seg = 36; bm = bmesh.new(); rings = []
    for i in range(seg):
        a = 2 * math.pi * i / seg
        ring = []
        for r, y in prof:
            t = y / 3.3
            c3 = math.cos(3 * (a + 0.9 * t))
            rr = r * (1.0 + 0.32 * t * c3)
            droop = -0.35 * t * t * max(0.0, c3) if r > 0.8 else 0.0
            ring.append(bm.verts.new((rr * math.cos(a), (y + droop) * H / 3.0, rr * math.sin(a))))
        rings.append(ring)
    for i in range(seg):
        A_, B_ = rings[i], rings[(i + 1) % seg]
        for k in range(len(prof) - 1):
            try: bm.faces.new((A_[k], B_[k], B_[k + 1], A_[k + 1]))
            except ValueError: pass
    bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=1e-4)
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return mesh_obj("K_Splash20_water", bm, True, 50).name

def build_boll20():
    """K_Boll20_base / _head (verify17 item 3): white base 3 x 1.5 x 3 with a 0.2 bevel and a chamfered top plate; squat round
    gold head 1.5 across, ~1.05 tall, on a thin collar. Authored at origin, base at y 0."""
    clear_piece("K_Boll20"); clear_piece("Q_")
    base = [rbox("Q_bb", 3.0, 1.3, 3.0, 0.2, 2, loc=(0, 0.65, 0)), rbox("Q_bt", 2.5, 0.25, 2.5, 0.1, 2, loc=(0, 1.38, 0))]
    head = [lathe("Q_hd", [(0.0, 1.5), (0.62, 1.5), (0.66, 1.6), (0.6, 1.66), (0.75, 1.72), (0.76, 1.95), (0.66, 2.25),
                           (0.42, 2.48), (0.0, 2.56)], seg=28, smooth=True)]
    merge_objs("K_Boll20_base", base); merge_objs("K_Boll20_head", head)
    return ["K_Boll20_base", "K_Boll20_head"]

def build_swimring20(R=1.15, r=0.42, seg=24, rs=10):
    """K_SwimRing20_red / _white: a torus (major R, minor r) lying flat on y 0, split into 6 alternating colour segments."""
    clear_piece("K_SwimRing20")
    bms = {"red": bmesh.new(), "white": bmesh.new()}
    for i in range(seg):
        tok = "red" if (i * 6 // seg) % 2 == 0 else "white"
        bm = bms[tok]
        def ring(a):
            return [bm.verts.new(((R + r * math.cos(2 * math.pi * k / rs)) * math.cos(a), r * math.sin(2 * math.pi * k / rs) + r,
                                  (R + r * math.cos(2 * math.pi * k / rs)) * math.sin(a))) for k in range(rs)]
        A_, B_ = ring(2 * math.pi * i / seg), ring(2 * math.pi * (i + 1) / seg)
        for k in range(rs):
            bm.faces.new((A_[k], A_[(k + 1) % rs], B_[(k + 1) % rs], B_[k]))
    out = []
    for tok, bm in bms.items():
        bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=1e-5)
        bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
        out.append(mesh_obj(f"K_SwimRing20_{tok}", bm, True, 60).name)
    return out

def build_scale20():
    clear_piece("K_Scale20_"); return rbox("K_Scale20_stone", 10.0, 10.0, 10.0, 0.01, 1)

R20_PREFIXES = ("K_Scale20_", "K_Arch20_", "K_Splash20_", "K_Boll20_", "K_SwimRing20_")

def build_all20():
    return {"scale": build_scale20().name, "arch": build_arch20(), "splash": build_splash20(), "boll": build_boll20(),
            "ring": build_swimring20()}

def export_r20(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-20 pieces plus the 10-stud cube."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R20_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 21 (verify18 items 1, 4): chunky bevelled stair blocks
# (6 taller steps, 4-6 stud blocks, joints offset row to row, riser = front faces only), a ruined 3-tier round-arched arcade with
# a round tower for the island skyline, and a domed palace. The reference c2/c4 frames show ~6 steps where ours had 8, and
# each block reads as a separate rounded stone (bevel ~0.3).
def build_stairs21(rise=1.0, n=6, d0=28.0, run=20.0, lat0=4.3, lat1=17.7, bevel=0.3, seed=211, tag="Stairs21"):
    """K_Stairs21_stone / _riser: 4 flights (rot4) of n steps; each step is a row of full-height bevelled blocks 4-6 wide
    with offset joints. Riser = faces whose normal points back along the flight (toward the plaza)."""
    clear_piece(f"K_{tag}_"); clear_piece("Q_")
    rnd = random.Random(seed); tread = run / n; objs = []
    for i in range(n):
        h = rise * (i + 1); dc = d0 + tread * i + tread / 2
        for s in (-1, 1):
            # widths 4-6 that fill lat0..lat1, starting with a half block on odd rows
            W = lat1 - lat0; ws = []; x = 0.0
            first = rnd.uniform(2.0, 3.0) if i % 2 else rnd.uniform(4.0, 6.0)
            ws.append(first); x = first
            while W - x > 6.0:
                w = rnd.uniform(4.0, 6.0)
                if W - x - w < 2.5: w = W - x - 2.5 if W - x - 2.5 >= 4.0 else w
                ws.append(w); x += w
            ws.append(W - x)
            x = lat0
            for w in ws:
                o = rbox(f"Q_s{i}_{s}_{x:.1f}", w - 0.1, h, tread - 0.06, bevel=bevel, segs=2, loc=(s * (x + w / 2), h / 2, -dc))
                objs.append(o); x += w
    st = merge_objs(f"K_{tag}_stone", objs, rot4=True)
    # split risers: horizontal faces whose normal points along the flight axis, toward the centre
    bm = bmesh.new(); bm.from_mesh(st.data); bm2 = bm.copy()
    def is_riser(f):
        c = f.calc_center_median(); n_ = f.normal
        if abs(n_.y) > 0.3: return False
        if abs(c.x) > abs(c.z): return n_.x * (-math.copysign(1, c.x)) > 0.7
        return n_.z * (-math.copysign(1, c.z)) > 0.7
    bmesh.ops.delete(bm, geom=[f for f in bm.faces if is_riser(f)], context='FACES')
    bmesh.ops.delete(bm2, geom=[f for f in bm2.faces if not is_riser(f)], context='FACES')
    bm.to_mesh(st.data); bm.free()
    me = bpy.data.meshes.new(f"K_{tag}_riser"); bm2.to_mesh(me); bm2.free()
    ob = bpy.data.objects.new(f"K_{tag}_riser", me); coll().objects.link(ob)
    return [st.name, ob.name]

def build_arcade21(W=26.0, D=3.0, seed=212):
    """Ruined arcade for the island skyline, ~34 tall: tier 1 (13 tall, 3 wide round arches, dark back wall), tier 2 (10 tall,
    4 arches, open to the sky), tier 3 (8 tall, broken: 2 bays of uneven height), floor slabs between tiers, and a round tower
    (r 3.4, 40 tall, 4 levels of dark arched windows, cornices, small dome) at the +x end. Faces -Z, lateral x."""
    clear_piece("K_Arcade21_"); clear_piece("Q_")
    rnd = random.Random(seed); st, dk = [], []
    tiers = [(0.0, 13.0, 3, 3.0, 0.0), (13.8, 10.0, 4, 2.0, 0.0), (24.6, 8.0, 4, 1.7, 1.0)]
    for t, (y0, H, nb, ho, broken) in enumerate(tiers):
        bw = W / nb; hs = H - ho - 1.6
        inner = arch_outline(ho, hs, ho, 2, 14)
        for b in range(nb):
            if broken and b >= 2: continue
            top = H if not broken else rnd.uniform(5.5, 8.0)
            st.append(bay(f"Q_b{t}{b}", inner, bw / 2, top, hs, -D / 2, D / 2, 'z', (-W / 2 + bw * (b + 0.5), y0, 0)))
        if t < 2: st.append(rbox(f"Q_f{t}", W + 1.0, 0.8, D + 1.0, 0.2, 1, (0, y0 + H + 0.4, 0)))
    st.append(rbox("Q_plinth", W + 1.6, 1.0, D + 1.6, 0.2, 1, (0, 0.5, 0)))
    dk.append(rbox("Q_back", W - 0.4, 12.4, 0.4, 0.05, 1, (0, 6.2, D / 2 + 0.3)))
    tx = W / 2 + 3.4
    st.append(lathe_at("Q_tw", [(0, 0), (3.9, 0), (3.9, 1.2), (3.4, 1.6), (3.4, 38.0), (0, 38.0)], (tx, 0, 0), 20, False))
    for lv in range(4):
        y = 6.0 + lv * 9.0
        st.append(lathe_at(f"Q_tc{lv}", [(3.4, y + 3.6), (3.9, y + 3.8), (3.9, y + 4.4), (3.4, y + 4.6)], (tx, 0, 0), 20, False))
        for k in range(4):
            a = 2 * math.pi * (k + 0.5 * (lv % 2)) / 4
            dk.append(rbox_rot(f"Q_tw{lv}{k}", 0.7, 3.6, 1.3, (tx + 3.15 * math.cos(a), y, 3.15 * math.sin(a)), -a, 0.55, 2))
    st.append(lathe_at("Q_tdome", [(0, 38.0), (3.8, 38.0), (3.5, 40.0), (2.4, 41.6), (0, 42.4)], (tx, 0, 0), 20))
    merge_objs("K_Arcade21_stone", st); merge_objs("K_Arcade21_darkStone", dk)
    return ["K_Arcade21_stone", "K_Arcade21_darkStone"]

def build_palace21():
    """Domed palace ~26 tall: a 20 x 10 x 14 block with 3 round-arched windows per long side and a cornice, a drum (r 5, 3
    tall), a big dome (r 6.2), a lantern and gold finial, and two small corner domes on drums at the front corners."""
    clear_piece("K_Palace21_"); clear_piece("Q_")
    st, dome, gold, dk = [], [], [], []
    st.append(rbox("Q_blk", 20.0, 10.0, 14.0, 0.3, 1, (0, 5.0, 0)))
    st.append(rbox("Q_cor", 21.0, 0.9, 15.0, 0.2, 1, (0, 10.4, 0)))
    st.append(rbox("Q_base", 21.4, 1.0, 15.4, 0.2, 1, (0, 0.5, 0)))
    for s in (-1, 1):
        for k in (-1, 0, 1):
            dk.append(rbox(f"Q_w{s}{k}", 2.4, 5.0, 0.4, 1.1, 3, (k * 6.0, 5.4, s * 7.0)))
    st.append(lathe_at("Q_drum", [(0, 10.8), (5.4, 10.8), (5.0, 11.2), (5.0, 14.0), (5.5, 14.4), (0, 14.4)], (0, 0, 0), 32, False))
    for k in range(8):
        a = 2 * math.pi * k / 8
        dk.append(rbox_rot(f"Q_dw{k}", 0.5, 1.8, 1.0, (4.85 * math.cos(a), 12.6, 4.85 * math.sin(a)), -a, 0.4, 2))
    dome.append(lathe_at("Q_dome", [(0, 14.4), (5.3, 14.4), (5.2, 16.4), (4.4, 18.6), (2.8, 20.2), (0, 20.8)], (0, 0, 0), 32))
    st.append(lathe_at("Q_lan", [(0, 20.6), (0.9, 20.6), (0.9, 22.0), (1.2, 22.2), (0, 22.6)], (0, 0, 0), 12, False))
    gold.append(lathe_at("Q_fin", [(0, 22.5), (0.4, 22.6), (0.15, 24.6), (0, 25.0)], (0, 0, 0), 8, False))
    for sx in (-1, 1):
        c = (sx * 8.4, 0, -5.4)
        st.append(lathe_at(f"Q_cd{sx}", [(0, 10.8), (1.9, 10.8), (1.9, 13.0), (0, 13.0)], c, 16, False))
        dome.append(lathe_at(f"Q_cdm{sx}", [(0, 13.0), (2.0, 13.0), (1.6, 14.4), (0.8, 15.2), (0, 15.5)], c, 16))
        gold.append(lathe_at(f"Q_cf{sx}", [(0, 15.4), (0.2, 15.4), (0.05, 16.6), (0, 16.7)], c, 6, False))
    merge_objs("K_Palace21_stone", st); merge_objs("K_Palace21_dome", dome); merge_objs("K_Palace21_gold", gold)
    merge_objs("K_Palace21_darkStone", dk)
    return ["K_Palace21_stone", "K_Palace21_dome", "K_Palace21_gold", "K_Palace21_darkStone"]

def build_scale21():
    clear_piece("K_Scale21_"); return rbox("K_Scale21_stone", 10.0, 10.0, 10.0, 0.01, 1)

R21_PREFIXES = ("K_Scale21_", "K_Stairs21_", "K_Arcade21_", "K_Palace21_")

def build_all21():
    return {"scale": build_scale21().name, "stairs": build_stairs21(), "arcade": build_arcade21(), "palace": build_palace21()}

def export_r21(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-21 pieces plus the 10-stud cube."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R21_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 22 (verify19 items 5, 8): 8 shallower stair steps and a
# raised bevelled runner slab at each stair foot. Riser count read from the frames: c4 reference dark bands at y 476/509/554/626/755
# match an 8-step flight (rise 0.75) projected through the c4 camera (487/519/564/632/747); 6 steps give 498/552/647/854. p1 shows
# 8 bands in the reference against 6 in ours. The runner slab (p5 ref y 380-680 at both stair feet) projects to d ~16.5-28 on the
# floor: a silver bevelled frame, a thick gold rim, a blue face with a gold Y, a cyan gem near the foot, top rising toward the stairs.
def build_stairs22():
    return build_stairs21(rise=0.75, n=8, seed=221, tag="Stairs22")

def _shear_up(o, d0, d1, y_add):
    """raise the top of a Y-up piece linearly along -Z: + y_add * (d - d0) / (d1 - d0) for vertices above y 0.05"""
    for v in o.data.vertices:
        d = -v.co.z
        if v.co.y > 0.05: v.co.y += y_add * max(0.0, min(1.0, (d - d0) / (d1 - d0)))

def build_runner22(d0=16.5, d1=28.0, W=7.2, h=0.55, rise=0.35):
    """K_Runner22_silver / _gold / _blue / _gem: one slab per stair foot (rot4), N flight along -Z, lateral x."""
    clear_piece("K_Runner22_"); clear_piece("R_")
    L = d1 - d0; dc = (d0 + d1) / 2; sil, gold, blue, gem = [], [], [], []
    sil.append(rbox("R_sil", W, h, L, bevel=0.28, segs=3, loc=(0, h / 2, -dc)))
    gold.append(rbox("R_rim", W - 1.1, h + 0.1, L - 1.0, bevel=0.14, segs=2, loc=(0, (h + 0.1) / 2, -dc)))
    blue.append(rbox("R_face", W - 2.1, h + 0.16, L - 1.9, bevel=0.08, segs=2, loc=(0, (h + 0.16) / 2, -dc)))
    # gold Y on the blue face: stem from the foot to 60 %, two arms to the stair end, two side lines
    yt = h + 0.2; ds = d0 + 1.6; dm = d0 + L * 0.6; de = d1 - 1.1
    gold.append(rbox("R_stem", 0.28, yt, dm - ds, bevel=0.06, segs=1, loc=(0, yt / 2, -(ds + dm) / 2)))
    for sx in (-1, 1):
        ax = 1.6 * sx; ln = math.hypot(ax, de - dm); o = rbox(f"R_arm{sx}", 0.28, yt, ln, bevel=0.06, segs=1, loc=(0, yt / 2, 0))
        o.rotation_euler = (0, math.atan2(ax, de - dm), 0); o.location = (ax / 2, 0, -(dm + de) / 2); gold.append(o)
        gold.append(rbox(f"R_side{sx}", 0.22, yt, L - 3.0, bevel=0.05, segs=1, loc=(2.0 * sx, yt / 2, -(dc + 0.3))))
    gem.append(rbox("R_gem", 1.5, h + 0.3, 1.0, bevel=0.45, segs=3, loc=(0, (h + 0.3) / 2, -(d0 + 1.0))))
    out = []
    for nm, lst in (("silver", sil), ("gold", gold), ("blue", blue), ("gem", gem)):
        for o in lst:
            bpy.context.view_layer.update(); o.data.transform(o.matrix_basis); o.matrix_basis = Matrix.Identity(4)
            _shear_up(o, d0, d1, rise)
        out.append(merge_objs(f"K_Runner22_{nm}", lst, rot4=True).name)
    return out

def build_scale22():
    clear_piece("K_Scale22_"); return rbox("K_Scale22_stone", 10.0, 10.0, 10.0, 0.01, 1)

R22_PREFIXES = ("K_Scale22_", "K_Stairs22_", "K_Runner22_")

def build_all22():
    return {"scale": build_scale22().name, "stairs": build_stairs22(), "runner": build_runner22()}

def export_r22(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-22 pieces plus the 10-stud cube."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R22_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]

# ---------------------------------------------------------------- pass 23 (verify20 items 1, 2, 4, 5): 7-riser stairs of long slabs
# with a crisp 0.15 chamfer; a one-piece runner ramp (rounded foot, thick gold rim, big low Y, one gem); a translucent curved fall
# ribbon; the Expeditions gate front (pilasters, archivolt, gold filigree crest, door swirl, lamp posts, crystal basins); the Story
# portal as a silver horseshoe with 7 blue gems. Riser count from the frames: the v20_c4_ref dark bands (442/500/550/600/720) against
# flights projected through the c4 camera on our footprint (d 28-48, rise 6): 7 risers give 475/506/550/616/730 (5 in frame, as in
# the reference), 8 give 6 in frame, 6 give 4. All pieces are authored in Studio coordinates relative to a stated origin, and
# their bbox centres are written to kit/own/ae_kit_r23_centres.json so the placement does not depend on where the import lands.
def build_stairs23(n=7, H=6.0, d0=28.0, run=20.0, lat0=4.3, lat1=17.7, bevel=0.15, tag="Stairs23"):
    """K_Stairs23_stone / _riser: 4 flights (rot4) of n steps of long slabs (joints every ~6.7, offset row to row)."""
    clear_piece(f"K_{tag}_"); clear_piece("Q_")
    tread = run / n; rise = H / n; objs = []; W = lat1 - lat0
    for i in range(n):
        h = rise * (i + 1); dc = d0 + tread * i + tread / 2
        ws = [W / 2, W / 2] if i % 2 == 0 else [W / 4, W / 2, W / 4]
        for s in (-1, 1):
            x = lat0
            for w in ws:
                objs.append(rbox(f"Q_s{i}_{s}_{x:.1f}", w - 0.06, h, tread - 0.04, bevel=bevel, segs=1, loc=(s * (x + w / 2), h / 2, -dc)))
                x += w
    st = merge_objs(f"K_{tag}_stone", objs, rot4=True)
    bm = bmesh.new(); bm.from_mesh(st.data); bm2 = bm.copy()
    def is_riser(f):
        c = f.calc_center_median(); n_ = f.normal
        if abs(n_.y) > 0.3: return False
        if abs(c.x) > abs(c.z): return n_.x * (-math.copysign(1, c.x)) > 0.7
        return n_.z * (-math.copysign(1, c.z)) > 0.7
    bmesh.ops.delete(bm, geom=[f for f in bm.faces if is_riser(f)], context='FACES')
    bmesh.ops.delete(bm2, geom=[f for f in bm2.faces if not is_riser(f)], context='FACES')
    bm.to_mesh(st.data); bm.free()
    me = bpy.data.meshes.new(f"K_{tag}_riser"); bm2.to_mesh(me); bm2.free()
    ob = bpy.data.objects.new(f"K_{tag}_riser", me); coll().objects.link(ob)
    return [st.name, ob.name]

def loft23(name, rings, cap=True):
    """Closed rings (same point count) lofted in order; both end rings capped with a fan."""
    bm = bmesh.new(); vr = [[bm.verts.new(p) for p in r] for r in rings]; k = len(rings[0])
    for a, b in zip(vr, vr[1:]):
        for j in range(k):
            bm.faces.new((a[j], a[(j + 1) % k], b[(j + 1) % k], b[j]))
    if cap:
        for r in (vr[0], vr[-1]):
            c = bm.verts.new(sum((v.co for v in r), Vector()) / k)
            for j in range(k): bm.faces.new((r[j], r[(j + 1) % k], c))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    return mesh_obj(name, bm, False)

def _surf23(d, d0=17.0, dk=28.0, d1=48.4, y0=0.55, yk=0.9, y1=6.35):
    if d <= dk: return y0 + (yk - y0) * max(0.0, d - d0) / (dk - d0)
    return yk + (y1 - yk) * (d - dk) / (d1 - dk)

def _dsamples23(d0, d1, R):
    ds = [d0 + R * (1 - math.cos(math.radians(a))) for a in range(0, 91, 10)]
    ds += [x for x in [28.0] + [float(v) for v in range(int(math.ceil(ds[-1])), int(d1) + 1)] if ds[-1] < x < d1]
    return sorted(set(ds + [d1]))

def runner_layer23(name, W, d0, d1, top_off, bot_mode):
    R = W; rings = []
    for d in _dsamples23(d0, d1, R):
        u = min(1.0, (d - d0) / R); w = max(0.08 * W, W * math.sqrt(max(0.0, 1 - (1 - u) ** 2)))
        t = _surf23(d) + top_off
        if bot_mode == "floor": b = 0.0 if d <= 28.0 else _surf23(d) - 1.4
        else: b = max(0.02, _surf23(d) - 0.35)
        rings.append([(-w, b, -d), (w, b, -d), (w, t, -d), (-w, t, -d)])
    return loft23(name, rings)

def build_runner23(d0=17.0, d1=48.4):
    """K_Runner23_silver / _gold / _blue / _gem: ONE ramp per flight (rot4) from a rounded foot on the floor up the stairs:
    silver 8.6 wide, gold rim band 0.5 wide inside it, blue face, big gold Y low on the ramp, a single cyan gem at the foot."""
    clear_piece("K_Runner23_"); clear_piece("R_")
    sil = [runner_layer23("R_sil", 4.3, d0, d1, 0.0, "floor")]
    gold = [runner_layer23("R_rim", 3.95, d0 + 0.35, d1, 0.08, "in")]
    blue = [runner_layer23("R_face", 3.45, d0 + 0.85, d1 - 0.4, 0.14, "in")]
    def path(pts): return [(x, _surf23(d) + 0.17, -d) for x, d in pts]
    dm = 33.0; ds = d0 + 3.4
    gold.append(tube_along("R_stem", path([(0, ds + k * (dm - ds) / 12) for k in range(13)]), 0.24))
    for sx in (-1, 1):
        gold.append(tube_along(f"R_arm{sx}", path([(sx * 2.55 * k / 12, dm + k * (47.6 - dm) / 12) for k in range(13)]), 0.24))
    gem = [rbox("R_gem", 1.8, 0.55, 1.3, bevel=0.25, segs=2, loc=(0, _surf23(d0 + 2.0) + 0.2, -(d0 + 2.0)))]
    out = []
    for nm, lst in (("silver", sil), ("gold", gold), ("blue", blue), ("gem", gem)):
        out.append(merge_objs(f"K_Runner23_{nm}", lst, rot4=True).name)
    return out

def build_ribbon23(W=6.0, H=40.0, rows=30, cols=8, th=0.15):
    """K_Ribbon23_water: a fall ribbon, top at y 0, front +Z: cupped across (edges back 0.8), lip curling over from z -2.5,
    widening 25 % and swaying slightly as it falls. Two sheets 0.15 apart (front faces +Z, back faces -Z) so it renders from
    both sides."""
    clear_piece("K_Ribbon23_")
    bm = bmesh.new()
    for side in (0, 1):
        g = []
        for j in range(rows + 1):
            t = j / rows; row = []
            for i in range(cols + 1):
                u = -1 + 2 * i / cols; x = u * W / 2 * (1 + 0.25 * t) + 0.5 * math.sin(t * 3 * math.pi) * t
                z = -0.8 * u * u - 2.5 * math.exp(-t * 14) - side * th
                row.append(bm.verts.new((x, -H * t, z)))
            g.append(row)
        for j in range(rows):
            for i in range(cols):
                q = (g[j][i], g[j + 1][i], g[j + 1][i + 1], g[j][i + 1])
                f = bm.faces.new(q); f.normal_update()
                want = 1 if side == 0 else -1
                if f.normal.z * want < 0: f.normal_flip()
    return mesh_obj("K_Ribbon23_water", bm, True, 80).name

def spiral23(cx, cy, z, r0, r1, turns, a0=0.0, n=40, sgn=1):
    return [(cx + (r0 + (r1 - r0) * k / n) * math.cos(a0 + sgn * 2 * math.pi * turns * k / n),
             cy + (r0 + (r1 - r0) * k / n) * math.sin(a0 + sgn * 2 * math.pi * turns * k / n), z) for k in range(n + 1)]

def build_gate23():
    """Expeditions gate front, origin = gate step top centre, front plane z 0, plaza toward -Z (Studio origin (0, 7.0, 84.5)).
    The door (recessed 4.2) spans x +-5.4, y -0.5..18.1 with a round top (centre y 12.7)."""
    clear_piece("K_Gate23_"); clear_piece("G_")
    pale, gold, swirl, dark, glass, basin, water = [], [], [], [], [], [], []
    for x in (-18.4, -7.6, 7.6, 18.4):
        pale.append(rbox(f"G_pil{x}", 1.8, 20.4, 1.2, bevel=0.15, segs=1, loc=(x, 10.6, -0.6)))
        gold.append(rbox(f"G_cap{x}", 2.5, 0.9, 1.7, bevel=0.15, segs=1, loc=(x, 21.2, -0.6)))
        gold.append(rbox(f"G_bas{x}", 2.5, 0.8, 1.7, bevel=0.15, segs=1, loc=(x, 0.4, -0.6)))
    def arc(r, z, n=24):
        return [(-r, 0.0, z)] + [(r * math.cos(math.pi - math.pi * k / n), 12.7 + r * math.sin(math.pi - math.pi * k / n), z) for k in range(n + 1)] + [(r, 0.0, z)]
    pale.append(tube_along("G_archivolt", arc(6.1, -0.35), 0.6))
    gold.append(tube_along("G_archtrim", arc(7.0, -0.3), 0.24))
    for s in (-1, 1):
        gold.append(tube_along(f"G_ogee{s}", [(s * (9.2 - 8.0 * k / 16), 19.6 + 6.6 * (k / 16) ** 1.6 + 0.9 * math.sin(math.pi * k / 16), -0.5) for k in range(17)], 0.22))
        gold.append(tube_along(f"G_scrA{s}", spiral23(s * 3.3, 22.5, -0.5, 2.1, 0.35, 1.5, math.pi / 2, 44, -s), 0.2))
        gold.append(tube_along(f"G_scrB{s}", spiral23(s * 7.0, 21.0, -0.5, 1.3, 0.25, 1.4, math.pi / 2, 34, s), 0.17))
        gold.append(tube_along(f"G_scrC{s}", spiral23(s * 13.0, 20.6, -0.5, 1.6, 0.3, 1.3, math.pi / 2, 36, -s), 0.18))
    fin = lathe("G_fin", [(0, 0), (0.7, 0.0), (0.95, 0.8), (0.35, 1.7), (0.55, 2.5), (0.0, 3.6)], seg=12); fin.location = (0, 25.6, -0.5); gold.append(fin)
    swirl.append(tube_along("G_sw1", spiral23(0.4, 9.5, 3.95, 4.1, 0.4, 2.2, 0.0, 70, 1), 0.36))
    swirl.append(tube_along("G_sw2", spiral23(-2.4, 2.8, 3.95, 1.9, 0.3, 1.3, 1.0, 36, -1), 0.3))
    swirl.append(tube_along("G_sw3", spiral23(2.7, 15.6, 3.95, 1.7, 0.3, 1.3, 2.0, 36, 1), 0.3))
    for x in (-12.5, 12.5):
        o = lathe(f"G_post{x}", [(0, 0), (0.8, 0), (0.8, 0.5), (0.35, 0.8), (0.25, 1.2), (0.25, 7.0), (0.5, 7.2), (0, 7.2)], seg=10); o.location = (x, -0.8, -3.0); dark.append(o)
        o = lathe(f"G_lan{x}", [(0, 7.2), (0.55, 7.3), (0.62, 8.4), (0, 8.5)], seg=6); o.location = (x, -0.8, -3.0); glass.append(o)
        o = lathe(f"G_lcap{x}", [(0, 8.45), (0.8, 8.45), (0.25, 9.3), (0, 9.7)], seg=6); o.location = (x, -0.8, -3.0); gold.append(o)
    for x in (-21.0, 21.0):
        o = lathe(f"G_bowl{x}", [(0, 0), (1.6, 0), (1.6, 0.3), (2.7, 0.9), (2.7, 1.35), (2.3, 1.35), (1.7, 0.75), (0, 0.75)], seg=20); o.location = (x, 4.0, 0.5); basin.append(o)
        o = lathe(f"G_wat{x}", [(0, 0.95), (2.35, 0.95), (2.35, 1.05), (0, 1.05)], seg=20); o.location = (x, 4.0, 0.5); water.append(o)
    out = []
    for nm, lst in (("pale", pale), ("gold", gold), ("swirl", swirl), ("dark", dark), ("glass", glass), ("basin", basin), ("water", water)):
        out.append(merge_objs(f"K_Gate23_{nm}", lst).name)
    return out

def build_portal23(R=7.4, foot=-8.4):
    """Story portal: silver horseshoe band (two 0.75 tubes at r 6.9 / 7.9 = 2.5 wide, 1.5 deep) from -50 to 230 deg with legs to
    the base, a keystone, feet, and 7 blue gems on the front. Built in XY facing +Z, then turned to face +X (Studio origin =
    opening centre (-86.6, 16.0, 0))."""
    clear_piece("K_Portal23_"); clear_piece("P_")
    sil, gem = [], []
    a0, a1 = math.radians(-50), math.radians(230)
    for r in (R - 0.5, R + 0.5):
        pts = [(r * math.cos(a0), foot + 0.6, 0.0)] + [(r * math.cos(a0 + (a1 - a0) * k / 40), r * math.sin(a0 + (a1 - a0) * k / 40), 0.0) for k in range(41)] + [(r * math.cos(a1), foot + 0.6, 0.0)]
        sil.append(tube_along(f"P_band{r}", pts, 0.75))
    sil.append(rbox("P_key", 2.4, 2.8, 2.0, bevel=0.4, segs=2, loc=(0, R + 0.4, 0)))
    for a in (a0, a1):
        sil.append(rbox(f"P_foot{a:.1f}", 3.2, 1.0, 2.2, bevel=0.3, segs=2, loc=(R * math.cos(a), foot + 0.5, 0)))
    for k, ad in enumerate((57, 123, 24, 156, -9, 189)):
        a = math.radians(ad)
        o = rbox(f"P_gem{k}", 1.0, 1.5, 0.7, bevel=0.3, segs=2); o.location = (R * math.cos(a), R * math.sin(a), 0.75); o.rotation_euler = (0, 0, a - math.pi / 2); gem.append(o)
    gem.append(rbox("P_gemKey", 1.3, 1.7, 0.7, bevel=0.35, segs=2, loc=(0, R + 0.4, 1.05)))
    out = []
    for nm, lst in (("silver", sil), ("gem", gem)):
        ob = merge_objs(f"K_Portal23_{nm}", lst); ob.data.transform(Matrix.Rotation(math.radians(90), 4, 'Y')); out.append(ob.name)
    return out

def build_scale23():
    clear_piece("K_Scale23_"); return rbox("K_Scale23_stone", 10.0, 10.0, 10.0, 0.01, 1)

R23_PREFIXES = ("K_Scale23_", "K_Stairs23_", "K_Runner23_", "K_Ribbon23_", "K_Gate23_", "K_Portal23_")

def r23_info(path=None):
    """bbox centres / sizes in authored (= Studio) coordinates and triangle counts of the pass-23 pieces."""
    import json
    info = {}
    for o in bpy.data.objects:
        if o.type == 'MESH' and o.name.startswith(R23_PREFIXES):
            vs = [o.matrix_world @ v.co for v in o.data.vertices]
            lo = [min(v[i] for v in vs) for i in range(3)]; hi = [max(v[i] for v in vs) for i in range(3)]
            if o.get("zup"):  # Z-up data back to authored Y-up: (x, y, z)_b = (x, -z, y)_a
                lo, hi = [lo[0], lo[2], -hi[1]], [hi[0], hi[2], -lo[1]]
            tris = sum(len(p.vertices) - 2 for p in o.data.polygons)
            info[o.name] = {"c": [round((a + b) / 2, 3) for a, b in zip(lo, hi)], "s": [round(b - a, 3) for a, b in zip(lo, hi)], "tris": tris}
    if path: json.dump(info, open(path, "w"), indent=1)
    return info

def build_all23():
    return {"scale": build_scale23().name, "stairs": build_stairs23(), "runner": build_runner23(), "ribbon": build_ribbon23(),
            "gate": build_gate23(), "portal": build_portal23()}

def export_r23(path):
    """Z-up + UVs (new pieces only), then export ONLY the pass-23 pieces plus the 10-stud cube."""
    to_zup_and_uv()
    bpy.ops.object.select_all(action='DESELECT')
    sel = [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(R23_PREFIXES)]
    for o in sel: o.select_set(True)
    bpy.context.view_layer.objects.active = sel[0]
    bpy.ops.export_scene.fbx(filepath=path, use_selection=True, object_types={'MESH'}, apply_unit_scale=True,
                             mesh_smooth_type='FACE', use_mesh_modifiers=True, axis_forward='-Z', axis_up='Y')
    return [o.name for o in sel]
