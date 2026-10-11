# Fix pass 32: Anime Expeditions spawn plaza (glowing blue falls, blue palms in the p6 sky gap, dark teal swirl portal, low white bollards with gold domes, E red carpet completed, dark niches)

Builder report for `notes/fix_brief32.md`, answering the round-29 review `notes/verify29_plaza.md` (9.21/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`). The reference studio `97946bf6-...` was not captured:
the full-size v29 frames were enough. **No kit this pass.** All work is Studio-side (Parts, WedgeParts, SpecialMesh ellipsoids and
clones of our own kit pieces), so no Import 3D was needed and `ae_kit.blend` was not touched. About 90 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 Falls | Done. The 12 pass-31 falls (Fall31 planes and veils) are hidden and rebuilt on the same tops. Each fall now has three layers. **Body:** 7 wide, 12 SmoothPlastic planes (120,200,245), T 0.25 -> 0.9, narrowing 15 %. **Mid glow:** 3.6 wide, Neon (175,230,252), T 0.55 -> 0.95. **Core:** 1.6 wide, Neon (230,250,255), T 0.35 -> 0.92. A faint 10.5-wide veil sits behind at T 0.82. Length is up to 44 (was 32); the foot stays at y >= 62, and the pass-31 mist is moved to the new foot. In c4 and c3 they now read as blue-edged falls with a white core, not grey stubs. |
| 2 Sky gaps | **p6:** done. 4 blue palms (own `K_Palm6A` pieces at 0.95-1.2x: leaf (35,85,215), rim (60,115,230), wood (105,72,48)), at x -54..-74, z 13..34. Behind them are 3 blue `K_FluffyS_leaf` canopy clumps at y 27-33. p6 (1000,200): sky (154,211,238) -> palm crown; top-half saturation 100 -> **105** (ref 117). The same palms flank the Story ring on the left in p4, as in the reference (p4 102 -> 106). **p3:** part. A dark-brown mass (3 `K_Goth28_dark` at 2-2.9x, Slate (78,62,52), and 2 `K_DeadTree_wood` at 2.6-2.8x) stands at x 70-88, z -60..-84. It shows as dark branches behind the c3 fountain, but the p3 box (200,200) is still the blue tree in front (see "Measured"). **p4 island tone:** not done (see "Measured"). |
| 3 Expeditions portal | Done. The Neon portal plane and arch are now SmoothPlastic (10,108,122) at T 0; the pass-31 glow ellipse and teal light are off. An own **Parts swirl** sits on it: 3 spiral arms of 14 thin Neon segments (24,110,114), r 0.4 -> 4.8, T 0.25 -> 0.75; a core ellipse (32,108,108) T 0.35; a small teal PointLight. p2 (640,330): (0,174,200) -> **(10,161,174)** vs (3,110,125). p2 (640,300): (7,144,180) -> (26,85,115). Orb ring and crescents moved +6 up (not +8: the pass-31 lesson about cropping at the p2 top). p2 (720,200) is still the island band. |
| 4 Bollards | Done, with a correction. The zoom pair (p5, 3x) shows the reference bollard is a **low white slab** that is longer radially than it is wide. On it sit a gold tapered block and a gold dome. The review's sample (165,163,124) was on the shaded gold block, not the slab, so I did not tint the slab grey. New build: a 2 x 0.6 x 3 slab (226,226,218) with a 1.4 x 0.3 x 2.4 top and four 0.3 chamfer wedges. On it, a gold Metal frustum (a 1.0 block plus 4 wedges, 1.6 at the foot, 1.0 tall), a gold dome 1.5 x 1.2 and a finial: 2.8 tall in all. It is aligned to the plaza centre. The pass-31 post and the old `Pass28.Boll28_head` are hidden; the low slab exposed that olive pyramid in the first try. |
| 5 Ground | **p8 SE:** done. A second leaf scatter (7-stud jittered grid, 85 % fill, x 40-184, z -20..172) adds 313 red and 144 grey Slate (100,106,100) rubble pieces. It uses a **multi-hit down-ray that keeps going until it reaches a Grass part**: the pass-31 single ray stopped on splat and palm collision hulls, which is why the gaps were left. The E half now reads as one red and grey mass. **Red palms** (RedPalm17 leaves): (110,25,30) / (130,30,35) -> (78,20,22) / (92,26,26). p8 (1100,500) (222,154,149) -> (195,154,147); sunlit from above they stay light. **Lagoon:** (6,32,78) -> (2,30,62), deep (2,20,48). p8 W (63,90,153) -> (62,89,132) vs (103,123,141). **S lawn:** not changed (see "Measured"). |
| 6 Niche and jet core | Part. The 4 `TunnelBack20` panels are now SmoothPlastic (10,25,40): c1 (560,400) (61,105,129) -> **(17,34,56)** vs (20,31,49). The pass-31 plume egg is 0.6x and T 0.62, but c1 (640,400) is still bright (233,253,254) because the column and core behind it are unchanged. No back-niche water sheet. |
| 7 Summon | Part. The kept bunting strand (22 Pennant17 + Cord17 at z -72) is raised 3.5 studs, so it now runs along the pediment above the cornice in c4, not across the windows. The entry and emblem are not done. |
| 8 Boss Rush | Facade darker: `GothBoss29_stone` (120,55,120) -> (62,38,68), bone (225,200,230) -> (100,72,108). Pass-31 magenta trims and light kept. |
| 9-10 | Not attempted (arch bevel, Story ring glow, props). |

## Captures
- **Final set:** `out/r32/r32_<cam>.png`, all 12 at full size **1284 x 793** (second frame of `capture_set2.py`). Contact sheet `out/r32/contact.jpg` (v29 reference left, r32 right).
- **Baseline:** the round-29 practice frames `out/verify29/v29_<cam>_rep.jpg`. The saved place was the pass-31 state; descendant count 19177 was confirmed at the start.
- **Working sets:** `out/r32w/a` to `f`; pair images `out/r32w/pair_<cam>.jpg` (ref above, ours below); zoom pairs `out/r32w/z<tag>_<cam>.jpg`.
- **Tools (`out/r32w/`):**
  - `run.sh` runs `fix/pass32.lua`.
  - `lrun.sh <lua>` writes its JSON to `out/r32w/json/`, so no tracked `cmd/*.json` is overwritten.
  - `some.sh <tag> <cams>` captures a subset of cameras.
  - `run_cap.sh` captures the final set.
  - `metrics.py <tag> [dir]` compares against v29 ref / v29 rep.
  - `pick.py` now lists up to 4 hits per pixel, which shows when the first hit is only a collision hull.
  - `pair.py`, `zoom.py`, `stack.py`, `count.lua`, and the queries `q_*.lua`.

## Results
**Top-half mean HSV saturation:**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref v29 | 82 | 99 | 103 | 109 | 91 | 117 | 89 | 104 | 95 | 110 | 90 | 85 |
| base (v29 rep) | 78 | 90 | 87 | 102 | 95 | 100 | 80 | 93 | 102 | 103 | 95 | 91 |
| **r32** | **78** | **90** | **89** | **106** | **95** | **105** | **84** | **94** | **103** | **103** | **95** | **91** |

The p6 gap went from -17 to -12, p4 from -7 to -3, and p7 from -9 to -5. No camera moved away from the reference.

**Boxes (5x5 means):**

| box | ref | base | r32 |
|---|---|---|---|
| c4 fall (670,230 ref / 600,210 ours) | (198,242,249) | (215,215,204) | (224,238,238) |
| c3 fall (190,280 / 60,230) | (195,240,249) | (215,219,210) | (228,245,247) |
| p6 sky gap 1000,200 | (72,124,198) | (154,211,238) | palm crown and trunk (66,49,50); the crown fills 850-1100 x 100-300 |
| p2 portal 640,330 | (3,110,125) | (0,174,200) | (10,161,174) (swirl core) |
| p2 portal 640,300 | (12,159,169) | (7,144,180) | (26,85,115) |
| c1 niche 560,400 | (20,31,49) | (61,105,129) | **(17,34,56)** |
| p5 bollard 634,580 | (85,75,46) gold block | (209,210,215) | (214,189,24) gold block |
| p8 red tree 1100,500 | (137,102,90) | (222,154,149) | (195,154,147) |
| c2 Boss facade 160,250 | (49,32,49) | (44,49,60) | (43,49,59) (box lands on a palm in our frame) |
| c4 tread (a 9.5) | (191,192,189) | (189,196,189) | (189,196,189) unchanged |
| p4 rim (a 9.5) | (44,68,111) | (39,63,118) | (39,63,118) unchanged |

**The five 9.5 cameras:**
- **p3:** the bollards are now low white slabs, plus the dark branches behind.
- **p4:** palms now flank the ring, as in the reference.
- **c1:** the niche is darker.
- **c2:** the Boss facade is darker.
- **c4:** the falls glow and the bunting has been lifted.

I checked all five by eye in the pair images. None lost a feature.

## What I measured / proved
- **The p3 "sky" box is blue foliage, not sky.** v29 rep (200,200) = (92,166,236), and the pick and the crop both show it is the lit blue tree in front, which is sky-coloured in sun. The sky is 50 px higher. In the reference, the same pixel is a dark branch of the blue tree in front of dark gothic buildings. A dark mass that reaches p3 y 120-260 at that bearing would have to stand about 45 studs tall at x 70. It would also stand in the middle of c3 and p5, so I kept it at about 39 studs, behind the tree. The p3 top half still gained +2.
- **The p4 "beige island" box (1150,40)** sits on a purple tree trunk beside the floating rotunda island in our frame. In the reference it is the Guild tower. Toning the island rock would be a global colour change: it also changes the background of the c3 and c4 falls. I skipped it. The p6 palms gave p4 +4 anyway.
- **The bollard review colour was the gold block.** In a 3x zoom pair, the reference slab is white (230,231,223). Only the tapered gold base reads (165,163,124) in shade. Lesson 2 of pass 31 again: check a "retint" against the reference picture.
- **Cloned SA palms read pale from below.** The cloned Trees13 palm, with its SurfaceAppearance at (33,55,132), rendered (165,200,214) on the underside in p6. Own `K_Palm6A` pieces as plain SmoothPlastic (35,85,215) render saturated blue. Use plain-colour meshes for anything seen against the sky from below.
- **S lawn:** `GroundS` and `K_Hero_turf` are coplanar at y 6 under the p7 box. As a test, `GroundS` set to LeafyGrass (62,104,0) rendered **(119,182,109)**, with blue **up** 12 from (121,188,97). I reverted it. The blue is ambient light on the grass materials, as pass 31 found.
- **Portal Neon:** the first core (60,200,200) Neon rendered (19,246,247) (clipped). (32,108,108) gives (10,161,174). This matches the pass-31 rule: Neon renders at about 2x its colour, then clips.
- **Scatter rays:** the pass-31 carpet ray took the first hit. Splat and palm collision hulls block about half of the SE grid points, which is where the green gaps came from. `groundY(x, z, maxY, pred)` steps through hits (up to 8) until `pred` (Grass material) is true.
- **Idempotence:** a second run of pass 32 gives the same report and the same descendant count, **20209**.

## Built (method)
`fix/pass32.lua` is idempotent and runs after pass 31.
- Every touched part keeps its old value in a P32* attribute (Col/Mat, T/CC/CQ + Hidden, CF, Size, Tx, En, SA), and the script restores those first.
- New pieces go in `Plaza.Pass32` (Falls32, Sky32, Gate32, Boll32, Ground32).
- It also merges `Workspace.ae_kit_r32` if one is ever imported (scale cube `K_Scale32_stone`).

The blocks:
- **FALLS32:** groups the Fall31 planes by (x, z) to get each fall's top. For each fall it builds 12 rows of body + mid + core planes yawed to face the plaza centre (`CFrame.lookAt(xz, origin)`), plus a veil. It moves the pass-31 mist with `moveTo`.
- **SKY32:** for each palm, `groundY` finds the ground below y 12, then `kp()` places wood, leaf and rim at the same CFrame and scale. Canopy clumps are sunk by their kit offset. The dark mass uses `kp` with Slate.
- **GATE32:** recolours the portal plane and arch. Each spiral arm follows `r = 0.4 + 4.4t`, `ang = arm * 120deg + 4.2t`, with x squashed to 0.85. Each segment is `CFrame.lookAt(mid, next, Vector3.zAxis)` with Size (width, 0.05, length), so the thin axis is the portal normal.
- **BOLL32:** works in the frame `B0 = CFrame.new(foot) * lookAt(centre)`. Chamfers are WedgeParts: a wedge's tall face is +Z, so the front wedge uses 0 deg, the back 180, and the sides +-90 (tall face toward the cap).
- **GROUND32:** recolours RedPalm17 leaves. The scatter uses `Random.new(32)`, `groundY` with a Grass predicate, 70 % red leaf meshes and 30 % grey Slate rubble. The lagoon is recoloured.
- **NICHE32 and EXTRA32:** recolour TunnelBack20, resize the plume, `moveTo` the bunting up 3.5 studs, and recolour the Boss facade.

## Lessons (for the workflow vault)
1. **Zoom-check a colour target before applying it.** The bollard target was the shaded gold base, not the slab. The p3 "sky" target was lit blue foliage. Two of the five priority items had a box that measured a different object than its label.
2. **A fall needs width and a gradient to read as water.** Two thin strips at 2.6 studs read as poles. A 7-stud blue body with a 3.6 glow and a 1.6 white Neon core reads as a falling sheet at 200 studs.
3. **Plain-coloured meshes for anything seen from below against the sky.** Textured SurfaceAppearance foliage went pale on its underside.
4. **Scatter rays must step through collision hulls.** Loop the ray, excluding each hit until the hit satisfies a ground predicate. A single ray silently skipped half the grid.
5. **A low piece can expose hidden older pieces.** Lowering the bollard showed an olive pyramid from pass 28 that the taller post had covered. After a size change, list every visible part within a few studs.
6. **Material swaps do not remove ambient blue.** LeafyGrass made the lawn bluer. The lawn needs cover pieces, or the change has to come from lighting, which stays settled.

## Objects built (for 5 Object Recipes)
- **Glowing waterfall (3-layer):** a 7-wide body of 12 SmoothPlastic planes (120,200,245) at T 0.25 -> 0.9, narrowing 15 %. A 3.6-wide Neon mid (175,230,252) at T 0.55 -> 0.95. A 1.6-wide Neon core (230,250,255) at T 0.35 -> 0.92. A 1.5x veil at T 0.82 behind, and mist at the foot. Length up to 44; it faces the plaza.
- **Parts swirl portal:** a dark teal SmoothPlastic door plane (10,108,122). On it, 3 Neon spiral arms of 14 segments (24,110,114), r 0.4 -> 4.8, width 0.8 -> 0.4, T 0.25 -> 0.75. A core ellipse (32,108,108) at T 0.35, and a teal PointLight with range 10.
- **Ornate low bollard:** a white slab 2 x 0.6 x 3 with a 1.4 x 0.3 x 2.4 top and four 0.3 chamfer wedges. A gold frustum (1.0 block + 4 wedges, 1.6 -> 1.0, 1.0 tall), a gold dome 1.5 x 1.2 and a 0.3 finial. Its long axis is radial.
- **Kit palm in a plain colour:** K_Palm6A wood/leaf/rim at the same CFrame and scale, leaf (35,85,215), rim (60,115,230), wood (105,72,48).
- **Red-and-rubble ground scatter:** a 7-stud jittered grid at 85 % fill, Grass-only multi-hit rays, 70 % dark-red leaf meshes and 30 % grey Slate rubble, at 1.1-1.7x.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **20209** (pass 31: 19177). Workspace holds only Camera, Terrain, SpawnLocation and Plaza.
- Nothing was saved or committed, and no kit was exported. `ae_kit.blend` and `fix/build_plaza.lua` are untouched, and no tracked `cmd/*.json` was overwritten.
- `fix_lighting.lua` was not re-run (no lighting change). Technology, post effects and Atmosphere are unchanged, and Haze was not tested.
- `GroundS` was tested once with LeafyGrass inside pass 32 and removed from the script. The next run restored it to its pass-31 value (P32Col attribute), so it is (72,108,0) Grass again.
- **How to rebuild:** on the pass-31 build, run `sh out/r32w/run.sh`. It is idempotent.

## Reference use
The round-29 frames in `out/verify29/` were used for every target. I did not capture, run execute_luau in or read positions from the reference studio, and did not open `ae_reference.blend`. No computer use. Only own meshes and Parts were used.

## Next
- **p3:** to cover the box, the dark mass behind the blue tree would need to be about 45 studs tall at x 70. Check c3 and p5 before trying it.
- **Portal:** still slightly bluer and darker than the reference's mid-teal. Try a plane of (5,118,125) and a wider, lighter swirl band.
- **Jet core:** c1 (640,400) is still white. Make the Jet30 column and core T 0.6, and add the back-niche water sheet.
- **Summon:** the bright arched entry and the glowing emblem are not done. The facade is cream; the reference is grey stone with gold.
- **S lawn:** only cover pieces will move it. Try own grass-clump meshes in a yellow-green.
- **p4 island tone and props:** not done.
