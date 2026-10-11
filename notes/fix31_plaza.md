# Fix pass 31: Anime Expeditions spawn plaza (fading falls on light island rock, arcing jets, yellow lawn and E red carpet, glowing Expeditions portal and orb in the sky, slim bollards, Boss Rush glow)

Builder report for `notes/fix_brief31.md`, answering the round-28 review `notes/verify28_plaza.md` (9.13/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`); reference studio `97946bf6-...` was not used (the
full-size v28 frames were enough). **No kit this pass:** all Studio-side (Parts, SpecialMesh ellipsoids and clones of our own kit
pieces), so no Import 3D was needed. About 95 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 Falls | Done. All 17 fall strips (Fall16, the three `Ribbon23` white bars that ran from y 128 to the ground, IslFall24, Fall27, Fall28, Fall30) are hidden. 12 remain after a spacing rule (one fall per 18 studs of plan distance, newest first) and each is rebuilt as a **fading fall**: 10 stacked Neon planes (175,232,250) 2.6 wide, T 0.3 at the top to 0.95 at the foot, a faint 1.9x wider veil (T 0.85), and at the foot a mist ellipsoid (T 0.8) plus a mist ParticleEmitter (size 3-5, T 0.6). Length is capped at 32 and the foot never goes below y 60, so no fall touches the canopy or the ground. FallFoam30 balls hidden, the opaque lips made T 0.45. **Island undersides:** 35 dark Slate `_rock` parts above y 60 (they rendered navy in shade, so every fall in front of them read as a white column) are now light warm stone (186,178,150) SmoothPlastic. |
| 2 Jets | Done. Pass-30 puffs, dome and ellipsoid sheets (the cloud) hidden; column, core and foam kept. Per jet: 6 curved sheets, each a 6-segment arc (rise 0.25, fall 2.2, reach 1.7-2.0) of thin blocks 0.75 -> 0.4 wide, T 0.35 -> 0.6, (165,228,248); a 1.5 x 2.2 plume ellipsoid T 0.5; streak emitter (VelocityParallel, Squash 1.5, speed 6-8, life 0.6, size 0.4-1.0, gravity -20). Reads as a fountain spray now, not a cauliflower. |
| 3 Ground colour | Done. S lawn `GroundS` (62,112,4) -> (72,108,0) Grass: p7 (880,650) (108,194,101) -> (129,177,85) vs ref (98,169,42). 149 other lawn Grass parts (K_Hero_turf, patches, Lawn25, WhitePave) blue x0.35, green -10. **E red carpet:** 344 own `K_Litter_leaf` / `K_Spill9_leaf` clones at 1.1-1.6x in 3 dark reds (178,30,36)/(160,24,32)/(196,44,42) on a jittered 8-stud grid (80 % fill) over x 44-176, ground-only down-rays. 40 smaller red litter pieces on the E stair flanks (p3). Lagoon (22,58,118) -> (6,32,78), deep (4,22,60): p8 W (67,121,199) -> (63,90,153). c2 fern back to lime: (200,56,58) -> **(192,230,68)** vs (176,222,87). |
| 4 Expeditions gate | Done. Painted swirl hidden; Neon portal plane + arch (9,100,110) T 0.3 with a soft inner glow ellipse and a teal PointLight: p2 (640,300) (23,110,138) -> (7,144,180) vs (18,178,190). Two crystal basins (stone pedestal 2.6 tall, 4-wide basin, gold rim, Neon water, 3 own `K_Crystal_glass` up to 4.7 tall) at x +-22 outside the side panels, as in the reference. **Orb:** the review asked for +10 up, but +10 cropped the ring at the top of p2. Measured from the pictures instead: ref orb centre at p2 y 167 (22 deg up), ours 120 (26 deg). Moved the ring and crescents 8 back and 1 down: now y 163 in p2, and in p6 the ring sits at the top-left in open sky like the reference. |
| 5 Bollards | Done. White slab, pass-30 trims and pyramid hidden; plinth 2.6 x 0.4 (182,188,195), post 2.1 x 2.2 x 2.1 (200,205,210), gold collar, gold Metal dome 1.8 x 1.4 and finial. p1 (360,560) (242,241,233) -> (225,226,228). |
| 6 Boss Rush | Done (part). Stone (70,40,90) Slate -> (120,55,120); 3 magenta Neon (220,60,160) trim strips round the door and a PointLight (220,60,160) range 20 brightness 2. Glow shows in p7 and p5; the review box p5 (940,330) lands on a dead tree in our frame, so it did not move. |
| 7 Summon finish | Not done. |
| 8 Foliage tints | Palms (Trees13 K_Soft13P, 42 SurfaceAppearances x0.78): c4 (108,143,204) -> **(94,126,182)** vs (73,106,181). Gold tree (8 SAs near (5,70,-178)) blue x0.62. c2 fern done in item 3. |
| 9-10 | Not attempted (arch bevel, props, Story glow plane). |

## Captures
- **Final set:** `out/r31/r31_<cam>.png`, all 12 at full size **1284 x 793** (second frame of `capture_set2.py`). Contact sheet `out/r31/contact.jpg` (v28 reference left, r31 right).
- **Baseline:** the round-28 practice frames `out/verify28/v28_<cam>_rep.jpg` (the saved place was that state; descendant count 18390 confirmed).
- **Working sets** `out/r31w/a`-`f`; stacks `out/r31w/s<tag>_<cam>.jpg` (ref above new), zoom pairs `out/r31w/z<tag>_<cam>.jpg`.
- **Tools (`out/r31w/`):** `run.sh` (runs `fix/pass31.lua`), `lrun.sh <lua>`, `some.sh <tag> <cams>`, `run_cap.sh`, `metrics.py <tag> [dir]` (ref v28 / base v28 rep / new; now with fall, boss, fern and lawn boxes), `pick.py`, `stack.py`, `zoom.py`, `count.lua`.

## Results
**Top-half mean HSV saturation:**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref | 83 | 100 | 102 | 110 | 90 | 116 | 90 | 99 | 96 | 110 | 92 | 80 |
| base | 83 | 93 | 90 | 105 | 97 | 101 | 76 | 89 | 104 | 103 | 97 | 94 |
| **r31** | **78** | **90** | **90** | **102** | **95** | **100** | **81** | **95** | **103** | **104** | **95** | **91** |

p8 gap -10 -> -4, p7 -14 -> -9, c4 +14 -> +11, c3 +5 -> +3. p1 (-5), p2 (-3) and p4 (-3) dropped: the light island rock and the paler falls take saturation out of the top half. p4 (a 9.5) looks the same by eye apart from lighter island undersides top right; re-check it.

**Boxes (5x5 means):**

| box | ref | base | r31 |
|---|---|---|---|
| c3 fall (190,280 ref / 60,230 ours) | (204,242,249) | (253,254,254) | (214,217,208) (box now lands on light rock; the fall is narrower) |
| c4 fall (670,230 / 600,210) | (202,243,249) | (255,255,255) | (213,212,201) |
| c1 jet 640,420 | (173,221,233) | (236,253,254) | (229,249,252) |
| p2 gate 640,300 | (18,178,190) | (23,110,138) | (7,144,180) |
| p6 door 60,300 | (0,75,86) | (8,128,161) | (0,165,197) (too bright here; see Next) |
| p7 lawn 880,650 | (98,169,42) | (108,194,101) | (129,177,85) |
| p8 W 250,250 | (118,134,143) | (67,121,199) | (63,90,153) |
| c4 palm | (73,106,181) | (108,143,204) | (94,126,182) |
| c2 fern 800,560 | (176,222,87) | (200,56,58) | (192,230,68) |
| p1 bollard | (230,231,223) | (242,241,233) | (225,226,228) |
| c4 tread (a 9.5) | (191,192,189) | (189,196,189) | (189,196,189) unchanged |
| p4 rim (a 9.5) | (42,67,110) | (39,63,118) | (39,63,118) unchanged |

## What I measured / proved
- **Why the falls read as pillars:** `Ribbon23` ran from y 128 to y 10 (ground), and the other falls hung in front of `K_Isl92_rock` Slate (112,117,122), which renders navy in shade. A white bar on a dark wall with its foot hidden by the canopy reads as a column whatever its transparency. Two changes fixed the read: falls end at y >= 60 (above the canopy) and the rock behind them is light.
- **Perspective check for the fall foot:** a foot at y 55, 300 studs away, sits 9.3 deg up from c3; a 20-stud tree 60 studs away covers up to 13 deg. So the foot must be above about y 75 at that range, or the fall seems to go into the trees. Hence length <= 32 and fewer, spaced falls.
- **Orb position from the pictures:** ref orb centre at p2 y 167 (atan((396-167)/566) = 22 deg), ours 120 (26 deg). Raising it 10 (as asked) put it at the frame top. Moving it 8 back and 1 down gives 163.
- **Neon portal response:** (15,170,185) T 0.3 rendered (0,255,255) at p2; (6,72,80) rendered (13,82,113); (9,100,110) gives (7,144,180). Neon is about 2x the colour, then clipped.
- **S lawn:** `GroundS` is already (62,112,4) and renders (108,194,102): the blue is OutdoorAmbient (169,165,184) on the Grass material, so lowering the blue does nothing. A SmoothPlastic test went flat lime (128,215,55); Grass (72,108,0) gives (129,177,85). `K_Hero_turf` lies coplanar with GroundS at y 6.0.
- **Raycast picks hit collision hulls:** `pick.py` reported `K_Hero19_gold` for p7 lawn pixels; a MeshPart's collision hull is larger than its visible mesh. A multi-hit ray (exclude and repeat) showed GroundS under it.
- **Idempotence:** two more runs of pass 31 give the same report and the same descendant count (**19177**).

## Built (method)
`fix/pass31.lua`: idempotent, runs after pass 30. Every touched part keeps its old value in a P31* attribute (Col/Mat, T/CC/CQ + Hidden, CF, Size, Tx, En, SA) and is restored first. New pieces go in `Plaza.Pass31` (Falls31, Jet31, Ground31, Gate31, Boll31, Extra31). It merges `Workspace.ae_kit_r31` if one is ever imported; `fix/build_plaza.lua` IMPORTS now lists `ae_kit_r30` / `ae_kit_r31` too.
- **FALLS31:** collect fall parts by name; sort by priority, keep one per 18 studs; per kept fall: top = old top, foot = max(old foot, 60), length clamped 14-32, plane yawed to face the plaza centre (`CFrame.lookAt(xz, origin)`), 10 segments with T linear 0.3 -> 0.95, veil, mist ellipsoid + emitter. Rock retint by name/material/height filter.
- **JET31:** arc points `top + dir*(0.2 + reach*t) + up*(2.0t - 4.2t^2)`; each segment `CFrame.lookAt(mid, next)` with Size (width, 0.12, length), so the width is tangential.
- **GROUND31:** Grass-material lawn filter (hue 0.2-0.45, s > 0.25, flat, y < 9); carpet scatter with `Random.new(31)`, ray from y 70 that must land on Grass / Ground / patch / Lawn below y 9.5; kit clones via `kp()` with a per-axis scale.
- **GATE31:** portal plane 0.08 in front of DoorPanel23; basins found by a down-ray at x +-22, z 80; orb `moveTo(+Vector3(0,-1,8))` for K_ExpRing8 and Cres28.
- **BOLL31:** new Parts on each hidden `K_Boll20_base` foot, rotation copied.
- **EXTRA31:** Boss trims from the Goth door's Neon leaf position (front face x - 2); SurfaceAppearance tints scaled from the stored P31SA base (palms x0.78; gold tree only within 30 studs of its crown).

## Lessons (for the workflow vault)
1. **A translucent strip still reads as a column if its background is dark and its foot is hidden.** Fix the background (lighten the rock behind) and end the fall clearly in the air, above anything that could cover its foot. Transparency alone did not do it.
2. **Check a requested move against the reference picture before you make it.** "Raise the orb 10" cropped it in p2. Measuring the elevation angle in both frames gave the real correction: 8 back, 1 down.
3. **Some colour channels are owned by lighting, not by the part.** The lawn's blue came from OutdoorAmbient on Grass; the part's blue was already 4. Move only the channels you control, or cover the area with your own pieces.
4. **Scatter leaf meshes, not discs.** Flat red cylinders read as polka dots from the top view. Clones of an own leaf-litter mesh in three dark reds gave an irregular carpet edge for the same part count. Sunlit red renders about 40 levels lighter, so set it darker.
5. **Neon has a steep response.** Find the portal colour in two or three tries and measure each (about 2x, then clipped), rather than setting the target colour directly.
6. **Raycast picks can hit a MeshPart's collision hull.** When a pick names an unlikely part, repeat the ray excluding it and list every hit.
7. **Fewer, spaced features read better than many.** Ten falls under one island read as a colonnade; four with spacing read as falls.

## Objects built (for 5 Object Recipes)
- **Fading waterfall (Parts):** 10 stacked Neon planes (175,232,250) 2.6 wide, T 0.3 -> 0.95 down the fall, a veil 1.9x wider at T 0.85 behind, a mist ellipsoid (T 0.8) and a mist emitter (size 3-5, T 0.6, rate 6) at the foot. Length 14-32, foot above the canopy, facing the plaza.
- **Arcing fountain jet:** 6 thin curved sheets per jet, each 6 block segments along `r = 0.2 + 1.7t`, `y = 2.0t - 4.2t^2`, 0.75 -> 0.4 wide, T 0.35 -> 0.6; a 1.5 x 2.2 plume ellipsoid T 0.5; streak particles (VelocityParallel, Squash 1.5, speed 6-8, life 0.6, gravity -20).
- **Leaf carpet:** own leaf-litter and spill meshes at 1.1-1.6x, 3 dark reds, jittered 8-stud grid with 80 % fill, ground-only rays.
- **Neon portal door:** plane + arch in front of the door panel, Neon (9,100,110) T 0.3, an inner glow ellipse T 0.6, teal PointLight range 14.
- **Crystal basin:** stone pedestal 2.2 x 2.6, 4-wide basin, gold rim, Neon water disc, 3 own crystals (one Neon) up to 4.7 tall.
- **Slim bollard:** plinth 2.6 x 0.4, post 2.1 x 2.2, gold collar 2.3, gold Metal dome 1.8 x 1.4, finial 0.4.
- **Portal trim glow:** 3 Neon strips (220,60,160) framing a door, with a PointLight (range 20, brightness 2) in front.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **19177** (pass 30: 18390). Workspace holds only Camera, Terrain, SpawnLocation and Plaza.
- Nothing was saved or committed. No kit exported; `ae_kit.blend` untouched. `fix/build_plaza.lua`: IMPORTS gained r30/r31 entries only. `cmd/count.json` was overwritten by `out/r31w/count.lua` (scratch).
- `GroundS` was hand-tested once (SmoothPlastic, then Grass (80,100,0)) outside the script and set back to (62,112,4) Grass before pass 31 took it over with a P31Col attribute.
- `fix_lighting.lua` not re-run (no lighting change). Technology, post effects and Atmosphere unchanged; Haze not tested.
- **How to rebuild:** on the pass-30 build, run `sh out/r31w/run.sh`. It is idempotent.

## Reference use
- No capture of the reference studio: the round-28 frames in `out/verify28/` were used for every target. No execute_luau in the reference, no position reads. `ae_reference.blend` not opened. No computer use. Own meshes and Parts only.

## Next
- p6 door now reads too bright (0,165,197) vs (0,75,86), while p2 is still under. The reference door is a dark swirl with a light rim, so try a darker centre with a bright Neon rim band.
- Falls are now subtle. If the review wants more glow, try T 0.2 on the top 3 segments only, or a bright Neon lip.
- p1/p2/p4 top-half saturation dropped 3-5 (light island rock). Consider a slightly greener rock (175,180,150) or more ivy on the undersides.
- Not done: Summon bunting/entry/emblem, arch bevel, props, Story glow plane, more E-side density near the paths.
