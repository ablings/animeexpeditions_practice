# Verify round 20: Anime Expeditions spawn plaza (freestyle, after fix pass 22)

An independent reviewer scored the build against the **live reference** on the Shadow PC on 2026-10-10.
Round 19 (`verify19_plaza.md`, 7.92) was read only for comparison. Every score below is fresh.

## Method
- **Reference:** studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b` ("Game"), cameras from `cams.json`.
- **Practice:** studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885` (AE_practice.rbxl), cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only, through `capture_set2.py` / `mcpcli.py`. No code was run in either studio, and nothing
  was modified or saved in either studio.
- **Captures:** each camera was captured twice in each studio, and the second frame was judged. The judged frames are
  `out/verify20/v20_<cam>_ref.jpg` and `v20_<cam>_rep.jpg`, 1452x793.
  - Pixels changing by more than 30 levels between the two frames: 1.1-5.5% in the reference (water, VFX, crowd) and
    0.0-1.2% in the practice (fountain mist). That is animation, not streaming.
- **Colours:** every RGB below is a 5x5 mean from those JPEGs, given with its frame and pixel box (x0-x1, y0-y1).
  - Targets are sampled from the reference frame.
  - Each box was checked on zoomed 120 px tiles, in both frames, to confirm it lands on the named feature. Where the
    practice box cannot land on the feature because it is missing or different, this is said.
  - Stud sizes are estimates from the pictures.
- **Coverage metrics** (PIL HSV, same boxes as round 19):
  - Top-half mean saturation (0-255), ref / rep: p1 84/100, p2 99/128, p3 101/106, p4 108/119, p5 92/98, p6 114/120,
    p7 90/84, p8 99/95, c1 97/109, c2 106/115, c3 91/95, c4 85/121. (Round 19 rep: 109, 132, 116, 129, 117, 127, 109,
    120, 120, 123, 105, 125.)
  - W blue (hue 0.55-0.72, sat > 0.45): p8 x 0-420, y 150-650: 32.3% ref / 48.5% rep. p7 x 0-450, y 100-700:
    14.5% / 21.6%. Unchanged from round 19.
  - E green (hue 0.17-0.40, sat > 0.3) in x 1000-1452, y 100-700: p7 25.9% / 24.8%; p8 4.0% / 14.9%.
  - E red (hue > 0.95 or < 0.04, sat > 0.45), same box: p7 18.6% / 10.5%; p8 32.5% / 22.2%. (The red bound differs
    from round 19's, so compare ref against rep only, not across rounds.)
  - Green on the c2 stairs (x 800-1452, y 400-793): 6.9% ref / 0.1% rep. The shrub balls are gone, and nothing is on the
    treads now.

## Overall read
Pass 22 landed most of its list:

| Fix | Evidence |
|---|---|
| **Atmosphere** | Top-half saturation fell in all 12 frames (by 2-25 levels). p7/p8 are now at or below the reference. p2 and c4 are still about 30 levels too saturated (see below). |
| **N avenue blue palms + gold canopy** | p1 and c4 now read like the reference: blue palms framing the stairs, gold trees behind Summon, an aqueduct on the N island. |
| **Island canopies** | Broken into blue/purple/gold lumps. They no longer read as green lollipops. |
| **Runners** | Raised slabs with a gold Y and a cyan gem. Blue matches: (91,145,241) (p5 rep, box 78-82, 468-472) against (84,141,230) (p5 ref, box 148-152, 408-412); (70,125,225) against (75,126,225) (c4, both box 658-662, 698-702). |
| **Stair grass** | The shrub balls are gone. A fern spray sits on the stair top: (119,169,70) (c2 rep, box 878-882, 288-292) against (114,166,54) (c2 ref, box 928-932, 588-592). |
| **S stair-top lawn** | Present under the gate in p2: (76,139,59) (p2 rep, box 598-602, 376-380) against (113,171,81) (p2 ref, box 558-562, 376-380). It is a little dark and saturated. |
| **Arch notch** | Now a recessed U with dark pods: (59,63,72) (c1 rep, box 688-692, 260-264) against (50,54,70) (c1 ref, box 686-690, 260-264). |
| **Raid skull** | Now lit, but tan rather than salmon-red (see p3). |
| **E side** | Red trees and lawn are in, and p7 E green matches (24.8% against 25.9%). |

What now separates the build from the reference, by visual impact:
1. **The falls are opaque white columns.** In p1, c3 and c4 they read as pillars: (220,228,232) (p1 rep, box 735-739,
   113-117), a flat white cylinder. The reference fall is a translucent ribbon, (200,235,243) (p1 ref, box 751-755,
   138-142), with the rock showing through, mist at its foot and vines at its lip. The sky is also still hard and blue
   in p2 and c4: the reference background is misty green-grey, (184,207,165) (p1 ref, box 618-622, 28-32, island
   mist), where the practice frame shows clean sky, (121,204,236) (p1 rep, same box).
2. **Facades are still blockouts.** These are the focal points of p2 and p6 and still the weakest pieces:
   - The Expeditions gate is a flat teal box with a white statue.
   - The Story portal is a ring of stone blocks.
   - Boss Rush is a pink box with a purple spiral.
   - Summon is a plain cream box with bunting.
3. **Raid is brick and orange, not red.**
   - Skull forehead: (172,117,100) (p3 rep, box 720-724, 38-42) against (213,112,95) (p3 ref, same box).
   - Haze: orange-brown (152,76,63) (p3 rep, box 618-622, 178-182) against red glow (206,118,105) (p3 ref, box 598-602,
     218-222).
   - Tower: (150,97,105) (c3 rep, box 1348-1352, 278-282) against (225,86,89) (c3 ref, same box).
4. **Stairs read as pillow blocks.** The treads are short blocks with heavy rounded bevels. In c4, 8 tread rows show
   between the plaza and the stair top, against 6 in the reference. The reference treads are long slabs with a crisp
   chamfer. The treads are also still dark: (167,174,166) (c4 rep, box 398-402, 688-692) against (186,191,185) (c4 ref,
   same box).
5. **Runner rims are white.** (246,245,243) (p5 rep, box 283-287, 478-482) against thick gold (156,141,39) (p5 ref, box
   260-264, 498-502). The runner is also built in two pieces: an upper slab, then a flat apron with a second chevron
   and a second gem. The reference runner is one slab with a rounded foot and one gem.

## Per camera (round 19 -> round 20)

### p1_spawn_n: 8 -> 8.5
- **Gains:**
  - The blue palm avenue, the gold canopy behind Summon and an aqueduct on the N island.
  - The recessed notch with pods.
  - Top-half saturation down from 109 to 100 (ref 84).
- **Geometry:**
  - **Falls:** solid white columns, not water (see the overall read).
  - **Bollards:** unchanged. The base is about 1.3x too large and pure white, (255,255,254) (rep, box 445-449, 528-532),
    against a shaded cream base (128,129,138) (ref, box 438-442, 573-577, shadow side). The head is a smooth dome,
    (240,233,159) (rep, box 445-449, 488-492), against a faceted dark gold eye (119,109,32) (ref, box 438-442, 498-502).
- **Missing:** the crowd and parasols at the stair top (only partly present), and mist round the falls.

### p2_spawn_s: 7.5 -> 8
- **Gains:**
  - The lawn strip at the stair top under the gate (see the table).
  - The green palm at right, as in the reference.
- **Geometry:** the gate is unchanged, a flat teal box with a white statue. The reference is an ornate turquoise frame
  with filigree, lamp posts and crystal fountains.
- **Colour:**
  - Still the most saturated frame: top half 128 against 99. The sky is clean blue where the reference has pale cloud
    mass and island mist round the ring.
  - The lawn is a little dark: (76,139,59) against (113,171,81).
- **Missing:** the tree on the rock pillar upper left.

### p3_spawn_e: 8.5 -> 8.5
- **Gains:**
  - Red trees round the facade.
  - The skull is lit, with bright red eyes.
- **Colour:** the skull is tan and the haze orange-brown (see the overall read). The reference wraps the whole facade in
  red glow.
- **Geometry:**
  - The "Raid" sign sits across the red drip, mid-tower. The reference sign sits on the gable over the door, with a
    small skull below it.
  - The skull sits on a brick tower; the reference has a red rock mass with spires.

### p4_spawn_w: 8 -> 8
- **Gains:** the grass fringe at the W stair top and blue palms behind the portal.
- **Geometry:** the Story tree trunk is still short and thin; the reference trunk fills the top third of the frame with
  limbs and roots.
- **Colour:** the trunk is dark and purple, (83,66,65) (rep, box 698-702, 168-172), against (113,92,66) (ref, box
  698-702, 148-152).
- **Missing:** the ivy and blue drips over the portal, and the palace at right (a white block stands there).

### p5_diag_ne: 8 -> 8.5
- **Gains:** the raised runner slabs with the gold Y and cyan gem; the blue matches (see the table).
- **Geometry:**
  - The runner is two pieces (slab, then a flat apron with a second chevron and gem). Make it one slab, as in the
    reference.
  - Summon is a cream box with bunting; the reference is an ornate gold palace.
- **Colour:** the rims are white, not gold (see the overall read).
- **Missing:** the Boss Rush shrine (still a purple spiral on a pink box).

### p6_diag_sw: 7.5 -> 8
- **Gains:**
  - The grass fringe on both stair tops.
  - The raised runners.
  - The palm grove behind the arch.
- **Geometry:**
  - **Expeditions gate:** still a flat teal box. Its door is flat cyan, (25,163,183) (rep, box 108-112, 298-302), against
    a dark cloud-swirl door (3,121,134) (ref, box 128-132, 318-322).
  - **Story portal:** a block ring with blue squares; the reference is a smooth silver horseshoe with blue gems.
- **Missing:** the lamp posts and crystal fountain at the gate.

### p7_high: 7.5 -> 8
- **Gains:**
  - Top-half saturation 84 against 90 (now matched).
  - E green 24.8% against 25.9%.
  - The S foreground has a green palm, lawn and sand.
  - The N avenue has blue palms.
- **Geometry:** white plinth paths still dominate the S foreground; the reference has a palm cluster and beach props on
  sand and grass.
- **Colour:**
  - W blue 21.6% against 14.5%.
  - E red 10.5% against 18.6%: the reference E is a red carpet under the trees; the practice frame has red trees on
    lawn.
  - The S lawn is too pale: (118,178,87) (rep, box 898-902, 618-622) against (94,128,59) (ref, same box).

### p8_top: 8 -> 8
- **Gains:** the E side has lawn and red trees in place of a bare grey field.
- **Geometry:**
  - The E/W arms are still about a third of the reference length.
  - The medallion diamond is still about 1.3x too large.
- **Colour:**
  - **W blue** 48.5% against 32.3%: unchanged and too much.
  - **E side:**
    - The grey ground still shows through in bands and is dotted with red heart blobs.
    - Lawn is pale, (140,189,106) (rep, box 980-984, 382-386), against (125,168,51) (ref, box 988-992, 298-302,
      lawn hole with white flowers).
    - The reference box lands on lawn; the practice frame has grey ground at that box.

### c1_wall: 8.5 -> 8.5
- **Gains:** the recessed notch with dark pods (see the table).
- **Geometry:**
  - **Notch tree:** a bare brown stick; the reference has a gnarled trunk with a crown.
  - **Arch:** still about 1.1-1.15x wider than the reference.
  - **Stairs:** both read as fat pillow blocks.
- **Colour:**
  - **Tunnel:** the inside is teal marble, (95,160,147) (rep, box 898-902, 428-432), against a dark slate back wall
    (44,54,62) (ref, box 878-882, 468-472). Only the lowest strip is slate: (38,45,60) (rep, box 878-882, 478-482).
  - **Pale band:** slightly light and blue, (131,142,146) (rep, box 554-558, 328-332), against (119,124,127) (ref, box
    554-558, 349-353).
  - **Gold ledge:** present but darker and lower in the tunnel than the reference ledge.

### c2_fountain: 7.5 -> 8
- **Gains:** the shrub balls are gone, and the fern spray at the stair top matches (see the table).
- **Geometry:** the treads are now bare (0.1% green against 6.9%). The reference has one spray on the plaza lip by the
  fountain base. Add one or two there.
- **Colour:** the plaza floor carries flat lime leaf decals; the reference has soft fern sprays.
- **Missing:**
  - The Boss Rush shrine (still a pink box with a spiral).
  - The grey palace domes at right; white blocks stand there.

### c3_pavilion: 8 -> 8.5
- **Gains:**
  - The background now reads like the reference: arcades, a bell tower and lumpy blue and purple canopies.
  - The sky is softened by cloud.
  - Blue palms left of the pavilion.
- **Geometry:** the left fall is a white column under the arcade island (see the overall read).
- **Colour:** the Raid tower is brick, not red glow (see the overall read).
- **Missing:** hanging vines and the gold tree mass at the far left.

### c4_stairs: 8 -> 8
- **Gains:**
  - The blue palm avenue, the gold canopy and the aqueduct.
  - The runner blue matches.
  - Risers match: (77,112,131) (rep, box 428-432, 653-657) against (85,107,121) (ref, same box).
- **Geometry:**
  - **Steps:** 8 tread rows show between the plaza and the top, against 6. Each tread is a short pillow block; the
    reference treads are long slabs (about 3x the length in frame) with a crisp chamfer.
  - **Runner Y:** sits high and thin; the reference Y is large and low on the slab.
- **Colour:**
  - **Treads** still dark: (167,174,166) against (186,191,185) (both box 398-402, 688-692).
  - **Top-half saturation** 121 against 85: the most over-saturated frame after p2.
  - **Pineapple:** still a smooth gold pot, (207,168,13) (rep, box 198-202, 418-422), against a textured fruit,
    (135,92,23) (ref, box 188-192, 408-412).
- **Missing:** the crowd, parasols and lamp posts at the stair top.

## Scores
| camera | r19 | r20 |
|---|---|---|
| p1_spawn_n | 8 | 8.5 |
| p2_spawn_s | 7.5 | 8 |
| p3_spawn_e | 8.5 | 8.5 |
| p4_spawn_w | 8 | 8 |
| p5_diag_ne | 8 | 8.5 |
| p6_diag_sw | 7.5 | 8 |
| p7_high | 7.5 | 8 |
| p8_top | 8 | 8 |
| c1_wall | 8.5 | 8.5 |
| c2_fountain | 7.5 | 8 |
| c3_pavilion | 8 | 8.5 |
| c4_stairs | 8 | 8 |
| **average** | **7.92** | **8.21** |

## Top-10 for the next pass (ranked by visual impact)
1. **Falls and background mist.** Seen in p1, p2, c3, c4.
   - Replace the white fall cylinders with flat curved ribbons, 5-6 studs wide, Transparency 0.35-0.45, colour
     (200,235,243) (p1 ref, box 751-755, 138-142).
   - Add a scrolling texture or particle streaks, a mist puff at the foot, and vines at the lip.
   - Raise Atmosphere Haze from 0 to about 1-1.5 with Color about (185,208,170) (p1 ref, box 618-622, 28-32). Target:
     top-half saturation in p2 from 128 to about 100, and in c4 from 121 to about 90.
2. **Expeditions gate and Story portal (focal facades).** Seen in p2, p6, p4.
   - **Gate:**
     - Give the flat teal box a filigree arch top and pale stone and gold pilasters.
     - Replace the statue and flat door with a dark cloud-swirl door, (3,121,134) (p6 ref, box 128-132, 318-322), with a
       lighter swirl.
     - Add two lamp posts (about 8 studs) and two crystal fountains either side.
   - **Story portal:** a smooth silver horseshoe ring about 1.5 studs thick with 6-8 blue gems, in place of the block
     ring.
3. **Raid red.** Seen in p3, p5, c2, c3.
   - Recolour the skull from tan (172,117,100) to (213,112,95) (p3 ref, box 718-722, 38-42).
   - Recolour the haze cloud from orange-brown to red glow (206,118,105) (p3 ref, box 598-602, 218-222). Add a red
     PointLight (range about 30, brightness 2-3) on the facade.
   - Retint the tower brick toward (225,86,89) (c3 ref, box 1348-1352, 278-282).
   - Move the "Raid" sign from mid-tower onto the gable over the door, off the red drip.
4. **Stair tread shape and colour.** Seen in c4, c1, c2, c3.
   - Make the treads long slabs, about 3x the current block length (joints every 6-8 studs), with a crisp chamfer of
     about 0.15 stud in place of the pillow bevel.
   - Lighten from (167,174,166) to (186,191,185) (c4 ref, box 398-402, 688-692).
   - Then recapture c4: 8 rows show against 6 in the reference. If they still do, try 6 risers of 1.0 stud with deeper
     treads.
5. **Runner rims and one-piece runner.** Seen in p5, p6, c2, c4.
   - Change the white rims to gold, (156,141,39) (p5 ref, box 260-264, 498-502), about 0.5 stud wide.
   - Merge the slab and the flat apron into one slab with a rounded foot and a single cyan gem.
   - Enlarge the Y and move it lower on the slab (c4).
6. **Boss Rush and Summon facades.** Seen in p5, c2, c3, p1, c4.
   - **Boss Rush:** a purple gothic shrine (spires, lit pink and purple windows, about 25 studs tall) in place of the
     pink box with a spiral.
   - **Summon:** a gold cornice, columns and a gold medallion over the door.
7. **Foliage balance E/W.** Seen in p8, p7.
   - Trim W blue by about a third: p8 W box from 48.5% to about 33%.
   - On the E side, cover the grey bands with a dark red ground carpet and bushes so that p7 E red goes from 10.5% to
     about 18%.
   - Darken the E and S lawns from (140,189,106) / (118,178,87) to (125,168,51) / (94,128,59) (p8 ref, box 988-992,
     298-302; p7 ref, box 898-902, 618-622).
   - Replace the red heart blobs with irregular red canopy masses.
8. **Arch interior and notch tree.** Seen in c1, p1-p6.
   - Retint the tunnel marble from teal (95,160,147) to slate (44,54,62) (c1 ref, box 878-882, 468-472).
   - Give the notch tree a gnarled trunk with 2-3 limbs and a small blue crown about 4 studs across.
   - Narrow the arch about 10%.
9. **E/W cross arms and medallion.** Seen in p8, p7.
   - Extend the E and W arms to about 3x their length (about 20 studs more each), with pale borders, a blue runner and
     a cyan diamond tip.
   - Shrink the medallion diamond to about 75%.
10. **Close props.** Seen in p1-p6, c4.
    - **Bollards:** base about 25% smaller and cream, about (225,220,205), not pure white. The head is a faceted dark
      gold eye on a gold pyramid, (119,109,32) (p1 ref, box 438-442, 498-502).
    - **Pineapple:** a textured diamond-pattern fruit, (135,92,23) (c4 ref, box 188-192, 408-412), with a spiky crown.
    - **Story tree trunk:** about 2x thicker with roots and limbs, retinted from (83,66,65) to (113,92,66) (p4 ref, box
      698-702, 148-152).
