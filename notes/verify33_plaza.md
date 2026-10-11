# Verify round 33: Anime Expeditions spawn plaza (freestyle, after fix pass 35)

This is an independent review against the **live reference**, done 2026-10-11. I did not build this pass. I read round 32
(`verify32_plaza.md`) to compare camera by camera; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code run, nothing modified or saved, no computer use.
- **Captures:** each camera twice per studio; the second frame is judged.
  - Judged frames: `out/verify33/v33_<cam>_ref.jpg` and `_rep.jpg`. First frames: `out/verify33/raw/<cam>_{ref,rep}_a.jpg`.
  - All 24 judged frames are full size, **1284 x 793**.
  - Frame 1 vs frame 2 (pixels changed by more than 30 levels): reference 1.2-4.8% (water, VFX, crowd); practice 0.0-0.3%.
    The frames match; the differences are animation.
- **Colours:** 5x5 mean from the judged JPEG, given as (x,y) ref vs rep. Stud sizes are estimates from the pictures.
- **Animated jet:** c1 (640,380) swings (144,187,202) -> (12,31,42) between the two ref frames, and c3 (640,600) swings
  (135,189,205) -> (57,95,113). Jets are judged by shape and size.
- **Pass-35 change size** (pixels changed by more than 30 levels, r32 practice frame vs r33 practice frame):
  p1 8.1%, p3 5.2%, p4 5.1%, p5 4.6%, c1 4.2%, c3 4.2%, p8 4.1%, p7 3.3%, p2 2.3%, c2 2.0%, p6 1.5%, c4 0.9%.
- **Top-half mean HSV saturation** (same PIL metric as earlier rounds):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r33 | 81 | 99 | 102 | 109 | 90 | 111 | 88 | 97 | 94 | 110 | 94 | 80 |
| rep r32 | 86 | 97 | 95 | 114 | 98 | 109 | 82 | 90 | 110 | 104 | 98 | 90 |
| **rep r33** | **87** | **97** | **96** | **113** | **97** | **109** | **81** | **88** | **105** | **103** | **98** | **91** |
| gap r33 | +6 | -2 | -6 | +4 | +7 | -2 | -7 | -9 | **+11** | -7 | +4 | +11 |

- c1 dropped from +16 to +11. p5 barely moved (+8 -> +7).

## Overall read
Pass 35 is a broad clean-up pass. It landed several long-carried items:
- **N canal:** now a blue strip. p7 (640,250) (186,195,191) -> (108,145,214), ref (123,145,192).
- **Lagoon:** sand-and-rock banks over the N half. p8 (260,240) (62,89,131) -> (138,140,116); p7 (300,250) is now bank (125,138,117).
- **Flower patches:** on target. p8 (910,510) (98,152,78) -> (138,193,100), ref (141,182,93).
- **Bollards:** aged gold, squat dome. p5 (640,560) (215,186,21) -> (147,120,19), ref (144,123,19): on target. p1 (360,520)
  (208,183,25) -> (134,109,20), ref (76,66,10).
- **c1 jet base:** dimmer. (640,420) (161,203,214) -> (72,136,165).
- **c2 teal sheet:** now shows behind the jet. (600,400) (6,26,42) -> (73,121,146).
- **Ledge:** the stepped light-grey ledge reads on the outer rim in c1, p1 and c2 (far arm). The arches now have a lit edge.

What still costs points, in order:
1. **The arch outer face is still a dark navy slab.** The ledge sits on the outermost rim only. The broad band between the gold
   pipes is unchanged:
   - c1 (340,300) (41,52,59) vs the ref's lit shoulder (178,171,168).
   - c2 (560,200) (41,49,69) vs (100,114,135).
   - p1 (120,250) (55,68,91) vs (103,105,118).
   - The flat front face is still too light: c1 (500,300) (88,101,110) vs (60,64,60).
   - The U arms (c2, p1, p3) have no ledge.
2. **New artefact: bare trunk poles.** Raising the notch-tree crowns and thinning the lower third exposed a straight brown pole:
   - p3 (205,120) (70,142,236) -> (61,51,55); ref royal blue (21,69,205).
   - c3 (630,250) (97,155,225) -> (103,84,73); ref (47,115,240).
   The ref trunk branches into the crown; a bare vertical stick reads as unfinished.
3. **Carried items:** the p2 orb and pillars, falls and the c3 cloud, the Raid door and wash, the Summon entry and the p6 portal.

## Per camera (round 32 -> round 33)

### p1_spawn_n: 9.5 -> 9.5
- **Gains:**
  - The ledge gives the arch a light top edge.
  - The bollard is aged gold with a squat dome: (360,520) (208,183,25) -> (134,109,20), ref (76,66,10).
  - The pool is less white: (240,420) (184,239,246) -> (144,209,224); the ref frame is (159,214,237).
- **Remaining:**
  - The face band between the pipes is still dark: (120,250) (55,68,91) vs (103,105,118); (150,330) (56,66,81) vs (84,86,99).
  - The gold tree mass behind the stair is missing: (500,180) is blue (92,120,172) vs gold (183,142,70).
  - Saturation +6.

### p2_spawn_s: 9 -> 9
- Pass 35 changed little here (2.3%).
- **Unchanged:**
  - The orb hangs against the island band: (720,200) (101,135,113) vs sky (187,209,215).
  - The orb is pure white: (680,130) (255,255,255) vs (120,145,165).
  - The cyan pillars: (560,330) (87,226,243) vs (107,124,132).
  - The portal: (640,330) (12,144,158) vs (4,116,129).

### p3_spawn_e: 9.5 -> 9.5
- **Gain:** the NE crown now covers the upper-left: (150,120) (141,166,153) -> (67,125,219), ref (16,63,205).
- **Loss:** a bare straight trunk pole now stands in the crown: (205,120) (61,51,55), (205,60) (56,49,52) vs blue/sky.
  The crown is also paler: (250,150) (34,73,190) -> (75,122,203), ref (43,93,208).
- **Unchanged:**
  - The Raid wash is hot: (640,150) (253,41,54) vs (243,138,135).
  - The door: (640,330) (31,44,53) vs (0,11,18).
  - The arch face: (150,330) (92,105,115) vs (134,135,139).
- Net: hold.

### p4_spawn_w: 9.5 -> 9.5
- **Unchanged:**
  - The Story crown is dark and low: (640,100) (36,75,159) vs (96,114,207).
  - The ring interior: (640,330) (13,22,31) vs (0,9,16).
- (1000,100) is still blue foliage (92,163,238) vs a pale island (210,234,235).

### p5_diag_ne: 9.5 -> 9.5
- **Gains:**
  - The bollard is on target: (640,560) (147,120,19) vs (144,123,19).
  - The crown over the arch is thinner: (640,100) (53,101,193) -> (53,89,160); the ref is (35,92,222).
- **Remaining:**
  - The lit arch face: (560,330) (101,107,104) vs (76,81,82).
  - The Raid door: (1200,300) (29,41,50) vs (2,11,16).
  - The ref's gold tree/crowd at the left is missing.
  - The jet base: (640,420) (202,233,210) vs (117,193,217).
  - Saturation +7.

### p6_diag_sw: 9.5 -> 9.5
- 1.5% change.
- **Unchanged:**
  - The portal: (60,300) (12,128,149) vs (1,81,93).
  - (800,250) (188,202,195) vs a dark canopy (66,80,59).
  - (620,200) blue crown (47,93,204) vs sky/stone (104,140,127).

### p7_high: 9 -> 9.5
- **Gains:**
  - The N canal is blue water, on target.
  - The lagoon N half has sand/rock banks: (300,250) is bank (125,138,117). The ref there is blue water (41,75,124), but the overall
    lagoon read is now sand + rock + water, like the ref.
  - The SE sand patch reads.
- **Remaining:**
  - The SE sand is pale cream (237,212,159) at (1000,650) and sits on the red/green boundary with hard round edges; the ref there is
    lawn (98,180,48).
  - The W foreground is still saturated blue: (150,300) (50,133,250) vs sandy rock (114,108,65).
  - The plaza centre: (640,420) (103,113,120) vs (195,196,174).
  - The E red: (950,280) (168,87,91) vs (163,60,66).
  - Saturation -7.

### p8_top: 9.5 -> 9.5
- **Gains:**
  - The lagoon has sand islands with rocks.
  - The flower patches are on target.
  - The SE rock now has facets and red bits instead of a flat clover.
- **Remaining:**
  - The SE rock is still a hard-edged black disc, about 14 studs wide: (1100,640) (54,63,68) vs (144,129,115). The ref is grey rock
    with lit tops under a big red palm.
  - The lagoon water is still navy: (200,300) (58,89,156) vs (75,86,53).
  - The E field has no ochre: (1000,300) (118,184,76) vs (143,119,50).
  - Saturation -9.

### c1_wall: 9.5 -> 9.5
- **Gains:**
  - The ledge gives a light outer rim.
  - The crown thinning shows sky/stone at (640,120): (49,46,46) -> (113,129,157); the ref is (140,148,118).
  - Saturation 110 -> 105.
  - The jet base is dimmer.
- **Remaining:**
  - The shoulder band between the pipes is navy: (340,300) (41,52,59) vs (178,171,168).
  - The front face is too light: (500,300) (88,101,110) vs (60,64,60).
  - The jet now reads as a translucent rectangular box, not a plume; the ref is a rounded, frothy plume about 3 studs wide.

### c2_fountain: 9.5 -> 9.5
- **Gains:**
  - A teal water sheet is visible in the niche: (600,400) (73,121,146).
  - The ledge reads on the far arm as a light stepped rim.
- **Remaining:**
  - The near U arm is still near-black: (560,200) (41,49,69) vs (100,114,135).
  - The arch is still smaller than the ref's (about 380-800 px wide vs 450-920).
  - The Raid wash is hot.
  - Saturation -7.

### c3_pavilion: 9 -> 9
- **Loss:** the centre tree now shows a bare straight pole: (630,250) (103,84,73) and (600,300) (136,144,154) vs blue crown
  (47,115,240) / (19,67,208).
- **Unchanged:**
  - The cloud: (300,40) (228,232,235) vs (102,205,241).
  - The falls bars: (60,230) (226,246,247) vs (157,169,156).
  - The recess under the arch: (640,500) (161,177,187) vs (60,65,80).
  - The door: (1200,450) (28,39,49) vs (3,12,17).
- The jet is now teal and translucent, better in value: (640,600) (63,130,164).

### c4_stairs: 9.5 -> 9.5
- Not touched (0.9%).
- The entry: (640,410) (170,153,103) vs (197,168,101).
- The canopy: (640,350) (229,214,153) vs (117,159,177).
- (200,400) is gold (208,195,153) vs the ref's blue cypress (66,120,232).
- Saturation +11.

## Scores
| camera | r32 | r33 |
|---|---|---|
| p1_spawn_n | 9.5 | 9.5 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 9.5 | 9.5 |
| p5_diag_ne | 9.5 | 9.5 |
| p6_diag_sw | 9.5 | 9.5 |
| p7_high | 9 | **9.5** |
| p8_top | 9.5 | 9.5 |
| c1_wall | 9.5 | 9.5 |
| c2_fountain | 9.5 | 9.5 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **112.5** | **113** |
| **average** | **9.375 (9.38)** | **9.417 (9.42)** |

Arithmetic: two cameras at 9 make 18 and ten at 9.5 make 95, so the sum is 113. 113 / 12 = 9.4167.

## Top-10 for the next pass (ranked by visual impact)
1. **Arch outer band: light it (c1, c2, p1, p3, p5).**
   - Recolour the wide band between the gold pipes from navy (41,52,59)/(41,49,69) to a mid stone grey (100,112,128).
   - Widen the stepped ledge to about 2 studs, so it reads as the ref's lit shoulder (178,171,168) in c1 at (340,300).
   - Run the ledge along the U arms too (c2 (560,200) -> (100,114,135); p1 (120,250) -> (103,105,118)).
   - Darken the flat front face from (88,101,110) to about (62,66,64) (c1 (500,300)); p5 (560,330) target (76,81,82).
2. **Fix the bare notch-tree poles (p3, c3, c1).**
   - Add 3-4 crown clusters of about 3-4 studs, colour (33,73,189), around the exposed trunk from mid-height up.
   - Or split the trunk into 2-3 angled branches of about 0.6 stud.
   - Targets: c3 (630,250) (103,84,73) -> (47,115,240); p3 (205,120) (61,51,55) -> (21,69,205).
   - Keep the c1 top-centre gap (140,148,118) open.
3. **p2 orb and Expeditions portal (p2, p6): carried four rounds.**
   - Raise the orb about 8 studs, or lower the island band 10, so (720,200) shows sky (187,209,215).
   - Orb (255,255,255) -> (220,235,240), Transparency 0.3.
   - Pillars (87,226,243) -> (107,124,132).
   - p6 portal (12,128,149) -> (1,81,93), with a darker teal swirl.
4. **Raid door and wash (p3, p5, c3, c2).**
   - Door interior to (3,10,16); it is (28-31,39-44,49-53).
   - Wash (253,41,54) -> (243,138,135) at half brightness.
   - Add 3 carved arch recesses (60,20,25), about 3 studs wide, on the c3 facade.
5. **c3 sky and falls.**
   - Rotate the skybox, or remove the cloud, so (300,40) reads (102,205,241).
   - Falls (226,246,247) -> (196,240,247) at Transparency 0.4, with a 1.5x wider plane at 0.75 and a mist part (200,230,235)
     about 8 studs wide at each foot.
   - Darken the recess under the arch (640,500) from (161,177,187) to (60,65,80).
6. **SE rock and SE sand (p8, p7).**
   - Break the disc's round outline: spread 4-6 rocks over about 18 x 12 studs at 2-5 stud heights, lit tops (144,129,115).
   - Put one big red palm over it.
   - Cut the SE sand patch to about 60% of its size and tint it (192,171,116).
   - Restore lawn (98,180,48) at p7 (1000,650).
7. **Fountain jet shape (c1, c3, p5).**
   - Replace the rectangular translucent box with a rounded plume: 2-3 stacked rings or a cone, about 3 studs wide and 4 tall.
   - Colour (175,221,233), with the top frothy/white and the base Transparency 0.6.
8. **Summon side (c4, p1, p5).**
   - Add a gold tree mass (183,142,70) of about 12 studs behind the N stair (p1 (500,180)).
   - Brighten the c4 entry (170,153,103) -> (197,168,101).
   - Turn the canopy at (640,350) (229,214,153) to blue/sky (117,159,177).
   - Add 2 blue cypress (66,120,232) flanking the stair top, about 8 studs tall.
   - Add 4-6 stalls or lamps.
9. **Lagoon water and W foliage (p8, p7).**
   - Lagoon navy (58,89,156) -> green-teal (75,86,53) at its edges.
   - Thin the W blue foreground foliage, so p7 (150,300) (50,133,250) shows sandy rock (114,108,65).
   - Add ochre (143,119,50) patches in the E field (p8 (1000,300)).
10. **Story tree and p6 canopy (p4, p6).**
    - Lift the Story crown about 5 studs and lighten it, (36,75,159) -> (96,114,207).
    - Show 2-3 branching trunk arms above the ring.
    - Fill p6 (800,250) (188,202,195) with dark canopy (66,80,59).
