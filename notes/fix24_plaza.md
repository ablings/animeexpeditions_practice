# Fix pass 24: Anime Expeditions spawn plaza (near sky islands and giant tree, E red carpet, Raid red rock, jointed stair blocks, outlined runner Y and teardrop gem)

Builder report for `notes/fix_brief24.md`, answering the round-21 review `notes/verify21_plaza.md` (8.33/10).

**Status by review item**

| Item | Status |
|---|---|
| 1 Sky | Done: 5 near islands (kit `K_Isl77x`) N and S, plus a new giant tree `K_Tree24` behind the Expeditions gate. p2 top-half saturation is down from 127 to 111 (ref 101). c4 only from 121 to 116 (ref 89). |
| 2 Ground | E red carpet with a grey path; lime discs (`GrassHole18/19`) hidden; W lagoons hidden; S lawn darker (LeafyGrass). |
| 3 Raid | Skull, facade and towers are red rock; red glow round the facade; 3 rock spires. The pass-23/round-21 discrepancy is settled (see below). |
| 4 Stairs | Done: new kit `K_Stairs24`, still 7 risers. Blocks are ~4.5 studs with 0.2 gaps and a 0.18 chamfer over a dark joint slab. Flat SmoothPlastic tread with no mottled texture. |
| 5 Runner | Done: an outlined Y in the middle third (`K_RunY24`, gold lines round a dark-blue core) and a round cyan gem in a gold teardrop (`K_Gem24`). The rim is unchanged (`K_Runner24_gold`). |
| 10 (part) Tunnel | Fill light lifted. |
| 6, 7, 8, 9, rest of 10 | Not attempted (time box). |

**Captures**
- Final set: `out/r24/r24_<cam>.png` (capture_set2.py, second frame kept). Contact sheet: `out/r24/contact.jpg` (v21 ref left, r24 right).
- Working frames are in `out/r24w/<letter>_<cam>.png`: `a_` is the baseline, `b_`-`e_` are Studio-only steps, and `f_`/`g_` come after the kit import.
- Tools (`out/r24w/`):
  - `box24.py`: v21 boxes, with targets re-sampled from `v21_<cam>_ref.jpg` on every run, plus saturation and W-blue/E-green/E-red metrics.
  - `cap.sh`: two captures, judges the second.
  - `run.sh`: runs `fix/pass24.lua`.
  - `lrun.sh`: runs any Lua file in the practice studio.
  - `lua/q_*.lua`: read-only queries of the practice place.
- `out/r22w/pick.py` was used for picks.

**Rules kept**
- Pictures only: every target was re-sampled from the v21 reference frames. The reference studio was not touched at all, not even by screen_capture.
- Own geometry only, no computer use. The place was not saved and nothing was committed. `ae_kit.blend` was saved before and after the export.

**State at the end**
- `#workspace.Plaza:GetDescendants()` = **17338** (17217 after pass 23, plus the `Pass24` folder and its pieces).
- Workspace holds only **Camera, Terrain, SpawnLocation, Plaza**.
- The header of `pass24.lua` merged `ae_kit_r24` into `ServerStorage.Kit` (11 meshes in; the scale cube was destroyed).
- Atmosphere, Technology and post effects are unchanged.

**How to rebuild** (on the pass-23 build with `ae_kit_r24` imported): `sh out/r24w/run.sh`.
- Idempotent: every touched piece is restored from its `P24*` attributes first (hidden parts, colours/materials, lights).
- Blocks: `--SKY24`, `--GROUND24`, `--RAID24`, `--STAIR24`, `--RUN24`, `--TUNNEL24`. Each kit block has a Studio-only fallback.
- `fix/build_plaza.lua` has r24 in `IMPORTS`.

## Results (final set `out/r24`, 5x5 means, max channel difference against the v21 reference box)

| box | v21 practice | r24 | target (v21 ref) |
|---|---|---|---|
| p3 skull (rep 723,46 / ref 720,40) | 61 | **15** | (207,108,93) |
| p3 Raid glow, same box (600,220) | 135 (dark tower dome) | **6** | (226,124,111) |
| p3 haze, review rep box (640,150) | 21 | 14 | (226,124,111) |
| c3 Raid tower (rep 1330,300 / ref 1350,280) | 68 | **12** | (176,77,62) |
| p8 E ground | 81 (green lawn) | **9** | (194,82,75) |
| p7 S lawn | 55 | 30 (B stays 84, see Lessons) | (92,123,54) |
| c4 tread | 7 | 7 (now flat, not mottled) | (186,191,185) |
| c4 bevel/joint (430,640) | 19 | **6** | (99,113,122) |
| c4 runner Y gold (on the new Y line, 684-688,698-702) | 61 (old Y arm) | **29** (183,172,60): R, G match, B low | (183,175,89) |
| c1 tunnel | 26 | 14 | (44,54,62) |
| p1 band (620,30) | 72 (clean sky) | **41** (now the N island underside) | (176,202,164) |

The review's c4 "gold" box (700,620) now lands on the blue face beside the new, narrower Y. The Y line itself was measured instead. p1 "fall" (739,125) now lands on the new N island, not the old fall.

Coverage (my metric in `box24.py`; thresholds differ a little from the review's):

| metric | ref | v21 practice | r24 |
|---|---|---|---|
| p8 E red | 48.7 | 33.8 | 56.7 |
| p8 E green | 4.4 | 16.1 | 7.0 |
| p8 W blue | 44.4 | 52.8 | 45.3 |
| p7 E red | 23.5 | 17.0 | 37.5 |
| p7 E green | 26.5 | 26.0 | 9.2 |
| p7 W blue | 14.3 | 27.8 | 25.9 |

- **E red:** now over the reference, especially in p7.
- **W:** p8 is matched; p7 is still bluish from the W trees.

Top-half saturation (rep / ref):

| cam | ref | v21 practice | r24 |
|---|---|---|---|
| p1 | 85 | 101 | 96 |
| p2 | 101 | 127 | 111 |
| p3 | 102 | 106 | 112 |
| p4 | 108 | 119 | 120 |
| p5 | 93 | 99 | 104 |
| p6 | 111 | 117 | 108 |
| p7 | 88 | 85 | 85 |
| p8 | 102 | 95 | 95 |
| c1 | 97 | 108 | 115 |
| c2 | 106 | 114 | 117 |
| c3 | 95 | 94 | 88 |
| c4 | 89 | 121 | 116 |

12-camera mean |rep - ref|: 11.1 -> 11.0. Mean signed: +9.3 -> +7.6. Gains on p1, p2, p6 and c4; p3 (red glow) and c1 rose.

## Raid discrepancy (brief: settle on two captures)
Both captures were measured, and picks were done from the practice camera.
- **Skull.** The v21 box (721-725, 44-48) is 6 px below the v20 box. It lands on a shaded, down-facing strip of `K_Skull15_bone` between the dark brows, which rendered (147,107,104). The lit forehead 10 px higher rendered (240,195,160). Pass 23's "8 off" was the lit forehead on the v20 box. Both are the same pale-tan bone, which is far from the reference's red skull. Fix: bone (185,105,85) SmoothPlastic, skull light b 5. (255,118,92) with b 8 overshot to R 249.
- **Tower.** Pass 23 recoloured `RaidGable`, the red stripe. The review moved its box off the stripe onto the brown brick `RaidFacadeCap` / `RaidFacade` (88,47,56), which pass 23 never touched. Fix: `RaidFacade`, `RaidFacadeCap` and the `K_RTower7` stone/dome/darkStone recoloured to Slate (165,48,20).
- **Haze.** The review's practice box (640,150) is open sky, where pass 23's particle band flickers (21 to 66 off between runs). The like-for-like box is the reference box (600,220). In practice that box was the dark `K_RTower7` dome. The glow blobs now cover it: 6 off.

## 1. Sky (`--SKY24`)
- **Islands.** Five slab islands from the pass-7 kit, placed by **grass-cap top** (the first try used the bbox top, which is the ruin tower, and they sat 50 studs low), turned to face the plaza.
  - S: `K_Isl771` (-75,125,215) x1.35; `K_Isl772` (105,140,255) x1.35; `K_Isl773` (10,190,320) x1.4.
  - N: `K_Isl772` (0,150,-215) x1.6; `K_Isl771` (-135,175,-270) x1.3.
  - Rock is Slate (170,168,158), grass is Grass (120,165,80), vines (95,150,70). There are two green kit soft trees on each cap, and no shadows.
  - The heights were chosen by projecting through the camera: the c4 underside lands at about row 210 and the top at row 64, as in the reference.
- **N falls.** The N kit fall dropped straight down the c4 centre line in front of Summon, so it is hidden. Two pass-23 ribbons (55 tall, T 0.25) now hang at x -38 / +30 under the N island.
- **Giant tree.** `K_Tree24` at (-24, 4, 118), behind and left of the gate. Bark is (120,98,82); crown (70,150,140), rim (110,185,165). No shadows: its shadow had darkened the gate door (13 to 30 off) and the S lawn box.

## 2. Ground (`--GROUND24`)
- **Carpet.** SmoothPlastic (155,55,35) under everything E of the plaza: x 75-245 / z -110..25 and x 54-76 / z -110..20. The p8 reference has red at the plaza edge on the N half and a green band on the S half.
  - A first, larger version also covered the SE (to z 95). That pushed p8 E red to 68 % and p7 to 45 %, so it was cut back.
- **Path.** A dark Slate band (100,100,96), 90 x 26 at y 6.42, along the E axis (the reference's wide cobble path).
- **Patches.** Grass patches inside the carpet zone were recoloured to carpet red. All 102 `GrassHole18/19` lime discs are hidden.
- **W.** `Lagoon11` x3, `Lagoon16` and `LagoonDeep16` hidden: p8 W blue went from 52.8 to 45.3 (ref 44.4).
- **S lawn.** `GroundS` set to LeafyGrass (42,57,0). Grass (46,74,10) gave (96,140,87); SmoothPlastic (70,100,15) gave (109,180,121).

## 3. Raid (`--RAID24`)
- Bone and tower as above.
- **Glow.** Five translucent sphere-mesh blobs (240,135,115), T 0.45, 2 thick, at x 136-140 either side of the door and up the towers. The first colour, (240,110,95), read 21 off (G low).
- **Spires.** Three kit spires (`K_Spire`) x2.7-3.6, red rock (150,44,34) Slate, leaning, behind the facade.

## 4. Stairs (`--STAIR24`, kit `K_Stairs24`)
- Same footprint as pass 23 (7 risers, d 28-48, rise 6).
- Rows alternate [W/3 x3] and [W/6, W/3, W/3, W/6] (blocks ~4.5), with 0.2 gaps and a 0.18 one-segment chamfer.
- Joint slab (85,95,105): its top is 0.12 below each tread, so it only shows in the gaps. The first colour, (60,70,80), made the bevel box 41 off; (85,95,105) gives 6.
- Tread (126,129,125) SmoothPlastic renders (193,198,187), 7 off.

## 5. Runner (`--RUN24`, kits `K_Runner24` / `K_RunY24` / `K_Gem24`)
- `K_Runner23_gold` (rim + old Y) and `K_Runner23_gem` are hidden. The rim is now `K_Runner24_gold`, in the same colour.
- **Y.** Stem d 26-33.6; arms to (±2.9, 38.2); stroke 0.9; outline tube r 0.15 at surface + 0.2; core (25,40,110).
- **Gold.** SmoothPlastic (108,101,25) rendered (184,172,32). With (108,101,44) it renders (183,172,60), 29 off, all in B.
- **Gem.** A teardrop at d 20.6 (circle r 0.8, tip 1.75 up the ramp) with a gold tube and bed, and a lathed dome gem r 0.55, Neon (90,220,240) T 0.15.

## 6. Tunnel (`--TUNNEL24`)
`TunnelFill22` lights set to (160,170,165), b 1.6, r 10 (pass 23 left b 0.45). Error went from 26 to 14; the remaining gap is blue (67 against 62).

## Lessons (for the workflow vault)
1. **Before calling two measurements a contradiction, check that the boxes are the same pixel.** The Raid skull difference came from a box 6 px lower, on a shaded strip. The tower difference was a different part (brick cap, not the red gable). Pick the part under each box first.
2. **Place a mesh by the feature that matters, not by its bbox.** Island tops placed by bbox sat 50 studs low because the ruin tower is the highest point. Anchor on the grass cap.
3. **Big scenery casts big shadows.** The giant tree's crown shadowed the gate door and the S lawn, and two "colour" boxes got worse with no colour change. Turn off CastShadow on background pieces, or re-check the boxes it can shade.
4. **One fill polygon cannot drape over a bent surface.** The Y core, triangulated as one polygon across the ramp's slope break, cut chords up to 1.4 studs above the surface and hid the gold outline. Build draped decals as dense ribbons (every 0.4 stud) that sample the surface height.
5. **Two views can disagree on coverage.** From the top (p8) the E reads red; from the oblique p7 its near SE reads green, because the reference's grass blades hide the red ground at that angle. Fit the region to both views (red N half, green band on the SE) instead of one metric.
6. **A blue channel that doesn't move is sky light, not paint.** The S lawn B stayed at about 84-87 for Grass, LeafyGrass and SmoothPlastic, whatever the colour. Only R and G can be matched with colour. The rest needs light or geometry (shade, taller grass).
7. **Kit reuse is fast for background mass.** Five scaled kit islands took one block and no import. The time went to the pieces that are new shapes (tree, joints, Y), which is where Blender earns its place.
8. **A geometry change can move a review box off its feature.** The new, narrower Y moved off the review's c4 gold box, so the box now reads the blue face. Re-pick a box on the same feature before reading the number.

## Objects built (for 5 Object Recipes)

### Giant tree (`tools/ae_kit.py`: `build_tree24`)
- **Trunk.** Lofted from 41 rings of 20 points (`loft23`). Radius = 5.0 + 1.4(1-t) + 3.1e^(-9t), giving ~19 across at the foot and ~13 at mid-height. Five root flares: `max(0, cos 5a)^3 * 0.55e^(-14t)`. S-lean: x = 6 sin(0.9πt)·t, z = -4t². Twist of 1.6 rad. Height 86.
- **Limbs.** Three limbs from y 62/67/72, 20-26 long, radius 2.8 down to 1.1, lofted on rings built in the limb frame.
- **Crown.** At each limb tip and the top, 4-5 icospheres (subdivision 3, r 7-11, squashed 0.72 in y, jittered ±12 %), plus a rim shell (subdivision 2, 1.06x, raised 0.3r) on every second lump.
- **Triangles.** Bark 2,420; crown 5,440; rim 720.
- **Studio.** Origin = trunk foot (-24, 4, 118). Bark (120,98,82), crown (70,150,140), rim (110,185,165), SmoothPlastic, no shadows.

### Jointed stair blocks (`build_stairs24`)
- The pass-23 7-riser footprint, rot4. Each row is `rbox` blocks of W/3 (4.47), with offset rows W/6 + W/3 + W/3 + W/6, 0.2 gaps and a 0.18 chamfer.
- Risers are split off by face normal (as in pass 23).
- Joint slab: one thin-bevel box per row and side, top 0.12 below the tread.
- **Triangles.** Stone 7,296; riser 1,152; joint 2,464.
- **Studio.** Tread SmoothPlastic (126,129,125); joint (85,95,105); riser keeps the pass-23 colour.

### Outlined runner Y (`build_runner24`, `_youtline24`, `_densify24`)
- **Outline.** A Y outline computed in (x, d). The stem's edge meets the arm's outer edge at J; the arms' inner edges meet at the crotch C. The outline is densified every 0.4 and draped on `_surf23(d)` + 0.2 as a closed tube of r 0.15.
- **Core.** Three ribbons (stem and two arms), 0.9 wide, sampled every 0.4 on the surface + 0.17.
- **Triangles.** Gold 5,808; core 360.
- **Studio.** Gold SmoothPlastic (108,101,44); core (25,40,110).

### Teardrop gem setting (`build_runner24`)
- The lower part of a circle (r 0.8), plus a tip 1.75 up the ramp, as a tube (r 0.18) and a flat bed. Gem: a lathed dome, r 0.55, 0.5 high. rot4.
- **Studio.** Gold as the Y; gem Neon (90,220,240), T 0.15.

### Near sky islands (Studio, kit `K_Isl77x`)
- Placed with the grass-cap top centre at the target point, turned to face the plaza, scale 1.3-1.6.
- Rock Slate (170,168,158), grass (120,165,80), vine (95,150,70). Two green soft trees on each cap. No shadows.
- N islands: the kit fall is hidden; two ribbon falls are set off the camera centre line.

### Raid red rock (Studio)
- Facade, cap and round towers are Slate (165,48,20).
- Glow: five sphere-mesh blobs (240,135,115), T 0.45.
- Spires: three `K_Spire` x2.7-3.6, red rock (150,44,34), leaning.

### E red carpet (Studio)
- Carpet parts SmoothPlastic (155,55,35) at y 6.08, under the patches. Grass patches inside the zone are recoloured to match.
- A Slate path band (100,100,96) at y 6.42. Lime discs are hidden.

## Files
- `fix/pass24.lua` (new), `fix/build_plaza.lua` (r24 in `IMPORTS`).
- `tools/ae_kit.py`: pass-24 section (`build_tree24`, `build_stairs24`, `_youtline24`, `_densify24`, `_flat24`, `build_runner24`, `build_scale24`, `r24_info`, `build_all24`, `export_r24`).
- `kit/own/ae_kit_r24.fbx` (12 meshes including the scale cube; largest 7,296 triangles) and `kit/own/ae_kit_r24_centres.json`. `ae_kit.blend` saved.
- `out/r24/` (set and contact sheet), `out/r24w/` (tools and working frames).

## Next (not done)
- c4 sky is still 116 against 89. The reference's N island is greener and nearer, with foliage hanging below it; add canopy and vines under the N island.
- E red overshoots in p7: add green tufts or tall grass blades on the SE carpet edge.
- Items 6-9: gate glazing, Summon/Boss Rush facades, bollards, layered falls.
