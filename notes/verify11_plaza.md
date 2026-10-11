# Verify round 11: Anime Expeditions spawn plaza (freestyle, after fix pass 13)

Scored against the **live reference** on the Shadow PC on 2026-10-10. The reviewer is independent and had not seen the build
before. Round 10 (`verify10_plaza.md`) was read for context only; every score below is fresh.

## Method
- **Reference:** studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- **Practice:** studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only. No code was run, and nothing was modified or saved in either studio.
- **Captures:** `v11_<cam>_ref_a` / `v11_<cam>_ref` and `v11_<cam>_rep_a` / `v11_<cam>_rep`, all 1452x793.
  - Pixels that changed by more than 30 levels within a pair: at most 5.8% in the reference (animated water, VFX, leaves)
    and at most 1.9% in the practice place.
  - So the second frame was judged and no third frame was needed.
- **Files:** `out/verify11/v11_<cam>_ref.jpg` and `v11_<cam>_rep.jpg`. The `_a` frames are kept alongside.
- **Colour values:** "sampled" RGB is a 5x5 average from those JPEGs. All other colours and all stud sizes are estimates.

## Overall read
Pass 13's big win is **density and colour blocking**: the masses behind Summon now land.
- A gold mass sits left of Summon and a purple wisteria mass sits right of it.
- The wisteria has hanging drip strands, and it reads correctly in c4, p5 and c3.
- A blue tree now stands over every arch.

From p5, c3 and c4 the layout of the N/NE quarter now matches the reference picture for picture.

**Foliage style (asked specifically).** This is better than the crystal shards and spheres, but it is still not the
reference style. The new clumps have broken, lumpy outlines, so the silhouettes are right. Close up, though, every clump
reads as **crumpled paper or cabbage leaves**, for three reasons:
- **The leaf cards are too large.** Each card reads 3-5 studs with one big leaf shape, so the shading breaks into a few large
  flat planes with hard creases.
- **The lit faces go pale and shiny.** Practice blue-tree highlights sample about (126,168,228), with white specular glints.
  Reference blue foliage is deeply saturated, e.g. (14,60,198), with bright cyan tips.
- **The reference is fine-grained.** Its leaves read as high-frequency speckle, roughly 0.3-0.5 stud leaves, with a dark core
  and bright edges and no specular at all.

Gold clumps have the same problem and also run dark and olive: shadowed gold samples (119,93,37), against the reference's
(196,156,71). The wisteria is the best of the new kit, because its drip strands hide the card planes.

**Raid haze is now visible, but it is the wrong colour.** It is a pale pink-grey cloud, sampled (173,153,164) and
(175,157,167) beside the skull. The reference air there is saturated red, sampled (184,74,75) and (199,77,89).
- The cloud makes the practice facade read lighter and flatter.
- The skull (132,67,78 at the brow) is now darker than the haze around it. Last round it was the focal point.

**Unchanged from round 10:**
- The white bollards and the 5-swirl medallion.
- The pale wing flanks.
- Low islands with glass-slab waterfalls.
- The Story trunk lying across p8.
- The two white plinths at the Raid door (third round in a row).

## Per camera (round 10 -> round 11)

### p1_spawn_n: 7 -> 7
- **Gains:**
  - A gold mass (about 6 clumps, ~350 px wide) and a purple mass now frame Summon, as in the reference.
  - The arch-side blue trees are larger and fill the upper corners.
- **Geometry:**
  - **Islands:** an island underside still hangs from the top edge (y 0-130 px). Reference islands sit behind a skyline with
    towers and an aqueduct.
  - **Summon:** a plain pediment box about 160 px wide. The reference is a domed arcade about 150 px wide, with a statue in the
    arch.
  - **Bollards:** still tall white plinths (about 80 px) with a smooth gold dome. The reference bollards are squat grey stone
    with a pointed, stepped gold cap.
  - **Medallion:** still 5 broad swirls. The reference has 8 thin hooked blades and a ring of 8 gold studs at its rim.
- **Colour:**
  - The blue trees are mid-blue with white glints. The reference is deep saturated blue with fine texture.
  - Sky (57,197,241) is close.
- **Missing:**
  - Blue palms on the avenue at the Summon flanks (the reference has 2 big ones, 200 px tall).
  - Crystal pods on the arch tops.
  - The Guilds facade at upper left (practice has a white building).
  - Crowd and stall clutter.

### p2_spawn_s: 7 -> 7
- **Gains:**
  - The SW red tree is gone.
  - A green broadleaf tree right of the gate.
  - Blue clumps over both arches.
- **Geometry:**
  - **Shard ring:** still navy blue segments around a white oval, hung at y≈20-220. The reference ring is grey stone, with the
    green palm crossing it.
  - **Expeditions gate:** about 180 px wide with a spiral face. The reference is about 220 px, with a turquoise cloudy door
    and a crystal fountain either side.
- **Colour:** the gate teal is close. The ring should be grey (150,155,160), not navy.
- **Missing:**
  - The big green palm at upper right.
  - The tree on a rock pillar at centre-left.
  - The domed palaces at upper left.
  - Grass tufts on the S stairs.
  - The bloom on the gate.

### p3_spawn_e: 8 -> 8
- **Gains:** the red haze is visible for the first time, and the dead trees across the facade foot read well.
- **Geometry:**
  - **Skull tower:** still a plain stacked block rising out of the facade.
  - **White plinths:** the two at the door foot are still there (about 25 px each, the brightest thing in the lower Raid).
  - **Palms:** the dark red palms now droop like bat wings at the door. The reference palm is upright with spread fronds,
    left of the door.
- **Colour and lighting:**
  - The haze is pink-grey and translucent, not red. The skull is darker than the cloud behind it, so the focal point is lost.
  - The facade has gone bright red (153,30,39) under the haze. The reference facade is dark, with the red coming from the light.
- **Missing:** the Raid sign and arch detail, red spill on the steps (practice has a few petals), and the left upright red palm.

### p4_spawn_w: 7 -> 7
- **Gains:** the Story canopy is now blue leaf clumps with drip vines instead of discs, so it is less lollipop-like.
- **Geometry:**
  - **Story tree:** the canopy is about 300 px wide and sits above a long bare trunk with three straight limbs. The reference
    is a thick gnarled trunk inside a canopy filling the top 300 px edge to edge, with hanging blue moss.
  - **Portal:** still a navy-and-white graphic spiral in a gold ring. The reference is a carved silver-blue frame around a
    black opening.
- **Missing:**
  - The gold Guild facade at upper right (practice shows white buildings).
  - Green palms at left.
  - Blue clumps packed round the portal base.
  - Grass tufts on the stairs.

### p5_diag_ne: 7 -> 8
- **Gains (large):** the three items round 10 listed as missing are now in:
  - the gold masses over Summon;
  - the purple wisteria mass between Summon and the arch;
  - the blue tree over the arch.
  The composition now matches the reference: Summon at left, purple, the arch, then Boss Rush and Raid at right.
- **Geometry:**
  - **Summon:** a plain yellow facade. The reference is cream/gold with columns and a gold statue.
  - **Bollard:** the foreground one is a tall white plinth. The reference is squat, with a pointed gold cap.
  - **Raid:** the practice Raid fills the right edge as a flat red slab.
- **Colour:** the gold is too olive in shadow, and the blue tree is pale on its lit side.
- **Missing:** blue palm at left of the arch, the red palm in front of Boss Rush, and stalls at Summon.

### p6_diag_sw: 7 -> 7
- **Geometry:**
  - **Island:** the underside fills the top centre (y 0-150). The reference has open sky with a green palm, a ruin tower and
    the grey shard ring.
  - **Waterfalls:** still translucent white glass slabs.
  - **Story portal:** a spiral disc. The reference has a dark opening in a carved frame.
- **Gains:** a green broadleaf near the gate and blue palms at right.
- **Missing:**
  - The big green palm at top centre.
  - The orange tree behind the Expeditions fountain.
  - Lanterns.
  - Grass on the stairs.

### p7_high: 7 -> 7
- **Gains:**
  - The lawn is darker. The right side samples (109,165,59) against the reference's (104,182,58).
  - The clumps give the arch corners real mass.
- **Geometry:**
  - **Horizon:** flat green baseplate is visible at both top corners, and the far trees stand evenly spaced on brown trunks.
    The reference background is solid buildings and foliage with no ground showing.
  - **W lagoon:** still small, at upper left. In the reference, water ringed by blue foliage and palms fills the left third.
  - **Terraces:** the E/W ones are plain white boxes.
- **Colour:**
  - **Red litter:** now large round red ovals (polka dots, about 15 px each). The reference red is irregular, ragged leaf
    splats in big continuous patches with green holes.
  - **Gravel:** close (92,104,100 against 98,108,98).
- **Missing:**
  - The big green palm and pineapple at bottom left.
  - Sand beach and beach rings.
  - Boss Rush is a flat box with a spiral; the reference is a carved purple shrine.

### p8_top: 7 -> 7
- **Gains:**
  - The N avenue shows purple and gold masses.
  - The E zone reads as gravel with red litter and dead trees.
- **Geometry:**
  - **Story trunk:** it still lies across the W half as a long tan bar (about 300 px). The reference W is a ring of blue foliage
    around a stepped round arena.
  - **E terrace:** a bare white box (about 90x110 px).
  - **W/SW lawn:** about 40% is still open flat lawn. The reference is fully covered.
- **Colour:** the red is polka dots again. The reference E zone is about 60% solid red cover with green patches.
- **Missing:** the S sand beach with palms at the corners, the W arena, and the round fountain basins with dark water.

### c1_wall: 7 -> 7
- **Gains:** the purple wisteria and gold masses at left now read like the reference's Summon side.
- **Geometry:**
  - **Wing flank:** still a plain pale slab rising to both sides. The reference wing is darker, with recessed bands.
  - **Fountain:** the centre column is a translucent blue box. The reference has a sculpted water splash.
- **Colour:**
  - **Foreground splats are colour-swapped.** The reference has a blue splat at left (Summon side) and a red one at right
    (Raid side). Practice has red at left and blue/red at right.
  - The practice splats are crisp low-poly starbursts; the reference's are soft, fringed leaf splats.
- **Missing:** the blue crystal pods beside the pavilions (reference: 2, each about 60x110 px), and the lit pavilion interiors.

### c2_fountain: 7 -> 7
- **Gains:** Boss Rush with its dead trees and the spiral, plus a hint of haze behind the arch.
- **Geometry:**
  - **Wing:** the arch side wing is still a long pale wall rising to the right. The reference wing stays low and dark.
  - **Raid:** sits as a flat pink block behind the arch top.
- **Missing:**
  - The orange tree and the grey palace domes at right (practice has sky and a cloud).
  - Tall grass behind the right stairs.
  - The red palm at left.
  - Raid's carved facade.

### c3_pavilion: 8 -> 8
- **Gains:** a gold mass at left, purple wisteria behind Summon, a blue tree over the arch, and Raid with haze and the beam.
- **Geometry:**
  - **Islands:** still low and close, filling the top 280 px. Their towers are about 60 px tall; the reference towers and
    aqueduct are 150-200 px. The reference islands are high and far, with lots of sky between them.
  - **Waterfalls:** wide translucent white slabs.
- **Colour:**
  - The haze is pink-grey rather than red, as in p3.
  - The sky behind the islands reads pale (177,213,233). The reference is (86,199,243).
- **Missing:** the dark red palm in front of Raid's left side, the lit crystal pods, and the Summon statue.

### c4_stairs: 7 -> 7
- **Gains:** big gold and purple masses with hanging wisteria, twin blue palms framing Summon, and blue cypress cones.
- **Geometry:**
  - **Islands:** still low and crowding the top third (three undersides, y 0-200).
  - **Summon:** about 200 px wide, a pediment box.
  - **Cypress:** the cones are small and read as crystal shards (about 60 px tall). The reference cypress pair is about
    210 px tall, soft and dense.
- **Colour:** the gold is olive-brown; it should be warm yellow. The purple is close.
- **Missing:**
  - The gold pineapple at left (reference about 120 px).
  - Blue hedge masses at the stair tops.
  - Bunting, flags, crowd and stall clutter.
  - The glowing pavilion crystals.

## Scores
| camera | r10 | r11 |
|---|---|---|
| p1_spawn_n | 7 | 7 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 8 | 8 |
| p4_spawn_w | 7 | 7 |
| p5_diag_ne | 7 | 8 |
| p6_diag_sw | 7 | 7 |
| p7_high | 7 | 7 |
| p8_top | 7 | 7 |
| c1_wall | 7 | 7 |
| c2_fountain | 7 | 7 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 7 | 7 |
| **average** | **7.17** | **7.25** |

## Top-10 fixes (ranked by visual impact)
1. **Make the leaf clumps read as fine foliage, not crumpled paper.** (All cameras.)
   - Shrink each leaf card to 1.5-2.5 studs and double the card count per clump (40-80).
   - Re-author the cut-out texture so each card carries 15-30 small leaves (0.3-0.5 stud each), not one big leaf.
   - SurfaceAppearance: Roughness 1, Metalness 0, no specular; this kills the white glints.
   - Bake a gradient: dark core to bright tips.
     - Blue: core (10,40,150), tips (60,150,255).
     - Gold: core (170,120,30), tips (250,210,90).
     - Purple: core (110,70,170), tips (200,160,245).
   - Keep the wisteria drip strands; they are working.
2. **Fix the Raid haze colour and restore the skull as the focal point.** (p3, p5, c2, c3.)
   - Haze particles: Color (230,40,40), LightEmission 0.6, Transparency 0.5-0.7, Size 20-30.
     - Keep them behind and around the facade, not in front of the skull.
     - The target air sample beside the skull is about (190,75,80).
   - Facade back to dark maroon (100,25,30).
   - Skull: dusty rose (225,100,105), with a PointLight (255,90,90), range 20, so it is the lightest thing on the temple.
   - Delete the two white plinths at the door foot (third round in a row).
3. **Islands: lift, push out, slim the waterfalls.** (c3, c4, p1, p6, p2.)
   - Raise the N/NE/NW islands 20-25 studs and push them 30 studs outward, so c3/c4 show sky between them.
   - Towers: 35-50 studs, 2-3 per island, plus one aqueduct span of 3-4 arches.
   - Waterfalls: 2-3 stud streams, (200,235,255), Transparency 0.3, with a mist emitter at the base.
4. **Close the horizon.** (p7, p8, p1, c2.)
   - Hide the visible baseplate in the p7 top corners by extending the building/foliage ring to cover about 200 studs of
     radius.
   - Cluster the far trees in groups of 3-5 with overlapping canopies and no trunks showing.
   - Add grey palace domes and arcades behind the S/E (c2 right, p2 upper left).
   - Atmosphere: Density 0.3-0.35, Color (190,215,235).
5. **Story tree, portal and W arena.** (p4, p6, p8.)
   - Trunk: rotate or shorten it so it does not lie across p8. It should be upright and thick (8-10 studs at the base) with
     gnarled roots.
   - Canopy: grow it to a dense dome about 60 studs wide that fills the p4 top edge, with hanging blue moss.
   - Portal: carved silver-blue frame (150,170,205) around a dark opening (15,20,40). Drop the graphic spiral.
   - Ring it with a stepped round white-stone arena about 40 studs across.
6. **Bollards and medallion; they are in the foreground of every spawn camera.** (p1-p6.)
   - Bollards: cut the height by 35%, use a grey stone body (150,155,160), and add a pointed stepped gold cap.
   - Medallion: 8 thin hooked dark blades (45,55,65) with a gold hub, and a ring of 8 gold studs at the rim.
7. **Arch wings and crystal pods.** (c1, c2, c3, p5.)
   - Wing flank faces: dark slate (50,62,72) with 2 recessed bands and a gold rim on top.
   - The wing should drop toward the plaza, not rise as a long pale ramp.
   - Add 2 faceted crystal pods per arch beside the pavilions: Glass/Neon (40,110,230), about 4x6 studs, with a PointLight
     of range 12.
8. **Ground litter.** (p7, p8, c1.)
   - Red zone: replace the round red ovals with ragged leaf-splat decals or meshes, 3-6 studs each.
     - Merge them into continuous patches covering about 60% near Raid, falling to 30% by the plaza.
     - Leave green grass holes.
   - c1 splats: swap them so blue is on the Summon (N/left) side and red on the Raid (E/right) side.
   - Use soft fringed splat cards, not low-poly starbursts.
9. **N avenue dressing.** (c4, p1, p5.)
   - Gold pineapple about 8 studs tall by the W pavilion.
   - Blue cypress pair at the avenue mouth, 5x16 studs, soft leaf-clump style (not shards).
   - Blue hedge masses on the stair-top flanks, about 10x3 studs.
   - Bunting between the lamp posts.
   - Summon: add a column arcade and a gold statue in the centre arch, and warm the facade to cream/gold (235,210,150).
10. **S side.** (p2, p6.)
    - Shard ring to grey stone (150,155,160).
    - Expeditions gate: scale it 1.2x, give it a turquoise cloudy door, and add a crystal fountain either side.
    - Add a big green palm (about 30 studs) upper right of the gate.
    - Add an orange tree (240,150,60) behind the Expeditions fountain.
    - Add grass tufts on the S stairs.
