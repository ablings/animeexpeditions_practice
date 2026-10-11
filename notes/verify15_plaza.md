# Verify round 15: Anime Expeditions spawn plaza (freestyle, after fix pass 17)

Scored against the **live reference** on the Shadow PC on 2026-10-10 by an independent reviewer who had not seen the build
before. Round 14 (`verify14_plaza.md`) was read for context only; every score below is fresh.

## Method
- **Reference:** studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- **Practice:** studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only. No code was run in Studio; nothing was modified or saved in either studio.
- **Captures:** `v15_<cam>_ref_a` / `v15_<cam>_ref` and `v15_<cam>_rep_a` / `v15_<cam>_rep`, all 1452x793.
  - Pixels changing by more than 30 levels within a pair: 2.0-5.8% in the reference (animated water, VFX, crowd, portals;
    the highest is p8 at 5.8%) and at most 0.6% in the practice (fountain mist). The differences are animation, not
    streaming, so the second frame was judged.
- **Files:** `out/verify15/v15_<cam>_ref.jpg` and `v15_<cam>_rep.jpg`, with the `_a` frames alongside.
- **Colours:** "sampled" RGB is a 5x5 average from those JPEGs. Other colours and all stud sizes are estimates.

## Overall read
Pass 17 landed two of its jobs clearly:
- **Summon and the avenue:** c4 now looks down an open avenue to a cream arcade with a dome, a gold statue, umbrellas and
  bunting. It shows correctly in p1, p5, c1, c3 and p7 as well. This is the biggest gain of the round.
- **The E ground:** p8 now reads blue left and red right from above, with gravel paths and red palms. That is the
  reference's top-down read.

The Raid moved in the right direction but went too far. The facade is no longer salmon plastic, but the upper tower is now
a flat brown-maroon with almost no red light on it (skull sampled (106,70,68)). The reference upper Raid glows: skull
(181,106,89), haze (168,74,28) round it, red fire all along the base. The haze is now red (sampled (198,79,61)), but it is
a soft round cloud behind the tower, not a glow that wraps the building.

**The wing flanks are still the main geometry mismatch.** The new flanks fall toward the plaza (the direction is now
right) and their sides are dark slate. But their top faces are pale (sampled (190,203,201) in c1), so from every
player-height camera they read as two pale playground slides either side of each pavilion. They are in 9 of 12 frames.
The reference has no separate ramps. The pavilion arch itself is the dark mass: a thick grey-slate horseshoe with
recessed bands (c2 sampled (53,64,79)), whose outer bands sweep down into the stair balustrade.

Unchanged from round 14:
- the tall pointed bollards and domed medallion studs;
- the oversized blue trees at the frame corners;
- the spiky dark grass;
- the S side: shard ring, gate, beach;
- the box-column fountains.

## Per camera (round 14 -> round 15)

### p1_spawn_n: 8 -> 8
- **Gains:**
  - The avenue end is now a cream arcade with dome, arches and bunting, with umbrellas and stalls in front. It is in the
    right place and at the right size relative to the stairs.
- **Geometry:**
  - **Wing flanks:** a pale slide on each side of both pavilions (x 50-140 and 460-550, and the mirror on the right). The
    reference shows only the dark arch with gold rim.
  - **Bollards:** still about 1.5x tall, with faceted pointed gold caps. The reference has a squat rounded gold head on a
    low white base.
  - **Medallion studs:** still domed beads. The reference has flat discs.
  - **Gold clumps:** they wrap the Summon roof and block the view through. The reference sees past Summon to the falls
    and islands.
- **Colour:** the blue trees at the top corners are about 2x the reference mass.
- **Missing:**
  - The falls and the aqueduct in the skyline.
  - The crowd.
  - The "Guilds" facade at left (the practice building there is close).

### p2_spawn_s: 7 -> 7
- **Gains:** none visible since round 14.
- **Geometry:**
  - **Shard ring:** navy tiles round a white oval, floating high and isolated in clear sky. The reference has grey rock
    shards set into a cloudy, rocky skyline.
  - **Gate:** about 70% of the reference width. It has a cyan spiral and a white statue; the reference has a turquoise
    cloudy door with crystal fountains either side.
  - **Wing flanks:** pale slides again.
- **Colour:** the stair grass is tall, spiky and dark. The reference stair-top grass is a soft, light lawn strip.
- **Missing:**
  - The big green palm at upper right.
  - The tree on a rock pillar at upper left.
  - The stair-top lawn.
  - The two blue trees at the corners are still about 2x too big.

### p3_spawn_e: 8 -> 8
- **Gains:**
  - The facade is dark now, with a pointed red-rimmed door that glows red inside.
  - The skull and tower separate from the lower facade.
  - The haze is red, not mauve.
  - Red palms flank the door; the Boss Rush portal is at left.
- **Colour and lighting:**
  - The upper tower and skull are dead brown, sampled (106,70,68) and (37,25,33) at the top. The reference skull is lit
    (181-204,100-106,82-89) and glows.
  - The lower facade by the door is a pink-mauve (173,75,91). The reference lower facade is dark (58-89,33-43,46-55),
    with hot red only at the rims and the door.
  - So the value pattern is inverted: the practice is light low and dark high, where the reference is dark low and lit
    high.
  - The haze is a round cloud behind the tower. It does not reach the stair top or wrap the sides.
- **Geometry:**
  - The red palm is short (about 12 studs) and sits behind the door line. The reference palm, left of the door, rises to
    skull height (about 25 studs) and is the frame's main dark silhouette.
  - The stair splats are pale pink and sparse. The reference has dense red (190,50,50).
- **Missing:**
  - The red fire VFX along the base.
  - The blue-green palm and dark rock mass at left.

### p4_spawn_w: 8 -> 8
- **Gains:** none visible since round 14.
- **Geometry:**
  - **Story trunk:** short. The canopy caps it just above the sign. The reference trunk is huge and gnarled, with limbs
    through the upper centre and a blue swirl in the portal.
  - **Story sign:** hangs on the trunk with drips. The reference has blue lettering arched over the ring.
- **Colour:** the grass is spiky and dark.
- **Missing:**
  - The portal interior; practice shows a flat black disc. The reference has an animated blue swirl.
  - The green palms at left.

### p5_diag_ne: 8 -> 8
- **Gains:**
  - At left, the Summon arcade with a gold statue, bunting and umbrellas matches the reference's Summon placement.
  - At right, the Raid door glows red, and the Boss Rush portal is visible.
- **Geometry:**
  - **Wing flanks:** two pale slides flank the fountain arch, the most visible object in the middle third. The reference
    arch is a single dark-grey horseshoe with gold trim.
  - **Bollard:** the biggest object in the lower half. The reference bollard is about 60% of that height, with a rounded
    head.
  - **Red palm:** small. The reference has a big dark-red palm at x≈980 rising above the Raid roof.
- **Colour:** the Raid lower facade reads purple-maroon (99,29,43). The reference stone is darker (45,32,45), with bright
  red-lit arches.
- **Missing:** the dense red splats on the E stairs.

### p6_diag_sw: 7 -> 7
- **Gains:** none visible since round 14. Stair grass, the island and the Story ring are as before.
- **Geometry:**
  - **Wing flanks:** the pale slides are the central object of the frame, right behind the bollard. This is the worst
    camera for them.
  - **Expeditions gate:** spiral door. The reference has a cloudy turquoise door.
  - **Story sign:** tilted on the trunk.
- **Colour:** the blue tree above the pavilion is about 2x the reference.
- **Missing:**
  - The big green palm at top centre.
  - The orange tree behind the fountain.
  - The soft stair-top lawn.
  - The crystal fountains at the gate.

### p7_high: 7 -> 7
- **Gains:**
  - The Summon arcade and bunting now close the avenue.
  - The E zone has red leaf splats, black trees and red palms.
- **Geometry:**
  - **E ground:** the splats are separate heart-shaped cards on grey. The reference is continuous ragged red cover with
    green holes and grass, and the gravel shows only in paths.
  - **Wing flanks:** they read from above as four grey boulders on the plaza corners.
  - **S foreground:** still lawn and a white plinth path. The reference has a sand beach, a big green palm with a
    pineapple, a swim ring and a life ring.
  - **Blue trees:** the two on the S fountains are about 2x the reference size and hide the S pavilions.
- **Colour:** the fountain basins are bright, light-blue pools. The reference basins are dark teal.

### p8_top: 7 -> 8
- **Gains:**
  - The E half reads red with gravel paths and red palms (splat sampled (217,63,69); reference (189,54,52)).
  - The overall top-down read now matches: blue W, red E, cross-shaped plaza in the middle.
- **Geometry:**
  - **E cover:** about 45% red as discrete cards. The reference is about 60%, merged, with green holes. The practice red is
    slightly pinker and more saturated.
  - **Wing flanks:** grey blocks at each corner; they do not read as part of the arch.
  - **S edge:** sand patches, but no palms or beach props.
- **Colour:** the four fountain basins read bright light-blue. The reference basins are dark teal with blue trees inside.

### c1_wall: 7 -> 7
- **Gains:**
  - The Summon arcade with its statue at left.
  - The dark Raid with its red-glow door at right.
- **Geometry:**
  - **Wing flanks:** the frame is dominated by two pale slide tops (190,203,201) with dark slate sides, falling toward the
    camera. The reference has the arch's own thick grey bands (171,172,164 on the lit top, darker in the grooves) curving
    down into a gold-trimmed step. It has no separate pale ramps and no black plinth blocks.
  - **Fountain:** still a translucent box column. The reference has a sculpted water splash.
- **Colour:**
  - The splats are red and pink at left and blue/red at right. The reference has blue at left (Summon side) and red at
    right (Raid side), as soft fringed leaf splats about 4 studs across.
- **Missing:**
  - The crystal pods beside the pavilion domes.
  - The tall dark-red palm at upper right.

### c2_fountain: 7 -> 7
- **Gains:** a red-palm cluster and the Boss Rush portal at left, and red haze behind the Raid tower.
- **Geometry:**
  - **Wing flanks:** two pale slides with dark sides run through the middle. The reference arch is one dark slate
    horseshoe (53,64,79) with grooved bands, sweeping right into the stair rail.
  - **Right side:** a long pale grey slab wall at mid-right. The reference has the dark pavilion base there.
  - **Grass:** blades about 4-5 studs tall and spiky.
- **Missing:**
  - The orange tree and the grey palace domes at right; the practice has a white blob and sky there.
  - The upper Raid glow.

### c3_pavilion: 8 -> 8
- **Gains:**
  - The Summon arcade with bunting and statue at left.
  - The skull tower in the same place as the reference, with a red haze band behind it.
- **Geometry:**
  - **Wing flanks:** pale slides either side of the arch, plus the gold bollard tip in the foreground.
  - **Red palm:** the reference has a dark-red palm against the sky between the pavilion and the Raid (x≈980, top at
    y≈270). The practice palm is small and sits in front of the Raid wall.
  - **Skyline:** the island towers are plain grey boxes. The reference has ruined arcades, domes, two wide glowing falls
    and an aqueduct.
- **Colour:** the Raid is brown and unlit (69,20,27 in the door surround). The reference Raid is a lit red (169,70,71 on
  the skull, 197,125,125 on the arch).

### c4_stairs: 8 -> 8
- **Gains:**
  - This is now the strongest camera. It looks down an open avenue to the Summon arcade, past umbrellas and stalls, under
    bunting, framed by blue palms and gold, purple and teal trees. That is the reference composition.
  - There is a pineapple at left.
- **Geometry:**
  - **Pineapple:** reads as a gold pot with green flat leaves (202,166,4). The reference pineapple is a large textured gold
    fruit (136,94,24 in shade), about 8 studs, with a spiky crown.
  - **Summon:** about 70% of the reference width in frame.
  - **Skyline:** island towers are boxy. The reference has an aqueduct arcade at top centre and wide bright falls.
- **Missing:**
  - The tall lamp posts along the avenue.
  - The crowd.
  - The two tall blue cypress trees framing the steps.

## Scores
| camera | r14 | r15 |
|---|---|---|
| p1_spawn_n | 8 | 8 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 8 | 8 |
| p4_spawn_w | 8 | 8 |
| p5_diag_ne | 8 | 8 |
| p6_diag_sw | 7 | 7 |
| p7_high | 7 | 7 |
| p8_top | 7 | 8 |
| c1_wall | 7 | 7 |
| c2_fountain | 7 | 7 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 8 | 8 |
| **average** | **7.50** | **7.58** |

- **Close to 9:** c4 and p1.
- **Close to 8:** c1, c2 and p6. All three are held at 7 almost entirely by the pale wing slides.

## Top-10 fixes (ranked by visual impact)
1. **Wing flanks: kill the pale slides.** (p1, p2, p3, p4, p5, p6, c1, c2, c3, and the corners in p7/p8.)
   - Recolour the top faces to the side colour, dark slate (55,65,75), with a 0.4-stud gold (200,165,60) rim only on the
     outer edge.
   - Merge each flank into the arch. Thicken the horseshoe's outer band to about 3 studs, cut 2 recessed grooves along it
     (each about 0.5 studs deep, (40,48,58)), and sweep it down and outward until it meets the stair balustrade about 8
     studs from the pavilion.
   - Delete the black plinth blocks under the slide ends.
   - Test in p6 and c1: no pale surface should remain between the dome pavilions and the plaza floor.
2. **Raid: light the top, darken the bottom.** (p3, p5, c2, c3.)
   - **Lower facade by the door:** from pink-mauve (173,75,91) down to (70,35,45).
   - **Skull and upper tower:** keep the dark base (100,60,58), but add 2-3 red SpotLights (255,80,60), brightness 3-5,
     range 40, aimed up the skull and tower from the roof line. Aim for lit faces of about (180,100,90) and glowing eyes.
   - **Haze:** spread it into 3-4 overlapping emitters along the whole facade, from the stair top (y≈3) up to the skull,
     tint (200,70,40). It should wrap both towers, not sit as one disc behind them.
   - **Fire:** add a line of low red fire/ember emitters along the base, about 1.5 studs tall, across the full facade width.
3. **Big red palm in front of the Raid.** (p3, p5, c1, c3.)
   - Scale the left-of-door palm to about 25 studs tall, with the crown at skull height.
   - Move it about 6 studs toward the plaza, so it stands in front of the facade line and breaks the sky in c3 at
     x≈980 px.
   - Fronds (90,25,30), 8-10 of them, each about 8 studs long, drooping.
4. **E ground: merge the splats.** (p7, p8, p3.)
   - Scale each leaf card up 1.5x and overlap them, so the gravel shows only on the paths and in a few gaps. Aim for about
     60% cover near the Raid, falling to 30% by the plaza.
   - Desaturate to (185,55,55), with (130,30,35) edge cards.
   - Add 10-15 green grass holes (120,170,80), each 2-4 studs.
   - Thicken the red splats on the E stair treads to about 50% cover.
5. **S side.** (p2, p6, p7.)
   - **Shard ring:** recolour to grey rock (150,155,160), drop it about 15 studs, and scale it 1.3x.
   - **Expeditions gate:** scale it 1.3x and swap the spiral for a turquoise cloudy door (Neon/Glass (60,190,190) with a
     cloud texture). Put a crystal fountain either side.
   - **Palm:** add a 30-stud green palm at upper right of the gate.
   - **Pillar tree:** add a tree on a rock pillar at upper left.
6. **Corner blue trees to half size.** (p1, p2, p4, p6, p7, c3.)
   - Scale the blue trees at the frame corners, and the two on the S fountains, to about 0.5x (about 15 studs tall), so
     the domes, sky and S pavilions read.
   - Add 2 tall slim blue cypress trees (about 14 studs) framing the N stair top for c4.
7. **Grass style and lawn edge.** (p2, p4, p6, c2.)
   - Replace the spiky blades with soft clumps about 1.5-2 studs tall in (150,200,90), with lighter tips.
   - Run a continuous 1-stud lawn strip along every S and W stair-top lip, with 6-10 clumps spilling down the treads.
8. **Bollards and medallion studs.** (Every spawn camera, c3.)
   - Bollard to about 60% of its present height: a white square base (228,229,222) about 3x3x1.5 studs, a squat rounded
     gold head (200,165,60) about 1.5 studs tall with a dark band, and no pointed cap.
   - Medallion rim studs: flat discs flush with the rim.
9. **Skyline detail.** (p1, c3, c4.)
   - Two wide falls: 4 studs wide, (200,235,255), Transparency 0.3, with mist at the base.
   - A 4-arch aqueduct between the two N islands.
   - Replace the plain box towers with ruined arcade towers (open arches, broken tops).
   - Trim the gold clumps round Summon by about 30%, so the falls show above its roof in p1.
10. **Close-up props.** (c1, c4, p7, p8.)
    - **c1 splats:** blue at left, red at right.
    - **Fountain column:** replace the box with a sculpted splash (2-3 curved translucent sheets plus mist).
    - **Basins:** recolour to dark teal (40,110,120).
    - **Pineapple:** make it a real pineapple. A textured gold body (200,150,40), about 6 studs, with a diamond pattern and
      a spiky crown of 8-10 narrow leaves, in place of the pot.
    - **S beach:** sand (225,205,150), about 40x20 studs, with a big green palm, a swim ring and a life ring.
