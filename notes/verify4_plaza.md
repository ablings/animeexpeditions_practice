# Verify round 4: Anime Expeditions spawn plaza (freestyle, after fix pass 6)

This is an independent review. I used `screen_capture` only and took 2 captures per camera in each studio. The frames were identical
each time, and I judged the last one. Reference studio is `ecdeebfb-...`, practice studio is `efa46ce6-...` (both ids confirmed with
`list_roblox_studios`). Cameras come from `cams.json` and `cams_practice.json`. I ran no code and changed nothing in either Studio.

RGB values marked "sampled" are 5x5 averages read from the saved capture JPEGs. Every other colour, and all sizes, are estimates
from the pictures. Rule of thumb: 1 stud at d studs is about 565/d px wide in a 1284 px frame.

## Overall read
Pass 6 fixed the biggest problem from round 3. The navy and black shading is gone:
- The shaded crest in p6 is sampled (50,61,89), against the ref's (50,57,75).
- The lit crest face in c1 is sampled (130,135,141), against the ref's (131,133,134).
- The vaults are lit, and the basins now have a water sheet and glow.
- The lanterns sit at ref height and have ribbed gold domes.
- The palm trunks are tan, sampled (99,64,45), against the ref's (97,69,40).
- There are 2 palms per avenue side, and the gold, purple and blue trees sit in the right places.

From the spawn, the near-field (gates, basins, bollards, stairs, runners) now reads as the same place. What separates the two is
the far-field and the "hero" set pieces:
1. **The islands read as UFO saucers.** They are smooth inverted cones with a comb of evenly spaced vine strips. The rock is
   slate blue, sampled (51,67,104), where the ref is grey rock (137,148,145). They hang too close and too low: in c4 they fill
   y=30-275 px, where the ref islands are thin, wide slabs with tall ruined towers and real waterfalls.
2. **The Raid landmark reads as a cartoon creature.** It is a pink ball with two black dot eyes on a flat red box. Ref:
   - a carved stone skull with glowing eyes and a red beam,
   - flanking spired towers and an arcade,
   - red haze.
   It shows in p3, p5, c2, c3 and p8, so it costs points in 5 cameras.
3. **Density.** The ref's grass carpets, red bush clumps, umbrellas and stalls are still mostly confetti-sized chips.
4. **The stairs are too light.** Treads are sampled about (186-192,193,194). In the same light the ref is about (73,84,93),
   with pale nosings.

## Per camera (round-3 score in brackets)

### p1_spawn_n: 7/10 (6)
- Geometry/proportion:
  - The gates, crest window, basins, bollards, stairs, runner and avenue now line up almost one-for-one with the ref.
  - The lantern domes sit at the ref height (y about 185-250).
  - The medallion is still 4-5 broad crescent swirls. The ref has 8 thin hooked blades and a ring of 8 gold studs, which the
    practice lacks.
  - The Summon hall at the avenue end is a plain cream colonnade with a gold dome. The ref has an ornate gold and cream
    facade with a sign.
- Colour/material:
  - The medallion gold is sampled (190,180,105), a little pale and flat against (180,165,62).
  - The lantern glass is sampled (54,168,224), which is good.
  - The floor has no tile grout.
- Lighting: this now reads correctly. The vaults glow and the shade is neutral.
- Missing:
  - Islands: the practice islands are 3 huge saucers right overhead. The ref has distant islands with towers and waterfalls.
  - Clouds.
  - Avenue clutter: umbrellas, stalls, banners.
  - Blue crystals floating beside the lanterns.

### p2_spawn_s: 6/10 (5)
- Geometry:
  - The Expeditions portal is now a teal arch with 2 side pillars and crystal braziers. It is about 95 px tall to the top
    of the arch, where the ref is about 165 px including the finial.
  - The ring is now 8 rectangular grey boxes sitting directly on top of the arch. The ref ring is curved crescent shards
    about 150 px across, centred about 80 px higher, around a white oval glow.
- Colour: the gate stone matches the ref slate. The bollards are a lilac grey, where the ref is white.
- Missing:
  - The grass lawn at the top of the stairs.
  - Big grass spills over the steps. The practice has thin green flecks.
  - The giant palm and the big tree on rock at the top right.
  - The domed towers and the misty rock spires on the left.
  - The middle of the sky is empty.

### p3_spawn_e: 6/10 (5)
- Geometry:
  - The Raid tower now has height (top at y about 100 against about 30 in the ref).
  - It has a gothic arch entry, a pediment with a gold disc, and two needle spires.
  - The silhouette is only about 135 px wide. The ref complex is about 440 px with side towers, an arcade wing and many spires.
  - The "skull" is a smooth pink ball with two black dots, and reads as a cartoon blob.
- Colour:
  - The wall is flat, sampled (184,78,81), and the head (209,105,104).
  - The ref is darker weathered stone, (92,40,48) in shade, with a grey-red skull (124,85,72) and neon red eyes and beam.
- Lighting: there is no red haze or glow. The ref is drenched in red light.
- Missing: the "Raid" sign, the dead trees, the dense red bush clumps on the steps (the practice has scattered flecks), the
  Boss Rush tower on the left.

### p4_spawn_w: 6/10 (5)
- Geometry:
  - The big blue tree centres the view. Its trunk now flares, but it is about 75 px wide with 3 stub branches. The ref trunk
    is about 200 px, with large twisting branches into a canopy that fills the top of the frame.
  - The Story ring is about 95 px, which is the right size. It sits on a dark brown plinth.
  - There are 2 blue palms now, against about 6 in the ref.
- Colour:
  - The ring void is navy, sampled (13,25,75), where the ref is black (0,9,16).
  - The plinth and lower trunk are near black, sampled (40,33,48). The ref is (88,74,62).
- Missing: the gold crown and "Story" sign, the grass lawn and stair grass, the fluffy blue trees and crystals around the ring,
  and the Guild facade on the right.

### p5_diag_ne: 7/10 (6)
- Geometry:
  - This is still the best match. The gate, basin, bollard, both runner arms and both flights are where the ref has them.
  - The gate is about 345 x 240 px against about 405 x 280 px. It is a touch small, sitting about 20 px high, and the basin
    is smaller too.
  - The bollard is a tall plain white post. The ref is short, with a bevelled gold cap.
- Colour: the stone and runners are good. The Raid wall on the right is a flat salmon red.
- Missing:
  - The ornate Summon facade on the left (the practice has a sand box).
  - Dense purple and gold trees with umbrellas.
  - Big blue and red bush clumps at the stair feet.
  - The skull, sign and glow on Raid.

### p6_diag_sw: 6/10 (5)
- Geometry: the layout is correct.
- Colour/lighting:
  - This is the big win of this pass. The shaded gate is now readable slate: the crest is sampled (50,61,89), against the
    ref's (50,57,75), and the gold bevels show.
  - The vault glows.
- Missing:
  - The grass carpets on both flights and on the floor, which are the ref's dominant colour here.
  - The ornate Expeditions arch with its "Expeditions" sign. The practice shows a plain teal arch and grey boxes.
  - The Story tree's foliage on the right.
  - Background: the horizon at y about 385 is empty sky and sea, where the ref is filled with trees and towers.

### p7_high: 6/10 (5)
- Geometry:
  - The sunken cross, corner pools with lanterns, medallion diamond and runners read well.
  - The lantern domes are about 95 px against about 75 px, a bit large from this height.
- Colour/material:
  - The ground is now organic patches, which is better: grey gravel east, grass west and south, sand patches.
  - The grass is teal-green, sampled (113,172,129). The ref grass is a warm yellow-green, (151,177,73).
- Horizon:
  - The far ground is a flat green plane with large dark teal ellipses, sampled (49,105,125), that read as holes or shadows.
  - White pole waterfalls hang in the sky.
  - The ref has buildings out to the frame edge.
- Missing:
  - West: water channels and blue bushes.
  - East: dense red litter (the practice gravel is mostly bare).
  - South: the big foreground palm with a sand patch.
  - The avenue clutter.

### p8_top: 6/10 (6)
- Geometry:
  - The pool centres match within about 5-10 px.
  - The E and W arms end at about x=390 and x=820. The ref continues each one onto an upper landing, with a runner and a
    glowing end, to about x=350 and x=935. That is about 30 studs of landing missing on each side.
  - The centre diamond is about 170 px against about 130.
  - The stair blocks still show a brick grid.
- Colour/material:
  - East is grey gravel, sampled (139,144,150), with a few red trees and 2 large flat, saturated red plates (237,75,93).
    The ref is about 60% covered in red litter (152,86,76) to (190,45,40), with green islands.
  - West is plain grass with blue trees. The ref is a patchwork of blue foliage, water, white flowers and stone.
- Missing:
  - The north water channel with sand beaches.
  - The south arcaded courtyard.
  - The Raid "head" sticks out east as a long tube with a pink sphere. It reads as a worm from above.

### c1_wall: 6/10 (5)
- Geometry:
  - The crest window is now right: a notch about 170 px against about 150 px.
  - The arms are flat-topped boxes. The ref arms hook inward at the top.
  - The basin is about 30% larger in frame (320-960 px against 410-900 px).
  - The upper bowl is a tall cylinder with gold vertical rods. The ref is a smaller bowl with a dark slatted grille.
- Colour:
  - The crest stone matches: sampled (130,135,141) against (131,133,134).
  - The gold is now yellow, sampled (204,176,59), but flat. It has no metallic highlight.
  - The steps are much too light: sampled (186,193,194) against the ref's (73,84,93).
- Lighting: the vault is a bright blue room, sampled (20,39,71) with a blue light. The ref is a grey vault (30,42,61) with a
  gold ledge band.
- Water: a glowing white dome or "egg" sits in the upper bowl. The ref has a wispy blue spray and a sheet falling over the ledge.
- Missing: the blue tree and crystals between the lanterns are small and sparse, and the blue and red bush clumps at the basin
  foot are confetti here.

### c2_fountain: 5/10 (4)
- Geometry:
  - The basin now stands forward, but overshoots. Its centre is about 160 px left of the arch centre, about 6-7 studs forward.
    In the ref it is about 50 px, so the basin rim tucks under the arch.
  - The arch reads as a blue-lit tunnel.
- Material:
  - The angled cyan slab is gone (good). The new water dome reads as a glowing ball.
  - The stairs are light and blocky.
  - A slate gutter, sampled (78,95,113), still runs under the camera.
  - The floor has no tile grid.
- Background: the Raid blob is very prominent at the top left.
- Missing: the falling water, the cracked floor slabs, solid grass clumps (the practice has scattered chips), the Boss Rush
  tower, and depth.

### c3_pavilion: 5/10 (5)
- Geometry:
  - The gate and lanterns are framed like the ref.
  - The palms now lean sensibly, which fixes the splayed bundle.
- Sky:
  - The islands now have green caps, but they are rounded saucers with comb vines. The rock is sampled (51,67,104), against
    the ref's (137,148,145).
  - Each island has one stub tower, about 20 px tall. The ref has ruined arched towers about 150 px tall.
  - The waterfalls are thin white poles.
  - The right half of the sky is empty except for the Raid blob. The ref has big cumulus (241,242,236), ruins, islands and
    the skull tower.
- Missing: the ornate Summon facade, the umbrellas and stalls, the dead red tree.
- The sky upgrade is offset by the Raid head, which dominates this frame, so the score is unchanged.

### c4_stairs: 6/10 (5)
- Geometry:
  - The stair, runner and lanterns are a near-exact match. The palms are right in count, colour and lean, and the gold and
    purple trees are in place.
  - The runner is about 30% too wide at the bottom of the frame: about 640 px against about 485 px.
  - The Summon hall is too close and plain: about 235 px wide, with no sign or towers.
  - The 3 island saucers sit right above the avenue (y=30-275 px). The ref islands are higher, flatter and farther away.
- Colour:
  - The steps are too light and uniform. The ref has a darker tread body with pale nosing.
  - The sky is sampled (78,174,222), against (65,193,242) with large clouds.
- Missing: the umbrellas, the pineapple house and stall clutter, the blue cypress cones, the waterfalls straight ahead, the
  big gold tree mass.

## Scores
| camera | r3 | r4 |
|---|---|---|
| p1_spawn_n | 6 | 7 |
| p2_spawn_s | 5 | 6 |
| p3_spawn_e | 5 | 6 |
| p4_spawn_w | 5 | 6 |
| p5_diag_ne | 6 | 7 |
| p6_diag_sw | 5 | 6 |
| p7_high | 5 | 6 |
| p8_top | 6 | 6 |
| c1_wall | 5 | 6 |
| c2_fountain | 4 | 5 |
| c3_pavilion | 5 | 5 |
| c4_stairs | 5 | 6 |
| **average** | **5.17** | **6.00** |

## Top-10 fixes (ranked by visual impact)
1. **Rebuild the islands as the ref's distant rock slabs.** (Affects p1, p2, p3, c3 and c4.)
   - Recolour the rock from (51,67,104) to (137,148,145).
   - Reshape each island from a round cone to a wide, irregular slab, about 3:1 width to depth, with a jagged underside.
   - Move them about 1.5x farther out and about 30 studs higher, so that in c4 they sit at y=0-180 px instead of 30-275.
   - Replace the evenly spaced vine comb with 3-5 clustered vine curtains per island.
   - Raise the stub towers to ruined white towers about 8x8x40 studs, with arched openings.
   - Make the waterfalls 3-4 studs wide, translucent (200,230,245), Transparency 0.3, with mist at the foot. They should not
     be thin poles.
   - Add 4-6 large cumulus cards (241,242,236) behind them, and fill the empty right half of c3.
2. **Replace the Raid head and widen the complex.** (Affects p3, p5, c2, c3 and p8.)
   - Replace the pink ball and dots with a carved skull, about 10 studs wide, in (125,85,72): deep eye sockets with neon
     (255,50,50) cores, a red neon beam down the face, and a "Raid" sign plate.
   - Darken the walls from (184,78,81) to (150,65,65), with (92,40,48) trim.
   - Add 2 side towers with spired domes, about 30 studs tall, and a low arcade wing about 20 studs to each side, so the
     complex reads about 3x wider in p3.
   - Add a red PointLight (range 40, brightness 2) and a red ParticleEmitter haze.
   - Shorten the tube sticking east (p8).
3. **Turn the confetti into ref-style clumps and carpets.**
   - On each flight, place 6-10 mounded clumps, 3-5 studs across and 0.5-1 stud tall:
     - South and west flights: grass carpets that cover 40% of the treads and spill onto the floor.
     - East flight: red bushes (190,45,40).
     - North flight: blue bushes (40,90,230).
   - Recolour the grass from teal (113,172,129) to yellow-green (150,178,75).
   - Add a grass lawn strip at the top of the S and W flights.
4. **Darken the stairs.**
   - Set step bodies and treads from (190,194,194) to about (110,118,128).
   - Add a 0.3-stud pale nosing (190,192,190) on each step edge, and risers at (75,85,95).
   - This affects p1-p6, c1, c2 and c4.
5. **Rebuild the Summon hall as an ornate facade, and fill the north avenue.**
   - Move the hall back about 15 studs.
   - Make it a cream (215,195,140) facade about 40 studs wide and 30 tall, with 3 arched bays, gold (200,172,60) trim, 2
     corner towers and a "Summon" sign.
   - Add 4-6 umbrellas and stalls, plus 2-3 blue cypress cones, along the avenue.
   - Narrow the north stair runner by about 25% (about 1.5 studs) to match c4.
6. **Upgrade Expeditions.**
   - Scale the arch about 1.7x (to about 20 studs tall).
   - Add stained-glass panels (teal (60,170,170), pale trim (190,235,230)) and a sign.
   - Replace the 8 rectangular boxes with 8 curved crescent rock shards, on a ring of radius about 12 studs, centred about 10
     studs above the arch top, around a white oval glow.
   - Add a grass lawn in front.
7. **Finish Story.**
   - Make the ring void black (0,9,16) instead of (13,25,75).
   - Add a gold crown and a "Story" sign above the ring.
   - Recolour the plinth and lower trunk from (40,33,48) to (88,74,62).
   - Thicken the trunk 2.5x and add 4-5 large twisting branches into the canopy, scaling the canopy about 1.4x.
   - Add 2 more blue palms on each side of the ring.
8. **Fix the basin, water and vault.**
   - Pull each basin back about 4 studs toward its arch, so the rim tucks under the opening (c2).
   - Shrink the basin about 20% (c1).
   - Replace the glowing white dome with a ParticleEmitter spray (light blue (170,220,240), short and wispy) and a thin
     water sheet over the upper ledge.
   - Make the upper bowl lower, with a dark slatted grille instead of gold rods.
   - Vault interior: change from (20,39,71) with a strong blue light to grey (30,42,61) with a gold ledge band. Lower the
     vault light to brightness about 0.8.
9. **Ground and horizon.**
   - Delete the dark teal ellipses on the horizon (49,105,125) and hide the edge of the green plane (p7).
   - Replace the 2 saturated red plates (237,75,93) with scattered red litter (190,45,40) covering about 60% of the east gravel.
   - Add 2 water channels (90,170,200) with blue shrubs on the west.
   - Add the E and W upper landings: a runner about 25-30 studs long past each stair top, ending in a glowing tile (p8).
   - Shrink the centre diamond about 20%.
10. **Medallion and stone detail.**
    - Redraw the medallion as 8 thin hooked blades in (40,45,55), each about 1 stud at the root, tapering to a curl.
    - Add a ring of 8 gold studs at about 70% radius.
    - Darken the medallion gold to (180,165,62), with Metal material.
    - Hook the tops of the crest arms inward by about 1 stud.
    - Add a 4-stud tile grout grid (165,170,172) to the floor, and change the slate gutter in c2 to cracked pale slabs.
    - Make the bollards shorter (about 3 studs) with a bevelled gold cap.
