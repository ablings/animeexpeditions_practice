# Verify round 14: Anime Expeditions spawn plaza (freestyle, after fix pass 16)

Scored against the **live reference** on the Shadow PC on 2026-10-10 by an independent reviewer who had not seen the build
before. Round 13 (`verify13_plaza.md`) was read for context only; every score below is fresh.

## Method
- **Reference:** studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- **Practice:** studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only. No code was run in Studio; nothing was modified or saved in either studio.
- **Captures:** `v14_<cam>_ref_a` / `v14_<cam>_ref` and `v14_<cam>_rep_a` / `v14_<cam>_rep`, all 1452x793.
  - Pixels changing by more than 30 levels within a pair: at most 4.0% in the reference (animated water/VFX/crowd) and at
    most 1.6% in the practice (fountain mist, p3 haze). The second frame was judged; no third frame was needed.
- **Files:** `out/verify14/v14_<cam>_ref.jpg` and `v14_<cam>_rep.jpg`, with the `_a` frames alongside.
- **Colours:** "sampled" RGB is a 5x5 average from those JPEGs. Other colours and all stud sizes are estimates.

## Overall read
Pass 16 landed its two biggest jobs. **The Raid now reads red from every camera**, and **the north skyline is lush again**:
green-topped islands with trees and towers fill the upper third of c4, p1 and c3 the way the reference does. The W quarter
is no longer an open lawn. Stair grass now exists on the S and W stairs.

What is left:
- **Raid surface:** it is red the wrong way. The whole facade is one flat salmon value, sampled (170,52,60) on lit faces.
  It reads as red plastic, not as dark stone lit red. The reference stone stays dark (90-94,43-48,52-65) and the red sits
  in the haze, the rims and the doorway.
- **Wing flanks:** now the largest single geometry mismatch. They show in 8 of 12 cameras. Practice sampled
  (139,156,164), pale; reference (52,61,64), dark slate.
- **Summon:** still a gold pediment behind clumps, with no facade.
- **E ground:** still grey with polka dots.
- **S side:** shard ring, gate, palms and beach.
- **Grass style:** spiky dark-green blades, where the reference has soft, light lawn tufts.

## Per camera (round 13 -> round 14)

### p1_spawn_n: 8 -> 8
- **Gains:**
  - The upper third is now green-topped islands with trees, towers and hanging vines. The "too thin" skyline from round 13
    is fixed.
  - New bollards and an 8-blade medallion with gold rim studs.
- **Geometry:**
  - **Bollards:** about 1.5x too tall. The practice is a grey stone pillar about 3 studs tall with a faceted gold cap. The
    reference is a low white square base (sampled (228,229,222)) with a squat rounded gold head (sampled (138,122,29) in
    shadow) and a dark band. The practice cap is sampled (199,189,43), a little lemon.
  - **Medallion:** reads correctly now. The practice rim studs are domed beads and stand out; the reference studs are flat
    discs set into the rim.
  - **Summon:** still only a gold pediment between the gold clumps. The reference shows the arcaded facade with "Summon"
    and a statue.
  - **Wings:** pale slab ramps rising outward. The reference wings are dark slate scrolls curving down to the fountain.
- **Colour:** blue and gold fine. The practice blue trees at both top corners are heavier and taller than the reference's
  small blue trees.
- **Missing:** crowd, stalls and bunting on the avenue; the Guilds facade (the practice cream building is close).

### p2_spawn_s: 7 -> 7
- **Gains:** tall grass tufts on the stair treads (about 12 clumps). An island with a tower sits at upper right.
- **Geometry:**
  - **Shard ring:** navy segments round a white oval, floating high in the sky. The reference ring is grey rock shards
    round a white glow, and it reads as part of the skyline.
  - **Gate:** about 70% of the reference width, with a cyan spiral and a white statue. The reference has a turquoise
    cloudy door, crystal fountains either side and bloom.
  - **Blue trees:** the trees at both top corners are about 2x the reference mass and crowd the frame.
- **Colour:** the grass is dark spiky blades (64,137,45). The reference stair-top grass is a lighter, soft lawn edge
  (156,200,90).
- **Missing:** the big green palm at upper right (about 30 studs), the tree on a rock pillar at upper left, and the stair-top
  lawn strip.

### p3_spawn_e: 8 -> 8
- **Gains:**
  - The Raid is unmistakably red now. Red haze sits behind the tower, the door glows red, and a red Neon arch strip outlines
    the door.
  - Dead black trees flank the temple, and a Boss Rush portal shows at left.
  - Red splats on the stairs.
- **Colour and lighting:**
  - Every facade face is the same bright salmon (170,52,60). It looks like painted plastic. The reference stone is dark
    (94,43,52) with red light on the edges, the haze and the door only.
  - The haze is still mauve-pink at its edge (146,125,150) where it meets the sky; the reference is red-orange (173,38,36).
  - The skull is (167,55,65), more saturated than the reference (124,78,73), and it shares the facade value, so the
    tower is one red mass.
- **Geometry:**
  - The keystone skull reads small but fine.
  - The upright red palm is hidden behind the right tower. The reference palm stands left of the door, about 25 studs, and
    is one of the frame's main silhouettes.
- **Missing:** the carved arch detail round the door, and the blue-green palms at left.

### p4_spawn_w: 8 -> 8
- **Gains:**
  - The Story trunk now splits into several limbs.
  - Dense blue mass, blue palms and grass round the portal.
  - Grass tufts on the W stairs.
- **Geometry:**
  - **Trunk:** too short. The split happens only about 15 px above the sign, and the canopy caps it. The reference trunk
    is huge and gnarled, with limbs spreading through the upper centre.
  - **Story sign:** a slab hanging on the trunk. The reference has blue lettering arched over the portal ring.
- **Colour:** the grass is spiky and dark, where the reference has soft light-green ground cover.
- **Missing:** the green palms at left, and the Guilds facade at right (the practice has a white building there).

### p5_diag_ne: 8 -> 8
- **Gains:** the right third is now red, with the Raid door glowing red and the Boss Rush portal visible.
- **Geometry:**
  - **Bollard:** the central bollard is the tallest thing in the lower half. The reference bollard is about 60% of that
    height.
  - **Wing:** the slab rises outward as a pale grey ramp. The reference is a dark scroll curving down.
  - **Summon:** a yellow pediment at left. The reference shows the facade, stalls and umbrellas.
- **Colour:** the Raid facade is flat salmon (see p3).
- **Missing:** the large dark-red palm in front of Boss Rush (the reference centre-right silhouette).

### p6_diag_sw: 7 -> 7
- **Gains:**
  - Stair grass.
  - The island with towers sits at upper left-centre, which echoes the reference's ruin island.
  - The Story tree has limbs.
- **Geometry:**
  - The Expeditions gate has a spiral door.
  - The Story sign is tilted and hangs off the trunk.
  - The central bollard is too tall.
- **Missing:** the big green palm at top centre, the orange tree behind the fountain, the overgrown stair-top lawn, and the
  crystal fountains at the gate.

### p7_high: 7 -> 7
- **Gains:**
  - The W lagoon is now in: light-blue pools ringed by blue trees and palms.
  - The north avenue is lined with colourful clumps.
- **Geometry:**
  - **Foreground blue trees:** the two big trees on the S fountains are about 2x the reference size. They hide most of the
    S pavilions. The reference has one green palm at left and a small blue tree at right.
  - **S foreground:** still lawn and a white plinth path. The reference has a sand beach, a big green palm with a pineapple
    and beach rings.
  - **E ground:** a grey disc with round red dots, about 30% cover. The reference is ragged continuous red cover with green
    holes, and the Boss Rush shrine.

### p8_top: 7 -> 7
- **Gains:**
  - The W half is now about 85% covered: blue trees, two lagoon pools, and a round white arena with the Story tree.
- **Geometry:**
  - The arena reads as a flat white disc; the steps do not read from above.
  - The E half is still grey (91,103,99) with dots. The reference is about 60% red (187,53,54), with gravel paths and red
    palms.
  - The S edge has some sand, but no green palms and no beach props.
- **Missing:** dark-water fountain basins (the practice fountains read as bright pools).

### c1_wall: 7 -> 7
- **Gains:** the red Raid at upper right now matches the reference's red read.
- **Geometry:**
  - **Wing flanks:** pale slab ramps (139,156,164) rising outward. The reference is dark slate (52,61,64) with recessed
    bands, curving down.
  - **Fountain:** a translucent box column. The reference has a sculpted water splash.
- **Colour:**
  - The splats are still swapped: red at left, blue/red at right. The reference has blue at left and red at right.
  - The splats are low-poly starbursts. The reference splats are soft fringed leaf splats about 250 px across.
- **Missing:** the big crystal pods beside the pavilions, and the red palm at upper right.

### c2_fountain: 7 -> 7
- **Gains:** the left half now reads red: the Raid tower, the haze, a red tree and the Boss Rush portal. Tall grass now
  shows on the right stairs.
- **Geometry:**
  - The wing is a long pale ramp rising to the right. In the reference it is dark and curved.
  - An island underside hangs in the upper-left corner.
  - The grass blades are about 4-5 studs tall and spiky, about 2x the reference tufts.
- **Missing:**
  - The orange tree and the grey palace domes at right; the practice shows a white box and sky there.
  - The red palm at left.

### c3_pavilion: 8 -> 8
- **Gains:**
  - The upper left now has green islands with trees and towers, as the reference does.
  - The skull tower is in the same place as the reference skull.
- **Geometry:**
  - The falls are hairlines. The reference has two wide glowing falls at upper left.
  - The aqueduct is missing.
- **Colour:** the Raid facade is flat salmon; the haze at right is pink-red over sky.
- **Missing:** the dark-red palm in front of Raid (a major reference silhouette), the Summon statue and arcade, and the gold
  tree mass at far left (the practice has gold clumps there, close).

### c4_stairs: 7 -> 8
- **Gains:**
  - The upper third is now lush islands with trees, towers, vines and falls. It matches the reference's composition.
  - Palms frame both sides.
- **Geometry:**
  - **Summon:** still only a gold pediment. Purple, teal and gold clumps wall off the avenue. The reference sees down an open
    avenue to the Summon facade, with stalls, a crowd and bunting.
  - **Falls:** pale and thin. The reference falls are wider and bright.
  - **Aqueduct:** missing.
- **Colour:** the island grass is bright lime (147,211,109); the reference islands are softer, greyer green.
- **Missing:**
  - The gold pineapple at left.
  - The crowd, the stalls and the bunting.

## Scores
| camera | r13 | r14 |
|---|---|---|
| p1_spawn_n | 8 | 8 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 8 | 8 |
| p4_spawn_w | 8 | 8 |
| p5_diag_ne | 8 | 8 |
| p6_diag_sw | 7 | 7 |
| p7_high | 7 | 7 |
| p8_top | 7 | 7 |
| c1_wall | 7 | 7 |
| c2_fountain | 7 | 7 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 7 | 8 |
| **average** | **7.42** | **7.50** |

p8 and c2 are close to 8. The W coverage in p8 and the red left half in c2 are both real gains, but the E ground and the
pale wing still hold each at 7.

## Top-10 fixes (ranked by visual impact)
1. **Raid: dark stone lit red, not salmon plastic.** (p3, p5, c1, c2, c3.)
   - Set the facade base colour to about (95,45,55), Slate or Brick material, so that faces away from the uplights stay
     dark. Re-aim the SpotLights to graze the edges, pillars and arch rims, peaking near (200,70,65); do not flood whole
     faces.
   - Skull and tower to (125,75,72), so they separate from the facade.
   - Haze tint (200,60,50), and remove the mauve edge. Extend it down to the stair top so it wraps the base.
   - Move the upright dark-red palm in front of and left of the door: about 25 studs tall, fronds (110,25,30) spread
     wide. In p5 it must read centre-right in front of Boss Rush.
   - Carve 3-4 recessed arch bands round the door.
2. **Arch wing flanks.** (c1, c2, c3, p5, p1-p4 at the frame edges.)
   - Recolour to dark slate (52,61,64), with 2 recessed bands and a gold rim on top.
   - Reshape so that each flank curves **down** toward the plaza as a scroll, about 6 studs at the pavilion falling to about
     2 studs at the outer end. At the moment they rise outward as straight ramps.
3. **Summon facade and the avenue.** (c4, p1, p5, c3.)
   - Clear the purple/teal/gold clumps on the avenue axis for about 20 studs either side of centre.
   - Build a 5-arch colonnade facade, about 30 studs wide and 18 tall, colour (235,210,150), with a central dome. Put a gold
     statue in the middle arch and the "Summon" sign over it.
   - Line the avenue with 4-6 stalls, umbrellas and bunting between the lamp posts.
   - Add a gold pineapple, about 8 studs, by the W pavilion at the stair top.
4. **E ground cover.** (p7, p8, p3.)
   - Replace the round red dots with ragged leaf-splat cards 3-6 studs across, merged into continuous patches. Aim for about
     60% cover near Raid, falling to 30% by the plaza, colour (187,53,54) with darker (130,30,35) edges, with green holes.
   - Add 2-3 gravel paths (110,110,105) and 3-4 red palms in the E zone.
5. **S side.** (p2, p6, p7, c2.)
   - Shard ring: grey rock shards (150,155,160), lower and about 1.3x bigger, so they sit in the skyline above the gate
     rather than floating as navy tiles.
   - Expeditions gate: 1.3x, a turquoise cloudy door instead of the spiral, and a crystal fountain either side.
   - A big green palm (about 30 studs) at upper right of the gate.
   - A tree on a rock pillar at upper left.
   - An orange tree (240,150,60) behind the S fountain and in c2 right, plus grey palace domes behind c2 right.
6. **Grass style.** (p2, p4, p6, c2.)
   - Swap the spiky dark blades (64,137,45, about 4-5 studs) for soft clumps about 2 studs tall in (150,200,90), with
     lighter tips.
   - Run a continuous lawn strip 1-1.5 studs tall along every stair-top lip on S and W, with 6-10 clumps spilling down the
     treads.
7. **S beach and foreground.** (p7, p8.)
   - Sand (225,205,150) over the S quarter's front half, about 40x20 studs.
   - One big green palm (about 30 studs) with a gold pineapple at its foot, beach rings, and a towel.
   - Shrink the two S-fountain blue trees to about half their size (about 15 studs tall), so the pavilions show.
8. **Bollards and medallion studs.** (Foreground of every spawn camera.)
   - Bollard to about 60% of its present height: a low white square base (228,229,222), about 3x3x1.5 studs, with a squat
     rounded gold head about 1.5 studs tall, a dark band at its waist, and gold (200,165,60).
   - Medallion rim studs: flat discs set into the rim, not domed beads.
9. **c1 close-up.** (c1, p5.)
   - Swap the splats: blue at left (Summon side), red at right (Raid side). Make them soft fringed leaf splats about 4 studs
     across.
   - Replace the translucent box column with a sculpted water splash (2-3 curved translucent sheets and a mist emitter).
   - Add 2 faceted crystal pods (Glass/Neon (40,110,230), 4x6 studs, PointLight range 12) beside each pavilion.
10. **Story tree and skyline detail.** (p4, p6, c3, c4.)
    - Story trunk: raise the split point by about 10 studs, and push 4-5 limbs up through the canopy so they show in the
      upper centre of p4. Move the sign off the trunk into an arch of blue lettering over the portal ring.
    - Falls 3-4 studs wide, (200,235,255), Transparency 0.3, with a mist emitter at the base.
    - One 4-arch aqueduct between the two north islands in c4.
    - Soften the island grass from (147,211,109) toward (150,175,130).
