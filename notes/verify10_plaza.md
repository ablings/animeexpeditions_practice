# Verify round 10: Anime Expeditions spawn plaza (freestyle, after fix pass 12)

Scored against the **live reference** on the Shadow PC, 2026-10-10, by an independent reviewer who had not seen the build
before. I read the round 9 notes for context only; the scores below are fresh.

## Method
- Reference studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- Practice studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- `screen_capture` only. No code was run. Nothing was modified or saved in either studio.
- Captures: `v10_<cam>_ref_a` / `v10_<cam>_ref` and `v10_<cam>_rep_a` / `v10_<cam>_rep`. Within each pair, at most 3.2% of
  pixels differ (reference, from animated water, VFX and leaves) and at most 1.4% (practice). So I judged the second frame and
  did not need a third.
- Judged frames: `out/verify10/v10_<cam>_ref.jpg` and `v10_<cam>_rep.jpg`, 1452x793. Both frames of each pair are kept.
- "Sampled" RGB means a 5x5 average from those JPEGs. All other colours and every stud size are estimates from the pictures.

## Overall read
Pass 12 closed two of the round-9 big five. **The Raid values are now right**: dark maroon facade (sampled (114,27,35)),
dusty-rose skull (225,100,105) as the lightest thing on the temple, dark red palms at the door. **The red litter now reads as
speckle on grey gravel** in p7/p8 instead of flat blobs. The horizon is no longer empty baseplate, and the N avenue has cypress
cones, stalls and umbrellas. The islands are now grey-green rock with grass caps, vines, towers and waterfalls.

**The sky is no longer the gap.** The reference upper sky in c3 samples (83,198,242) and the practice sky (139,205,234), so the
practice sky is now a little paler and hazier than the reference. What still separates the two moods is **local glow and
aerial perspective**: the reference Raid sits in red haze (air beside the skull (159,113,99); practice clear sky
(73,199,239)), and the reference crystals, pavilion interiors and Summon have bloom and light shafts. The practice frames
still look like flat, crisp, untextured Roblox parts.

The biggest remaining gap is **foliage style and density**. Every practice tree is either low-poly crystal shards (blue
trees by the arches) or smooth spheres (the horizon trees, the Story canopy). The reference foliage is soft, fluffy leaf-card
clumps packed to the frame edges.

## Per camera (round 9 -> round 10)

### p1_spawn_n: 7 -> 7
- **Gains:** islands are grey-green with grass caps and towers. The avenue now shows cypress, red/blue umbrellas and gold and
  purple trees around Summon.
- **Geometry:**
  - The island still hangs from the top edge (underside to y≈90 px of 793). The reference islands sit behind a far skyline,
    with undersides at y≈40-150 and towers and an aqueduct on top.
  - Bollards are still tall white plinths (about 70 px) with a smooth gold dome. The reference bollards are squat stone with
    a pointed gold cap.
  - The medallion is still 5 broad swirls. The reference has 8 thin hooked blades.
- **Colour:** fine; Summon gold is close.
- **Missing:** the gold tree mass (reference: about 300 px wide behind Summon), the purple wisteria mass right of Summon,
  crystal pods on the arch tops, the Guilds facade at upper left, and the dense crowd and stalls. Practice reads sparse.

### p2_spawn_s: 7 -> 7
- **Geometry:**
  - The shard ring hangs at centre y≈130 of the composite and is navy shards around a white oval. The reference ring is grey
    stone shards and sits behind the green palm.
  - The gate is about 150 px wide. The reference gate is about 220 px wide with a crystal fountain either side.
- **Colour:** a red tree at far left. The reference has blue trees only on this side.
- **Missing:** the green palm at upper right, the tree on a rock pillar at centre-left, the domed palaces at upper left, the
  bloom on the Expeditions gate.

### p3_spawn_e: 8 -> 8
- **Gains:** values are now correct. The temple is dark, the skull is the lit focal point, dark red palms frame the door, and
  the Boss Rush swirl sits at the left.
- **Geometry:**
  - The skull tower is a plain stacked block about 120 px tall rising straight out of the facade. The reference skull is
    carved, sits in a recessed frame with spires either side, and the temple is wider with an arcade.
  - Known flaw confirmed: two small white plinths at the door foot. They are the brightest thing in the lower half of the
    Raid; remove them.
- **Lighting:** no red haze. The reference temple is wrapped in red bloom and smoke. Any smoke added in pass 12 is not visible
  from here.
- **Missing:** dead-tree silhouettes against the facade (only a few in practice), the red glow on the steps.

### p4_spawn_w: 7 -> 7
- **Geometry:**
  - The Story canopy is still smooth blue discs with drip vines (lollipop read). The reference is a huge dense blue leaf canopy
    filling the top 250 px.
  - The portal is still a navy-and-white graphic spiral in a gold ring. The reference is a carved silver-blue frame around a
    black opening.
- **Missing:** the gold Guild facade at upper right (practice shows white buildings), blue cypress/palms around the portal,
  crystal pods.

### p5_diag_ne: 7 -> 7
- **Gains:** Raid is now dark maroon with a pale skull, the red palm is in front, and the Boss Rush swirl is visible.
- **Geometry:** Summon is a plain yellow facade with arched holes. The reference is cream/gold with columns, a gold statue at
  the door, and stalls in front.
- **Missing:** the purple wisteria mass behind the arch (reference about 250x200 px), the blue pom tree over the arch, bloom,
  and the two white plinths again (visible at the Raid door).

### p6_diag_sw: 7 -> 7
- **Geometry:**
  - The island underside fills the top centre (y 0-160). The reference has open sky with a big green palm, a ruin tower and the
    grey shard ring.
  - The waterfalls read as translucent white glass panels hanging from the island, not water.
- **Missing:** the green palm, the orange tree behind the Expeditions fountain, lanterns, and the Story portal's dark opening.

### p7_high: 6 -> 7
- **Gains (large):**
  - Horizon filled with tree rings and buildings.
  - Red litter now speckled over dark grey gravel, with black dead trees.
  - White terraces at the E/W arm ends.
  - Cypress and stalls on the N avenue.
- **Geometry:**
  - The horizon trees are evenly spaced pastel lollipops (yellow, purple, blue, sage), which reads toy-like. The reference
    background is buildings and dense foliage with no visible gaps.
  - The W lagoon is out of frame or too small. The reference left third is blue water ringed by blue foliage and palms.
  - The E/W terraces are plain white boxes. The reference terraces are carved white stone.
- **Colour:** lawn sampled (145,181,88), now too pale and uniform against reference grass (102,152,33) with darker tufts.
  Red litter coverage on the E zone is now plausible, but the reference red is denser near Raid (about 60%) and has green
  grass patches mixed in.
- **Missing:** the big green palm and pineapple bottom-left, the beach props (rings, umbrellas).

### p8_top: 6 -> 7
- **Gains:** the E zone reads like the reference from above: grey gravel, red speckle, dead trees, Raid at the E edge.
- **Geometry:**
  - The Story tree still crosses the W half as a long tan bar with blue spheres. The reference W is a ring of blue foliage
    around a stepped round arena.
  - Large open flat lawn in the W/SW. The reference is fully covered with foliage, sand paths and white paving.
  - The E terrace is a bare white box.
- **Missing:** the sand beach and palms at the S corners, the W arena.

### c1_wall: 7 -> 7
- **Gains:** behind the arch, the dark Raid spires, the dark red palm and the pale skull now read correctly.
- **Geometry:** the wing flank is still a plain pale slab with no carved bands. The reference is darker, with recessed bands
  and a gold rim. Foreground leaf cards are crisp starbursts; the reference uses soft leaf clusters.
- **Missing:** blue crystal pods beside the pavilions (reference: 2, each about 60x110 px), glowing pavilion interiors, the
  Summon arcade detail, the purple wisteria at left.

### c2_fountain: 7 -> 7
- **Gains:** the background Raid now has a dark facade and spires, plus a pale skull, and Boss Rush with dead trees and red
  palms in front.
- **Geometry:** the arch side wing is still a long pale wall rising to the right. The reference wing stays low and dark, with a
  gold rim.
- **Missing:** the orange tree and the grey palace domes and arcades at right (practice shows sky and a cloud), the red haze
  around Raid.

### c3_pavilion: 7 -> 8
- **Gains:**
  - The islands now read as grey-green rock with grass caps, vines, short towers and waterfalls.
  - Raid has a dark facade and a light skull with red eyes and the beam.
  - Summon is visible with purple trees.
- **Geometry:**
  - Island towers are about 50-60 px tall. The reference towers and aqueduct arches are 150-200 px tall, with round green
    trees on every island.
  - The waterfalls are flat translucent white slabs, wider than the reference streams.
- **Lighting:** red haze is missing (reference air beside skull (159,113,99), practice open sky).
- **Missing:** the gold tree mass at left, the dark red palm directly in front of Raid's left side (practice has a smaller one),
  the lit crystal pods.

### c4_stairs: 7 -> 7
- **Gains:**
  - Blue cypress cones, umbrellas and stalls on the avenue.
  - Gold and purple tree masses.
  - Twin blue palms framing Summon, and white towers.
- **Geometry:**
  - The islands are still low and close (undersides y≈0-200, three islands crowd the top third). The reference islands are high
    and far (y≈100-260 of a deeper view), with towers, aqueduct and waterfalls.
  - Summon is about 220 px wide and reads as a simple pediment box. The reference facade is a grand arcade with glow.
- **Missing:** the gold pineapple at left (reference about 120 px), the big blue cypress pair flanking the avenue (practice
  cones are small), bunting and flags, crowd and stall clutter, glowing pavilion crystals.

## Scores
| camera | r9 | r10 |
|---|---|---|
| p1_spawn_n | 7 | 7 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 8 | 8 |
| p4_spawn_w | 7 | 7 |
| p5_diag_ne | 7 | 7 |
| p6_diag_sw | 7 | 7 |
| p7_high | 6 | 7 |
| p8_top | 6 | 7 |
| c1_wall | 7 | 7 |
| c2_fountain | 7 | 7 |
| c3_pavilion | 7 | 8 |
| c4_stairs | 7 | 7 |
| **average** | **6.92** | **7.17** |

## Top-10 fixes (ranked by visual impact)
1. **Change the foliage style from crystal shards and spheres to soft leaf-card clumps.** (All cameras.)
   - Replace every faceted blue "crystal" tree and every smooth sphere tree with clumps of 20-40 overlapping, slightly drooping
     leaf cards (each 3-5 studs). Use 2 tones per clump: blue (30,80,220)/(70,140,255), purple (150,110,220)/(190,150,240),
     gold (220,170,40)/(250,210,90), green (90,160,60)/(130,190,70).
   - Horizon trees: break the even spacing and cluster them in 3-5s. Tint the far ring about 20% toward the sky colour
     (170,210,235) so it recedes.
2. **Add local glow and haze; the sky itself is done.** (p3, p5, c1, c2, c3, c4, p1.)
   - Raid: make the smoke visible from 90 studs. Use a ParticleEmitter, Color (255,70,70), Size 25-40, Transparency 0.6,
     Rate 8, Lifetime 6, LightEmission 0.5, at the skull and spread across the facade. Add 3-4 PointLights (255,50,50),
     range 50, brightness 3.
   - Crystals and pavilion interiors: Neon (60,150,255) cores with PointLights (80,170,255), range 12.
   - Atmosphere: raise Density so objects 200+ studs away fade toward (190,215,235).
3. **Pack the N avenue and the arch flanks with foliage and clutter.** (p1, p5, c4, c1.)
   - Gold tree mass behind Summon: 3-4 big clumps 20-25 studs tall, about 50 studs wide in total.
   - Purple wisteria mass right of Summon and behind the NE arch: about 40x25 studs of hanging purple clumps.
   - Gold pineapple about 8 studs tall by the W pavilion.
   - Scale the blue cypress cones up to 5x16 studs as a pair flanking the avenue.
   - Bunting between the lamp posts.
4. **Rework the islands' top dressing and waterfalls.** (c3, c4, p1, p6.)
   - Waterfalls: replace the wide white glass slabs with streams 2-3 studs wide, white-blue (200,235,255), Transparency 0.3,
     with a mist emitter at the base.
   - Towers: 2-3 per island, 35-50 studs tall (about 3x the current height), plus one aqueduct span (3-4 arches) between the N
     pair.
   - Tops: 4-6 round green leaf-card trees per island.
   - Lift the N/NE/NW islands another 15-20 studs and push them 20-30 studs further out, so c4 shows sky between the islands
     and the pavilion domes.
5. **Story tree and portal.** (p4, p6, p8.)
   - Canopy: replace the blue discs with 8-10 drooping blue leaf-card clumps filling a dome about 50 studs wide.
   - Shorten or reorient the trunk so it does not lie across the p8 frame; keep the total height to about 70 studs.
   - Portal: carved silver-blue frame (150,170,205) around a dark opening (15,20,40), with a faint Neon blue swirl
     (40,110,255, Transparency 0.5).
   - Ring the tree with a stepped round white-stone arena about 40 studs across.
6. **Raid finishing.** (p3, p5, c3, c2.)
   - Delete the two white plinths at the Raid door foot.
   - Carve the skull tower: frame it with 2 flanking spires 8-10 studs taller than the skull, and narrow the stacked block below
     the skull by about 30%.
   - Add 4-6 more black dead trees across the facade foot, and a red glow strip (Neon (200,40,40)) on the 3 bottom steps.
7. **Lawn, lagoon and terraces.** (p7, p8.)
   - Lawn base to (100,150,40), with darker tuft patches (70,120,30) and lighter sand paths (220,200,150).
   - Cover about 50% of the open W/SW lawn with foliage clumps and bushes.
   - Make the W lagoon visible in p7: about 60x40 studs of water (60,150,210) ringed by blue foliage and 3-4 palms.
   - E/W terraces: add a balustrade, 2 plinths with crystals, and a 1-stud gold rim, so they read carved rather than boxed.
8. **Arch wings and crystal pods.** (c1, c2, c3, p1, p5.)
   - Wing flank faces to dark slate (50,62,72) with 2 recessed bands and a gold rim on top.
   - Add 2 big faceted crystal pods (Glass/Neon (40,110,230), about 4x6 studs, PointLight range 12) per arch, on the wall top
     beside the pavilions.
9. **Medallion and bollards.** (p1-p6.)
   - Medallion: 8 thin hooked dark blades (45,55,65), each about 1 stud wide at the root, tapering to a hook. Add a gold hub
     and a ring of 8 gold studs.
   - Bollards: cut the height by about 35%, use a square stone body (150,155,160) and a pointed stepped gold cap. They should
     not be pure white.
10. **S side.** (p2, p6.)
    - Remove the red tree at the SW (p2 left).
    - Scale the Expeditions gate 1.4x and add a crystal fountain either side.
    - Shard ring: grey stone (150,155,160).
    - Add a big green palm upper right of the gate, an orange tree behind the Expeditions fountain, and a tree on a rock
      pillar at centre-left.
