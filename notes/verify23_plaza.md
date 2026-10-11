# Verify round 23: Anime Expeditions spawn plaza (freestyle, after fix pass 25)

Independent review against the **live reference** on the Shadow PC, 2026-10-11. Round 22 (`verify22_plaza.md`, 8.46)
was read only for comparison; every score below is fresh.

## Method
- **Reference:** studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, cameras from `cams.json`.
- **Practice:** studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885`, cameras from `cams_practice.json` (x - 3000, y - 3).
- **Tools:** `screen_capture` only (via `capture_set2.py` -> `mcpcli.py call screen_capture`). No code was run in either
  studio; nothing was modified or saved in either studio. No computer use.
- **Captures:** each camera captured twice per studio; the second frame was judged. Judged frames:
  `out/verify23/v23_<cam>_ref.jpg` and `v23_<cam>_rep.jpg` (1452x793). Raw PNGs in `out/verify23/raw/`.
  Pixels changing by >30 levels between frames: 1.3-4.6% ref (water, VFX, crowd), 0.0-2.3% practice: animation, not
  streaming.
- **Colours:** every RGB is a 5x5 mean from the judged JPEGs, given with frame and box (x0-x1, y0-y1). Each target was
  picked in the reference frame; each box was checked on a 2x zoomed 120 px tile in both frames. Where the practice
  feature sits elsewhere, the practice box is moved onto it and both boxes are given. Stud sizes are estimates from the
  pictures.
- **Coverage metrics** (PIL HSV; blue H140-185, red H<=12 or >=240, green H40-100, S>80-110, V>50-60). These thresholds
  give the same reference values as round 22 within 1.2 points. Reference / practice r23 (practice r22 in brackets):
  - Top-half mean saturation: p1 83/96 (93), p2 99/113 (109), p3 100/109 (108), p4 105/119 (119), p5 93/107 (98),
    p6 110/106 (106), p7 86/82 (82), p8 101/92 (91), c1 97/117 (110), c2 104/117 (114), c3 91/93 (85), c4 85/118 (115).
  - W blue: p8 (x0-420 y150-650) 37.7 / 44.9 (44.9); p7 (x0-450 y100-700) 15.1 / 23.3 (23.3). Unchanged.
  - E red (x1000-1452 y100-700): p7 20.1 / 16.1 (25.7); p8 38.6 / 34.4 (34.1).
  - E green, same box: p7 25.9 / 16.9 (6.7); p8 3.9 / 8.7 (6.1).
  - c2 stair green (x800-1452 y400-793): 6.9 / 10.5 (0.1).

## Overall read
Pass 25 fixed round 22's biggest regression. The grey island undersides no longer form a ceiling over the Summon. From
the stairs you now see island tops with canopy and arched ruins. The top colour above the N stair matches the reference
almost exactly: (178,201,168) practice vs (189,209,165) reference, p1 box 618-622,28-32.
The giant tree crown is green and in lobes: (96,148,140) practice vs (100,156,146) reference, p2 box 592-596,58-62.
The Raid's pink bubble domes are gone and the glow now reads as red haze. The E field is balanced: p7 E red is 16.1 vs
20.1 and E green 16.9 vs 25.9 (round 22: 25.7 / 6.7), with grey paths.

The remaining gaps are mostly about finish:
- The island canopies are pale, faceted, mint-grey low-poly masses. Grey undersides still show at the top corners of
  p1, p2, p3 and c3.
- The new skybox is a much stronger blue than the reference.
- Practice frames are still more saturated (c4 top half 118 vs 85).
- The new fern clumps are dark lime cones that read as lettuce.
- The W half is untouched.

| Fix (pass 25) | Evidence |
|---|---|
| Islands pushed out/down, canopy and ruins on top | p1 (178,201,168) rep vs (189,209,165) ref, box 618-622,28-32 (both on island top): match. c3 W island (147,171,150) rep box 40-44,60-64 vs (152,192,134) ref box 150-154,100-104: right value, too grey/cool (lacks yellow-green). c4 above Summon (189,200,199) rep box 640-644,80-84 vs (152,162,159) ref box 700-704,60-64: island now present, ~35 levels too pale. |
| Giant tree crown green, 4 lobes, trunk west | (96,148,140) rep vs (100,156,146) ref, box 592-596,58-62: match. Read as a pale, semi-translucent mint mass in p2/p6 because the lobes are low-contrast against the pale islands. |
| Raid glow cards, spires, red retint | Glow (200,112,104) rep box 640-644,170-174 vs (224,112,111) ref box 598-602,218-222: close (rep box moved onto the haze; the ref box falls on a pink turret in rep). Brick (119,92,103) rep box 1360-1364,270-274 vs red rock (150,53,58) ref box 1348-1352,278-282 (c3): still grey-mauve, not red rock. |
| E ground darker, paths, lawn wedge, slab removed | (212,95,80) rep box 1110-1114,555-559 vs (197,88,74) ref box 1160-1164,526-530 (p8; rep box moved off a red palm crown onto ground): close. Slab gone. |
| Slim runner Y with long stem | c4: proportions now right at close range. Rim gold (162,140,40) rep box 560-564,564-568 vs (183,175,89) ref box 638-642,558-562 (both on runner rim gold): too dark and saturated. At distance (p5 stem, row y 502) the ref Y has two ~10 px gold bands (196,176,59) (ref box 150-154,500-504) around a ~10 px dark core (41,68,159). Rep has ~5 px pale gold lines (195,197,132) around a 12 px core (39,75,197), so the Y reads as thin wire. |
| 16 standing fern clumps | c2 fern (63,132,18) rep box 900-904,500-504 vs (114,166,54) ref box 928-932,588-592 (rep box moved onto the clump; the ref box lands on bare tread in rep): ~50 levels too dark, too saturated. Stair green now 10.5 vs 6.9 (overshoot). Clumps are solid cones of hard-edged cards. |
| Darker risers and joints | c4 riser (109,137,149) rep box 400-404,505-509 vs (85,103,115) ref box 428-432,646-650 (rep box moved onto a riser): ~25 levels too light, barely changed from round 22. Tread (192,198,185) vs (186,191,185), box 398-402,688-692: match. Block joints are barely visible in c4. |
| Skybox (known) | p2 sky (60,196,240) rep vs (172,215,236) ref, box 760-764,20-24: rep is a saturated cyan-blue. The ref sky is pale and hazy with cloud. |

## Per camera (round 22 -> round 23)

### p1_spawn_n: 8.5 -> 9
- **Gains:** grey island ceiling gone. Above the Summon there is now an island top with canopy and an arched ruin at
  the same colour as the reference (table). Fern clumps stand at the runner foot. The Y is slim.
- **Geometry:** a grey faceted underside still fills the top-left corner (x 0-400, y 0-150). The reference has the
  gold palace and blue palms there. Canopies are faceted and pale. The reference islands are soft, layered green with
  waterfalls.
- **Colour:** bollard head (214,201,116) rep box 444-448,500-504 vs faceted dark gold (119,109,32) ref box
  438-442,498-502: still a smooth pale dome. Top-half saturation 96 vs 83.
- **Missing:** crowd and parasols at the stair top; Summon still a cream box with bunting.

### p2_spawn_s: 8.5 -> 8.5
- **Gains:** crown green and lobed, trunk off-axis (table).
- **Geometry/colour:** the crown lobes and the islands behind are all pale mint-grey, so the tree's silhouette dissolves
  into the islands. The reference crown is a darker, saturated green against white sky. The sky is cyan (table). Grey
  undersides remain at both upper corners. Gate side panels unchanged: (30,138,141) rep vs (95,170,185) ref, box
  656-660,298-302 (both on the side panel).
- **Missing:** crystal basins in front of the gate; floating stone ring fragments.

### p3_spawn_e: 9 -> 9
- **Gains:** bubble domes gone. Red haze around the tower and a red light strip at the door read much more like the
  reference's glow.
- **Geometry:** facade under the sign is still a plain dark box. The reference has a gothic arch door with a skull
  keystone and dark bare branches in front of the glow. Grey island underside top-left.
- **Colour:** glow close (table).

### p4_spawn_w: 8.5 -> 8.5
- No meaningful change. Ring rim (155,162,194) rep box 683-687,345-349 vs (130,151,202) ref box 674-678,295-299 (rep box
  moved onto the rim): too pale and grey.
- **Geometry:** plain round ring; the reference is a horseshoe with a crest, a darker inner band, ivy and blue drips.
  The reference trunk is wider and has roots. A white block stands at right where the reference has the gold palace.

### p5_diag_ne: 8.5 -> 8.5
- **Gains:** Raid glow is red haze, not bubbles; fern clumps on both stair flanks.
- **Losses:** the runner Y reads as thin pale-gold wire (see table). The reference Y is a bold gold band.
- **Missing:** Summon facade detail; Boss Rush is still a purple spiral disc; crowd and parasols.

### p6_diag_sw: 8.5 -> 8.5
- **Changes:** the crown behind Expeditions is now pale mint and semi-transparent-looking. It reads as fog more than a
  tree. Y as p5.
- **Geometry/colour:** gate walls flat teal (as p2); Story ring plain (as p4); bollard as p1.

### p7_high: 8.5 -> 9
- **Gains:** E field is balanced: red under the trees, grey paths, green lawn in the lower right. E red 16.1 vs 20.1 and
  E green 16.9 vs 25.9, up from 6.7.
- **Colour:** S lawn (95,116,84) rep vs (91,126,55) ref, box 898-902,618-622: value right, still too grey (lacks
  yellow-green). W blue 23.3 vs 15.1: unchanged.
- **Geometry:** white plinth paths still dominate the S foreground.

### p8_top: 8.5 -> 8.5
- **Gains:** slab gone, E ground hue/value close (table), E red 34.4 vs 38.6.
- **Losses/unchanged:** W blue 44.9 vs 37.7. The far W is still one huge blue canopy plus open lawn and sand discs; the
  reference has dense mixed canopy with water and stone circles. The E paths read as straight grey strips; the reference
  paving is irregular.

### c1_wall: 8.5 -> 8.5
- No change in frame. Foreground foliage is still flat splat decals (big blue and red splashes on the floor). The
  reference has 3D blue (left) and red (right) fern sprays standing on the stair edges. The new clumps are not in this
  view. The notch tree is still a bare stick with two pods. Top-half saturation 117 vs 97.

### c2_fountain: 8 -> 8.5
- **Gains:** a standing fern clump now sits at the stair foot by the fountain, where the reference has its spray. Stair
  green 0.1 -> 10.5 (ref 6.9).
- **Geometry/colour:** the clump is about 2x too big and too dark (table). It is a solid cone of hard cards; the
  reference is a loose, low, bright spray. The floor leaves are still flat lime decals and the treads are pale and
  smooth. Boss Rush is still a spiral on a box.

### c3_pavilion: 8.5 -> 9
- **Gains:** the grey slab in the upper-left quarter is replaced by island tops with arches and canopy over the gold
  tree. The Raid has no bubbles.
- **Colour:** island (147,171,150) vs (152,192,134), brick (119,92,103) vs (150,53,58) (table).
- **Missing:** waterfalls off the W islands, hanging vines on the pavilion, crowd at the Summon, Raid arch door.

### c4_stairs: 8 -> 8.5
- **Gains:** no grey ceiling. The Summon is backed by an island with arched ruins and gold trees. The Y now has the right
  proportions at close range.
- **Losses/unchanged:** top-half saturation 118 vs 85, the worst frame (cyan sky + saturated blue/purple trees). The
  island above the Summon is too pale (table). Risers too light and joints faint, so the stairs read as smooth plaster,
  not cut stone. Rim gold too dark (table).
- **Missing:** crowd, parasols, lamp posts; blue fern sprays on the stair flanks; textured pineapple.

## Scores
| camera | r22 | r23 |
|---|---|---|
| p1_spawn_n | 8.5 | 9 |
| p2_spawn_s | 8.5 | 8.5 |
| p3_spawn_e | 9 | 9 |
| p4_spawn_w | 8.5 | 8.5 |
| p5_diag_ne | 8.5 | 8.5 |
| p6_diag_sw | 8.5 | 8.5 |
| p7_high | 8.5 | 9 |
| p8_top | 8.5 | 8.5 |
| c1_wall | 8.5 | 8.5 |
| c2_fountain | 8 | 8.5 |
| c3_pavilion | 8.5 | 9 |
| c4_stairs | 8 | 8.5 |
| **average** | **8.46** | **8.67** |

## Top-10 for the next pass (ranked by visual impact)
1. **Sky and overall saturation (every player-height view, worst c4/c1/p4).** Replace or tint the skybox toward pale hazy
   blue (172,215,236) (p2 ref box 760-764,20-24) with cloud; current (60,196,240). Raise Atmosphere Haze/Glare slightly
   so distant islands wash toward white. Target top-half saturation within ~10 of the reference (c4 118 -> ~95,
   c1 117 -> ~105, p1 96 -> ~88). If still high, drop the blue/purple tree leaf saturation by ~10%.
2. **Island canopies: soften and warm (p1, p2, p6, c3, c4).** Recolour canopy from mint-grey (147,171,150) to
   yellow-green (152,192,134) (c3 ref box 150-154,100-104). Break the faceted shells into 3-5 overlapping rounded lumps
   per island, 8-15 studs. Add 2 waterfalls (falls translucent ~0.5, tint (130,187,218)) off the W/N island edges.
   Darken the island mass directly above the Summon from (189,200,199) to (152,162,159) (c4 ref box 700-704,60-64).
   Hide the remaining grey undersides at the frame corners: drop those islands another 20-30 studs or move them ~60
   studs outward (p1 top-left, p2 both corners, p3 top-left).
3. **Giant tree reads as fog (p2, p6).** Separate it from the islands: darken and saturate the crown lobes to
   (80,140,110) on shadow sides with (100,156,146) lit tops (p2 ref box 592-596,58-62). Make them fully opaque. Make sure
   no pale island sits directly behind the crown in p2 (move that island ~40 studs W or lower it).
4. **Stair stone (c4, c2, c1).** Risers from (109,137,149) to (85,103,115) (c4 ref box 428-432,646-650). Make the
   joints a dark 0.15-stud line (70,85,95) every 4-6 studs along each tread. Add a slight tread-edge bevel highlight so
   blocks read as cut stone. This is the second pass asking for it: check the riser material actually changed in Place1.
5. **Fern clumps: lighter, looser, smaller, colour-coded (c2, p1-p6, c1).** Scale to ~60% (2.5-3 studs high, 4-5 wide),
   flatter spray rather than cone. Lighten to (114,166,54) (c2 ref box 928-932,588-592) from (63,132,18). Make W-side
   clumps blue and E-side red as in c1/c4 ref. Then delete the flat blue/red floor splats in c1 and put clumps on those
   stair edges. Target c2 stair green ~7 (now 10.5).
6. **Runner Y at distance (p5, p6, p1).** Keep the c4 proportions, but widen each gold outline from ~0.25 to ~0.5 stud
   and colour it (196,176,59) (p5 ref box 150-154,500-504), not pale (195,197,132). Fill the arms with the dark core
   (41,68,159) as well as the stem. Runner rim gold from (162,140,40) to (183,175,89) (c4 ref box 638-642,558-562).
7. **W canopy and ground (p8, p7, p4).** Unchanged for two rounds: W blue 44.9 vs 37.7 (p8), 23.3 vs 15.1 (p7). Replace the
   single giant blue canopy at far W with 6-10 mixed trees (blue, purple, gold; 15-25 stud crowns). Fill the open lawn and
   sand discs with water pools and stone circles. Lawn from (95,116,84) to (91,126,55) (p7 ref box 898-902,618-622).
8. **Expeditions gate and Story portal (p2, p6, p4).** Gate side panels from (30,138,141) to glazed pale cyan
   (95,170,185) (p2 ref box 656-660,298-302) with white/gold mullions; two crystal basins (4 studs) in front. Story ring
   rim from (155,162,194) to (130,151,202) (p4 ref box 674-678,295-299), plus a horseshoe crest on top, a darker inner
   band and ivy/blue drips.
9. **Raid facade and rock (p3, p5, c1, c3).** Replace the dark box under the sign with a gothic pointed arch door
   (~8 wide x 14 high studs) with a small skull keystone. Retint brick from (119,92,103) to red rock (150,53,58) (c3 ref
   box 1348-1352,278-282). Put 3-4 dark bare branch silhouettes (10-15 studs) in front of the glow.
10. **Summon/Boss Rush facades, bollards, crowd props (p1, p5, c3, c4).** Summon: white-gold palace face with blue arched
    windows and a medallion. Boss Rush: purple gothic shrine ~25 studs replacing the spiral disc. Bollard heads faceted
    dark gold (119,109,32) (p1 ref box 438-442,498-502), not the smooth (214,201,116) dome. Add 6-10 parasols/stalls and
    lamp posts at the Summon stair top.
