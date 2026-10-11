# Verify round 35: Anime Expeditions spawn plaza (freestyle, after fix pass 37)

This is an independent review against the **live reference**, done 2026-10-11. I did not build this pass. I read round 34
(`verify34_plaza.md`) to compare camera by camera; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code run, nothing modified or saved, no computer use.
- **Captures:** each camera twice per studio; the second frame is judged.
  - Judged frames: `out/verify35/v35_<cam>_ref.jpg` and `_rep.jpg`. Both frames: `out/verify35/raw/<cam>_{ref,rep}_{a,b}.jpg`.
  - All 24 judged frames are full size, **1284 x 793**.
  - Frame a vs frame b (pixels changed by more than 30 levels): reference 0.7-4.2% (water, VFX, crowd); practice 0.0-0.2%.
    The frames match; the differences are animation.
- **Colours:** 5x5 mean from the judged JPEG, given as (x,y) rep vs ref (r34 rep in brackets where useful). Stud sizes are
  estimates from the pictures.
- **Pass-37 change size** (pixels changed by more than 30 levels, r34 practice frame vs r35 practice frame):
  c3 16.7%, p2 11.1%, p3 10.2%, c2 9.1%, c1 8.1%, p4 7.8%, p6 7.4%, p5 5.3%, p1 4.8%, c4 3.4%, p8 1.5%, p7 1.0%.
  The sky turn accounts for part of every player-height camera.
- **Top-half mean HSV saturation** (same PIL metric as earlier rounds):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r35 | 82 | 100 | 102 | 110 | 91 | 117 | 87 | 100 | 95 | 109 | 91 | 84 |
| rep r34 | 87 | 97 | 97 | 114 | 98 | 109 | 82 | 88 | 103 | 101 | 99 | 92 |
| **rep r35** | **89** | **96** | **101** | **112** | **97** | **106** | **82** | **88** | **104** | **100** | **104** | **93** |
| gap r35 | +7 | -4 | -1 | +2 | +6 | -11 | -5 | -12 | +9 | -9 | +13 | +9 |

- c3 rose +5 because its upper left is now blue sky rather than white cloud. That is correct; the ref's blue reads the same
  way. Saturation is not a driver this round.

## Overall read
Pass 37 fixed the long-standing c3 sky and made the Raid arcade visible. The arch grooves work. The new jet is the
weakest piece.

1. **Sky (c3 headline):** fixed.
   - c3 (300,40): (68,165,243) [r34 (228,232,235)], ref (95,201,241).
   - c3 (100,60): (81,170,241), ref (103,208,242).
   - The big cumulus now sits top-centre over the crown, like the ref's. The other cameras' skies moved slightly; none got
     worse. p4 (1000,100) went from (88,158,237) to (131,175,233), ref (216,241,240).
2. **Arch grooves (c1, flagged):** they read as recessed grooves, not boxes.
   - From c1, the two dark grooves follow the shoulder curve, and the shoulder now has the ref's banded look.
   - The front face is on value: c1 (500,300) (64,77,85) [r34 (88,101,110)], ref (60,64,60); (380,350) (63,74,83), ref (59,69,77).
   - p5 face (560,330) (77,83,82), ref (76,81,81). This is the r34 #3 face item, done.
3. **NE arch darker (p3, flagged):** too dark from p3.
   - The east-facing foot and shoulder fell from (92,104,114) to (68,80,90) at p3 (150,330); the ref there is (134,135,139).
   - The darkening is right from c1, which sees the face, but wrong from p3, which sees the shoulder and foot.
   - p1 (80,330) also went darker: (57,69,89) [r34 (97,103,120)], ref (91,95,93).
4. **Raid arcade:** the three arched bays each side of the door now show in p3, p5, c2 and c3. This is a clear silhouette
   gain. The surround reads grey-pink, though, not the ref's maroon:
   - p3 (600,320) (111,104,108), ref (104,49,55).
   - p3 (560,330) (108,98,104), ref (79,38,49).
   - p5 (1100,320) (159,93,97), ref (103,24,31).
5. **Fountain:**
   - The niche is now near black: c2 (600,400) (9,17,33) [r34 (72,119,146)], ref (0,13,22). Done.
   - The far arm is on value: c2 (700,250) (36,47,69), ref (45,52,62).
   - **Jet:** from c2 the curl over the spout reads. From the front (c1, p1, p3, c3) it reads as a straight pale-blue
     translucent block standing on the spout, with no froth. The ref is a dark-ish translucent body with a bright white frothy
     crown:
     - c1 (640,400) (126,201,230), ref (84,118,133).
     - c1 (640,430) (118,174,203), ref (226,254,254).
     - c3 (640,600) (126,201,230), ref (100,143,159).
     - The ref jet is animated, but the shape difference holds in every frame: the ref has a plume, ours a block.
6. **p2:**
   - The island band is lower: (720,200) (144,178,186) [r34 (100,136,111)], ref (180,205,214).
   - The orb ring is grey-blue: (740,110) (115,126,159).
   - The Expeditions sign is now about the ref's size and position (letters span about 185 px vs 160 px), low over the gate.
     Its teal is darker: (640,240) (65,174,173) vs (107,228,226).

## Per camera (round 34 -> round 35)

### p1_spawn_n: 9.5 -> 9.5
- **Gains:**
  - The arch grooves read.
  - The pool is less pale: (240,420) (95,173,201) [r34 (143,208,223)], ref (61,136,180).
- **Losses:** the NW arch shoulder is darker: (80,330) (57,69,89) vs (91,95,93).
- **Remaining:**
  - The U-arm face (120,250) (54,67,91) vs (102,104,117).
  - The gold mass (500,180) (89,118,172) vs gold (183,142,70).
  - The bollard (360,520) (133,108,20) vs (76,66,10).
  - The jet is a block.

### p2_spawn_s: 9.5 -> 9.5
- **Gains:**
  - The sign is at the right size and height.
  - The ring is grey-blue.
  - The band is lower (values above).
- **Remaining:**
  - The sign teal is dark.
  - Above the band, (680,100) is still green-grey (128,159,138) vs sky (142,208,237).
  - The ref's big palm right of the gate is missing.
  - (200,300) (114,117,107) vs teal (88,145,152).

### p3_spawn_e: 9.5 -> 9.5
- **Gains:**
  - The Raid arcade bays are visible each side of the door. This is the r34 #1 Raid item, built.
  - The NE shoulder grooves look right.
- **Losses:** the NE arch is too dark at (150,330) (68,80,90) vs (134,135,139).
- **Remaining:**
  - The arcade colour (above).
  - The door (640,330) (31,43,53) vs (32,18,23).
  - The NE crown is still pale: (250,150) (72,120,202) vs (43,94,208); (150,120) (67,125,219) vs (16,63,204).
  - The wash (640,150) (251,109,113) vs (240,132,111).
- The gain and the loss roughly cancel.

### p4_spawn_w: 9.5 -> 9.5
- The change is mostly the sky and arch.
- The Story crown is unchanged: (640,100) (36,74,159) vs (100,117,206).
- The ring interior (640,330) (13,22,31) vs (0,9,16).
- (1000,100) (131,175,233) vs a pale island (216,241,240).

### p5_diag_ne: 9.5 -> 9.5
- **Gains:**
  - The face value is on target.
  - The Raid bays show.
  - The jet base is no longer white-hot: (640,420) (90,175,173).
- **Remaining:**
  - The light band is flat: (520,300) (201,204,207) vs (159,162,127).
  - The gold pipe (500,330) (167,141,58) vs blue-shadow groove (46,84,122).
  - The Raid door (1200,300) (28,40,50) vs (5,10,16).
  - The surround (1100,320) (159,93,97) vs (103,24,31).
  - The left gold tree and crowd are missing.

### p6_diag_sw: 9.5 -> 9.5
- Unchanged in substance.
- The portal is on target: (60,300) (13,94,113) vs (11,135,149).
- (800,250) is pale (189,201,193) vs dark canopy (66,80,59).
- (620,200) is blue crown (47,92,204) vs stone/sky (98,135,125).
- The recess (560,330) (54,59,66) vs (21,29,40).
- The pipe (500,330) (148,122,45) vs (44,70,75).
- Saturation -11.

### p7_high: 9.5 -> 9.5
- Not touched (1.0%).
- The SE sand (1000,650) (237,211,159) vs lawn (98,178,49).
- The W foreground (150,300) (47,132,251) vs sandy rock (101,99,64).
- The plaza centre (640,420) (100,112,120) vs (195,196,173).

### p8_top: 9.5 -> 9.5
- Not touched (1.5%).
- The black SE disc (1100,640) (53,63,68) vs (150,133,116).
- The lagoon (200,300) (57,88,156) vs (68,83,51).
- No E ochre: (1000,300) (118,183,76) vs (149,124,51).

### c1_wall: 9.5 -> 9.5
- **Gains:**
  - The face value is on target.
  - The grooves read as the ref's banded shoulder. This camera has the best arch match yet.
- **Remaining:**
  - The jet is a pale block: (640,400) (126,201,230) vs (84,118,133), with no white crown (640,430) (118,174,203) vs
    (226,254,254).
  - The right shoulder is now dark at (900,300) (86,102,116) vs light (179,187,190); the NE outer bevel needs its light rim.
  - The top gap (640,120) (112,131,156) vs (138,146,116).
- The jet alone keeps this off 10.

### c2_fountain: 9.5 -> 9.5
- **Gains:**
  - The niche is near black.
  - The far arm is on value.
  - The curl over the spout reads here.
  - The Raid bays are visible behind.
- **Remaining:**
  - The near U arm is still dark: (560,200) (69,78,109) [r34 (40,49,68)], ref (100,113,134). Better, not there.
  - The Boss Rush/Raid foreground reds are too light: (300,300) (215,68,82) vs (167,16,24); (380,250) (96,62,74) vs (39,32,37).
  - The ref's stone outcrop and crystal behind the arch are missing.
- Saturation -9.

### c3_pavilion: 9 -> 9.5
- **Gains:**
  - The sky is fixed. The upper left is blue, with a cumulus top-centre as in the ref.
  - The Raid arcade bays read under the sign.
  - This was the r34 #1 item; the camera no longer reads as the weakest.
- **Remaining:**
  - The notch sill/recess (640,500) (159,177,187) vs (60,65,80). This was not done this pass.
  - The door (1200,450) (28,38,50) vs (4,9,17).
  - The falls are still white: (60,230) (205,246,247) vs (159,170,155).
  - The jet block (640,600) (126,201,230) vs (100,143,159).
  - The Raid lower facade is pink-grey: (1060,470) (144,95,114) vs (74,68,65).

### c4_stairs: 9.5 -> 9.5
- Not touched in substance (3.4%, mostly sky).
- The entry (640,410) (169,153,102) vs (209,178,105).
- The canopy (640,350) (229,214,151) vs (127,165,177).
- (200,400) is gold (207,195,151) vs blue cypress (68,121,233).

## Scores
| camera | r34 | r35 |
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
| c3_pavilion | 9 | **9.5** |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **113.5** | **114** |
| **average** | **9.458 (9.46)** | **9.500 (9.50)** |

Arithmetic: twelve cameras at 9.5 make 114. 114 / 12 = 9.50.

## Top-10 for the next pass (ranked by visual impact)
1. **Fountain jet (seen in c1, c3, p1, p3, p5 and on all four arches).**
   - Replace the straight translucent block with a plume about 2 studs wide and 2.5 tall.
   - Give it a darker translucent body (84,118,133) and a bright white frothy crown (226,254,254) about 1.5 studs deep at the
     top, spilling forward over the spout lip. Keep the c2 curl.
   - Targets: c1 (640,400) (126,201,230) -> (84,118,133); c1 (640,430) (118,174,203) -> (226,254,254); c3 (640,600) -> (100,143,159).
2. **NE arch outer value (p3, p1, c1).**
   - Keep the dark face that c1 sees ((64,77,85) is on target).
   - Lighten the outward shoulder and foot pieces and the outer bevel rim:
     - p3 (150,330) (68,80,90) -> (130,132,136).
     - c1 (900,300) (86,102,116) -> (175,185,190).
     - p1 (80,330) (57,69,89) -> (91,95,93).
   - Keep the two grooves.
3. **Raid arcade colour and the door interiors (p3, p5, c3, c2).**
   - Tint the new arcade surround deep maroon:
     - p3 (600,320) (111,104,108) -> (104,49,55).
     - p3 (560,330) -> (79,38,49).
     - p5 (1100,320) (159,93,97) -> (103,24,31).
     - c3 (1060,470) -> (74,68,65).
   - Make the bay and door interiors near black (5,10,16):
     - p5 (1200,300) (28,40,50).
     - c3 (1200,450) (28,38,50).
     - p4 ring (13,22,31) -> (0,9,16).
4. **c3 notch sill/recess.**
   - Make the recess under the planter dark: c3 (640,500) (159,177,187) -> (60,65,80).
   - Recess it about 1 stud and cap it with a thin gold sill.
5. **U-arm near arm (c2, p1).**
   - Light band on the U arms: c2 (560,200) (69,78,109) -> (100,113,134); p1 (120,250) (54,67,91) -> (102,104,117).
   - Add the stepped ledge.
6. **Shoulder band and pipe (p5, p6).**
   - Break the flat light band with the same grooves seen from p5: (520,300) (201,204,207) -> (160,162,128).
   - Tone the gold pipe where the ref shows a shadowed groove: p5 (500,330) (167,141,58) -> about (60,85,115); p6 (500,330)
     (148,122,45) -> (44,70,75).
7. **Summon side (c4, p1, p5).**
   - Gold tree mass (183,142,70) about 12 studs behind the N stair (p1 (500,180) now (89,118,172)).
   - Entry (169,153,102) -> (209,178,105).
   - Canopy (229,214,151) -> (127,165,177).
   - 2 blue cypress (68,121,233), about 8 studs tall, flanking the stair top (c4 (200,400)).
8. **SE rock and sand (p8, p7).**
   - Break the black disc (1100,640) (53,63,68) into 4-6 rocks over about 18 x 12 studs, with lit tops (150,133,116).
   - Shrink the SE sand to 60% and tint it (192,171,116); p7 (1000,650) back to lawn (98,178,49).
9. **Crown values (p3, p4, p6).**
   - NE notch crowns: (72,120,202)/(67,125,219) -> (43,94,208)/(16,63,204).
   - Story crown: lift it about 5 studs and lighten it, (36,74,159) -> (100,117,206).
   - p6 (800,250) (189,201,193) -> dark canopy (66,80,59).
10. **Lagoon, W foreground, E ochre, and the p2 sign (p8, p7, p2).**
    - Lagoon (57,88,156) -> (68,83,51) at the edges.
    - Thin the W blue so that p7 (150,300) shows sandy rock (101,99,64).
    - Ochre (149,124,51) patches at p8 (1000,300).
    - Lighten the Expeditions sign teal (65,174,173) -> (107,228,226).
