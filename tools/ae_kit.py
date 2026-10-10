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
