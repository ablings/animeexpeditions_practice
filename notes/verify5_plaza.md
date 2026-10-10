# Verify round 5: Anime Expeditions spawn plaza (freestyle, after fix pass 7)

**PROVISIONAL (no live reference).** Reviewed on the Shadow PC on 2026-10-10. The reference studio was not open on this
PC, so the reference is:
- the nine pictures in `out/refsheet/`: r1-r4 at player height from spawn, r5-r9 aerial;
- the round-4 written per-camera descriptions in `notes/verify4_plaza.md`.

Cameras marked **[r4 text]** below have no matching picture, and I scored them against the round-4 description only.
Confirm these scores on the main PC against the live reference.

## Method
- Practice studio is `ae13592b-5ca7-43d3-91a6-9135c14250eb`. Cameras come from `cams_practice.json`.
- I used `screen_capture` only: `v5_<cam>_a` then `v5_<cam>`, and judged the second capture.
- The pairs were identical except p1 and p4, where the sign text only appeared on the second capture.
- I ran no code and changed nothing.
- The judged frames are saved to `out/verify5/v5_<cam>.jpg`.
- "Sampled" RGB values are 5x5 averages from those JPEGs. All other colours and sizes are estimates. Rule of thumb: 1 stud at
  d studs is about 640/d px in this 1452 px frame.

## Overall read
Pass 7 fixed the two worst problems from round 4.

**The Raid landmark no longer reads as a creature.**
- It is now a skull with red eye sockets, teeth and a red beam, on a tall tower.
- It has a "RAID" plate, a pediment with a gold disc, a gothic arch with a red glow, two onion-dome towers and crenellated
  arcade wings.
- In p3 it is about 400 px wide against the ref's about 440, so the silhouette is now in the right league.

**The islands no longer read as saucers.** They are flat slabs with a jagged underside, a grass cap, white ruin towers and
trees on top, and clouds behind.

The grass, red and blue clumps are now mounded clumps rather than confetti. The S and W flights now read green, as the ref
does.

What still separates the build from the ref:
1. **Raid is a flat, saturated pink-red.**
   - The wall is sampled (167-185,39-47,62-70) and the skull (165,81,94).
   - The ref is dark weathered stone, about (92,40,48) in shade, with a grey-red carved skull.
   - There are no dead-tree thickets or red haze around the base.
2. **The islands still hang low and overhead, and their waterfalls are thin poles.**
   - In c4 they span y≈95-240 px straight above the avenue.
   - Their rock reads blue through the haze, sampled (74-103,128-139,167-188), where the ref is grey (137,148,145).
   - The ref (r1, r2) has distant islands with broad white waterfall curtains, and towers and domes on the skyline.
3. **The north-flight treads are still pale.**
   - c4 treads are sampled (173-190,184-192,188). The dark band (67,86,104) is only the riser shadow.
   - The S flight (c2) did get darker treads (119,122,139) with pale nosings, so the fix landed on one flight only.
4. **Expeditions is unchanged.**
   - The ring is still 8 rectangular grey boxes, sampled (95,100,121), around a white disc on a plain teal arch.
   - It has no "Expeditions" sign.
   - Ref r2 has curved crescent shards around a white oval and a gold-teal ornate gate.
5. **Far-field and horizon (p7, p8).** The ground is still a flat green plane, with dark ellipses at the horizon and no buildings.

## Per camera (round-4 score in brackets)

### p1_spawn_n: 7/10 (7). Ref: r1.
- Geometry:
  - The near field (gates, basins, bollards, lantern domes, runner) matches r1.
  - The Summon hall now has a sign, side turrets and umbrellas in front.
  - The hall is still a small plain cream block, about 110 px wide. r1 shows a big gold-and-cream ornate facade framed by
    huge gold trees.
- Colour:
  - The medallion gold is sampled (231,214,103), still pale and flat against r1's deep gold.
  - The medallion is still 4-5 broad swirls with no studs.
- Sky:
  - The new island slabs and ruins read far better than the saucers.
  - They still fill the top centre of the frame (y≈55-170).
  - Their 8 or so waterfalls are hairline poles. r1 has 2-3 wide bright curtains.
- Missing:
  - The gold-tree mass behind the Summon hall. The practice gold trees are small.
  - The big blue crystal pods on the walls beside the lanterns.
  - The large blue tree overhanging the right.

### p2_spawn_s: 6/10 (6). Ref: r2.
- Geometry:
  - Mounded grass clumps now sit on the flights and floor corners. The right-hand floor clump matches r2's spills well.
  - The Expeditions gate and ring are unchanged from round 4: a plain teal arch about 110 px tall with 2 grey pillars, and 8
    rectangular boxes in a ring about 165 px across, around a white disc.
  - In r2 the ring is curved crescent shards around a tall white oval, and the gate is an ornate teal-and-gold frame with a
    big "Expeditions" sign.
- Colour: the bollards are still lilac-grey. r2's are white.
- Missing:
  - The grass lawn at the top of the stairs.
  - The giant palm and the big tree on the rock, top right.
  - The domed towers and misty spires on the left of r2.
  - The orange trees beside the gate (2 are present but small).

### p3_spawn_e: 7/10 (6). Ref: r3.
- Geometry:
  - This is the biggest gain of the pass. The skull tower, onion towers, wings, gothic arch, sign plate and dead trees now
    give the r3 silhouette.
  - The red clumps on the stairs are now mounded clumps.
- Colour:
  - Everything is one saturated pink-red: the wall is sampled (167,39,62) and the skull (165,81,94).
  - r3 has darker stone, near-black wing towers, a grey-red skull and neon accents.
  - The skull is a smooth sphere with a face, not carved.
- Lighting: there is a faint red bloom at the arch. r3 is drenched in red light, with a red glow throughout the courtyard.
- Missing:
  - The dense dark-red tree thicket that surrounds Raid in r3.
  - The red litter carpet down the stairs and floor. Clumps are present, but there is no litter.
  - The Boss Rush tower on the left.

### p4_spawn_w: 7/10 (6). Ref: r4.
- Geometry:
  - The Story ring is a good size and now carries a gold crown and a "STORY" plate, as r4 does.
  - The canopy is big and fills the top centre.
  - The grass clumps on the flights match r4's grass spills.
  - The trunk is still mostly hidden behind the ring. r4's trunk is a huge tan trunk, about 200 px wide, splitting into
    thick twisting branches that are visible above the sign.
  - There are 4 blue palms, against about 6 in r4.
- Colour:
  - The ring void is sampled (4,19,58), still navy, where r4 is black.
  - The trunk is sampled (67,61,72) and the plinth (33,32,50): grey-purple, against r4's warm tan.
- Missing: the blue crystal pods on both sides, the fluffy blue trees right of the ring, the Guild facade on the right.

### p5_diag_ne: 7/10 (7). [r4 text]
- Geometry:
  - The layout still matches.
  - The Summon facade now has a sign, umbrellas and purple trees, which is better than the round-4 sand box.
  - The Raid front on the right reads as a building.
- Colour:
  - Raid is flat pink-red.
  - The Summon facade in shade is sampled (85,91,107), grey and dull, where the ref is ornate cream and gold.
  - The bollard is still a tall plain white post with a gold dome cap.
- Missing: the dense purple and gold trees with umbrellas, and the skull glow on Raid.

### p6_diag_sw: 7/10 (6). [r4 text]
- Geometry:
  - Both flights now carry mounded grass clumps, sampled (153,171,112). These were the ref's dominant colour here, and they
    are now present.
  - The Story crown and sign show on the right.
  - The Expeditions arch on the left is still plain, with box shards and no sign.
- Background: the horizon is still mostly empty sky. One island sits behind the gate.
- Missing: the "Expeditions" sign and ornate arch, a fuller grass carpet that joins the clumps, and the trees and towers on
  the horizon.

### p7_high: 6/10 (6). [r4 text]; r5-r9 used for the overall read.
- Geometry:
  - The cross, corner pools, medallion and runners read well.
  - The Summon hall, Story ring and Raid complex now read as landmarks from above.
- Colour:
  - The grass is now yellow-green, sampled (150,180,94), close to the ref's (151,177,73). That is fixed.
- Horizon:
  - It is still a flat green plane to the frame edge.
  - Dark shapes sit at y≈45-70, and a long dark band crosses the plane.
  - The ref (r5-r9) has the island edge with cliffs and sea, and dense buildings to the edge.
- East:
  - It is a big bare grey gravel field, sampled (141,151,158), with red palms around it.
  - The ref east is covered in dense red trees and litter.
- Missing: the west water channels, dense foliage, and the island rim and cliffs.

### p8_top: 6/10 (6). [r4 text]; compare r5.
- Geometry:
  - The pool centres and arms are as in round 4.
  - The E and W upper landings are still missing. The arms stop at the stair tops (x≈545 and x≈905).
  - The centre diamond is still large, about 165 px.
  - The Raid complex now has wings and onion towers from above.
  - The skull tower projects east as a long tube with the skull at its end. This is a perspective effect of a tall tower
    near the frame edge, but it still reads as a worm or rocket.
- Colour:
  - East is still mostly bare grey gravel with a few red trees.
  - r5 shows a red-brown, densely treed quadrant.
  - The west is a big blue tree mass, which reads closer to r5's blue quadrant than before.
- Missing: the north water channel and beaches, the south arcaded courtyard, and red litter.

### c1_wall: 6/10 (6). [r4 text]
- Geometry:
  - The basin and gate are unchanged.
  - The upper bowl is still a tall cylinder with gold rods.
  - The white "egg" dome is still in the bowl.
  - The blue and red clumps at the stair feet are now big mounded bushes, which is much better than confetti.
- Colour:
  - The vault is still a bright blue room, sampled (26,62,109).
  - The ref is a grey vault (30,42,61) with a gold ledge band.
- Background: Summon's sign, the Raid towers and an island read as a real backdrop.

### c2_fountain: 6/10 (5). [r4 text]
- Geometry:
  - The basin centre is still about 130 px left of the arch centre (about 4-5 studs forward). The ref is about 50 px.
  - The S flight now has dark treads, sampled (119,122,139), with pale nosings, and solid grass clumps. This is a clear
    material win.
- Background: Raid is still prominent at the top left, but it now reads as a castle rather than a blob.
- Missing: the falling water sheet, the cracked floor slabs, the floor tile grid, and the Boss Rush tower.

### c3_pavilion: 6/10 (5). [r4 text]
- Sky:
  - The grey slabs with white ruin towers, trees and clouds now read as floating ruins.
  - The towers are about 35 px. The ref towers are about 150 px tall with arches.
  - The waterfalls are thin translucent poles.
  - The island rock reads blue, sampled (79,128,167), where the ref is grey (137,148,145).
  - The centre and right of the sky are still empty except for Raid.
- Raid: the skull tower now reads as a skull. It is still flat pink-red, and the skull is smooth.
- Missing: the ornate Summon facade, the ruins and islands on the right half, and cumulus mass behind them.

### c4_stairs: 6/10 (6). [r4 text]; r1 for the gold-tree mass.
- Geometry:
  - The stairs, palms, lanterns and gold and purple trees are in place, and there are umbrellas at the hall now.
  - The runner is still about 640 px wide at the bottom of the frame.
  - The Summon hall is still close and small, about 150 px wide.
  - The islands still sit right above the avenue (y≈95-240). The ref has them higher and farther away.
- Colour:
  - The N-flight treads are still pale, sampled (173-190,184-192,188), with only a dark riser line (67,86,104).
  - The blue clumps are a good colour and shape.
- Missing: wide waterfalls straight ahead, the gold-tree mass, the blue cypress cones, and stall clutter.

## Scores
| camera | r4 | r5 | reference used |
|---|---|---|---|
| p1_spawn_n | 7 | 7 | r1 |
| p2_spawn_s | 6 | 6 | r2 |
| p3_spawn_e | 6 | 7 | r3 |
| p4_spawn_w | 6 | 7 | r4 |
| p5_diag_ne | 7 | 7 | r4 text |
| p6_diag_sw | 6 | 7 | r4 text |
| p7_high | 6 | 6 | r4 text + r5-r9 |
| p8_top | 6 | 6 | r4 text + r5 |
| c1_wall | 6 | 6 | r4 text |
| c2_fountain | 5 | 6 | r4 text |
| c3_pavilion | 5 | 6 | r4 text |
| c4_stairs | 6 | 6 | r4 text + r1 |
| **average** | **6.00** | **6.42** | |

## Top-10 fixes (ranked by visual impact)
1. **Push the islands back and up, and give them real waterfalls.** (Affects p1, p2, p5, c3 and c4.)
   - Move every island about 1.5x farther from the plaza and about 30 studs higher, so that in c4 they sit at y≈0-150 px
     and no longer cover the avenue end.
   - Set the rock colour to (137,148,145) and lower its haze tint, so it stops reading blue.
   - Replace the hairline waterfalls with 2-3 per island, each a 4-6 stud wide curtain in (200,230,245) at Transparency
     0.3, with a mist puff at the foot.
   - Raise the ruin towers to about 8x8x40 studs, with arched openings.
   - Fill the empty centre and right of the c3 sky with 2 more islands and 3-4 cumulus cards (241,242,236).
2. **Weather and darken Raid.** (Affects p3, p5, c2, c3 and p8.)
   - Walls: change from (185,47,70) to (130,55,58), with (92,40,48) trim.
   - Onion towers and spires: near-black red (60,25,30).
   - Skull: grey-red (125,85,72), Slate material. Add 2-3 studs of brow ridge, cheekbones and jaw so it stops reading as a
     ball. Keep the neon (255,50,50) eyes and beam.
   - Add a red PointLight (range 40, brightness 2) at the arch.
   - Add a red ParticleEmitter haze, or Atmosphere-style red fog cards, at the base.
   - Surround the base with 6-8 dark-red dead trees (120,30,35), each 10-15 studs tall.
3. **Rebuild the Expeditions ring and gate.** (Affects p2, p6 and p8.)
   - Replace the 8 boxes with 8 curved crescent shards, each about 6 studs long and 1.5 thick, arched along a ring of radius
     about 12 studs, in (150,155,165). Centre the ring about 10 studs above the arch top.
   - Make the glow a tall white oval (about 5x8 studs, Neon).
   - Scale the arch about 1.5x.
   - Add teal (60,170,170) stained-glass panels with gold (200,172,60) frames.
   - Add an "Expeditions" sign plate about 14x3 studs above the arch.
   - Add a grass lawn strip at the top of the S flight.
4. **Darken the N flight (and check E and W) to match the S flight.**
   - Set the treads on every flight to about (115,120,135), as on the S flight, with a 0.3-stud nosing (190,192,190).
   - The c4 treads are still (173-190,184-192,188).
   - Narrow the N runner by about 1.5 studs.
5. **Fill the East quadrant and the Raid stairs with red.** (Affects p3, p7 and p8.)
   - Cover about 60% of the bare east gravel (141,151,158) with dense red trees and bushes (150-190,40-86,40-76).
   - Add flat red litter decals or plates on the E stair treads and floor, as r3 does.
6. **Make Summon ornate and back it with gold trees.**
   - Move the hall back about 15 studs and scale it to about 40 studs wide and 30 tall.
   - Use cream (215,195,140) with gold (200,172,60) trim, 3 arched bays and 2 corner towers.
   - Plant 3-4 large gold trees (220,175,50), each 25-30 studs tall, behind and to the sides of the hall, as in r1.
   - Add 2-3 blue cypress cones along the avenue.
7. **Show the Story tree trunk.**
   - Recolour the trunk and plinth from (67,61,72)/(33,32,50) to warm tan (150,110,75)/(88,74,62).
   - Thicken the trunk about 2.5x, and add 4-5 thick branches that are visible between the sign and the canopy.
   - Make the ring void black (0,9,16).
   - Add 2 blue crystal pods (40,110,230, Glass) beside the ring, and 2 more blue palms.
8. **Basin, water and vault.** (Affects c1, c2 and p1-p6.)
   - Pull each basin back about 4 studs toward its arch.
   - Replace the white egg dome with a wispy ParticleEmitter spray (170,220,240) and a thin water sheet over the ledge.
   - Lower the upper bowl and replace the gold rods with a dark slatted grille.
   - Vault: grey (30,42,61) with a gold ledge band, and lower the blue light to brightness about 0.8.
9. **Ground and horizon.** (Affects p7 and p8.)
   - Remove the dark shapes and band on the horizon plane.
   - End the ground at an island rim with grey cliffs (137,148,145) and sea or sky beyond, as in r5-r9, about 150-200 studs
     from the centre.
   - Add the E and W upper landings: a runner about 25-30 studs long past each stair top, ending in a glowing tile.
   - Add 2 west water channels (90,170,200).
   - Shrink the centre diamond about 20%.
10. **Medallion, bollards and crystals.**
    - Redraw the medallion as 8 thin hooked blades with a ring of 8 gold studs.
    - Darken its gold from (231,214,103) to (180,165,62), Metal material.
    - Make the bollards white (235,235,235) instead of lilac, and shorter (about 3 studs) with a bevelled gold cap.
    - Add the big blue crystal pods (about 4x6 studs, (40,110,230), Glass) on the wall tops beside the lanterns, as in r1-r4.
