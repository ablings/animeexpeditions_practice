# Verify round 16: Anime Expeditions spawn plaza (freestyle, after fix pass 18)

Scored against the **live reference** on the Shadow PC on 2026-10-10 by an independent reviewer who had not seen the build
before. Round 15 (`verify15_plaza.md`) was read for context only; every score below is fresh.

## Method
- **Reference:** studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- **Practice:** studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only. No code was run in Studio; nothing was modified or saved in either studio.
- **Captures:** `v16_<cam>_ref_a` / `v16_<cam>_ref` and `v16_<cam>_rep_a` / `v16_<cam>_rep`, all 1452x793, saved in
  `out/verify16/`.
  - Pixels changing by more than 30 levels within a pair: 1.0-4.0% in the reference (water, VFX, portals, crowd) and
    0.0-1.1% in the practice (fountain mist). That is animation, not streaming, so the second frame was judged.
- **Colours:** every "sampled" RGB is a 5x5 mean from those JPEGs. The pixel box (x0-x1, y0-y1) and frame are given with
  each one. Stud sizes are estimates from the pictures.

## Overall read
Pass 18 fixed the round-15 headline problem: **the pale "slides" are gone in every frame.** The arch is now one object
with a grooved outer sweep and gold rims, and from c1, p5 and c3 it reads as the reference's horseshoe with ears. That
is the main gain of the round.

Other gains:
- **Raid:** the skull and upper tower are now lit (tower in p3, practice (189,118,99)), against the reference's
  (215,107,103) (p3 ref, box 738-742, 138-142). The value pattern is no longer inverted.
- **Big red palm:** it is now in the right place and at the right height in p3, p5, c2 and c3. Its crown sits against the
  sky between the pavilion and the Raid, as in the reference.
- **E ground:** the splats are merged now. The red matches: practice (159,48,45) against reference (194,61,52) (p8 ref,
  box 1248-1252, 298-302).

What now separates the build from the reference, by visual impact:
1. **The arch itself.** It is about 1.4x too wide and has 4-5 concentric pale bands, where the reference has one
   thick dark-slate band. In c1 the reference arch spans x 410-1045 and the practice arch spans x 260-1195.
2. **The arch interior is a black void.** In practice it samples (6,10,19) (p5 rep, box 648-652, 418-422). The reference
   tunnel is lit: the fountain glows cyan against a grey interior, (169,232,244) (p5 ref, box 718-722, 398-402).
   This shows in 9 of 12 frames as two black mouths either side of every spawn view.
3. **The Raid haze is brown-rust, not red glow.** Practice samples (152,87,82) (c3 rep) and (117,65,81) (p3 rep).
   The reference is (178,77,76) (p3 ref, box 643-647, 173-177) and (153,52,57) (c3 ref, box 1348-1352, 278-282).
4. **The E ground has no green.** It is now over-red: 48% red against the reference's 34%, and 1% green against 10%
   (p8, region x 930-1300, y 150-650).

Unchanged since round 15:
- the oversized blue trees;
- the faceted bollards and domed rim beads;
- the spiky grass;
- the whole S side;
- the boxy skyline;
- the pot-pineapple;
- the bright cyan basins.

## Per camera (round 15 -> round 16)

### p1_spawn_n: 8 -> 8
- **Gains:**
  - No slides; the arches read as arches.
  - The Summon avenue, bunting and umbrellas are still right.
- **Geometry:**
  - **Arches:** too wide. The practice left arch runs x 0-540; the reference runs x 150-500. The ears sit as blocks on
    top; in the reference they are part of a taller U-handle, top at y≈265.
  - **Bollards:** faceted and pointed, about 1.5x the reference height. The reference is a squat rounded gold head on a low
    white base.
  - **Rim:** domed gold beads on the rim; the reference has flat discs only.
- **Colour:**
  - **Arch interiors:** black, (6,9,18) (rep, box 198-202, 428-432). The reference is lit blue-grey, (115,173,192) (ref,
    box 318-322, 438-442).
  - **Arch bands:** the bands are pale grey with dark grooves. The reference bands are dark slate, (82,86,98) (ref, box
    298-302, 358-362).
- **Missing:**
  - Wide falls and the aqueduct in the skyline. The practice towers are plain boxes.
  - The crowd.
  - The blue trees at the top corners are about 2x the reference mass.

### p2_spawn_s: 7 -> 7
- **Gains:** none on the S side itself. The arches are better, as in p1.
- **Geometry:**
  - **Shard ring:** a navy ring floating high in clear sky. The reference has grey rock shards in a cloudy rock skyline.
  - **Gate:** about 70% of the reference width. It has a cyan spiral; the reference has a turquoise cloudy door with crystal
    fountains either side.
- **Colour:** the stair grass is tall dark spikes. The reference has a soft lawn strip along the top step, (114,178,70)
  (ref, box 558-562, 376-380).
- **Missing:**
  - The big green palm at upper right.
  - The tree on a rock pillar at upper left.
  - The blue corner trees are still about 2x too big.

### p3_spawn_e: 8 -> 8
- **Gains:**
  - The skull and tower are lit.
  - The tall red palm left of the door now reaches near skull height.
  - A thin red fire line runs at the base, (142,14,17) (rep, box 698-702, 378-382).
- **Colour and lighting:**
  - **Haze:** a brown-rust cloud, (117,65,81) (rep, box 868-872, 248-252). The reference wraps the whole facade in red
    glow, (178,77,76) (ref, box 643-647, 173-177) and (168,128,124) (ref, box 638-642, 253-257). In the reference, red
    light spills onto the towers, the door arch and the stair top; the practice facade sits in neutral daylight.
  - **Lower facade:** close now, practice (139,59,77) against reference (112,61,72) (ref, box 648-652, 328-332).
- **Geometry:**
  - The fire line is a 1-pixel strip. The reference base is a band of red glow and embers about 2 studs tall.
  - The stair splats are sparse pale pink. The reference has red clumps, (115,50,62) (ref, box 613-617, 408-412).
- **Missing:**
  - The rock mass and green palm at left.
  - The red side towers with lit spires.

### p4_spawn_w: 8 -> 8
- **Gains:** the arches, as in p1.
- **Geometry:**
  - **Story trunk:** short, capped just above the sign. The reference trunk is huge and gnarled, with limbs through the
    top third.
- **Colour:** the grass is spiky and dark.
- **Missing:**
  - The portal interior: practice is a flat black disc. The reference has a blue swirl.
  - The green palms at left.

### p5_diag_ne: 8 -> 8
- **Gains:**
  - The arch now reads as the reference horseshoe with gold trim.
  - The big red palm stands in the right place, rising above the Raid roof.
  - The Summon arcade with its statue is at left.
- **Geometry:**
  - **Bollard:** the biggest object in the lower half. It is pointed and faceted, about 1.6x the reference height. The
    reference head is rounded, (223,214,144) (ref, box 718-722, 543-547), on a white base (239,239,230) (ref, box 718-722,
    638-642).
  - **Arch:** slightly too wide. Its interior is black.
- **Colour:**
  - **Arch bands:** pale, (132,138,139) (rep, box 538-542, 378-382). The reference is (69,79,84) (ref, box 598-602,
    368-372), with grooves at (25,39,51) (ref, box 558-562, 408-412).
  - **E stair splats:** thin pink streaks. The reference has dense clumps, (195,90,89) (ref, box 918-922, 513-517).

### p6_diag_sw: 7 -> 7
- **Gains:** the slides are gone; the centre of the frame is now the arch and fountain.
- **Geometry:**
  - **Bollard:** dominant, faceted cap.
  - **Arch interior:** black.
  - **Expeditions gate:** a spiral door; the reference has a turquoise cloud door.
- **Colour:**
  - The blue tree above the pavilion is about 2x the reference.
  - The grass on the stairs is spiky.
- **Missing:**
  - The big green palm at top centre.
  - The orange tree.
  - The soft lawn.
  - The crystal fountains at the gate.

### p7_high: 7 -> 7
- **Gains:** the E ground now reads as continuous red cover from above.
- **Geometry:**
  - **Blue trees:** the trees on the S fountains and the W cluster are about 2x the reference. They hide the S pavilions
    and half the W side.
  - **Arch sweeps:** from above they read as chunky grey blocks at the four corners.
  - **S foreground:** lawn and a white plinth path. The reference has a bright sand beach, (249,250,215) (ref, box
    378-382, 638-642), with a big green palm, a pineapple and swim rings.
- **Colour:**
  - **Basins:** bright cyan, (129,228,233) (rep, box 378-382, 538-542). The reference basins are teal, holding blue trees.

### p8_top: 8 -> 8
- **Gains:**
  - The splats are merged, with gravel paths.
  - The red hue is right.
- **Colour:**
  - **Too much red, no green.** The E region (x 930-1300, y 150-650) is 48% red and 1% green in practice; the reference is
    34% red and 10% green.
  - **Green holes:** the reference has many grass holes with white flowers, (118,167,50) (ref, box 988-992, 298-302).
  - **Basins:** they read bright light blue. The reference is (92,185,203) (ref, box 558-562, 248-252), with a blue tree
    inside each.
- **Missing:** beach props and palms on the S edge.

### c1_wall: 7 -> 8
- **Gains:**
  - The slides are gone. The frame is now a horseshoe arch with ears, flanked by two stairs, with Summon at left and the
    Raid at right. That is the reference composition.
- **Geometry:**
  - **Arch:** too wide. The practice arch spans x 260-1195; the reference spans x 410-1045, so the practice is about 1.45x.
    The practice has 4-5 concentric bands; the reference has a thick outer band, one gold-rimmed groove and the inner
    lip.
  - **Fountain:** still a box column in a black tunnel. The reference has a sculpted splash against a lit back.
- **Colour:**
  - **Arch band:** practice (175,176,163) (rep, box 328-332, 398-402). The reference is (74,81,87) (ref, box 508-512,
    298-302).
  - **Splats are swapped.** Practice has red at left and blue at right. The reference has blue left, (80,162,246) (ref,
    box 338-342, 668-672), and red right, (227,96,93) (ref, box 1118-1122, 628-632).
- **Missing:**
  - The crystal pods beside the domes.

### c2_fountain: 7 -> 8
- **Gains:**
  - No slides.
  - The arch side shows grooved bands sweeping into the stair rail, as in the reference.
  - The red palms and Boss Rush at left, and the Raid tower behind.
- **Geometry:**
  - **Grass:** tall spiky blades fill the lower-right quarter. The reference has one soft clump, (114,165,53) (ref, box
    928-932, 588-592).
  - **Tunnel:** the interior is black.
- **Colour:**
  - **Arch face:** reads pale and gold. The reference is (49,55,77) (ref, box 638-642, 288-292), with the sweep at
    (21,31,43) (ref, box 798-802, 258-262).
  - **Haze:** brown behind the tower.
- **Missing:**
  - The orange tree, (158,116,79) (ref, box 1298-1302, 208-212).
  - The grey palace domes at right; the practice shows white blobs and sky there.

### c3_pavilion: 8 -> 8
- **Gains:**
  - The red palm silhouette against the sky between the pavilion and the Raid now matches.
  - The skull is lit with red eyes.
- **Colour and lighting:**
  - **Haze:** (152,87,82) (rep, box 1378-1382, 218-222). The reference is (153,52,57) (ref, box 1348-1352, 278-282),
    hotter and redder, and it wraps the tower down to the door.
  - **Raid arch:** close, practice (53,15,26) against reference (76,23,32) (ref, box 1198-1202, 468-472). It needs red
    rim light.
- **Geometry:**
  - **Arch:** wider, pale bands, black interior.
  - **Skyline:** boxy towers. The reference has ruined arcades, domes, two wide falls and an aqueduct.
- **Missing:**
  - The tall blue palm at left of the pavilion.

### c4_stairs: 8 -> 8
- **Gains:** still the strongest camera: the avenue, Summon, bunting, umbrellas and blue palms.
- **Geometry:**
  - **Pineapple:** still a gold pot with flat leaves, (155,129,24). The reference is a textured fruit, (133,91,23) (ref,
    box 188-192, 408-412), with a spiky crown.
  - **Crystals:** the big blue crystals at the stair-top corners are not in the reference. It has the pavilion bases and
    blue bushes there.
- **Missing:**
  - The two tall blue cypress trees framing the steps, (32,64,183) (ref, box 313-317, 298-302).
  - The aqueduct at top centre and the wide falls.
  - The lamp posts and the crowd.
- **Colour:**
  - **Stair treads:** read darker blue-grey, (87,100,116). The reference treads are (158,164,162) (ref, box 298-302,
    558-562).

## Scores
| camera | r15 | r16 |
|---|---|---|
| p1_spawn_n | 8 | 8 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 8 | 8 |
| p4_spawn_w | 8 | 8 |
| p5_diag_ne | 8 | 8 |
| p6_diag_sw | 7 | 7 |
| p7_high | 7 | 7 |
| p8_top | 8 | 8 |
| c1_wall | 7 | 8 |
| c2_fountain | 7 | 8 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 8 | 8 |
| **average** | **7.58** | **7.75** |

## Top-10 fixes (ranked by visual impact)
1. **Arch: narrow it and darken it.** (p1-p6, c1, c2, c3.)
   - Pull the outer sweep in, so the arch is about 70% of its present width: in c1 it should span x≈410-1045 px, not
     260-1195.
   - Reduce it to one thick outer band (about 3 studs), one recessed groove and the inner lip; drop the extra concentric
     rings.
   - Recolour the bands to dark slate (70,79,85) (c1 ref, box 508-512, 298-302; p5 ref (69,79,84), box 598-602,
     368-372), with grooves at (25,39,51) (p5 ref, box 558-562, 408-412).
   - Keep the gold rims (0.4 studs).
   - Raise the ears into the band as a U-handle, so the top reaches about 1.5 studs higher, instead of sitting as blocks.
2. **Light the arch interiors.** (p1-p6, c1, c2, c3.)
   - Close each tunnel with a back wall about 4 studs behind the fountain column, (120,130,140) SmoothPlastic.
   - Add a cyan PointLight (120,220,255), brightness 2, range 12, inside each tunnel, and make the water column Neon or
     Glass (150,225,240).
   - Target: no pixel darker than about (60,70,80) inside the mouth. The reference reads (169,232,244) (p5 ref, box
     718-722, 398-402) and (115,173,192) (p1 ref, box 318-322, 438-442); practice is (6,10,19).
3. **Raid haze: red glow, not brown smoke.** (p3, p5, c2, c3.)
   - Retint the haze emitters to (180,70,70) (p3 ref, box 643-647, 173-177; c3 ref (153,52,57), box 1348-1352,
     278-282). Raise opacity and spread it down to the stair top.
   - Add 4-6 red PointLights (255,60,50), brightness 3, range 20, along the facade at door height, so the side towers and
     door arch pick up red rim light.
   - Thicken the base fire line from a strip into a 2-stud ember/glow band across the full facade width.
4. **E ground: cut the red back and add green holes.** (p8, p7, p3.)
   - Remove about 30% of the red cards, mostly near the plaza and along the paths, to bring cover from 48% to about 35%.
   - Add 15-20 grass holes, 4-8 studs, (118,167,50) (p8 ref, box 988-992, 298-302), with white flower dots.
   - Keep the red at (194,61,52) (p8 ref, box 1248-1252, 298-302).
5. **Corner blue trees to half size.** (p1, p2, p3, p4, p6, p7, c3.)
   - Scale them to about 0.5x (15 studs), including the two on the S fountains and the W cluster in p7.
   - Add 2 slim blue cypress trees (about 14 studs, (32,64,183), c4 ref, box 313-317, 298-302) framing the N stair top.
   - Remove the big blue crystals at the N stair top in c4.
6. **Bollards and rim beads.** (Every spawn camera, c3.)
   - Bollard at about 60% of its present height: a white base (239,239,230) (p5 ref, box 718-722, 638-642), about 3x3x1.5
     studs, with a squat rounded gold head (223,214,144) (p5 ref, box 718-722, 543-547), about 1.5 studs. No faceted
     point.
   - Delete the domed gold beads on the medallion rim; keep only the flat discs.
7. **Splats: swap the c1 pair and thicken the E stairs.** (c1, p5, p3.)
   - c1 left (Summon side): blue (80,162,246) (c1 ref, box 338-342, 668-672). c1 right (Raid side): red (227,96,93) (c1
     ref, box 1118-1122, 628-632).
   - Splats should be soft fringed clumps about 4 studs across, not spiky stars.
   - E stair treads: dense clumps (195,90,89) (p5 ref, box 918-922, 513-517), about 40% cover at the bottom steps.
8. **Grass style and lawn strip.** (p2, p4, p6, c2.)
   - Replace the tall spikes with soft clumps 1.5-2 studs tall, (114,165,53) (c2 ref, box 928-932, 588-592).
   - Run a continuous 1-stud lawn strip, (114,178,70) (p2 ref, box 558-562, 376-380), along every S and W stair-top lip.
9. **S side.** (p2, p6, p7.)
   - **Shard ring:** recolour to grey rock (150,155,160), drop it about 15 studs, and scale it 1.3x.
   - **Gate:** scale it 1.3x and swap the spiral for a turquoise cloud door.
   - **Palm:** add a 30-stud green palm at upper right of the gate.
   - **Beach:** replace the lawn and plinth path in the S foreground with a sand beach (249,250,215) (p7 ref, box
     378-382, 638-642), about 40x20 studs, with a palm, a pineapple and swim rings.
10. **Skyline and close props.** (p1, c2, c3, c4, p7, p8.)
    - **Falls:** two wide falls, 4 studs wide, translucent white.
    - **Aqueduct:** a 4-arch aqueduct between the N islands.
    - **Towers:** ruined arcade towers in place of the plain boxes.
    - **Orange tree:** add one (158,116,79) (c2 ref, box 1298-1302, 208-212) behind the SE pavilion.
    - **Pineapple:** a textured fruit (133,91,23) (c4 ref, box 188-192, 408-412), about 6 studs, with a diamond pattern
      and a spiky crown, in place of the pot.
    - **Basins:** recolour to teal (92,185,203) (p8 ref, box 558-562, 248-252).
