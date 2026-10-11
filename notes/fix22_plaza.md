# Fix pass 22: Anime Expeditions spawn plaza (haze, canopies, falls and aqueduct, stair grass, arch notch, runners, 8 steps, Raid)

This is the builder report for `notes/fix_brief22.md`. It answers the round-19 review `notes/verify19_plaza.md` (7.92/10).

**Status by review item**

| Item | Status |
|---|---|
| 1 Background | Done. Atmosphere kept at Density 0.28; canopies now 3-4 coloured lumps each; north island with an aqueduct and two falls. |
| 2 Foliage | Done: E splats thinned, SE lawn, red trees on the E side, blue palms on the N avenue, white S pads turned to lawn, tan sand, S palm cluster. |
| 3 Stair grass | Done: shrub balls replaced by 31 fern sprays, and a grass fringe along the S and W stair tops. |
| 4 Arch notch | Done: recessed U with pods and a small tree; tunnel fill light. The width (1.17x) was not changed (see below). |
| 5 Runners | Done: raised bevelled slabs (kit `K_Runner22`), and the runner blue measured. |
| 7 Raid | Skull warmed and lit, red haze retuned, facade recoloured against the fog. |
| 8 Stairs | Done: 8 steps of 0.75 (kit `K_Stairs22`); tread lightened. |
| 6 Arms and medallion, 9 Facades, 10 Bollards and pineapple | Not attempted. |

**Captures**
- Final set: `out/r22/r22_<cam>.png`, 12 cameras through `capture_set2.py`, second frame kept.
- Contact sheet: `out/r22/contact.jpg`, with the v19 reference on the left and r22 on the right.
- Working frames: `out/r22w/<letter>_<cam>(_a).png`.
  - `a_` is the baseline.
  - `b_` to `p_` are Studio-only steps; the atmosphere tests are `d_`, `e_`, `f_`, `h0.28_` and `h0.24_`.
  - `q_` onward come after the kit import.

**Rules kept**
- Pictures only. Every target was re-sampled from `out/verify19/v19_<cam>_ref.jpg` on every run by `out/r22w/box22.py`.
- The reference studio was not touched at all in this pass, not even with screen_capture.
- Own geometry only. No computer use.
- The place is not saved and nothing is committed. `ae_kit.blend` was saved before the export.

**State at the end**
- `#workspace.Plaza:GetDescendants()` = **17177**: 16182 for pass 21, plus `Pass22` (994 descendants) and the clones it adds.
- Workspace holds only **Camera, Terrain, SpawnLocation, Plaza**.
- `ae_kit_r22` was merged into `ServerStorage.Kit` by the header of `pass22.lua`: 6 meshes went in and the scale cube was destroyed.
- Lighting: the Atmosphere is changed (Density 0.28). The original values are stored in the `P22Atmo` attribute and restored at the start of every run.

**Tools (`out/r22w/`)**
- `box22.py <cam> <png>...`: 5x5 means at the round-19 review boxes, with the targets re-sampled from v19.
- `metrics22.py <cam> <png>...`:
  - top-half saturation;
  - W blue cover;
  - green cover: HSV hue 43-102 with s > 90. This reproduces the review's p7/p8 figures within 2.
  - red cover. My red rule does not reproduce the review's p8 numbers, so the red figures below are mine.
- `cap.sh <cam> <tag>`: captures twice and runs the boxes and metrics on the second frame. For p3 it also runs the pass-18 Raid boxes.
- `rayz.py <cam> x|y|z <v> px,py...`: intersects a camera pixel ray with an axis plane. I used it for the falls, the aqueduct, the fern and the runner slab.
- `pick.py`, `run.sh` (runs `fix/pass22.lua`).

**How to rebuild** (on the pass-21 build with `ae_kit_r22` imported)
- Run `sh out/r22w/run.sh`. It is idempotent: every touched piece is restored from its `P22*` attributes first.
- Blocks run in this order: `--SKY22`, `--STAIR22`, `--GRASS22`, `--ARCH22`, `--RUN22`, `--RAID22`, `--FOL22`.
- `fix/build_plaza.lua` has r22 in `IMPORTS`.

## Results (final set `out/r22`, against the v19 reference)

| measure | v19 practice | r22 | reference |
|---|---|---|---|
| top-half saturation p1 / p7 / p8 | 109.1 / 108.6 / 119.7 | 102.1 / 86.6 / 98.2 | 84.1 / 90.6 / 98.8 |
| top-half saturation c3 / c4 / p5 | 104.6 / 125.2 / 117.1 | 95.4 / 122.3 / 100.0 | ~91 / 85.6 / 92 |
| p7 E green cover (s > 90) | 10.0 % | 23.5 % | 25.6 % |
| p8 E green cover | 3.7 % | 13.3 % | 3.8 % (the reference lawn is mostly unsaturated) |
| c2 stair green (x > 800, y > 400) | 16.8 % | 0.1 % in the box, see note | 6.7 % |
| c4 riser / tread / runner | 11 / 18 (on our geometry) / 69 | 9 / 19 / 5 | |
| p5 runner | 54 | 3 | |
| c1 pods / tunnel / slate / ledge | n/a (plug) / 28 | 12 / 8 / 5 / 8 | |
| p2 stair-top lawn | 60 (stone) | 27 | |
| p3 skull cheek | 115 | 24 | |

- **c2 green:** at Density 0.38 with the old 6 steps, the working frame read 9.8 %. On the 0.75-rise steps the lip ferns sit lower and edge-on, so the green streak at y ≈ 385 now falls above the metric window. By eye there are flat sprays on the lips and no balls.
- **p8 lawn holes (59 off):** the GrassHole18 retint reads grey-green under the fog. Not fixed.
- **c1 pale band (19 off):** unchanged from pass 21. Not attempted.

**Pass-18 Raid boxes**

| box | baseline (before pass 22) | r22 |
|---|---|---|
| skull | 30 | **35, kept out on purpose** (see below) |
| tower | 18 | 13 |
| rim | 11 | 20 |
| hazeL | 3 | 5 |
| hazeR | 26 | 6 |
| shadeR | 3 | 22 |
| lowL | 8 | 8 |
| lowR | 18 | 32 |

- **skull (kept out):** item 7 asks for a lit salmon skull, cheek (216,128,102). The warmer bone that brings the cheek from 115 to 24 off makes the sunlit skull top read (250,187,145), against the old (230,152,130). The two targets pull in opposite directions; I chose the review's cheek.
- **shadeR and lowR (out because of the fog):** they sit on shadowed and lower facade faces that share one material (`K_Spire_stone` / `K_Gothic_stone`) with lowL. The fog lifts their G and B by 22-36. Even near-black base colours cannot get under the fog floor, so separate parts would be needed.
- **rim (out):** the pick reports `RaidArchBand17`, but recolouring it did not move the pixel. Something non-queryable sits in front, probably the red trees or the haze.

## 1. Background (`--SKY22`)
**Atmosphere test.** The pass-21 Haze test (Haze 1) raised saturation. This pass tests the other axis, density with Haze 0:

| Density | p1 | c4 | p7 | p8 | p3 low Raid boxes |
|---|---|---|---|---|---|
| 0.2 (original, grey) | 110.7 | 127 | 108.6 | 119.7 | in |
| 0.24 | 107.2 | | 100.4 | 112.4 | |
| **0.28 (kept)** | **102.1** | | **86.2** | **97.8** | lifted |
| 0.32 | 94.4 | 109.2 | | | |
| 0.38 | 85.3 | 97.9 | 53.9 | 57.8 | grey |
| 0.45 | 76.0 | 85.2 | | | |

- Density 0.38 matched p1, but it washed out the high cameras and turned the distant Raid grey.
- I kept **0.28**, which matches p7 and p8 and drops every player-height camera by 5-17.
- Atmosphere.Color has no effect at Haze 0: (200,220,235) and (222,222,220) gave identical frames. The fog tint comes from Decay.

**Canopies.**
- The 35 round island crowns are IslSkirt16 K_Soft15U/R plus the Canopy21 clones. Their leaf parts are hidden and the trunks are kept.
- Each crown becomes 3-4 K_Soft15K lumps (123 in all), in the mix blue / purple / gold / pale green:
  - lumps are ~0.5-0.66x the crown width, spread at r 0.32;
  - one lump sits higher on the trunk tip, so no trunk shows above the crown.
- Lump colour comes from the leaf map on the SurfaceAppearance: 118173 is blue, 94449 gold, 108341 purple.

**North island, aqueduct and falls.**
- Projected positions:
  - the p1 reference falls at x 780 and 905, the c4 falls at x 760 and 900, and p5 all land at x ≈ 15 and ≈ 55, z -160..-200;
  - the c4 aqueduct (x 585-700, y 40-80) lands at x -47..-9, y 132-147 at z -200, which is 40 long, the size of K_Aque9.
- Built:
  - a K_Isl92 clone at 0.42 scale at (15, 128, -235);
  - a K_Aque9 clone on top of it;
  - two K_Fall8 sheets, 9 wide, SmoothPlastic (228,242,250) at transparency 0.2. A first try at 6 wide in Glass at 0.35 was invisible.
- A first try at 0.7 scale and z -195 was a dark slab across p1, so the island moved back and shrank.

## 2. Foliage (`--FOL22`)
- **E side:**
  - 105 of 263 red splat pairs are hidden; rim and core are grouped by rounded position and 3 of every 5 are kept.
  - The GrassHole18 lime circles are retinted to Grass (110,150,50).
  - 36 grey Zoning patches south of the E arm (x > 30, z > 12) became Grass (88,138,52).
  - 5 red K_Soft15R canopy trees (150,35,40) stand on the grey; 3 of the 8 planned spots raycast onto something above y 15 and were skipped.
- **N avenue:** 6 LagoonPalm16 blue palms (26-30 tall) at x ±21.5, z -60..-100.
- **S side:**
  - the 3 WhitePave pads are now Grass (92,145,58);
  - the Sand20 discs are tan (222,204,160);
  - 3 GreenPalm20 clones stand at the S approach.

## 3. Stair grass (`--GRASS22`)
- All 56 Clump21 balls are hidden. 1 in 5 of their spots, plus 5 fixed (lat, d) lip spots per flight, get a K_Fern spray: 31 in all, 3.6 across, leaf (100,150,48) and rim (125,172,62).
  - One lip spot is the c2 reference fern, projected to x 10, z 30.8 on the S flight.
- A fringe of 112 K_Grass blades runs along the S and W stair tops (d 48.4 and 49.3). They are 1.3-2.6 tall, colour (120,185,75).
  - The first fringe (1.6 tall, spacing 1.1) did not show in p2. At 2.6 tall it does.

## 4. Arch notch and tunnel (`--ARCH22`)
- In each corner, `NotchBack21` is hidden and replaced by:
  - a low slate back wall at w 34.6, 1.5 behind the front, y 8.9-10.6;
  - a floor;
  - 3 ball pods (63,56,64), which render (62,62,74), 12 off;
  - a 7.5-stud trunk with a branch and two blue lumps.
- **Tunnel wall:** `K_Hero19_stone` rendered purple (33,26,47) in shadow. A green-cyan PointLight (150,235,185), brightness 2.2, range 9, at w 34.5, y 3.2 brings it to (37,46,58), 8 off.
- **Arch width:** not changed. Narrowing the hero arch means re-scaling the K_Arch20 / K_Hero19 meshes, which was not attempted within the time box.

## 5. Runners (`--RUN22`, kit `K_Runner22`)
- **Slab:** one per stair foot, from d 16.5 to 28. It sits on the floor, and its top rises 0.35 toward the stairs.
- **Colours:** silver (205,210,215), gold Metal (160,135,45), face (58,82,160), gem Neon (90,220,240) at transparency 0.2.
- **Stair runner:**
  - K_Stairs_blue (58,80,160) and K_Stairs_navy (53,75,143), both two-point fits;
  - navy is far from linear: (28,38,95) rendered (29,57,167), while (66,84,128) rendered (98,142,207).
  - Result: c4 runner 5 off, p5 runner 3 off, p5 slab face (84,142,239).

## 7. Raid (`--RAID22`)
- **Skull:** bone (235,150,100) SmoothPlastic, and a PointLight (255,150,115) in front of it. The cheek went from 115 to 24 off; the light alone barely moved it, the bone colour did.
- **Haze:** the RaidHaze16 Band particle colour (145,95,86), interpolated from two settings.
- **Fog compensation:**
  - gable (138,29,0);
  - spire and gothic (72,2,5);
  - the light RaidArchBand17 (125,84,70).
  - Two-point fits, because under the fog a part's render moves only 0.3-0.6x as much as its colour.

## 8. Stairs (`--STAIR22`, kit `K_Stairs22`)
- **Count:** 8 risers, read from the frames.
  - In c4, the reference dark bands at y 476 / 509 / 554 / 626 / 755 match an 8-step flight projected through the c4 camera (487 / 519 / 564 / 632 / 747). A 6-step flight projects to 498 / 552 / 647 / 854.
  - In p1, the reference shows 8 bands and ours 6.
- **Tread:** (122,125,121) Slate. It measured 4 off in the working frame and 19 in the final set; c4's tread box is sensitive to which block it lands on.
- **Importer warning:** `K_Stairs22_stone` has 20,384 triangles, over Roblox's 20,000 per-mesh limit, and at import scale it sits at the 2048-stud MeshPart cap. It rendered whole: all four flights show complete blocks in c2, c4, p5 and p7. Next time use bevel segments 1, or split the flights into two meshes.

## Lessons (for the workflow vault)
1. **Test a global setting on every camera, not just the one in the review.** Atmosphere Density 0.38 fixed p1 exactly and wrecked the high and distant cameras (p7 54 against 91). The value to keep is the one that best matches the whole set, here 0.28.
2. **Know which Atmosphere knob does what.** Color only tints Haze. At Haze 0 it does nothing, and density fog takes its tint from Decay. Pass 21's Haze test and this pass's Density test pull saturation in opposite directions.
3. **Fog compresses colour response.** Under fog a far part's render moves only 0.3-0.6x as much as its colour, and dark targets can fall below the fog floor. Fit with two measured points per channel, and accept that shadow-side boxes may be unreachable.
4. **Count steps by projection, not by eye.** A luminance profile down a column of the reference frame, compared with candidate flights projected through the same camera, settled 6 against 8 unambiguously. Neither the pass-21 count nor the review's prose was right on its own.
5. **Check that a clone source is visible.** The first fern source was one of the hidden Planting ferns, so 31 invisible ferns were placed. Filter sources by Transparency and by the hide attributes of earlier passes.
6. **Reuse the kit before modelling.** Falls (K_Fall8), aqueduct (K_Aque9), fern spray (K_Fern), canopy lumps (K_Soft15K plus leaf maps) and red trees (K_Soft15R) already existed. Only the stairs and the runner slab were genuinely new meshes.
7. **Mind the importer limits when you merge.** Merging 4 rotated flights of bevelled blocks went over 20k triangles and hit the 2048-stud size cap at import scale. Count triangles in Blender before exporting.
8. **Distant pieces read darker and bigger than you expect.** The first north island, at 0.7 scale, was a dark slab across p1. Place background pieces small and far, then capture.
9. **A light is weaker than a colour change.** The skull PointLight barely moved the cheek; warming the bone colour did. For the tunnel wall in shadow, though, a fill light was the only lever that did not also change the sunlit faces.

## Objects built (for 5 Object Recipes)

### Shallow stair blocks (`tools/ae_kit.py`: `build_stairs22`, which is `build_stairs21` with `tag`)
- 4 flights (rot4) of 8 steps: rise 0.75, tread 2.5, d 28-48, lateral 4.3-17.7.
- Bevelled blocks 4-6 wide with offset joints, as in pass 21.
- The riser split keeps only faces whose normal points down the flight.
- Studio: tread (122,125,121) Slate, riser (71,89,101). 20,384 triangles (see above).

### Raised runner slab (`build_runner22`)
- Y-up, N flight along -Z, d 16.5-28; rot4 gives one per stair foot. Layers:
  - silver rbox 7.2 x 0.55, bevel 0.28;
  - gold rim rbox 6.1 wide, 0.1 higher;
  - blue face 5.1 wide, 0.16 higher;
  - gold Y: a stem to 60 % of the length, two arms to the stair end, and two side lines;
  - a gem rbox 1.5 x 1.0 near the foot.
- Every layer is sheared up 0.35 toward the stairs (`_shear_up`).
- Studio: silver (205,210,215), gold Metal (160,135,45), face (58,82,160), gem Neon (90,220,240) at transparency 0.2. Placed at the scene origin, bottom on the floor.

### Lumpy island canopy (Studio)
- Hide the crown's leaf parts and keep the trunk.
- Add 3-4 K_Soft15K clones, each scaled to 0.5-0.66x the crown width, at r 0.32 x the crown width, base at y - 0.3h. One sits higher on the trunk tip.
- Colours come from the leaf maps: blue / purple / gold, or pale green (150,190,120) by tint.

### North island with aqueduct and falls (Studio)
- A K_Isl92 clone at scale 0.42, centred at (15, 128, -235).
- A K_Aque9 on top, seated by raycast onto the island.
- Two K_Fall8 sheets, 9 wide and down to y ≈ 0, at x 5 and 40, z -221. SmoothPlastic (228,242,250), transparency 0.2.

### Recessed notch planter (Studio)
- Per arch corner, in the frame d = (±1, 0, ±1).Unit:
  - back wall 4.7 x 1.7 at w 34.6;
  - floor 4.6 x 1.8 at w 33.8, y 8.85;
  - 3 ball pods of 1.2-1.6 at w 34;
  - trunk 0.55 x 7.5 plus a branch;
  - 2 blue lumps 3.6 tall at the top.
- Tunnel fill: a PointLight (150,235,185), brightness 2.2, range 9, at w 34.5, y 3.2.

### Lip ferns and stair-top fringe (Studio)
- **Ferns:** a visible Planting K_Fern clone scaled to 3.6 across, set by raycast. Leaf (100,150,48), rim (125,172,62).
- **Fringe:** K_Grass_leaf blades 1.3-2.6 tall in two rows at d 48.4 and 49.3, spacing 0.9, colour (120,185,75), no shadow.

### Lit Raid skull (Studio)
- Bone (235,150,100) SmoothPlastic, and a PointLight (255,150,115), brightness 6, range 22, 7 studs in front.
- Haze particle colour (145,95,86).
- Facade compensated for the fog: gable (138,29,0), spire and gothic (72,2,5), band (125,84,70).

## Files
- `fix/pass22.lua` (new). `fix/build_plaza.lua` (r22 added to `IMPORTS`).
- `tools/ae_kit.py`:
  - `build_stairs21` now takes a `tag`;
  - pass-22 section: `build_stairs22`, `_shear_up`, `build_runner22`, `build_scale22`, `build_all22`, `export_r22`.
- `kit/own/ae_kit_r22.fbx`: 7 meshes, imported by the lead. `ae_kit.blend` saved.
- `out/r22/` (set and contact sheet), `out/r22w/` (tools and working frames).
