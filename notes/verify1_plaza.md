# Verify round 1: Anime Expeditions spawn plaza (freestyle)

Independent review. Method: `screen_capture` only, 2 captures per camera per studio (frames were identical, last one judged).
Reference studio `ecdeebfb-...`, practice studio `efa46ce6-...`, cameras from `cams.json` / `cams_practice.json`.
No code was run and nothing was modified in either Studio.

Scale note: in the top view (p8, ~157 studs above the floor) 1 px is about 0.28 studs, and both plazas have about the same
overall footprint (corner-to-corner about 115-120 studs). Sizes below are estimates from the pictures.

## Overall read
The plan is right: a sunken cross with a centre medallion, four stair flights with blue runners and four corner features.
At player height it still looks like a different place. The ref corners are open **arched fountain gates with lantern
pavilions**; the practice has closed, curled grey shells with a black inside. Every spawn view ends in **empty sky** where
the ref has a themed landmark. The stairs, runners and blue boxes read as toy-like primitives. The floor is a high-contrast
white tile grid, where the ref uses soft pale stone with slate bands. All four spawn views in the practice are identical,
so the four directions have no identity.

## Per camera

### p1_spawn_n: 3/10
- Geometry: the stair and runner axis matches. Ref corner arches (M-crest, fountain under the arch) are replaced by dark
  curved canopies over side stair flights. The domes sit low on the stair tops with no lantern body. The 4 blue boxes
  (~4x5x2) at the stair foot have no counterpart in the ref (it has small gold bollards on white pedestals).
- Colour/material: the floor is pure white tiles with a grey grid, where the ref has pale grey stone (about 205,208,214)
  with slate bands. The runner is flat blue with a gold rod, where the ref has blue with a gold Y-chevron inlay and kerbs.
- Lighting: flat noon light with hard grid shadows. No bloom, haze or warm fill.
- Missing: the Summon hall at the stair top, gold, blue and purple trees, the floating-island skyline, waterfalls.

### p2_spawn_s: 2/10
- Same frame as p1. The ref has the teal Expeditions portal gate (about 14 studs tall) with crystal braziers at the
  stair top and grass spilling over the stairs. The practice shows only sky.
- Emblem: the ref is 8 curved hooked blades (shuriken swirl) with a flat gold disc. The practice is a 16-point straight
  star with a raised gold dome.

### p3_spawn_e: 2/10
- The ref is dominated by the red Raid zone (skull tower about 30+ tall, red palms, red foliage scattered on the stairs).
  The practice is the same neutral frame. Only a few saturated red blobs hint at the theme.

### p4_spawn_w: 2/10
- The ref has the Story ring portal (about 10 studs across) under a giant blue tree, with blue palms. The practice is the
  same neutral frame with blob trees.

### p5_diag_ne: 3/10
- Ref: in the corner, about 25 studs from the centre, the arched fountain gate faces the plaza with a 2-tier basin, two
  lantern pavilions on the shoulders and a blue tree behind. The stairs flank it. A pedestal bollard sits in the
  foreground on a slate band.
- Practice: the corner object is set back (about 35+ studs) and sits up at the stair top. It is a dark open cylinder with
  a blob tree on a small pedestal. The fat raised yellow bar and big gold half-spheres in the foreground are much heavier
  than the ref's thin gold inlays.

### p6_diag_sw: 3/10
- Same issues as p5. The ref SW corner has grass and the Expeditions/Story portals visible beyond. The practice has
  sky only.

### p7_high: 3/10
- The cross plan reads. The corner shells read as big curled tubes, about 12-15 studs tall walls closed to the outside.
  The ref corners are open rounded-square water pools (about 35x35, low 2-stud rim) with the arch gate on the inner
  corner and lanterns on the pool corners.
- The arms are 45-stud-wide flat tile slabs. In the ref only the N avenue is wide (about 37, with a water channel); the
  E, W and S arms are narrow (about 17 studs) with pointed plus-shaped ends and cyan diamond inlays.
- The ground is a bright flat baseplate (about 120,215,90). The ref has grass, sand and water terrain with themed colour
  zones (blue W, red E). The corner palms are broken (tilted bare trunks with wisps).

### p8_top: 4/10
- Best match: the footprint, centre diamond (about 38 studs) and stair positions are close. The emblem is about
  18 studs vs the ref's about 15. The corner rings are the right size but are closed shells, not pools. The E and W arms
  run about 65 studs long at full width. The ref has no plain tile field, and its runners join into one continuous inlay
  from the centre out.

### c1_wall: 2/10
- The camera is boxed in by huge pale stair slabs at eye height. The practice stairs reach the diagonal and come too close
  to the centre.
- The ref subject (arch crest about 16 studs, fountain basin, ribbed lantern domes with cyan glow) is replaced by a
  black-backed canopy, smooth half-sphere domes and grey capsule posts.
- The red bushes are glossy saturated (about 255,30,30). The ref uses coral fern clumps (about 225,85,75).

### c2_fountain: 1/10
- The practice camera is inside or on the S runner. The runner is a raised steep blue slab, about 1.5 studs above the
  treads, and fills half the frame. The corner fountain the shot is about is not visible.
- In the ref the camera is on the plaza floor, with the fountain basin and arch about 15 studs away.

### c3_pavilion: 1/10
- The look-at point (about 25 studs up) is empty sky in the practice, because the corner piece tops out at about
  10-12 studs. The ref fills the frame with the arch crest and two lantern pavilions (spike tips about 24-26 studs) plus
  tree and crystals.

### c4_stairs: 1/10
- The practice camera is on the runner. The frame shows only a blue plane with a gold pipe.
- The ref shows a 6-7-step stone flight (bevelled blocks) with the runner sitting between stone kerbs at tread level,
  and a gold Y chevron.
- Because the practice stair foot is about 5 studs closer to the centre, the shot is lost.

## Scores
| cam | score |
|---|---|
| p1_spawn_n | 3 |
| p2_spawn_s | 2 |
| p3_spawn_e | 2 |
| p4_spawn_w | 2 |
| p5_diag_ne | 3 |
| p6_diag_sw | 3 |
| p7_high | 3 |
| p8_top | 4 |
| c1_wall | 2 |
| c2_fountain | 1 |
| c3_pavilion | 1 |
| c4_stairs | 1 |
| **average** | **2.25** |

## Top-10 fixes (ranked by visual impact)

1. **Rebuild the 4 corner pieces as arched fountain gates plus open pools.**
   - Remove the curled shells and their black interiors.
   - On each diagonal, centred about (+-18, +-18), place an arch facing the centre:
     - about 16 wide, 12 tall to the arch top, 3 thick;
     - an M crest of two 3-stud horns with a 4-stud slot between them, reaching about 16-17 studs;
     - an opening of about 9 wide x 7 tall with a back wall in dark slate (55,60,75), not black;
     - stone (150,155,165) with 0.4-stud gold (215,175,60) edge trims.
   - In front of the arch, a 2-tier basin: outer about 11 across x 2.5 tall with a gold rim; inner about 6 across, raised
     1.5. Water is (110,200,220), with a glass or neon jet.
   - Behind the arch (outer side), an open rounded-square pool about 35x35 with a 2-stud rim, water 1 stud below the rim,
     and a rock island with a blue tree.
2. **Give every spawn view a destination landmark (block-outs are enough).**
   - N: a cream and gold Summon hall, about 40 wide x 25 tall.
   - S: a teal Expeditions portal gate, about 14 tall with 3 arches.
   - E: a red Raid gate with a skull tower, about 30 tall, red (190,50,50).
   - W: the Story ring portal (about 10 across) under a giant blue tree (about 40 tall).
   - Place them 15-25 studs beyond each stair top. Add 2-3 floating rock islands (60-100 studs up) on the skyline.
3. **Lantern pavilions at the right height.** Per corner, 2 lanterns on the arch shoulders, about 6 studs either side of
   the crest:
   - stone pedestal 4 across x 3 tall;
   - 4 gold columns about 4 tall around a cyan neon/glass core (90,200,255);
   - ribbed blue dome (40,80,190), 4.5 across;
   - gold spike 2 tall, with the tip at about 24-26 studs above the floor.
   - Remove the grey capsule posts.
4. **Stairs, runners and bollards.**
   - Move each stair foot out to about 27 studs from the centre (now about 22).
   - Use 6-7 steps of about 0.75 rise and 2 tread, with bevelled block faces.
   - Make the runner flush with the tread nosings (now about 1.5 studs proud): 7 wide, blue (45,90,200), with 0.5 gold
     kerbs and a gold Y chevron inlay instead of the gold cylinder.
   - Carry the runner as a flush inlay across the floor to the centre diamond.
   - Delete the 8 blue boxes. Put 2 white pedestals (2.5x2.5x1.2, (235,235,240)) with gold dome caps (1.6) at each
     stair foot.
5. **Foliage density (known gap, high impact).**
   - Replace the blob trees with layered, fluffy canopies: blue (40,90,230), purple (150,110,210), gold (225,175,50).
   - Make the corner trees about 18-22 tall, not 8.
   - Recolour the red bushes to coral (225,85,75) and use flatter, fern-like clumps (about 3x1x3).
   - Scatter about 15-20 clumps per quadrant on step edges and against walls, tinted by zone (blue W, red E, green S).
6. **Floor material and trims.**
   - Replace the white tiles (245) with their grey grid with pale stone (205,208,214) slabs about 6x6 and subtle grout
     (175,180,190).
   - Add slate bands (95,105,125), about 3 wide, around the centre diamond and along each stair foot.
   - Replace the raised 1-stud yellow bars and diamond rails with flush gold inlays 0.4-0.5 wide (215,175,60, not
     255,220,0).
   - Shrink the gold half-sphere bollards to about 1.6 across, on pedestals.
7. **Arms and ground.**
   - Narrow the E, W and S arms from about 45 to about 17 wide.
   - End them about 45 studs past the stair top in a pointed plus-shape with cyan diamond inlays.
   - Keep N at about 37 wide and add a 6-wide water channel down its middle.
   - Replace the flat green baseplate (120,215,90) with Terrain grass (90,160,70), sand patches and a water edge.
8. **Lighting, sky and post.**
   - Add a cloud skybox or `Clouds` (Cover about 0.5).
   - Atmosphere: Density about 0.3, Haze about 1.5, Color (200,220,255).
   - Bloom: Intensity about 0.6, Size about 30, Threshold about 1.2.
   - ColorCorrection: Saturation +0.15, warm tint (255,248,235).
   - Raise Ambient and OutdoorAmbient to about (130,140,160) so shadows go soft blue-grey, not grid-black.
   - Check Lighting.Technology by hand.
9. **Centre emblem.**
   - Replace the 16-point straight star with 8 curved, hooked blades (shuriken swirl) in slate (50,60,75).
   - Make the gold centre a flat disc (about 4 across, 0.3 proud), not a dome.
   - Add a ring of 8 small gold studs at a radius of about 7.
   - Shrink the whole medallion from about 18 to about 15 studs.
10. **Palms (known gap).**
    - Fix or remove the broken corner palms (tilted bare trunks with wisps).
    - If kept: 20-25 stud curved trunks (110,80,50) with 8-10 broad fronds, blue-tinted on the W side and dark red on
      the E side, 2 per quadrant behind the pools.
