# Fix pass 27: Anime Expeditions spawn plaza (less saturated N leaves, lobed tree crown, jointed rounded stair blocks, falls, gate/ring/Raid colours, mixed W trees)

Builder report for `notes/fix_brief27.md`, answering the round-24 review `notes/verify24_plaza.md` (8.83/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...`, reference studio `97946bf6-...` (screen_capture only, never execute_luau).
One kit, `kit/own/ae_kit_r27.fbx` (stairs), imported by the lead; everything else is Studio-side and own textures.

## Status by review item

| Item | Status |
|---|---|
| 1 Leaf saturation | Done, with new leaf colour maps (the leaves have no vertex colours, see below). c4 top-half saturation 111 -> **84** (ref 81), c1 113 -> **98** (ref 93). |
| 2 Crown | Done. 8 dark, 4 mid and 2 lit lobes from our own `K_Fluffy_leaf` around the Crown25 shell. Reads as a dark lobed tree in p2/p6. Crown box 12 -> 11. |
| 3 Islands | Partly done. 3 pale translucent falls and 5 rounded lumps on the N island's S lip. The c4 canopy box is 16 -> 13. The c3 island box is still 53 (it samples sky through the cap tree). |
| 4 Stair joints | Done. Proved by tint first, then kit r27 (rounded blocks, 0.3 gaps, recessed dark joint). c4 riser 7 -> **2**, tread 9 -> **4**. |
| 5 West half | Partly done. A third of the West16 lagoon trees now use the gold leaf map. GroundS is now Grass (30,58,0). p7 W blue 27.2 -> 24.1 (ref 10.7). |
| 7 Gate panels / Story ring | Colour done: panel 51 -> **7**, ring 34 -> **4**. No crystal basins, crest or mullions. |
| 8 Raid brick | Colour done: 61 -> **21** (c3). No gothic door or branches. |
| 10 Ground foliage | Lime fern 38 -> **7**. 2 floor-level red/blue litter pieces hidden (the c1 red flakes). The c2 lime floor leaves are kept: the reference has them too. |
| 6, 9 | Not attempted. |

## Captures
- **Final set:** `out/r27/r27_<cam>.png`, second frame of `capture_set2.py`, normalised (see below). p2 and p6 were re-captured after the last crown change. Contact sheet `out/r27/contact.jpg` (v24 reference left, r27 right).
- **Reference frames:** the round-24 judged frames stayed on the Shadow PC. They were re-captured here with `cams.json` (screen_capture only) into `out/verify24/v24_<cam>_ref.jpg`.
- **Baseline:** pass-26 state, `out/r27w/base/r26_<cam>.png`. Working frames: `out/r27w/<letter>_<cam>.png`. Full sets: `out/r27w/d/` (all leaves desaturated) and `out/r27w/e/` (N half).
- **Frame sizes:**
  - On this PC Studio captured **1284 x 793** (not 1452 x 793): same height and vertical FOV, with 84 px cropped from each side.
  - `box27.py` subtracts 84 from each review x and clips the metric boxes. With that shift the baseline reproduces the review values (c4 riser 7, tread 9; p2 panel 51; p4 ring 34).
  - **After the lead's Import 3D the viewport became 1266 x 418.** `out/r27w/norm.py` scales such frames to height 793 (same vertical FOV) and centre-crops them to 1284. `cap.sh` and `full.sh` call it.
  - So the post-import frames, including all of `out/r27/`, have about half the resolution. Thin features such as the p5 runner-Y lines (56 -> 77) measure worse partly from blur.
  - The reviewer should restore the Studio layout (the bottom panel) before judging.
- **Tools (`out/r27w/`):** `run.sh` (runs `fix/pass27.lua`), `lrun.sh <lua>`, `cap.sh <cam> <tag>`, `full.sh <tag>`, `box27.py`, `pick.py` (takes review 1452 coordinates), `sh.py`, `norm.py`, and the proof tints `tint2.lua` (pass-25 stairs) and `tint3.lua` (r27 stairs), restored with `untint.lua`.

## Results (5x5 means; max channel difference to the v24 reference box; baseline = pass 26 here)

| box | pass 26 | r27 |
|---|---|---|
| c4 riser | 7 | **2** (85,104,112) |
| c4 tread | 9 | **4** |
| c4 rim gold | 9 | 10 |
| c4 canopy | 16 | 13 |
| p1 island (a 9) | 11 | 11 |
| p2 sky | 43 | 42 |
| p2 crown | 12 | 11 |
| p2 panel | 51 | **7** |
| p3 glow (a 9) | 6 | 10 (untouched; capture noise and resolution) |
| p4 ring | 34 | **4** |
| p7 lawn S | 35 | 40 (R/G now within 7; B +40 is haze on a high camera) |
| c1 blue clump shadow side | 95 | 69 (desaturated leaves lift it) |
| c2 fern | 38 | **7** |
| c3 Raid | 61 | **21** |
| c3 island | 52 | 53 |

**Top-half saturation (ref / pass 26 -> r27):**

| cam | ref | pass 26 | r27 |
|---|---|---|---|
| p1 | 81 | 88 | 77 |
| p2 | 99 | 86 | 83 |
| p3 | 101 | 91 | 86 |
| p4 | 107 | 104 | 99 |
| p5 | 91 | 102 | 91 |
| p6 | 112 | 92 | 89 |
| p7 | 85 | 78 | 71 |
| p8 | 103 | 87 | 80 |
| c1 | 93 | 113 | 98 |
| c2 | 109 | 109 | 101 |
| c3 | 91 | 94 | 89 |
| c4 | 81 | 111 | 84 |

- The mean |rep - ref| moved 11.9 -> 10.3. c4, c1 and p5 are now on target.
- The S/W/E/high views (p2, p3, p6, p7, p8) were already under the reference and remain under. Their leaves were left alone. The rest of the drop comes from the lower-resolution frames, the gold lanterns, the W gold trees and the new lawn.

**Coverage:**
- p7 W blue 27.2 -> 24.1 (ref 10.7). p8 W blue 36.0 -> 33.5 (ref 38.7).
- E green / E red: p7 21.5 / 17.7, p8 11.5 / 51.5. Unchanged.
- c2 stair green 6.8 (ref 8.2).

## What I measured / proved
- **Leaves carry no vertex colours.**
  - Every `*_leaf` object in `ae_kit.blend` has 0 colour attributes. The colour comes from the SurfaceAppearance ColorMap (our own `tex/leaf14` spray maps) multiplied by SA.Color.
  - So the "re-export" was done on our own maps with `tex/make_ae_tex27.py SAT VAL TAG`.
  - Step a (0.75 / 1.10, uploaded on the Shadow PC) took c4 111 -> 92.
  - Step b (0.62 / 1.12, uploaded here: blue 121845655626185, gold 81552654586566, purple 104105154617661), plus the blue-palm SA tint at saturation x0.55, took c4 to 83.
- **Desaturating every leaf overshot the other views.** p2 went 86 -> 82 (ref 99), p6 92 -> 88 (ref 112), p8 87 -> 78 (ref 103), p7 78 -> 70 (ref 85).
  - Final rule: only leaves with z < 0 and x > -50 change. Those are the N/NE trees that c4, c1, p1, p5 and c3 look at. The far NW stays, because p7 and p8 see it from above.
  - The notch crowns within r 45 of the hero also keep their maps, because p2 is a 9.
- **Hue split, c4 top half (pass 26 -> r27, ref):** blue 60 -> 46 (31), gold 34 -> 22 (18), purple 8 -> 5 (1). The pavilion gold `K_Hero_goldLan` is at saturation x0.6.
- **Stairs, first proof (pass-25 parts):** `tint2.lua` tinted stone red, riser green and joint blue.
  - Every tread pixel in c4/c2 is `Stairs25_stone`.
  - The blue joints DO show between the 4.5-stud blocks when tinted. Untinted they vanish: the gap is 0.2, the joint top sits only 0.1 below the tread and is lit, and the 0.08 chamfer gives no shading.
- **Stairs, second proof (r27 parts):** `tint3.lua` showed the c4 riser box is `Stairs27_riser`, the block fronts. (54,65,73) rendered (53,70,84). These faces get no sun, unlike the old joint-slab fronts, which rendered at x1.58.
  - Set (78,90,95), which renders (85,104,112).
  - Tread (118,122,120) renders (188,195,188).
  - Edge (100,104,103). Joint (48,58,66): (26,31,36) read as black slots.
- **Colour ratios on the picked parts (set -> rendered):**
  - `K_Trip10_teal` (40,140,140) -> (41,150,152).
  - `Portal23_silver` (205,212,225) -> (157,162,197).
  - Raid11 Brick (88,47,56) -> (134,98,106). The Brick texture adds about 50 to G and B, so the second step needed G/B near 15: (165,14,18).
  - Fern26 lime (118,165,58) -> (142,198,55).
- **p2 sky box:** a lit crown lobe on the -x side covered the p2 sky box (43 -> 74). Lit lobes are now only on the +x side, and the box is back to 42.
- **Waterfalls:** the first positions sat on the c4 canopy box (16 -> 27). Moved to x -85 / 34 / 72, where the reference falls are (right of centre in c4).
- **W box:** picks inside the p7 W box land on the `Pass16.West16` lagoon trees, a sand disc and grass patches.
  - Pass 26's Color tint on those trees did nothing, because Color multiplies the map. Swapping the map works.
  - With gold and purple on 2 of every 3 trees, p8 W blue fell to 31 (ref 38.7), so only 1 in 3 turns gold.
- **c2 floor leaves:** the re-captured c2 reference frame shows lime leaves on its floor, bottom left. They are kept. Only the floor-level red/blue litter (c1) is hidden.

## Built (method)
`fix/pass27.lua`: idempotent, restores every P27* attribute first, and new pieces go in `Plaza.Pass27`. It merges `Workspace.ae_kit_r27` into `ServerStorage.Kit` (scaled by `K_Scale27_stone`) when present. Blocks:
- **LEAF27:** map swap to the leaf27b maps plus the palm SA HSV step, N/NE only (`zMax 0`, `xMin -50`, `keepR 45`).
- **GOLD27:** `K_Hero_goldLan` saturation x0.6, value x1.05.
- **TREE27 (`Crown27`):** `K_Fluffy_leaf` lumps, CastShadow off, opaque.
  - 8 dark (48,92,74) on an ellipse (r 30 x 24), 9 below the crown centre, alternating +3.
  - 4 mid (78,132,108) on the flanks.
  - 2 lit (118,186,138) on top, +x side only.
- **COL27:** panel (90,159,171), Story ring (161,190,233), Raid brick (165,14,18), lime fern (91,133,47).
- **FALL27:** `K_Fall8_fall` ribbons, 6 wide, 45/50/37 tall, (205,232,246), T 0.35.
  - Each hangs from the lip of `Isl24_4`, found by a downward raycast march from the plaza side.
  - The march uses an Include filter, and CanQuery is set temporarily and restored.
- **ISL27:** 5 `K_Fluffy_leaf` lumps, 10-15 studs, (104,152,72), on the same lip.
- **FLOOR27:** hides floor-level (y < 1) non-green `Planting.K_Litter`.
- **WEST27:** 1 in 3 `West16` K_Soft15B trees get the gold map. GroundS becomes Grass (30,58,0); it was LeafyGrass (42,57,0).
- **STAIR27:** `Stairs27_stone/edge/riser/joint` placed at the identity. `Stairs25_*` are hidden. The joint has CanCollide/CanQuery off.

**Kit r27** (`tools/ae_kit.py`, pass-27 section: `build_stairs27`, `build_all27`, `export_r27`, `r27_info`):
- Same 7-riser footprint as pass 25.
- Blocks W/4 (3.35); offset rows W/8 + 3 x W/4 + W/8.
- Bevel 0.3 with 2 segments; 0.3 gaps.
- Split by face normal: `stone` (ny >= 0.92), `edge` (the rounded bevels), `riser` (ny < 0.25).
- The joint slab is recessed 0.4 and sits 0.06 behind the block fronts, so its colour is independent of the risers.
- 4 flights merged (rot4). Triangles: riser 16368, edge 7936, stone 2480, joint 2464, cube 44. Centres are in `kit/own/ae_kit_r27_centres.json`.
- `ae_kit_r27` was added to the IMPORTS of `fix/build_plaza.lua`.

## Lessons (for the workflow vault)
1. **Check what carries a colour before planning a re-export.** The brief said vertex colours, but the leaves have none: the colour is a SurfaceAppearance map. One query of the .blend (`len(o.data.color_attributes)`) settles it. Then fix the map (own texture, re-upload), not the mesh.
2. **A global colour fix moves every camera.** Desaturating all leaves fixed c4/c1 but pushed p2/p6/p7/p8 further under the reference. Split the change by what each camera looks at (here the N half, minus the far NW seen from above) and re-measure all twelve.
3. **Invisible joints are a contrast problem.** The blocks already existed. A 0.2-stud lit gap is about 2 px at a grazing angle. Wider gaps (0.3), a recessed joint with its own colour, and rounded edges that shade make the seam read.
4. **Splitting a mesh by face normal gives free colour control.** One generated block set becomes tops / rounded edges / fronts / joints, each a MeshPart with its own colour. That made the riser colour (2 off) and the tread colour (4 off) independent.
5. **When the geometry changes, re-prove which part owns the pixels.** The c4 riser box moved from the joint-slab fronts (pass 26) to the block fronts. Those faces get no sun, so the lit x1.58 ratio no longer applied. One red/green tint capture showed it.
6. **A new piece can steal another camera's review box.** A waterfall took the c4 canopy box, and a lit crown lobe took the p2 sky box. After adding geometry, re-read every box in the cameras that can see it.
7. **The capture size follows the Studio layout.** The frame width differs between PCs (1452 vs 1284), and an import changed the viewport to 1266 x 418. Vertical FOV is constant, so frames can be normalised by height. Verify the normalisation by reproducing a few review values, and note the lost resolution for thin features.
8. **The reference can contradict the review.** The review asked to clear the c2 floor leaves, but the reference frame shows lime leaves on its own floor. Re-check a "remove" item against the reference picture before deleting.
9. **Haze limits colour matching from high cameras.** The p7 lawn reached R/G within 7, but B stays about 40 high from the atmosphere at that distance. Judge high-camera ground colour on R/G, or accept the haze.

## Objects built (for 5 Object Recipes)
- **Jointed rounded stair blocks (`build_stairs27`):** rbox blocks (bevel 0.3, 2 segments, 0.3 gaps, offset rows) over a recessed joint slab, split by normal into stone/edge/riser meshes. Colours: tread (118,122,120), edge (100,104,103), riser (78,90,95), joint (48,58,66).
- **Lobed crown dressing:** a ring of dark leaf lumps under and around a smooth crown shell, a few mid lobes on the flanks, lit lobes on top. It turns a pale mass into a tree silhouette.
- **Island-lip falls:** a thin ribbon mesh hung from a raycast-found lip, pale (205,232,246) at T 0.35.
- **Desaturated leaf maps:** `tex/make_ae_tex27.py`, HSV saturation x0.62, value x1.12 on our own spray maps (`tex/leaf27/leaf27b_*`).

## State at the end
- `#workspace.Plaza:GetDescendants()` = **17575** (pass 26: 17544). Workspace holds only Camera, Terrain, SpawnLocation and Plaza; `ae_kit_r27` was merged into `ServerStorage.Kit`.
- Nothing was saved or committed. `ae_kit.blend` was saved after the r27 build and export.
- Atmosphere, Technology and post effects are unchanged; Haze was not tested. `fix_lighting.lua` was not re-run, because the Density 0.28 vs 0.2 note from pass 26 still stands.
- **How to rebuild:** on the pass-26 build, run `sh out/r27w/run.sh`. It is idempotent.

## Reference use
- Reference studio: screen_capture only (`capture_set2.py` with `cams.json`), to re-create the v24 frames. Every target was re-sampled from those frames.
- No execute_luau in the reference and no position reads. `ae_reference.blend` was not opened. No computer use. Own meshes and images only.

## Next
- **Runner Y at distance (item 6):** wider gold bands and core (mesh).
- **Bollard heads and the Summon / Boss Rush facades (item 9).**
- **Gate crystal basins, Story crest and ivy, Raid gothic door and branches.**
- **W half:** pools and stone circles in place of the sand discs. The p7 W blue (24 vs 11) comes from more than West16; pick deeper in the box.
- **c3 island box:** it samples sky through the Isl24_4 cap tree. A denser canopy there would also help the c4 view.
