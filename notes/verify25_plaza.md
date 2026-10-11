# Verify round 25: Anime Expeditions spawn plaza (freestyle, after fix pass 27)

Independent review against the **live reference** on the main PC, 2026-10-11. I did not build this pass. Round 24
(`verify24_plaza.md`, 8.83) was read for comparison only; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only, called directly as the MCP tool. No code was run in either studio, nothing was modified
  or saved, and no computer use was used.
- **Captures:**
  - Each camera was captured twice per studio and the second frame was judged.
  - Judged frames: `out/verify25/v25_<cam>_ref.jpg` / `_rep.jpg`. Both frames of every pair: `out/verify25/raw/`.
  - Every frame is full size, **1284 x 793** (no short frames; no Studio panel was open).
  - Pixels that changed by more than 30 levels between frames 1 and 2: 0.8-4.0% in the reference (water, VFX, crowd)
    and 0.0-0.1% in practice. The frames match; the difference is animation.
- **Coordinates:** all pixel boxes are in 1284-wide frames. Round 24 used 1452-wide frames, so subtract 84 from an r24
  x to compare.
- **Colours:** every RGB is a 5x5 mean from the judged JPEGs, given as frame + box. Each box was checked on a 2x zoomed
  tile. Boxes that missed (sky behind leaves, a lamp on the ring) were moved and re-sampled. Stud sizes are estimates
  from the pictures.
- **Comparing with pass 26:** the pass-26 practice frames (`out/r27w/base/r26_<cam>.png`, same 1284 x 793 layout) were
  put side by side with the r25 practice frames to see what pass 27 changed.
- **Top-half mean HSV saturation** (same PIL metric as round 24; ref r25 / rep r24 / **rep r25**):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r25 | 82 | 98 | 103 | 110 | 90 | 113 | 88 | 96 | 95 | 109 | 91 | 83 |
| rep r24 | 90 | 88 | 91 | 105 | 101 | 90 | 76 | 86 | 112 | 104 | 90 | 115 |
| **rep r25** | **78** | **84** | **84** | **101** | **92** | **90** | **72** | **80** | **99** | **101** | **88** | **84** |

## Overall read
**Wins from pass 27:**
- The N views are no longer over-saturated. c4 is 84 against 83 (was 115), c1 99 against 95, p5 92 against 90.
- The giant crown in p2 reads as a dark lobed tree, not fog. Lit lobe (89,148,130) rep box 498-502,28-32 vs
  (81,135,130) ref box 498-502,58-62.
- The stairs now read as cut stone blocks with joints. Tread and riser values match: c4 tread (191,192,189) ref box
  298-302,698-702 vs (192,198,192) rep box 248-252,688-692; c4 riser (76,97,110) ref box 298-302,648-652 vs (82,102,109)
  rep box 298-302,638-642.
- The c1 red floor flakes are gone, and the c1 blue clump now matches: (80,159,241) ref box 345-349,645-649 vs
  (92,171,240) rep box 228-232,628-632.
- Gold trees now break up the W lawn in p7/p8.

**Two of the fixes overshot:**
1. **Stair blocks are too short, too puffy and too far apart.**
   - Reference blocks are about 3-4x as long as a riser is high, with flat tops, a small rounded nose and hairline joints.
   - Practice blocks are about 1.5-2x the riser, pillow-rounded on top, with wide, deep, dark joints, and each row floats
     over a dark recess.
   - Close up (c2, c4) they read as cushions or egg-crate; at distance (p5, p6, c3) the flights look busy and cobbled.
2. **The desaturation has flattened the accents.**
   - The reference N view gets its look from a pale haze plus a few strong accents: deep-blue palms, saturated column
     trees and a warm gold tree.
   - Practice now has the right average saturation, but everything is mid-pastel:
     - palm leaves (140,173,211) rep box 868-872,93-97 vs (73,106,180) ref box 313-317,209-213 (c4);
     - gold tree (198,181,130) p1 rep box 638-642,211-215 and (242,229,168) c4 rep box 638-642,228-232, vs (191,150,71)
       c4 ref box 518-522,248-252 and (221,183,78) p1 ref box 518-522,158-162.
   - The sky is also paler than the reference: c3 sky (181,209,237) rep vs (69,192,243) ref, box 648-652,58-62. As a
     result, p2/p3/p6/p7/p8 now sit 14-23 below the reference top-half saturation.

**Unchanged since round 24:** the runner Y, bollards, the Summon / Boss Rush / Raid facades, the Story crest, the gate
basins and ring fragments, the W lagoon water, and the faceted island shells (only the N island got lumps and faint
falls).

**Known gaps, ranked by visual impact** (these are what the eye notices first in the reference):
1. Dense foliage colour masses: the W blue lagoon canopy and the E red ground in p7/p8.
2. Floating islands with bright waterfalls and ruined towers (c3, c4, p1).
3. Water and VFX: fountain jets, the lagoon, the portal glow.
4. Painted textures on the facades (Summon, Raid, Boss Rush, Story).
5. Palms at scale near the camera (p7, p8).
6. Signs, crowd and props.

## Per camera (round 24 -> round 25)

### p1_spawn_n: 9 -> 9
- **Gains:**
  - The stair flights read as blocks at this distance.
  - The leaves are no longer neon. Top-half saturation is 78 vs 82.
- **Geometry:** the far island is still a faceted mint shell band (x 300-750, y 0-200). The reference has rocky
  undersides with green tops and bright falls. The practice gold tree sits behind the Summon; the reference's big gold
  tree stands left of the runner (x 250-470, y 90-230).
- **Colour:** the gold tree is beige (198,181,130), rep box 638-642,211-215, vs (221,183,78), ref box 518-522,158-162.
  The bollard head is still a smooth pale dome: (181,165,95), rep box 378-382,494-498, vs a faceted dark gold
  (140,131,53), ref box 351-355,498-502.
- **Missing:** crowd and parasols at the stair top; Summon facade detail (it is still a cream box with bunting).

### p2_spawn_s: 9 -> 9
- **Gains:** the crown is now a dark, lobed tree with matching lit colour (see above). The gate side panels are pale
  glazed cyan, (121,161,174) rep box 588-592,298-302, vs (84,165,192) ref box 608-612,298-302.
- **Remaining:**
  - Some crown lobes are still translucent mint, and the pale island band still runs right behind the crown
    (rep y 170-230, (149,171,152) rep box 498-502,198-202). In the reference, the crown and the gate sit against open,
    bright sky.
  - The floating stone-ring fragments around the white orb are missing. The reference has about 8 grey crescents in a
    ring of roughly 90 px radius (x 430-680, y 60-240); practice has the white oval and 2-3 small dark chips.
  - No crystal basins in front of the gate. Top-half saturation is 84 vs 98 (under; the sky is too pale).

### p3_spawn_e: 9 -> 9
- No real change. The pale faceted island disc still hangs top right of centre (rep x 690-980, y 0-60).
- The Raid door is hidden behind a red tree. The reference shows a gothic pointed arch with a skull keystone, flanked by
  bare branches. The skull tower and haze read well.
- Top-half saturation is 84 vs 103: the sky is pale and there is less red foliage on the stairs.

### p4_spawn_w: 8.5 -> 8.5
- **Gains:** the ring was retinted (a blue-lavender rim with cyan lamps). The blue crown and its drips are strong.
- **Remaining:**
  - Still a plain round ring. The reference has a horseshoe crest over the ring, a darker inner band, blue ivy drips and
    the root-flared trunk behind it.
  - A white cloud-like block and a white block stand at right where the reference has the gold palace.
  - Top-half saturation is 101 vs 110.

### p5_diag_ne: 9 -> 9
- **Gains:** the saturation is matched (92 vs 90).
- **Losses:** the stair flights now look cobbled. The blocks are short, with dark gaps between each block and each row;
  the reference has long blocks with hairline joints (see the stair crop in the Overall read).
- **Unchanged:**
  - The near runner panel is pale blue (105,155,242), rep box 18-22,408-412, vs a deep (55,92,213), ref box
    28-32,408-412.
  - Its gold rims are thin wire; the reference rims are about 3x wider.
  - Boss Rush is still a purple spiral disc, and the Summon a cream box.

### p6_diag_sw: 8.5 -> 8.5
- The crown on the Expeditions side (top left) still washes out into the pale island and greens. Top-half saturation is
  90 vs 113.
- The stairs are cobbled as in p5. The Story ring is plain (as in p4), the bollard as in p1, and the near runner as in
  p5.

### p7_high: 9 -> 9
- **Gains:** gold trees now mix into the W blue clumps, which is closer to the reference's mixed canopy.
- **Remaining:**
  - The S lawn is still blue-grey: (80,136,104) rep vs bright yellow-green grass (112,181,61) ref, box 898-902,618-622.
  - The W reference is a blue-water lagoon with blue palms and sand. Practice is lawn with tree clumps and flat sand
    discs.
  - The near-left palm is a faceted, saturated green low-poly star. The reference palm has long yellow-green fronds.
  - Top-half saturation is 72 vs 88.

### p8_top: 8.5 -> 8.5
- No layout change. The W half is open lawn and sand discs with scattered blue clumps; the reference is dense blue canopy
  with water and stone circles.
- The giant W tree reads as a brown star on a blue disc.
- The E red is close. The N runner channel and the four pools read right.

### c1_wall: 9 -> 9
- **Gains:** the red floor flakes are gone, and the blue clump colour matches. Red: (254,90,78) rep box
  1038-1042,598-602 vs (227,92,90) ref box 1018-1022,598-602, about 25 levels too hot in R.
- **Remaining:**
  - The side treads are pillow blocks with wide dark joints. The reference has long flat blocks with hairline joints.
  - The notch tree is still a stick trunk with a diagonal plank and three dark balls. The reference has a twisted trunk
    with green and blue leaves.
  - The fountain jet is an opaque mushroom; the reference jet is a translucent, glowing water stream.

### c2_fountain: 9 -> 9
- **Gains:** the fern is darker and close, (78,138,35) rep box 828-832,558-562, on its mid leaf. The reference fern is a
  lighter, finer spray (190,234,98) ref box 928-932,588-592 on its lit tips; the practice fern is a coarse fan.
- **Losses:** at this range the right flight is the worst stair read in the set.
  - The blocks are about 1.5x as long as they are high, with domed tops, joints about 0.3 stud wide and deep black
    wells. Each row overhangs a dark slot.
  - The reference treads (168,174,170) are long flat slabs with a thin bevelled nose and hairline joints.
- **Remaining:** two red flower decals lie on the floor at the runner (rep x 480-620, y 500-600), where the reference
  floor is clean. Boss Rush is still a spiral.

### c3_pavilion: 9 -> 9
- **Gains:** faint pale falls now hang off the left island (rep x 140-170, y 220-270).
- **Remaining:**
  - The reference falls are bright white shafts 30-60 studs long, and the reference island has rock undersides, a ruined
    tower and leafy tops. Practice still shows pale faceted shells: the canopy goes washed to near white,
    (243,252,221) rep box 28-32,173-177, vs (163,188,129) ref box 150-154,100-104.
  - The sky is too pale (see the Overall read).
  - The Raid door is hidden by a red tree, and the Summon is a cream box.
  - The cobbled stairs in the foreground cost a little.

### c4_stairs: 8.5 -> 9
- **Gains:** the main r24 problem is fixed: top-half saturation is 84 vs 83 (was 115). Joints are visible, and the
  tread and riser colours match.
- **Overshoot:**
  - The palms are pale lavender-blue (140,173,211), against deep (73,106,180) in the reference.
  - The blue column trees no longer stand out. The reference has (33,70,190), ref box 223-227,298-302, as strong
    vertical accents.
  - The gold tree is beige.
  - The stairs are pillows with deep wells. The reference blocks are about 4-6 studs long, flat, with 0.1-stud joints.
- **Runner (unchanged):**
  - Pale panel (82,137,239), rep box 468-472,698-702, vs deep (64,107,219), ref box 558-562,698-702.
  - Thin gold lines (about 8 px) vs about 25 px gold bands.
  - A thin white kerb vs a wide grey stone kerb (about 40 px at the bottom of the frame).
- **Stray:** a flat blue water decal lies across the right treads (rep x 1040-1280, y 535-555).
- **Missing:** the island falls are faint, and there is no crowd, parasols or lamp posts; the pineapple is untextured.

## Scores
| camera | r24 | r25 |
|---|---|---|
| p1_spawn_n | 9 | 9 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9 | 9 |
| p4_spawn_w | 8.5 | 8.5 |
| p5_diag_ne | 9 | 9 |
| p6_diag_sw | 8.5 | 8.5 |
| p7_high | 9 | 9 |
| p8_top | 8.5 | 8.5 |
| c1_wall | 9 | 9 |
| c2_fountain | 9 | 9 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 8.5 | 9 |
| **average** | **8.83** | **8.88** |

## Top-10 for the next pass (ranked by visual impact)
1. **Stair block proportions (every player view: c2, c4, c1, c3, p5, p6, p1-p4).**
   - Keep the jointed-block idea and the tread/riser colours.
   - Lengthen each block to about 3.5-4x the riser height (roughly 4-6 studs), so each flight row has 2-3 blocks per
     side instead of 4-6.
   - Narrow the joint from 0.3 to 0.08-0.1 stud and make it shallow (0.1 deep), in (70,85,95).
   - Flatten the top: cut the top-edge bevel radius by about 2/3 (to about 0.15 stud) and keep one rounded nose on the
     front edge only.
   - Close the gap under each row so the next riser meets the tread above with no dark slot.
2. **Restore accent saturation and a deeper sky, but keep the haze (c4, p1, c3, p2, p3, p6, p7).**
   - Palm leaves from (140,173,211) to about (75,110,190) (c4 ref box 313-317,209-213).
   - Blue column trees to about (35,75,190) (c4 ref box 223-227,298-302).
   - Gold tree leaves from (198,181,130)/(242,229,168) to (191,150,71)-(221,183,78) (c4 ref box 518-522,248-252; p1 ref
     box 518-522,158-162).
   - Sky zenith from (181,209,237) toward (70,190,240) (c3 box 648-652,58-62), with a white-ish horizon haze and cloud.
   - Leave the purple trees and the far-distance haze as they are.
   - Target top-half saturation within about 8 of the reference in all 12 cameras (now -23 in p6, -19 in p3, -16 in p7).
3. **Islands and waterfalls (c3, c4, p1, p3).**
   - Make the 3 falls bright and readable: Transparency about 0.25, colour about (235,245,250), 30-60 studs long and
     3-5 studs wide.
   - Add 2 more off the W islands seen in c3 (rep x 100-350).
   - Give the faceted canopy shells grey rock undersides (about (120,125,130)) and 3-5 rounded leafy lumps each, coloured
     toward (163,188,129) (c3 ref box 150-154,100-104), not the current near-white wash.
   - Remove the last grey disc in the p3 top (rep x 690-980, y 0-60), or lower it by about 30 studs.
4. **Runner and Y (c4, p5, p6, p1).**
   - Panel from (82,137,239) to (60,100,215) (c4 ref box 558-562,698-702).
   - Widen each gold rim band about 3x (to about 0.6 stud) in about (200,175,60).
   - Replace the thin white kerb with a grey stone kerb about 1 stud wide, (175,178,178).
   - Fill the Y core in dark blue (49,64,137) with a gold outline.
   - Delete the stray flat blue water decal on the c4 right treads (rep x 1040-1280, y 535-555).
5. **W half: lagoon and lawn (p7, p8).**
   - Replace the open W lawn and sand discs with a blue-water lagoon, about 60 x 40 studs, colour about (60,170,230)
     with lighter shallows. Put sand banks around it and 4-6 blue palms on its edge.
   - Retint the S lawn from (80,136,104) to (112,181,61) (p7 box 898-902,618-622).
   - Swap the faceted low-poly green palm at the p7 near-left for a long-frond palm in yellow-green (about (150,200,70)).
6. **Expeditions gate backdrop (p2, p6).**
   - Lower the pale island band behind the crown by another 40-60 studs, or move it about 60 studs W, so the crown and
     gate stand against sky.
   - Make the remaining translucent mint crown lobes fully opaque.
   - Add 8 grey stone crescents (each about 6-10 studs long, (150,155,165)) in a ring about 12 studs in radius around the
     white orb.
   - Add two crystal basins (about 4 studs wide) in front of the gate.
7. **Raid facade (p3, c3, p5, c2).**
   - Move the red tree in front of the Raid door about 10 studs aside so the door reads.
   - Replace the plain door with a gothic pointed arch (about 8 wide x 14 high studs) with a skull keystone.
   - Add 3-4 dark bare branch silhouettes (10-15 studs) flanking it.
8. **Story portal (p4, p6).**
   - Add a horseshoe crest (about 6 studs wide) on top of the ring.
   - Add a darker inner band, about (40,60,120), and 4-6 blue ivy drips off the rim.
   - Replace the white block at the right of p4 with a gold-and-white palace corner.
9. **Summon / Boss Rush facades, bollards, crowd props (p1, p5, c3, c4).**
   - Bollard heads: faceted 4-sided dark gold (140,131,53) (p1 ref box 351-355,498-502), replacing the smooth
     (181,165,95) dome.
   - Summon: a white-gold face with blue arched windows and a medallion.
   - Boss Rush: a purple gothic shrine about 25 studs tall, replacing the spiral disc.
   - Add 6-10 parasols/stalls and lamp posts at the Summon stair top.
10. **Fountain jets and floor clean-up (c1, c2, c3, p5).**
    - Replace the opaque mushroom jet with a translucent stream (Transparency about 0.4, (170,225,245)) plus a light
      glow.
    - Delete the two red flower decals on the c2 floor at the runner (rep x 480-620, y 500-600).
    - Cool the c1 red clump from (254,90,78) to (227,92,90).
    - Swap the coarse c2 fern fan for a finer spray with lit tips toward (190,234,98).
