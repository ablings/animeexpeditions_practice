# Fix pass 36: Anime Expeditions spawn plaza (light arch shoulder band, branched notch-tree crowns, Expeditions orb/pillars/portal, Raid beam and recesses, softer falls)

Builder report for `notes/fix_brief36.md`, answering the round-33 review `notes/verify33_plaza.md` (9.42/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`). The reference studio `97946bf6-...` was not captured:
the full-size v33 frames were enough. **No kit this pass** (all Studio-side). About 80 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 Arch outer band | **Band done; arm and face not changed.** A red Neon tint on `Pass20.K_Arch20_slate` showed that it is the whole band between the gold pipes on every arch, in c1, c2, p1, p3 and p5 (`out/r36w/tint_sheet.jpg`). It went from Slate (30,37,43) to SmoothPlastic **(112,116,122)**. c1 (340,300) (41,51,59) -> **(148,154,159)** vs ref (178,170,168). (95,105,118) gave (123,139,158), too blue; (122,125,130) gave (161,164,169) but read too pale in p5. **The other boxes do not move:** c2 (560,200), p1 (150,330), p3 (150,330), p5 (560,330) and c1 (500,300) are all on `K_Arch20_stone` (the U arm/crown). **Neon stone test:** Neon (80,82,85) renders as a flat (82-94) on every face. That fixed c2 (40 -> 82, ref 100) and p1 (56 -> 83, ref 83), and helped c1 (500,300) (88 -> 82) and p5 (100 -> 94). But the arch read as an unshaded cut-out: the inner band and the U depth disappeared (`out/r36w/t_arch2.jpg`). So it was reverted, and the stone stays (72,78,84). The wider ledge and narrower U arm need a K_Arch20 rework (kit), which was not done this pass. |
| 2 Bare notch-tree poles | Done. Each `Trunk34` is cut to y 23.5, inside its crown. Three 0.5-wide branch arms rise from 55 % height, each ending 1.2 inside a ~3.8 clump of own `K_FluffyS_leaf` (36,78,195)/(60,108,210). Six more clumps cover the trunk: four on the plaza-facing side at 3 heights plus one above the top, one at the crown top and one outward. In total there are 36 clumps and 12 arms over the 4 trees. p3 (205,120) (60,51,55) -> **(28,67,189)** vs (21,69,204). c3 (630,250) is no longer trunk: (103,83,72) -> (117,131,169), sky/clump edge, vs ref (47,114,240). Our crown sits higher than the ref's, so that pixel is above it. c1 (640,120) is unchanged (112,129,157): the top-centre gap stays open. |
| 3 p2 orb, pillars, portal | Done, with one deviation. **Orb:** the brief asked to raise it 8. But the v33 frames show the ref core at about (708,167) and ours at (685,125): ours is already *higher*. So `Landmarks.K_ExpRing8` is moved (-3,-5,0), and the core now sits where the ref's is. The core stays a near-white Neon (235,245,250) at T 0.1. A SmoothPlastic (190,214,226) at T 0.35 vanished against the sky; the ref core is white too, and the brief's (680,130) box is beside the core in the ref. **Pillars:** `K_Trip10_glass` Glass (60,170,170) -> SmoothPlastic (70,82,90) at T 0.2: (87,226,242) -> **(125,148,171)** vs (106,123,131). **Portal:** the Swirl32/SwirlCore32/Portal31/PortalArch31 colours are scaled by 0.85 (45 parts). p2 (640,330) (12,143,157) -> (14,102,116) vs (4,115,129); p6 (60,300) (11,128,149) -> (14,95,114) vs (1,81,93). A 0.65 scale lost the swirl. **(720,200):** this is the low south island fringe (`Sky25.IslFringe25`). Hiding it gave (158,182,185) vs sky (187,209,214), but it exposed a flat grey island underside across p2 and p6, so it stays (`FRINGE_HIDE = false`). |
| 4 Raid | Beam and recesses done; the door was not changed. **Beam:** `RaidBeam11` Neon (255,40,40) -> core (205,105,102), 0.7x wide, inside a new Neon halo (200,45,45) at T 0.55. p3 (640,150) (252,40,53) -> **(251,109,113)** vs (243,138,135). **Recesses:** 3 dark arches (40,12,16) are placed left (-z) of the door, each a 3 x 5.5 slab and a 3-stud disc. They sit on the facade face found by rays that skip the dead trees in front (the first try hit Branch28). A green tint proves them in c3 (1125-1203, 515-553) and in p3. **Door:** the door is already black Neon. Nothing translucent stands in front of it, only Fire/Embers at y 9 and two ember sheets 2 tall. The lift is Atmosphere (density 0.28) over about 160 studs, and Atmosphere is settled. |
| 5 c3 falls | Done. The cloud was not changed. **Falls:** FallCore32 -> (170,215,235), FallMid32 -> (140,200,225), and Fall32/FallVeil32 are 1.5x wide (444 parts). One mist ellipsoid 8 x 3 x 4.8 (200,230,235) at T 0.5 sits at the foot of each fall (18 groups by x,z). c3 (60,230) (226,245,246) -> (205,246,247), so the brief's (196,240,247) is close. **Cloud (300,40):** this is the skybox. Only `Sky.SkyboxOrientation` could move it, and that is a global change that moves every camera's sky, so it was not tried. **Recess under the arch** (640,500): not done. |
| 6-10 | Not attempted. c4 was picked: (640,350) is `Colonnade17.Dome` cream and (640,410) is `Colonnade17.Back`. It was left alone because c4 is at 9.5 and the dome also shows in p1. |

## Captures
- **Final set:** `out/r36/r36_<cam>.png`, all 12 at full size **1284 x 793**. Contact sheet `out/r36/contact.jpg` (v33 ref | v33 rep | r36).
- **Working sets:** `out/r36w/b` to `m`, plus `tint` (the slate red test) and `tint2` (the recess green test). The `a` set was taken while the slate tint was on: ignore it.
- **Check images:** `tint_sheet.jpg`, `t_arch.jpg`, `t_arch2.jpg` (the Neon stone test), `t_tree2-4.jpg`, `t_p2b.jpg`, `t_p2c.jpg` (fringe hidden), `t_raid2.jpg`, `t_c3b.jpg`.
- **Tools (`out/r36w/`):**
  - `run.sh` runs `build.sh` (head + params + body -> `fix/pass36.lua`) and then the script.
  - `lrun.sh <lua>` runs a Lua file in the practice studio.
  - `some.sh <tag> [cams]` captures a set; it now captures all 12 when no cameras are given (the pass-35 version captured none with an empty argument).
  - `bx.py`, `pick.py` and `trip.py` point at v33. `tri.py <tag> <out> cam:x0,y0,x1,y1 ...` makes cropped rows of ref | v33 | new.
  - `q*.lua` are queries; `tint*.lua` and `untint.lua` are the ownership tests.

**Top-half mean HSV saturation:**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref v33 | 81 | 99 | 103 | 110 | 91 | 112 | 89 | 98 | 94 | 110 | 94 | 80 |
| rep v33 | 87 | 97 | 96 | 114 | 98 | 110 | 82 | 88 | 105 | 103 | 98 | 91 |
| **r36** | **88** | **97** | **100** | **114** | **98** | **109** | **83** | **90** | **103** | **102** | **99** | **91** |

**Change size against the v33 practice frame** (pixels changed by more than 30 levels): p3 5.9 %, p2 4.7 %, c3 3.9 %, p1 3.8 %, c1 3.6 %, p4 3.4 %, p6 3.1 %, c2 2.8 %, p8 2.8 %, p5 2.5 %, p7 2.5 %, c4 1.1 %.

**Checks on the 9s and 9.5s.** I compared every camera by eye in the contact sheet:
- The lighter shoulder band shows on every arch: p1-p6, c1, c2 and c3.
- The notch trees read as branched crowns, not poles: p1-p5, c1 and c3.
- p2 and p6 gain the lower orb and the darker portal and pillars.
- p7, p8 and c4: there are no visible changes besides the trees.

No feature was lost.

## What I measured / proved
- **Slate ownership:** a red Neon tint of `K_Arch20_slate` covers the full band between the pipes in all five target cameras.
- **Picks hit MeshPart collision hulls:** the pick tool's first hit is often `K_Arch20_gold`, even where the picture shows slate. Raycasts use the collision geometry, not the render mesh. The tint is the proof; the pick is only a list of candidates.
- **Neon is not linear here:** Neon (50,55,62) rendered (9-15,18-33,35-44), and (92,97,104) rendered (123-130,142-145,156-172). The slope is about 2.7-3.3x, with a large negative offset and a blue shift. (80,82,85) gave (82-94,90-97,97-108). Interpolate between two tests; do not scale from one.
- **p2 orb:** the ref core is lower-right of ours in the same camera, so the brief's "raise" was the wrong direction. A crop comparison caught it.
- **Raid door:** no translucent part, Beam or emitter stands in front of the door above y 12 (scan of `x > 100`, `|z| < 60`). Its lift is Atmosphere.
- **Idempotence:** repeated runs give the same report and **21745**.

## Built (method)
`fix/pass36.lua` is idempotent and runs after pass 35.
- Every touched part keeps its old value in a P36* attribute, and the script restores those first. New pieces go in `Plaza.Pass36` (Tree36, Raid36, Falls36).
- It merges `Workspace.ae_kit_r36` if one is ever imported. `fix/build_plaza.lua` IMPORTS also lists r36.

The blocks:
- **ARCH36:** recolours the slate band. The `STONE_COL` knob is nil (the Neon test is documented in `params.lua`).
- **TREE36:** for each `Trunk34`, it cuts the length to `TRUNK_TOP`, keeps the bottom and moves the centre down. It adds 3 arms built with `CFrame.lookAt` from 55 % height, each stopping 1.2 short of its clump. Clumps are placed by centre: `CFrame.new(c - k.Position*sc)`, with `sc = width / kit size`.
- **ORB36:** moves the ring model by `ORB_SHIFT` and recolours its core, the pillar glass and the portal parts (scaled from their stored original colour).
- **RAID36:** builds the beam core and halo. Each recess comes from a +x ray at y 16 that skips every non-Gothic/Raid or translucent hit.
- **FALLS36:** recolours the falls and widens them. It groups the parts by rounded (x/6, z/6), finds each group's lowest bottom and adds a mist ellipsoid there.

## Lessons (for the workflow vault)
1. **Check the brief's direction against the picture before you move a piece.** The brief said "raise the orb 8". A crop comparison showed that the ref orb is lower than ours, so a raise would have moved away from the reference.
2. **Neon flattens shading. It can fix backlit boxes, but it costs form.** An unshaded Neon arch hit 3 of 5 colour boxes, but it lost the depth of the U and the inner band. Judge the whole piece by eye, not only the boxes.
3. **A raycast pick reports collision hulls, not what is drawn.** A gold MeshPart's hull was "first hit" over slate it does not cover on screen. Use a tint to prove which part owns a pixel.
4. **To hide a bare trunk, cut it inside the crown and branch it.** Clumps on the camera-facing side at 3 heights plus arms that end inside clumps hid all four poles. That is cheaper and reads better than enlarging the crown, which moves every camera's saturation.
5. **Hiding a fringe can expose a worse surface.** Removing the green fringe exposed a flat grey underside. Look at what is behind a piece before you hide it.
6. **When you cast rays to place things on a facade, skip the decoration.** The first recess ray hit a dead tree in front of the wall. Filter by the owning model's name and by transparency.

## Objects built (for 5 Object Recipes)
- **Lit arch shoulder band:** the existing slate band mesh in SmoothPlastic (112,116,122) instead of Slate (30,37,43). It renders (148,154,159) when lit.
- **Branched crown over a bare trunk:** cut the trunk inside the crown. Add 3 arms 0.5 thick, 2.6 out and 4.2 up from 55 % height, each ending in a ~3.8 cloud clump. Add 4 more clumps on the viewer side at 3 heights and one at the crown top. Colours: royal (36,78,195) and (60,108,210).
- **Raid light beam:** a pink Neon core (205,105,102), 0.7x wide, inside a red Neon halo (200,45,45) at T 0.55 and 1.6x wide.
- **Carved arch recess:** a dark slab 3 x 5.5 (40,12,16) with a 3-stud disc on top, 0.15 proud of the facade, placed by a filtered ray.
- **Waterfall foot mist:** a sphere-mesh ellipsoid 8 x 3 x 4.8 (200,230,235) at T 0.5, 0.8 above the lowest fall segment, one per fall.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **21745** (pass 35: 21650). Workspace holds Camera, Terrain, SpawnLocation and Plaza.
- Nothing was saved or committed, and there was no computer use. `RivalsPractice_replica.rbxl` was not touched.
- Changed tracked files: `fix/build_plaza.lua` (IMPORTS r36). New files: `fix/pass36.lua` and this note.
- `tools/ae_kit.py` and `ae_kit.blend` are unchanged: no kit this pass.
- `fix_lighting.lua` was not re-run. Technology, post effects and Atmosphere are unchanged, and Haze was not tested.
- **How to rebuild:** on the pass-35 build, run `sh out/r36w/run.sh`.

## Reference use
The round-33 frames in `out/verify33/` were used for every target. The reference studio was not captured: there was no execute_luau and no position read there, and `ae_reference.blend` was not opened. Only own meshes and Parts were used.

## Next
- **K_Arch20 rework (kit):** narrow the U arms, or give them a lit chamfer, so the backlit boxes lift (c2 (560,200) 40 vs 100; p1, p3). Widen the ledge to about 2. A flat Neon arm is not the answer (see the test above).
- **c3:** the skybox cloud (only `SkyboxOrientation`, which is global; test it against all 12 cameras), and the recess under the arch (640,500).
- **p2 (720,200):** the island fringe band. Replace it with a lower, cloud-coloured fringe rather than hiding it.
- **Items 6-10:** SE rock and sand, the jet plume, the Summon side (c4 dome (640,350) is `Colonnade17.Dome`), the lagoon edges and the Story crown.
