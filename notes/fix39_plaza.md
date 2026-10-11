# Fix pass 39: Anime Expeditions spawn plaza (blue waterfall jets, wide dark shoulder band on every arch, redder Raid arcade)

Builder report for `notes/fix_brief39.md`, answering the round-36 review `notes/verify36_plaza.md` (9.50/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`). Reference studio `97946bf6-...`: **screen_capture only**
(3 close-ups of the jet). **No kit this pass:** everything was done in Studio. About 80 minutes.

Camera picked to finish: **c1** (jet + shoulder bands). Both of its main items were done. They also carry to p5, p1, p3, p6 and c2,
because all four arches and all four jets share the same build.

## Status by review item

| Item | Status |
|---|---|
| 1 Jets | **Done (rebuilt).** Close-ups of the reference jet (`out/r39w/jetne2.jpg`, `jetc2.jpg`: ref left, ours right) showed that it is a **waterfall**, not a plume. Blue water pours from the spout under the gold ledge and curls down into the upper basin. It is about 55 % of the basin wide, has white edges, a few white flecks and a small mist at the lip. The pass-38 Sheet38/LipFroth38/Crown38 are hidden (40 parts) and the Plume38 emitter is disabled. New per corner: a flat run plus an 8-segment quarter curl (R 1.2) and a drop onto the drum. It is 3.2 wide at the landing and tapers to 0.7x at the lip. SmoothPlastic (150,215,235) at T 0.15, with white edge strips (225,248,252), 5 small flecks, a pale froth disc (200,235,245) at T 0.3 and a small blue-white smoke emitter at the lip (rate 12, LightEmission 0). Results: c1 (640,400) **(119,202,229)** vs ref (127,186,203) [r36 (195,233,242)]; c1 (640,430) **(115,180,211)** vs (125,209,237) [254,254,254]; p5 (640,400) (113,193,224) vs (85,136,156) [192,228,238]; c2 (520,360) (158,208,228) vs (31,54,76) [239,254,254]. The c2 view is a blue curl over the lip again, not a white cloud. **Not met:** p3 (1040,410) (180,220,236) and p6 (640,400) (115,194,223) vs a dark niche (6,29,41). In both the ref shows its own jet at about the same place, and the box sits on a dark gap in its swirl. Our fall is one solid sheet. |
| 2 Shoulder bands | **Done (all four arches).** A tint (`out/r39w/tsh.jpg`: ledge red, slate green, grooves blue, inner band yellow, gold magenta) and a brightness profile across c1 y 300 showed the cause. Ours ran, from the outside in: thin light ledge, slate/grooves (x 330-400), gold, then a wide light U face. The ref runs: light outer rim (x 320-400), a **wide dark ridged band (x 410-500)**, gold, then the light U face. So the dark band in the ref sits where our U face starts. **Fix:** (a) the outer slate band (130,135,140) and grooves (100,105,110) become the light rim; (b) a new dark band (45,49,48) is laid ON the pale face, from its outer gold line inward over 55 % of its width. It has 2 ridge lines (88,94,96) and a new gold line at its inner edge. The band uses the kit curves (`_arc19`/`_intrados19`, A20) evaluated in Lua: 544 thin boxes over 4 corners x 2 sides. Results: c1 (500,300) **(49,60,61)** vs (60,64,60) [132,136,139]; c1 (380,350) **(76,89,91)** vs (59,69,77) [130]; c1 (900,300) **(122,131,135)** vs (181,194,206) [86,102,116]; p5 (560,330) **(73,82,75)** vs (76,81,81) [138,137,129]; p1 (80,330) **(87,95,110)** vs (91,96,93) [57,69,89] (r36 item 4's shoulder is fixed by the same change). **Cost:** p3 (150,330) (133,138,140) -> (104,115,117) vs (134,135,139), because the dark band now covers that point. c2 (700,250) went 36 -> 60 vs 45. c1 (340,300) went 148 -> 171 vs 154. By eye, every arch now reads like the ref: light rim, dark slatted shoulder, gold, light U (`out/r39w/ctd.jpg`, `shc.jpg`). p5 (520,300) is unchanged (ArchLedge35, 201 vs 160). |
| 3 Raid arcade | **Small gain, noisy.** ArcWall37 (50,16,20) -> (50,7,10) and trims -> (40,6,9). p5 (1100,320) (100,55,67) vs (103,23,32). c3 (1060,470) (94,61,82) vs (74,66,65). **p3 (600,320) is not stable between captures:** the same (50,16,20) measured (69,60,73) in my baseline and in r36, but (123,59,72) in pass 38. Now (124,58,70). (80,4,4) gave R 167 and (58,3,5) gave 136, so under the red lights red is very nonlinear. G and B cannot go below about 55-60, which is the haze floor (Atmosphere is settled). Doors and bays were not changed (they are already black Neon). |
| 4 NW arch | The shoulder is done through item 2: p1 (80,330) (87,95,110) vs (91,96,93). The p1 (120,250) "U-arm" box is the distant Guild building (pass 38), so it was not changed. |
| 5 Pipe vs groove | **Not done.** p5 (500,330) and p6 (500,330) land on our outer gold tubes, where the ref shows a groove. This is geometry: the ref band edge sits at a different place. p6 recess (560,330) went (54,59,66) -> (38,42,44) vs (21,29,40), which is a side effect of the dark band. |
| 6-10 | Not attempted. |

## Captures
- **Final set:** `out/r39/r39_<cam>.png`, all 12 at full size **1284 x 793**. Contact sheet `out/r39/contact.jpg` (v36 ref | v36 rep | r39).
- **Working sets:** `out/r39w/a` (baseline = r36 state) and `b`-`g`, `tint`. Reference close-ups are in `out/r39w/refz/` (`jetne*.png` ref, `p_*.png` practice). The sheets are `jet1`, `jetz`, `jetne2`, `jetc2`, `sh1`, `tsh`, `shb`, `shc`, `jd`, `jf` and `ctd`.
- **Tools (`out/r39w/`):**
  - `run.sh` runs `build.sh` (head + params + body -> `fix/pass39.lua`) and then the script. `lrun.sh`, `some.sh <tag> [cams]`, `bx.py` (v36), `pick.py` and `sheet.py` (v36) are carried over from pass 38.
  - New: `contact.py` (whole-frame rows), `refcap.sh` (screen_capture only, reference) and `repcap.sh` (practice). `tint39.lua`, `t_sh.lua` and `untint39.lua` (restores every T39C tint) are the test scripts.

**Top-half saturation (ref / v36 rep / r39) and change against the v36 practice frame (pixels > 30 levels):**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref | 82 | 100 | 103 | 110 | 91 | 117 | 87 | 99 | 95 | 109 | 91 | 80 |
| v36 | 88 | 95 | 100 | 111 | 97 | 106 | 82 | 88 | 100 | 100 | 104 | 93 |
| **r39** | **88** | **95** | **103** | **111** | **97** | **105** | **83** | **90** | **102** | **101** | **104** | **93** |
| change % | 3.3 | 1.6 | 4.4 | 1.9 | 2.1 | 0.5 | 0.9 | 1.8 | 5.1 | 2.3 | 3.0 | 0.2 |

**Checks on the 9.5s (contact sheet, by eye):**
- p1, p2, p4, p6: the arches have a dark shoulder band like the ref's. The jets are small blue falls.
- p7, p8, c4: almost untouched.
- c3: the arcade is a little redder. The notch slab is unchanged at (41,54,71).

**Risks to re-check:**
- p3 (150,330), now darker (see item 2).
- The top end of the dark band beside the U tower ends on a straight diagonal. It reads as a small wedge in p5 and c1.
- The jet is a clean sheet. It is less swirly than the ref's, so the p3 and p6 far-jet boxes still read blue.

## What I measured / proved
- **Look at the reference piece close up before you rebuild it.** Three reference screen_captures showed that the "jet" is a waterfall from the back spout into the basin. The pass-38 plume answered a misread.
- **A one-row brightness profile across a feature beats single boxes.** At c1 y 300 the profile showed band positions and widths (light 320-400 / dark 410-500 / U face 510+ in the ref, against dark 330-400 / U face 410+ in ours). The dark band had to move **inward onto the U face**, not just get darker. The darken-in-place test (`shb.jpg`) left both c1 boxes at 132 and pushed p1 (80,330) the wrong way (57 -> 41).
- **Neon water saturates:** Neon (55,120,150) at T 0.2 rendered (1,199,253). SmoothPlastic (150,215,235) at T 0.15 in the dark niche renders about (119,202,229).
- **Red-lit arcade:** same colour, different capture: R 69 vs 123. Do not tune to one capture of that box.
- **Idempotence:** repeated runs give `jet38 hidden 40 | arch39 segs 544 | arcade recoloured 42 | Plaza 22642`.

## Built (method)
`fix/pass39.lua` is idempotent and runs after pass 38. The head is the pass-38 head with P39 attributes. It restores P39* first, and new parts go in `Plaza.Pass39`. It merges `Workspace.ae_kit_r39` if one is ever imported, and `fix/build_plaza.lua` IMPORTS lists r39.

The blocks:
- **JET39:** per corner, the frame is `d = (sx,0,sz).Unit`, `u = (-sz,0,sx).Unit`. A path in the (w, y) plane: run 36.6 -> 35.7 at y 6.07, a quarter curl about (35.7, 4.86) with R 1.2 in 8 steps, then a drop to (34.45, 4.15). Each step is a box `fromMatrix(mid, u, normal)` whose width fans from 0.7x to 1x, with two edge strips. It adds flecks on the curl, a froth cylinder at w 34.25 and a mist emitter at w 35.8.
- **ARCH39:** recolours `K_Arch20_slate` and `K_Groove37_dark` light. It then evaluates the arch outlines from `tools/ae_kit.py` (A19/A20: `po` = `_arc19(4.4, 5.3)`, inner = `_intrados19` with hw 7.6, hs 1.1, ry 5.4, 14 + 3 points) for both sides and all 4 mirrors. `world(u,y,w) = ((w+u)/sqrt2 * mx, y, (u-w)/sqrt2 * mz)`. Strips are lerps between the two outlines (`f` in 0.02..0.55), and each segment is one box in the w = 33 - 0.04 plane: the band (0.06 thick), ridges at f 0.11 and 0.22 (proud 0.08), and a Metal gold line at f 0.52-0.56.
- **RAID39:** recolours ArcWall37 and the trims.

## Lessons (for the workflow vault)
1. **Close up on the reference before you rebuild a small effect.** From the judging cameras, the jet looked like a plume. At 6 studs it is a waterfall. One extra screen_capture saved a second wrong rebuild.
2. **Profile a whole row of pixels across a banded feature.** That shows where each band sits and how wide it is. Single boxes only show that one value is wrong. Here the fix was to move the dark band inward, not to darken it.
3. **When the build is wider than the ref, paint the ref's layout onto your surface.** A thin overlay strip that follows the kit curve (evaluated in Lua from the same formulas) moved the band without a new mesh.
4. **Neon water goes pure cyan.** Use SmoothPlastic at low transparency and a light tint for water in a dark niche.
5. **Some review boxes are noisy.** The red-lit Raid arcade read R 69 and R 123 for the same colour in different captures. Take two captures before you tune to such a box.

## Objects built (for 5 Object Recipes)
- **Niche waterfall:** a sheet that runs off the spout lip, curls down (quarter circle R 1.2, 8 boxes) and drops into the basin. It is 3.2 wide at the landing and 2.2 at the lip, SmoothPlastic (150,215,235) at T 0.15, with 0.2-wide white edge strips (225,248,252), a few 0.2 x 0.1 white flecks on the curl, a flat froth disc (200,235,245) at T 0.3 where it lands, and a small smoke emitter at the lip (rate 12, size 0.6 -> 1.2, LightEmission 0).
- **Ridged shoulder band overlay:** a dark band (45,49,48) laid 0.04 in front of the arch's pale face. It covers the outer 55 % between the pale outer edge and the opening, with 2 lighter ridge lines (88,94,96) and a gold line at its inner edge. It is built from the arch's own outline formulas as one box per curve segment. The outer slate bands go light (130,135,140) to form the rim.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **22642** (pass 38: 21943). Workspace children are unchanged (Camera, Terrain, SpawnLocation, Plaza).
- All test tints were restored (`untint39.lua`, T39C count 0 before the final run).
- Nothing was saved or committed, and there was no computer use. `RivalsPractice_replica.rbxl` was not touched.
- Changed tracked file: `fix/build_plaza.lua` (IMPORTS r39). New files: `fix/pass39.lua` and this note.
- `tools/ae_kit.py` and `ae_kit.blend` are unchanged: no kit.
- `fix_lighting.lua` was not re-run. Technology, post effects and Atmosphere are unchanged, and Haze was not tested.
- **How to rebuild:** on the pass-38 build, run `sh out/r39w/run.sh`.

## Reference use
Targets came from the round-36 frames in `out/verify36/`. In the reference studio there were 3 screen_captures only (`out/r39w/refz/jetne.png`, `jetne2.png`, `jetc2.png`). There was no execute_luau and no position read, nothing was saved, and `ae_reference.blend` was not opened. Only own Parts and an engine-default particle texture were used.

## Next
- **Jet swirl:** split the sheet into 2-3 twisting lobes with gaps (the dark niche shows through in the ref), so that the p3/p6 boxes can go dark. A kit lathe, like `K_Splash20` but pouring forward, would do it.
- **Band top end:** finish the dark band against the U tower with a curved end, not a diagonal cut.
- **p3 (150,330):** narrow the band (BAND_F 0.45) and check whether p3 recovers while c1/p5 hold.
- Items 5-10 (pipe groove, Summon side, c2 reds, SE rocks and sand, crowns, sign and ring).
