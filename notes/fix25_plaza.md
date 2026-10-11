# Fix pass 25: Anime Expeditions spawn plaza (green-topped islands, glow cards on the Raid, slim runner Y, SE lawn and paving, lobed tree crown, standing ferns, sharp stair blocks)

This is the builder report for `notes/fix_brief25.md`. It answers the round-22 review `notes/verify22_plaza.md` (8.46/10, p3 at 9).

**Status by review item**

| Item | Status |
|---|---|
| 1 Islands | Done (Studio). Vines are hidden and the rock is warmer. A pale canopy fringe hangs on the near rim, there are pale ruin towers on the caps, and the cap trees are pale green. The N and S islands are moved 60 further out and 30 lower. The p1 band went from 52 off to **9**. |
| 2 Raid glow | Done. The bubble domes are hidden and replaced by 6 soft glow cards (own texture, `tex/ae_glow25.png`). The tower domes are glow pink. There are 4 more red spires, and the skull pillars and bone are retinted. Glow 26 -> 16, c3 tower 36 -> 20, skull 55 -> 23. |
| 3 Runner Y | Done (kit `K_RunY25`). Slim Y: 0.16 gold outline, arms to x ±2.05 (about 60 % of the face), fork about 40 % down the slab, long stem to the gem, plus the two long inner gold lines. Gold pixels: (182,173,74) against the reference's (187,172,74). |
| 4 E ground | Done. Carpet darkened, `Path24` slab hidden, three 7-wide grey paths, and a lawn wedge plus green patches south of the line z = 4 + 0.45(x - 55). p7 E green 9.0 -> 19.8 % (ref 26.6), E red 36.7 -> 23.0 % (ref 24.4); p8 ground 35 -> 14 off. |
| 5 Giant tree | Done. The new lobed crown (`K_Crown25`, 4 lobes) is green. The tree moved 34 in x and 30 in z, so in p2 the trunk now stands left of the gate, as in the reference. Crown, re-picked on the crown at the ref box (594,60): (96,149,139) against (98,156,145). |
| 7 Ferns | Done (kit `K_Fern25`). There are 16 standing clumps: lime by the fountain side of each flight's foot, plus blue (N, W), red (E) and lime (S) on the second tread's outer edge. c2 stair green went from 0.2 to 10.7 % (ref 7.5). |
| 8 Stairs | Done (kit `K_Stairs25`). The chamfer is 0.18 -> 0.08 and every steep face is split into the riser mesh. Riser 25 -> 11 off; tread 7. |
| 6, 9, 10 | Not attempted (time box). |

**Captures**
- **Final set:** `out/r25/r25_<cam>.png`, from capture_set2.py with the second frame kept. p3, p5, c3, p7 and p8 were re-captured after the last glow change. Contact sheet: `out/r25/contact.jpg` (v22 reference on the left, r25 on the right).
- **Working frames:** `out/r25w/<letter>_<cam>.png`.
  - `b_`, `c_`: Studio steps before the import.
  - `d_` onwards: after the import.
  - `z_`: copies of the final set.
- **Tools** (all in `out/r25w/`):
  - `box25.py`: the v22 review boxes, re-sampled from the v22 reference frames on every run.
  - `cap.sh`: two captures; the second one is judged.
  - `run.sh`: runs `fix/pass25.lua`.
  - `lrun.sh`: runs a Lua file in the practice studio.
  - `satall.py`: top-half saturation.
  - `sheet.py`: reference/practice side-by-side sheets.
  - `proj.py`: camera projection and unprojection, for picking world points from pixels.
  - `out/r22w/pick.py` was used for raycast picks.

**Rules kept**
- **Pictures only.** Every target was re-sampled from the `v22_*_ref.jpg` frames. The live reference studio was not used at all, not even screen_capture.
- **Own work only.** Own geometry and own texture, no computer use. The place was not saved and nothing was committed.
- **Blender.** `ae_kit.blend` was saved before building, before export and after export. Every mesh is under 20k triangles; the largest is `K_RunY25_gold` at 16,336.

**State at the end**
- `#workspace.Plaza:GetDescendants()` = **17524** (17338 after pass 24, plus `Pass25`).
- Workspace holds only **Camera, Terrain, SpawnLocation, Plaza**. The `ae_kit_r25` import was merged into `ServerStorage.Kit` by the pass-25 header and its scale cube destroyed. The selection was cleared.
- Atmosphere, Technology and post effects are unchanged.

**How to rebuild:** on the pass-24 build, run `sh out/r24w/run.sh`, then `sh out/r25w/run.sh`.
- **Idempotent.** Pass 25 restores everything it touched from its `P25*` attributes first: hidden parts, colours and materials (`P25Col`/`P25Mat`), and moved Pass24 pieces (`P25CF`).
- **Blocks:** `--SKY25`, `--TREE25`, `--GROUND25`, `--RAID25`, `--STAIR25`, `--RUN25`, `--FERN25`. The kit blocks skip cleanly without the kit.
- `fix/build_plaza.lua` has `ae_kit_r25` in `IMPORTS`.

## Results (final set, 5x5 means, max channel difference against the v22 reference box)

| box | v22 practice | r25 | target (v22 ref) |
|---|---|---|---|
| p1 band (620,30) | 52 (grey underside) | **9** (pale green cap tree / ruins) | (188,209,167) |
| p3 glow (600,220) | 26 | **16** | (233,119,117) |
| p3 skull (rep 726,34 / ref 720,40) | 55 | **23** | (210,107,93) |
| c3 Raid red (rep 1252,302 / ref 1350,280) | 36 | **20** | (149,54,58) |
| p2 crown (re-picked on the crown at the ref box 594,60) | 52 | **7** | (98,156,145) |
| p8 E ground (rep 1102,562 / ref 1162,528) | 35 | **14** | (197,89,76) |
| c4 riser (rep 430,628 / ref 430,648) | 25 | **11** | (85,103,115) |
| c4 tread | 7 | 7 | (186,191,185) |
| c4 runner Y gold (mean of all gold pixels in the Y window, both frames) | 24 | ~5 (182,173,74) vs (187,172,74) | (183,175,89) |
| c4 sky (702,62) | 14 (grey underside) | 79 (open blue sky) | (152,163,157) |
| c2 fern (930,590) | 138 | 134 (the clump stands just left of the box) | (114,166,54) |

The review's c4 gold box (616,620) now lands on the blue face beside the slimmer Y, so the Y gold was measured on its own pixels instead. The p2 crown box (902,48) now lands on sky, because the tree moved left.

**Coverage**, from my metric in `box25.py`. The numbers in brackets are the round-22 practice values.

| metric | ref | r25 |
|---|---|---|
| p7 E red | 24.4 | 23.0 (36.7) |
| p7 E green | 26.6 | 19.8 (9.0) |
| p8 E red | 49.3 | 51.2 (52.1) |
| p8 E green | 4.2 | 9.8 (6.8) |
| p7 W blue | 15.0 | 25.9 (unchanged; item 6 not done) |
| p8 W blue | 42.2 | 45.2 (unchanged; item 6 not done) |
| c2 stair green | 7.5 | 10.7 (0.2) |

**Top-half saturation** (r25 / ref): p1 98/85, p2 115/99, p3 113/101, p4 121/107, p5 107/93, p6 108/110, p7 86/87, p8 96/101, c1 117/97, c2 119/105, c3 95/91, c4 119/85.
- The 12-camera mean |rep - ref| is 12.7, worse than 10.1 for v22 practice.
- The rise comes mostly from p2 and c4. Moving the islands out and down opened the sky as the review asked, and our skybox is a more saturated blue than the reference's pale, cloudy sky.
- So the composition is closer (sky, tree left of the gate, islands at the corners, green tops with ruins), but this metric is worse. The next lever is the skybox (paler, more cloud) or a pale far island layer behind the Summon, not moving the near islands back.

## What I measured from the pictures
- **Runner Y (c4 ref zoom 480-980 x 440-793).** I projected through the c4 camera onto `_surf23`:
  - The arm tips are at row 540, x ±2.05: the inner gold lines, at about 61 % of the face width.
  - The fork is at row 590, d ≈ 37.0.
  - The outer stem width is 54 px at row 700, about 0.77 stud. Each gold line is about 10-12 px, about 0.16 stud.
  - The reference has two long inner gold lines that the arms run into. Ours had none.
- **Tree (p2).** The reference trunk is about 146 px left of the gate axis and thinner than ours, so it is further back. I moved it +34 x and +30 z. Empirically, +x shows on the left in p2.
- **E lawn line.** Unprojecting the p7 red/green boundary in the reference (pixels (1000,400) to (1452,470)) gives the ground points (48,13) to (109,30). The line z = 4 + 0.45(x - 55) keeps the p8 reference box (116,35) red.
- **Fern (c2).** The review box sits on the S flight's first tread at (8.2, 1.3, 29.7) (pick).

## Lessons (for the workflow vault)
1. **Seen from below, an island's colour is the colour of whatever hangs over its rim.** Moving the islands could not show their tops from eye level. What changed the read was pale foliage hanging over the near rim and pale trees and ruins on the cap: the p1 band went from 52 to 9 off with only a small move. From a low camera, dress the silhouette edge, not the top surface.
2. **Haze is pale, so match value and saturation, not just hue.** The first fringe green, (105,165,80), read as dark saturated green (93,166,114). Only a pale sage (195,220,150) reached the hazy reference band. Distant foliage in a stylised sky needs much lighter, greyer source colours than foreground foliage.
3. **Opening the sky trades one error for another.** Moving the near islands away removed the grey ceiling, but exposed the blue skybox. The reference's sky is pale cloud. Fix the background layer as well, or the saturation metric gets worse even though the picture reads better.
4. **Translucent spheres read as bubbles; flat soft-alpha cards read as glow.** The pink domes showed their silhouette edges. Camera-facing cards with a ragged radial alpha texture, at decal transparency 0.4-0.6, read as haze. When a glow box sits on a solid behind the haze (here the tower dome), also tint that solid: the box moved only once the dome was glow pink.
5. **Check axis handedness on the picture, not in your head.** I placed the tree using a computed camera right-vector and expected +x on the left. The capture showed where it really went. Make one move, capture, and read the direction off the frame before tuning.
6. **Split faces by normal so the stair fronts get their own colour.** The pass-24 riser split only caught front faces whose normal pointed at the plaza, so the visible fronts and chamfers stayed in the tread mesh and kept the tread colour. Splitting by "normal more than 60 deg from up" put every front, side and chamfer in the riser mesh. Riser went from 25 to 11 off with no other change.
7. **A thin outline needs a thinner stroke than you expect.** The reference's 0.16 gold lines and 0.5 core look bold at stair distance. Our 0.3 tubes round a 0.9 core read twice too big. Measure stroke widths in pixels and convert through the camera before modelling.
8. **A plant's shape decides which pixels it covers.** The fern's narrow base and wide top left the review pixel (at its base) bare even when the clump was right there. Use fronds that leave nearer to horizontal (35-60 deg) for a spray that covers the ground around the base.

## Objects built (for 5 Object Recipes)

### Slim runner Y with inner lines (`tools/ae_kit.py`: `build_runner25`)
- **Outline.** `_youtline24(ds 22.6, df 37.0, d1 39.3, X1 2.05, a 0.25)`, densified every 0.3 and draped on `_surf23` + 0.2 as a closed tube of r 0.08 (res 4).
- **Inner lines.** Two long lines at x ±2.30, from d 23.5 to 47.9, same tube.
- **Core.** Three ribbons, 0.5 wide, every 0.4 along their length, on the surface + 0.17. rot4.
- **Triangles.** Gold 16,336; core 400.
- **Studio.** Gold SmoothPlastic (124,117,54), core (25,40,110). `Gem24_gold` is recoloured to the same gold.

### Lobed tree crown (`build_crown25`)
- Four lobes, at the 3 `K_Tree24` limb tips (pushed out 2) and the top (+6). Each lobe has 5-6 icospheres (subdivision 3, r 5-8, top lobe ×1.2), squashed 0.7 in y and jittered only ±6, so the gaps between lobes stay open.
- **Rim.** On every second lump, the upper half of a subdivision-2 sphere at 1.05 r, raised 0.25 r.
- **Triangles.** Leaf 6,720; rim 432.
- **Studio.** Origin = trunk foot (10, 4, 148), yaw 0.3. Leaf (135,190,150), rim (170,215,180), SmoothPlastic, no shadows. The `Tree24` crown is hidden and the bark moved with the crown.

### Standing fern clump (`build_fern25`)
- **Fronds.** 12 fronds at azimuth 30° ±0.2 rad and elevation 50-75°, each 3.0 × 0.8-1.15 long. Height h(s) = s·sin(el) - 0.5·s²/L·(0.6 + 0.4·cos el), so each frond rises and droops a little.
- **Blade.** 14 segments, width 0.45·sin(πt)^0.6, alternating ×1.25 and ×0.8 for serration. Two sheets (one facing up, one down) so it renders from both sides.
- **Size and triangles.** About 3.0 × 1.9 tall; 672 triangles.
- **Studio.** Scale 1.2-1.5; placed by raycast onto the tread. Lime (95,150,35), blue (40,90,210), red (190,45,40).

### Sharp stair blocks (`build_stairs25`)
- The pass-24 layout (7 risers, 4.5 blocks, 0.2 gaps) with chamfer 0.08.
- Faces with normal.y < 0.5 go to `_riser`; the rest go to `_stone`. Joint slab top is 0.1 below the tread.
- **Triangles.** Stone 2,688; riser 5,760; joint 2,464.
- **Studio.** Tread (126,129,125), riser (100,106,103), joint (70,85,95), all SmoothPlastic. Stone and riser collide.

### Island dressing (Studio, on the pass-24 kit islands)
- Vines hidden; rock Slate (150,138,118).
- Five canopy-only `K_Soft14U` fringes on the near rim, 5 below the grass top, scale 1.3 ± 25 %: leaf (205,228,170), pad (185,210,155), rim (225,240,190).
- A `K_Tower9` and a `K_Ruin8` in pale stone (226,222,205) on each cap. Cap trees (195,220,150) / (220,236,185).
- N islands moved z -60 and y -30; S islands z +60 and y -30. No shadows.

### Raid glow cards (Studio)
- `tex/make_ae_tex25.py` makes `tex/ae_glow25.png`: a white radial alpha with fBm-ragged edges. Uploaded as `rbxassetid://105673126145689`.
- 6 transparent Parts facing -x (the plaza), at x 150-158, y 20-44, z ±16-34, 22-34 wide. Each has a Front Decal, Color3 (255,165,155), Transparency 0.6.
- The `K_RTower7` domes are SmoothPlastic (225,105,100). Skull bone is (150,62,48); pillars are Slate (140,42,40).
- Four `K_Spire` at scale 1.4-1.7 flank the facade, in Slate (150,44,34).

### E lawn wedge and paths (Studio)
- **Lawn.** An 85 × 40 Grass Part (88,138,52) at y 6.12, with its north edge on the line z = 4 + 0.45(x - 55) from x 56. Zoning patches south of the line (x 52-140) are recoloured to the same lawn.
- **Red.** The carpet and the red patches are (132,47,30).
- **Paths.** Three Slate paths (120,118,112), 7 wide, at y 6.3: E axis from x 78 to 150, and two diagonals to the NE.

## Files
- **New:** `fix/pass25.lua`, `tex/make_ae_tex25.py`, `tex/ae_glow25.png`, `kit/own/ae_kit_r25.fbx` (9 meshes including the scale cube) and `kit/own/ae_kit_r25_centres.json`.
- **Changed:** `fix/build_plaza.lua` (`ae_kit_r25` in `IMPORTS`) and `tools/ae_kit.py`. The pass-25 section has `build_runner25`, `build_crown25`, `build_fern25`, `build_stairs25`, `build_scale25`, `r25_info`, `build_all25` and `export_r25`.
- `ae_kit.blend` saved.
- `out/r25/` (set and contact sheet), `out/r25w/` (tools and working frames).

## Next (not done)
- **Sky.** A paler skybox or a far pale island layer behind the Summon (c4 sky box is 79 off; top-half saturation is high in p2 and c4).
- **Raid.** From p5 the glow cards still read as a red wash over the facade. Try smaller cards at the edges and dark bare branches in front.
- **Fern.** Re-export with flatter fronds (35-60°) so it covers its base.
- **Not attempted:** item 6 (W canopy mix, W blue 25.9 vs 15), item 9 (gate glazing, Story crest) and item 10 (Summon/Boss Rush facades, faceted bollards, translucent falls).
