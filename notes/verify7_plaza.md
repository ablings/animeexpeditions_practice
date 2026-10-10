# Verify round 7: Anime Expeditions spawn plaza (freestyle, after fix pass 9)

Scored against the **live reference** on the Shadow PC, 2026-10-10, by an independent reviewer who had not seen the build before.

## Method
- Reference studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- Practice studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- I used `screen_capture` only and ran no code. Nothing was modified or saved in either studio.
- Captures are `v7_<cam>_ref_a` / `v7_<cam>_ref` and `v7_<cam>_rep_a` / `v7_<cam>_rep`. Every pair matched, so the second
  frame was judged and no third capture was needed.
- The judged frames are in `out/verify7/v7_<cam>_ref.jpg` and `v7_<cam>_rep.jpg`, 1452x793.
- "Sampled" RGB values are 5x5 averages from those JPEGs. All other colours and every size in studs are estimates from the
  pictures. For p8, the scale is about 3.5 px per stud at plaza height.

## Overall read
Pass 9 is the biggest step so far. The practice plaza now has an island ceiling, waterfalls, a red Raid with a skull and
beam, dark fountain arches, water-sheet fountains, thin Story ring, 3D signs, tall-grass lawns, a Guild facade and grey
towers. In c3 and c4 it finally reads as a hub under floating islands instead of a model on an empty table.

Several of these pieces overshoot or land in the wrong value:

1. **The islands are the wrong colour and hang too low.**
   - The undersides are purple, sampled (70,50,88). Reference island rock is pale grey-green: (177,180,169) lit and
     (121,135,123) in shade.
   - In p1, p2, p4 and c4 the islands form a solid purple ceiling that starts at the top edge of the frame and comes down to
     y≈200, with icicle spikes.
   - The reference islands sit a little higher, are lighter and broken up by sky. Their caps are much greener and fuller,
     with round trees, ruins and vines.
   - The practice waterfalls end mid-air in white cloud discs, which read as pillars on plates.
2. **The fountain arches overshot to uniform near-black.**
   - Every practice face samples (57-65,69-74,83-86).
   - The reference arch is **two-tone**. The crest and outer ring band are mid grey (132,135,135), and only the recessed inner
     bands are dark (51-66,60-70,68-74).
   - Without the light faces the arch loses its carved form and becomes a dark silhouette.
3. **Raid is now red, but it reads as a cartoon on a plinth.**
   - The skull is a round pink blob on a box pedestal above the facade, and the "Raid" letters sit on that pedestal.
   - In the reference the skull is a carved head fused into the top of a tall gothic facade. The beam runs about 20 studs from
     its mouth down to the "Raid" letters over the doorway arch.
   - The reference also has bloom, dark spires, black dead trees and a dark red palm.
   - The practice facade is a flat pink (175,53,75), with no light/dark sculpting.
4. **The fountain drum is oversized.** In c1 it fills about 60% of the basin width and is about 170 px tall. In the
   reference it is a small slatted drum, about 38% of the basin, with water falling onto it from the ledge behind.
5. **From above (p7/p8), the layout is crowded.**
   - The practice landmarks sit about 95-100 studs from the centre, with plain grass between. Story and Raid crowd the arms.
   - The reference keeps a ring of themed ground between the arms and the landmarks: the W lagoon, the N water channel, the
     E gravel road to a carved plaza at about 160-200 studs, and the S white courtyard.

## Per camera (round 6 -> round 7)

### p1_spawn_n: 6 -> 6
- **Geometry:**
  - Gains: the islands with waterfalls now fill the top, the bollards are white with gold caps, and there are water sheets in
    the basins, umbrellas on the avenue and a Guild facade on the left.
  - Gaps:
    - The island band reads as a solid lid from y=0 to y≈190. The reference has gaps of sky between the islands.
    - Summon is still a small pink-cream dome pavilion, about 130 px wide. The reference is an ornate facade with a gold-tree
      mass rising behind it to y≈120 and light shafts.
    - The bollard plinths are about 140 px wide and tall. The reference bollards are about 110 px and squat.
- **Colour:**
  - Island undersides are purple (70,50,88). They should be grey-green rock.
  - The arch is uniformly dark. The reference has a mid-grey crest and ring.
  - The medallion gold is still too bright: (232,212,94) against (179,164,63).
  - The medallion is still 5 broad swirls. The reference has 8 thin hooked blades.
- **Lighting:** Flat. The reference has bloom, light shafts and glowing crystal pods.
- **Missing:** big blue crystal pods next to the kiosks; gold-tree mass behind Summon; stall clutter; grey palace towers
  framing both sides.

### p2_spawn_s: 6 -> 6
- **Geometry:**
  - Gains: a tall-grass lawn at the top of the flight, a 3D "Expeditions" sign and two minarets.
  - The gate is still a single teal greenhouse window. The reference is a triptych: a centre arch with a swirling dark-teal
    portal and statue, two side arches, crystal fountains and lanterns.
  - The shard ring is now dark navy, sits behind and in front of an island, and is half hidden. The reference ring is grey
    stone shards around a white oval, clear against open sky.
- **Missing:**
  - Foreground blue crystal pods and blue trees beside the kiosks.
  - The tree on the rock pillar, upper centre-left.
  - The palm, upper right.
  - Domed palaces, upper left.
- **Note:** The red spill sits on the left (east) side here, where the reference shows none. It is fine thematically but
  heavier than the reference.

### p3_spawn_e: 6 -> 7
- **Geometry:**
  - The best-improved camera. The red Raid, skull with red eyes, beam, "Raid" letters, small skull keystone, onion towers, red
    fog and red trees all read from the spawn, and the silhouette is now right.
  - Remaining gaps:
    - The skull is a round head on a stepped box plinth, with the letters on the plinth. In the reference the skull is carved
      into the upper facade and the long beam runs down to the letters over the doorway arch.
    - There is no Boss Rush purple glow left of Raid. The reference has it at x≈480-560 px.
- **Colour and lighting:**
  - The facade is flat pink (175,53,75). The reference ranges from (225,125,115) in the bloom to (203,48,53) in shade, with
    black dead trees and dark spires.
  - Practice has fog but no bloom glow on the facade.

### p4_spawn_w: 6 -> 6
- **Geometry:** The ring is now thin, which is good. The tree is a dense, dark navy faceted canopy that hides the trunk and
  branches. In the reference the big tan trunk and spreading branches are the main shape, with wispy blue foliage and hanging
  strands.
- **Colour:**
  - The "Story" letters are dark blue on the dark blue canopy and unreadable. The reference letters are pale blue with a dark
    outline on the ring crest.
  - The ring is navy and gold. The reference ring is silver-blue.
- **Missing:**
  - The gold Guild facade on the right. Practice has a white building there.
  - Crystal pods.
  - About 3 more blue palms around the ring.

### p5_diag_ne: 6 -> 6
- **Geometry:**
  - The composition holds. Raid is now red with a skull keystone and letters.
  - Summon still reads as a single-storey tan arcade with a dome, partly hidden by trees. The reference is a long ornate
    facade with gold letters, stalls and flags in front.
- **Colour:** The Raid facade is flat pink. The reference is sculpted red with a black dead tree, a dark red palm and a Boss
  Rush purple glow at x≈950 px.
- **Missing:** purple wisteria mass, blue cypress cones, the wall of islands at top left. The practice island is purple and
  covers the top of the frame.

### p6_diag_sw: 6 -> 6
- **Geometry:**
  - Gains: the ring is thin and no longer reads as a cannon, there is a tall-grass lawn along the top, and both 3D signs are
    present.
  - Remaining gaps:
    - The Expeditions gate is a greenhouse window.
    - The "Story" letters sit inside the canopy and cannot be read.
    - The lawn is a uniform bright wall, sampled about (110,200,50). The reference grass is lower and mixed.
- **Missing:**
  - The big green palm top centre.
  - The island ruin tower centre.
  - The orange tree.
  - The blue crystal pods on the arch.
  - The shard ring. Practice shows only a white oval at top left; the shards are lost.

### p7_high: 5 -> 5
- **Gains:** The grey gravel to the east, red fog, Guild facade, grey towers and Story ring are all visible.
- **Gaps:**
  - The Raid block fills the right foreground, at x≈1150-1450 and y≈0-450. In the reference that area is open grey gravel
    with red litter; Raid is out of frame and only the Boss Rush is visible at top right.
  - West is flat lawn plus the giant Story tree. The reference has a blue lagoon with beach, palms and pool toys.
  - The S flight top is buried under a big grass block. The reference has grass and sand with white pedestals carrying blue
    crystals.
  - The N avenue is paved. The reference has a water channel lined with blue cypress.
- **Colour:** Too much uniform lawn (110,170,60) and not enough sand, water and gravel.

### p8_top: 5 -> 5
- **Practice:**
  - The Story tree blob covers the whole west.
  - The Raid block and skull sit 95-195 studs east, directly on the axis.
  - A plain paved N avenue.
  - Short arms, about 52 studs from the centre to the arm end.
  - A centre diamond about 170 px across.
- **Reference:**
  - The arms are about 80 studs long. The E arm becomes a grey gravel road with red litter to a carved plaza at about
    160-200 studs.
  - The W arm reaches a stepped Story arena with water at about 150-200 studs.
  - A blue water channel runs up the N avenue, with sand beaches either side.
  - The south is a white arcaded courtyard.
  - The centre diamond is about 145 px across.

### c1_wall: 6 -> 6
- **Geometry:**
  - The egg dome is gone and there is now a slatted drum with a water sheet. The concept is right.
  - The drum is too big: about 330 px wide and 170 px tall. The reference is about 205 px wide and 70 px tall.
  - The basin is about 650 px wide against about 540 px in the reference. It still sits forward of the arch.
- **Colour:**
  - The arch is all dark, (57,69,83). The reference crest is (132,135,135) and the inner bands are (58,61,79).
  - The gold is too bright and flat: (211,183,68) against (117-120,102-110,32-36) in shade in the reference.
- **Foliage:**
  - Practice spills cover nearly all of the flanking treads, as angular shards.
  - The reference spills are 2-3 patches, each 6-10 studs, and most treads are bare grey.
- **Background:** The reference shows Raid with glowing letters and a skull, and Summon with flags and umbrellas. Practice
  shows a flat pink Raid wall and a small tan Summon.

### c2_fountain: 6 -> 6
- **Geometry:**
  - The basin is still forward of the arch mouth.
  - The arch side wing is a long flat dark slab. The reference balustrade has carved bands and a lighter top.
  - The green spill covers the whole floor foreground. The reference has 2 small splashes.
- **Colour:**
  - Risers are near-black blue (26,40,66), and treads are (115,123,135).
  - The reference treads are light (170-190) with dark joints and a gold nosing.
- **Missing:** the Boss Rush tower with purple portal and sign, the black dead tree mass, grey palace domes on the right and
  the orange tree. Practice has only a magenta blob at far left.

### c3_pavilion: 5 -> 6
- **Gain:** This camera gained the most. Islands now fill the upper band, with grass caps, trees, ruin towers and four
  waterfalls.
- **Gaps:**
  - The island rock is purple (70,53,89) against pale grey-green (121-177,135-180,123-169) in the reference.
  - The waterfalls stop at cloud discs.
  - The ruins are small white boxes. The reference has tall grey towers, about 150-200 px, plus an aqueduct and a domed
    rotunda.
  - The skull is about 200 px wide, on a plinth, and its eyes are cut-out black sockets with red discs. The reference skull is
    about 160 px, carved into the facade, with bloom.
- **Missing:** the ornate Summon facade and gold tree on the left, the purple wisteria mass and the dark red palm.

### c4_stairs: 5 -> 6
- **Gains:** The island band with waterfalls fills y≈0-240 above the avenue. The palm pair and blue crystals frame the view,
  and there are umbrellas and gold and purple trees.
- **Gaps:**
  - A tall-grass wall runs across the top of the N flight. The reference opens straight onto the avenue: stalls, pineapple,
    flags, blue cypress cones and people.
  - Summon is a small pavilion, about 140 px wide. The reference is an ornate two-storey facade about 150 px wide, backed by
    a gold tree mass up to y≈190.
- **Colour:**
  - The tread tops are too dark: (111,123,138) against (189,192,188) in the reference.
  - The island rock is purple.

## Scores
| camera | r6 | r7 |
|---|---|---|
| p1_spawn_n | 6 | 6 |
| p2_spawn_s | 6 | 6 |
| p3_spawn_e | 6 | 7 |
| p4_spawn_w | 6 | 6 |
| p5_diag_ne | 6 | 6 |
| p6_diag_sw | 6 | 6 |
| p7_high | 5 | 5 |
| p8_top | 5 | 5 |
| c1_wall | 6 | 6 |
| c2_fountain | 6 | 6 |
| c3_pavilion | 5 | 6 |
| c4_stairs | 5 | 6 |
| **average** | **5.67** | **5.92** |

Pass 9 added the right pieces. Most cameras did not move a full point, because the new pieces landed in the wrong value or
colour: purple islands, all-dark arches, a flat pink Raid and an oversized drum. These are cheap fixes with a big payoff.

## Top-10 fixes (ranked by visual impact)
1. **Recolour and open up the islands.** (Affects p1, p2, p4, p5, p6, c3 and c4.)
   - Underside rock from purple (70,50,88) to grey-green stone: lit faces (175,178,168), shade faces (120,135,125).
   - Remove or halve the icicle spikes. The reference undersides are blocky, broken rock with vines.
   - Lift the four islands nearest the spawn axes by about 20-25 studs. In p1 and c4 their undersides should sit at about
     y≈60-150 px instead of 0-200 px.
   - Open 2-3 sky gaps, each 20-30 studs wide, between islands, so the band reads as separate islands rather than a lid.
   - Thicken the grass caps to (110,170,70) and let them spill over the edges.
   - Add 4-6 round trees per island in (90,160,60), 15-20 studs each.
   - Replace the small white ruin boxes with grey stone (165,170,165) towers, 10x10x50 studs.
   - Waterfalls:
     - Delete the white cloud discs at the foot.
     - Fade each fall out over its lower third, using stacked parts at Transparency 0.2 -> 0.5 -> 0.8.
     - Add a mist ParticleEmitter at the fade point.
2. **Make the fountain arches two-tone and fix the gold.** (Affects every spawn and close view: p1-p6 and c1-c4.)
   - Crest, horns, top surface and outer ring band: mid grey (130,135,135).
   - Inner recessed bands and vault: keep dark (55,62,72).
   - Side wings and balustrade: top face (130,135,135), flank face (75,85,95).
   - Plaza gold (edges, bollard caps, medallion): from flat (211-232,183-212,68-94) to (180,160,65), Material Metal, so it
     shades darker.
   - Lighten the stair tread tops to (175,180,180) and keep the risers dark (60,70,85). The current treads are
     (111,123,138) and the risers (26,40,66).
3. **Fuse the Raid skull into the facade and add glow.** (Affects p3, p5, c1, c2 and c3.)
   - Remove the box plinth.
   - Build the skull as the top of a tall central gothic gable, about 22-25 studs wide, with its chin about 15 studs above the
     doorway.
   - Run the Neon beam (255,40,40), about 1.5 studs wide, from its mouth down about 20 studs to the "Raid" letters.
   - Move the letters onto the facade directly above the doorway arch, just above the small skull keystone.
   - Shade the facade:
     - lit faces (200,80,88);
     - recesses and trim (95,35,45);
     - spires and onion domes (70,30,40).
   - Add a red Bloom/SurfaceLight on the facade: 3 PointLights in (255,60,60), range 40-50, brightness 3.
   - Add 2-3 black dead trees (40,30,35), each 20 studs tall, in front, and one dark red palm (120,30,40) on the left.
   - Make the Boss Rush purple portal (200,80,255) visible left of Raid from p3: about 15 studs north of Raid and in front of
     its line.
4. **Scale the fountain core down and tuck it in.** (Affects c1, c2, c3 and p1-p6.)
   - Drum: shrink to about 60% of its current diameter and 45% of its height. The target is about 4 studs across and 1.5
     studs tall.
   - Add a small upper bowl lip (gold) on top.
   - Narrow the water sheet to about 3 studs and let it fall from the vault ledge onto the drum.
   - Shrink the outer basin about 15% and pull it back about 3-4 studs so its back rim sits under the arch mouth.
5. **Open the Story tree and make the sign readable.** (Affects p4, p6 and p8.)
   - Canopy: lighten to (60,120,240) and cut it into 6-8 separate wispy clumps with gaps, so the tan trunk (150,115,80) and
     3-4 thick branches read through.
   - Hang 10-15 blue strands (70,130,240), each 6-12 studs long, from the canopy.
   - Shrink the footprint about 30% in plan; it currently covers the whole west in p8.
   - Move the "Story" letters out of the canopy onto the ring crest, about 2 studs above the ring. Use pale blue
     (170,210,255) with a dark navy outline (20,30,70).
   - Ring frame: silver-blue (150,170,205) instead of gold and navy.
6. **Open the N avenue and grow Summon.** (Affects c4, p1, p5, c1 and c3.)
   - Remove the tall-grass strip across the top of the N flight; the reference has none there.
   - Put stalls, umbrellas, flags and a pineapple prop on the first 20 studs of the avenue.
   - Line it with 6 blue cypress cones (40,90,220), each 4x14 studs.
   - Make Summon read as a wide 2-storey ornate facade (pass 9's arcade is not visible from c4 or p1):
     - about 50 studs wide and 30 tall, facing the avenue;
     - cream (225,210,170) with a gold (200,170,60) frieze and a blue (50,90,180) band;
     - gold 3D "Summon" letters about 20 studs wide.
   - Behind it, add 2-3 gold trees about 35 studs tall, with 30-stud canopies, in (215,170,50).
7. **Rebuild the Expeditions gate as a triptych and restore the shard ring.** (Affects p2, p6 and p8.)
   - Centre arch about 12x20 studs, with a dark-teal swirl portal (20,110,110) and a statue.
   - Two side arches about 8x14 studs.
   - Gold filigree (200,170,60), and lantern posts either side.
   - Shard ring:
     - grey stone (110,125,145) instead of navy;
     - about 30% larger;
     - placed in open sky, so move the island behind it about 30 studs sideways or up.
8. **Rebalance the layout around the arms.** (Affects p7, p8, p3 and p5.)
   - Extend each arm about 25 studs, from about 52 to about 80 studs from the centre.
   - Move the Raid block about 60 studs further east, onto the E axis at about 160-220 studs, and scale it about 1.3x so it
     keeps its size from p3.
   - Fill the gap with a grey gravel road (104,107,109), red litter patches and black dead trees, ending in a small carved
     stone plaza at about 160 studs.
   - West: a blue lagoon (60,170,220) with a sand beach (225,205,150), palms and pool toys between the W arm and Story.
   - North: a water channel (90,200,230), about 6 studs wide, down the avenue centre, with sand strips either side.
   - South: replace the grass block over the S flight top with a white paved courtyard (230,230,225) and 2 white pedestals
     carrying blue crystals.
9. **Thin the foliage spills.** (Affects c1, c2, c3, p1-p6 and p7.)
   - Cut spill coverage on the flights and floor from about 80% to about 25%: 2-3 patches per flight, each 6-10 studs across.
     Leave the tread edges bare grey.
   - Use rounder leaf cards instead of sharp triangles.
   - Mute the lawn strips: mix (90,160,50) and (130,190,70) blades and drop the height to about 1.5-2 studs.
10. **Plaza props and details.** (Affects p1-p6.)
    - Big blue crystal pods beside each kiosk on the wall tops: faceted Glass (40,110,230), about 4x6 studs, 2 per arch,
      with a light glow.
    - Bollards: about 30% shorter and squatter.
    - Medallion: 8 thin hooked dark blades (45,55,65) on pale stone, with a Metal gold centre (180,165,60) and a ring of 8
      gold studs.
    - Floor: a tile grid with dark joints (110,120,125).
