# Verify round 26: Anime Expeditions spawn plaza (freestyle, after fix pass 28)

Independent review against the **live reference** on the main PC, 2026-10-11. I did not build this pass. Round 25
(`verify25_plaza.md`, 8.88) was read for comparison; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code was run in either studio, nothing was modified or saved, no computer use.
- **Captures:**
  - Each camera was captured twice per studio; the second frame was judged.
  - Judged frames: `out/verify26/v26_<cam>_ref.jpg` / `_rep.jpg`. First frames: `out/verify26/raw/<cam>_{ref,rep}_a.jpg`.
  - Every frame is full size, **1284 x 793**.
  - Pixels changed by more than 30 levels between frames 1 and 2: 1.1-3.8% in the reference (water, VFX, crowd) and
    0.0-0.3% in practice. The frames match; the difference is animation.
- **Colours:** 5x5 means from the judged JPEGs, given as frame + centre pixel (x,y) in 1284-wide frames. Stud sizes are
  estimates from the pictures.
- **Pass-28 change size** (pixels changed > 30 levels, r25 practice frame vs r26 practice frame): c4 28%, p7 14%,
  c3 13%, p6 13%, p5 13%, p8 11%, c2 10%, others 7-8%.
- **Top-half mean HSV saturation** (same PIL metric as rounds 24/25):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r26 | 82 | 100 | 103 | 109 | 91 | 115 | 88 | 97 | 95 | 110 | 91 | 83 |
| rep r25 | 78 | 84 | 84 | 101 | 92 | 90 | 72 | 80 | 99 | 101 | 88 | 84 |
| **rep r26** | **83** | **91** | **90** | **105** | **97** | **98** | **74** | **84** | **102** | **104** | **97** | **92** |

Every camera is now within 10 of the reference except p6 (-17), p7 (-14), p3 (-13) and p8 (-13). The gap in those four
is the pale island/haze masses and the open lawn, not the accents.

## Overall read
**Pass 28 fixed the round-25 number-one problem. The stairs are right now.**
- Long flat slabs, 2-3 blocks per side per row, thin joints, no dark slot under each row. They read correctly close
  up (c2, c4) and at distance (p1-p6, c3).
- Tread and riser values match:
  - c4 tread (189,196,189) rep (250,690) vs (191,192,189) ref (300,700).
  - c4 riser (84,104,111) rep (250,506) vs (76,97,110) ref (300,650).
- What is left is small: the rep slabs are a touch too clean and boxy. The reference nose carries a soft highlight
  and the joints are slightly darker. Leave them alone this pass.

**Runner and Y match.**
- Panel (59,108,227) rep (470,700) vs (64,107,219) ref (560,700).
- Y core (38,63,156) rep (640,640) vs (44,65,148) ref (640,620).
- Gold band (218,187,45) rep (440,700), about 40 px wide, vs (211,189,56) ref (470,700), about 30 px. Slightly wide,
  but fine.
- The grey kerb (182,187,181) is about 60 px. The stray c4 water decal is gone.

**Accent colours are back.**
- Gold tree (200,159,92) rep (640,240) vs (201,160,73) ref (520,250) in c4.
- Blue column trees (36,88,203) rep (230,250) vs (32,69,190) ref (225,300).
- Bollard heads (139,136,54) rep (378,492) vs (140,131,53) ref (353,500).
- The c3 sky is now deep: (67,176,243) rep (900,60) vs (89,198,240) ref.
- Palms are still about 30 levels light: (109,143,204) rep (250,115) vs (80,112,180) ref (315,211) in c4.

**Raid reads now** (p3, c3, p5, c2): a pointed gothic door with a keystone and bare branches, with the red tree off
the door.

**What now separates the views from the reference, in order of what the eye hits first:**
1. **Fountain jets.** They appear in 9 of 12 cameras: an opaque pale-blue mushroom (136,216,233) rep c1 (640,350)
   vs a translucent dark-teal glowing stream (66,121,140) ref c1 (640,400). The three dark balls in the arch notch
   sit where the reference has a twisted tree.
2. **The sky frame.** Hanging white ruin chunks with no rock under them float in the p2/p3/p4/p5 skies, for example
   p3 rep x 750-880 y 0-70 and x 1130-1250 y 0-100. The reference frames every sky with big rock islands, green tops
   and bright falls.
3. **Hero facades.** The Story ring is plain (p4, p6), the Summon is a cream box (p1, c4, c3, p5), Boss Rush is a
   spiral disc (p5, c2, c3, p7), and the Expeditions orb is lost against the crown tree (p2).

**Known gaps, ranked by visual impact** (unchanged in kind from round 25):
1. Dense foliage colour masses (W blue canopy, E red ground).
2. Floating islands with falls and ruined towers.
3. Water and VFX (jets, portal glow, lagoon depth).
4. Painted textures on the facades and floor.
5. Palms at scale.
6. Signs, crowd and props.

## Per camera (round 25 -> round 26)

### p1_spawn_n: 9 -> 9
- **Gains:**
  - The stairs read as long slabs.
  - The bollard heads are faceted dark gold and match in colour.
  - The palms are deep blue.
  - Top-half saturation is 83 vs 82.
- **Geometry:**
  - The N island is still a pale faceted mint shell with an aqueduct (rep x 300-900, y 40-180). The reference has rock
    undersides, green tops and two bright falls (ref x 660-720, y 30-200).
  - The fountain jets are opaque mushrooms. Each arch notch holds dark balls.
- **Colour:**
  - The gold tree is dull: (187,151,91) rep (640,200) vs (216,176,77) ref (520,160).
  - The bollard bases are bright white chunky blocks, (248,247,242) rep (360,540), vs a stepped grey-white
    (230,231,224) ref (360,560).
- **Missing:** the Summon facade (cream box with bunting) and the crowd and parasols at the stair top.

### p2_spawn_s: 9 -> 9
- **Gains:** the 8 crescents now exist and the sky is deeper ((96,202,241) rep (800,40)).
- **Remaining:**
  - The crescents are lost. They are thin and purple-grey, (101,110,137) rep (580,95), and sit in front of the crown
    trunk and canopy. In the reference, thick grey crescents (110,137,161) ref (690,125) ring the orb against open
    sky.
  - The pale island band still runs right behind the crown (rep y 150-230).
  - A floating ruin chunk with no rock base hangs at rep x 40-150, y 0-100.
  - The gate is a teal door with a painted spiral. The reference has a glowing portal surface in a crystal frame.
  - Top-half saturation is 91 vs 100.

### p3_spawn_e: 9 -> 9.5
- **Gains:**
  - The Raid door now reads: a pointed gothic arch with a keystone and bare black branches each side.
  - The skull tower and red haze are strong.
  - The stair slabs are clean.
- **Remaining:**
  - Three floating ruin chunks have no island under them (rep x 200-300 y 0-150, x 750-880 y 0-70, x 1130-1250
    y 0-100). The reference top is filled by grey crescent rocks and green-topped islands.
  - Top-half saturation is 90 vs 103: less red foliage on the stairs and a paler top-left island.

### p4_spawn_w: 8.5 -> 8.5
- **Gains:** the blue crown with drips is strong, and the palms are deep blue.
- **Unchanged:** a plain ring with cyan lamps. There is no horseshoe crest, no dark inner band and no ivy drips.
- Floating ruins (rep x 130-300 y 0-100) and a domed gazebo chunk (rep x 1010-1120 y 20-130) hang without rock.
- Top-half saturation is 105 vs 109.

### p5_diag_ne: 9 -> 9
- **Gains:** the stairs read correctly, and the Raid door with branches is visible at right.
- **Remaining:**
  - Boss Rush is still a purple spiral disc (rep x 880-930, y 300-370). The reference has a purple gothic shrine with
    a "Boss Rush" sign.
  - The Summon is a cream colonnade.
  - The jet is a mushroom.
  - Floating ruin towers hang in the sky top-centre (rep x 540-780, y 0-170).
  - The near runner panel is a little pale at its lit edge: (88,130,231) rep (20,410) vs (55,92,213) ref (30,410).
  - Top-half saturation is 97 vs 91, slightly over.

### p6_diag_sw: 8.5 -> 8.5
- **Gains:** the stairs read correctly, and saturation rose from 90 to 98.
- **Remaining:**
  - The Expeditions corner (top left) is still a pale island with green drapes, with the white orb overlapping the
    "Expeditions" sign. The reference shows the crescent ring in open sky above the gate.
  - The Story ring is plain.
  - The fountain notch has dark balls and a stick tree where the reference has a leafy tree.
  - Top-half saturation is 98 vs 115, the largest gap in the set.

### p7_high: 9 -> 9
- **Gains:** the W lagoon is back with blue palms on its edge, the near palm is long-frond yellow-green, and the S
  lawn is brighter.
- **Remaining:**
  - The lagoon is pale cyan and round: (98,165,218) rep (260,250). The reference W water is a broad, deep blue
    (30,86,147) ref (260,250) / (36,93,179) ref (60,300), with an irregular shoreline under dense blue canopy.
  - The S lawn is minty: (108,194,102) rep vs (114,181,60) ref at (900,620). B is about 40 too high.
  - The near palm is too yellow: (187,223,79) rep (250,420) vs (132,193,83) ref (330,420).
  - The hard Roblox shadows on the spawn floor are crisper than the reference's soft ones.
  - Top-half saturation is 74 vs 88.

### p8_top: 8.5 -> 8.5
- **Gains:** the lagoon disc is visible at the W.
- **Remaining:**
  - The W half is still mostly open lawn with sand discs and scattered blue clumps. The reference W is dense blue
    canopy over grey-blue water and stone circles.
  - The E red is close.
  - The giant W tree is a brown star on a blue disc.

### c1_wall: 9 -> 9
- **Gains:** none of note in this view.
- **Remaining:**
  - The jet is an opaque mushroom (see Overall read).
  - The arch notch has 3 dark balls and a stick trunk with a diagonal plank. The reference has a twisted trunk with
    green and blue leaves rising out of the notch.
  - The arch face is flat light grey with a dark marble band. The reference arch is bevelled grey stone with
    stepped inner bands.
  - The red clump is still hot: (251,91,95) rep (1040,600) vs (227,92,90) ref (1020,600).

### c2_fountain: 9 -> 9
- **Gains:**
  - The right flight is now long flat slabs (the r25 "worst stair read" is fixed).
  - The red floor decals are gone. The green leaf scatter on the floor at bottom left matches the reference's.
- **Remaining:**
  - The fern is a coarse dark fan: (102,166,48) rep (800,560) vs a fine spray with lit tips (190,234,98) ref
    (930,590).
  - Boss Rush is a spiral disc.
  - The jet is a mushroom.
  - The fountain arch reads dark slate. The reference arch is lighter bevelled grey.

### c3_pavilion: 9 -> 9
- **Gains:** the sky is deep blue and matches. The Raid door reads.
- **Remaining:**
  - The left island is a pale aqueduct band, (151,172,154) rep (60,140). The reference has a big rock island with
    leafy lumps (172,193,130) ref (152,102), a ruined tower and two bright white falls 30-60 studs long (ref x
    160-280, y 190-350).
  - Boss Rush is a spiral, and the Summon a cream box.
  - Top-half saturation is 97 vs 91.

### c4_stairs: 9 -> 9.5
- **Gains:** this is the best view in the set.
  - Stairs, runner, Y, kerb, gold bands, the blue column trees and the gold tree all match in form and colour (see the
    Overall read).
  - The stray water decal is gone.
- **Remaining:**
  - The palms are about 30 levels light.
  - The N island is a pale mint shell with faint falls.
  - The Summon is a cream box where the reference has an ornate gold facade with blue windows.
  - There is no crowd, and the pineapple is untextured.
  - Top-half saturation is 92 vs 83, slightly over.

## Scores
| camera | r25 | r26 |
|---|---|---|
| p1_spawn_n | 9 | 9 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9 | 9.5 |
| p4_spawn_w | 8.5 | 8.5 |
| p5_diag_ne | 9 | 9 |
| p6_diag_sw | 8.5 | 8.5 |
| p7_high | 9 | 9 |
| p8_top | 8.5 | 8.5 |
| c1_wall | 9 | 9 |
| c2_fountain | 9 | 9 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9 | 9.5 |
| **average** | **8.88** | **9.04** |

## Top-10 for the next pass (ranked by visual impact)
1. **Fountain jets and arch notch (c1, c2, c3, p1-p6: 9 cameras).**
   - Replace the opaque mushroom jet, (136,216,233) at c1 rep (640,350), with a translucent stream:
     - a column about 1 stud wide and 4-5 studs tall, Transparency 0.4, colour (110,190,220);
     - a Neon core 0.3 stud wide in (200,245,255);
     - a short spray ParticleEmitter and a soft PointLight (range 8, (120,210,240));
     - target read: (66,121,140) through the water (ref c1 (640,400)).
   - Replace the 3 dark spheres in each arch notch with a small twisted tree: trunk 0.6 stud, 5-6 studs tall, with
     2-3 leaf clumps in (90,150,60) and (40,90,220).
2. **Sky frame: no ruins hanging in empty sky (p2, p3, p4, p5, p6, c3).**
   - Every floating ruin chunk needs a rock island under it or must go: p3 rep x 200-300 y 0-150, x 750-880 y 0-70,
     x 1130-1250 y 0-100; p4 x 130-300, x 1010-1120; p5 x 540-780; p2 x 40-150.
   - Each island needs a grey rock cone underneath, (120,125,130), about 1.5x the ruin width and 0.8x its height,
     plus a grass cap (110,170,70) with 3-5 leafy lumps.
   - Retint the pale N/W island shells from (151,172,154) toward (172,193,130) (c3 ref (152,102)).
   - Give the c3/c4 left island two bright falls: (235,245,250), Transparency 0.25, 3-5 studs wide, 30-60 long.
3. **Expeditions orb and crescents (p2, p6).**
   - Move the crown tree about 25 studs E (or raise the orb and ring about 12 studs above the canopy) so the ring sits
     against open sky.
   - Thicken the crescents to about 1.5 studs and lengthen them to 8-12 studs.
   - Retint them from (101,110,137) to about (130,138,155).
   - Lower the pale island band behind the crown by about 50 studs.
4. **Story portal (p4, p6).**
   - Add a horseshoe crest about 6 studs wide on top of the ring.
   - Add a darker inner band in (40,60,120), 1 stud wide.
   - Add 4-6 blue ivy drips (40,90,220), 3-6 studs long, off the rim.
   - Add a dark-blue glow plane inside the ring.
5. **Summon facade (p1, c4, c3, p5, p7).**
   - Replace the cream box with a white-gold face: 3 tall blue arched windows (60,100,200) with gold frames, a gold
     medallion over the door, and pilasters with gold capitals.
   - It is the vanishing point of c4 and p1.
6. **Boss Rush facade (p5, c2, c3, p7, p8).**
   - Replace the spiral disc with a purple gothic shrine about 25 studs tall: pointed arch, spires, and a sign in
     (200,60,90) on (70,40,90) stone with a magenta glow.
7. **W lagoon and lawn (p7, p8).**
   - Deepen the lagoon from (98,165,218) to about (40,95,170), with a lighter rim (90,170,220).
   - Stretch it to about 80 x 50 studs with an irregular shoreline.
   - Cover the W sand discs with dense blue canopy clumps (40,90,220).
   - Retint the S lawn from (108,194,102) to (114,181,60).
   - Tone the p7 near palm from (187,223,79) to (132,193,83).
8. **Fountain arch and bollard finish (c1, c2, p1-p6).**
   - Arch face from flat light grey to bevelled grey stone (150,155,165), with 2 stepped inner bands and a darker
     band (70,80,95).
   - Bollard base from bright white (248,247,242) to (230,231,224), stepped in two tiers, with a 0.2-stud gold trim
     (200,175,60).
9. **Foliage accents (c1, c2, c4, p1).**
   - Cool the c1 red clump from (251,91,95) to (227,92,90).
   - Swap the coarse c2 fern for a finer spray with lit tips toward (190,234,98).
   - Darken the palm leaves from (109,143,204) to (80,112,180).
   - Warm the p1 gold tree from (187,151,91) to (216,176,77).
10. **Life and props (p1, c4, c3, p2).**
    - Add 6-10 parasols/stalls and lamp posts at the Summon stair top.
    - Add two crystal basins (about 4 studs) in front of the Expeditions gate.
    - Texture the pineapple.
    - Give the Expeditions door a glowing teal portal surface (Neon (60,200,200), Transparency 0.3) in place of the
      painted spiral.
