# Verify round 27: Anime Expeditions spawn plaza (freestyle, after fix pass 29)

Independent review against the **live reference**, 2026-10-11. I did not build this pass. Round 26
(`verify26_plaza.md`) was read for comparison; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code was run, nothing was modified or saved, no computer use.
- **Captures:** each camera twice per studio; the second frame was judged.
  - Judged frames: `out/verify27/v27_<cam>_ref.jpg` / `_rep.jpg`. First frames: `out/verify27/raw/<cam>_{ref,rep}_a.jpg`.
  - All frames are full size, **1284 x 793**.
  - Pixels changed > 30 levels between frames 1 and 2: reference 0.8-5.2% (water, VFX, crowd), practice 0.0-0.2%.
    The frames match; the difference is animation.
- **Colours:** 5x5 means from the judged JPEGs, frame + centre pixel (x,y). Stud sizes are estimates from the pictures.
- **Pass-29 change size** (pixels > 30 levels, r26 practice frame vs r27 practice frame): p2 14%, p6 7%, p1 6%,
  p3 6%, p5 5%, p4/p7/c1/c3 4%, c2/c4 3%, p8 2%. A small pass on screen.
- **Top-half mean HSV saturation** (same PIL metric as rounds 24-26):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r27 | 82 | 99 | 102 | 110 | 91 | 116 | 88 | 105 | 94 | 110 | 91 | 80 |
| rep r26 | 83 | 91 | 90 | 105 | 97 | 98 | 74 | 84 | 102 | 104 | 97 | 92 |
| **rep r27** | **82** | **93** | **90** | **104** | **95** | **99** | **73** | **84** | **103** | **103** | **97** | **92** |

Essentially unchanged. The gaps are still p8 (-21), p6 (-17), p7 (-15) and p3 (-12): the W lagoon/lawn and the pale
island masses, none of which pass 29 touched.

**Arithmetic note:** round 26's scores (9, 9, 9.5, 8.5, 9, 8.5, 9, 8.5, 9, 9, 9, 9.5) sum to 107.5, so their mean
is **8.96**, not the 9.04 printed in `verify26_plaza.md`. Round 27 is compared against 8.96.

## Overall read
**Pass 29 landed its structural fixes (sky, notch trees) but not its colour/facade ones.**

Wins that read on screen:
- **No more ruins hanging in empty sky.** Every floating chunk in p3, p4, p5, p2 now sits on a grey rock cone with a
  grass cap (p3 rep x 760-880 y 0-110, x 1100-1260 y 0-140; p4 x 100-300; p5 x 540-780). This was the r26 #2 item and
  it is fixed in kind.
- **Arch notches hold small twisted trees** with blue and green leaf clumps (c1, c3, p1, p2, p5, p6). They now read
  like the reference's notch tree instead of three dark balls.
- **Story ivy drips** hang off the crown canopy (p4, p6), and a small crest knob sits on the ring.
- **Expeditions orb:** the upper half of the crescent ring now sits against sky ((115,204,240) at p2 rep (620,110) and
  (760,110)). The crescents are thicker and read as a ring.
- **Boss Rush** reads as a dark purple block with a spire and a pink sign (p5 rep (900,340) (81,58,115); c2).
- **Jets** are no longer opaque mushrooms. There is a translucent column with steam spray, best seen in c2 and p3.

What did not land:
- **Jets still read as lamps, not water.** The column is about 40 px wide in c1 and topped by a glossy sphere. The
  reference is a frothy white burst about 100 px wide: (214,246,251) ref c1 (640,420) vs (136,203,221) rep (640,390)
  in the column and (173,195,205) at the sphere (640,330).
- **The Summon still reads as a cream box.** The face is (243,231,160) rep c4 (575,345) and the windows grey
  (121,133,137) rep (610,360). The reference face is a mid gold-olive (181,149,79) ref (590,340) / (222,215,141)
  ref (640,375). The bunting is the strongest thing on it. Gold capitals and the medallion are too small to register
  at c4/p1 distance.
- **The Story ring is still pale.** Rim (118,146,199) rep p4 (600,330) vs dark steel (45,69,113) ref (600,330). The
  crest is a cyan knob (52,227,238), not a horseshoe.
- **The lower half of the orb ring** still overlaps the island band: (101,136,112) at p2 rep (720,200).
- **Untouched (as stated in the brief):** W lagoon, lawn, arch/bollard finish, foliage tints, props.

**Known gaps, ranked by visual impact:**
1. Dense foliage colour masses (W blue canopy over water in p7/p8, E red ground).
2. Floating islands with bright falls and ruined towers (the c3/c4/p1 left and N islands are still pale with no falls).
3. Water and VFX (jet bursts, portal glow, lagoon depth).
4. Painted textures on facades and floor (Summon, Story, Expeditions door).
5. Palms at scale.
6. Signs, crowd and props.

## Per camera (round 26 -> round 27)

### p1_spawn_n: 9 -> 9
- **Gains:** the notch trees replace the dark balls on both arches, and the jets are translucent columns.
- **Geometry:**
  - The jets are glass tubes with a ball. The reference has white bursts (ref x 200-260 / 1020-1080, y 390-450).
  - The N island is still a pale faceted band with an aqueduct. The reference has rock undersides with two bright
    falls (ref x 660-720, y 30-200).
- **Colour:**
  - The gold tree is dull: (187,151,91) rep (640,200) vs (219,180,78) ref (520,160).
  - The bollard bases are bright white chunky blocks: (248,247,242) rep (360,540) vs (230,231,224) ref (360,560).
- **Missing:** the Summon reads as cream with bunting; there is no crowd.

### p2_spawn_s: 9 -> 9
- **Gains:** the largest change in the set (14%).
  - The crown trunk moved left of the orb.
  - The crescents are thicker and the upper ring is against sky.
  - A ruin at top left now has a rock base.
- **Remaining:**
  - The lower half of the ring and the "Expeditions" sign sit on the island band (rep y 170-230).
  - The gate is still a teal door with a painted spiral, (33,119,148) rep (640,330). The reference has a glowing
    teal portal (7,150,164) ref (640,300) with crystal basins either side.
  - Top-half saturation is 93 vs 99.

### p3_spawn_e: 9.5 -> 9.5
- **Gains:** the three hanging ruins now sit on rock cones with grass caps, which closes the r26 complaint. The
  skull tower, red haze and Raid door are strong.
- **Remaining:**
  - The jets are lamp-like columns.
  - Top-half saturation is 90 vs 102: less red foliage on the stairs, and the top-left island is grey rather than
    green.

### p4_spawn_w: 8.5 -> 9
- **Gains:**
  - The ruins at top left and the gazebo at top right now have rock bases.
  - Blue ivy drips hang under the crown, and a crest knob sits on the ring.
- **Remaining:**
  - The ring rim is pale silver-blue, (118,146,199) rep (600,330), vs dark steel (45,69,113).
  - The crest is a small cyan knob where the reference has a horseshoe about 6 studs wide.
  - The ring has no dark inner band or glow plane.
  - Top-half saturation is 104 vs 110.

### p5_diag_ne: 9 -> 9
- **Gains:** Boss Rush is now a dark purple shrine block with a spire (97,75,126) rep (920,330). The notch tree reads.
- **Remaining:**
  - The Summon at left is cream (237,228,192) rep (60,250) vs gold-cream (209,199,159) ref (60,230), with oversized
    bunting.
  - The jet is a column with a ball.
  - The near bollard is bright white.

### p6_diag_sw: 8.5 -> 8.5
- **Gains:** a leafy notch tree, and ivy drips on the Story tree.
- **Remaining:**
  - The Expeditions corner is still a pale island with green drapes. The orb is cropped at the top edge (rep
    (170,30) white). In the reference the crescent ring sits fully in open sky above the gate (ref x 50-320,
    y 0-210).
  - The Expeditions door is a painted spiral, (35,121,150) rep (60,300), vs a glowing portal (1,128,139) ref.
  - The Story ring is pale: inside (28,39,57) vs (0,9,18).
  - Top-half saturation is 99 vs 116, still the largest gap among the eye-level views.

### p7_high: 9 -> 9
- **Unchanged** (the lagoon and lawn were not in the pass).
  - The lagoon is pale cyan and round: (98,165,218) rep (260,250) vs deep (35,89,149) ref (260,250) / (37,95,179)
    ref (60,300).
  - The S lawn is minty: (108,194,102) vs (112,182,61) at (900,620).
  - The near palm is too yellow: (187,223,79) rep (250,420) vs (132,193,83) ref (330,420).
- Top-half saturation is 73 vs 88.

### p8_top: 8.5 -> 8.5
- **Unchanged.**
  - The W half is open lawn with sand discs and a bright lagoon: (116,237,254) rep (250,250) vs grey-blue water under
    canopy (106,125,143) ref.
  - The SW lawn is (135,178,103) rep (150,500) where the reference has a pale stone/sand path area (216,219,211).
- Top-half saturation is 84 vs 105.

### c1_wall: 9 -> 9
- **Gains:** the twisted notch tree with blue and green clumps reads well; this was the r26 complaint.
- **Remaining:**
  - The jet is a glass tube with a glossy ball, (136,203,221) / (173,195,205). The reference is a white frothy
    burst, (214,246,251) at (640,420), about 100 px wide and 90 px tall.
  - The arch face is flat light grey with a dark marble band. The reference arch is bevelled grey stone.
  - The red clump is still hot: (251,90,95) rep (1040,600) vs (227,92,90) ref (1020,600).

### c2_fountain: 9 -> 9
- **Gains:**
  - The jet shows a steam spray at its base.
  - Boss Rush now reads purple with a pink sign behind the red palm.
  - The notch tree shows.
- **Remaining:**
  - The fern is a coarse dark fan: (102,166,48) rep (800,560) vs a fine spray with lit tips (190,234,98) ref
    (930,590).
  - The arch reads dark slate (64,71,90) vs (48,55,74). That is close, but it has no bevel highlights.

### c3_pavilion: 9 -> 9
- **Gains:** the notch tree is leafy, and the floating ruins centre-right have rock cones.
- **Remaining:**
  - The left island is a pale aqueduct band, (122,151,132) rep (60,140), vs leafy green (169,192,130) ref (152,102).
    There are no bright falls (ref x 160-280, y 190-350).
  - The Summon at left is near white, (254,253,237) rep (60,430), vs gold (192,183,130) ref.
  - Top-half saturation is 97 vs 91.

### c4_stairs: 9.5 -> 9.5
- **Gains:** the gold tree warmed: (204,161,88) rep (650,230) vs (220,178,77) ref (540,230).
- **Remaining:**
  - The Summon is the vanishing point and still reads cream: (243,231,160) rep (575,345) with grey windows
    (121,133,137), vs gold-olive ornate (181,149,79) / (222,215,141) ref. Bunting dominates it.
  - The palms are about 25 levels light: (109,143,204) rep (250,115) vs (85,115,181) ref (315,211).
  - The N island is still a pale shell with faint falls.
  - There is no crowd.

## Scores
| camera | r26 | r27 |
|---|---|---|
| p1_spawn_n | 9 | 9 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 8.5 | 9 |
| p5_diag_ne | 9 | 9 |
| p6_diag_sw | 8.5 | 8.5 |
| p7_high | 9 | 9 |
| p8_top | 8.5 | 8.5 |
| c1_wall | 9 | 9 |
| c2_fountain | 9 | 9 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9.5 | 9.5 |
| **average** | **8.96** (printed 9.04) | **9.00** |

## Top-10 for the next pass (ranked by visual impact)
1. **Fountain jets read as water, not lamps (9 cameras: c1, c2, c3, p1-p6).**
   - Delete the glossy sphere on top of each jet.
   - Replace the 40 px glass tube with a burst:
     - a central column about 0.8 stud wide and 2.5 studs tall, Transparency 0.35, (200,240,250);
     - a wide crown of 3-4 overlapping curved sheets or cones, about 3 studs across, Transparency 0.3, (215,245,250);
     - a Neon core (235,255,255).
   - Double the spray ParticleEmitter rate and size so the white froth fills about 3 x 3 studs above the basin.
   - Target: (214,246,251) at c1 (640,420); now (136,203,221).
2. **Summon facade colour and scale of detail (c4, p1, p5, c3, p7).**
   - Retint the face from (243,231,160) to (215,195,130).
   - Make the pilasters, cornice and window frames gold (200,160,70), each at least 1 stud wide so they register at
     70 studs.
   - Make the windows (60,100,200), not grey (121,133,137).
   - Enlarge the medallion to about 5 studs.
   - Cut the bunting to one strand, or lower it below the windows. It is currently the dominant read.
3. **W lagoon and lawn (p7, p8).**
   - Deepen the lagoon from (98,165,218) to (40,95,170), with a rim of (90,170,220).
   - Stretch it to about 80 x 50 studs with an irregular shore.
   - Cover the W sand discs with dense blue canopy clumps (40,90,220).
   - Retint the S lawn from (108,194,102) to (114,181,60).
   - Retint the p7 near palm from (187,223,79) to (132,193,83).
4. **Left and N floating islands: colour and falls (c3, c4, p1, p3).**
   - Retint the pale island shells from (122,151,132) to (169,192,130), with leafy lumps.
   - Add two bright falls under the c3/c4 left island and two under the N island: (235,245,250), Transparency 0.25,
     3-5 studs wide, 30-60 studs long.
5. **Story portal (p4, p6).**
   - Darken the ring rim from (118,146,199) to (50,75,120).
   - Replace the cyan knob with a horseshoe crest about 6 studs wide, gold (200,170,60) with a blue (40,70,160)
     inset.
   - Add a dark-blue inner band (30,45,90), 1 stud wide, and a glow plane (20,40,110) inside.
6. **Expeditions orb and gate (p2, p6).**
   - Raise the orb and crescent ring about 10 studs, or drop the island band behind it a further 30 studs, so that
     the lower half of the ring is also in sky. It now sits on (101,136,112) at p2 (720,200).
   - Swap the painted spiral door (33,119,148) for a glowing portal plane: Neon (10,150,165), Transparency 0.3.
   - Add two crystal basins about 4 studs wide either side of the gate.
7. **Bollard and arch finish (p1-p6, c1, c2).**
   - Bollard base from (248,247,242) to (230,231,224), stepped in two tiers, with a 0.2-stud gold trim
     (200,175,60).
   - Arch face from flat light grey to bevelled stone (150,155,165): two stepped inner bands, a darker band
     (70,80,95), and a 0.3-stud chamfer on the outer edge.
8. **Foliage tints (c1, c2, c4, p1).**
   - Cool the c1 red clump from (251,90,95) to (227,92,90).
   - Darken the palm leaves from (109,143,204) to (85,115,181).
   - Warm the p1 gold tree from (187,151,91) to (219,180,78). The c4 gold tree is already right.
   - Swap the coarse c2 fern (102,166,48) for a finer spray with lit tips (190,234,98).
9. **Boss Rush finish (p5, c2, p7).**
   - The shrine block reads; now add a magenta glow (PointLight (220,60,160), range 20).
   - Make the sign about 2x larger in (200,60,90) on (70,40,90) stone, and add 2 pointed spires about 8 studs tall.
10. **Life and props (p1, c4, c3).**
    - Add 6-10 more parasols, stalls and lamp posts along the Summon stair top. Parasols exist now but are sparse.
    - Add a few NPC-scale figures or statues to suggest the crowd.
    - Texture the pineapple.
