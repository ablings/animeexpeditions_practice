# Verify round 2: Anime Expeditions spawn plaza (freestyle, after fix pass 4)

Independent review. Method: `screen_capture` only, 2 captures per camera per studio (frames were identical; the last one was judged).
Reference studio `ecdeebfb-...` (`place_84515722934860_Anime_Expeditions.rbxl`), practice studio `efa46ce6-...` (Place1). Cameras from
`cams.json` / `cams_practice.json`. No code was run and nothing was modified in either Studio. A few RGB values below were
sampled from the captured frames (3x3 average); the others, and all sizes, are estimates from the pictures (horizontal FOV is
about 2.27 x distance, so 1 stud at d studs is about 565/d px wide in a 1284 px frame).

## Overall read
This round is a real step up. The plan, the sunken cross, the four arched fountain gates with two-tier basins, the lanterns,
the stairs with the Y-chevron runner, the hooked-blade medallion and one landmark per direction all now read at player
height, and each spawn view has its own identity. From the round-1 spawn shots, a player would now recognise the place.

What still separates it from the reference, by impact:
1. **Emptiness.** The upper half of every ref frame is dense: trees, palms, islands, towers, waterfalls and clouds. The
   practice shows flat saturated blue sky over a handful of blob trees.
2. **Colour value.** Everything is lighter and less saturated in the warm tones, and over-saturated in the cool ones:
   - The gold is butter-pale (253,237,154) where the ref is deep (194,175,54).
   - The runner is cyan-blue (45,150,255) where the ref is royal (65,111,218), with a darker inset (45,62,150).
   - The water glows (141,238,255) where the ref reads (125,188,204).
   - The gate stone is pale and flat.
3. **Gate proportions.** The horns are two tall, separate panels. In the ref they form a squat, continuous squared-U crest
   that sits below the lantern domes.
4. **Lanterns.** They are about two-thirds of the ref size.
5. **Landmarks.** They sit in the right places but are flat-colour boxes at about half the ref's apparent size.

## Per camera (round-1 score in brackets)

### p1_spawn_n: 5/10 (3)
- Geometry/proportion:
  - The gates, basins, stairs, runner and Summon hall line up with the ref composition.
  - The crest horns rise to about y=180 px against the ref's about 265 px, so they are about 3-4 studs too tall, and they
    read as two free-standing tablets.
  - The lantern domes are small (about 50 px against about 85 px).
  - The ref bollards are big, in the foreground at about (+-9, -8). The practice bollards are small, at the stair foot.
  - The Summon hall is about 1.5x too large in the frame and plain.
- Colour/material:
  - The floor is (221,224,214) against (192,198,193).
  - The medallion blades are broad mid-blue swirls. The ref has thin near-black hooked blades (40,45,55) on pale stone,
    inside a **thick raised gold ring** (about 1 stud wide). The practice ring is a thin line.
  - The gold disc is pale and oversized.
- Lighting: flat and even. There is no form shading on the gate or the basins, and no bloom or haze. The sky is (60,167,245)
  with no clouds.
- Missing: the gold, blue and purple trees, blue palms, crystals, the floating-island skyline with waterfalls, and the stall
  clutter on the avenue.

### p2_spawn_s: 4/10 (2)
- Geometry: the Expeditions portal is about 85 px tall against about 130 px, and is a set of 3 flat neon slabs. The ref is a
  stained-glass teal arch with columns, braziers and a ring of floating rocks above. The ref has grass spilling over the stair
  edges and a big green palm top right.
- Colour: the neon cyan (0,255,255 class) is far too hot. The ref portal is teal (40,140,140) with pale-teal trim.
- Missing: the giant palm, the ring of floating rocks, the domed towers on the left horizon, the clouds. A single red tree
  (top left) is the only warm accent.

### p3_spawn_e: 4/10 (2)
- Geometry:
  - The Raid gate is the right idea in the right place, but the ref skull tower reaches almost to the top of the frame (about
    y=30 px, roughly 35-40 studs above the terrace). The practice is a block of about 15 studs topped by a red ball.
  - The ref has a pointed gothic arch entry with flanking spire towers and red palms.
- Colour: the practice is saturated primary red (about 210,30,40) with flat faces. The ref is a weathered red stone
  (170,70,60) to (200,90,80) with a red glow and dark accents.
- Missing: the red palms, the bare dead trees, the coral foliage on the steps (the practice has 3 clumps), the spires.

### p4_spawn_w: 4/10 (2)
- Geometry:
  - The ref Story portal is a heavy silver ring of about 80 px with a black void and a gold crown ornament, under a giant
    blue tree whose trunk (about 200 px wide) and canopy fill the whole upper half of the frame.
  - The practice ring is about 55 px with a cyan fill, and the "giant" tree is a normal tree (canopy top at about y=150,
    trunk about 15 px).
- Colour: the ring interior should be black (15,15,20) with a subtle glow, not cyan.
- Missing: the blue palms on both sides, the blue cypress cones, the blue crystals.

### p5_diag_ne: 5/10 (3)
- Geometry:
  - This is the best layout match. The gate, basin, lanterns and both stair flights sit where the ref has them.
  - Gate width:height is about 1.0 (355 x 345 px) against about 1.55 (430 x 275 px), so the crest is too high.
  - The ref foreground has a bollard on a tall white pedestal on the diagonal (about 12 studs out) and the dark slate outer
    band of the medallion ring. The practice foreground is a plain pale floor with thin gold lines.
  - The ref lantern glass cores are visible above the gate shoulders. In the practice they are hidden behind the sloping
    shoulder walls.
- Colour: as p1. The ref gate stone is mid grey (150,155,165) with dark inner bevels (70,75,90). The practice is uniform pale
  (190,195,205).
- Missing: the purple and gold trees on the left, the blue tree with crystals behind the gate, the red palm on the right,
  the floating island with waterfalls at top left.

### p6_diag_sw: 5/10 (3)
- Geometry: same as p5. The Expeditions portal (left) and the Story ring (right) are in the right place but too small and
  too neon.
- Colour/lighting: the shadow side of the gate is (70,80,110), which is fine and close to the ref. The ref has warm
  sun-dapple and long tree shadows on the floor; the practice floor is uniformly lit.
- Missing: the grass tufts on the steps, the palms, the giant blue tree, the ring of floating rocks.

### p7_high: 4/10 (3)
- Geometry:
  - The plan matches well: pools, lanterns, stairs, arms, dais.
  - The pools are about 3 studs further out than in the ref.
  - From behind, the crest horns read as grey tombstones on dark blocks.
  - The **edge of the baseplate is visible** at the top of the frame (a hard green line against sky and water).
- Colour: the practice ground is one flat lime green (125,198,104). The ref has zones: blue water and blue foliage to the W,
  red ground (170,70,45) with grey gravel to the E, sand and tall grass (127,172,44) to the S. Its stair stone is pale
  (202,201,183); the practice stairs are bluish (155,164,180).
- Missing: palms (two giant green palms SW, blue palms N), the long N avenue lined with blue palms and cypresses, the
  white stone pillars and gems in the S foreground, all the clutter.

### p8_top: 5/10 (4)
- Geometry:
  - The centre diamond (about 39 studs), the medallion, the pool centres (about +-43 against +-40) and the stair bands all
    match within a few studs.
  - The E and W arms run about 97 studs from the centre against about 82.
  - The terrace blocks at the outer corners are bare grey squares.
  - The SW pool renders almost white (glare).
- Colour: it reads as a clean plaza on a lawn. The ref reads as a plaza inside a dense blue/red/green jungle.
- Missing: the foliage carpet (it covers about 60% of the ref frame), the zone colours, the N water channel to the fountain.

### c1_wall: 4/10 (2)
- Geometry (the clearest proportion check):
  - The practice basin outer rim spans about 700 px against about 470 px. The basin sits about 4 studs nearer the plaza
    centre and in front of the arch, where the ref tucks its back rim under the arch opening.
  - The practice crest runs out of the frame top. The ref crest top is at about y=155 px, about 14 studs above the floor.
  - The ref lanterns stand fully visible either side of the crest (dome about 130 px). The practice lanterns are hidden
    behind the horns, with only their dome tops showing.
- Colour/material:
  - The ref niche has layered dark slate with a gold shelf and a white-blue foamy cascade into an upper basin with a gold
    bar grille. The practice has a single neon cyan slab and spike.
  - The practice water is (141,238,255) against (125,188,204), and its gold (247,227,126) has no dark outline.
  - The ref gate band is (94,102,109) with darker bevel steps; the practice band is flat (134,145,165).
- Missing: the crystals, the blue tree in the crest slot, the coral and blue fern clumps at the basin foot.

### c2_fountain: 3/10 (1)
- Geometry:
  - The camera is on the floor now (fixed since round 1).
  - In the ref the basin sits directly in front of and partly under a **deep barrel vault**: the side view shows 2-3
    stepped ribs and about 6+ studs of depth. The practice gate is a thin 3-stud band, and its basin stands apart to the
    left.
  - A practice stair-foot bollard sits right in the lens (foreground block).
  - The lime glossy blobs on the steps (about 110,230,60) read as plastic.
- Colour: the ref floor tiles are (185,190,195) with dark grout and cracks; the practice is flat pale.
- Missing: the lantern on its big stone drum behind the gate shoulder, the Raid skyline, the blue tree.

### c3_pavilion: 4/10 (1)
- Geometry:
  - The pavilion composition is back.
  - The practice horns (top at about y=355 px) rise **above** the lantern domes (about 390-470 px). In the ref the crest
    (about 435 px) sits **below** the domes (about 350-420 px).
  - The lantern domes are about 80 px across against about 110 px.
- Lighting/sky: the upper 55% of the frame is empty flat blue with a **visible skybox artefact** (a small pale diamond at
  about x=640, y=190). In the ref this area is cumulus clouds, a floating island with waterfalls and ruined towers.
- Missing: everything above the gate: palms, the blue tree, crystals, the skull tower at full height.

### c4_stairs: 5/10 (1)
- Geometry:
  - The step count, the tread depth, the stair-top height and the Y-chevron orientation all match.
  - The ref runner has a **double-line** gold Y on a darker centre panel, and thick white-and-gold kerb rails standing
    proud of the treads.
  - The Summon hall is about 2x too large and too close at the stair top. The ref hall sits far down a long avenue behind
    palms.
- Colour:
  - The runner is (45,150,255) against (65,111,218) with a centre panel of (45,62,150).
  - The kerb gold is pale.
  - The treads match (191,199,209 against 190,192,189), but the practice risers are too light and too blue.
- Missing: the avenue (blue palms, gold trees, lamps, umbrellas), the floating islands with waterfalls.

## Scores
| cam | r1 | r2 |
|---|---|---|
| p1_spawn_n | 3 | 5 |
| p2_spawn_s | 2 | 4 |
| p3_spawn_e | 2 | 4 |
| p4_spawn_w | 2 | 4 |
| p5_diag_ne | 3 | 5 |
| p6_diag_sw | 3 | 5 |
| p7_high | 3 | 4 |
| p8_top | 4 | 5 |
| c1_wall | 2 | 4 |
| c2_fountain | 1 | 3 |
| c3_pavilion | 1 | 4 |
| c4_stairs | 1 | 5 |
| **average** | **2.25** | **4.33** |

## Top-10 fixes (ranked by visual impact)

1. **Fill the frame with foliage at reference density (known gap; the single biggest gap in every view).**
   - Replace the smooth blob canopies with layered, spiky leaf-card or fern-cluster canopies. Colours:
     - blue (40,90,230) with a lighter rim (110,160,255);
     - purple (150,110,210);
     - gold (225,175,50);
     - red (150,30,40).
   - Per quadrant behind the pools: 2 palms 22-28 tall with curved trunks (110,80,50) and 8-10 fronds 8-10 long. Blue
     fronds (60,110,230) W and N, dark red (120,25,30) E, green (110,170,60) S.
   - Plus 3-4 trees 18-24 tall and 2 blue cypress cones (3 wide x 12 tall).
   - Line the N avenue with 6 blue palms per side at 12-stud spacing.
   - Replace the glossy blob clumps with flat fern cards (3x0.5x3):
     - coral (225,85,75) E, blue (70,130,240) W, green (150,210,60) S;
     - 20-30 per quadrant on step edges and at the basin feet;
     - SmoothPlastic or Grass material, never glossy.
2. **Build the skyline and fix the sky.**
   - Replace the flat skybox with a cloudy one: base (110,185,240), large white cumulus in the lower third. Fix the seam or
     artefact visible at screen centre in c3.
   - Scale the floating islands up 3-4x: 60-120 studs across, 15-30 thick, rock underside (130,135,140), grass top, 2-3
     ruin towers or a domed building on top, 1-2 white waterfalls (Neon or Glass, 3-5 wide, 40-60 long) each.
   - Place them 150-300 studs out at heights of 60-140 so they fill the upper third of p1, p2, c3 and c4.
3. **Colour and value pass (cheap, affects every frame).**

   | element | now | target |
   |---|---|---|
   | gold (all) | (253,237,154) | (200,160,45) base, dark outline trims (120,90,20) |
   | runner | (45,150,255) | (65,111,218), with a centre inset panel (45,62,150) about 3 wide |
   | water | (141,238,255) | (110,190,205), Glass or Water-like with Transparency about 0.2 |
   | neon jets and slabs | | (170,225,240) with Transparency 0.4 |
   | gate stone | flat pale | (150,155,165), inner bevel and recessed band (75,80,95) |
   | floor | (221,224,214) | (190,195,198), grout (150,155,160) |
   | stair risers | | (115,125,135) |
   | lantern and blue domes | (30,107,246) | (60,110,210) |

4. **Gate crest and vault proportions.**
   - Lower the crest top from about 16.5 to about 13.5. Make the horns 3-4 wide, rising only 3 studs above the band top
     (about 10.5).
   - Join the horns into one squared U: two pillars and a 4-wide bottom bar at the band top, with the inner slot open, and
     a continuous gold outline (0.4) around the whole U.
   - Deepen the arch from 3 to about 6-7 studs, with 2 stepped inner ribs (each 0.6 inset, darker stone).
   - Keep the outer width at 20-22, so the elevation reads about 1.5:1 (wide).
   - Move each basin about 3-4 studs outward along the diagonal so its back rim sits under the arch opening.
   - In the niche, replace the neon slab with a 3-wide foamy cascade from the gold shelf into an upper basin ringed with
     about 16 gold bars (0.2 x 1.2).
5. **Lantern pavilions to reference scale.**
   - Scale each lantern about 1.45x about its base: dome about 9 across (ribbed), 6 gold columns about 6 tall, glass core
     about 4 across in (90,200,255) Neon behind Glass.
   - Seat each lantern on a stone drum about 7 across x 4 tall (90,95,105) with a gold rim, so the glass core shows above
     the gate shoulders. The spike tip lands at about 30-32.
   - Check in c1 and c3 that the domes appear above the crest.
6. **Landmarks to reference size and material (keep them as blockouts).**
   - Raid (E):
     - a skull tower 35-40 tall above the terrace (skull 10 wide, red neon blade down the face);
     - a pointed gothic arch gate 14 tall;
     - 2 spire towers 20-25 tall;
     - weathered red stone (170,70,60) with dark accents (60,25,30). No primary red.
   - Story (W):
     - a ring about 12 across x 2 thick in silver (190,195,205) with a gold crown, and a black void (15,15,20);
     - a giant tree with a trunk 10-12 across and a canopy 50-60 across, reaching 60-70 above the terrace, about 15
       studs behind the ring.
   - Expeditions (S): a teal (40,140,140) arched portal 14-16 tall with pale-teal columns, two crystal braziers, and a
     ring of 8-10 floating rock slabs (each 4x2x8) about 20 across above it. Remove the full-saturation cyan neon.
   - Summon (N): push the hall about 40 studs further down the avenue (or scale it to 0.65), and add columns, arches and
     a gold dome.
7. **Medallion ring and dais foreground.**
   - Make the blades thinner and darker (40,45,55), as hooked spikes with a pale stone field between them.
   - Shrink the gold disc to r about 1.6 with a dark centre ring.
   - Add a **raised gold ring** around the medallion: about 1 wide, 0.4 proud, r about 9, colour (200,160,45).
   - Outside it, add a dark slate band (60,65,80), about 3 wide, following the dais, with a gold edge, so p1-p6 get the
     ref's dark/gold foreground arc.
8. **Bollards.**
   - Remove the 8 stair-foot bollards; they block c2 and read as clutter at the stair foot.
   - Put 4 bollards on the diagonals at about (+-9.5, +-9.5), on the dais edge facing the gates:
     - a white pedestal (235,235,240) 2.5x2.5 base x 2.3 tall, tapering;
     - a gold dome cap 1.8 across with a dark slot;
     - a stepped plinth 3.5x3.5x0.4.
9. **Ground and terrain.**
   - Hide the baseplate edge, visible in p7, behind terrain or water out to 400+ studs.
   - Replace the flat lime green with zones:
     - W: water and blue-tinted grass (60,120,200);
     - E: red ground (170,70,45) with grey gravel paths (110,110,115);
     - S: sand (220,200,150) and tall grass (127,172,44).
   - Cover the bare grey terrace squares at the outer corners with tile and grass, and add a 6-wide water channel on the
     N avenue.
   - Pull the E and W arm ends in by about 15 studs (to about 82 from the centre).
10. **Lighting and post.**
    - Add contrast so the sun side and the shade side of the gates differ (the ref shade is about 0.55x the lit value):
      Ambient and OutdoorAmbient about (110,115,130) and ShadowSoftness about 0.3.
    - ColorCorrection: Contrast +0.1, Saturation +0.1, TintColor (255,245,230).
    - Bloom: Intensity 0.5, Threshold 1.1.
    - Atmosphere: Density 0.3, Haze 1.5, Color (200,220,255), so the distant landmarks and islands fade.
    - Fix the SW pool glare (pool water Reflectance 0, lower its specular).
    - Recheck Lighting.Technology by hand.
