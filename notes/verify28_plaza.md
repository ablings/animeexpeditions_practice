# Verify round 28: Anime Expeditions spawn plaza (freestyle, after fix pass 30)

Independent review against the **live reference**, 2026-10-11. I did not build this pass. Round 27
(`verify27_plaza.md`) was read for comparison; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code was run, nothing was modified or saved, no computer use.
- **Captures:** each camera twice per studio; the second frame was judged.
  - Judged frames: `out/verify28/v28_<cam>_ref.jpg` / `_rep.jpg`. First frames: `out/verify28/raw/<cam>_{ref,rep}_a.jpg`.
  - All frames are full size, **1284 x 793**.
  - Pixels changed > 30 levels between frames 1 and 2: reference 0.9-4.8% (water, VFX, crowd), practice 0.0-0.3%.
    The frames match; the difference is animation.
- **Colours:** 5x5 means from the judged JPEGs, frame + centre pixel (x,y). Stud sizes are estimates from the pictures.
- **Pass-30 change size** (pixels > 30 levels, r27 practice frame vs r28 practice frame): p8 12.4%, p7 8.1%, c3 5.8%,
  p5 5.3%, p1/c1 3.6%, c4 3.1%, p6 3.0%, c2 2.7%, p4 2.5%, p2 1.7%, p3 1.6%.
- **Top-half mean HSV saturation** (same PIL metric as rounds 24-27):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r28 | 83 | 100 | 102 | 110 | 90 | 116 | 90 | 99 | 96 | 110 | 92 | 80 |
| rep r27 | 82 | 93 | 90 | 104 | 95 | 99 | 73 | 84 | 103 | 103 | 97 | 92 |
| **rep r28** | **83** | **93** | **90** | **105** | **97** | **101** | **76** | **89** | **104** | **103** | **97** | **94** |

p8 closed half its gap (-15 -> -10) from the blue canopy. p6 (-15), p7 (-14) and p3 (-12) are still the low ones.
c4 is now 14 over the reference: the gold/lilac canopy around the Summon is a little hot.

## Overall read
**Pass 30 landed most of its list. The Summon, Story ring and W lagoon now read right in kind; the jets are better
but still not water; the new falls made the "pillar" problem worse, not better.**

Wins that read on screen:
- **Summon facade** is now a gold building, not a cream box. In c4 the face is (192,172,108) at (600,300), the windows
  are blue (83,140,231) at (610,360) (was grey (121,133,137)), gold pilasters and cornice register, and the
  medallion reads. Ref face (171,140,77) at (590,340). Same win in p1, p5, c3, p7.
- **Story ring** is dark steel: (40,64,118) at p4 (600,330) vs ref (43,68,111). The crest is a gold horseshoe with a
  blue inset. In p6 the rim is (40,69,138) vs (53,76,109): close, slightly too saturated.
- **W lagoon and canopy** (p7, p8): the lagoon is deep blue with a rim and blue canopy clumps cover the W lawn and
  sand discs. p8 (250,250) went from (116,237,254) to (67,121,199). The near palm in p7 is now green (132,197,70) vs
  ref (132,193,83): fixed.
- **Jets** are a burst on the drum now (column + puffs + foam disc). At c1 the core is (163,221,235) vs ref
  (173,222,234): the colour is right.
- **Bollards** are two-tier with gold trim.
- **Islands** are greener on top: c3 (60,140) (158,179,120) vs ref (175,195,131); was (122,151,132).

What did not land, or regressed:
- **The falls read as white pillars, now more than before.** The fall strips under the c3 left island and the c4 N
  island are opaque pure white: (254,254,254) at c3 (60,230) and (255,255,255) at c4 (600,210). The reference falls are
  translucent blue-white streaks that fade into mist: (204,243,250) at c3 ref (190,280), (202,244,249) at c4 ref
  (670,230). At this contrast the c3 left island looks like it stands on white columns.
- **The jets read as a cloud or cauliflower, not water.** The burst is built from round puffs (c1 x 560-660, y 330-430).
  The reference is streaky: thin translucent sheets falling over the back wall, with spray. Shape, not colour, is the
  gap now.
- **c2 fern regressed in colour.** The spot at c2 (800,560) is now a red clump (201,57,59); r27 was a coarse green fern
  (102,166,48); the reference is a lime fern with lit tips (190,234,98).
- **Untouched:** the Expeditions gate and orb (p2, p6), the S lawn (108,194,102), Boss Rush (still (95,59,132) with no
  glow vs ref magenta (198,112,180) at p5 (940,330)), the arch bevel, palm and gold-tree tints, props.

**Known gaps, ranked by visual impact:**
1. Dense foliage colour masses. The W canopy has now arrived, so the remaining gap is the E red ground density and the
   S lawn tint.
2. Floating islands with falls. The islands have the right shape, but the falls read as solid white pillars.
3. Water and VFX: jet sheets, portal glow, mist.
4. Painted textures on facades and floor (Expeditions door, arch stone).
5. Palms at scale: the c4 palm leaves are still light.
6. Signs, crowd and props.

## Per camera (round 27 -> round 28)

### p1_spawn_n: 9 -> 9
- **Gains:**
  - The Summon at the vanishing point is now gold with blue windows.
  - The jets are bursts instead of a tube with a ball.
  - The bollards are two-tier with gold trim.
- **Geometry:**
  - The bollards are still big white slabs with a green-gold pyramid. The reference bollard is a slim grey pedestal
    with a small gold dome (ref x 1290-1340 in the half-scale sheet, about 2x2 studs, 3 studs tall).
  - The N island has white strips under it, and the reference falls are thin and glowing.
- **Colour:**
  - The bollard face is (242,241,234) vs ref (230,231,224).
  - The gold tree is (187,151,91) vs ref (219,180,78).

### p2_spawn_s: 9 -> 9
- **Gains:** the jets read as bursts.
- **Remaining** (not in the pass):
  - The Expeditions door is still a painted spiral, (15,122,156) at (640,330). The reference is a glowing teal portal,
    (18,178,190) at (640,300).
  - The lower half of the orb ring still sits on the island band, (101,136,112) at (720,200).
  - Top-half saturation is 93 vs 100.

### p3_spawn_e: 9.5 -> 9.5
- **Gains:** the jets are bursts.
- **Remaining:**
  - The skull tower and the Raid door are still strong.
  - Saturation is 90 vs 102: the stairs need more red ground cover and the left trees are lilac/grey.

### p4_spawn_w: 9 -> 9.5
- **Gains:**
  - The ring rim matches the reference: (40,64,118) vs (43,68,111).
  - A gold horseshoe crest with a blue inset (15,70,243) replaces the cyan knob.
  - With the dark ring and the ivy drips, the Story gate reads like the reference.
- **Remaining:**
  - There is no glow plane in the ring: (29,41,55) inside vs ref near black with a faint blue glow.
  - The bollards are white slabs.

### p5_diag_ne: 9 -> 9
- **Gains:** the Summon at left is now gold with a "Summon" sign and blue windows: (229,215,156) at (60,250) vs ref
  (196,187,156). The jet is a burst.
- **Remaining:**
  - Boss Rush has no glow: (95,59,132) vs magenta (198,112,180).
  - The near bollard is a large white block with a green pyramid. The reference has a small gold sphere on a grey post.

### p6_diag_sw: 8.5 -> 9
- **Gains:** the Story ring is dark with a gold horseshoe: (40,69,138) at (1130,300) vs ref (53,76,109). This was half
  of the r27 complaint.
- **Remaining:**
  - The Expeditions corner is unchanged. The door is a painted spiral, (8,129,161) at (60,300). The orb is cropped at
    the top edge ((255,255,255) at (170,30)). In the reference the crescent ring sits in open sky (ref x 50-320,
    y 0-210).
  - Saturation is 101 vs 116.

### p7_high: 9 -> 9
- **Gains:**
  - The W lagoon is deeper with a shore: (76,122,206) at (260,250), was (98,165,218).
  - A blue canopy covers the W lawn, and the near palm is green.
- **Remaining:**
  - The lagoon is still about 45 levels light vs ref (28,84,147).
  - The S lawn is unchanged and minty: (108,194,102) vs (112,181,60) at (900,620).
  - The E red ground is a set of separate blobs. The reference is a continuous red carpet.
  - Saturation is 76 vs 90.

### p8_top: 8.5 -> 9
- **Gains:** the biggest change in the set (12%).
  - The W half is now a dark blue lagoon under a dense blue canopy: (67,121,199) at (250,250), was (116,237,254). This
    matches the reference's blue W mass.
- **Remaining:**
  - The S lawn and sand discs (bottom centre) are still open.
  - The E side is grey ground with red heart blobs. The reference is a dense red carpet with green tufts.
  - Saturation is 89 vs 99.

### c1_wall: 9 -> 9
- **Gains:** the jet is a column with a crown of puffs; the colour is right ((163,221,235) vs (173,222,234)).
- **Remaining:**
  - The puffs are round and read as a cloud. The reference is streaky sheets about 100 px wide falling over the back
    wall.
  - The arch face is still flat light grey with no bevel.

### c2_fountain: 9 -> 9
- **Gains:** the jet shows a burst and spray.
- **Remaining:**
  - The fern spot is now a red clump, (201,57,59) at (800,560), vs ref lime fern (190,234,98).
  - Boss Rush at left has no magenta glow: (91,86,104) at (200,220) vs (202,136,151).
  - The arch has no bevel highlights.

### c3_pavilion: 9 -> 9
- **Gains:**
  - The Summon at left is gold with blue windows and bunting: (233,221,167) at (120,470).
  - The island tops are greener.
- **Remaining:**
  - The falls under the left island are opaque white strips, (254,254,254) at (60,230). They read as columns holding
    the island up. The reference falls are translucent (204,243,250) streaks.
  - The island underside is still grey stone, with no leafy drape.

### c4_stairs: 9.5 -> 9.5
- **Gains:** the Summon is the vanishing point and finally reads as the gold Summon. It has a gold face, blue windows,
  a gold cornice and pilasters, and a medallion; this was the r27 #2 item.
- **Remaining:**
  - The bunting strand still runs across the facade just under the cornice.
  - The falls under the N island are solid white bars: (255,255,255) at (600,210) vs (202,244,249).
  - The palms are still light: (109,143,204) at (250,115) vs ref (85,115,181).
  - Saturation is 94 vs 80: the canopy around the Summon is slightly too saturated.

## Scores
| camera | r27 | r28 |
|---|---|---|
| p1_spawn_n | 9 | 9 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 9 | 9.5 |
| p5_diag_ne | 9 | 9 |
| p6_diag_sw | 8.5 | 9 |
| p7_high | 9 | 9 |
| p8_top | 8.5 | 9 |
| c1_wall | 9 | 9 |
| c2_fountain | 9 | 9 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **108** | **109.5** |
| **average** | **9.00** | **9.125 (9.13)** |

Arithmetic: round 28 has nine cameras at 9 (81) and three at 9.5 (28.5), which sum to 109.5. 109.5 / 12 = 9.125.

## Top-10 for the next pass (ranked by visual impact)
1. **Falls: from white pillars to water (c3, c4, p1).**
   - Delete or retint the opaque white fall strips: now (254,254,254) / (255,255,255).
   - Each fall: a plane 3-4 studs wide, Transparency 0.4, colour (200,240,250).
   - Fade it towards the bottom with a vertical-gradient decal or a second, wider plane at Transparency 0.7.
   - Add a mist ParticleEmitter at the foot (white, size 3-5, Transparency 0.6).
   - Target: (204,243,250) at c3 (190,280).
   - Do not let a fall touch both the island and the ground; end it in mist 10-20 studs above the canopy.
2. **Jets: from puffs to streaks (9 cameras: c1, c2, c3, p1-p6).**
   - Replace the round puff spheres with 4-6 thin curved sheets, each about 0.3 x 2.5 studs, Transparency 0.35.
     Arc them outward and downward over the drum lip, so the outline is a fountain spray, not a cloud.
   - Keep the core column and the foam disc.
   - Give the spray emitter stretched streak particles: speed 6-8, lifetime 0.6, size 0.4-1.0, and Acceleration
     (0,-20,0) so it falls back.
   - Keep the colour: (163,221,235) is already on target.
3. **Ground colour masses (p7, p8, p3, p6).**
   - Retint the S lawn from (108,194,102) to (112,181,60).
   - Join the E red heart blobs into a continuous red carpet (220,60,60) with green tufts, covering about 70% of the E
     ground in p8.
   - Deepen the W lagoon a further step, from (76,122,206) to (35,90,150).
   - Add red ground cover on the E stairs (p3).
4. **Expeditions gate and orb (p2, p6).** Untouched in pass 30.
   - Swap the painted spiral door (8,129,161) for a Neon portal plane (15,170,185), Transparency 0.3, with a swirl
     decal.
   - Add two crystal basins about 4 studs wide either side of the gate.
   - Raise the orb and ring about 10 studs, or push the island band behind it back 30 studs. Now the top is cropped in
     p6 and the bottom sits on (101,136,112) at p2 (720,200).
5. **Bollards: shape (p1-p6).**
   - The reference bollard is a slim grey pedestal, about 2x2 studs and 3 studs tall, (200,205,210), topped by a gold
     (220,180,60) dome about 1.2 studs.
   - The current one is a 3x3 white slab, (242,241,234), with an olive pyramid. Halve the footprint, grey it, and
     swap the pyramid for the dome.
6. **Boss Rush glow (p5, c2, p7).**
   - Add a PointLight (220,60,160), range 20, brightness 2, and a Neon magenta trim on the door arch.
   - Target: (198,112,180) at p5 (940,330); now (95,59,132).
7. **Summon finish (c4, p1, c3).**
   - Lift the bunting strand above the cornice, or remove it; it still crosses the facade.
   - Add a bright arched entry (229,229,209) with a glowing gold emblem in the centre bay, matching ref c4 (640,375).
   - Tone down the canopy behind it about 10% in saturation (c4 is 94 vs 80).
8. **Foliage tints (c2, c4, p1).**
   - Put a lime fern back at the c2 stair foot: (190,234,98) with lit tips. It is now a red clump (201,57,59).
   - Darken the palm leaves from (109,143,204) to (85,115,181).
   - Warm the p1 gold tree from (187,151,91) to (219,180,78).
9. **Arch bevel (c1, c2, c3).**
   - The arch face is flat light grey. Add two stepped inner bands, a darker band (70,80,95), and a 0.3-stud chamfer
     on the outer edge so the gold trim has a lit edge.
   - Add a faint blue glow (40,80,140) inside the arch over the jet.
10. **Life and props (p1, c4, c3).**
    - Add 6-10 more parasols, stalls and lamp posts along the Summon stair top.
    - Add a few NPC-scale figures or statues.
    - Give the Story ring an inner glow plane (20,40,110).
