# Verify round 32: Anime Expeditions spawn plaza (freestyle, after fix pass 34)

This is an independent review against the **live reference**, done 2026-10-11. I did not build this pass. I read round 31
(`verify31_plaza.md`) to compare camera by camera; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code run, nothing modified or saved, no computer use.
- **Captures:** each camera twice per studio; the second frame is judged.
  - Judged frames: `out/verify32/v32_<cam>_ref.jpg` and `_rep.jpg`. First frames: `out/verify32/raw/<cam>_{ref,rep}_a.jpg`.
  - All 24 judged frames are full size, **1284 x 793**.
  - Frame 1 vs frame 2 (pixels changed by more than 30 levels): reference 1.3-4.1% (water, VFX, crowd); practice 0.0-0.2%.
    The frames match; the differences are animation.
- **Colours:** 5x5 mean from the judged JPEG, given as (x,y) ref vs rep. Stud sizes are estimates from the pictures.
- **Animated jet caveat:** the reference jet is animated. At c3 (640,600) the reference measured (33,65,81) in round 31 and
  (195,235,245) / (211,247,254) in this round's two frames; c1 (640,380) swings (16,46,60) to (111,178,199). So the jet is judged by
  shape and size, not by one pixel.
- **Pass-34 change size** (pixels changed by more than 30 levels, r31 practice frame vs r32 practice frame):
  p8 8.6%, p7 7.7%, c3 7.3%, p3 7.1%, c1 6.9%, p1 6.2%, p4 6.1%, p2 5.9%, p5 5.8%, c2 4.5%, p6 2.6%, c4 0.1%.
- **Top-half mean HSV saturation** (same PIL metric as rounds 24-31):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r32 | 82 | 100 | 102 | 110 | 90 | 117 | 87 | 103 | 94 | 109 | 92 | 81 |
| rep r31 | 80 | 91 | 89 | 107 | 90 | 106 | 81 | 88 | 104 | 101 | 94 | 91 |
| **rep r32** | **87** | **98** | **96** | **114** | **98** | **110** | **82** | **90** | **110** | **105** | **99** | **91** |
| gap r32 | +5 | -2 | -6 | +4 | +8 | -7 | -5 | -13 | **+16** | -4 | +7 | +10 |

- The builder's trade-off is confirmed: c1 is +16 over, p5 +8 and c4 +10 (c4 untouched). p4 is +4, not +7 against this round's ref frame.
- p2 gap -9 -> -2 and p3 -13 -> -6: both close to target now.

## Overall read
Pass 34 fixed the worst artefact of round 31. **The saw-tooth inner band is gone on every fountain view.** It is now one smooth
light-grey band that follows the arch curve, and the niche behind it is dark again: c1 (560,400) (126,164,188) -> (17,34,56),
ref (20,31,49). That is on target. The jet is now a thin translucent fan, the right shape and size for c1. The **p3 upper-left blue
mass landed**: (250,150) (68,77,97) -> (33,73,189), ref (43,92,208). The **E ground is now solid red**: p8 (950,480) (167,104,83) ->
(182,54,59), ref (183,68,62), with flat green patches and white dots.

What still costs points, in order:
1. **Arch outer face: shading contrast is too strong.** The lit faces are now too light: c1 (500,300) (88,101,110) vs (60,64,60),
   p5 (560,330) (100,106,104) vs (76,81,81). The shaded/back-lit faces are still too dark: c2 (560,200) (40,49,68) vs (100,113,134),
   p1 (150,330) (56,66,80) vs (83,85,98), p3 (150,330) (92,104,114) vs (134,135,139). In p1, p2, p4 and c2 the arch reads as a
   navy-black slab, because the outer face has no up-facing lit step. The ref arch has a stepped, tiered shoulder that catches light
   from every side.
2. **Blue crowns push c1 (+16) and p5 (+8) over saturation.** The notch tree's royal-blue crown fills the c1 top centre.
3. **Carried items:** lagoon, S lawn, N canal, the p2 orb and pillars, falls, the c3 cloud, bollard gold, the Raid doorway, the Summon entry and p6.

## Per camera (round 31 -> round 32)

### p1_spawn_n: 9 -> 9.5
- **Gains:**
  - The saw-tooth band is gone. Both arches now read as smooth bands over dark niches, each with a small fan, like the ref.
  - The arch face lifted a little: (150,330) (46,55,65) -> (56,66,80).
- **Geometry:** good. The rep has no tiered shoulder on the arch outer face; the ref's face has 2-3 steps.
- **Colour:**
  - The arch face is still about 25 levels dark: (56,66,80) vs (83,85,98).
  - The bollard gold is unchanged at (208,183,24) vs a shaded (76,66,10) at (360,520).
  - The slab is unchanged at (229,228,216) vs (163,163,125).
  - The pool water (240,420) is (184,239,246) vs (132,211,236), slightly too white.
- **Missing:** the big gold tree mass behind the stair and the crowd/props at the Summon. Saturation 87 vs 82 (+5).

### p2_spawn_s: 9 -> 9
- **Gains:** saturation 91 -> 98 (ref 100); smooth arch bands.
- **Remaining (unchanged since round 30):**
  - The orb still hangs against the grey-green island and ivy band: (720,200) (100,134,113) vs sky (174,200,212).
  - The orb itself is pure white (255,255,255) where the ref ring and orb read soft.
  - The side pillars are bright cyan: (560,330) (87,226,242) vs (107,123,131).
  - The portal is a flat door plane, (12,143,157) vs (3,126,140); the ref is a tall teal vortex mass.
  - The arch face reads as a dark navy slab, though in this view it is close in value: (150,330) (44,51,70) vs (47,54,74).

### p3_spawn_e: 9.5 -> 9.5
- **Gains:**
  - The corner notch tree now fills the upper-left with royal blue: (250,150) (33,73,189) vs (43,92,208).
  - (200,200), sky in round 31, is now blue crown (55,106,210); the ref there is a brown trunk/rock (93,76,61).
  - Saturation 89 -> 96.
- **Remaining:**
  - (150,120) is still the grey-green floating island (141,166,152) vs royal blue (16,63,204). The crown needs to reach about 60 px
    (about 4 studs) higher/further left.
  - The Raid doorway is unchanged, (31,44,53) vs (15,8,14).
  - The Raid red wash is unchanged and hot, (640,150) (252,40,53) vs a pink glow (246,155,143).
  - The arch face is dark on this side, (92,104,114) vs (134,135,139).

### p4_spawn_w: 9.5 -> 9.5
- **Gains:** the Story tree has a big royal-blue crown, and the ring/portal composition reads like the ref.
- **Remaining:**
  - The crown is darker and lower than the ref's: (640,100) (36,74,158) vs (97,116,206). The ref shows a massive branching brown trunk
    above the ring, with the canopy higher. The rep crown covers the trunk from about y 200 up.
  - The ring interior is unchanged, (12,22,30) vs (2,15,56). The ref has a deep blue swirl.
  - The upper-right is blue foliage (61,105,189) vs a pale green island (142,177,147).
  - Saturation 114 vs 110.

### p5_diag_ne: 9.5 -> 9.5
- **Gains:** smooth band; dark niche with a fan; the tree crown over the arch reads like the ref's blue tree.
- **Remaining:**
  - The arch lit face overshot light: (560,330) (100,106,104) vs (76,81,81).
  - The bollard dome is unchanged: a smooth sphere on a tall taper, gold (215,186,21) vs (143,123,18) at (640,560).
  - The Raid door is unchanged, (28,40,50) vs (2,10,16).
  - The ref's gold tree mass and crowd at the Summon (left) are missing.
  - Saturation 98 vs 90 (+8; the builder flagged +7).

### p6_diag_sw: 9.5 -> 9.5
- 2.6% change. Holds: the blue canopy, palms and Story trunk.
- **Remaining:**
  - The portal is unchanged and dark: (60,300) (11,128,149) vs (17,159,171).
  - (800,250) is unchanged light sky/stone (187,201,194) vs a dark canopy (73,91,82).
  - The tree over the arch is now a lighter blue: (620,200) (47,93,204); the ref there shows sky/stone (98,134,125).
  - Saturation 110 vs 117.

### p7_high: 9 -> 9
- **Gains:** the E red ground is solid, with a flat green flower patch.
- **Remaining (all unchanged):**
  - Lagoon: (150,300) is saturated blue foliage/water (50,133,250); the ref there is a sandy/rock bank (105,101,65).
  - S lawn (900,600): (88,159,115) vs sand/lawn (192,171,115).
  - N canal (640,250): (185,195,190) vs blue water (123,144,191).
  - The centre plaza is flat light grey (203,205,205) vs a warmer, textured (179,179,156), and has no grey stair masses with gold
    piping around the four fountains.
  - The E red (950,280) is unchanged at (167,86,92) vs (162,59,65).
  - Saturation 82 vs 87.

### p8_top: 9.5 -> 9.5
- **Gains:**
  - Solid red fields with white dots: (950,480) (182,54,59) vs (183,68,62), on target.
  - Five flat green flower patches, each about 6-10 studs, with white dots.
- **Remaining:**
  - The SE rock is now one flat black clover-shaped blob, (48,57,63) vs (45,44,39). The colour is right, but it has no lit tops or
    texture and reads as a hole in the map. The ref rock is broken grey-black with highlights and red foliage over it.
  - The patches are a darker green than the ref: (910,510) (97,151,77) vs (153,187,94).
  - The W lagoon is unchanged, a heavy navy pool (58,87,155) at (200,300) vs green/rock (69,83,55).
  - The E red field is bigger and flatter than the ref, which mixes red with ochre (147,120,51) at (1000,300).
  - Saturation 90 vs 103 (-13).

### c1_wall: 9.5 -> 9.5
- **Gains (the round-31 regression is fixed):**
  - The smooth inner band follows the curve.
  - The niche is dark, (17,34,56) vs (20,31,49).
  - The jet is the right size and value at (640,380): (116,171,186) vs (111,178,199).
- **Remaining:**
  - The arch face is now too light: (500,300) (88,101,110) vs (60,64,60).
  - The ref arch face is stepped in 2-3 tiers with a dark recess band; the rep face is flat between two thin dark bands.
  - The lower jet (640,420) is (161,202,214) vs (64,94,109): the jet base is brighter than the ref's.
  - No visible lit water sheet behind the jet: the ref shows a soft blue glow.
  - **Saturation 110 vs 94 (+16).** The blue crown fills the top centre (x 450-830, y 0-240).

### c2_fountain: 9.5 -> 9.5
- **Gains:** the arch teeth are gone.
- **Remaining:**
  - The arch face is still near-black: (560,200) (40,49,68) vs (100,113,134); (620,250) (40,48,67) vs (52,60,76).
  - The niche shows no water: (520,400) (16,21,33) vs a teal sheet (38,76,93).
  - The arch sits smaller and further away than in the ref (about 380-800 px wide vs 450-920).
  - The Raid tower's red wash is hot.
  - Saturation 105 vs 109.

### c3_pavilion: 9 -> 9
- **Gains:** smooth arch band; dark niche; saturation 94 -> 99 (ref 92, now +7).
- **Remaining:**
  - The upper-left cloud is unchanged, (300,40) (228,232,235) vs blue (87,198,241).
  - The falls are unchanged hard bars, (60,230) (228,245,247) vs (150,166,155).
  - The Raid facade is still flat red with no carved arches; the door is unchanged, (1200,450) (28,39,49) vs (1,11,15).
  - The jet is now a thin dim fan. The ref is animated but reads as a bright plume about as wide as the inner drum (about 3 studs):
    (640,600) is (89,137,155) vs (211,247,254) in this round's ref frames.
  - The dark recess under the arch is light grey: (640,500) (161,176,187) vs (60,65,80).

### c4_stairs: 9.5 -> 9.5
- Not touched (0.1% change).
- The entry is (170,153,103) vs (209,177,102) at (640,410).
- (640,350) is a pale gold canopy (228,214,152) vs blue (105,151,177).
- Saturation 91 vs 81 (+10). The ref has stalls and a crowd on the stair top; the rep has four parasols.

## Scores
| camera | r31 | r32 |
|---|---|---|
| p1_spawn_n | 9 | 9.5 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 9.5 | 9.5 |
| p5_diag_ne | 9.5 | 9.5 |
| p6_diag_sw | 9.5 | 9.5 |
| p7_high | 9 | 9 |
| p8_top | 9.5 | 9.5 |
| c1_wall | 9.5 | 9.5 |
| c2_fountain | 9.5 | 9.5 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **112** | **112.5** |
| **average** | **9.333 (9.33)** | **9.375 (9.38)** |

Arithmetic: three cameras at 9 make 27 and nine at 9.5 make 85.5, so the sum is 112.5. 112.5 / 12 = 9.375.

## Top-10 for the next pass (ranked by visual impact)
1. **Arch outer face: add the tiered shoulder and even out the shading (c1, c2, p1-p6, c3).**
   - Drop the base face colour about 15 to about (75,82,90), so the lit side lands near the ref. c1 (500,300) is (88,101,110)
     vs (60,64,60); p5 (560,330) is (100,106,104) vs (76,81,81).
   - Add 2 stepped, up-facing ledges along the outer arch curve: each about 1.2 studs wide and 0.5 stud proud, light grey
     (150,155,160), between the gold pipes. They catch light from above, so the back-lit sides stop reading as a navy slab.
     Targets: c2 (560,200) (40,49,68) -> (100,113,134); p1 (150,330) (56,66,80) -> (83,85,98); p3 (150,330) (92,104,114) -> (134,135,139).
2. **Notch-tree crowns: cut the c1/p5 over-saturation without losing p3.**
   - c1 is +16 (110 vs 94) and p5 +8 (98 vs 90).
   - Raise the crown base of the two N notch trees about 4 studs and thin the lower third by about 30%, so sky and white
     buildings show through over the c1 arch (x 450-830, y 0-240).
   - Keep the colour (33,73,189), which is on target in p3.
   - For p3, push the NE crown about 4 studs further out (north-west in view) so it covers (150,120), now grey-green island
     (141,166,152) vs (16,63,204).
3. **Niche water sheet glow (c2, c1, p1).**
   - The Neon sheet barely reads: c2 (520,400) (16,21,33) vs teal (38,76,93).
   - Make the back sheet about 5 studs wide, colour (60,140,170), Transparency 0.2, and move it 0.5 stud forward of the back wall
     so it shows past the jet.
   - Dim the jet base: c1 (640,420) (161,202,214) -> about (64,94,109). Set the lower third of the fan to Transparency 0.75.
4. **Lagoon, S lawn and N canal (p7, p8): carried four rounds.**
   - N canal: tint the strip north of the plaza from (185,195,190) to blue water (123,144,191), about 8 studs wide.
   - S lawn/sand: p7 (900,600) (88,159,115) -> (192,171,115). Put sand over the SE lawn quarter, about 25 x 25 studs.
   - W lagoon: cover its N half with sand/rock banks (105,101,65) and blue palms; add white surf lines. p8 (200,300) (58,87,155) -> (69,83,55).
5. **SE rock mound (p8, p7).**
   - It is now a flat black clover blob, (48,57,63). Rebuild it as 4-6 rocks of 3-6 studs, heights varying 2-5 studs.
   - Colour (45,44,39) with lit tops (95,98,92).
   - Drape red foliage (183,68,62) over about 30% of it.
   - Lighten the green flower patches from (97,151,77) to (153,187,94).
6. **p2 orb and Expeditions portal (p2, p6): carried three rounds.**
   - Lower the island/ivy band behind the orb about 10 studs, or raise the orb about 8, so (720,200) shows sky (174,200,212), not (100,134,113).
   - Soften the orb: (255,255,255) -> (220,235,240), Transparency 0.3.
   - Tone the cyan side pillars from (87,226,242) to (107,123,131).
   - Lift the p6 portal plane from (11,128,149) to (17,159,171).
7. **Raid door and glow (p3, p5, c3, c2).**
   - Make the door interior black (5,8,12): it is (28-31,40-44,49-53) in p3, p5 and c3 vs (2-15,8-11,14-16).
   - Change the Raid wash from hot red (252,40,53) to a pinker (246,155,143) at about half the brightness.
   - Add 3 carved arch recesses (60,20,25), about 3 studs wide, on the c3 facade.
8. **Falls and c3 cloud (c3, c4, p1): carried three rounds.**
   - Falls: drop the bar colour from (228,245,247) to (196,240,247), add a plane 1.5x wider at Transparency 0.75, and add a mist part
     (200,230,235), Transparency 0.6, about 8 studs wide, at each foot.
   - Rotate the skybox, or remove the cloud mass, so the c3 upper-left (300,40) shows blue (87,198,241), not (228,232,235).
   - Restore the c3 jet plume to about 3 studs wide above the inner drum. The ref reads as a bright plume; the rep reads as a thin fan.
9. **Bollards (p1, p5).**
   - Gold (208-215,183-186,21-24) -> aged gold (150,128,30), Reflectance 0, so the shaded side reaches about (76,66,10).
   - Make the dome squatter, about 0.7 x the current height, on a short base.
   - Slab (229,228,216) -> (180,178,150).
10. **Summon entry and c4 saturation (+10); p6 canopy.**
    - c4: make the entry a bright arched door (209,177,102) with a lit inner door; it is (170,153,103).
    - c4: turn the pale gold canopy at (640,350) (228,214,152) to blue/sky (105,151,177).
    - c4: add 4-6 stalls or lamp posts on the stair top.
    - p6: fill (800,250) (187,201,194) with dark canopy (73,91,82).
