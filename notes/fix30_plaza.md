# Fix pass 30: Anime Expeditions spawn plaza (froth jets on the drum, gold Summon face, blue W canopy and deep lagoon, dark Story ring with horseshoe crest, greener islands)

Builder report for `notes/fix_brief30.md`, answering the round-27 review `notes/verify27_plaza.md` (9.00/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...`, reference studio `97946bf6-...` (not used: the full-size v27 frames were
enough). **No kit this pass:** everything is Studio-side (Parts, SpecialMesh ellipsoids and clones of our own kit pieces), so no
Import 3D was needed. About 80 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 Fountain jets | Done (Studio). The whole pass-29 jet (column, glossy cap ball, froth ball, emitter, light) is hidden/disabled. **The pass-29 jet floated:** its raycast found the back ledge, not the drum, so the burst stood 3 studs above the water. The new jet starts on the `Pass9.DrumWater` surface: a 0.8 x 2.5 column (200,240,250) T 0.35, a faint Neon core (T 0.6), 6 flaring curved sheets (ellipsoids, 25 deg out) (160,228,248), 9 cyan froth puffs (135,218,245) T 0.45 round the column, a dome and a foam disc on the drum, spray at Rate 60 (twice pass 29) and a cyan PointLight. |
| 2 Summon facade | Done (Studio). Face (cream K_Summon9 and every cream Colonnade17 part) (215,195,130); pilasters, capitals, cornice bands, keys, dome band and K_Summon9 gold (200,160,70) Metal. Windows rebuilt larger (glass 4.2-4.4 wide) with gold frames 1 stud wide, mullion and transom; 6 new tall upper-storey windows at y 31-39 (the pass-29 ones sat behind the entablature). Medallion 5 studs. Bunting cut to the one cord at z -72 (46 cords/pennants hidden). |
| 3 W lagoon and lawn | Done except the lawn retint. Lagoon (22,58,118) (renders about 2x brighter, see below) with a (55,125,185) rim and sand bank, 3 extra lobes for an irregular ~80 x 50 shore. 148 own `K_FluffyS_leaf` clumps in 4 blues around (40,90,220) on a jittered 11-stud grid over the open W lawn (skipping the lagoon, the Story corridor and anything taller than the ground). Near palm SA tints darkened: (187,223,79) -> **(132,196,70)** vs (131,192,83). The S lawn retint was skipped: GroundS is one 1700 x 800 part that every camera sees, and pass 28 found its blue is haze. |
| 4 Islands and falls | Part. Isl24_4 pads (205,232,95), island grass (140,195,75), Isl27 lumps and the IslFringe25 leaves greener: c3 island (122,150,133) -> **(158,179,120)** vs (169,192,129). All 9 existing falls Neon (215,238,250) T 0.5, at least 4.5 wide; 4 new falls (36-50 long) hung from the lip of Isl24_4 and NorthIsl22 (raycast march), each with a lip and a foam puff. The very white vertical bars in c3/c4 are the old `Pass23.Fall23.Ribbon23` (190,250,255) T 0.15, unchanged. |
| 5 Story portal | Done (Parts). Rim (50,75,120): p4 rim (117,145,198) -> **(39,63,118)** vs (44,68,113). Pass-29 disc crest hidden; a horseshoe of 15 gold (200,170,60) Metal blocks on an arc (R 2.5, open 110 deg at the bottom, about 6 wide) with a blue (40,70,160) inset arc, heel caps and a blue Neon gem, heels on the ring top. Inner band (30,45,90), opening (6,12,28). No glow plane (the reference inside is darker than ours, (0,9,18)). |
| 6 Orb / gate | Gate only: `Gate23_swirl` Neon (4,92,102) T 0.3: p2 (33,119,147) -> (15,122,155) vs (7,149,163); p6 (35,121,150) -> (8,128,161) vs (1,108,120). Orb not moved (raising it would crop it further at the top of p6). No crystal basins. |
| 7 Bollards | Base (240,239,230) -> (222,223,215) with two gold (200,175,60) trim bands. p1 (248,247,242) -> (242,241,233) vs (230,231,223). Arch bevel not done. |
| 8 Foliage | c1 red clump Fern26 (160,58,54): (250,90,94) -> (239,87,83) vs (226,92,90). Palms, gold tree and the c2 fern not done (palms would push c4 saturation further over). |
| 9-10 | Not attempted (Boss Rush light/sign/spires, props). |

## Captures
- **Final set:** `out/r30/r30_<cam>.png`, all 12 at full size **1284 x 793** (second frame of `capture_set2.py`). Contact sheet `out/r30/contact.jpg` (v27 reference left, r30 right).
- **Baseline:** pass-29 state in `out/r30w/base/`. Working sets `out/r30w/a`-`d`; zoom pairs `out/r30w/z_*.jpg`.
- **Tools (`out/r30w/`):** `run.sh` (runs `fix/pass30.lua`), `lrun.sh <lua>`, `some.sh <tag> <cams>`, `run_cap.sh` (final set), `metrics.py <tag> [dir]` (saturation, boxes, contact sheet), `fixT.lua` (one-off), `count.lua`. Picks use `out/r29w/pick.py`.

## Results
**Top-half mean HSV saturation** (ref = v27 judged frames, base = pass 29 here):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref | 82 | 99 | 102 | 110 | 91 | 116 | 88 | 105 | 94 | 110 | 91 | 80 |
| base | 82 | 93 | 90 | 104 | 95 | 99 | 73 | 84 | 103 | 103 | 97 | 92 |
| **r30** | **83** | **93** | **93** | **105** | **97** | **101** | **76** | **91** | **103** | **104** | **97** | **93** |

p8 gap -21 -> -14, p7 -15 -> -12, p6 -17 -> -15, p3 -12 -> -9. Pixels changed > 30 levels vs base: p8 14.5 %, p7 8.9 %, c3 5.9 %, p5 4.1 %, c1 3.8 %, p3 3.7 %, c2 3.4 %, p1/c4 3.1 %, p6 3.0 %, p4 2.2 %, p2 1.6 %.

**Boxes (5x5 means):**

| box | ref | base | r30 |
|---|---|---|---|
| c1 jet 640,420 | (214,245,250) | (109,176,198) | (236,253,254) |
| c4 face 640,375 | (222,214,140) | (176,176,137) | (204,183,107) |
| p4 rim 600,330 | (44,68,113) | (117,145,198) | **(39,63,118)** |
| p7 palm 250,420 | (131,192,83) | (187,223,79) | **(132,196,70)** |
| c3 island 60,140 | (169,192,129) | (122,150,133) | (158,179,120) |
| p1 bollard | (230,231,223) | (248,247,242) | (242,241,233) |
| c1 red | (226,92,90) | (250,90,94) | (239,87,83) |
| p2 gate | (7,149,163) | (33,119,147) | (15,122,155) |
| c4 tread (a 9.5) | (191,192,189) | (189,196,189) | (189,196,189) unchanged |

The c4 "face2" box (590,340) lands on the kept bunting strand in our frame; the p7 "lagoon" box (260,250) lands on a blue palm crown above the lagoon (pick), so neither measures what its name says.

## What I measured / proved
- **The pass-29 jet floated.** A zoom pair showed the burst 3 studs above the drum: pass 29 raycast down from y 8.6 and hit the back ledge. The drum water is `Pass9.DrumWater` (a disc at y 4.1, within 0.6 of the jet x/z); the new jet is placed on it.
- **Ball parts are always spheres.** Pass 29's "2.6 x 1.6 cap" rendered as a glossy sphere for this reason. Ellipsoids (sheets, puffs, foam) need a SpecialMesh with MeshType Sphere, which follows Size.
- **Water renders about 2x brighter than set from above.** Lagoon (40,95,170) rendered (67,133,211) in p8; set to (22,58,118) / deep (15,42,95) it renders (67,121,199). Sun on SmoothPlastic at a steep angle.
- **Bunting projection:** 3 cords at z -72/-98/-124, y 17. From the c4 camera they project at 13.2/8.6/5.9 degrees; the facade top is at 13.6 and the windows at 6.3. The z -72 cord sits at the facade top, so it is the one kept.
- **Story ring owner:** p4 600,330 = `Pass23.Portal23.Portal23_silver`; 640,350 = `Pass14.StoryOpening14`; the crest = `Pass29.Story29.Crest*`.
- **Island owners (c3):** 60,140 = `Isl24_4` K_Soft14C_leafPad; 100,180 = `NorthIsl22` K_Isl92_rock; 150,200 = `Isl27_lump`. The white bars = `Pass23.Fall23.Ribbon23`.
- **Lawn owner:** the W/S lawn is `GroundW` / `GroundS` (one huge part each), so a lawn retint is a global colour change; skipped.
- **Idempotence:** a second run of pass 30 gives the same report and the same descendant count (18390).

## Built (method)
`fix/pass30.lua`: idempotent, runs after pass 29. Every touched part keeps its old value in a P30* attribute (Col/Mat, T/CC/CQ + Hidden, CF, Size, plus **P30Tx** for transparency-only changes, **P30En** for emitters/lights it disables and **P30SA** for SurfaceAppearance tints); all are restored first. New pieces go in `Plaza.Pass30` (Jet30, Summon30, West30, Isl30, Story30, Extra30). Blocks:
- **JET30:** per Jet29 column: base y from the nearest DrumWater; column + Neon core cylinders; 6 sheets `CFrame.new(top + r(cos a, -0.5, sin a)) * Angles(0,-a,0) * Angles(0,0,-25deg)`; 9 puffs at random height h with radius 0.4 + 0.5 h/H (seeded per jet); dome, foam disc, emitter on an Attachment, PointLight.
- **SUMMON30:** recolour by name (gold set) and by HSV (cream: s < 0.3, v > 0.85, hue 0.05-0.2); `win(x, z, w, y0, h, fw)` builds glass rectangle + cylinder arch in front of a gold rectangle + cylinder fw larger, with mullion and transom.
- **WEST30:** lagoon lobes are cylinders with the lagoon's rotation; plan sizes swapped if the cylinder's local Y is world Z. Rim at -0.03, sand at -0.06, lobe water at -0.012 (below the deep disc, no z-fight). Canopy: jittered grid, `Random.new(30)`, a down-ray from y 80 must hit something lower than y 9.5 (ground), clump 0.55-0.95 scale sunk 1.5 + k.
- **ISL30:** recolour by name inside the two island models; falls by name; `lipFall(model, x, len, w)` marches z across the model's bounding box with downward rays (CanQuery temporarily on for the model's visible parts) and hangs the fall from the last hit.
- **STORY30:** horseshoe blocks with `CFrame.lookAt(p, p + tangent, Vector3.xAxis)` along an arc in the y-z plane (the ring faces +x).
- **EXTRA30:** gate Neon, bollard base + 2 trim bands per base (block CFrame copied from the base), Fern26 tint.

## Lessons (for the workflow vault)
1. **Zoom before you retint.** The jet's problem was not colour: it was 3 studs too high. A 4x zoom pair (reference crop next to practice crop) shows placement errors that box colours and saturation never will.
2. **A Ball part is always a sphere.** For a squashed dome, petal or froth puff, use a Part with a SpecialMesh (MeshType Sphere); the mesh follows Size.
3. **Water seen from above renders far brighter than its colour.** Set lagoon colours at about half the target and measure in the top view.
4. **Cover a lawn instead of retinting it.** When the lawn is one huge part every camera sees, scatter your own clumps over the region that needs colour (seeded jittered grid, ground-only raycast, skip zones). p8 saturation +7 with no other camera hurt.
5. **Project before you cut.** To pick which bunting strand stays, compute each cord's elevation angle from the camera and compare it with the facade's top and window heights.
6. **Every reversible change needs its own attribute.** Transparency-only changes, disabled emitters and SurfaceAppearance tints each got their own (P30Tx, P30En, P30SA). The first run set two transparencies without one, and they had to be reset by hand (`out/r30w/fixT.lua`) before the restore could be trusted.

## Objects built (for 5 Object Recipes)
- **Froth fountain jet:** column 0.8 x 2.5 T 0.35 (200,240,250) + Neon core T 0.6, 6 ellipsoid sheets 0.2 x 2.4 x 1.6 flaring 25 deg on a 0.9 ring, 9 cyan puffs 1.1-1.7 T 0.45 spiralling out with height, a 2.6 x 1.1 dome, a 3.6 x 0.4 foam disc on the water, spray at Rate 60 (size 0.6 -> 1.7), cyan PointLight range 9.
- **Gold-framed arched window (`win`):** glass rectangle + cylinder arch (60,100,200), gold frame 1 stud wide all round (rectangle + cylinder), gold mullion and transom 0.35.
- **Parts horseshoe crest:** 15 blocks along an arc R 2.5 from -35 to 215 deg (open at the bottom), 0.7 deep x 1.3 thick, gold Metal; a 0.55 blue inset arc in front; heel caps; Neon gem at the centre.
- **Canopy scatter:** own K_FluffyS_leaf at 0.55-0.95 scale in 4 blues on a jittered 11-stud grid; ground-only down-ray; skip ellipses for water and corridors.
- **Irregular lagoon:** 4 overlapping cylinder discs (water), each with a rim disc +6 and a sand disc +15, stacked 0.03 apart.
- **Lip waterfall:** a Neon (215,238,250) T 0.5 slab 4-4.5 wide hung from the last raycast hit along the island edge, a lip block and a foam ellipsoid at the foot.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **18390** (pass 29: 17942). Workspace holds only Camera, Terrain, SpawnLocation and Plaza.
- Nothing was saved or committed. No kit exported; `ae_kit.blend` and `fix/build_plaza.lua` untouched. `fix_lighting.lua` not re-run (no lighting change). Technology, post effects and Atmosphere unchanged; Haze not tested.
- **How to rebuild:** on the pass-29 build, run `sh out/r30w/run.sh`. It is idempotent.

## Reference use
- No capture of the reference studio: the round-27 frames in `out/verify27/` were used for every target. No execute_luau in the reference, no position reads. `ae_reference.blend` not opened. No computer use. Own meshes and Parts only.

## Next
- Jets: still a little too white at the c1 box (236,253,254) vs (214,245,250). Try puffs T 0.5 and a dimmer dome.
- Summon: the face is warmer but still lighter than the reference's gold-olive; the facade is small at c4 range.
- Falls: the old `Ribbon23` bars read as opaque white pillars in c3/c4. Make them T 0.4, or replace them with the lip falls.
- Islands: the undersides are still grey rock where the reference is leafy with ivy.
- Not done: orb in open sky (p6), crystal basins, arch bevel, palm/gold-tree/fern tints, Boss Rush finish, props, S lawn.
