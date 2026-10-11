# Fix pass 28: Anime Expeditions spawn plaza (long flat stair blocks, wide-rim runner, accents and a clearer south sky, lagoon, falls, gothic Raid door, gate crescents, faceted bollards)

Builder report for `notes/fix_brief28.md`, answering the round-25 review `notes/verify25_plaza.md` (8.88/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...`, reference studio `97946bf6-...` (not used: the full-size v25 frames
were enough, so no reference capture was taken). One kit, `kit/own/ae_kit_r28.fbx`, imported by the lead.

## Status by review item

| Item | Status |
|---|---|
| 1 Stair blocks | Done (kit r28). 3 long flat blocks per side per row (4.47 studs, about 5x the riser), 0.1 joints, joint recessed 0.1, bevel 0.15, each row runs back under the next so the dark slot is gone. c4 tread 6 -> **4**; riser colour (82,100,110) vs (76,97,110) ref, measured at the new riser position (the v25 riser box now lands on a tread). c2 right flight reads as long slabs. |
| 2 Accents and sky | Done. c4 palm 67 -> **20**, gold tree 97 -> **29**, column trees deep blue again. Own sky variant f: clear azure south, the pass-26 clouds kept in the north. Saturation now within about 8 of the reference on 9 of 12 cameras (table below). |
| 3 Islands and falls | Mostly done. Falls brighter (235,245,250) T 0.25, 2 more off Isl24_4. Rock undersides grey. Canopy pads darker (c3 canopy 92 -> 68). p3 disc hidden. |
| 4 Runner and Y | Done (kit r28). 1-stud grey kerb, 0.75 gold band, darker blue face, bigger Y with a dark core. c4 panel 30 -> **8**; p5 panel 63 -> 38. Stray blue spill on the c4 treads hidden. |
| 5 West half | Done. Lagoon water 60 x 40 back on a larger sand bank, 5 blue palms on its edge. S lawn brighter. The faceted green palm near p7 replaced by a long-frond yellow-green palm. |
| 6 Gate | Part: 8 stone crescents round the orb (radius 9). No crystal basins; the island band behind the crown is unchanged. |
| 7 Raid | Done: gothic pointed door (about 13.6 x 23.6 studs) with keystone and skull boss, 4 bare branches, the red tree in front moved 24 studs aside. The red Raid haze still tints the door. |
| 9 Bollards | Heads done: faceted dark gold, p1 bollard head 42 -> **7**. Summon / Boss Rush facades not done. |
| 10 Floor | c2 red flower ferns hidden; c1 red clump cooler (27 -> 24, the clump is mostly lit). Fountain jets and the finer fern spray not done. |
| 8 Story crest / ivy / palace corner | Not attempted. |

## Captures
- **Final set:** `out/r28/r28_<cam>.png`, all 12 at full size **1284 x 793** (second frame of `capture_set2.py`, no normalisation needed). Contact sheet `out/r28/contact.jpg` (v25 reference left, r28 right).
- **Baseline:** pass-27 state `out/r28w/base/`; it reproduces every v25 practice box value exactly, so the box tool is trustworthy.
- **Working sets:** `out/r28w/a`-`f`. Tools in `out/r28w/`: `box28.py` (v25 boxes in 1284 frames, no x shift), `cap.sh`, `some.sh <tag> <cams>`, `full.sh <tag>`, `pick.py` (centre 642), `run.sh`, `lrun.sh`.

## Results (5x5 means; max channel difference to the v25 reference box; base = pass 27)

| box | base | r28 |
|---|---|---|
| p1 bollard head | 42 | **7** |
| p1 gold tree | 52 | 52 (darker now: (169,133,81); the c4 target is darker than the p1 one) |
| p2 crown (a 9) | 13 | 13 |
| p2 panel (a 9) | 37 | 36 |
| p5 panel | 63 | 38 |
| p7 lawn S | 45 | 41 (G/R within 13; B is haze, as in pass 27) |
| c1 red | 27 | 24 |
| c1 blue (a 9) | 12 | 12 |
| c3 sky | 112 | 112 (cloud: north sky kept cloudy, see below) |
| c3 canopy | 92 | 68 |
| c4 palm | 67 | **20** |
| c4 gold tree | 97 | **29** |
| c4 panel | 30 | **8** |
| c4 tread | 6 | **4** |

**Top-half saturation (ref / pass 27 / r28):**

| cam | ref | p27 | r28 |
|---|---|---|---|
| p1 | 82 | 78 | 83 |
| p2 | 99 | 84 | 91 |
| p3 | 103 | 84 | 93 |
| p4 | 110 | 101 | 105 |
| p5 | 90 | 92 | 97 |
| p6 | 113 | 90 | 98 |
| p7 | 88 | 72 | 75 |
| p8 | 96 | 80 | 86 |
| c1 | 95 | 99 | 103 |
| c2 | 109 | 101 | 105 |
| c3 | 91 | 88 | 97 |
| c4 | 83 | 84 | 93 |

Mean |rep - ref| 9.9 -> 6.9. Still out of the 8 band: c4 +10 (deep palms), p6 -15, p7 -13.

## What I measured / proved
- **The paleness was cloud, not sky colour.** The clear sky already rendered azure (61,161,244) at c3 900,60; the c3 box (650,60) and the top of c4/p2 were cloud. Variant e (fewer high clouds, greener-azure ramp) took the c3 box 112 -> 7, but c4 jumped 84 -> 102 and c3 to 115.
- **Saturation split by hue and by region** (`dsat` per 214 x 66 tile) showed where the rise came from: c4 +10.8 in the blue-purple class (palm crowns, top-left and top-right tiles +20..+34), c3 +5.6 in the cyan class (sky).
- **North/south sky blend (variant f):** the sky generator blends two parameter sets by azimuth (north weight by -z of the view direction, smoothstep from -0.3 to 0.6). The north kept the pass-26 clouds and c4/c1/p5 came back down. Orientation proved by capture: the north views went cloudy again and the south views stayed clear.
- **Palm tint trade-off:** with rim (87,126,214) / leaf (35,78,205) the palm box was 16 off but c4 sat was 97. The final rim (104,138,210) with a duller inner leaf (78,100,165) keeps the palm at 20 off and c4 at 93. Our palm crowns fill more of the c4 frame than the reference's, so a perfect colour match over-saturates the frame.
- **Gold tree:** the pass-27 leaf27b gold map gave (242,229,168). The original leaf14 gold map with SA tint (215,190,150) renders (220,179,94).
- **Lagoon:** `Lagoon16`/`LagoonDeep16` were hidden by pass 24 (P24Hidden) for the p8 W-blue metric. Pass 28 shows them again with a `P28Shown` attribute, so a restore re-hides them.
- **Pixel ownership by pick:** c4 870,95 = `NPalm22` SA; 225,300 = `Cypress19`; 640,230 = a `Trees13` K_Soft15K cluster at (0,65,-185); c2 red decals = `Planting.K_Fern` (pink-red) at (13,1,25); c1 red = `Fern26`; c4 stray blue = `K_Spill9` at (13,4,-40); p3 disc = `Islands.K_Isl92` at (290,190,50); Raid door blockers = `Pass22.Fol22.RedTree22` (one of five models with that name, pivot (120,18,-5)).
- **Lowering the p3 disc 35 studs made it worse:** it became a grey island in the middle of the sky. Hidden instead.
- **Raid door colour:** the door leaf in SmoothPlastic (12,6,9) rendered pink under the Raid lights and haze. A near-black Neon leaf, set 1.7 studs deeper, stays dark.
- **Runner gold:** (150,124,36) rendered (228,199,46), brighter than the reference (213,191,56); set to (138,114,36).
- **Riser:** the new riser faces render (82,100,110) for set (78,90,95), against (76,97,110) in the reference.

## Built (method)
`fix/pass28.lua`: idempotent and runs after pass 27. Every touched part keeps its old value in a P28* attribute (Col/Mat, SA, Map, Size, CF, Hidden, plus P28Shown for parts it un-hides). New pieces go in `Plaza.Pass28`. It merges `Workspace.ae_kit_r28` into `ServerStorage.Kit` itself. Blocks:
- **SKY28:** own skybox variant f (ids in the file; variant e ids kept in a comment).
- **ACC28:** N palm SA tints; Cypress19 original blue map plus SA (190,200,245); the N gold tree original gold map plus SA (215,190,150).
- **ISL28:** Sky25 pads (124,157,90), Isl24_4 rims (150,190,110), island Slate rocks (112,117,122), Isl27 lumps (118,150,88), p3 K_Isl92 hidden.
- **FALL28:** Fall27 retinted (235,245,250) T 0.25; 2 new falls from the Isl24_4 lip (raycast march, as in pass 27).
- **RUN28:** colour fallback for the old runner, and the stray spill hidden.
- **WEST28:** lagoon shown and resized; 5 NPalm22 clones (ScaleTo, set on the ground by bounding box); GreenPalm20 replaced by a yellow-green NPalm22 clone; GroundS (62,112,4).
- **FLOOR28:** red K_Fern near (14,1,26) hidden; Fern26 red (178,60,62).
- **KIT28:** stairs, runner and Y, bollard heads, crescents, gothic door, branches and the red-tree move.
  - Colours: tread (118,122,120), nose edge (124,128,126), riser (78,90,95), joint (40,48,54), kerb (112,114,114), gold (138,114,36), blue (46,66,145), Y core (30,40,88).
  - Crescents (178,182,192) Slate; door stone (120,40,45) Slate, leaf (4,2,3) Neon, bone (225,215,190); branches (45,32,36) Wood; bollard heads (135,126,50) Metal.

**Kit r28** (`tools/ae_kit.py` pass-28 section: `build_stairs28`, `build_runner28`, `build_boll28`, `build_cres28`, `build_goth28`, `build_branch28`, `build_all28`, `export_r28`, `r28_info`):
- 15 pieces plus `K_Scale28_stone`. The largest is `K_RunY28_gold` at 16,400 triangles.
- Centres are in `kit/own/ae_kit_r28_centres.json`.
- `ae_kit_r28` was added to the IMPORTS of `fix/build_plaza.lua`.

## Lessons (for the workflow vault)
1. **"Paler than the reference" can be the amount of cloud, not the sky colour.** Sample the clear sky somewhere else in the frame before retinting the ramp; here the clear sky already matched.
2. **Make sky changes directional.** One skybox serves all twelve cameras. Blending two parameter sets by azimuth let the south views get a clear sky while the north views kept the haze that matched them. Prove the orientation with one capture.
3. **Matching an accent's colour is not enough when it fills more of the frame.** Palms of the right colour but larger in frame pushed c4 10 over. Use the region and hue split to see which object carries the excess, then trade a little colour (a duller inner leaf layer) for the frame total.
4. **To remove a slot, overlap the pieces.** Joints read as hairlines when each block row runs back under the next, taller one: no gap needs hiding, and the remaining seam is a 0.1 joint over a 0.1 recess.
5. **Check "lower it" items against the frame.** Lowering a sky disc moved it into the middle of the view. Hide it, or move it out of frame upward.
6. **Several parts can share a name.** `FindFirstChild("RedTree22")` returned the wrong one of five, so the move did nothing ("redtree 0"). Loop over all children with that name and select by position.
7. **Dark materials under strong coloured light.** A near-black SmoothPlastic door turned pink under the Raid lights and haze. Use near-black Neon (unlit) for an opening that must stay dark.
8. **Re-prove a review box after the geometry changes.** The v25 c4 riser box now lands on a tread of the new, longer blocks (114 off). The riser colour was measured on the new riser rows instead.

## Objects built (for 5 Object Recipes)
- **Long jointed stair blocks (`build_stairs28`):**
  - 3 blocks per side per row, with half blocks at the ends of the offset rows; bevel 0.15 with 2 segments; 0.1 gaps.
  - Each block, except in the top row, extends 0.6 of a tread under the next row.
  - A joint slab per row, recessed 0.1.
  - Split by face normal into stone/edge/riser meshes, plus the joint mesh.
- **Wide-rim runner (`build_runner28`):** 3 lofted layers of the r23 ramp: kerb (half-width 4.3, floor), gold (3.3, +0.08) and blue (2.55, +0.14). The Y is ribbons draped on the ramp surface plus tube outlines (core 0.8 wide, outline r 0.15).
- **Faceted bollard head (`build_boll28`):** a lathe with seg=4 rotated 45 degrees and flat shaded: a 4-sided collar, bulb and spike.
- **Floating crescent (`build_cres28`):** a loft of a 6-point cross-section along an arc of radius 12, tapered by sqrt(1-u^2) to points at both ends. 8 copies are rotated about the orb in its plane, alternately tilted 0.25 rad.
- **Gothic pointed door (`build_goth28`):**
  - An equilateral pointed-arch outline (two 60-degree arcs of radius 2 x half-width) with two tube archivolts, jambs, bases and a keystone.
  - The door leaf is the same outline filled (ear-clip).
  - A lathe skull boss with two socket discs.
- **Bare branch (`build_branch28`):** a recursive 3-level fork of tapering tube_along segments with random jitter (seed 28).
- **Own sky variant f (`tex/make_ae_tex28.py`):** variant e (clouds thin out above about 30 degrees, greener-azure MID/TOP) in the south, blended to the pass-26 d parameters toward -z by an azimuth smoothstep.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **17647** (pass 27: 17575). Workspace holds only Camera, Terrain, SpawnLocation and Plaza; `ae_kit_r28` was merged into `ServerStorage.Kit` (15 pieces).
- Nothing was saved or committed. `ae_kit.blend` was saved after the r28 build and export.
- Technology, post effects and Atmosphere are unchanged; Haze was not tested.
- **How to rebuild:** on the pass-27 build, run `sh out/r28w/run.sh`. It is idempotent.

## Reference use
- No capture of the reference studio was needed: the round-25 frames in `out/verify25/` were used for every target. No execute_luau in the reference, no position reads. `ae_reference.blend` was not opened. No computer use. Own meshes and own textures only.

## Next
- p6 (-15) and p7 (-13) are still under the reference saturation: the W/S canopy (p6) and the high view's ground (p7).
- c3 sky box: the NE sky is still cloud at 650,60. Narrowing the north band of the sky blend would clear it, but c3/c1/p5 are already 6-8 over.
- The p2 island band behind the crown (38 off), crystal basins at the gate, the Story crest and ivy, the palace corner, the Summon / Boss Rush facades, translucent fountain jets, the finer c2 fern spray.
- The skull boss on the Raid door is too small to read at p3 range; enlarge it about 2x.
