# Fix pass 21: Anime Expeditions spawn plaza (skyline, west blue, arch notch, stair blocks, grass, basins)

Builder report for `notes/fix_brief21.md`, answering the round-18 review `notes/verify18_plaza.md` (7.83/10).

**Status by review item**

| Item | Status |
|---|---|
| 1 Background | Done, except the aqueduct. Atmosphere haze was tested and rejected. |
| 2 West blue | Done, but p8 is still above target. |
| 3 Arch notch, slate, ledge | Done. Fountain forward and the narrower opening not done. |
| 4 Stair blocks | Done (new kit mesh). |
| 5 Grass clumps and lawn strip | Done. |
| 8 Basins | Done. |
| 10 c1 splats | Done. |
| 6 Arms and runners | Not attempted. |
| 7 Raid glow and skull | Not attempted. |
| 9 Gate and Summon facades | Not attempted. |
| Pineapple | Not attempted. |

**Captures**
- Final set: `out/r21/r21_<cam>.png` (12 cameras, `capture_set2.py`, second frame kept).
- Contact sheet: `out/r21/contact.jpg`, with the v18 reference on the left and r21 on the right.
- Working frames: `out/r21w/<letter>_<cam>(_a).png`. `a_` is the baseline; `b_` to `n_` are Studio-only steps; `o_` to `q_` come after the kit import.

**Rules kept**
- Pictures only. Targets were re-sampled from `out/verify18/v18_<cam>_ref.jpg` on every run.
- I captured the reference studio twice (`out/r21w/ref_north.png`, `ref_west.png`), with screen_capture only, to see the skyline arcades and domes from more angles. Nothing was read or run there.
- Own geometry only. No computer use.
- The place is not saved and nothing is committed. `ae_kit.blend` is saved.
- The session dropped mid-pass. The practice place reloaded from the pass-20 save, and I re-ran `fix/pass21.lua`, which is idempotent, on the new studio id `8ce7b1eb`.

**State at the end**
- `#workspace.Plaza:GetDescendants()` = 16182. That is 15573 for pass 20, plus the Pass21 folder and its pieces.
- Workspace holds only Camera, Terrain, SpawnLocation and Plaza.
- The `ae_kit_r21` model was merged into ServerStorage.Kit by the header loop: 8 meshes went in and the scale cube was destroyed.

**Tools (`out/r21w/`)**
- `box21.py <cam> <png>...`: 5x5 means at every round-18 review box. The target is re-sampled from the v18 reference each run.
- `metrics.py <cam> <png>...`: top-half mean HSV saturation (0-255), and blue cover in the review rectangles. A pixel counts as blue when b > r+40, b > g+20 and b > 120. That rule reproduces the review's figures on the v18 frames: 60.1 / 39.4 in the practice and 40.9 / 15.3 in the reference.
- `cap.sh <cam> <tag>`: captures twice and runs box21 and metrics on the second frame. For p3 it also runs the eight pass-18 Raid boxes.
- `pick.py`, `lu.sh <file.lua>`, `run.sh` (runs `fix/pass21.lua`), `refcap.sh` (screen_capture of the reference only).

**How to rebuild** (on the pass-20 build with `ae_kit_r21` imported)
- Run `sh out/r21w/run.sh`. It rebuilds `Plaza.Pass21` and first restores everything it touched from the `P21*` attributes.
- Blocks: `--SKY21`, `--WEST21`, `--ARCH21`, `--STAIR21` (the kit stairs swap lives here so the grass lands on the new steps), `--GRASS21`, `--RAID21` (no-op), `--BASIN21`, `--KIT21` (skyline pieces).
- `fix/build_plaza.lua` has r21 in `IMPORTS`.

## Results (final set against the v18 reference)
| box | v18 practice | r21 |
|---|---|---|
| c1 notch interior | 86 | 12 |
| c1 outer slate | 56 | 7 |
| c1 gold tunnel ledge | 67 | 7 |
| c1 splat L / R | 102 / 90 | 21 / 28 |
| c4 riser (measured on our riser, see below) | 42 (box) | 11 |
| c4 tread (measured on our tread) | 4 | 18 |
| p7 basin | 68 | 3 |
| c2 basin | 32 | 22 |
| p7 blue cover (target ~20, ref 15.3) | 39.4 % | 26.5 % |
| p8 blue cover (target ~40, ref 40.9) | 60.1 % | 51.7 % |
| top-half saturation p1 (ref 84.4) | 112.3 | 110.7 |
| pass-18 Raid boxes | hazeL/R 21/23 in the v18 frame | all within 15, except lowR at 17 (the v18 frame read 15) |

- **c4 stairs:** the new stairs have 6 taller steps, so the review's riser and tread boxes now land on the other surface. Measured at the reference's own boxes:
  - our riser at (400,690) reads (74,105,124) against the riser target (85,107,121): 11 off;
  - our tread at (430,655) reads (172,176,167) against the tread target (186,191,185): 18 off.
- **Box misses:**
  - The c2 grass box (930,590) and the p2 lawn box (560,378) land on stone or a distant building in our frames. I judged both by eye:
    - c2: soft lime clumps instead of spikes;
    - p2: a lawn strip with tufts at the S stair top.
  - The p5 runner and rim, and the c4 runner and pineapple, were not attempted.

## 1. Background (`--SKY21`, `--KIT21`)
**Removed (hidden):**
- 500 green K_Soft15K "lollipop" clumps above y 55, with their trunks. Only the green-tinted clumps were hidden. The gold, blue and purple crowns are white plus a leaf map, and a first run that hid every clump above y 55 also took the gold terrace trees.
- The 20 white box towers: `IslDress12` (including its trunks) and `IslTower14` with its windows, bands, domes and spires.
- 29 of 31 waterfall columns. They read as white posts.

**Kept:** the 2 northern fall columns nearest the axis, at transparency 0.4 and colour (205,235,250).

**Added:**
- 2 irregular umbrella canopies per island: K_Soft15U/R clones, set by raycast onto the island and tinted pale (195,215,160).
  - The tint must set `SurfaceAppearance.Color` as well as `Part.Color`. Our leaf parts carry an SA whose Color overrides the part colour.
- 17 kit pieces on the old tower spots (one per 30 studs), facing the plaza:
  - every third is a palace, `K_Palace21` (stone (176,180,174), dome (112,132,150), gold);
  - the rest are arcades, `K_Arcade21` (stone, darkStone (70,78,86)).

**Island colours:** the islands were repainted pale, as distant objects:
- grass (170,205,150);
- rock (185,200,205);
- vines (120,160,110).

The reference islands sample grass (157-168, 174-204, 156-169) and rock (114-138, 139-150, 150-160) in p1.

**Atmosphere test:** Haze 1, with everything else at the reference settings, raised the p1 top-half saturation from 114.1 to 119.2, so it made things worse. I dropped it, and Atmosphere is unchanged. The saturation gap (110.7 against 84.4) comes from content, not haze: the reference top half is full of white cloud, pale stone and bloom. The measure moved only 112 -> 110.7, although by eye the skyline is now towers, arcades and canopies rather than posts and balls.

**Not done:** the aqueduct, and wider falls.

## 2. West blue (`--WEST21`)
- **Selection:** blue clumps are Trees13 K_Soft15K whose leaf SurfaceAppearance has the blue leaf map (`...118173022878419`) and x < -45. The West16 K_Soft15B bushes count as blue too.
- **Thinning:** deterministic (sorted by z, keep k of every 5):
  - low clumps: 36 of 60 hidden;
  - high clumps: 25 of 63 hidden;
  - bushes: 84 of 140 hidden.
- **Filling:** 3 blue palms (LagoonPalm16 clones scaled to 27 tall) with sand discs, placed in the gaps.

| step | p8 blue % | p7 blue % |
|---|---|---|
| base | 60.1 | 39.4 |
| hide 40% of the low clumps and bushes | 54.1 | 31.3 |
| hide 60% | 51.7 | 24.6 |
| plus 40% of the high clumps | 51.8 | 24.6 |

The rest of the p8 blue is the Story tree canopy and the cyan lagoons. The rule counts cyan water as blue, in the reference too.

## 3. Arch (`--ARCH21`)
**Notch.** The dark lintel and cyan slot were one part: `Pass9.Ledge`, a 5.4 x 0.7 x 7 block at y 8.7, jutting 1.3 in front of the crown and lit cyan underneath by the vault light. It is hidden, and so is its gold lip.

The reference has a gold bar at y 275-283 and a dark step at 285-298. Projected onto the arch front plane (w 33) with `plane.py`, these are y 8.95-8.75 and 8.7-8.37. I added:
- a gold sill `NotchSill21` at w 32.9;
- a dark slate step `NotchStep21` at w 32.75. At w 33.2 it sat inside the stone and did not show.
- a dark back panel `NotchBack21` at w 35.6, spanning u ±2.35 and y 8.9-12.55, colour (48,54,60).
  - At y1 14.5 it stood above the U arms as a black slab in p1, so its top is now 12.55.

**Slate band:** (74,81,87) rendered (89,102,109), a ratio of 1.2. Target over ratio gives (30,37,43): 7 off.

**Gold ledge:** `TunnelLedge21`, Metal, 14 x 0.6 x 0.8 at w 37.6, y 3.8. The reference pixels (524/914, 432/453) project onto the tunnel back at u -7.5..7, y 3.4-4.2.
- (120,105,30) rendered (70,53,1).
- (135,150,60) rendered (82,100,8).
- (128,112,60) rendered (83,68,12): 7 off.

**Splats:** sunlit floor ratio about 1.5. Left rim (50,105,185) and core (40,95,200); right rim (200,70,68) and core (190,60,58).

**Not done:**
- **Fountain forward:** the bowl is part of the hero mesh, so only the drum could move.
- **Narrower opening:** pass 20 fitted the opening to the reference edge pixels. A row scan was not repeated, so I left it.

## 4. Stairs (`--STAIR21`, kit `K_Stairs21`)
- **Why a new mesh:** in the c2 and c4 reference frames the flight reads as about 6 chunky steps; ours had 8 thin ones. The dark "wedge spacers" were the end faces of the 4.5-stud blocks. `split_by_normal` had sent every vertical face into the riser colour.
- **The new mesh:**
  - 6 steps, rise 1.0, tread 3.33 (same run of 20 and the same top at 6);
  - blocks 4-6 wide, with joints offset row to row (odd rows start with a 2-3 block);
  - bevel 0.3 with 2 segments.
- **Riser split:** only faces whose normal points back down the flight become `_riser`, so the joints stay stone.
- **Placement:** the old stone, riser and 64 Nosing strips are hidden. The new stairs keep the old colours: tread (99,102,101) Slate, riser (71,89,101). The riser colour comes from the render ratio: (97,99,102) rendered (116,120,123).
- **Result:** on the reference's own boxes the riser is 11 off and the tread 18 off. By eye, c4 now reads as stacked rounded blocks, as in the reference.

## 5. Grass (`--GRASS21`)
- **Clumps:** the 92 StairGrass16 spike blades are hidden. 56 of them (60%) become green K_Soft15K clones scaled to 1.3 tall, set by raycast onto the new steps, colour (150,205,70) and rim (180,225,90).
- **Lawn strips:** 13.4 x 0.3 x 1.2 Grass strips (120,180,70) along the S and W stair-top lips, each with 5 tufts 1 stud tall.

## 8. Basins (`--BASIN21`)
K_Hero_water is Glass, and Glass is not linear:

| colour | rendered |
|---|---|
| (110,175,195) | (119,222,227) |
| (55,120,150) | (30,166,195) |
| (120,112,137) | (143,152,177) |
| (76,113,138), interpolated per channel between the last two | (69,157,181): 3 off in p7, 22 in c2 |

## Lessons (for the workflow vault)
1. **Check what a colour really lives in before tinting.** The leaf parts carry a SurfaceAppearance whose own `Color` overrides `Part.Color`. "Tinted" clumps stayed teal until the SA colour was set too. Likewise "blue trees" are white parts with a blue leaf map, so select them by `ColorMap`, not by `Color`.
2. **Decide what you hide by its appearance class, not by height alone.** Hiding every clump above y 55 also removed the gold terrace canopy. Filtering on the tint (green-coloured, not white plus a map) kept it.
3. **A step count is a shape fact; read it from the frames.** The reference stairs have about 6 risers where ours had 8. No colour change could fix "stripy". The fix was taller, fewer, bevelled blocks, with the riser material on the front faces only. When you split materials by normal, check that you have not painted joints and ends.
4. **When geometry changes, measure at the reference's own boxes, not the review's practice boxes.** After the stair swap, the review's riser box landed on a tread. Sampling our frame at the reference box positions gave the true 11 / 18.
5. **Glass colour is not linear.** Two measured points per channel and a linear interpolation landed within 3. A single ratio overshot by 37 to 76.
6. **Test global settings on the metric before believing the prose.** Atmosphere Haze made the saturation worse. The reference's softness comes from content: pale stone, clouds and distant colour. So paint distant pieces pale instead.
7. **Find the part behind a look before building a new one.** The "dark lintel and cyan slot" were one old pass-9 block jutting out under the vault light. Hiding it, then adding a sill and step at the projected reference rows, matched within 12. Raycast picks miss CanQuery-off foliage and hit MeshPart collision hulls, such as the open notch. Use the plane projection (`plane.py`) to place things.
8. **Keep the raycast filter in step with the build order.** The grass raycast excluded the whole Pass21 folder, which now holds the new stairs. Clumps fell through to the floor until the stairs were exempted and the stair swap moved ahead of the grass block.
9. **Save the .blend before any long Studio loop.** The session dropped mid-pass. The idempotent Studio script on disk brought the place back in one run, but unsaved Blender work would have been lost.

## Objects built (for 5 Object Recipes)

### Chunky stair blocks (`tools/ae_kit.py`: `build_stairs21`)
- 4 flights (rot4) of 6 steps: rise 1.0, tread 20/6, flights from d 28 to 48, lateral 4.3-17.7 each side of the runner.
- Each step is a row of full-height `rbox` blocks, 4-6 wide, with bevel 0.3 and 2 segments. Odd rows start with a 2-3 block, so the joints are offset.
- After the merge, faces with a horizontal normal pointing back down the flight go to `K_Stairs21_riser`.
- Studio: tread (99,102,101) Slate, riser (71,89,101) SmoothPlastic, placed at the old `K_Stairs_stone` CFrame.

### Ruined arcade with round tower (`build_arcade21`)
- Tier 1: 13 tall, 3 bays of 8.7 with round openings of half-width 3.0, and a dark back wall.
- Tier 2: 10 tall, 4 bays of half-width 2.0, open to the sky.
- Tier 3: broken; 2 bays of random height 5.5-8.
- 0.8 floor slabs between tiers and a plinth. Each bay is `bay()` with `arch_outline`, 3 deep.
- Round tower at +x: r 3.4, 38 tall, 4 levels of rounded dark window slots, cornices, a dome to 42.
- Studio: stone (176,180,174), darkStone (70,78,86). Placed on the old white-tower spots, facing the plaza.

### Domed palace (`build_palace21`)
- A 20 x 10 x 14 rounded block with a cornice and plinth, and 3 arched dark windows per long side.
- A drum (r 5, y 10.8-14.4) with 8 window slots, a dome lathe (r 5.3, to 20.8), a lantern and a gold finial to 25.
- Two corner drums with small domes and finials.
- Studio: stone (176,180,174), dome (112,132,150), gold (190,160,70) Metal, darkStone (70,78,86).

### Notch close-up (Studio)
- In each arch corner frame (d = (±1, 0, ±1).Unit):
  - `NotchBack21` slate (48,54,60), 4.7 x 3.65 x 0.3 at w 35.6;
  - `NotchSill21` gold Metal, 4.6 x 0.26 x 0.5 at w 32.9, y 8.72-8.98;
  - `NotchStep21` slate, 4.4 x 0.37 at w 32.75, y 8.35-8.72.
- `Pass9.Ledge` and `LedgeLip` are hidden.

### Tunnel gold ledge (Studio)
`TunnelLedge21`: Metal (128,112,60), 14 x 0.6 x 0.8 at w 37.6, y 3.8, on the tunnel back panel.

### Soft grass clump and lawn strip (Studio)
- **Clump:** a green K_Soft15K leaf-card clump scaled to 1.3 tall. Leaf (150,205,70) and rim (180,225,90), set on both `Part.Color` and `SurfaceAppearance.Color`. Foot set by raycast.
- **Lawn strip:** a Grass Part 13.4 x 0.3 x 1.2 (120,180,70) just outside the stair-top lip, with 5 one-stud tufts.

### Island canopies and pale distant islands (Studio)
- 2 K_Soft15U/R clones per island, at 0.22 of the island's bounding-box size from its centre, foot by raycast onto the island, scale 0.8-1.3.
- Leaf (195,215,160) and rim (220,232,190).
- Islands: grass (170,205,150), rock (185,200,205), vines (120,160,110).

## Files
- `fix/pass21.lua` (new). `fix/build_plaza.lua` (r21 added to `IMPORTS`).
- `tools/ae_kit.py`: pass-21 section (`build_stairs21`, `build_arcade21`, `build_palace21`, `build_scale21`, `build_all21`, `export_r21`).
- `kit/own/ae_kit_r21.fbx`: 9 meshes, imported by the lead. `ae_kit.blend` saved.
- `out/r21/` (set and contact sheet), `out/r21w/` (tools and working frames).
