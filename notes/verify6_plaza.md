# Verify round 6: Anime Expeditions spawn plaza (freestyle, after fix pass 8)

This is the first round scored against the **live reference**. Reviewed on the Shadow PC on 2026-10-10 by an independent reviewer.

## Method
- Reference studio: `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- Practice studio: `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- I used `screen_capture` only and ran no code. Nothing was modified or saved in either studio.
- Captures are `v6_<cam>_ref_a` / `v6_<cam>_ref` and `v6_<cam>_rep_a` / `v6_<cam>_rep`.
- For p4 (both studios) and p6 (reference) the pairs differed, so I took a third capture (`_c`) and judged that one. The
  differences came from animated portals.
- The judged frames are in `out/verify6/v6_<cam>_ref.jpg` and `v6_<cam>_rep.jpg`, 1452x793.
- "Sampled" RGB values are 5x5 averages from those JPEGs. All other colours and every size in studs are estimates from the
  pictures.

## Overall read
**Layout.** The practice plaza has the right bones: the cross plan, four fountain arches with dome kiosks, the runners, the
four landmarks on the right axes, and blue/red/green colour zoning by quadrant. From the spawn, every landmark sits where the
reference has it.

**What separates it from the reference.** It is not one prop. It is **density and enclosure**:
- In every reference frame, the sky above the plaza is filled by huge, close, lush floating islands with towers, vines and
  waterfalls.
- Mid-distance architecture (Guild facade, domed palaces, grey towers) closes every gap between the landmarks.
- The practice has small, far, thin islands and open blue sky. The plaza therefore reads as a clean model on an empty table,
  not as a hub in a city.

**Plaza materials.** The fountain arches in the reference are dark slate with gold edges. The practice arches are pale
grey-blue. This lightens every spawn view and flattens the main near-field shapes.

### Where round 5 (provisional) was clearly off
1. **Islands: wrong direction.** Round 5 said "push the islands back and up".
   - In the live reference they are big and close. In c4 they fill the whole top third of the frame (x≈240-1250,
     y≈0-280 px), with green caps, hanging vines, round green trees, ruin towers and aqueducts, and wide waterfalls.
   - The practice islands are now about 1/3 that size and read as distant ornaments.
2. **Raid: wrong direction.** Round 5 asked for dark weathered stone and a grey-red skull. Pass 8 did that. The live
   reference Raid reads **glowing red**:
   - The skull is a bright red-pink carved head, sampled (203,84,88), with glowing eyes.
   - The facade is lit pink-red, there is heavy red bloom and fog, and the dead trees are black.
   - The pass-8 Raid is a matte brown-maroon brick church. It is more weathered, but less like the reference than the round-5
     pink was.
3. **Treads.** The live reference treads are mid grey, sampled (138,145,150), with dark joints. Practice treads are now
   (118,128,142), which is close enough. The dark element round 5 was reaching for is the **arch and wall panels**, not the
   treads.
4. **Clumps.** Round 5 praised the mounded clumps. In the live reference the foliage on stairs and floor is a **flat leaf
   spill**: low splashes 0.2-0.5 studs high. The practice mounds stand 2-3 studs proud and look like hedgehogs on the steps,
   most clearly in c1, c3, c4 and p6.
5. **Scores.** Round 5 scored p3-p6 at 7 from pictures. Against the live reference the gap in enclosure, density and lighting
   is bigger than the pictures suggested, so those cameras drop to 6.

## Per camera (round 5 provisional -> round 6)

### p1_spawn_n: 7 -> 6
- **Geometry and proportion:**
  - The near field matches: medallion, bollards, two arches with basins, dome kiosks and the runner up the N flight.
  - The Summon hall is a small domed pavilion, about 130 px wide, at the end of the avenue. The reference is a wide ornate
    two-storey facade, about 150 px wide, with a big gold tree mass rising behind it to y≈120.
  - The islands are small slabs at y≈110-230. The reference islands are huge and fill y≈0-150 across the frame, with 3 wide
    waterfalls.
- **Colour and material:**
  - The arch cheeks are pale blue-grey, sampled (134,170,186). The reference is dark slate (67,70,87) with gold edges.
  - The medallion gold is sampled (231,212,94). The reference is deeper, (179,164,61).
  - The medallion is 4-5 broad swirls. The reference has 8 thin hooked dark blades and 8 gold studs.
  - The bollards are tall lilac posts, sampled (182,176,178). The reference bollards are short white (235,237,230) posts with
    a gold ball cap.
- **Lighting:** Practice is flat and even. The reference has bloom, light shafts behind Summon, and glowing blue crystal pods.
- **Missing:**
  - The Guild facade with its 3D "Guilds" letters on the left.
  - Grey palace towers on both sides.
  - The big blue crystal pods on the wall tops.
  - The gold-tree mass.
  - Stall clutter on the avenue.

### p2_spawn_s: 6 -> 6
- **Geometry:**
  - Pass 8 landed here. A shard ring with a white oval now hangs above the gate, and there is an "EXPEDITIONS" plate.
  - The ring is too small and too high relative to the gate: about 170 px across, top at y≈65. In the reference it is about
    170 px but sits closer to the sign.
  - The gate is a single tall teal arched window with mullions, which reads as a greenhouse. The reference is a triptych: a
    centre arch with a dark-teal swirling portal and a statue, two lower side arches, gold filigree and pillars with lanterns.
- **Colour:**
  - The shards are pale sky-blue, sampled (94,176,218). The reference shards are grey stone (100,127,152).
  - The sign is a small flat plate. The reference sign is 3D teal letters about 160 px wide.
- **Missing:**
  - Domed palace towers, upper left.
  - The giant tree on a rock pillar, and the palm, upper right.
  - Island rock masses filling the sky.
  - A tall grass lawn at the top of the flight.

### p3_spawn_e: 7 -> 6
- **Geometry:**
  - The silhouette is right: a central skull tower, two onion towers, a gothic arch and red trees behind.
  - The skull sits on a narrow brick pyramid, about 90 px wide. In the reference the skull is a giant carved statue head,
    about 120 px wide, fused into a large gothic facade. The red beam runs from its mouth down to a 3D "Raid" sign over the
    arch.
- **Colour and lighting:**
  - Practice is matte maroon and brown, sampled (124,53,66), with a brown skull.
  - The reference is lit red-pink with a bright red-pink skull (203,84,88), red neon, red fog and bloom. The courtyard glows.
- **Missing:**
  - The Boss Rush tower and purple portal on the left.
  - Black dead trees.
  - Red palm silhouettes.
  - Red litter as flat spill. Practice has mounds.

### p4_spawn_w: 7 -> 6
- **Geometry:**
  - The Story tree now has a visible brown trunk and a big blue canopy, which is a clear gain.
  - The ring is a thick, deep tube, sampled (54,52,88), with a small "STORY" plate.
  - The reference ring is a thin ornate silver-blue frame (84,113,154) with a crest on top and 3D blue "Story" letters. The
    tree behind is a huge tan trunk (108,87,65) whose branches fill the top centre, with wispy blue foliage.
- **Missing:**
  - About 6 blue palms around the ring. Practice has 3, set further back.
  - The blue crystal pods.
  - The Guild facade on the right.
  - Islands overhead.

### p5_diag_ne: 7 -> 6
- **Geometry:** The composition matches well: arch centre, blue flight on the left, red flight on the right, Summon on the
  left and Raid on the right.
- **Practice gaps:**
  - Summon is a small cream pavilion. The reference is a long ornate two-storey facade with gold letters.
  - Raid is matte maroon. The reference glows red, with a 3D "Raid" sign and a skull keystone.
  - The stair clumps are mounds. The reference has flat spills.
- **Missing:**
  - Purple wisteria trees.
  - Blue cypress cones.
  - The wall of islands with waterfalls at top left.
  - The Boss Rush purple glow.

### p6_diag_sw: 7 -> 6
- **Geometry:**
  - The Expeditions arch and sign sit on the left, and the Story ring sits on the right. Seen from the side here, the ring's
    depth makes it read as a **cannon barrel**.
  - The reference ring is thin.
  - The grass clumps are tidy mounds. The reference has flat grass splashes on the steps and a tall grass lawn along the top.
- **Missing:**
  - The giant palm (top centre in the reference).
  - Island rock with a ruined tower, centre.
  - The blue cypress and palms around Story.
  - The orange autumn tree.
  - The big blue crystal pods on the arch.

### p7_high: 6 -> 5
- **Geometry:** The cross, corner pools, kiosks and runners read correctly, and Summon, Story and Raid are visible landmarks.
- **Practice:** Beyond the plaza it is a flat green plane to the horizon, with sand patches. East is a brown-red dirt field,
  sampled (146,91,89), with red trees.
- **Reference:** It is packed to the frame edge:
  - West: a blue water lagoon with beach and palms.
  - North: an avenue lined with blue cypress cones and palms.
  - East: grey gravel, sampled (104,107,109), with red litter, black dead trees and the Boss Rush building.
  - South: grass with sand, pool toys and white pedestals carrying blue crystals.
- **Colour:** The practice east field is too brown and flat. The reference east is grey ground with red litter.

### p8_top: 6 -> 5
- **Practice from above:**
  - One giant blue tree blob fills the west.
  - The east is brown dirt with red/pink/yellow trees and the Raid block.
  - The N avenue is a plain grey strip.
  - The arms are still short.
- **Reference from above:**
  - A **water channel** runs down the N avenue, with sand beaches either side.
  - The W arm extends to the Story complex, with blue water and a stepped arena.
  - The E arm extends along a grey gravel road to a carved plaza.
  - The south is a white arcaded courtyard.
  - The centre diamond is smaller, with 8 hooked blades.
- **Colour:** The practice palette is more saturated pastel and does not have the reference's grey-gravel structure.

### c1_wall: 6 -> 6
- **Geometry:**
  - The arch and basin framing match well.
  - Practice still has the white egg dome and gold rods in the basin. The reference has a dark slatted drum with water
    falling from a ledge.
  - The kiosk domes and crystals are similar.
- **Colour:**
  - The arch cheeks are pale. The reference is dark slate.
  - The practice vault is blue, sampled (26,54,95). The reference vault is a dark grey (35,45,53) with a gold ledge band.
- **Foliage:** The practice clumps are tall spiky mounds. The reference has flat spills.
- **Background:** The reference has the Summon facade with umbrellas, a ruined tower and an island on the left, and Raid
  with a glowing 3D sign on the right.

### c2_fountain: 6 -> 6
- **Geometry:**
  - The basin still sits forward of the arch, about 4 studs. The reference basin is tucked under the arch mouth.
  - The S flight treads are now a good grey with nosings.
  - The grass mounds on the steps are bulky. The reference has flat splashes.
- **Background:** Raid reads as a castle. In the reference it is a glowing red mass with the Boss Rush sign, dark palm
  silhouettes and grey palaces on the right.
- **Missing:**
  - Floor tile joints and cracked slabs.
  - Falling water.
  - The orange tree and tall grass at the top of the flight.

### c3_pavilion: 6 -> 5
- **Sky:**
  - This camera shows the biggest single gap. In the reference, three huge green-capped islands fill the upper half: ruin
    towers about 150-200 px tall, aqueduct arches, vines and two wide waterfalls on the left.
  - The practice sky is about 70% empty blue, with tiny islands at y≈150-420 on the left and right edges.
- **Raid:**
  - In the reference the skull statue is about 160 px wide with glowing eyes, and the facade glows.
  - In practice the skull is about 130 px wide, brown and matte, on a brick pyramid.
- **Missing:**
  - The ornate Summon facade.
  - Purple wisteria.
  - The red palm.
  - A cumulus mass.

### c4_stairs: 6 -> 5
- **Geometry:**
  - The stairs, runner, kiosks and palm pair match.
  - The reference end of the avenue is a dense wall: gold-tree mass, Summon facade, blue cypress cones, umbrellas, stalls and
    flags. Overhead, islands with waterfalls fill y≈0-280.
  - The practice end is a small pavilion between gold and purple trees, with open sky and small far islands above.
- **Colour:** The blue clumps are good colours but bulky. The treads are fine.
- **Missing:** Big gold trees about 35 studs tall, blue cypress, stall clutter, island mass and waterfalls.

## Scores
| camera | r5 (provisional) | r6 (live ref) |
|---|---|---|
| p1_spawn_n | 7 | 6 |
| p2_spawn_s | 6 | 6 |
| p3_spawn_e | 7 | 6 |
| p4_spawn_w | 7 | 6 |
| p5_diag_ne | 7 | 6 |
| p6_diag_sw | 7 | 6 |
| p7_high | 6 | 5 |
| p8_top | 6 | 5 |
| c1_wall | 6 | 6 |
| c2_fountain | 6 | 6 |
| c3_pavilion | 6 | 5 |
| c4_stairs | 6 | 5 |
| **average** | **6.42** | **5.67** |

The drop is a recalibration against the live reference, not a regression. The pass-8 Raid recolour is the only change that
moved the build away from the reference.

## Top-10 fixes (ranked by visual impact)
1. **Make the floating islands big, close and lush.** (Affects c3, c4, p1, p2, p5, p6 and p4.)
   - Scale each island slab about 3x, to 80-120 studs long.
   - Bring the islands in to about 110-170 studs from the centre, with their undersides about 50-80 studs above the plaza. In
     c4 they should fill the top third of the frame above Summon. In c3 they should fill the centre and left of the sky.
   - Grass caps in (110,170,70), with hanging vine strips (70,140,60), 10-20 studs long, over the edges.
   - Add 4-6 round leafy green trees per island, each 15-20 studs, in (90,160,60).
   - Ruins in grey stone (175,180,175):
     - towers 10x10x50 studs with arched windows;
     - one aqueduct of 4-5 arches;
     - one domed rotunda.
   - Add 2 waterfalls per island, each 6-10 studs wide and 40-60 tall, in (220,240,250) at Transparency 0.2, with mist at
     the foot.
   - Underside rock (150,160,160).
   - Put 3 large cumulus banks (245,245,240) behind.
2. **Close the horizon with mid-distance architecture.** (Affects p1, p2, p4, p5, c3 and c4.) Place 5-6 building blocks
   90-130 studs from the centre, in the gaps between the landmarks:
   - a Guild facade NW, between Summon and Story: cream (225,215,185) with gold (200,170,60) trim, 50x40 studs, with 3D green
     "Guilds" letters;
   - a domed palace SE and SW: blue domes (40,80,170) on cream drums, 40-50 studs tall;
   - 2-3 slender grey towers (150,155,160), each 8x8x60 studs.
3. **Re-light Raid as a glowing red set piece, and enlarge the skull.** (Affects p3, p5, c2, c3 and p8.)
   - Facade lit faces (170,70,75), trim and shade (90,35,45).
   - Replace the brick pyramid with a facade-mounted skull statue about 25 studs wide, carved, in (200,85,88), with Neon eyes
     (255,40,40) and the neon beam from the mouth down to the sign.
   - Replace the "RAID" plate with 3D letters about 16x5 studs in (255,80,80), with a small skull keystone above the arch.
   - Add 3 red PointLights, each range 50 and brightness 3, colour (255,40,40), and a low red fog ParticleEmitter at the base.
   - Make the dead trees black (40,30,35).
   - Add the Boss Rush tower on the left: a dark stone gothic tower about 15x15x40 studs with a purple Neon portal
     (200,80,255) and 3D purple "Boss Rush" text.
4. **Darken the fountain-arch cheeks and banners to slate.** (Affects every spawn and close view.)
   - Change the four arches' cheek, banner and parapet faces from pale grey-blue (about (134,170,186)) to slate (65,72,85).
   - Keep the gold (200,170,60) edges.
   - Keep the arch top rim lighter, at (125,130,135).
   - Vault interior: (35,45,55) instead of blue, with a gold ledge band.
5. **Rebuild the fountain core.** (Affects c1, c2, c3 and p1-p6.)
   - Remove the white egg dome and the gold rods.
   - Use a dark slatted drum (50,60,70) with a gold band.
   - Add a water sheet 4 studs wide in (120,210,235) at Transparency 0.3, falling from a ledge at the back of the vault into
     the drum, plus spray particles.
   - Pull each basin back about 4 studs so it sits under the arch mouth.
6. **Make Summon an ornate facade and back it with a gold-tree wall.** (Affects c4, p1, p5 and c1.)
   - Widen the hall to about 50 studs and raise it to about 30, as a 2-storey arcade:
     - cream (225,210,170);
     - gold frieze (200,170,60);
     - a blue band (50,90,180);
     - a statue in the centre arch;
     - 3D gold "Summon" letters about 20 studs wide.
   - Plant 2-3 gold trees about 35 studs tall, with canopies about 30 studs wide, in (215,170,50), behind and to the left of
     the hall.
   - Line the avenue with 6 blue cypress cones (40,90,220), each about 4x14 studs, plus stalls, umbrellas and flags.
7. **Flatten the foliage into spills and fill the far field.** (Affects c1, c3, c4, p6, p7 and p8.)
   - On stairs and floor, replace the mounded clumps with flat leaf-spill patches 0.3-0.5 studs high and 6-10 studs across,
     with irregular edges:
     - blue (60,130,230);
     - red (220,70,70);
     - green (120,190,60).
   - Add tall grass lawn strips, 2-3 stud blades, along the top of the S and W flights.
   - Far field:
     - W: a blue lagoon (60,170,220) with a sand beach (225,205,150).
     - N: a water channel about 6 studs wide down the centre of the avenue.
     - E: change the brown dirt to grey gravel (104,107,109), with red litter and black dead trees.
     - S: a white arcaded courtyard.
8. **Thin and dress the Story portal.** (Affects p4, p6 and p8.)
   - Cut the ring depth from about 10 studs to 3 so that it stops reading as a cannon in p6.
   - Frame in silver-blue (130,160,210), with blue gems and a crest on top.
   - Replace the plate with 3D "Story" letters (90,150,255).
   - Make the void black, with a slow blue swirl.
   - Recolour the trunk tan (150,115,80) and add 3-4 thick branches spreading into the canopy.
   - Add 3-4 more blue palms around the ring, and 2 big blue crystal pods (40,110,230), Glass, about 4x6 studs.
9. **Rebuild the Expeditions gate as a triptych.** (Affects p2, p6 and p8.)
   - Centre arch about 12x20 studs, with a dark-teal swirling portal (20,110,110) and a statue.
   - Two side arches about 8x14 studs with teal glass (80,180,200).
   - Gold filigree (200,170,60), and lantern posts either side.
   - 3D teal "Expeditions" letters (100,230,200), about 20 studs wide.
   - Recolour the shards from sky-blue (94,176,218) to grey stone (110,125,145), and lower the ring about 5 studs toward the
     sign.
10. **Plaza details.** (Affects p1-p6 and p8.)
    - Medallion: 8 thin hooked dark blades (45,55,65) on pale stone, a gold (180,165,60) Metal centre and a ring of 8 gold
      studs.
    - Bollards: about 3 studs tall, white (235,237,230), with a gold ball-in-cup cap.
    - Floor: a tile grid with dark joints (110,120,125) and a few cracked slabs.
    - Big blue crystal pods on the wall tops beside each kiosk.
    - White pedestals with blue crystals at the S runner end.
