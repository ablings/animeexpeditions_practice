# Verify round 9: Anime Expeditions spawn plaza (freestyle, after fix pass 11)

Scored against the **live reference** on the Shadow PC, 2026-10-10, by an independent reviewer who had not seen the build
before (round 8 notes read for context only; scores below are fresh).

## Method
- Reference studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- Practice studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- `screen_capture` only. No code was run. Nothing was modified or saved in either studio.
- Captures: `v9_<cam>_ref_a` / `v9_<cam>_ref` and `v9_<cam>_rep_a` / `v9_<cam>_rep`. The pairs differ by at most 3.2% of pixels
  (reference, animated water/VFX/leaves) and 0.5% (practice), so the second frame was judged and no third capture was needed.
- Judged frames: `out/verify9/v9_<cam>_ref.jpg` and `v9_<cam>_rep.jpg`, 1452x793.
- "Sampled" RGB = 5x5 average from those JPEGs. All other colours and every stud size are estimates from the pictures.

## Overall read
Pass 11 is the biggest structural step so far. From above (p7/p8) the plaza now has the reference's four-quarter plan: red
gravel/litter zone and Raid pushed east, lagoon with sand and palms west, water channel north, white paving with crystal
pedestals at the flight tops. Raid now has the beam, red Neon letters, dark spires and dead trees, and Boss Rush is a purple
swirl. The Story tree is finally trunk-led. Summon is a 2-storey gold facade with gold/purple trees and umbrellas.

**What still separates it from the reference (in order of impact):**
1. **Lighting still reads flat midday.** Whatever pass 11 did to the post effects, it does not show in the frames. Practice sky
   samples (101,189,239), saturated and crisp; the reference sky near the islands is (206,230,235), hazy and bloomed. The
   reference Raid sits in red haze (sampled (159,113,100) in the air beside the skull); practice Raid is crisp. Check
   `Lighting.Technology` by hand (scripts cannot read it) and confirm the Bloom/Atmosphere/SunRays actually exist under
   Lighting and are Enabled.
2. **Raid values are inverted.** The practice facade is bright (216,78,88) and the skull is dark maroon (67,24,46). In the
   reference the facade is dark (77,21,37) and the skull is the lit, dusty-rose focal point (165,92,95).
3. **The red litter is flat polygon blobs.** From above, practice litter is huge solid red islands (195,52,51) with hard
   edges, and in the SE the gravel itself reads red. The reference is a fine speckle of red leaves over grey gravel (103,110,100),
   with white flower dots and green tufts.
4. **The floating islands are pale crumpled-paper undersides with flat green caps** and short ruins. The reference islands are
   grey-green rock with round trees, aqueducts, tall towers and vines, and sit higher.
5. **Foliage density.** The reference is packed to the horizon (stalls, flags, cypress cones, pineapple, crowds of trees);
   practice has single trees on open lawn, and beyond the plaza in p7 an empty green baseplate to the horizon.

## Per camera (round 8 -> round 9)

### p1_spawn_n: 7 -> 7
- **Gains:** Summon is now a 2-storey cream/gold facade with gold and purple trees and umbrellas in front, framed by blue palms.
- **Geometry:**
  - Summon facade is about 170 px wide but sits on bare paving; the reference facade has a gold tree mass rising to y≈120 and
    dense stalls/crowd in front.
  - Bollards are still tall white plinths (about 90 px tall incl. dome) with a smooth gold dome; reference bollards are squat
    stone blocks with a pointed gold cap.
  - Islands still hang from the top edge, undersides at y≈0-200 px; reference island undersides sit at y≈40-150 with towers
    and an aqueduct on top.
- **Colour:** Medallion gold now (188,171,54) against reference (172,160,63) - close. Medallion is still 5 broad swirls; the
  reference has 8 thin hooked blades.
- **Lighting:** flat; the reference has light shafts on Summon and glowing crystals in the pavilions.
- **Missing:** the big blue crystal pods on the arch tops (reference: 4 visible, each about 60x90 px), the Guild sign at left,
  blue cypress cones.

### p2_spawn_s: 7 -> 7
- **Gains:** The tall grass wall over the flight is gone; the gate now stands on a terrace with white arcades either side.
- **Geometry:**
  - Gate is about 180 px wide; the reference gate is about 220 px wide and taller, with crystal fountains and lanterns either side.
  - Shard ring: navy shards around a white oval. Reference ring is grey stone shards; it also sits lower (centre y≈170 vs 110).
- **Colour:** a red tree and a red spill sit at the left; the reference has blue trees and green patches only on this side.
- **Missing:** the tree on the rock pillar (centre-left), the green palm upper right, the domed palaces upper left.

### p3_spawn_e: 7 -> 8
- **Gains:** The read now matches: dark-spired red temple, skull head, red beam to the "Raid" letters, small skull keystone,
  black dead trees in front, purple Boss Rush swirl at left.
- **Geometry:** Raid stands well proportioned in the flight mouth. The reference skull is longer and more carved, and dark
  red palms and the stone rubble frame the door.
- **Colour:** inverted values. Facade (216,78,88) vs reference (77,21,37); skull (94,35,57) vs reference lit (164,89,88).
  Letters are red Neon (239,48,82) - the reference letters are paler red-pink (235,121,122) with glow.
- **Lighting:** the reference is drenched in red bloom/haze over the whole temple; practice has none.
- **Missing:** dark red palms (2), the red glow on the steps.

### p4_spawn_w: 6 -> 7
- **Gains:** The tan trunk with branches is now the main shape, with hanging blue vines.
- **Geometry:**
  - Foliage is a cluster of smooth blue discs/spheres (lollipop read). Reference foliage is wispy, dense blue leaf clumps that
    hang down over the branches.
  - The ring is a gold/silver frame with a graphic navy-and-white spiral; the reference portal is a carved silver-blue frame
    around a dark, almost black opening.
- **Missing:** the gold Guild facade upper right (practice shows white buildings), the green palm at left, the crystal pods.

### p5_diag_ne: 7 -> 7
- **Gains:** Raid with beam and letters, dark spires, dead trees and Boss Rush swirl framing the right; bigger Summon left.
- **Colour:** Raid facade too bright/pink (see p3). Spills are now small, close to the reference count.
- **Missing:** the dark red palm in front of Raid, the purple wisteria mass behind the arch, the stalls/flags in front of
  Summon, the bloom.

### p6_diag_sw: 7 -> 7
- **Gains:** The Story tree trunk now reads at upper right; portal ring has a gold frame.
- **Geometry:** a pale island fills the top centre; the reference has open sky with a big green palm, a ruin tower and the grey
  shard ring top-left.
- **Missing:** the green palm, the orange tree behind the Expeditions fountain, the lanterns.

### p7_high: 5 -> 6
- **Gains (large):** Layout now matches in plan. Raid moved east behind a grey gravel road with red litter and black dead
  trees; lagoon with sand beach and palms at west; N water channel with sand strips; white paving with blue-crystal pedestals
  in the foreground; Guilds and Summon on the N avenue.
- **Geometry:**
  - Beyond the plaza ring the frame is empty green baseplate up to the horizon; the reference is dense buildings and trees
    to the top edge.
  - The pedestals are plain white cubes; the reference pedestals are carved white plinths with a dark socket holding the crystal.
  - Red litter is a set of large flat blobs; the reference litter is speckled, with grass and flowers mixed in.
- **Colour:** lawn now (79,147,42) vs reference grass (111,163,48) - now slightly too dark and too uniform. Channel is bright
  cyan (127,236,254); the reference channel reads mid blue (84,137,224) with white stone edges. The lagoon (29,128,193) is
  more saturated than the reference water.

### p8_top: 5 -> 6
- **Gains:** E gravel road + red zone + Raid, W lagoon, N channel, white S terrace with the gate.
- **Geometry:**
  - The Story tree is so tall it crosses the west half of the frame as a long tan bar; the reference west is a ring of blue
    foliage around a stepped round Story arena.
  - Three square tall-grass blocks remain (W of the W flight, SW and SE of the S flight, each about 25x25 studs); the reference
    has none.
  - The reference arms carry a white carved terrace at each end; practice E and W arm ends are bare.
- **Colour:** the SE gravel is covered by solid red; litter (195,52,51) vs reference (180,55,52) is right in hue but wrong in
  coverage and texture.

### c1_wall: 7 -> 7
- **Gains:** Leaf spills are now leaf-card clusters, small; the background shows the gold Summon, purple wisteria, umbrellas
  and the dark spires of Raid.
- **Geometry:** the wing flank is a plain slab, no carved bands. Drum still has no gold upper bowl lip.
- **Colour:** wing flank (108,132,159), reference (44,59,72): still too light. Stairs: practice risers (59,71,89) under light
  treads; the reference treads and risers are both light grey (147-159) with soft dark joints.
- **Missing:** the big blue crystal pods on the wall top, the red palm over Raid, bloom.

### c2_fountain: 6 -> 7
- **Gains:** Raid with beam, Boss Rush swirl, dead trees and a red palm behind; spills much smaller.
- **Geometry:** the arch side wing is still a long pale flat wall; the reference wing is dark with recessed carved bands and a
  gold rim, and stays low.
- **Colour:** green leaf cards on the floor are bright triangles (about 300 px wide patch); reference is one soft green splash.
- **Missing:** the orange tree, the grey palace domes and arcades on the right (practice: plain cloud and sky).

### c3_pavilion: 7 -> 7
- **Gains:** The skull is carved with glowing red eyes and the beam runs to the letters; Summon gold facade at left.
- **Geometry:** islands are pale, faceted undersides (148,151,133) with flat green caps and towers about 50-60 px tall; the
  reference islands carry round trees, an aqueduct, a domed rotunda and towers 150-200 px tall, with grey-green rock.
- **Colour:** skull too dark (67,24,46) vs reference (165,92,95); facade too bright.
- **Missing:** gold tree mass left, dark red palm in front of Raid, red haze around the skull.

### c4_stairs: 7 -> 7
- **Gains:** Summon is a proper 2-storey facade with gold and purple trees, umbrellas and twin blue palms; risers lighter.
- **Geometry:** islands low and close, undersides at y≈0-220 px; reference islands sit high and far (y≈100-260) with towers.
  The pavilion domes crop hard at both edges, like the reference - good.
- **Missing:** blue cypress cones (reference: 2 large ones flanking the avenue), the gold pineapple at left, flags/bunting,
  stall clutter, the glowing crystal pod tops.

## Scores
| camera | r8 | r9 |
|---|---|---|
| p1_spawn_n | 7 | 7 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 7 | 8 |
| p4_spawn_w | 6 | 7 |
| p5_diag_ne | 7 | 7 |
| p6_diag_sw | 7 | 7 |
| p7_high | 5 | 6 |
| p8_top | 5 | 6 |
| c1_wall | 7 | 7 |
| c2_fountain | 6 | 7 |
| c3_pavilion | 7 | 7 |
| c4_stairs | 7 | 7 |
| **average** | **6.50** | **6.92** |

## Top-10 fixes (ranked by visual impact)
1. **Make the mood lighting actually show.** (All 12 cameras.) The frames are still crisp midday.
   - By hand in Place1: set `Lighting.Technology` to Future (or match the reference) and confirm Bloom, ColorCorrection,
     Atmosphere and SunRays exist under Lighting and are Enabled.
   - Targets: Atmosphere Density 0.3, Haze 1.5-2, Color (200,220,240), Glare 0.3; Bloom Intensity 0.6, Size 30, Threshold 1.2;
     SunRays Intensity 0.1; ColorCorrection Brightness 0.05, Saturation 0.1.
   - Goal: the sky near the islands should sample about (200,225,235), not (101,189,239).
2. **Flip the Raid values and add red haze.** (p3, p5, c1, c2, c3.)
   - Facade lit faces to (90,25,40), recesses (25,5,12); keep spires (60,20,30).
   - Skull to dusty rose (165,90,95) with darker sockets (60,20,25) and Neon eyes; it must be the lightest thing on the temple.
   - Letters to (235,120,125) Neon with a SurfaceLight.
   - Red haze: a ParticleEmitter (smoke, Color (255,60,60), Transparency 0.7, Size 20-30, Rate 5) at the skull and doorway,
     plus 3 PointLights (255,50,50), range 45, brightness 3.
   - Add 2 dark red palms (120,30,40), about 25 studs tall, either side of the door.
3. **Break up the red litter.** (p7, p8, p3, c2.)
   - Replace the big flat red blobs with scattered leaf decals/cards 2-4 studs each, about 40% coverage over grey gravel
     (103,108,105), red (180,50,52) to (200,70,70), with white flower dots and green tufts (110,170,50) mixed in.
   - Remove the solid red from the SE gravel; keep the road grey.
4. **Rework the floating islands.** (p1, p4, p6, c3, c4.)
   - Underside rock to grey-green (150,160,150) with darker crevices (90,100,95); drop the crumpled pale facets.
   - Lift the N, W and E islands 15-20 studs so undersides sit at y≈60-150 px in p1/c4.
   - Per island: 4-6 round trees (90,160,60) 15-20 studs, one grey tower 10x10x50 (165,170,165), hanging vines; one aqueduct
     span and one domed rotunda across the N pair.
5. **Fill the horizon and the avenue.** (p7, p1, c4, p5.)
   - Beyond the plaza ring (r > 150 studs), add 8-12 building/tree masses 30-60 studs tall so p7 has no empty baseplate to the
     horizon; tint distant ones lighter for haze.
   - On the N avenue: 6 blue cypress cones (40,90,220) 4x14 studs, 4-6 stalls with striped awnings, flags/bunting between the
     lamp posts, a gold pineapple about 8 studs tall by the W pavilion.
6. **Story tree canopy and portal.** (p4, p6, p8.)
   - Replace the smooth blue disc clumps with 6-8 leafy clumps (30,90,220) of overlapping leaf cards, drooping 10-15 studs
     below the branches; keep the vines.
   - Cap the tree height so it does not cross the p8 frame (about 70 studs total).
   - Portal: carved silver-blue frame (150,170,205) around a dark opening (15,20,40) with a faint Neon blue swirl
     (40,110,255, Transparency 0.5) instead of the white graphic spiral.
   - Ring the tree with a stepped round arena/stair (about 40 studs across) in white stone.
7. **Remove the remaining grass blocks and dress the arm ends.** (p8, p7.)
   - Delete the three square tall-grass blocks (W of the W flight, SW and SE of the S flight).
   - At the E and W arm ends add a white carved terrace (about 30x20 studs, (230,230,225)) like the S one.
   - Pedestals: carved white plinths with a dark socket (40,50,60) holding the crystal, about 4x4x5 studs.
   - Lawn: mix (95,160,45) and (120,175,55) patches; tone the N channel to (85,140,225) and the lagoon to (60,150,210).
8. **Arch wings and stairs.** (c1, c2, p1, p5.)
   - Wing flank faces to dark slate (50,62,72) with 2 recessed bands and a gold rim on top; top faces stay (130,135,135).
   - Stair risers up to (140,150,155) so the flights read as uniform light grey bevelled blocks.
   - Add a gold upper bowl lip on the drum.
9. **Crystal pods.** (p1, c1, c3, c4, p3.)
   - Big faceted Glass/Neon crystal pods (40,110,230), about 4x6 studs, 2 per arch on the wall tops beside the pavilions,
     each with a PointLight (80,170,255), range 12; also make the pavilion interiors glow the same.
10. **Medallion, bollards, S gate.** (p1-p6.)
    - Medallion: 8 thin hooked dark blades (45,55,65) on pale stone, gold hub, ring of 8 gold studs.
    - Bollards: cut height about 35%, square stone body, pointed stepped gold cap.
    - S gate: scale 1.2x, add a crystal fountain and lantern either side; shard ring to grey stone (150,155,160), lowered
      about 10 studs; add the green palm upper right and a tree on a rock pillar centre-left.
