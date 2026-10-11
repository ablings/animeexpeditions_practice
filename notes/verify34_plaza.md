# Verify round 34: Anime Expeditions spawn plaza (freestyle, after fix pass 36)

This is an independent review against the **live reference**, done 2026-10-11. I did not build this pass. I read round 33
(`verify33_plaza.md`) to compare camera by camera; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code run, nothing modified or saved, no computer use.
- **Captures:** each camera twice per studio; the second frame is judged.
  - Judged frames: `out/verify34/v34_<cam>_ref.jpg` and `_rep.jpg`. Both frames: `out/verify34/raw/<cam>_{ref,rep}_{a,b}.jpg`.
  - All 24 judged frames are full size, **1284 x 793**.
  - Frame a vs frame b (pixels changed by more than 30 levels): reference 0.8-3.5% (water, VFX, crowd); practice 0.0-0.6%.
    The frames match; the differences are animation.
- **Colours:** 5x5 mean from the judged JPEG, given as (x,y) ref vs rep. Stud sizes are estimates from the pictures.
- **Pass-36 change size** (pixels changed by more than 30 levels, r33 practice frame vs r34 practice frame):
  p2 4.6%, p1 4.3%, p3 4.1%, p4 3.6%, c1 3.4%, p6 3.2%, c3 3.1%, p5 3.0%, c2 2.5%, p7 1.7%, p8 0.7%, c4 0.4%.
- **Top-half mean HSV saturation** (same PIL metric as earlier rounds):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r34 | 82 | 99 | 102 | 110 | 91 | 116 | 87 | 101 | 94 | 110 | 94 | 84 |
| rep r33 | 87 | 97 | 96 | 113 | 97 | 109 | 81 | 88 | 105 | 103 | 98 | 91 |
| **rep r34** | **87** | **97** | **97** | **114** | **98** | **109** | **82** | **88** | **103** | **101** | **99** | **92** |
| gap r34 | +5 | -2 | -5 | +4 | +7 | -7 | -5 | -13 | +9 | -9 | +5 | +8 |

- The reference saturation moved slightly between rounds (animation and time of day): p8 97 -> 101 and p6 111 -> 116.
  The practice numbers are flat (within 2). Saturation is not a driver this round.

## Overall read
Pass 36 landed its two headline items and most of the p2 package.

1. **Arch band (headline):**
   - The band between the gold pipes is now light grey on every front arch.
   - c1 (340,300) (41,52,59) -> (148,154,159), ref (163,159,152).
   - c1 (900,300) (45,58,66) -> (148,154,161), ref (180,193,204).
   - p1 (80,330) (29,40,50) -> (97,104,120), ref (91,96,94).
   - In p5, c1 and c3 the arch now reads as the ref's light shoulder. This was the r33 #1 item.
   - Two parts are left:
     - The band is now one flat light value. The ref has 2-3 dark recessed grooves (about (45,53,62)) running inside the light
       shoulder, so ours reads a little plain.
     - The U arms are still the old dark slab. In c2 (560,200) (41,49,69) vs (100,114,135); the builder flagged this.
2. **Notch trees:**
   - The bare poles are gone.
   - p3 (205,120) (61,51,55) -> (29,67,190), ref (21,69,205).
   - c3 (600,300) (136,144,154) -> (27,63,185), ref (19,67,208).
   - A short trunk stub still shows inside the crown in c3/p5, at about (630,250) (117,132,169). It reads as a branch, not a pole.
3. **p2:**
   - The orb moved down and right. Its white core now sits where the ref's does: (700,155) is (255,255,255) in both.
   - The pillars are toned: (560,330) (87,226,243) -> (126,149,171), ref (107,124,132).
   - The portal is darker: (640,330) (12,144,158) -> (15,103,117), ref (3,114,128).
   - The orb still hangs in front of the grey-green island band rather than sky: (720,200) (100,136,111) vs (180,203,216).
4. **p6 portal:** (60,300) (12,128,149) -> (14,95,114), ref (1,100,114). On target.
5. **Raid:**
   - The wash is softer: p3 (640,150) (253,41,54) -> (251,109,113), ref (247,156,154).
   - The three dark recesses beside the door are **not visible** from p3, c3 or c2. The door-side pixels are unchanged:
     p3 (600,320) (120,73,82); c3 (1100,450) (126,56,66); c3 (1060,470) (130,64,96).
   - The door interior is unchanged: (31,44,53) vs (1,10,17).
6. **Falls (c3):**
   - Slightly less white: (60,230) (226,246,247) -> (204,246,248), ref (146,162,154).
   - Wider, but the mist at the feet does not read at this camera.
   - The cloud behind is unchanged: (300,40) (228,232,235) vs (95,201,241).

## Per camera (round 33 -> round 34)

### p1_spawn_n: 9.5 -> 9.5
- **Gain:**
  - The arch band is lighter: (80,330) (29,40,50) -> (97,104,120), ref (91,96,94).
  - The face at (120,250) is unchanged: (55,68,91) vs (97,101,117). The upper face still has a dark panel.
- **Remaining:**
  - The gold tree mass behind the stair: (500,180) blue (92,120,172) vs gold (197,154,72).
  - The bollard is still bright: (360,520) (134,109,20) vs (76,66,10).
  - The pool is pale: (240,420) (144,209,224) vs (73,145,186).
  - (200,300) is ochre (147,132,85) vs teal (95,157,157).

### p2_spawn_s: 9 -> 9.5
- **Gains:**
  - The orb sits at the ref position.
  - The pillars and portal are close to target (values above).
- **Remaining:**
  - The island band behind the orb: (720,200) (100,136,111) vs sky (180,203,216).
  - The orb ring segments are more saturated purple than the ref's grey-blue.
  - The Expeditions sign is small and flat. The ref sign is about 1.5x larger with gold trim; it reads big above the gate.
  - (200,300) (121,124,112) vs teal (89,146,152).

### p3_spawn_e: 9.5 -> 9.5
- **Gains:**
  - The pole is fixed: (205,120) (29,67,190) vs (21,69,205).
  - The wash is softer: (640,150) (251,109,113) vs (247,156,154).
- **Remaining:**
  - The NE crown is paler than the ref: (250,150) (72,121,202) vs (43,93,209); (150,120) (67,125,219) vs (16,63,205).
  - The door: (640,330) (31,44,53) vs (1,10,17).
  - The arch face: (150,330) (92,105,115) vs (134,135,139).
  - Raid door surround: there are no recesses. (600,320) (120,73,82) vs (98,43,53).

### p4_spawn_w: 9.5 -> 9.5
- Unchanged in substance (3.6% is the arch band).
- The Story crown is dark and low: (640,100) (36,75,159) vs (94,113,206).
- The ring interior: (640,330) (13,22,31) vs (1,10,17).
- (1000,100) is blue foliage (89,158,237) vs a pale island (211,239,240).

### p5_diag_ne: 9.5 -> 9.5
- **Gains:**
  - The arch band and shoulder are now light; the arch silhouette reads like the ref's.
  - The crown is fuller and bluer: (640,100) (53,89,160) -> (44,94,207), ref (35,92,222).
- **Remaining:**
  - The front face is too light: (560,330) (100,107,104) vs (76,81,82).
  - (520,300) is a light grey band (202,204,207) vs (163,178,170). This is the flat band with no grooves.
  - (500,330) is gold (178,153,65) vs a dark blue groove (49,98,148). The gold pipe got brighter.
  - The Raid door: (1200,300) (29,41,50) vs (2,11,17).
  - The jet base is white-hot: (640,420) (201,233,210) vs (60,138,169).
  - The left gold tree/crowd is missing.

### p6_diag_sw: 9.5 -> 9.5
- **Gain:** the portal is on target, (14,95,114) vs (1,100,114).
- **Remaining:**
  - (800,250) is pale (188,202,195) vs dark canopy (66,80,59).
  - (620,200) is blue crown (47,93,204) vs stone/sky (101,137,127).
  - (560,330) is grey (55,59,64) vs a dark recess (22,29,40).
  - (500,330) is gold (160,134,50) vs teal shadow (45,70,77).

### p7_high: 9.5 -> 9.5
- 1.7% change.
- **Unchanged:**
  - The SE sand is pale cream (237,212,159) at (1000,650) vs lawn (98,179,49).
  - The W foreground: (150,300) (50,133,250) vs sandy rock (101,98,64).
  - The plaza centre: (640,420) (103,113,120) vs (195,196,174).
  - The E red: (950,280) (168,87,91) vs (162,60,65).

### p8_top: 9.5 -> 9.5
- Not touched (0.7%).
- The SE rock is a black disc: (1100,640) (54,63,68) vs (151,134,116).
- The lagoon is navy: (200,300) (58,89,156) vs (67,82,51).
- The E field has no ochre: (1000,300) (118,184,76) vs (150,124,50).
- Flowers are on target.
- Saturation -13 (the ref rose by 4).

### c1_wall: 9.5 -> 9.5
- **Gain:** this is the biggest single improvement this round. The shoulder band went (41,52,59) -> (148,154,159), ref (163,159,152).
- **Remaining:**
  - The front face is too light: (500,300) (88,101,110) vs (60,64,60); (380,350) (87,100,110) vs (60,69,78).
  - The jet is a translucent box with no plume: (640,400) (77,143,172) vs frothy (165,218,232).
  - The top-centre gap: (640,120) (113,129,157) vs (140,148,119).
- Close to a 10 on silhouette. The face value and the jet hold it at 9.5.

### c2_fountain: 9.5 -> 9.5
- **Gain:** the far arm band is lighter, (700,250) (17,25,36) -> (71,76,101), ref (45,53,62).
- **Remaining:**
  - The near U arm is still a dark slab: (560,200) (41,49,69) vs (100,114,135). This needs the U-arm kit rework.
  - The niche reads teal (600,400) (72,120,146) and (480,250) (88,109,135). The ref niche is near black: (1,13,23), (7,11,18).
    The interior should be much darker.
  - The jet is a vapour puff, not the ref's bent water sheet.
  - The Raid facade carries no recesses; the ref's dark arcades and skull door read clearly.
  - Saturation -9.

### c3_pavilion: 9 -> 9
- **Gains:**
  - The pole is fixed: (600,300) (27,63,185) vs (19,67,208).
  - The falls are slightly less white.
- **Unchanged:**
  - The cloud: (300,40) (228,232,235) vs (95,201,241). The upper-left quarter is white where the ref is blue sky with defined
    cumulus.
  - The recess under the arch: (640,500) (161,177,187) vs (60,65,80).
  - The door: (1200,450) (28,39,49) vs (6,15,17).
  - The Raid facade: (1100,450) (126,56,66) vs (152,119,111). No recesses, and the facade is a flat red slab.
  - The falls mist is not visible.
- Still the weakest camera; it holds at 9.

### c4_stairs: 9.5 -> 9.5
- Not touched (0.4%).
- The entry: (640,410) (170,153,103) vs (204,174,104).
- The canopy: (640,350) (229,214,153) vs (115,158,178).
- (200,400) is gold (208,195,153) vs blue cypress (71,123,233).
- Saturation +8.

## Scores
| camera | r33 | r34 |
|---|---|---|
| p1_spawn_n | 9.5 | 9.5 |
| p2_spawn_s | 9 | **9.5** |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 9.5 | 9.5 |
| p5_diag_ne | 9.5 | 9.5 |
| p6_diag_sw | 9.5 | 9.5 |
| p7_high | 9.5 | 9.5 |
| p8_top | 9.5 | 9.5 |
| c1_wall | 9.5 | 9.5 |
| c2_fountain | 9.5 | 9.5 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **113** | **113.5** |
| **average** | **9.417 (9.42)** | **9.458 (9.46)** |

Arithmetic: eleven cameras at 9.5 make 104.5, and one at 9 makes 113.5. 113.5 / 12 = 9.4583.

## Top-10 for the next pass (ranked by visual impact)
1. **c3 sky, recess and Raid facade (c3, the only 9).**
   - Rotate or swap the skybox so that c3 (300,40) reads blue (95,201,241), not white cloud (228,232,235).
   - Darken the recess under the arch: (640,500) (161,177,187) -> (60,65,80).
   - On the Raid facade (c3 (1060-1200,450)), add the three recesses that are not visible:
     - 3 arches about 3 studs wide x 6 tall, recessed 1 stud, interior (20,8,12), on each side of the door.
     - Stone surround (152,119,111).
     - Place them where c3 and p3 actually see them, between the door and the left tower.
   - Door interior (28,39,49) -> (5,12,16).
2. **U-arm arch boxes (c2, p1, p3): needs the kit rework.**
   - Give the U arms the same light band as the front arches: c2 (560,200) (41,49,69) -> (100,114,135); p1 (120,250)
     (55,68,91) -> (97,101,117).
   - Add the stepped ledge.
3. **Arch band grooves and front face (c1, p5, c2).**
   - Inside the new light band (148,154,159), cut 2 recessed grooves about 0.4 stud wide, colour (45,53,62), following the arch
     curve (ref p5 (500,330) (49,98,148) shadowed groove; c2 far arm (45,53,62)).
   - Darken the flat front face from (88,101,110) to (62,66,64): c1 (500,300), c1 (380,350), p5 (560,330) -> (76,81,82).
   - Tone the gold pipe at p5 (500,330) back from (178,153,65) to about (150,125,45).
4. **Fountain niche and jet (c2, c1, p5).**
   - Make the niche interior near black, (8,12,20): c2 (480,250) (88,109,135) and (600,400) (72,120,146) vs (1-7,11-13,18-23).
   - Replace the box/puff jet with a curved water sheet spilling from the back wall: about 3 studs wide, 1.5 stud drop, colour
     (165,218,232), white froth at the lip.
   - Darken the jet base: p5 (640,420) (201,233,210) -> (60,138,169).
5. **p2 island band behind the orb.**
   - Lower or trim the S island fringe band about 10 studs, so that (720,200) shows sky (180,203,216), not (100,136,111).
   - Desaturate the orb ring segments to grey-blue (120,135,160).
   - Scale the Expeditions sign 1.5x with gold trim.
6. **SE rock and SE sand (p8, p7).**
   - Break the black disc: (1100,640) (54,63,68) -> 4-6 rocks over about 18 x 12 studs, lit tops (151,134,116), plus one red palm.
   - Shrink the SE sand to 60% and tint it (192,171,116).
   - p7 (1000,650) back to lawn (98,179,49).
7. **Summon side (c4, p1, p5).**
   - Gold tree mass (197,154,72) about 12 studs behind the N stair (p1 (500,180)).
   - Entry (170,153,103) -> (204,174,104).
   - Canopy (229,214,153) -> (115,158,178).
   - 2 blue cypress (71,123,233), about 8 studs tall, flanking the stair top (c4 (200,400)).
8. **Lagoon water, W foliage and E ochre (p8, p7).**
   - Lagoon (58,89,156) -> (67,82,51) at the edges.
   - Thin the W blue foreground so that p7 (150,300) shows sandy rock (101,98,64).
   - Ochre (150,124,50) patches in the E field (p8 (1000,300)).
9. **NE crown value (p3).**
   - Deepen the notch-tree crown clusters from (72,121,202)/(67,125,219) to (35,80,205) (p3 (250,150), (150,120)).
   - Replace the remaining trunk stub in c3 (630,250) (117,132,169) with leaf.
10. **Story tree and p6 canopy (p4, p6).**
    - Lift the Story crown about 5 studs and lighten it: (36,75,159) -> (94,113,206).
    - Fill p6 (800,250) (188,202,195) with dark canopy (66,80,59).
    - Darken the p6 recess (560,330) (55,59,64) -> (22,29,40).
