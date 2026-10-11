# Fix pass 26: Anime Expeditions spawn plaza (own paler skybox, real riser colour, island canopies and corners, crown, lighter flatter ferns, runner rim gold)

Builder report for `notes/fix_brief26.md`, answering the round-23 review `notes/verify23_plaza.md` (8.67/10; p1, p3, p7, c3 at 9).
Studio-only pass: **no new meshes** (time box). The ferns re-use `K_Fern25_leaf` at a new non-uniform scale.

**Status by review item**

| Item | Status |
|---|---|
| 1 Sky | Done. Own skybox v4 (`tex/make_ae_tex26.py`, variant d), uploaded with upload_image. Top-half saturation mean abs diff over 12 cams: 12.5 to **9.9**. Leaf desaturation not done (see Lessons 3). |
| 2 Islands | Partly. Cap-tree leaves are yellow-green, the aqueduct above the Summon is darker (40 to **7** off), and the four grey corner undersides are moved out of p1/p2/p3. Isl24_3 is moved off the p2 crown. No new lumps or waterfalls. |
| 3 Crown | Colour only: the islands behind are gone and it reads as a tree. Box 8 to 13 off (now darker, as asked for shadow sides). |
| 4 Stairs | Done. Found the real riser part: riser **34 to 7** off. The chamfer mesh is now a pale tread-edge highlight. |
| 5 Ferns | Done. 0.8x wide, 0.5x tall, lighter: clump **(150,196,78)** vs ref spray (145,187,73). c2 stair green 10.8 to **5.9** (ref 7.5). c1 floor splats hidden, standing blue/red clumps in their place. |
| 6 Runner | Rim colour only: **49 to 3** off. Y stroke width not changed (mesh). |
| 7 W canopy | Tested a tint on the lagoon trees: no effect on the metric (W blue 25.5 to 25.8). Switched off; recorded below. |
| 8-10 | Not attempted. |

## Captures
- **Final set:** `out/r26/r26_<cam>.png` from `capture_set2.py` (second frame kept); c1 and c2 re-captured after the last fern change. Contact sheet `out/r26/contact.jpg` (v23 reference left, r26 right).
- **Working frames:** `out/r26w/<letter>_<cam>.png` (`a`, `d` sky variants; `t`, `t2` tint tests; `e`-`i` pass-26 steps).
- **Tools (all `out/r26w/`):**
  - `box26.py`: the v23 review boxes, targets re-sampled from `out/verify23/v23_<cam>_ref.jpg` on every run (all reproduce the review values).
  - `cap.sh`: two captures, the second judged with box26.
  - `run.sh`: runs `fix/pass26.lua`. `lrun.sh`: runs any Lua file in the practice studio.
  - `up.sh <v>` / `setsky.sh`: upload a sky variant three faces per call, then set its ids.
  - `pick2.py`: raycast pick that temporarily makes every visible Plaza part queryable (many background pieces have CanQuery off, so `out/r22w/pick.py` misses them), then restores CanQuery in the same script.
  - `skystat.py`, `satbreak.py` (top-half saturation by hue class), `sheet.py`.

## Results (5x5 means; max channel difference to the v23 reference box)

| box | v23 practice | r26 | target (v23 ref) |
|---|---|---|---|
| c4 riser (rep 402,507 / ref 430,648) | 34 | **7** (90,110,119) | (85,103,115) |
| c4 tread (400,690) | 7 | 9 | (186,191,185) |
| c4 rim gold (rep 562,566 / ref 640,560) | 49 | **3** (185,177,86) | (183,175,89) |
| c4 above Summon (rep 642,82 / ref 702,62) | 40 | **7** (150,162,166) | (152,162,159) |
| p1 band (620,30), a 9 camera | 11 | **7** | (189,209,165) |
| p2 sky (762,22) | 112 | 42 (now pale blue; the ref box is on a cloud) | (172,215,236) |
| p2 crown (594,60) | 8 | 13 (92,149,133) | (100,156,146) |
| c3 island (rep 42,62 / ref 152,102), a 9 camera | 21 | 20 | (152,192,134) |
| c2 fern (clump's own green pixels, box 760-960 x 520-680) | ~51 | **~9** (150,196,78) | (145,187,73) |
| p3 glow (rep 642,172 / ref 600,220), a 9 camera | 24 | 27 (untouched; capture noise) | (224,112,111) |
| p7 lawn S (900,620), a 9 camera | 29 | 32 (untouched) | (91,126,55) |

**Top-half saturation** (ref / v23 practice -> r26): p1 84/97->92, p2 99/114->90, p3 101/110->95, p4 106/120->107, p5 93/107->102,
p6 111/106->92, p7 87/83->80, p8 101/92->90, c1 97/117->113, c2 104/118->106, c3 91/93->91, c4 85/118->116.
Mean |rep - ref| **12.5 -> 9.9**. The sky now errs both ways: p2, p6, p8 are below the reference, and c1/c4 stay high.
Coverage: p7 W blue 25.8 (ref 15.0), E green 19.5 (26.6), E red 23.3 (24.5); p8 W blue 45.2 (43.0); c2 stair green 5.9 (7.5).

## What I measured from the pictures
- **Sky.** Player cameras look almost level, so the top half of every frame is 0-35 deg elevation. The pass-12 ramp reached its cyan MID there.
  - In the reference sky pixels (b >= 200), 44-50 % are clear blue and 30-46 % are white cloud; ours had 55-71 % clear and 10-23 % cloud.
  - The reference's clear blue is less green: about (55-65, 145, 232) against our (61, 177, 236).
  - Variant a (haze to 16 deg, pale MID) overshot: p2 fell to 85 against 99, a white sky.
  - Variant d (haze to 10 deg, azure MID (0.38,0.62,0.95), TOP (0.24,0.50,0.94), cloud threshold 0.41 low / 0.47 high) gave p2 90, p4 106 (ref 106), p1 91.
- **Saturation by hue (c4 top half):** blue 62 vs 39 and gold 38 vs 16 make up the excess. It comes from the vertex-coloured blue trees and the gold tree and pillars, not from the sky (variant d moved c4 only 118 to 116).
- **Riser.** I tinted `Stairs25_riser` red and `Stairs25_stone` green. In c4 the risers stayed grey-blue, and only thin red nose lines showed. Then I tinted `Stairs25_joint` red, and the riser box read (255,43,45). The joint slab's front faces are the risers. (70,85,95) renders (109,137,149), about x1.58 lit. (54,65,73) renders (90,110,119).
- **Islands.**
  - The c4 above-Summon box is the Sky22 aqueduct `K_Aque9_white` (160,166,160). (108,114,110) renders (150,162,166).
  - The p1 band and the c3 island box both fall on Isl24_4's cap tree `K_Soft14C`, on the leafPad. The pick lands a few pixels off: the c3 value only moved when the pads changed.
  - The p1 band wants pale (189,209,165), and c3 wants yellow-green (152,192,134) on the same pad. I kept the pads pale (p1 is a 9) and turned only the leaf yellow-green.
- **Corners.** The grey undersides at the top corners of p1, p2 and p3 are the old `Islands.K_Isl91` at the four diagonals (rock (185,200,205)). I moved them 60 outward along their diagonal and 25 down (5 matched |x|,|z| > 120).
- **Crown.** `Isl24_3` stood directly behind the crown in p2, at x ~ -49, z 367. It is moved 60 W with its Sky25 dressing (z > 340).

## Lessons (for the workflow vault)
1. **Prove which part owns the pixels before recolouring.** Two passes darkened `Stairs*_riser` and the riser barely moved, because the visible riser faces belonged to the joint slab under the blocks. One capture with a suspect part tinted pure red settles it: tint, capture, restore. Raycasts are not proof: mesh hulls and CanQuery-off parts send them to the wrong part.
2. **A skybox only shows its 0-35 deg band at eye level.** Player cameras look nearly level, so the top half of every frame is 0-35 deg elevation. Tune the haze height and the cloud cover in that band; the zenith colour hardly shows. Go one step at a time: a too-pale band at once turns the sky white (p2 fell 14 points below the reference).
3. **Vertex-coloured meshes cannot be desaturated from Studio.** `Color` multiplies the vertex colour, so it can darken or shift a hue but cannot add grey. Lower leaf saturation needs paler vertex colours in the kit and a re-export. Check whether a mesh is vertex-coloured (Color white, no TextureID) before planning a Studio-side colour fix.
4. **One surface can carry two contradictory targets.** The same cap-tree pad is the p1 band (pale) and the c3 island (yellow-green), seen at different distances through haze. Split the mesh by material/token (leaf vs pad), and keep the camera that already scores well.
5. **Lit faces render about 1.6x their colour here.** The sun-facing riser read (70,85,95) as (109,137,149). Divide the target by the measured ratio, then make one correction step.
6. **Check a metric's box before changing a region.** Tinting 188 lagoon-tree leaf parts changed W blue by 0.3: the p7 W box is filled by other trees. Pick a few pixels inside the metric box first.
7. **Fern spray shape by scale.** A non-uniform MeshPart size (0.8 wide, 0.5 tall) turns a cone of fronds into a low spray without a new mesh. It also leaves the old review box bare, so measure the clump's own pixels.

## Objects built (for 5 Object Recipes)

### Own skybox v4 (`tex/make_ae_tex26.py`, `tex/sky/ae_sky26d_*.png`)
- Same direction-based method and face table as pass 12 (`make_ae_tex12.py`): every face pixel becomes a view direction.
- **Ramp:** HOR (0.86,0.91,0.95) at 0 deg -> HAZE (0.64,0.80,0.95) at 10 deg (power 1.3) -> MID (0.38,0.62,0.95) at 35 deg -> TOP (0.24,0.50,0.94) at 80 deg.
- **Clouds:** fbm on a deck-flattened direction. The threshold rises with elevation, 0.41 below 10 deg to 0.47 at 48 deg, so the low sky carries the most cloud. Band 1-80 deg. Cloud bottoms (0.86,0.90,0.95), white cores.
- **Ids:** Up 86697674728745, Dn 76842875409340, Ft 94655773202113, Bk 132148118311790, Lf 97641134518184, Rt 132849943400915. Set in `fix/pass26.lua` and in `fix/fix_lighting.lua`; the pass-12 ids are kept there in a comment.
- Variants a-c are kept in the script for comparison. Only a and d were uploaded.

### Stair stone colouring (Studio, on the pass-25 kit stairs)
- `Stairs25_joint` (its front faces are the risers, its top shows in the 0.2 gaps as joints): (54,65,73).
- `Stairs25_riser` (noses and chamfers): (168,172,166) as the tread-edge highlight.
- Tread is unchanged at (126,129,125).

### Fern spray (Studio, re-using `K_Fern25_leaf`)
- 18 clumps, size = kit size x scale x (0.8, 0.5, 0.8), with the centre offset scaled the same way. Placed by raycast.
- Colours: lime (118,165,58) at the 8 flight feet, blue (60,110,215) on the N/W, red (200,60,52) on the E, lime on the S second-tread edges, plus blue (14.5,-26.5) and red (26.5,-14.5) where the c1 splats were.
- The 8 `Pass19.K_Splat17_*` floor splats are hidden.

### Island dressing changes (Studio)
- Cap-tree and fringe `leaf` (185,255,70); pads and rims keep their pass-25 colours.
- Sky22 aqueduct white parts (108,114,110).
- `Islands.K_Isl91` at the diagonals: +60 along (x,z) and -25 y. `Isl24_3` and its Sky25 dressing: x -60.
- Crown25 leaf (118,186,138), rim (148,206,166), opaque.
- `Runner24_rim` (110,104,50).

## State at the end
- `#workspace.Plaza:GetDescendants()` = **17544**: the pass-25 count of 17524, plus `Pass26`, `Fern26` and 18 ferns. Workspace holds only **Camera, Terrain, SpawnLocation, Plaza**. The selection is cleared.
- Nothing was saved or committed. `ae_kit.blend` was not touched (no new meshes).
- Atmosphere, Technology and post effects are unchanged; Haze was not tested.
- **Note for the lead:** the live Atmosphere Density is 0.28, but `fix_lighting.lua` writes 0.2. Do not re-run fix_lighting without deciding which value is meant.
- **How to rebuild:** on the pass-25 build, run `sh out/r26w/run.sh`. It is idempotent: everything pass 26 touched is restored from its `P26*` attributes first.
- **Blocks:** `--SKY26`, `--STAIR26`, `--ISL26`, `--TREE26`, `--FERN26`, `--WEST26` (off), `--RUN26`.

## Reference use
- Every target was re-sampled from the `v23_*_ref.jpg` frames.
- The live reference studio was not used at all: no execute_luau, and not even screen_capture.
- No computer use. Own images only.

## Next
- **Saturation (c4 116 vs 85, c1 113 vs 97).** Re-export the blue/purple/gold leaf kits with about 10-15 % less saturated vertex colours. Studio cannot do it (Lesson 3).
- **Sky.** p6 (92 vs 111) and p2 want a little more blue near 25-35 deg. Try MID at 28 deg in a variant e, and re-check c4/c1.
- **Islands.** Rounded 3-5 lump canopies and translucent falls (mesh). The c3 island stays 20 off while the p1 pad stays pale.
- **W canopy (item 7).** The W blue in p7 comes from `Pass13.Trees13` / `StoryCanopy16`. Pick inside the metric box before choosing which trees to replace.
- **Runner Y stroke (item 6).** Wider gold outline (mesh). Items 8-10.
