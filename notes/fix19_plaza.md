# Fix pass 19: Anime Expeditions spawn plaza (narrower dark arch, lit tunnels, Raid red, east green, tree scale)

Builder report for `notes/fix_brief19.md`, answering the round-16 review `notes/verify16_plaza.md` (7.75/10).
Items 1-5 and 7 are done. Item 6 and items 8-10 were not attempted.

**Captures**
- Final set: `out/r19/r19_<cam>.png` (12 cameras, `capture_set2.py`, second frame kept). Contact sheet: `out/r19/contact.jpg`.
- Working frames: `out/r19w/<tag>(_a).png`, with the tag prefix giving the step: `a_` is the first run, `b_`-`g_` the Raid
  steps, `h_`-`m_` the later steps and `fin_` the final check.
- Tools in `out/r19w/`:
  - `box19.py <cam> <png>...` samples every round-16 review box. It re-reads the targets from
    `out/verify16/v16_<cam>_ref.jpg` on each run, and for p8 it also prints the red/green cover.
  - `cap.sh <cam> <tag>` captures a camera twice and runs the boxes on the second frame.
  - `pick.py <cam> x,y ...` casts a practice-camera ray through a pixel and names the part it hits.
  - `run.sh` runs pass19.lua.
  - `out/r18w/box.py` still checks the eight pass-18 Raid boxes against their v15 targets.

**Rules kept**
- I worked from the pictures only. The reference studio got screen_capture only, and no positions were read from it.
- Own geometry only. No computer use.
- The place is not saved and nothing is committed. `ae_kit.blend` is saved.

**How to rebuild** (on a pass-18 build with `ae_kit_r19` imported)
- Run `python cmd/runlua.py fix/pass19.lua <studio>`, then `python mcpcli.py call execute_luau cmd/pass19.json` (or run
  `out/r19w/run.sh`).
- It merges the r19 kit into Kit, then runs the blocks `--TUNNEL`, `--RAID19`, `--EAST19`, `--TREES19`, `--SPLAT19` and `--KIT19`.
- It is idempotent: it rebuilds `Plaza.Pass19`.
  - Hidden parts get `P19Hidden`. `P19T`, `P19CC` and `P19CQ` keep their old transparency, CanCollide and CanQuery, and are restored
    at the start of each run.
  - Recoloured parts keep their old colour and material in `P19Col` / `P19Mat`.
  - Lights keep their old values in `P19Light`.
  - Scaled trees keep their old pivot and scale in `P19CF0` / `P19Sc0`.
- `fix/build_plaza.lua` has r19 in `IMPORTS`. The pass-17, 18 and 19 blocks are not pasted into it.

## 1. Arch: narrower and darker (kit r19, `--KIT19`)
**Read from the c1 reference frame.**
- The c1 camera stands 16 studs in front of the arch face, which gives about 35.4 px per stud. The eye line is at y≈382.
- The arch is a pale front band whose crown rises into a U-handle. Outside it runs one dark-slate band with a groove, and every
  edge has a thin gold rim.
- Reference sizes, in studs from the arch axis:
  - intrados ±7.4 at the legs, top ≈6.5;
  - pale band outer edge ±8.1 at the legs, ≈9.7 where it meets the handle;
  - slate outer edge ±8.95;
  - handle arms u 2.1..4.0, top ≈12.4, outer corners rounded.
- The pass-18 build had 4-5 rings out to ±13.2.
- The handle top is lower than the old crest (13.5), not "1.5 higher" as the review asked. The frame overrules the prose here,
  and the handle arms are merged into the band instead of standing on it as blocks.

**Built in `tools/ae_kit.py`, pass-19 section:**
- `K_Hero19_stone/gold`: the K_Hero17 meshes with the old arch band, the crest and their gold ribbons cut out (`build_hero19`).
  - Each face is tested in the folded NE-corner frame (u, w, y).
  - The corner block and the basin are protected by explicit tests.
  - The inner rib steps (`K_Hero_rib`, `K_Hero_darkStone`) are kept as the arch's inner lip.
- `K_Arch19_stone/slate/groove/gold` (`build_arch19`, parameters in `A19`):
  - **Pale band:** from the in1 intrados (hw 7.6, springing 4.2, rise 4.0) out to a quarter ellipse centred (±3.9, 4.4) with
    a 4.4 / b 5.3, then straight legs. There is a crown piece between the arms, and the band runs w 33 to 39.5.
  - **U-handle arms:** u 2.2..3.9 from y 8.6 to 12.5, outer top corner rounded (r 1.1), w 33 to 36.5.
  - **Slate band:** between the pale outline and a / b 5.3 / 6.2, with its front at w 33.3. It is split into slate 0-0.42,
    groove 0.42-0.58 (front at w 33.65) and slate 0.58-1.
  - **Gold tubes (r 0.15):** along the intrados, the pale/slate boundary, the slate outer edge, the arm outlines and the sill.
- **Studio:**
  - The stone uses the hero stone colour.
  - Slate is (74,81,87) and the groove (14,20,26), both Slate material.
  - Gold matches the hero gold, with CanQuery off: the hull of the tube mesh blocked ray picks.
  - The K_Sweep18 band and K_Hero17 are hidden.

**Measured (c1, `out/r19w/k_c1.png`):**

| check | v16 practice | r19 | reference |
|---|---|---|---|
| arch span, gold pixels at y 420 | x 259-1192 | x 402-1049 | x 363-1090 (stair stringers included) |
| arch span, gold pixels at y 520 | x 260-1079 | x 392-1068 | x 410-1044 |
| pale band | — | (122,130,130) / (135,143,135) | (116,121,124) / (127,130,134) |
| slate band at the leg | — | (74-76,88,95) | box (74,82,87) |

- The arch is now about 1.04x the reference width, down from 1.45x.
- The review's band box (510,300) now lands on the pale arm and not on the slate. The composition matches, but this box is no
  longer a like-for-like comparison.
- The groove at the leg still reads blue, about (49,99,128). Moving its colour from (25,39,51) to (14,20,26) did not change it, so
  this pixel is probably the slate's side face catching the cyan tunnel light.

## 2. Lit arch interiors (`--TUNNEL`)
**Changes:**
- `K_Hero_vault` (niche back about 4 behind the column, crest window, shelf back) is now (120,130,140) SmoothPlastic.
- The four VaultLights are now cyan (120,220,255), brightness 2, range 12.
- A second cyan light sits low in each tunnel at P(0, 3, 38.5), brightness 1.5, range 10.
- The water sheet is (150,225,240) SmoothPlastic at transparency 0.15. Neon blew out to (252,255,255).

**Results:**

| frame | box | v16 practice | r19 | reference |
|---|---|---|---|---|
| p5 | (718-722, 398-402) | — | (189,220,229) | (169,232,245) |
| p1 | rep box (198-202, 428-432) | (6,9,18) | (49,65,99) | — |
| p5 | rep box (648-652, 418-422) | (6,10,19) | (52,69,104) | — |

- The p5 box is within 20 of the reference.
- The two rep boxes went from black to lit, but they are still a little under the review's floor of (60,70,80).
- Raising the low light to 2.5 did not move them, so it was reverted.

## 3. Raid red glow (`--RAID19`), one change per capture pair
| step | change | p3 haze (643-647,173-177) | c3 haze (1348-1352,278-282) | pass-18 boxes |
|---|---|---|---|---|
| target | | (178,77,76) | (153,52,57) | within 15 |
| base | pass 18 | (93,51,65) | (139,86,82) | all within 15 |
| s0 | haze (190,70,65) at T .15/.25, plus 4 red lights at door height (b 3, r 20) | (97,49,62) | (141,90,85) | hazeL/R (196,36,32); lowL 234 red; rim 49 off; shadeR 107 off |
| s1 | haze back to (150,100,95); 2 red lights (b 3, r 22) at (156,62,±24) | (175,51,65) | (229,90,85) | within 15 |
| s2 | light colour (255,130,115) | (174,62,74) | (199,99,93) | within 15 |
| s3 | right light red (255,60,50), b 1.5 | | (198,88,84) | |
| s4 | right light off; RaidGable (95,25,35) | | (147,80,77) | |
| s5 | haze (165,85,82), then reverted | (176,61,72) | (147,80,76) unchanged | hazeL/R 25 off |
| fin | | (174,62,75): 15 | (144,77,74): 25 | all within 15 |

**Final pass-18 boxes (`fin_p3.png`):**
- skull 8, tower 11, rim 10
- hazeL 7, hazeR 3
- shadeR 5, lowL 14, lowR 15

**Also built:**
- An ember band along the facade foot: 120 particles/s of glowing embers over a 3 x 60 strip, plus a 1.6-wide Neon glow strip
  (200,45,30) at transparency 0.35.

**Not done, on the lead's call:**
- **Door-height red lights:** dropped. They pushed the lower facade to 234 red against a target of about 125.
- **c3 haze box:** left at 25 off. G stays near 80 whatever the haze colour, light or gable colour; the base daylight on that
  surface sets it.
- **p3 haze2 box (640,255):** RaidButtress (157,54,67) against (169,128,125). The reference reads pale pink there from translucent
  haze. A light cannot add that much green to a dark purple stone.

## 4. East ground (`--EAST19`)
**Change:** the visible splat cores are hidden at random, with their nearest rim card: 70% near the plaza (x 60), falling to 30%
by x 120. That hid 162 of 414.

**Grass holes:** 24 of them, each made of 3 stacked Cylinder discs 6-11 across, (80,125,32) under (95,140,38), jittered 2.2 off
centre. Each has 7-13 white flower dots (245,245,235), 0.45 across.

**Cover** (p8, x 930-1300, y 150-650; red = R > G+50 and R > B+30, green = G > R+15 and G > B+15):

| step | red | green |
|---|---|---|
| v16 practice | 55% | 1% |
| s1: 55% / 15% hidden, 18 holes 4-8 across, (105,160,45) | 48% | 3% (the holes read as small lime dots) |
| s2: 70% / 30% hidden, 24 holes 6-11 across, darker green | 41% | 8% |
| reference | 40% | 10% |

My count gives the reference 40% red, where the review said 34%. The difference comes from the threshold, so the target was
taken from my own count of the reference frame.

## 5. Trees and crystals (`--TREES19`)
**Blue trees:**
- The four corner basin trees (K_Soft15C at (±39, ±40)) are scaled 0.5 about the trunk foot, together with their K_Soft15K
  clumps. Each clump follows the tree listed before it in Trees13.
- The W cluster (x -55..-120, |z| < 110) is scaled 0.6.
- 18 trees in all.

**Cypresses:** two at (±19, -50), cloned from K_Soft15Y, 14 tall, leaves (40,75,200). The c4 box (313-317, 298-302) reads
(22,73,169) against (33,65,184), within 15.

**Crystals:** decided by casting practice-camera rays through the reference pixels.
- The c4 reference pixels (255,365) and (230,330) hit `Pass9.K_Pod8` at (-21.9, 8.9, -51.3) in the practice. The reference has a
  low blue bush there.
- The c1 reference pod pixels (610,150) and (895,215) hit an island rock and a red palm in the practice, and no pod.
- So only the two N-stair-top pods (±22, -51) are hidden. The other six pods stay.

## 7. c1 splats (`--SPLAT19`)
- The two pairs of star ferns in the NE quadrant are hidden.
- K_Splat17 clumps replace them, about 4.6 across: blue on the N side at (13,-24) (70,150,240)/(120,185,250), and red on the E side
  at (25,-13) (225,90,85)/(240,135,125). The swap now matches the reference (blue at left, red at right in c1).
- These clumps sit about 4 studs from the c1 camera, so they fill more of the frame than the reference's.
- The review boxes miss them, because the practice clumps sit at the old fern spots and not where the reference's are.

## Not done
- **Item 6:** bollards and rim beads.
- **Item 8:** grass style and lawn strips. The spiky grass still shows in c2 and p6.
- **Item 9:** the S side and beach.
- **Item 10:** skyline, orange tree, pineapple, basin colour.
- **The E stair splats** (p5 box (918-922, 513-517)) still read pale pink (252,161,156).

## Lessons (for the workflow vault)
1. **Measure the reference in studs before modelling.** The c1 camera's distance to the arch face is known (16 studs), so
   35.4 px/stud turns every reference edge into a stud value. The arch was then built straight to those numbers, and it came out
   at 1.04x the reference width on the first build.
2. **Cut the old piece instead of covering it.** A wider old mesh behind a narrower new one keeps its silhouette. Deleting faces by
   a box test in the corner's own frame (u, w, y), with explicit protection for the neighbours (block, basin), removed the old arch
   cleanly from the merged hero mesh.
3. **The picture beats the prose on direction.** The review asked for the handle "1.5 higher". The frame puts the reference handle
   top lower than the old crest, so the frame wins.
4. **A ray pick through a reference pixel settles "remove it or not?"** Casting a practice-camera ray through the reference
   pixel, and naming what sits there in the practice, showed which of 8 identical pods were wrong (2) and which the review's other
   request concerned (none). That avoided deleting the 6 that were fine.
5. **Mesh hulls block picks.** A thin tube mesh spread over 4 corners gets a huge collision hull, so every ray hit the gold.
   Set CanQuery off on trim meshes, or picks lie.
6. **Light cannot fix the green channel.** When a box's G and B come from daylight on the base colour, recolouring the light (or
   the haze) does not move them. Check which channel is wrong before choosing light, haze or base colour.
7. **Neon water blows out.** A Neon sheet with a cyan light behind it clipped to white. SmoothPlastic in the target colour, lit by
   the coloured light, landed within 20.

## Objects built (for 5 Object Recipes)

### Horseshoe arch with U-handle and slate outer band (`tools/ae_kit.py`: `A19`, `_arc19`, `_intrados19`, `build_arch19`)
- **Frame:** the corner diagonal frame P(u, y, w). Front at w 33, mirrored to 4 corners with `merge_objs(mirror4=True)`.
- **Outer arcs** (`_arc19(a, b, s)`): a quarter ellipse centred (s·3.9, 4.4), from the top (u = s·3.9) to (s·(3.9+a), 4.4), then
  3 leg points to the floor.
- **Intrados** (`_intrados19`): the same point count on the ellipse hw 7.6, springing 4.2, rise 4.0, from u = 3.9 down.
- **Bands:** `arch_band` between matching outlines.
  - pale: a 4.4 / b 5.3, w 33-39.5;
  - slate: a 5.3 / b 6.2, front at w 33.3;
  - groove: the middle 16% of the slate, front at w 33.65.
- **Crown:** a band between the arms, from the intrados up to y 9.7.
- **Arms:** `extrude_uy` of u 2.2..3.9 from y 8.6 to 12.5, with the outer top corner a 6-segment quarter circle of r 1.1.
- **Gold:** `tube_along` r 0.15 on each edge, just in front of its face.
- **Studio colours:** pale = hero stone, slate (74,81,87) Slate, groove (14,20,26) Slate, gold = hero gold with CanQuery off.

### Hero edit by region delete (`build_hero19`)
- Copy the merged mesh. Map each vertex through `matrix_world` to Roblox axes and fold it into the NE corner (|X|, -|Z|).
- Delete faces whose vertices all lie in w 32.9-39.6, |u| ≤ 10.05, y ≥ 0, except:
  - corner-block faces (all y ≤ 6 and min w ≥ 33.99);
  - basin faces (any vertex within 5.6 of the basin centre below y 2.7).
- For the gold: w 32.5-37.5, |u| ≤ 10.8, y ≥ 0.3.

### Lit tunnel (Studio)
- Vault mesh (120,130,140) SmoothPlastic.
- Ceiling PointLight (120,220,255), brightness 2, range 12.
- Low PointLight in front of the niche back, brightness 1.5, range 10.
- Water sheet (150,225,240) SmoothPlastic at transparency 0.15.

### Ember band (Studio)
- An invisible 3 x 0.4 x 60 Box emitter along the facade foot: (255,80,40) to (180,20,20), LightEmission 1, size 0.9 to 0.2,
  lifetime 0.8-1.4 s, speed 0.8-1.6 up, rate 120.
- A 1.6-wide Neon strip (200,45,30) at transparency 0.35 under it.

### Grass hole with flowers (Studio)
- 3 Cylinder discs 6-11 across, (80,125,32) and (95,140,38), each jittered 2.2 off centre.
- About 1.2 white 0.45 dots per stud of diameter, scattered in the inner 40%.

### Slim cypress (Studio)
- A K_Soft15Y clone scaled to 14 tall, leaves (40,75,200), foot on the ground found by raycast.

## Files
- `fix/pass19.lua` (new). `fix/build_plaza.lua` (r19 added to `IMPORTS`).
- `tools/ae_kit.py`: pass-19 section (`build_hero19`, `build_arch19`, `build_scale19`, `build_all19`, `export_r19`).
- `kit/own/ae_kit_r19.fbx`: 7 meshes (K_Arch19 ×4, K_Hero19 ×2, K_Scale19_stone). Imported by the lead. `ae_kit.blend` saved.
- `out/r19/`, `out/r19w/`.
