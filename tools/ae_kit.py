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
