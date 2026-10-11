# Verify round 30: Anime Expeditions spawn plaza (freestyle, after fix pass 32)

This is an independent review against the **live reference**, done 2026-10-11. I did not build this pass. I read round 29
(`verify29_plaza.md`) to compare camera by camera; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** I used `screen_capture` only. I ran no code, modified and saved nothing, and used no computer use.
- **Captures:** I captured each camera twice per studio and judged the second frame.
  - Judged frames are in `out/verify30/v30_<cam>_ref.jpg` and `_rep.jpg`. First frames are in `out/verify30/raw/<cam>_{ref,rep}_a.jpg`.
  - All 24 judged frames are full size, **1284 x 793**.
  - Between frames 1 and 2, 1.2-4.3% of reference pixels changed by more than 30 levels (water, VFX and crowd). Practice
    pixels changed 0.0-0.4%. The frames match; the differences are animation.
- **Colours:** each is a 5x5 mean from the judged JPEG, given as frame and centre pixel (x,y). Stud sizes are estimates from the pictures.
- **Pass-32 change size** (pixels changed by more than 30 levels, r29 practice frame vs r30 practice frame): p6 10.3%, p8 10.2%,
  p7 9.8%, p4 5.7%, p2 5.4%, p1 4.4%, p5 4.2%, p3 3.8%, c3 3.4%, c1 2.8%, c4 2.2%, c2 0.8%.
  - p3 changed only in its lower half (the floor and bollards); its upper-left quadrant is 1-6%.
  - c2 barely moved (0.8%).
- **Top-half mean HSV saturation** (same PIL metric as rounds 24-29):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r30 | 83 | 100 | 103 | 109 | 91 | 112 | 86 | 102 | 94 | 110 | 92 | 81 |
| rep r29 | 78 | 90 | 87 | 102 | 95 | 100 | 80 | 93 | 102 | 103 | 95 | 91 |
| **rep r30** | **77** | **90** | **86** | **106** | **95** | **105** | **83** | **92** | **103** | **102** | **95** | **91** |

- **p6 gap:** -17 -> -7. This is the biggest gain in the set and comes from the blue canopy.
- **p4 gap:** -7 -> -3.
- **p3:** still -17, now the largest gap. Its sky gap is untouched.
- **p8:** -10. The E red is salmon, not deep red.
- **c4:** +10 hot. The ref read 81 this round.

## Overall read
**Pass 32 closed the two "kind" problems flagged in round 29:**
- **p6 sky:** the open sky is now blue canopy.
- **Bollards:** they are white slabs with a gold taper and dome, matching the ref in kind.

**It also landed the dark fountain niche and a calmer Expeditions portal.**

**What is left:**
- The E-side ground at the top views.
- The p3 sky gap. It was claimed fixed, but it does not show from the p3 camera.
- Three tint items now carried for 2-3 rounds: the lagoon, the S lawn and the Story ring.
- The light arch face and the white jet column on every fountain view.

### Wins that read on screen
- **p6 canopy.**
  - (950,150) moved from sky (209,224,234) to blue canopy (37,80,200); the ref is (11,64,153).
  - (900,200) moved from (178,215,235) to (118,145,212); the ref is (97,125,146).
  - The palm trunks and Story-tree mass now fill the right half as in the ref.
- **Expeditions portal.**
  - p6 (60,300) is (11,141,161) vs ref (15,155,168), on target. It was (0,165,197).
  - p2 (640,330) is (10,160,174) vs (4,131,142). It is closer but still about 30 light. The swirl decal reads.
- **Bollards** (p1-p6). In p5 zoom: white slab, tapered gold base and gold dome. This is the same kind of object as the ref.
  - The gold is on target: (215,186,21) at p5 (640,560) vs (143,123,18) shaded / (216,200,105) lit.
  - The slab clips to pure white: (255,255,255) at p5 (640,610), where the ref slab is shaded (167,164,126).
  - The rep dome is a smooth sphere on a tall taper. The ref is a squatter "eye" ornament.
- **Fountain niche.**
  - c1 (560,400) is (17,34,56) vs ref (20,31,49), on target. It was (61,105,129).
  - The jets now read against the dark niche in c1, c3 and p1-p6.
- **Falls.**
  - They are no longer grey: c3 (60,230) went from (215,219,210) to (226,245,247), and c4 (760,150) is (217,238,243).
  - They read as light blue-white water in c3, c4 and p1. They are still hard-edged and a touch too bright; the ref fall body is (196,240,247).
- **E side** (p7, p8).
  - The red trees are darker maroon. p8 (1100,500) went from (222,154,149) to (195,154,147).
  - Grey path strips now cut the red.
- **Summon bunting** is above the cornice in c4 and c3 and no longer crosses the facade.

### What did not land
- **p3 upper left is still open sky.**
  - (200,200) is (92,166,235) vs a dark tree mass (93,76,58) in the ref.
  - (300,250) is (102,87,85) vs (20,19,24).
  - Whatever dark mass was added is not in this camera's upper-left quadrant (1-6% change there).
- **The E ground at p8 is salmon, not deep red, and lacks the ref's big grey rubble band.**
  - (1050,350) is (239,107,95) vs (144,61,57).
  - (950,400) is (241,73,86) where the ref has grey rubble (95,103,103).
  - The SE corner (1100,650) is (235,118,99) where the ref has dark rock (50,53,51).
- **The Boss Rush facade is mid purple, not dark.**
  - c2 (250,200) is (98,81,135) and the sign/trim (130,220) is (179,90,186).
  - The ref facade is (25,34,46) at (130,220) and (27,20,22) at (160,250), with only magenta glow accents.
- **Not done and still visible:**
  - Lagoon: p7 (260,250) (73,102,165) vs (43,95,147).
  - S lawn: p7 (900,620) (121,188,97) vs (111,181,60).
  - Story ring interior: p4 (620,320) (29,40,54) vs (2,11,16).
  - Summon entry: c4 (640,375) (204,182,107) vs (226,220,158).
  - Summon door: c4 (640,420) (104,93,81) vs a bright door (193,171,115).

## Per camera (round 29 -> round 30)

### p1_spawn_n: 9 -> 9
- **Gains:**
  - The bollards are slabs with a gold taper and dome.
  - The falls in the background read blue-white.
  - The bunting is above the Summon cornice.
- **Geometry:** the ref arch niches show a lit blue water sheet at the back. The rep has a free-standing white jet column.
- **Colour:**
  - The bollard slab clips white, (254,254,252) at (920,540) vs (163,163,125).
  - The jet (640,420) is (81,101,153) vs the ref stair stone (135,143,140). The Summon stair carpet is fine.
  - Saturation is 77 vs 83.
- **Missing:** the ref has a much denser gold tree mass and crowd/props at the Summon.

### p2_spawn_s: 9 -> 9
- **Gains:**
  - The portal is a dark teal door with a swirl. It was flat bright cyan.
  - The bollards are fixed.
- **Remaining:**
  - The portal is still about 30 light, (10,160,174) vs (4,131,142).
  - The ref portal is a tall crystal-teal vortex mass. The rep is a flat door plane.
  - The orb ring still sits on a grey-green island and ivy band: (100,134,113) at (720,200), where the ref shows sky (178,203,215).
  - Saturation is 90 vs 100.

### p3_spawn_e: 9.5 -> 9.5
- **Holds:**
  - The Raid skull tower, red glow and the stair layout read right.
  - The bollards are fixed.
- **Remaining:**
  - The upper left is still open sky, (92,166,235) at (200,200), vs a dark tree mass (93,76,58).
  - The Boss Rush block left of Raid is lighter, (102,87,85) at (300,250), vs (20,19,24).
  - The Raid doorway (640,300) is (99,81,87) vs near-black (5,16,18).
  - Saturation is 86 vs 103, now the largest gap in the set.

### p4_spawn_w: 9.5 -> 9.5
- **Gains:**
  - The blue canopy and palms flank the Story ring.
  - Saturation went 102 -> 106 (ref 109).
- **Remaining:**
  - The ring interior is unchanged at (29,40,54) vs (2,11,16).
  - The ref Story tree trunk is a massive brown trunk rising out of the frame top. The rep tree is shorter, with its canopy at
    the top centre.
  - The upper-right island underside is unchanged at (146,129,139) vs (200,185,141).

### p5_diag_ne: 9 -> 9.5
- **Gains:**
  - The near bollard, the round-29 complaint, is now the right object: a white slab, tapered gold base and dome, at the right height.
- **Remaining:**
  - The slab clips pure white, (255,255,255) at (640,610), vs (167,164,126).
  - The dome is a smooth sphere, not the ref's ornament.
  - The jet is shorter and whiter than the ref's lit sheet.
  - The Raid facade at the right is flatter red.

### p6_diag_sw: 9 -> 9.5
- **Gains:**
  - Blue palms and canopy fill the open sky (see Wins). The Story trunk mass is at the right.
  - The portal is on target, (11,141,161) vs (15,155,168).
  - Saturation went 100 -> 105 (ref 112).
- **Remaining:**
  - (800,250) is still light sky/stone, (187,201,195), vs a dark canopy (66,80,59).
  - The rep canopy is slate-blue and leafier. The ref is saturated royal blue (11,64,153).
  - The Expeditions sign is cropped differently, which is fine.

### p7_high: 9 -> 9
- **Gains:**
  - The W canopy is denser.
  - Saturation went 80 -> 83 (ref 86).
- **Remaining:**
  - The lagoon is unchanged, (73,102,165) vs (43,95,147).
  - The S lawn is unchanged, (121,188,97) vs (111,181,60).
  - The centre plaza reads flat. There are no grey stair masses with gold piping around the four fountains, and the N canal
    at (640,250) is (185,195,190) where the ref shows a blue water course (123,144,191).
  - The E is a red tree forest. The ref E is mostly red ground with grey rubble and a few big red palms.

### p8_top: 9 -> 9
- **Gains:**
  - The red trees are darker maroon.
  - Grey paths break up the red.
- **Remaining:**
  - The E ground is salmon-pink, (239,107,95), vs deep red (144,61,57) and (198,63,53).
  - There is no broad grey rubble band. The ref runs one, about 25 studs wide, east from the E stair: (95,103,103) at (950,400).
  - The SE corner is red where the ref has dark rock (50,53,51).
  - The ref has green-and-white flower patches (124,172,47) inside the red; the rep has none.
  - The W lagoon is (62,89,132) vs ref (109,129,145). The ref W is broken by white surf and stone.
  - Saturation is 92 vs 102.

### c1_wall: 9.5 -> 9.5
- **Gains:**
  - The niche is dark and on target.
  - The jet is a smaller, clearer fan.
- **Remaining:**
  - The arch face is light flat grey, (133,143,145) at (500,300) and (860,300). The ref face is a mid-dark slate, (60,64,60)
    to (89,90,90), with a lighter chamfered inner band and stepped bevels.
  - The jet core is an opaque white column, (233,253,254) at (640,400), vs (190,223,233).
  - There is no water sheet spilling from the back niche. The ref shows one at (640,380), (120,160,176).

### c2_fountain: 9.5 -> 9.5
- **Holds:**
  - The fern, the jet and the stairs.
  - The Raid and palm silhouettes.
- **Remaining:**
  - The Boss Rush facade is mid purple, (98,81,135), and the sign/trim is magenta, (179,90,186). The ref is dark, (25,34,46)
    and (27,20,22), with glow only around the sign. The brief said this was darkened, but c2 changed only 0.8%.
  - The arch face is too light here as well.

### c3_pavilion: 9 -> 9
- **Gains:**
  - The falls are blue-white water, not grey strips, at (226,245,247).
  - The bunting is above the Summon cornice.
- **Remaining:**
  - The falls are hard-edged opaque bars. The ref falls are softer and translucent, with a brighter core (196,240,247) and a
    misty foot.
  - The upper left is still a big white cloud, (228,232,235) at (300,40), vs blue sky (106,205,242).
  - The jet column is bright white, (232,247,248) at (640,600), vs a dark niche with water (51,86,103).
  - The Raid facade is flat red without the ref's carved arches.

### c4_stairs: 9.5 -> 9.5
- **Gains:**
  - The falls are blue-white, (217,238,243) at (760,150).
  - The bunting is clear of the facade.
- **Remaining:**
  - The entry is unchanged, (204,182,107) at (640,375) vs (226,220,158).
  - The door (640,420) is dark, (104,93,81), vs a bright arched door (193,171,115).
  - Saturation is 91 vs 81, 10 hot. The purple and gold canopy around the Summon is denser and more saturated than the ref's.
  - The ref has props (parasols, stalls, crowd) on the stair top; the rep has four parasols.

## Scores
| camera | r29 | r30 |
|---|---|---|
| p1_spawn_n | 9 | 9 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 9.5 | 9.5 |
| p5_diag_ne | 9 | 9.5 |
| p6_diag_sw | 9 | 9.5 |
| p7_high | 9 | 9 |
| p8_top | 9 | 9 |
| c1_wall | 9.5 | 9.5 |
| c2_fountain | 9.5 | 9.5 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **110.5** | **111.5** |
| **average** | **9.208 (9.21)** | **9.292 (9.29)** |

Arithmetic: five cameras at 9 make 45 and seven at 9.5 make 66.5, so the sum is 111.5. 111.5 / 12 = 9.292.

## Top-10 for the next pass (ranked by visual impact)
1. **p3 sky gap (saturation -17, the largest gap).**
   - Add a dark tree or rock mass (93,76,58) about 30 studs tall and 25 studs wide, NE of the plaza: about 60-80 studs out
     along +x, at z -30 to -45. It should cover p3 x 120-300, y 100-280; that area is now sky (92,166,235).
   - Darken the Boss Rush block left of Raid to (25,22,28).
   - Make the Raid doorway near-black (5,16,18); it is now (99,81,87).
   - Check from the p3 camera itself, not from p4 or p6.
2. **E ground (p8, p7).**
   - Retint the salmon red (239,107,95) to a deep red (170,55,50).
   - Run a grey rubble band (95,103,103), about 25 studs wide, from the E stair foot east to the edge.
   - Put a dark rock mass (50,53,51), about 30 x 30 studs, in the SE corner.
   - Scatter 4-6 green flower patches (124,172,47), each about 6 studs, inside the red.
   - Thin the red tree forest in p7 by about a third, so the ground reads.
3. **Arch face (c1, c2, c3, p1-p6).**
   - Darken the flat face from (133,143,145) to a slate (75,80,80).
   - Add a lighter 1-stud chamfered inner band (150,155,155) and one stepped bevel, so the gold trim gets a lit edge.
4. **Lagoon and S lawn (p7, p8), carried two rounds.**
   - Lagoon: (73,102,165) -> (43,95,147).
   - S lawn: (121,188,97) -> (111,181,60), with the blue channel down about 37.
   - Add white surf and stone breaks on the W lagoon in p8.
5. **Jet core (c1, c3, p1-p6).**
   - Make the white column Transparency 0.4 and tint it (150,200,215). It is now (233,253,254); the target is (190,223,233).
   - Add a water sheet (120,160,176), about 4 studs wide at Transparency 0.3, falling from the back niche into the drum.
6. **Falls finish (c3, c4, p1).**
   - Drop the body to (196,240,247).
   - Add a second plane 1.5x wider at Transparency 0.75 for a soft edge.
   - Add a mist part (200,230,235) at Transparency 0.6, about 8 studs wide, at each foot.
   - Turn the c3 upper-left cloud away, or move the skybox, so the ref blue (106,205,242) shows.
7. **Boss Rush facade (c2, p7).**
   - Darken the purple face from (98,81,135) to (35,25,40).
   - Keep the magenta only on the sign and trim, and soften that from (179,90,186) to a glow around dark letters.
8. **Expeditions portal and orb (p2).**
   - Darken the plane about 30, from (10,160,174) to (4,131,142).
   - Give it depth with a second inset plane about 1 stud back.
   - Move the island and ivy band behind the orb down about 10 studs, or the orb up about 8, so the orb hangs against sky (178,203,215).
9. **Summon entry and c4 saturation.**
   - Make the centre entry a bright arched door (226,220,158) with a lit inner door (193,171,115); it is now (104,93,81).
   - Desaturate the purple and gold canopy around the Summon by about 10 (c4 is 91 vs 81).
   - Add 4-6 stalls or lamp posts on the stair top.
10. **Story ring and bollard finish (p4, p1-p6).**
    - Darken the ring interior from (29,40,54) to (2,11,16), carried two rounds.
    - Tone the bollard slab from clipped white (255,255,255) to (225,225,218) or use SmoothPlastic, so it shades like the ref (167,164,126).
    - Swap the smooth dome for a squatter dome, about 0.7 x the current height, with an inset ring.
