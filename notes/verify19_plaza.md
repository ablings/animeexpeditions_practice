# Verify round 19: Anime Expeditions spawn plaza (freestyle, after fix pass 21)

An independent reviewer scored the build against the **live reference** on the Shadow PC on 2026-10-10.
Round 18 (`verify18_plaza.md`, 7.83) was read only for comparison. Every score below is fresh.

## Method
- **Reference:** studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, cameras from `cams.json`.
- **Practice:** studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only, through `capture_set2.py` / `mcpcli.py`. No code was run in either studio, and nothing
  was modified or saved in either studio.
- **Captures:** each camera was captured twice in each studio, and the second frame was judged. The judged frames are
  `out/verify19/v19_<cam>_ref.jpg` and `v19_<cam>_rep.jpg`, 1452x793.
  - Pixels changing by more than 30 levels between the two frames: 1.0-5.2% in the reference (water, VFX, crowd) and
    0.0-1.2% in the practice (fountain mist). That is animation, not streaming.
- **Colours:** every RGB below is a 5x5 mean from those JPEGs, given with its frame and pixel box (x0-x1, y0-y1).
  - Targets are sampled from the reference frame.
  - Each box was checked with zoomed 120 px tiles, in both frames, to confirm it lands on the named feature. Where a
    practice box could not land on the feature because the feature is missing, this is said.
  - Stud sizes are estimates from the pictures.
- **Coverage metrics** (PIL HSV, so not directly comparable with the round-18 numbers, which used another method):
  - Top-half mean saturation (0-255), ref / rep: p1 84/109, p2 99/132, p3 102/116, p4 107/129, p5 92/117, p6 113/127,
    p7 91/109, p8 99/120, c1 97/120, c2 106/123, c3 91/105, c4 86/125.
  - W blue cover (hue 0.55-0.72, sat > 0.45): p8 x 0-420, y 150-650: 32.0% ref / 48.7% rep. p7 x 0-450, y 100-700:
    14.2% / 22.1%.
  - E green cover (hue 0.17-0.40) in x 1000-1452, y 100-700: p7 23.9% / 9.5%; p8 3.4% / 3.5%.
  - E red cover, same box: p7 18.4% / 17.3%; p8 23.0% / 37.4%.
  - Green cover on the c2 stairs (x > 800, y > 400): 5.8% ref / 11.7% rep.

## Overall read
Pass 21 landed most of what it set out to do:

| Fix | Evidence |
|---|---|
| **Outer slate band dark** | (29,41,48) (c1 rep, box 408-412, 350-354) against (36,46,54) (c1 ref, box 469-473, 349-353). Round 18 was (89,102,108). |
| **Gold ledge across the tunnel** | (82,69,10) (c1 rep, box 558-562, 441-445) against (78,75,16) (c1 ref, box 558-562, 440-444), at the same height. |
| **Basins teal** | (69,156,176) (p7 rep, box 365-369, 541-545) against (67,154,178) (p7 ref, box 918-922, 468-472). |
| **Stair risers** | (75,104,124) (c4 rep, box 398-402, 688-692) against (85,107,121) (c4 ref, box 428-432, 653-657). Treads are now bevelled blocks with offset joints. |
| **c1 splats** | Left (41,159,255) (c1 rep, box 298-302, 738-742) against (82,162,244) (c1 ref, box 338-342, 668-672). Right (253,107,108) (c1 rep, box 1105-1109, 648-652) against (226,97,95) (c1 ref, box 1118-1122, 628-632). |
| **West blue thinned** | p8 W blue 48.7% against 32.0%; p7 22.1% against 14.2%. Still too much, but much closer. Blue palms and sand now show in p7/p8. |
| **Skyline** | The white box towers are gone; ruined arcades, a bell tower and domed palaces stand on the islands. |
| **Raid skull** | Now a round skull with red eyes, and the "Raid" sign sits on the gable. |

What now separates the build from the reference, by visual impact:
1. **Background mood.** The practice sky is clean and hard: top-half saturation 105-132 against 84-113. The island
   canopies read as round broadleaf "lollipop" trees in green. There are no falls, no aqueduct and no haze; the
   reference background is soft, misty and busy.
2. **Foliage density.** The reference reads as a jungle of blue, purple, gold and red; the practice reads as a park
   with tree clumps on lawn. E green cover in p7 is 9.5% against 23.9%.
3. **Stair grass is now topiary.** The spikes became round shrub balls, placed in rows on every tread. They are darker,
   (66,93,35) (c2 rep, box 945-949, 487-491), against a flat fern spray (114,166,54) (c2 ref, box 928-932, 588-592),
   and there is twice as much of it (11.7% against 5.8%). The stair-top lawn strips do not show in p2.
4. **Arch notch is a stone plug.** The notch is now closed, but by a rough flat stone slab (70,81,88) (c1 rep, box
   731-735, 228-232) that fills x≈653-813, y≈143-289 flush with the ear tops. The reference notch is a recessed U
   with a pale and gold rim, dark pods (50,54,70) (c1 ref, box 686-690, 260-264) and a tree growing out of it.
   The arch is also about 1.17x wider than the reference (outer c1 ref x≈400-1107, rep x≈320-1147).
5. **Runners** are still flat inlays, too dark, with white rims instead of gold.

## Per camera (round 18 -> round 19)

### p1_spawn_n: 8 -> 8
- **Gains:**
  - Skyline: ruined arcades and towers in place of white boxes.
  - The notch is closed; no sky shows through.
  - Dark outer band.
- **Geometry:**
  - **Notch:** a flat stone plug flush with the ear tops (see the overall read). It reads as a planter box.
  - **Bollards:** the white base is about 1.3x too large and too clean, and the head is a smooth dome.
    - Head (232,219,142) (rep, box 445-449, 494-498) against a faceted dark gold eye (119,109,32) (ref, box 438-442,
      498-502).
    - Base (228,225,223) (rep, box 445-449, 558-562) against a shaded cream base (128,129,138) (ref, box 438-442,
      573-577, shadow side).
- **Colour:** the background is too saturated; the reference sky band is misty green-grey behind the falls.
- **Missing:** the two falls, the aqueduct, the crowd and parasols at the stair top. The gold trees are present but
  clipped into balls.

### p2_spawn_s: 7.5 -> 7.5
- **Gains:** dark outer band and closed notch.
- **Geometry:**
  - **Gate:** unchanged, a flat teal box with a white statue. The reference is an ornate turquoise frame with filigree
    and a cloud-swirl door.
  - **Stair grass:** rows of round shrub balls on every tread; the reference has scattered low leaf sprays.
- **Colour:** stair-top lawn still missing.
  - Reference lawn (115,177,79) (ref, box 558-562, 376-380), a strip of soft tall grass under the gate.
  - The practice frame has stair stone there, (50,61,77) (rep, box 558-562, 404-408); there is no lawn strip to sample.
- **Missing:** the tree on the rock pillar upper left and the pale cloud mass around the ring.

### p3_spawn_e: 8.5 -> 8.5
- **Gains:** the skull is now round with red eyes and a red drip, and the sign has moved down onto the gable.
- **Geometry:** the skull sits on a brick tower. The reference skull sits on a red rock mass flanked by two spires and
  dense dead trees.
- **Colour:**
  - The skull is too dark and unlit: (100,60,59) (rep, box 698-702, 83-87, cheek) against a lit salmon-red
    (216,128,102) (ref, box 718-722, 78-82, cheek).
  - The Raid haze is still an orange-brown cloud behind the tower, not a red glow wrapping it.
- **Missing:** the dense dark-red canopy and red palms around the facade.

### p4_spawn_w: 8 -> 8
- **Gains:** the Story tree now shows a trunk and blue drips under the crown.
- **Geometry:** the trunk is still short and the crown a single blob. The reference trunk is huge and gnarled, filling
  the top third of the frame with roots and limbs.
- **Colour:** the stairs are dotted with shrub balls. The reference has grass and leaf sprays.
- **Missing:** the blue palm fringe either side of the portal, and the palace at right.

### p5_diag_ne: 8 -> 8
- **Geometry:**
  - **Runners:** still flat inlays. The reference runners are raised, bevelled slabs, ref y≈380-620 against rep y≈390-530,
    with a cyan gem near the foot.
  - **Summon building:** a plain cream box with bunting. The reference is an ornate gold-and-stone palace.
- **Colour:**
  - Runner blue too dark: (41,74,177) (rep, box 128-132, 458-462) against (84,141,230) (ref, box 148-152, 408-412).
  - Rims are white with a thin gold line, (214,215,215) (rep, box 288-292, 518-522). The reference rim is thick gold,
    (156,141,39) (ref, box 260-264, 498-502).
  - Note: round 18's (208,190,89) at box 148-152, 498-502 sits on the gold Y stem of the runner, not on the rim.
- **Missing:** the Boss Rush shrine reads as a purple spiral on a pink box.

### p6_diag_sw: 7.5 -> 7.5
- **Gains:** the closed notch, the dark band and the green palm behind the arch.
- **Geometry:**
  - **Expeditions gate:** a plain teal box, as in p2.
  - **Story frame:** a ring of stone blocks with a gold rim. The reference is a smooth silver horseshoe with blue gems.
  - **Stair grass:** rows of shrub balls on both stairs.
- **Missing:** the soft lawn, the orange tree and the lamp posts at the Expeditions gate, and the palm grove right of
  the arch.

### p7_high: 7 -> 7.5
- **Gains:**
  - Basins teal, matching (see table).
  - W blue down to 22.1% against 14.2%, with blue palms and sand visible.
- **Geometry:**
  - The S foreground is still dominated by white plinth paths and a white pad; the reference has a green palm cluster,
    sand and beach props.
  - The N avenue reads as cyan and blue stripes; the reference is a pale stone avenue lined with blue palms.
- **Colour:** E green cover 9.5% against 23.9%. The practice E ground is grey with red blobs; the reference E is red
  canopy with lawn between.
- **Missing:** dense foliage on all sides.

### p8_top: 8 -> 8
- **Gains:** W blue 48.7% against 32.0%; basins teal.
- **Geometry:**
  - **E/W arms:** still short, about a third of the reference length. The W arm runs into separate white blocks.
  - **Medallion diamond:** still about 1.3x too large.
- **Colour:**
  - E ground: grey with red heart-shaped blobs and a few small lime blobs, (88,109,90) (rep, box 955-959, 334-338, on
    the edge of a lime blob). The reference has irregular lawn holes with white flowers, (128,170,54) (ref, box
    988-992, 298-302).
  - E red cover 37.4% against 23.0%: the red blobs are too many and too bright.

### c1_wall: 8 -> 8.5
- **Gains:** the dark outer band, the gold ledge, the closed notch and both splats (see table).
- **Geometry:**
  - **Notch:** a flat stone plug, x≈653-813, y≈143-289, flush with the ear tops. The reference is a recessed U, x≈650-800,
    with its floor at y≈290, a pale and gold rim, dark pods and a tree.
  - **Arch:** about 1.17x wider (outer x≈320-1147 against 400-1107; opening at y≈400 x≈460-1093 against 500-1040).
- **Colour:**
  - Pale band slightly light and blue: (130,141,143) (rep, box 554-558, 338-342) against (119,124,127) (ref, box 554-558,
    349-353).
  - Tunnel back wall is purple-tinted: (32,21,44) (rep, box 878-882, 478-482) against slate (44,54,62) (ref, box
    878-882, 468-472).

### c2_fountain: 7.5 -> 7.5
- **Gains:** the stairs now read as bevelled stone blocks, as in the reference.
- **Geometry:** grass is now round shrub balls in rows on the treads (11.7% green against 5.8%). The reference is one
  low fern spray on the lip.
- **Colour:** shrubs too dark, (66,93,35) (rep, box 945-949, 487-491), against (114,166,54) (ref, box 928-932, 588-592).
- **Missing:**
  - The Boss Rush building is a pink box with a purple spiral; the reference is a lit purple gothic shrine.
  - The orange tree and grey palace domes at right; the white blocks there read as unfinished.

### c3_pavilion: 8 -> 8
- **Gains:** ruins and a bell tower on the islands; the round skull; bevelled stair blocks.
- **Geometry:** the island canopies read as round broadleaf trees. The reference shows ruined arcades, two falls, hanging
  vines and dense foliage.
- **Colour:**
  - The Raid tower is brick, (148,79,77) (rep, box 1348-1352, 278-282), against a red glow wrapping it, (183,61,67)
    (ref, same box).
  - The sky is clean saturated blue with flat clouds; the reference sky is softer.
- **Missing:** the tall blue palm left of the pavilion and the Summon facade detail.

### c4_stairs: 8 -> 8
- **Gains:**
  - Risers match: (75,104,124) (rep, box 398-402, 688-692) against (85,107,121) (ref, box 428-432, 653-657).
  - Treads are cut into bevelled blocks with offset joints.
- **Geometry:** the steps are about 1.3x too tall in frame; 4 steps show between the plaza and the stair top against
  6 in the reference.
- **Colour:**
  - Tread slightly dark and warm: (173,176,166) (rep, box 428-432, 653-657) against (186,191,185) (ref, box 398-402,
    688-692).
  - Runner still too dark and saturated: (28,55,168) (rep, box 658-662, 698-702) against (75,126,225) (ref, same box).
  - Pineapple still a smooth gold pot, (204,167,5) (rep, box 208-212, 398-402), against a textured fruit, (133,91,24)
    (ref, box 188-192, 408-412).
- **Missing:** the aqueduct, the falls, the lamp posts and the crowd.

## Scores
| camera | r18 | r19 |
|---|---|---|
| p1_spawn_n | 8 | 8 |
| p2_spawn_s | 7.5 | 7.5 |
| p3_spawn_e | 8.5 | 8.5 |
| p4_spawn_w | 8 | 8 |
| p5_diag_ne | 8 | 8 |
| p6_diag_sw | 7.5 | 7.5 |
| p7_high | 7 | 7.5 |
| p8_top | 8 | 8 |
| c1_wall | 8 | 8.5 |
| c2_fountain | 7.5 | 7.5 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 8 | 8 |
| **average** | **7.83** | **7.92** |

## Top-10 for the next pass (ranked by visual impact)
1. **Background haze, falls and canopies.** Seen in p1-p6, c1-c4.
   - Add Atmosphere haze (Density about 0.3, Haze 1.5-2, Color (200,220,235)) so the top-half saturation drops from
     105-132 to about 85-110.
   - Add two wide translucent falls (5-6 studs wide, Transparency 0.4) dropping from the N islands, and a 4-arch
     aqueduct between them (about 40 studs long).
   - Recolour the round green island canopies to the reference mix (blue, purple, gold) and break them into 3-4 lumps
     each, so they stop reading as lollipops. Add hanging vines under the island rims.
2. **Foliage density around the plaza.** Seen in p1-p8, c2, c3.
   - E side: add red canopy trees and bushes on the grey ground so E green+red reads like the reference. Lawn holes with
     white flowers between them, (128,170,54) (p8 ref, box 988-992, 298-302).
   - Fill the N avenue with blue palms (25-30 studs) either side, and the S foreground with a green palm cluster,
     sand and beach props in place of the white plinth paths.
   - Keep W blue where it is now, or trim about 10% more (p8 target about 35%).
3. **Stair grass.** Seen in c2, p2, p4, p6.
   - Delete about 60% of the shrub balls, and replace the rest with low flat fern sprays (1 stud tall, 3-4 studs across)
     on the tread lips, in (114,166,54) (c2 ref, box 928-932, 588-592).
   - Add the lawn strip at the S and W stair tops: 2-3 studs deep, soft blades about 1.5 studs tall, (115,177,79)
     (p2 ref, box 558-562, 376-380). It must show in p2 under the gate.
4. **Arch notch and width.** Seen in c1, p1-p6.
   - Remove the flat stone plug. Make the notch a recessed U about 1.5 studs deep, its floor about 2 studs below the ear
     tops (c1: floor at y≈290), with the pale band and a gold rim running round it.
   - Inside, put 2-3 dark rounded pods, (50,54,70) (c1 ref, box 686-690, 260-264), and a small tree growing out.
   - Narrow the whole arch about 15% (c1 outer width from about 827 px to about 707 px).
   - Retint the tunnel back wall from (32,21,44) to (44,54,62) (c1 ref, box 878-882, 468-472).
5. **Runners.** Seen in p5, p6, c4, p1-p4.
   - Raise the plaza-side runners into bevelled slabs about 1-1.5 studs high, angled up toward the stairs.
   - Runner blue from (28,55,168) / (41,74,177) to (84,141,230) (p5 ref, box 148-152, 408-412).
   - Rims from white to thick gold, about 0.5 stud, (156,141,39) (p5 ref, box 260-264, 498-502), and a cyan gem near
     the foot.
6. **E/W cross arms and medallion.** Seen in p8, p7.
   - Extend the E and W arms to about 3x their length (about 20 more studs each), with pale stone borders, a blue runner
     and a cyan diamond tip, as on the N/S arms. Merge or remove the separate white W blocks.
   - Shrink the medallion diamond to about 75%.
7. **Raid skull glow.** Seen in p3, c2, c3, p5.
   - Light the skull: from (100,60,59) to (216,128,102) (p3 ref, box 718-722, 78-82), with a red PointLight or a
     red-tinted neon face.
   - Remove the orange-brown haze cloud and wrap the tower in a red glow, (183,61,67) (c3 ref, box 1348-1352, 278-282).
   - Seat the tower on a red rock mass with two spires about 8 studs tall either side.
8. **Stair proportion.** Seen in c4, c2, c3.
   - Go from 6 steps back to about 8 at about 0.75x the height, so 6 show in c4 between the plaza and the top.
   - Lighten the treads from (173,176,166) to (186,191,185) (c4 ref, box 398-402, 688-692).
9. **Facades.** Seen in p2, p6, p5, c2, c3, p4.
   - Expeditions gate: filigree arch tops, two lamp posts, two crystal fountains, and a cloud-swirl door (turquoise
     (60,180,180) with a lighter swirl).
   - Summon: gold cornice, columns and a gold medallion over the door.
   - Boss Rush: a purple gothic shrine with lit windows in place of the pink box.
   - Story tree: thicken the trunk about 2x and add 3-4 roots and limbs rising into the crown.
10. **Close props.** Seen in p1-p6, c4.
    - Bollards: base about 25% smaller and shaded cream, not pure white; head a faceted dark gold eye on a gold pyramid,
      (119,109,32) (p1 ref, box 438-442, 498-502).
    - Pineapple: textured diamond-pattern fruit, (133,91,24) (c4 ref, box 188-192, 408-412), about 6 studs, with a
      spiky crown.
    - E ground: fewer red blobs (37.4% red against 23.0% in p8 x 1000-1452, y 100-700).
