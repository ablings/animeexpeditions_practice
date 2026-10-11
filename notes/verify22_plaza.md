# Verify round 22: Anime Expeditions spawn plaza (freestyle, after fix pass 24)

Independent review against the **live reference** on the Shadow PC, 2026-10-11. Round 21 (`verify21_plaza.md`, 8.33)
was read only for comparison; every score below is fresh.

## Method
- **Reference:** studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, cameras from `cams.json`.
- **Practice:** studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only (via `capture_set2.py` -> `mcpcli.py call screen_capture`). No code was run in either
  studio; nothing was modified or saved in either studio. No computer use.
- **Captures:** each camera captured twice per studio; the second frame was judged. Judged frames:
  `out/verify22/v22_<cam>_ref.jpg` and `v22_<cam>_rep.jpg` (1452x793). Raw PNGs `out/v22ref_*`, `out/v22rep_*`.
  Pixels changing by >30 levels between frames: 1.2-5.7% ref (water, VFX, crowd), 0.0-1.2% practice: animation, not
  streaming.
- **Colours:** every RGB is a 5x5 mean from the judged JPEGs, given with frame and box (x0-x1, y0-y1). Each target was
  picked in the reference frame; each box was checked on a 2x zoomed 120 px tile in both frames. Where the practice
  feature sits elsewhere the practice box is moved onto it and both boxes are given; where it is missing, that is said.
  Stud sizes are estimates from the pictures.
- **Coverage metrics** (PIL HSV, same boxes as round 21; my thresholds reproduce the round-21 reference values within
  ~2 points), ref / rep:
  - Top-half mean saturation: p1 84/93, p2 99/109, p3 101/108, p4 106/119, p5 92/98, p6 110/106, p7 86/82, p8 101/91,
    c1 97/110, c2 105/114, c3 91/85, c4 85/115. (Round 21 rep: 101, 127, 106, 119, 99, 117, 85, 95, 108, 114, 94, 121.)
  - W blue (p8 x0-420 y150-650): 37.1% / 44.8% (r21 48.4). (p7 x0-450 y100-700): 14.5% / 22.6% (r21 21.7).
  - E red (x1000-1452 y100-700): p7 20.4% / 28.5% (r21 10.7); p8 40.2% / 40.7% (r21 22.4).
  - E green, same box: p7 25.4% / 6.6% (r21 24.8); p8 3.6% / 6.1% (r21 14.9).
  - c2 stair green (x800-1452 y400-793): 6.4% / 0.1%.

## Overall read
Pass 24 moved the two frame-wide gaps for the first time: the sky in N/S views is now filled, and the E ground is red.
Both landed with new problems. The background islands are seen from below as large flat-grey faceted undersides with
pale vine fringes, and they sit close and low, so in p1, c3 and c4 they read as a grey ceiling rather than the
reference's bright, green-topped, ruin-crowned islands. The E red ground overshoots: p8 matches (40.7 vs 40.2), but in p7
E red is now 28.5% against 20.4% and the green lawn in the E foreground has gone (6.6% vs 25.4%). The Raid is now clearly a red
block, but its glow volumes read as translucent pink bubbles/domes rather than red haze. The runner Y and gem, and the
chamfered treads, are real gains at close range.

| Fix (pass 24) | Evidence |
|---|---|
| Background islands N/S | Fill the sky (c4 top-half sat 121 -> 115, p2 127 -> 109), but grey: p1 band (136,165,144) rep box 618-622,28-32 is island underside with vines vs green island top (188,209,167) ref, same box. c4 (166,170,171) rep vs (152,163,157) ref, box 700-704,60-64: similar value, but the rep is flat grey rock and the ref is foliage and ruin. |
| Giant tree behind gate | Present and in the right place. Crown too dark and teal: (46,119,133) rep box 900-904,46-50 vs (98,156,145) ref box 592-596,58-62 (both on crown). |
| Raid red rock and glow | Skull forehead (232,161,148) rep box 724-728,32-36 vs (210,107,93) ref box 718-722,38-42: now red-pink, a bit pale. Door-height glow (207,118,106) rep vs (233,119,117) ref, box 598-602,218-222: close. |
| E red carpet | (232,103,83) rep box 1100-1104,560-564 vs (197,89,76) ref box 1160-1164,526-530 (practice box moved off a red palm crown onto ground): right hue, ~15% too bright. |
| Stairs chamfered blocks | Joints now visible in c1/c2/c4. Treads (193,198,187) rep vs (186,191,185) ref, box 398-402,688-692 (c4): match. Risers (107,126,140) rep box 428-432,626-630 vs (85,103,115) ref box 428-432,646-650: ~20 levels light, so the bevel contrast is weak. |
| Outlined runner Y, gem in teardrop | Y outline gold (159,154,74) rep box 614-618,618-622 vs rim gold (183,175,89) ref box 638-642,558-562: hue now right. Runner blue (82,136,240) vs (75,126,225), box 658-662,698-702: match. Y is oversize (see c4). |
| North fall off-centre | Fall now beside the Summon; (191,220,229) rep box 812-816,110-114 vs (130,187,218) ref box 797-801,64-68: still pale and opaque. |

## Per camera (round 21 -> round 22)

### p1_spawn_n: 8.5 -> 8.5
- **Gains:** gold tree mass behind Summon; two falls visible either side; purple/blue palms along the avenue.
- **Losses:** a large grey faceted island underside now fills the top ~20% of the frame from x 300 to 1100. The reference
  top band is bright green island tops, gold palace at left, waterfalls (188,209,167) at box 618-622,28-32; practice
  gives (136,165,144), same box, on grey rock with vine fringes.
- **Colour:** fall (191,220,229) vs (130,187,218) (boxes above); bollard head still smooth pale dome (214,200,117) rep box
  444-448,500-504 vs faceted dark gold (119,109,32) ref box 438-442,498-502.
- **Missing:** crowd and parasols at the stair top; Summon still a cream box with bunting.

### p2_spawn_s: 8.5 -> 8.5
- **Gains:** the giant tree now stands behind the gate and fills the open sky; floating islands at both upper corners.
- **Geometry:** the tree's crown is a flat teal mass straight above the gate; in the reference the trunk is on the left
  half and the crown is green and broken up, with a stone ring/portal drifting in the sky. Islands are grey slabs seen
  from below.
- **Colour:** crown (46,119,133) vs (98,156,145) (boxes above). Gate side panels unchanged: flat teal (29,140,139) rep vs
  glazed pale cyan (95,171,184) ref, box 656-660,298-302. Door matches: (15,109,137) rep box 710-714,298-302 vs
  (9,131,148) ref box 722-726,298-302.
- **Missing:** crystal basins in front of the gate.

### p3_spawn_e: 8.5 -> 9
- **Gains:** the Raid now reads as a red mass: red-pink skull with red eyes and drip, red rock tower, red glow round the
  facade at door height, red trees in front. Biggest single improvement this round.
- **Geometry:** the glow is built from translucent pink domes/spheres whose edges read as bubbles; the reference glow
  is a soft, ragged haze with dark branches in front of it. Facade under the sign is still a dark plain box; the
  reference has a gothic arch door with a small skull keystone. Rock spires are thin and few (one at left).
- **Colour:** skull and glow (see table): close.

### p4_spawn_w: 8.5 -> 8.5
- No meaningful change. Ring (142,169,196) rep box 682-686,316-320 vs richer blue (131,151,202) ref box 674-678,295-299.
- **Geometry:** plain round ring; the reference is a horseshoe with a crest and darker inner band. Reference trunk
  wider with roots; ivy and blue drips over the portal missing; white block at right where the gold palace stands.

### p5_diag_ne: 8.5 -> 8.5
- **Gains:** runner Y is outlined (gold lines, dark blue core) and the foot gem sits in a gold teardrop; Raid is red.
- **Geometry:** the Y is too big: arms span nearly the full runner width and the stem is short; the reference Y is
  slim, with arms meeting about 40% down and a long stem to the gem. Raid glow domes read as pink bubbles.
- **Missing:** Summon facade detail; Boss Rush is still a purple spiral disc; crowd and parasols.

### p6_diag_sw: 8.5 -> 8.5
- **Gains:** Y and gem as p5; the tree behind Expeditions and islands fill the sky.
- **Geometry/colour:** gate walls flat teal (as p2); Story ring plain (as p4); bollard as p1.

### p7_high: 8 -> 8.5
- **Gains:** E field is now red under the red trees; lime discs and W pools gone.
- **Overshoot:** E red 28.5% vs 20.4%, E green 6.6% vs 25.4%: the reference keeps a strip of green lawn in the E
  foreground (lower right) and the red is broken by grey paving; practice is solid red to the plaza edge.
- **Colour:** S lawn (95,116,84) rep vs (96,129,58) ref, box 898-902,618-622: value right now, but too grey (lacks
  yellow-green). W blue 22.6% vs 14.5%: unchanged from round 21.
- **Geometry:** pink translucent domes visible at E edge; white plinth paths still dominate the S foreground.

### p8_top: 8 -> 8.5
- **Gains:** E red coverage matches (40.7% vs 40.2%); lime discs gone.
- **Colour:** E ground (232,103,83) vs (197,89,76) (see table): ~15% too bright. W blue 44.8% vs 37.1% (better than 48.4,
  still high); W has a single huge blue canopy at far left plus open lawn and sand discs where the reference is
  dense mixed canopy with water.
- **Geometry:** a long flat grey slab E of the plaza (roughly x 930-1275, y 330-455 in the rep frame) has no counterpart;
  the Raid glow domes show as overlapping pink circles at the E edge.

### c1_wall: 8.5 -> 8.5
- **Gains:** treads show block joints; tunnel back wall (33,53,71) rep vs (44,54,62) ref, box 878-882,468-472: close
  (slightly too blue).
- **Geometry:** foreground foliage is flat splat decals (large flat red and blue splashes on the floor); the reference
  has 3D fern clumps (blue left, red right) standing on the stair edges. Notch tree still a bare stick with two pods.

### c2_fountain: 8 -> 8
- **Gains:** fern sprays now sit on the upper stair at right ((76,113,64) rep box 1120-1124,292-296, darker than ref fern
  (114,166,54) ref box 928-932,588-592).
- **Missing:** the fern spray on the lower stair edge by the fountain: practice box 928-932,588-592 lands on bare tread
  (196,203,192). Stair green 0.1% vs 6.4%. Floor leaves are flat lime decals. Boss Rush still a spiral on a box.
- **Geometry:** treads now jointed, but very pale and soft with weak bevel (see c4).

### c3_pavilion: 8.5 -> 8.5
- **Gains:** Raid skull/tower are red now; tower brick (147,90,89) rep box 1250-1254,300-304 vs red rock (149,54,58) ref
  box 1348-1352,278-282 (practice box moved off a bright red stripe onto brick): closer, still too pink-grey.
- **Losses:** the W island underside fills the upper left quarter as a grey faceted slab; the reference has a green
  island top with ruins, two waterfalls and the gold tree.
- **Missing:** hanging vines on the pavilion, crowd at Summon.

### c4_stairs: 8 -> 8
- **Gains:** treads split into chamfered blocks; gold tree mass and Summon centred; Y outlined in the right gold.
- **Losses:** the sky is now a flat grey faceted island underside above the Summon (top-half sat 115 vs 85: the frame
  is still the most saturated because the trees are saturated blue/purple and the sky band remains blue at the edges).
  The reference skyline is a pale, layered mass of green island tops, ruins and waterfalls.
- **Geometry:** the Y is about 2x too large: outline ~1 stud wide and arms span the whole runner; the reference Y outline
  is ~0.4 stud and the arms span ~60% of the runner. Treads are very pale and pillowy; risers too light (see table).
- **Missing:** crowd, parasols, lamp posts; textured pineapple.

## Scores
| camera | r21 | r22 |
|---|---|---|
| p1_spawn_n | 8.5 | 8.5 |
| p2_spawn_s | 8.5 | 8.5 |
| p3_spawn_e | 8.5 | 9 |
| p4_spawn_w | 8.5 | 8.5 |
| p5_diag_ne | 8.5 | 8.5 |
| p6_diag_sw | 8.5 | 8.5 |
| p7_high | 8 | 8.5 |
| p8_top | 8 | 8.5 |
| c1_wall | 8.5 | 8.5 |
| c2_fountain | 8 | 8 |
| c3_pavilion | 8.5 | 8.5 |
| c4_stairs | 8 | 8 |
| **average** | **8.33** | **8.46** |

## Top-10 for the next pass (ranked by visual impact)
1. **Make the background islands read as islands, not a grey ceiling (p1, c3, c4, p2).** Push the N and W islands
   ~100 studs further out and drop them so their tops are at or just below eye level from the stairs (camera y 6):
   the top surface, not the underside, must be visible. Give each a green top (target (188,209,167), p1 ref box
   618-622,28-32) with 3-5 ruin towers/arches 20-40 studs tall in pale stone and a waterfall off the edge. Lighten and
   warm the undersides from flat grey to (150,140,125) with a soft gradient; remove the pale vine fringe. Goal: no
   grey rock above the Summon in c4.
2. **Raid glow: replace the bubble domes (p3, p5, p7, p8, c3).** Delete or hide the translucent pink spheres; use 2-3
   flat camera-facing glow cards or a ParticleEmitter (Size 15-25, Transparency 0.6-0.9, colour (233,119,117), p3 ref
   box 598-602,218-222) hugging the facade at 5-20 studs height, with dark bare branches in front. Add 3-4 more rock
   spires 25-40 studs tall in (149,54,58) (c3 ref box 1348-1352,278-282); retint the brick from (147,90,89) to that.
3. **Runner Y proportions (c4, p5, p6).** Scale the Y down: outline 0.4 stud, arms span ~60% of the runner width,
   arms meet ~40% down the slab, long stem down to the gem. Keep the gold (159,154,74) -> nudge to (183,175,89) (c4 ref
   box 638-642,558-562).
4. **E ground balance (p7, p8).** Keep the red, but restore a 15-25 stud strip of green lawn (96,129,58) along the E
   plaza edge (the p7 lower-right foreground) and break the red with grey paving paths 6-8 studs wide. Darken the red to
   (197,89,76) (p8 ref box 1160-1164,526-530). Remove the long flat grey slab E of the plaza. Target p7 E red ~20%,
   E green ~25%.
5. **Giant tree crown (p2, p6).** Recolour from (46,119,133) to green (98,156,145) (p2 ref box 592-596,58-62) and break it
   into 3-4 lobes; shift the trunk ~20 studs W of the gate axis so the gate is not centred under it. Add the floating
   stone ring fragments in the sky above the gate.
6. **W canopy and ground (p8, p7, p4).** Cut W blue to ~37% (p8) / ~15% (p7): replace the single giant blue canopy at far
   W with 6-10 mixed trees (blue, purple, gold, 15-25 studs crowns) and fill the open lawn/sand discs with water and
   rock.
7. **3D foliage instead of splat decals (c1, c2, p1-p6).** Replace the flat red/blue/lime floor splats with standing fern
   clumps (3-5 studs, blue on W stair edges, red on E, lime (114,166,54) by each fountain, c2 ref box 928-932,588-592),
   placed on stair edges and fountain bases. Target c2 stair green 0.1% -> ~6%.
8. **Stair contrast (c4, c2, c1).** Darken risers from (107,126,140) to (85,103,115) (c4 ref box 428-432,646-650) and make
   the joint/bevel a dark line (~0.15 stud, (70,85,95)) rather than lighter; reduce the tread chamfer roundness so blocks
   read as cut stone, not pillows.
9. **Expeditions gate and Story portal (p2, p6, p4).** Gate side panels to glazed pale cyan (95,171,184) (p2 ref box
   656-660,298-302) with white/gold mullions; two crystal basins in front (4 studs). Story ring: deepen to (131,151,202)
   (p4 ref box 674-678,295-299), add a blue horseshoe crest on top and a darker inner band.
10. **Summon/Boss Rush facades, bollards, falls (p1, p5, c3, c4).** Summon: white-gold palace face (246,245,193) (c4 ref
    box 717-721,374-378) with blue arched windows and a medallion. Boss Rush: purple gothic shrine ~25 studs replacing
    the spiral disc. Bollard heads faceted dark gold (119,109,32) (p1 ref box 438-442,498-502). Falls translucent
    (~0.5) tinted (130,187,218) (p1 ref box 797-801,64-68).
