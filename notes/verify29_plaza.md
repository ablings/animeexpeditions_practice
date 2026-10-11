# Verify round 29: Anime Expeditions spawn plaza (freestyle, after fix pass 31)

This is an independent review against the **live reference**, done 2026-10-11. I did not build this pass. I read round 28
(`verify28_plaza.md`) to compare camera by camera; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** I used `screen_capture` only. I ran no code, modified and saved nothing, and used no computer use.
- **Captures:** I captured each camera twice per studio and judged the second frame.
  - Judged frames are in `out/verify29/v29_<cam>_ref.jpg` and `_rep.jpg`. First frames are in `out/verify29/raw/<cam>_{ref,rep}_a.jpg`.
  - All 24 judged frames are full size, **1284 x 793**.
  - Between frames 1 and 2, 0.7-4.9% of reference pixels changed by more than 30 levels (water, VFX and crowd). Practice
    pixels changed 0.0-0.2%. The frames match; the differences are animation.
- **Colours:** each is a 5x5 mean from the judged JPEG, given as frame and centre pixel (x,y). Stud sizes are estimates from the pictures.
- **Pass-31 change size** (pixels changed by more than 30 levels, r28 practice frame vs r29 practice frame): p2 8.1%, p6 8.1%, p1 7.7%,
  p8 7.5%, p3 7.1%, p7 6.9%, p5 6.1%, c3 5.0%, p4 4.5%, c2 4.2%, c4 4.0%, c1 3.0%.
- **Top-half mean HSV saturation** (same PIL metric as rounds 24-28):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r29 | 82 | 99 | 103 | 109 | 91 | 117 | 89 | 104 | 95 | 110 | 90 | 85 |
| rep r28 | 83 | 93 | 90 | 105 | 97 | 101 | 76 | 89 | 104 | 103 | 97 | 94 |
| **rep r29** | **78** | **90** | **87** | **102** | **95** | **100** | **80** | **93** | **102** | **103** | **95** | **91** |

- p7 (+4) and p8 (+4) rose because of the continuous red carpet.
- p1, p2, p3 and p4 each fell 3-5, from the lighter warm island rock. This confirms the builder's p4 flag; p4 is now 7 under.
- The biggest remaining gaps are p6 (-17) and p3 (-16). There, open sky shows where the reference has dense canopy or
  structure: p6 (1000,200) is sky (154,211,238) vs blue canopy (72,124,198), and p3 (200,200) is sky (92,166,236) vs a dark
  tree (93,76,59).

## Overall read
**Pass 31 fixed the two worst "wrong kind" reads from round 28: the falls are no longer white pillars, and the jets are
no longer clouds. It also landed the fern, the Boss Rush glow, the red carpet and the bollard shape. What is left is mostly
degree, not kind.**

### Wins that read on screen
- **Jets read as a fountain.** Curved translucent sheets fall from a core all round the drum in c1, c2, c3 and p1-p6.
  - At c1 (620,330) the sheet is (152,192,203), close to the ref water (171,209,222).
  - This is the biggest per-frame improvement at player height.
- **Falls are no longer columns.**
  - c3 (60,230) went from (253,254,254) to (215,219,210).
  - c4 (600,210) went from (255,255,255) to (215,215,204).
  - The island underside is now warm stone, (170,131,80) at c3 (150,300), so the island no longer sits on posts.
  - They are still too grey and too solid. The ref falls are blue-white (195,240,249) and glow.
- **Fern** at c2 (800,560): from a red clump (201,57,59) to a lime fern (192,230,68). This is on the target's lit tips; the shaded ref is (101,153,47).
- **Boss Rush** has magenta: the c2 neon sign and trim are at (183,91,186) at (130,220), and in p7 it is a magenta door frame.
- **Red carpet E** is continuous across p7 and p8. p8 (900,450) is (212,87,89), and the E half now reads as one red mass.
- **Lagoon** is deeper: p7 (260,250) went from (76,122,206) to (71,103,172), and p8 (250,250) is (63,90,153).
- **Bollards** are slim with a gold dome (177,165,26) vs ref (184,159,40). The green pyramid is gone.
- **Palms** darkened: c4 (250,115) is (94,126,182) vs the r28 target (85,115,181). Fixed.
- **p6 orb** is no longer cropped at the top edge; it sits in sky above the gate.

### What did not land, or overshot
- **The Expeditions portal is now too bright.** It is a flat cyan plane: p2 (640,330) is (0,174,200) vs ref (3,110,125), and
  p6 (60,300) is (0,165,197) vs (2,118,133). The ref is a dark, swirling teal gate with a light core. This one is known.
- **The bollard is white, not grey, and still too tall.**
  - The face is (209,210,215) at p5 (634,580) vs ref (165,163,124).
  - The ref is a low ornate slab with a dome on it, about 1.5 studs tall to the dome. The rep is a 3-stud cube.
- **The S lawn barely moved.** p7 (900,620) is (121,188,97) vs ref (112,181,60); the blue channel is still 37 too high, so it reads mint.
- **The arch interior is too light.** c1 (560,400) is (61,105,129) vs ref near-black (2,15,25). The jets would pop more against a dark niche.
- **The jet core is an opaque pale egg** (233,254,254) at c1 (640,400). In the ref, water spills down from a back niche.

### Known gaps, ranked by visual impact
1. **Foliage density.** Background canopy is missing behind the Story tree (p6), behind Raid (p3) and in the far W (p4).
   This drives the saturation gaps.
2. **Water and VFX.** The falls need glow and translucency, the portal needs its swirl, and there is no mist.
3. **The outer islands and skyline** read right in kind. The new warm rock is a little beige in p4 and p1.
4. **Painted textures** (arch stone, facades, floor) are missing.
5. **Signs, crowd and props** are missing.

## Per camera (round 28 -> round 29)

### p1_spawn_n: 9 -> 9
- **Gains:**
  - The jets read as sprays.
  - The bollards are slim with gold domes.
  - The Summon is gold at the vanishing point.
- **Geometry:** the bollards are tall white cubes. The ref has a low grey slab with a dome.
- **Colour:**
  - The bollard face is (205,210,213) at (1020,520).
  - The gold tree is (204,157,93) at (620,200); it is warmer now.
  - Top-half saturation fell 83 -> 78 vs ref 82, from the beige island band.

### p2_spawn_s: 9 -> 9
- **Gains:**
  - A portal plane replaces the painted spiral.
  - Crystal basins flank the gate.
  - The jets are sprays.
- **Remaining:**
  - The portal is flat bright cyan, (0,174,200) at (640,330) vs ref (3,110,125). It has no swirl or depth.
  - The orb ring's lower half still overlaps the island band: (99,135,112) at (720,200).
  - Saturation is 90 vs 99.

### p3_spawn_e: 9.5 -> 9.5
- **Gains:**
  - The jets are sprays.
  - Red ground cover is on the E stairs.
- **Remaining:**
  - The upper left is open sky, (92,166,236) at (200,200). The ref has the dark Raid tree mass, (93,76,59).
  - Saturation is 87 vs 103.

### p4_spawn_w: 9.5 -> 9.5 (builder re-check)
- **Holds:**
  - The Story ring and crest still read correctly.
  - The tree canopy and the ivy drips match the ref.
- **Saturation:** the top-half drop is real, 105 -> 102 vs 109. The cause is the beige island underside in the top right
  (rep (147,128,139) at (1150,40) is unchanged from r28), together with the paler sky band. It does not change the read, so the score holds.
- **Remaining:**
  - The ring interior is (26,38,52) vs ref (0,8,17). The ref interior is darker, not glowing.
  - The bollards are white cubes.

### p5_diag_ne: 9 -> 9
- **Gains:**
  - The jet is a spray.
  - The bollard now has a gold dome, (201,180,46) vs ref (216,200,105).
- **Remaining:**
  - The near bollard dominates the lower centre. It is a white 3x3x3 cube, (209,210,215), vs a low beige-grey slab, (165,163,124).
  - Saturation is 95 vs 91, fine.

### p6_diag_sw: 9 -> 9
- **Gains:**
  - The orb is no longer cropped.
  - The portal is a plane now.
  - The jets are sprays.
- **Remaining:**
  - The portal is too bright: (0,165,197) at (60,300) vs (2,118,133).
  - The centre right is open sky, (154,211,238) at (1000,200). The ref has dense blue palms and canopy there, (72,124,198).
  - Saturation is 100 vs 117, the largest gap in the set.

### p7_high: 9 -> 9
- **Gains:**
  - The E red carpet is continuous.
  - The lagoon is deeper.
  - Boss Rush shows a magenta frame.
  - Saturation went 76 -> 80 (ref 89).
- **Remaining:**
  - The S lawn is mint, (121,188,97) vs (112,181,60).
  - The lagoon is still about 35 levels light, (71,103,172) vs (35,90,148).
  - The central plaza reads flatter than the ref: there are no grey stone stair masses with gold piping.

### p8_top: 9 -> 9
- **Gains:**
  - The E half is now a red mass.
  - Saturation went 89 -> 93 (ref 104).
- **Remaining:**
  - The SE lower right still shows green lawn between the red blobs.
  - The red trees are pink-lit, (222,154,149) at (1100,500) vs ref (137,102,90). The ref E is darker red with grey rubble.
  - The S lawn is still open.

### c1_wall: 9 -> 9.5
- **Gains:** the jet is now a fountain of curved sheets, not a cloud of puffs. This was r28 #2 and it reads.
- **Remaining:**
  - The arch niche is light, (61,105,129) at (560,400) vs (2,15,25).
  - The core is an opaque egg, (233,254,254).
  - There are no bevel bands on the arch face.

### c2_fountain: 9 -> 9.5
- **Gains:**
  - The lime fern is back, (192,230,68).
  - Boss Rush is magenta-lit.
  - The jet is streaky.
- **Remaining:** the Boss Rush facade is lilac, while the ref facade is dark purple, (49,32,49) at (160,250), with pink accents only.

### c3_pavilion: 9 -> 9
- **Gains:**
  - The falls are no longer pure white pillars.
  - The island rock is warm.
- **Remaining:**
  - The falls are still opaque light grey strips, (215,219,210) at (60,230), from the island down to the trees. The ref is
    translucent blue-white, (195,240,249), and fades into mist.
  - The upper left is a big white cloud, (226,230,233) at (300,40), where the ref is blue sky, (93,200,241). That is skybox
    placement, not geometry.

### c4_stairs: 9.5 -> 9.5
- **Gains:**
  - The palms are darker and on target.
  - The falls are off white.
- **Remaining:**
  - The falls are grey posts, (215,215,204) at (600,210) vs (198,242,249).
  - The bunting still crosses the Summon facade.
  - The entry is (204,182,107) at (640,375) vs a bright arched door, (226,224,174).
  - Saturation is 91 vs 85, slightly hot.

## Scores
| camera | r28 | r29 |
|---|---|---|
| p1_spawn_n | 9 | 9 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 9.5 | 9.5 |
| p5_diag_ne | 9 | 9 |
| p6_diag_sw | 9 | 9 |
| p7_high | 9 | 9 |
| p8_top | 9 | 9 |
| c1_wall | 9 | 9.5 |
| c2_fountain | 9 | 9.5 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **109.5** | **110.5** |
| **average** | **9.125 (9.13)** | **9.208 (9.21)** |

Arithmetic: seven cameras at 9 make 63 and five at 9.5 make 47.5, so the sum is 110.5. 110.5 / 12 = 9.208.

## Top-10 for the next pass (ranked by visual impact)
1. **Falls: from grey strips to glowing water (c3, c4, p1).**
   - Retint every fall plane from (215,219,210) to (195,240,249).
   - Use Transparency 0.45 at the top and fade to 0.85 at the foot, with a second, wider plane or a gradient decal.
   - Add a 1-stud Neon core strip (230,250,255) at Transparency 0.5 for the glow.
   - Make each fall 4-6 studs wide.
   - Target: (198,242,249) at c4 (670,230).
2. **Fill the sky gaps with canopy (p6, p3, p4; the saturation gaps of -17 and -16).**
   - p6: add 3-4 blue palms and a blue canopy mass (72,124,198), 25-35 studs tall, behind and right of the Story tree.
     They should cover p6 x 850-1100, y 100-300; that area is now sky (154,211,238).
   - p3: add a dark tree or rock mass (93,76,59) about 30 studs tall left of the Raid tower, covering p3 x 120-280, y 120-260.
   - p4: tone the beige island underside to grey-green (125,135,125) to recover about 3 points of saturation.
3. **Expeditions portal (p2, p6).**
   - Darken the plane from (0,174,200) to (5,110,125), switch Neon off or set Transparency 0.2, and add a swirl decal with
     a lighter core (60,200,200).
   - Raise the orb ring about 8 studs, or push the island band about 30 studs back. Its lower half still sits on
     (99,135,112) at p2 (720,200).
4. **Bollards: colour and height (p1-p6).**
   - Lower each bollard from about 3 studs to about 1.5 studs below the dome, widen the base to a 3 x 2 stud slab, and
     chamfer the top edge 0.3.
   - Tint it from white (209,210,215) to warm grey (175,172,150).
   - Keep the gold dome; it is on target.
5. **Ground tints (p7, p8).**
   - S lawn: (121,188,97) -> (112,181,60), with the blue channel down about 35.
   - Lagoon: (71,103,172) -> (35,90,148).
   - p8 SE: cover the remaining green gaps between the red blobs. Shade the red trees from (222,154,149) towards
     (150,70,65), and add grey rubble patches (106,112,106).
6. **Fountain niche and jet core (c1, c2, c3, 9 cameras).**
   - Darken the arch interior from (61,105,129) to (10,25,40), so the jets read against a dark niche.
   - Make the egg core translucent (Transparency 0.4) and shrink it about 40%.
   - Add a water sheet (171,209,222) at Transparency 0.3 spilling from the back niche into the drum, as in ref c1.
7. **Summon finish (c4, p1, c3).**
   - Lift the bunting strand above the cornice.
   - Make the centre entry a bright arched door (226,224,174) with a glowing gold emblem; it is now (204,182,107).
   - Drop the canopy saturation around the Summon about 6 (c4 is 91 vs 85).
8. **Boss Rush facade (c2, p7).**
   - Darken the lilac face to (55,35,60) and keep the magenta neon trim and sign.
   - In p7 the frame (116,69,136) should be closer to the ref (181,77,128): add a magenta PointLight with range 20 and
     brightness 2 at the door.
9. **Arch bevel (c1, c2, c3).**
   - Add two stepped inner bands on the arch face: a darker band (70,80,95) and a 0.3-stud chamfer on the outer edge, so
     the gold trim gets a lit edge.
10. **Story ring and props (p4, p6, c4, p1).**
    - Darken the ring interior from (26,38,52) to (5,10,20), with a thin blue rim glow (40,80,160).
    - Add 6-10 parasols, stalls and lamp posts along the Summon stair top.
    - Add a few NPC-scale statues.
