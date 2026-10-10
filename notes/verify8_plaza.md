# Verify round 8: Anime Expeditions spawn plaza (freestyle, after fix pass 10)

Scored against the **live reference** on the Shadow PC, 2026-10-10, by an independent reviewer who had not seen the build
before.

## Method
- Reference studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- Practice studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- I used `screen_capture` only and ran no code. Nothing was modified or saved in either studio.
- Captures are `v8_<cam>_ref_a` / `v8_<cam>_ref` and `v8_<cam>_rep_a` / `v8_<cam>_rep`. Every pair matched. The largest
  difference was 2.1% of pixels, and it came only from animated water and VFX. So the second frame was judged, and no third
  capture was needed.
- The judged frames are in `out/verify8/v8_<cam>_ref.jpg` and `v8_<cam>_rep.jpg`, 1452x793.
- "Sampled" RGB values are 5x5 averages from those JPEGs. All other colours and every size in studs are estimates from the
  pictures.

## Overall read
Pass 10 fixed most of the round-7 value problems, and the plaza now reads as the same place from the spawn.

**What now matches the reference:**
- **Fountain arches are two-tone.** The practice crest samples (128,136,136); the reference is (127,131,132).
- **Islands are grey-green with sky between them.** Lit rock samples (144,147,129); the reference is (153,159,145).
  - The spikes are smaller.
  - The falls fade out instead of ending on cloud discs.
- **The drum is small and sits under the arch mouth.**
- **The Expeditions gate is a triptych with a swirl portal**, and the shard ring is in open sky.
- **The Raid skull is fused into a gable**, with the letters over the door.
- **The N flight opens straight onto the avenue**, with gold trees, umbrellas and palms.

**What still separates it from the reference:**
1. **No mood lighting.** The reference has bloom, haze, light shafts and a red glow around Raid. Practice is flat
   midday.
2. **The layout seen from above (p7/p8) has not changed.** Raid fills the near-east, the west is lawn plus one tree blob,
   and there is a tall-grass block over the S flight.
3. **The landmarks are still simple.**
   - Summon is a small one-storey pavilion.
   - The Story tree is a faceted blob over a navy ring with a dark hole.
   - Raid is flat pink, with white letters, no beam and no dead trees.
   - Boss Rush is a flat magenta disc.
4. **The leaf spills are still large, sharp-shard carpets** (c2, p5).

## Per camera (round 7 -> round 8)

### p1_spawn_n: 6 -> 7
- **Gains:**
  - Two-tone arches.
  - Grey-green islands with sky gaps.
  - The fountain core is small.
  - The flight opens onto the avenue, with gold trees and purple wisteria behind it.
- **Geometry:**
  - Summon is still a small cream pavilion with a gold dome, about 130 px wide. The reference is an ornate gold facade
    about 150 px wide, with a gold tree mass rising to y≈120 behind it.
  - The bollards are still tall white plinths, about 140 px. The reference bollards are squat, about 90 px, with a stepped
    gold cap.
  - The islands still start at the top edge of the frame. In the reference, island undersides sit at about y≈40-150 px,
    with towers and an aqueduct on top.
- **Colour:**
  - The medallion gold is still bright: (222,193,58) against (179,166,62).
  - The medallion is still 5 broad swirls. The reference has 8 thin hooked blades.
- **Lighting:** Flat. The reference has light shafts on Summon and glow in the crystals.
- **Missing:**
  - Big blue crystal pods on the arch tops (the reference has 4 visible, each about 60x90 px).
  - Stall clutter on the avenue.
  - The Guild sign at left.

### p2_spawn_s: 6 -> 7
- **Gains:**
  - The gate is now a teal triptych with a swirl portal and gold filigree.
  - The shard ring floats in open sky.
- **Geometry:**
  - A tall bright grass wall still runs across the top of the flight, about 330 px wide. The reference has short mixed
    grass and white arcades, and the gate stands on a visible terrace with crystal fountains and lanterns either side.
  - The ring is navy shards around a white oval. The reference ring is grey stone shards.
  - The gate is about 190 px wide; the reference is about 220 px, and taller.
- **Colour:** The heavy red spill on the left floor reads as Raid litter on the wrong side; the reference has a green
  patch only.
- **Missing:**
  - The tree on the rock pillar, centre-left.
  - The green palm, upper right.
  - The domed palaces, upper left.

### p3_spawn_e: 7 -> 7
- **Gains:** The skull is now the head of a central gable, with "Raid" and a small skull keystone over the door.
- **Geometry:**
  - The skull is a rounded pink head about 140 px wide. The reference skull is about 150 px wide, more angular and carved.
  - The reference beam runs about 130 px from the skull's mouth down to the letters. Practice has none.
  - The reference has dark spires, a dark red palm and black dead trees across the front. Practice has two small dark
    trees.
- **Colour:**
  - The facade is flat pink, sampled (219,64,74). The reference is deep red (195,37,41) in light and near-black red (103,4,4)
    in the arch.
  - The practice letters are white. The reference letters are red-pink 3D with glow.
  - Boss Rush is a flat magenta disc. The reference is a purple swirling portal with a carved frame.
- **Lighting:** The reference is drenched in red bloom and haze. Practice has only light red fog at the base.

### p4_spawn_w: 6 -> 6
- **Gains:** The "Story" letters are now pale and readable against the canopy.
- **Geometry:**
  - The tree is still a dense faceted ball, about 260 px wide, on a short trunk.
  - In the reference the huge tan trunk and branches are the main shape, rising from y≈240 to the top of the frame. Its
    foliage is wispy blue, with hanging vines.
  - The ring is a thick navy and gold disc with a dark hole. The reference ring is a silver-blue carved frame around a
    swirling blue portal.
  - Two bright grass walls flank the flight top. The reference has short grass and green spills.
- **Missing:**
  - The gold Guild facade upper right. Practice shows white buildings.
  - The crystal pods.
  - The green palm, left.

### p5_diag_ne: 6 -> 7
- **Gains:**
  - The arch is two-tone.
  - The Raid gable with skull and letters frames the right side.
  - Boss Rush is visible.
  - The islands are grey with sky gaps.
- **Geometry:** Summon is a small domed pavilion. The reference is a long ornate gold facade with flags, stalls and
  umbrellas in front.
- **Colour:** Raid is flat pink. The red and blue spills cover most of the floor in front of the fountain. The reference has
  one blue patch and one red patch, each about 100 px.
- **Missing:**
  - The purple wisteria mass behind the arch.
  - The dark red palm and the black dead tree in front of Raid.
  - The blue cypress cones.

### p6_diag_sw: 6 -> 7
- **Gains:**
  - The triptych gate with swirl portal and "Expeditions" sign.
  - The "Story" sign is readable.
  - Two-tone arch.
- **Geometry:**
  - The Story ring is a dark navy oval. The reference ring is a silver-blue carved frame with a glowing blue portal.
  - The tall-grass wall along the top is still too bright and too tall.
- **Missing:**
  - The big green palm top centre.
  - The ruin tower on the island.
  - The orange tree.
  - The shard ring, top left. Practice shows only island edges there.

### p7_high: 5 -> 5
- **Gains:** The islands are out of frame, and the S triptych gate is visible top centre.
- **Geometry:** No change in layout.
  - The Raid block and skull still fill the right side, at x≈1100-1450 and y≈0-450. In the reference that area is grey
    gravel with red litter, and the Boss Rush is far off at top right.
  - West is lawn plus the Story tree. The reference has a lagoon with beach, palms and pool toys.
  - A large grass block covers the flight in the foreground. The reference has a blue runner flanked by grass and sand, with
    white pedestals carrying blue crystals.
- **Colour:** The lawn is uniform (159,189,86) and lighter than the reference grass (115,170,47). There is too little sand
  and no water.

### p8_top: 5 -> 5
- **Practice:**
  - The Story tree blob still covers the west.
  - Raid sits directly on the E axis, 95-195 studs out.
  - The N avenue is paved.
  - The arms are short, and grass blocks sit at each arm end.
- **Reference:**
  - The arms are long (about 80 studs).
  - The E arm runs into a grey gravel road with red litter, to a carved plaza.
  - West: blue foliage and a stepped Story arena.
  - North: a water channel with sand beaches.
  - South: a white arcaded courtyard.

### c1_wall: 6 -> 7
- **Gains:**
  - The drum is now about 160 px wide and 80 px tall, close to the reference (205 x 70 px).
  - The basin sits in the arch mouth.
  - The crest is mid grey (128,136,136), matching the reference.
- **Geometry:**
  - The arch wing flanks are pale (154,151,119 in light). The reference flank is dark slate (63,69,72), with carved bands
    and only the top face light.
  - There is no gold upper bowl lip on the drum.
- **Colour:**
  - The spills on the floor and treads are angular shards in saturated blue and red.
  - The reference has 2 soft leafy clumps, each about 200 px.
- **Background:**
  - Practice Summon is a small cream building. The reference is an ornate gold facade with flags.
  - Raid is flat pink. The reference has bloom and red-lit letters.

### c2_fountain: 6 -> 6
- **Gains:** The skull, letters and Boss Rush disc now show behind, and the basin sits in the arch mouth.
- **Geometry:**
  - The arch side wing is a long pale flat slab. The reference wing is dark with recessed carved bands and a gold rim.
  - A green shard spill covers about 40% of the stair foreground. The reference has 2 small splashes.
- **Colour:**
  - The treads read (91-164) with near-black risers (37,53,76).
  - The reference treads are uniform light grey with soft dark joints and no black risers.
  - The red spill covers the left floor.
- **Missing:**
  - The dark red palm, the black dead tree mass and the orange tree.
  - The grey palace domes on the right.
  - The bloom.

### c3_pavilion: 6 -> 7
- **Gains:** Grey-green islands with grass caps, small ruins, fading falls and sky gaps; the skull is in a gable.
- **Geometry:**
  - The ruin towers are short, about 60 px. The reference towers are 150-200 px tall, with an aqueduct and a domed rotunda.
  - The reference islands carry round green trees and vines. Practice has bare caps with green fringe.
  - The skull is about 200 px wide, a round pink head. The reference is about 160 px, carved, with glowing eyes and a beam.
- **Colour:** Flat pink Raid; white letters.
- **Missing:**
  - The gold tree mass on the left.
  - The ornate Summon facade.
  - The dark red palm.
  - The bloom.

### c4_stairs: 6 -> 7
- **Gains:**
  - The grass wall is gone.
  - The flight opens onto the avenue, with gold and purple trees, umbrellas and twin blue palms.
  - Grey-green islands with falls.
- **Geometry:**
  - Summon is a small pavilion, about 140 px wide and 110 px tall. The reference is an ornate gold facade about 150 px wide,
    with a gold tree mass up to y≈190 behind it.
  - The islands sit low over the avenue, with their undersides at y≈0-220. In the reference they are high, at y≈100-260
    px, and distant.
- **Colour:**
  - The tread tops are now light (164,163,157), but the risers are near-black (34,50,73).
  - The reference stairs are uniform mid grey, with chunky bevelled blocks and no black risers.
- **Missing:**
  - Blue cypress cones.
  - The pineapple.
  - Flags.
  - Stall clutter.
  - The large crystal pods on the flanking walls.

## Scores
| camera | r7 | r8 |
|---|---|---|
| p1_spawn_n | 6 | 7 |
| p2_spawn_s | 6 | 7 |
| p3_spawn_e | 7 | 7 |
| p4_spawn_w | 6 | 6 |
| p5_diag_ne | 6 | 7 |
| p6_diag_sw | 6 | 7 |
| p7_high | 5 | 5 |
| p8_top | 5 | 5 |
| c1_wall | 6 | 7 |
| c2_fountain | 6 | 6 |
| c3_pavilion | 6 | 7 |
| c4_stairs | 6 | 7 |
| **average** | **5.92** | **6.50** |

## Top-10 fixes (ranked by visual impact)
1. **Rebalance the layout.** (Affects p7, p8, p3, p5 and c2.) This is the deferred pass-10 item, and the only thing holding
   p7 and p8 at 5.
   - Extend each arm from about 52 to about 80 studs.
   - Move Raid about 60 studs further east, to about 160-220 studs on the E axis, and scale it about 1.3x.
   - Fill the gap with grey gravel (104,107,109), red litter patches and black dead trees (40,30,35), each about 20 studs.
   - West: a lagoon (60,170,220) with a sand beach (225,205,150), palms and pool rings between the W arm and Story.
   - North: a 6-stud water channel (90,200,230) down the avenue, with sand strips either side.
   - South: replace the grass blocks over the S and W flight tops with white paving (230,230,225) and 2 pedestals with blue
     crystals.
2. **Make Raid glow.** (Affects p3, p5, c1, c2 and c3.)
   - Facade: lit (195,40,45), recesses (100,10,15), spires and domes (60,20,30).
   - Letters: red-pink (235,70,80), Material Neon or with a SurfaceLight.
   - Add the Neon beam (255,40,40), 1.5 studs wide, from the skull's mouth down about 20 studs to the letters.
   - Make the skull more angular, and shade it (140,60,65) with darker sockets.
   - Add 3 PointLights in (255,50,50), range 45, brightness 3, plus red Atmosphere or ParticleEmitter haze at the
     doorway.
   - Add 3 black dead trees and 1 dark red palm (120,30,40) in front.
   - Boss Rush: replace the flat magenta disc with a purple (170,70,255) swirl portal in a dark carved frame, with glow.
3. **Global mood lighting.** (Affects all 12 cameras.)
   - Bloom: Intensity 0.6, Size 30, Threshold 1.5.
   - ColorCorrection: Saturation 0.15, Contrast 0.1.
   - Atmosphere: Density 0.3, Haze 1.5, Color (200,220,240).
   - SunRays: Intensity 0.1.
   - Add glow in the crystal pavilions with PointLights (80,170,255), range 12.
   - The reference reads hazy and glowing; practice is flat midday.
4. **Grow Summon.** (Affects p1, p5, c1, c3 and c4.)
   - Replace the small pavilion with an ornate 2-storey facade, about 50 studs wide and 30 tall, facing the avenue.
   - Colour it gold and cream (215,190,120), with arched windows, a blue (50,90,180) band and gold 3D "Summon" letters about
     20 studs wide.
   - Behind it, add a gold tree mass (215,170,50), 2-3 trees about 35 studs tall.
   - In front: flags, stalls and umbrellas.
5. **Rebuild the Story tree and ring.** (Affects p4, p6 and p8.)
   - Trunk: tan (150,115,80), about 12 studs thick, with 4-5 thick branches spreading to about 60 studs high.
   - Foliage: 6-8 wispy clumps in (30,90,220), with gaps between them, and 10-15 hanging blue vines.
   - Shrink the plan footprint about 30%.
   - Ring: silver-blue carved frame (150,170,205).
   - Fill the hole with a glowing swirl portal (40,110,255), Neon, instead of navy.
6. **Thin the leaf spills and soften the grass.** (Affects c1, c2, p2 and p5.)
   - Cut the floor and stair spills to 2-3 patches per area, each 6-10 studs.
   - Use rounded leaf cards, not triangles.
   - Remove the red spill from the S-side floor.
   - Lawn strips: mix (90,160,50) and (120,180,60), and drop the height to about 1.5 studs.
7. **Fix the arch wings and stairs.** (Affects c1, c2, p1 and p5.)
   - Wing and balustrade flank faces: dark slate (65,72,75), with 2 recessed bands and a gold rim on top.
   - Keep the top faces mid grey (130,135,135).
   - Stairs: raise the risers from (34,50,73) to (95,105,115), so the flight reads as grey bevelled blocks rather than
     striped black.
   - Add a gold upper bowl lip on the drum.
8. **Medallion, gold and bollards.** (Affects p1-p6.)
   - Gold from (222,193,58) to (180,165,62), Material Metal.
   - Medallion: 8 thin hooked dark blades (45,55,65) on pale stone, with a gold hub and a ring of 8 gold studs.
   - Bollards: cut their height about 35% and give them a stepped gold cap.
9. **Lift and dress the islands.** (Affects p1, p4, c3 and c4.)
   - Lift the islands nearest the N, W and E axes by 15-20 studs, so their undersides sit at y≈60-150 px in p1 and c4.
   - Add 4-6 round trees (90,160,60), 15-20 studs each, per island.
   - Grow the ruins into grey towers (165,170,165), about 10x10x50 studs.
   - Add one aqueduct span and one domed rotunda.
   - Add hanging vines.
10. **Crystal pods and foreground foliage.** (Affects p1, p2, p4 and c4.)
    - Put big faceted Glass crystal pods (40,110,230), about 4x6 studs, 2 per arch, on the wall tops beside the
      pavilions, with a PointLight glow.
    - Add 6 blue cypress cones (40,90,220), each 4x14 studs, on the N avenue.
    - Put a green palm and a tree-on-pillar silhouette over the S gate.
    - Replace the faceted blue spikes with softer, wispier canopies.
