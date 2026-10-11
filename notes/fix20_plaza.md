# Fix pass 20: Anime Expeditions spawn plaza (Raid haze on the building, dark tunnel, squat arch, bollards, stair tone, south beach)

Builder report for `notes/fix_brief20.md`, answering the round-17 review `notes/verify17_plaza.md` (7.75/10).
Items 1-5 are done, except the stair blocks and bevel. Items 6 and 8-10 were not attempted.

**Captures**
- Final set: `out/r20/r20_<cam>.png` (12 cameras, `capture_set2.py`, second frame kept).
- Contact sheet: `out/r20/contact.jpg`, with the v17 reference on the left and r20 on the right.
- Working frames: `out/r20w/<letter>_<cam>(_a).png`. The letter gives the step:
  - `a_` is the baseline;
  - `b_` to `i_` are the Raid, tunnel, stairs, bollard and south steps;
  - `k_` to `o_` come after the kit import.

**Rules kept**
- I worked from the pictures only. Every target came from `out/verify17/v17_<cam>_ref.jpg`, so the reference studio was not
  even captured this pass. No positions were read from it.
- Own geometry only. No computer use.
- The place is not saved and nothing is committed. `ae_kit.blend` is saved.

**State at the end**
- `#workspace.Plaza:GetDescendants()` = 15573. That is 15528 before pass 20, plus the Pass20 folder and its 44 pieces.
- Workspace holds only Camera, Terrain, SpawnLocation and Plaza.
- The `ae_kit_r20` model was merged into ServerStorage.Kit by the `--KIT20` header loop: 8 meshes went in and the scale cube
  was destroyed.

**Tools (`out/r20w/`)**
- `box20.py <cam> <png>...` takes 5x5 means at every round-17 review box. It re-samples each target from the v17 reference frame
  on every run. An entry can measure one pixel against a target box somewhere else, as the review does (for example c1 rep
  (540,440) against ref (880,470)).
- `cap.sh <cam> <tag>` captures twice and runs the boxes on the second frame. For p3 it also runs the eight pass-18 Raid boxes
  (`out/r18w/box.py`).
- `pick.py <cam> x,y ...` casts a practice-camera ray through a pixel and names the part it hits.
- `ground.py <cam> Y x,y ...` gives the point where a pixel's camera ray meets the plane y = Y. It needs no Studio call.
- `plane.py <cam> W x,y ...` gives the point where a pixel's ray meets the NE arch front plane w = W, as (u, y) in the arch frame.
- `pair.py ref rep out [crop]` stacks the reference over the practice frame for viewing.
- `run.sh` runs `fix/pass20.lua`.

**How to rebuild** (on a pass-19 build with `ae_kit_r20` imported)
- Run `sh out/r20w/run.sh`. It wraps `python cmd/runlua.py fix/pass20.lua <studio>` and then
  `python mcpcli.py call execute_luau cmd/pass20.json`.
- It is idempotent: it rebuilds `Plaza.Pass20`. It first restores everything it touched from the `P20*` attributes: hidden
  parts, colours, lights, emitter values, resized parts, and moved or scaled models.
- Blocks: `--RAID20`, `--TUNNEL20`, `--STAIR20`, `--BOLL20`, `--SOUTH20` and `--KIT20`.
- `fix/build_plaza.lua` has r20 in `IMPORTS`.

## 1. Raid (`--RAID20`), one change per capture pair (p3)
| step | change | haze box | tower box | pass-18 boxes |
|---|---|---|---|---|
| target | | (162,66,74) | (124,39,59) | within 15 |
| base | pass 19 (emitter 24x84x124 at (186,54,0), particles 16-24) | 12 | 50 | all within 15 |
| s1 | emitter 18x60x60, y 20-80, particles 10-16, colour (162,66,74) | 14 | 169 (sky) | hazeL 89, hazeR 160 (sky) |
| s2 | 84 wide, y 20-70 | 6 | 169 | hazeL 150, hazeR 162 |
| s3 | y 20-90 (the hazeL/R rays meet the haze plane at z -36, y 85) | 16 | 45 | hazeL 31, hazeR 43 (too saturated) |
| s4 | colour (150,80,76) | 12 | 63 | hazeL 26 (sky shows through) |
| s5 | rate 40 -> 60 | 14 | 41 | hazeL 18, hazeR 14 |
| s6 | two pink door lights, b2 r10 | door (81,27,35) -> (104,34,43) | | rim 10 -> 61: reverted |
| s7/s8 | standing 2-stud Neon ember band (200,40,30) at T 0.65, a fainter band above | | | unchanged |
| s9 | after the kit import: colour (145,98,88) | 12 | 47 | hazeL 18 (B too high), hazeR 5 |
| s10 | colour (152,90,76) | 13 | 50-65 | see below |

**Final pass-18 boxes (s10):**
- On the step pair: skull 8, tower 11, rim 10, hazeL 12, hazeR 9, shadeR 5, lowL 14, lowR 15.
- On the final set: hazeL 16, everything else the same.

**Result:**
- The haze is now a column 84 wide (was 124) with particles 10-16 (were 16-24). That is about half the area.
- Its top is near y 98, under the skull top (124). It sits behind the skull and towers instead of filling the sky.

**Not reached:**
- **Door box:** the box (693-697, 298-302) lands on the dark gothic stone above our door, because our Raid is bigger in the
  frame. Light can only push R; G 34 comes from the base colour (pass-19 lesson 6). The pass-18 rim box, 15 px lower on the
  door arch band, is within 10 of its own target.
- **Tower box** (848-852, 168-172): it lands on sky beside our right dome spire, where the reference has a lit tower. Haze can
  only tint it. A taller right spire would fix it.

## 2. Tunnel (`--TUNNEL20`) and arch (`--KIT20`, kit r20)
| step | change | c1 interior (540,440) vs ref (880,470) | c1 back wall (600,400) | p5 interior (720,400) |
|---|---|---|---|---|
| target | | (44,54,61) | (30,52,72) | (111,161,177) |
| base | pass 19 | (55,130,175) 114 | (111,129,126) 81 | (192,222,229) 81 |
| s1 | vault lights b2 r12 -> b1 r8; low tunnel lights off | (37,50,67) 7 | 79 | (156,196,208) 45 |
| s2 | K_Hero_sheet (150,205,225) -> (200,250,255) | | | |
| s3 | dark panel over the niche back (w 38), (38,50,62) | | (10,20,36) 36 | |
| s4 | panel (105,125,125) | | (46,73,92) 21 | |
| s5 | panel (70,90,98) | 8 | (24,43,65) 9 | (143,191,212) 35 |
| kit | K_Arch20 + splash (200,245,255) | (36,46,66) 8 | (28,46,70) 6 | (164,193,208) 53 (white splash) |
| k2 | splash (120,205,235) at T 0.15 | final (51,59,73) 12 | final (32,50,69) 3 | final (103,170,198) 21 |

- p1 arch slate box (198-202, 398-402) against ref (248-252, 298-302): (75,83,96), 5 off. The v17 practice was 13 off.
- The splash box (718-722, 428-432) is dominated by the mist particles. It read 119-207 R across frames with nothing changed;
  final 37.

**Arch shape, measured.** I scanned the c1 reference row by row for the edge between the dark interior and the pale band, and
projected each edge pixel onto the arch front plane.
- Points (u, y): (0, 6.49), (-1.87, 6.20), (-3.43, 5.78), (-5.13, 4.93), (-6.42, 3.65), (-7.28, 2.65).
- They fit an ellipse with half-width 7.6, centre at y 1.1 and rise 5.4, with residuals under 0.15.
- Pass 19 had springing 4.2, rise 4.0 and top 8.2.
- The sill under the U-handle projects to 8.74 (ours measured 9.41, built at 9.7). The handle top projects to 12.36 (ours 12.5).
- So the reference is not a true horseshoe. It is a squat semi-ellipse that springs just above the floor.

**Built (kit r20, `build_arch20`, `A20`).** The pass-19 arch, with:
- the intrados changed to that ellipse;
- the crown sill at 9.0;
- the single slate band and groove replaced by two stepped slate bands:
  - fronts at w 33.3 and w 33.75;
  - a/b 5.2/6.1 and 6.4/7.2 round the arc;
  - legs that fan out by 1.3 and 3.0 at the floor onto the stair rail;
  - a gold tube on each band's outer edge.

In c1 the opening is now a squat arch under a deep pale crown, as in the reference. I checked the outlines against the projected
reference points before export (`out/r20w/arch20_outline.png`).

**Splash:** `K_Splash20_water` (3.3 tall, 3 twisting lobes) sits on each drum at y 4.1. The Pass9 WaterSheets are hidden.

## 3. Bollards and rim beads (`--BOLL20`)
- The 8 domed `MedalStud` beads are hidden; the flat discs stay. The pass-16 bollards are hidden too.
- Stand-in Parts came first (base 3 x 1.5 x 3, gold ball 1.6): head 8 off, base 11 off.
- Then the kit bollard `K_Boll20`: a bevelled base with a top plate, and a squat lathe dome 1.5 across and 1.05 tall.
- The smooth dome caught the sun, so the head colour took three steps:

| head colour | p5 head box | off |
|---|---|---|
| (218,202,138) | (254,247,194) | 50 |
| (192,176,104) | (245,235,152) | 22 |
| (175,162,98) | (235,226,143) | 12 |

- The base (240,239,230) is 4 off.
- The bollard is now about 60% of the pass-16 height, and round instead of faceted.

## 4. Stair tone (`--STAIR20`)
- K_Stairs_stone (125,126,126) rendered at (201,203,198), so the sun brightens it about 1.6x.
- New colours:
  - treads (99,102,101);
  - risers (48,64,80);
  - nosings (120,124,122).
- The c4 tread box reads (169,175,170): 11 off.
- The riser box lands on a tread in our shallower stairs, so it is not a like-for-like comparison. By eye, the risers now read dark
  blue-slate between pale treads, as in the reference.
- **Not done:** the 0.2 bevel and the 4-6 stud tread blocks. They need a new stair ring mesh.

## 5. South side (`--SOUTH20`)
**Ring.** Measured in p2 (crop x 500-1100, y 60-420):
- The reference ring is 170 px wide and centred at y 160. Ours is 235 px wide and centred at y 126.
- At about 100 studs, 34 px is 6 studs.
- So the ring went 6 lower and 0.85x, in grey Slate (150,155,160).
- This is the opposite of the prose ("1.3x"); the frame wins (pass-19 lesson 3).

**Gate.**
- It is the same width as the reference in p2, but the reference gate is 1.27x taller in p6. So it is scaled 1.2x about its base,
  and the sign moves with it.
- The spiral is hidden. The door is now glass (70,205,200) with five soft cloud puffs (own K_Cloud7 mesh) at T 0.25.

**Green palm.**
- The p7 reference trunk-foot pixel (410,580) projects to (-39, 6, 49) with `ground.py`.
- The p2 crown (950,90) and the p6 crown (540,60) agree with a palm about 30 tall near (-35, 47).
- Built as a RaidPalm16 clone, 30 tall, leaves (42,95,32) with rims (70,125,42).

**Beach.**
- Six Sand discs (240,236,200) around the palm foot (-38, 57) and at the SE (70, 62). The p7 beach box ends 16 off.
- Three swim rings (kit `K_SwimRing20`, red (225,55,55) and white) at (-30, 60), (-46, 63) and (68, 64).
- **Not done:** a pineapple on the beach. The beach is also hard-edged discs, not a sand mound with a grass border.

## Final boxes (out/r20 against the v17 reference)
| box | r20 | v17 practice |
|---|---|---|
| c1 tunnel interior | 12 | 114 |
| c1 back wall | 3 | 81 |
| p5 tunnel interior | 21 | 36 |
| p1 arch slate | 5 | 13 |
| p5 bollard head / base | 12 / 4 | 75 / 62 |
| c4 treads | 11 | 43 |
| p7 beach | 16 | 149 |
| p3 haze | 13 | 13 |
| c2 arch face | 11 | 20 |

Unchanged, or not comparable:
- p3 door (100) and tower (50-65);
- c4 riser (the box lands on different geometry);
- c1 splats, c2 grass, c3 haze, p8, and the basins (items 6 and 9, not attempted).

## Not done
- Item 6: grass clumps, lawn strips, the W trees and basins.
- Item 8: the E ground pattern.
- Item 9: splat saturation.
- Item 10: skyline, pineapple, orange tree.
- The stair blocks and bevel.
- A taller right Raid spire for the tower box.

## Lessons (for the workflow vault)
1. **Fit a curve to projected edge pixels instead of nudging by "about 2 studs".** Scanning the reference frame row by row for the
   dark/pale edge, and projecting each edge pixel onto the arch's front plane, gave 10 (u, y) points. They fit one ellipse to
   within 0.15 studs. The review's prose ("low horseshoe, wider at the base") described the look, but the numbers showed a squat
   semi-ellipse springing at 1.1. Built to the numbers, the arch matched c1 on the first import.
2. **Plot the new outline against the measured points before exporting.** A 20-line PIL plot (`arch20_outline.png`) checks the
   shape in seconds. An import round trip costs the lead's time.
3. **A camera ray onto a plane can replace a ray pick.** `ground.py` and `plane.py` find where a pixel lands without touching
   Studio. That keeps working when a part I have just placed (here the palm) blocks the pick. It also gives world positions for
   reference pixels where the practice has nothing.
4. **Read the render ratio once, then scale the colour.** Sunlit Slate stairs rendered at 1.6x their colour. A shadowed panel
   rendered at about 0.26/0.40/0.58 per channel (blue ambient), and a smooth gold dome at about 1.15x. One capture gives the
   ratio, and target divided by ratio gives the colour. It landed within 3-12 in one or two steps every time.
5. **A smaller effect may need to be denser.** Shrinking the haze uncovered sky at boxes that used to sit inside the cloud. The
   fix was a narrower but denser column (rate 40 -> 60), not a wider one. Watch the boxes at the edge of whatever you shrink.
6. **Particles make boxes noisy.** Haze and mist boxes moved 10-90 levels between captures with nothing changed. Judge them on
   several frames or move the box off the particles, and never chase a single noisy reading.
7. **When two reference frames disagree, measure both and compromise.** The gate is the same width as the reference in p2 but
   1.27x taller in p6, because it stands deeper in the reference. Scaling 1.2x about its base serves both views.
8. **Check every frame a scale request is about before following it.** The review asked for the ring 1.3x larger. In p2 ours was
   already 1.4x wider than the reference in pixels, so it went 0.85x.

## Objects built (for 5 Object Recipes)

### Squat arch with stepped outer bands (`tools/ae_kit.py`: `A20`, `_arc20`, `build_arch20`)
- **Frame:** P(u, y, w) in the NE corner, front at w 33, mirrored to the 4 corners with `merge_objs(mirror4=True)`.
- **Intrados:** `_intrados19` with hw 7.6, centre (springing) 1.1 and rise 5.4 (top 6.5), then a short vertical leg to the floor.
- **Pale band:** `_arc19` a/b 4.4/5.3 out from the intrados, w 33-39.5.
  - The crown between the U-handle arms runs from the intrados up to the sill at 9.0.
  - The arms are u 2.2-3.9 from y 8.6 to 12.5, with the outer top corner rounded at r 1.1.
- **`_arc20`:** `_arc19` with the leg pushed out by flare·(k/L)^1.6, so the band fans onto the stair rail.
- **Slate bands:**
  - band 1: `_arc20(5.2, 6.1, flare 1.3)` outside the pale outline, front at w 33.3;
  - band 2: `_arc20(6.4, 7.2, flare 3.0)`, front at w 33.75 (stepped back).
- **Gold:** `tube_along` r 0.14-0.15 on the intrados, the pale/slate line, each band's outer edge, the arm outline and the sill.
- **Studio colours:** stone = hero stone; slate (74,81,87) Slate; gold = hero gold with CanQuery off.

### Sculpted splash (`build_splash20`)
- A lathe profile on 36 segments: stem 0.45-0.6, crown 1.25 at y 2.75, a curled lip, top 3.3.
- Each ring's radius is multiplied by 1 + 0.32·t·cos(3(a + 0.9t)), with t = y/3.3. That gives 3 lobes that twist with height.
- Where the profile is wider than 0.8, the lobe tips droop by 0.35·t².
- Studio: on the drum top (y 4.1), (120,205,235) SmoothPlastic at transparency 0.15. Lighter colours blow out to white.

### Squat bollard (`build_boll20`)
- Base: `rbox` 3 x 1.3 x 3 with a 0.2 bevel, plus a 2.5 x 0.25 top plate.
- Head: a lathe with a collar at r 0.62-0.66, the dome widest at r 0.76 (y 1.95) and the top at y 2.56.
- Studio: base (240,239,230) and head (175,162,98), both SmoothPlastic, at (±9.6, 0.25, ±9.6).

### Swim ring (`build_swimring20`)
- A torus with major radius 1.15 and minor radius 0.42, 24 x 10 segments, lying on y 0.
- The segments alternate into `_red` and `_white` in 6 blocks.
- Studio colours: (225,55,55) and (245,245,240).

### Tunnel back panel (Studio)
- A 14.4 x 6.4 x 0.2 Slate panel at w 38, just in front of the niche back, spanning y 2.6-9 and facing the plaza.
- Colour (70,90,98); it renders (32,50,69) in the tunnel shade.

### Raid haze column and ember wall (Studio)
- **Haze:** emitter box 18 x 70 x 84 at (182, 55, 0), particles 10-16, rate 60, colour (152,90,76).
- **Ember wall:** a 0.3 x 2 x 58 Neon strip (200,40,30) at T 0.65 standing at the facade foot (x 149.2), with a second strip at
  T 0.88 above it.

### Sand beach with palm (Studio)
- **Sand:** overlapping Sand Cylinder discs (240,236,200), 0.2 thick and 12-30 across, each 0.01 higher than the last.
- **Palm:** a RaidPalm16 clone scaled to 30 tall, its foot set by raycast; leaves (42,95,32), rims (70,125,42), wood (120,85,50).

## Files
- `fix/pass20.lua` (new). `fix/build_plaza.lua` (r20 added to `IMPORTS`).
- `tools/ae_kit.py`: pass-20 section (`A20`, `_arc20`, `build_arch20`, `build_splash20`, `build_boll20`, `build_swimring20`,
  `build_scale20`, `build_all20`, `export_r20`).
- `kit/own/ae_kit_r20.fbx`: 9 meshes, imported by the lead. `ae_kit.blend` saved.
- `out/r20/`, `out/r20w/`.
