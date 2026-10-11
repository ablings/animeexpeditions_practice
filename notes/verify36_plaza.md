# Verify round 36: Anime Expeditions spawn plaza (freestyle, after fix pass 38)

Independent review against the **live reference**, done 2026-10-11. I did not build this pass. Every score is fresh, and I
compared each camera against round 35 (`verify35_plaza.md`, all 9.5).

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code was run, nothing was modified or saved, and no computer use.
- **Captures:** two per camera per studio; the second frame is judged.
  - Judged frames: `out/verify36/v36_<cam>_ref.jpg` and `_rep.jpg`. Both frames: `out/verify36/raw/<cam>_{ref,rep}_{a,b}.jpg`.
  - All 24 judged frames are full size, **1284 x 793**.
  - Frame a vs b (pixels changed by more than 30 levels): reference 1.0-4.3% (water, VFX, crowd); practice 0.0-0.4% (the jet
    plume). The frames match.
- **Colours:** 5x5 mean from the judged JPEG, written (x,y) rep vs ref, with r35 rep in brackets. Stud sizes are estimates.
- **Pass-38 change size** (r35 practice frame vs r36, >30 levels): c1 7.4%, c3 4.8%, p3 3.1%, p5 3.0%, p1 2.7%, p2 1.3%,
  c2 1.3%, c4 0.9%, p6 0.8%, p4 0.7%, p8 0.5%, p7 0.1%. This is a small pass.
- **Top-half mean HSV saturation**:

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r36 | 82 | 100 | 103 | 110 | 91 | 117 | 87 | 99 | 95 | 109 | 91 | 80 |
| rep r36 | 88 | 95 | 100 | 111 | 97 | 106 | 82 | 88 | 100 | 100 | 104 | 93 |

## Overall read
Pass 38 is a net gain, but a small one. No camera crosses to 10.

1. **NE arch face: the builder was right.** I zoom-compared c1 and p5:
   - The ref's U face (the crest around the planter notch and the face over the niche) is light grey. The light face in r36
     matches it better than r35's dark face.
   - The two box measurements moved away because they land on the ref's **dark shoulder bands**:
     - c1 (500,300) (132,136,139) [r35 (64,77,85)], ref (60,64,60).
     - p5 (560,330) (138,137,129) [r35 (77,83,82)], ref (76,81,81).
   - In the ref, the shoulder carries two or three dark slate bands (about (60,65,62)) between the light bands. In r36 the
     shoulder bands are mid grey, so the shoulder reads flatter and lighter than the ref's.
   - p3 (150,330) (133,138,140) [r35 (68,80,90)], ref (134,135,139): on target. The r35 #2 item is done for p3.
2. **Jets: better from the front, worse from c2.**
   - **Front (c1, c3, p1, p3):** the straight block is gone. It is now a misty plume with a flat white crown, closer to the
     ref's silhouette. The ref body is a blue translucent swirl with white flecks, not a white puff. Ours is too white and too
     hot at the base:
     - c1 (640,430) (254,254,254) [r35 (118,174,203)], ref (125,209,237).
     - c1 (640,400) (195,233,242), ref (127,186,203).
     - p3 (1040,410) (228,253,254), ref (6,29,41): the far jet glows white where the ref is dark niche.
     - c3 (640,620) (249,254,253), ref (203,250,254), which is close.
   - **c2:** the r35 curl over the spout no longer reads; it is a white cloud now. The ref's c2 jet is a blue ribbon pouring
     forward over the lip. This is a regression:
     - c2 (520,360) (239,254,254) [r35 (180,218,233)], ref (31,54,76).
     - c2 (540,390) (67,49,21), ref blue body (32,122,151).
   - The jet is also smaller relative to its niche than in the ref. The ref jet fills about 60% of the niche width; ours fills
     about 35%.
3. **c3 notch slab:** done. c3 (640,500) (41,54,71) [r35 (159,177,187)], ref (60,65,80). It is slightly too dark.
4. **SE/NW arms:** done. c2 (560,200) (104,113,144) [r35 (69,78,109)], ref (100,113,134).
5. **Raid arcade maroon:** partly done. It is darker now, but it reads purple-grey rather than red-maroon:
   - p3 (600,320) (69,60,73) [r35 (111,104,108)], ref (103,46,53).
   - p3 (560,330) (69,59,73), ref (77,37,48).
   - p5 (1100,320) (100,56,70) [r35 (159,93,97)], ref (103,23,32).
   - c3 (1060,470) (95,62,83), ref (74,66,65).
6. **Sign teal (p2):** better, but still bluer and duller. (640,240) (103,188,205) [r35 (65,174,173)], ref (106,229,226).

## Per camera (round 35 -> round 36)

### p1_spawn_n: 9.5 -> 9.5
- **Gain:** a plume replaces the block. (230,410) is now white (203,235,244), ref (238,254,254), so the crown position is right.
- **Remaining (unchanged):**
  - NW shoulder (80,330) (57,69,89) vs (91,96,93).
  - U-arm face (120,250) (54,67,91) vs (101,103,117).
  - Gold mass (500,180) (89,118,172) vs (188,145,69).
  - Bollard (360,520) (133,108,20) vs (76,66,10).
  - Pool (240,420) (98,163,193) vs (122,189,219).

### p2_spawn_s: 9.5 -> 9.5
- **Gain:** the sign teal is brighter (above).
- **Remaining:**
  - Band (720,200) (144,178,186) vs (178,203,215).
  - Above the band, (680,100) (127,158,138) vs sky (140,210,236).
  - Orb ring (740,110) (115,126,159) vs (38,186,242).
  - Gate (640,330) (14,102,118) vs (9,137,150).
  - The big palm right of the gate is missing.

### p3_spawn_e: 9.5 -> 9.5
- **Gains:**
  - The NE arch outer is on value.
  - The arcade is darker.
- **Losses:** both jets glow white. The far one at (1040,410) is (228,253,254) where the ref is (6,29,41).
- **Remaining:**
  - The arcade hue (above).
  - Door (640,330) (31,43,53) vs (2,10,14).
  - NE crowns (250,150) (72,120,202) vs (43,92,208); (150,120) (67,125,219) vs (16,63,204).
  - Wash (640,150) (251,109,113) vs (251,177,163).
  - (1130,330) (75,83,106) vs (47,54,75).

### p4_spawn_w: 9.5 -> 9.5
- Not touched (0.7%).
- Story crown (640,100) (36,74,159) vs (101,118,208).
- Ring (640,330) (13,22,31) vs (0,8,16).
- (1000,100) (131,175,233) vs pale island (216,241,240).

### p5_diag_ne: 9.5 -> 9.5
- **Gains:**
  - The U face is light, as in the ref.
  - The surround is redder (above).
- **Losses:** the jet is white-hot. (640,400) (192,228,238) vs (85,136,156).
- **Remaining:**
  - Shoulder bands flat: (520,300) (201,204,207) vs (160,166,137); (560,330) (138,137,129) vs dark band (76,81,81).
  - Gold pipe (500,330) (167,141,58) vs shadow groove (48,93,140).
  - Raid door (1200,300) (28,40,50) vs (4,8,12).

### p6_diag_sw: 9.5 -> 9.5
- Unchanged apart from the jet.
- (640,400) (192,228,241) vs (7,26,39): our jet sits where the ref shows dark niche.
- Portal (60,300) (13,94,113) vs (7,133,147).
- (800,250) (189,201,193) vs dark canopy (66,80,59).
- (620,200) (47,92,204) vs (95,133,125).
- Recess (560,330) (54,59,66) vs (21,29,40).
- Pipe (500,330) (148,121,45) vs (44,69,76).
- Saturation -11.

### p7_high: 9.5 -> 9.5
- Not touched (0.1%).
- SE sand (1000,650) (237,211,159) vs lawn (100,180,49).
- W foreground (150,300) (47,132,251) vs (100,97,65).
- Plaza centre (640,420) (100,111,120) vs (195,196,173).

### p8_top: 9.5 -> 9.5
- Not touched (0.5%).
- Black SE disc (1100,640) (53,63,68) vs (148,132,115).
- Lagoon (200,300) (57,88,156) vs (78,89,60).
- E ochre missing: (1000,300) (118,183,76) vs (152,125,49).

### c1_wall: 9.5 -> 9.5
- **Gains:**
  - The U face is light grey, as in the ref.
  - The jet is a plume, not a block.
- **Losses:** the shoulder dark bands are lost: (500,300) (132,136,139) vs (60,64,60); (380,350) (130,135,137) vs (59,69,77).
- **Remaining:**
  - The jet is white-hot and narrow (above).
  - Right outer bevel (900,300) (86,102,116) vs light (181,194,206), unchanged.
  - Top gap (640,120) (111,130,155) vs (143,152,120).
  - Gold basin lip (640,460) (204,183,79) vs water (58,155,183): the ref's upper basin sits higher and wider.

### c2_fountain: 9.5 -> 9.5
- **Gain:** the near arm is on value. (560,200) (104,113,144) vs (100,113,134). This was the r35 #5 item.
- **Loss:** the curl became a white cloud (above).
- **Remaining:**
  - Foreground reds too light: (300,300) (215,68,82) vs (165,13,24); (380,250) (96,62,74) vs (34,29,37).
  - The stone outcrop and crystal behind the arch are missing.
- The gain and the loss cancel. Saturation -9.

### c3_pavilion: 9.5 -> 9.5
- **Gains:**
  - The notch slab is dark.
  - The jet crown is close in value.
  - The lower facade is darker.
- **Remaining:**
  - Sky (300,40) (68,165,243) vs (100,203,241).
  - Door (1200,450) (28,38,50) vs (3,7,15).
  - Falls white (60,230) (202,246,246) vs (159,171,156).
  - Facade hue (1060,470) (95,62,83) vs (74,66,65).

### c4_stairs: 9.5 -> 9.5
- Not touched (0.9%).
- Entry (640,410) (169,153,102) vs (216,185,106).
- Canopy (640,350) (229,214,151) vs (121,162,177).
- (200,400) gold (208,195,151) vs blue cypress (65,119,232).

## Scores
| camera | r35 | r36 |
|---|---|---|
| p1_spawn_n | 9.5 | 9.5 |
| p2_spawn_s | 9.5 | 9.5 |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 9.5 | 9.5 |
| p5_diag_ne | 9.5 | 9.5 |
| p6_diag_sw | 9.5 | 9.5 |
| p7_high | 9.5 | 9.5 |
| p8_top | 9.5 | 9.5 |
| c1_wall | 9.5 | 9.5 |
| c2_fountain | 9.5 | 9.5 |
| c3_pavilion | 9.5 | 9.5 |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **114** | **114** |
| **average** | **9.50** | **9.50** |

Arithmetic: 12 x 9.5 = 114. 114 / 12 = 9.50.

## Top-10 for the next pass (ranked by visual impact)
1. **Jet colour, size and the c2 curl (c1, c2, p3, p5, p6; all four arches).**
   - Keep the plume silhouette but tint its body translucent blue (127,186,203), not white.
   - Limit pure white (240+) to flecks and the top 0.5 stud of the crown. Cut the spout froth disc to (200,235,245).
   - Widen the plume about 1.6x, to about 60% of the niche width.
   - Restore the c2 forward ribbon (blue (32,122,151)) pouring over the lip toward the camera side.
   - Targets:
     - c1 (640,430) (254,254,254) -> (125,209,237).
     - c1 (640,400) (195,233,242) -> (127,186,203).
     - c2 (520,360) -> (31,54,76) niche showing through.
     - p3 (1040,410) (228,253,254) and p6 (640,400) -> dark niche (6,29,41).
2. **Arch shoulder dark bands (c1, p5).**
   - Keep the light U face.
   - On each shoulder, darken the two inner bands (between the gold rims, each about 0.6 stud wide) to slate (60,65,62):
     - c1 (500,300) (132,136,139) -> (60,64,60).
     - c1 (380,350) -> (59,69,77).
     - p5 (560,330) (138,137,129) -> (76,81,81).
     - p5 (520,300) (201,204,207) -> (160,166,137).
   - Light the outer bevel rim: c1 (900,300) (86,102,116) -> (181,194,206).
3. **Raid arcade hue and interiors (p3, p5, c3).**
   - Shift the surround from purple-grey to red-maroon (raise R by about 35, drop B by about 20):
     - p3 (600,320) (69,60,73) -> (103,46,53).
     - p3 (560,330) -> (77,37,48).
     - p5 (1100,320) (100,56,70) -> (103,23,32).
   - c3 lower facade (95,62,83) -> (74,66,65).
   - Door and bay interiors to near black:
     - (31,43,53)/(28,40,50) -> (3,8,14).
     - p4 ring (13,22,31) -> (0,8,16).
4. **NW/N arch and U arm (p1).** These were missed: lighten the NW shoulder p1 (80,330) (57,69,89) -> (91,96,93) and the
   U-arm face (120,250) (54,67,91) -> (101,103,117), the same treatment the NE arch got.
5. **Summon side (c4, p1).**
   - Gold tree mass (188,145,69) about 12 studs behind the N stair (p1 (500,180) (89,118,172)).
   - Entry (169,153,102) -> (216,185,106).
   - Canopy (229,214,151) -> (121,162,177).
   - 2 blue cypresses (65,119,232), about 8 studs tall, at the stair top (c4 (200,400)).
6. **Pipe vs groove (p5, p6).** Where the ref shows a shadowed groove, tone the gold pipe:
   - p5 (500,330) (167,141,58) -> (48,93,140).
   - p6 (500,330) (148,121,45) -> (44,69,76).
   - p6 recess (54,59,66) -> (21,29,40).
7. **Foreground reds (c2).** Darken the Boss Rush/Raid foreground: (300,300) (215,68,82) -> (165,13,24); (380,250)
   (96,62,74) -> (34,29,37).
8. **SE rock and sand (p8, p7).**
   - Break the black disc (1100,640) (53,63,68) into 4-6 rocks over about 18 x 12 studs, with lit tops (148,132,115).
   - Shrink the SE sand to 60%; p7 (1000,650) back to lawn (100,180,49).
9. **Crowns (p3, p4, p6).**
   - NE notch crowns: (72,120,202)/(67,125,219) -> (43,92,208)/(16,63,204).
   - Story crown: lift about 5 studs and lighten, (36,74,159) -> (101,118,208).
   - p6 (800,250) (189,201,193) -> (66,80,59).
10. **p2 sign/ring and the lagoon (p2, p8, p7).**
    - Sign teal (103,188,205) -> (106,229,226).
    - Orb ring (115,126,159) -> (38,186,242).
    - Lagoon edges (57,88,156) -> (78,89,60).
    - W foreground p7 (150,300) -> (100,97,65).
    - Ochre patches (152,125,49) at p8 (1000,300).
