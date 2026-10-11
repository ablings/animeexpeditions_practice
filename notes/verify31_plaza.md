# Verify round 31: Anime Expeditions spawn plaza (freestyle, after fix pass 33)

This is an independent review against the **live reference**, done 2026-10-11. I did not build this pass. I read round 30
(`verify30_plaza.md`) to compare camera by camera; every score below is fresh.

## Method
- **Studios** (ids confirmed with `list_roblox_studios`):
  - Reference `97946bf6-0aa4-48bc-9024-a884610ec79c` (place_84515722934860_Anime_Expeditions.rbxl), cameras from `cams.json`.
  - Practice `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (AE_practice.rbxl), cameras from `cams_practice.json` (x - 3000, y - 3).
  - RivalsPractice_replica.rbxl was not touched.
- **Tools:** `screen_capture` only. No code run, nothing modified or saved, no computer use.
- **Captures:** each camera twice per studio; the second frame is judged.
  - Judged frames: `out/verify31/v31_<cam>_ref.jpg` and `_rep.jpg`. First frames: `out/verify31/raw/<cam>_{ref,rep}_a.jpg`.
  - All 24 judged frames are full size, **1284 x 793**.
  - Frame 1 vs frame 2: reference 1.2-3.3% of pixels changed by more than 30 levels (water, VFX, crowd); practice 0.0-0.2%.
    The frames match; the differences are animation.
- **Colours:** 5x5 mean from the judged JPEG, given as (x,y) ref vs rep. Stud sizes are estimates from the pictures.
- **Pass-33 change size** (pixels changed by more than 30 levels, r30 practice frame vs r31 practice frame):
  p8 16.1%, c1 13.0%, c3 12.0%, p7 11.1%, p3 10.3%, p5 9.4%, p1 7.6%, c2 6.1%, p4 5.9%, p2 5.6%, p6 2.6%, c4 1.1%.
- **Top-half mean HSV saturation** (same PIL metric as rounds 24-30):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref r31 | 82 | 99 | 102 | 107 | 91 | 114 | 86 | 102 | 95 | 110 | 90 | 80 |
| rep r30 | 77 | 90 | 86 | 106 | 95 | 105 | 83 | 92 | 103 | 102 | 95 | 91 |
| **rep r31** | **80** | **91** | **89** | **107** | **90** | **106** | **81** | **88** | **104** | **101** | **94** | **91** |

- p3 gap -17 -> -13. p4 and p5 now on target.
- p8 gap -10 -> **-14** (grey rubble took the place of red, as the builder predicted). p7 -3 -> -5.
- c4 still +11 hot (not touched this pass).

## Overall read
Pass 33 landed the two biggest structural items from round 30: **the E ground at the top views now has the grey rubble band,
the SE dark rock and green patches**, and **the arch face is now dark slate**, not light grey. The p3 sky is filled with a dark
gothic skyline, and Boss Rush, the Raid doorway, the Story ring and the p2 portal all moved onto or near target.

Two new problems came with it:
- **The arch "inner band" reads as a ring of jagged grey teeth.** It is built from straight light-grey blocks set at angles
  around the inner arch, so on every fountain view (c1, c2, c3, p1-p6) it shows as a saw-tooth arc. In c1 (560,400) went from
  the dark niche (17,34,56) to (126,164,188); the ref there is a dark niche (20,31,49). This is the most visible new artefact.
- **The arch face overshot dark on the shaded views.** c1 is on target, but c2 (560,200) is (35,42,56) vs a lit slate
  (100,113,134), and p1 (150,330) is (46,55,65) vs (83,85,98).

### Wins that read on screen
- **E ground (p8, p7).**
  - Grey rubble band from the E stair east: p8 (950,400) (241,73,86) -> (113,124,124); ref (105,110,103). On target.
  - SE dark rock: p8 (1100,650) (235,118,99) -> (48,57,64); ref (54,56,51). On target in colour.
  - Salmon is gone: p8 (1000,300) (213,104,93) -> (143,115,72); ref (148,123,50). p7 (950,280) (217,108,106) -> (166,86,92), ref (163,60,65).
  - Green patches are present and the p7 red forest is thinner, so the ground reads.
- **Arch face (c1).** (500,300) (133,143,145) -> (73,85,85); ref (60,64,60) to (89,90,90). On target in c1.
- **p3 upper half.** The dark towers and spires fill most of the former open sky; Boss Rush (300,250) (102,87,85) -> (57,63,74),
  ref (25,24,27); Raid doorway (640,320) (51,55,69) -> (31,44,53), ref (0,10,18). Saturation +3.
- **Boss Rush in c2.** Face (250,200) (98,81,135) -> (60,73,92); sign/trim (130,220) (179,90,186) -> (139,77,133). Much calmer.
- **Story ring interior (p4).** (620,320) (29,40,54) -> (12,22,30); ref (4,15,16). Close.
- **p2 portal.** (640,330) (10,160,174) -> (12,143,157); ref (10,131,145). Close.
- **p5 Raid door** (1200,300) is now dark, (28,40,50) vs ref (0,9,16); it was red (212,57,68).
- **Bollard slab** no longer clips: p5 (640,610) (255,255,255) -> (242,242,232); p1 (920,540) (254,254,252) -> (229,228,216).

### What did not land or regressed
- **Arch inner band teeth** (see above): every fountain view.
- **Jet core still bright.** c3 (640,600) (232,247,248) -> (192,231,237) vs ref (33,65,81); c1 (640,380) (203,235,240) vs (16,46,60).
  The jet is now a translucent dome (better shape), but there is no lit blue water sheet at the back of the niche; the ref's
  niche reads dark with a blue glow (62,99,117) behind a small fan.
- **p3 upper-left is dark where the ref is saturated blue.** The ref upper-left is a big royal-blue tree canopy over a dark rock:
  (150,120) (16,63,204) and (250,150) (44,93,209). The rep there is a grey-green floating island (141,166,152) and dark towers
  (68,77,97); (200,200) is still a patch of sky (92,165,237) vs (93,77,60).
- **E red reads as speckle.** The rep red ground is a fine red/grey/green dither; the ref is solid red fields (184,69,62) with
  white flower dots and large flat green patches (132,176,50). The rep green patches are small round bushes about 4 studs wide.
  The SE rock is a cluster of black cubes: right colour, but it reads as a black object, not a rock mound.
- **p6 portal overshot dark:** (60,300) (11,141,161) -> (11,128,149) vs ref (19,155,170), the trade the builder noted.
- **Carried, untouched:** lagoon, S lawn, N canal (p7, p8), falls finish and the c3 cloud, p2 orb island, Summon entry/door, c4 saturation.

## Per camera (round 30 -> round 31)

### p1_spawn_n: 9 -> 9
- **Gains:** bollard slab toned (229,228,216) at (920,540); darker arch face; the jet is a translucent dome.
- **Geometry:** the saw-tooth inner band shows on both arches. The ref niche shows a lit blue sheet behind a small fan.
- **Colour:**
  - The arch face overshot: (150,330) (46,55,65) vs (83,85,98).
  - The bollard gold base is lit gold (208,183,24) at (360,520) where the ref is shaded (76,66,10).
  - The slab is still lighter than the ref (163,163,125).
- **Missing:** denser gold tree mass and crowd/props at the Summon. Saturation 80 vs 82.

### p2_spawn_s: 9 -> 9
- **Gains:** the portal is close to target, (12,143,157) vs (10,131,145).
- **Remaining:**
  - The orb ring still hangs against a grey-green island and ivy band, (100,134,113) at (720,200), where the ref shows sky (183,206,214).
  - The portal is a flat door plane; the ref is a tall teal vortex mass. (560,330) is a bright cyan pillar (88,226,242) vs (107,123,131).
  - Arch teeth and dark arch face as in p1. Saturation 91 vs 99.

### p3_spawn_e: 9.5 -> 9.5
- **Gains:** open sky replaced by a dark gothic skyline; Boss Rush and the Raid doorway much darker; saturation 86 -> 89.
- **Remaining:**
  - The ref upper-left is saturated blue canopy (16,63,204) over a dark rock; the rep has a grey-green island (141,166,152)
    and dark towers, so saturation is still -13.
  - (200,200) is still a patch of sky.
  - The Raid doorway is close but still lifted, (31,44,53) vs (0,10,18).
  - The Raid red wash (640,150) is hot red (252,40,53) vs the ref's lighter, pinker glow (250,173,164).

### p4_spawn_w: 9.5 -> 9.5
- **Gains:** ring interior (12,22,30) vs (4,15,16); saturation 107 = ref.
- **Remaining:**
  - The Story tree trunk is shorter than the ref's massive trunk.
  - The upper-right island underside is (74,97,125) vs a warm (169,151,90).
  - The arch is darker than the ref, (39,45,57) vs (51,56,76) at (150,330).

### p5_diag_ne: 9.5 -> 9.5
- **Gains:** the Raid door is dark; the slab no longer clips; the arch face (560,330) is (86,91,82) vs (76,81,81), on target.
- **Remaining:**
  - The saw-tooth inner band.
  - The bollard dome is still a smooth sphere on a tall taper.
  - Saturation 90 vs 91, on target.

### p6_diag_sw: 9.5 -> 9.5
- **Holds:** blue canopy and palms; the Story trunk mass.
- **Remaining:**
  - The portal overshot dark, (11,128,149) vs (19,155,170).
  - (800,250) is still light sky/stone (187,201,194) vs a dark canopy (66,80,59).
  - The canopy is a lighter slate-blue (37,80,200) vs royal (11,63,153).
  - Arch teeth. Saturation 106 vs 114.

### p7_high: 9 -> 9
- **Gains:** the E side now reads as red ground with a dark grey rubble band and fewer trees; (950,280) is (166,86,92) vs (163,60,65).
- **Remaining:**
  - The lagoon is unchanged, (72,102,165) vs (38,91,147).
  - The S lawn is unchanged, (121,188,97) vs (112,181,60).
  - The N canal at (640,250) is (185,195,190) vs a blue water course (123,144,191).
  - The centre plaza still lacks the grey stair masses with gold piping around the four fountains.
  - Saturation fell 83 -> 81 (ref 86).

### p8_top: 9 -> 9.5
- **Gains:** this camera's three round-30 complaints are all addressed:
  - The grey rubble band runs east from the E stair, (113,124,124) vs (105,110,103).
  - The SE corner is dark rock, (48,57,64) vs (54,56,51).
  - Green patches sit inside the red, and the salmon is gone.
- **Remaining:**
  - The red is a fine red/grey dither, not solid fields: (950,480) (167,104,83) vs (184,69,62). Saturation fell to 88 vs 102.
  - The green patches are small round bushes; the ref's are flat, about 10-15 studs, (132,176,50) with white dots.
  - The SE rock is a black cube cluster.
  - The W lagoon is still a heavy dark blue, (62,89,132) vs (119,133,145) with white surf and stone.

### c1_wall: 9.5 -> 9.5
- **Gains:** the arch face is dark slate and on target, (73,85,85) vs (60,64,60)/(89,90,90); the jet is a translucent dome.
- **Regressed:** the inner band is a saw-tooth ring of light-grey blocks over the dark niche, (560,400) (126,164,188) vs (20,31,49).
- **Remaining:**
  - The jet core (640,380) is still bright, (203,235,240) vs a dark niche (16,46,60) with a blue glow.
  - No lit water sheet at the back of the niche.

### c2_fountain: 9.5 -> 9.5
- **Gains:** Boss Rush face and sign much darker and calmer.
- **Remaining:**
  - The arch face overshot to near-black, (35,42,56) at (560,200) vs a lit slate (100,113,134).
  - The arch teeth show through the opening.
  - The Raid tower's red wash is hot.
  - Saturation 101 vs 110.

### c3_pavilion: 9 -> 9
- **Gains:** the arch face is darker; the jet is less white, (232,247,248) -> (192,231,237).
- **Remaining:**
  - The jet is still far too bright vs a dark niche with water, (33,65,81).
  - The upper-left white cloud is unchanged, (228,232,235) vs blue (99,203,241).
  - The falls are unchanged hard bars, (228,245,247) at (60,230).
  - The Raid facade is flat red without carved arches.

### c4_stairs: 9.5 -> 9.5
- Not touched (1.1% change). The entry is (204,182,107) vs (226,216,138); the door is (104,93,81) vs a bright door (193,170,115).
- Saturation 91 vs 80, 11 hot. The ref has stalls and a crowd on the stair top; the rep has four parasols.

## Scores
| camera | r30 | r31 |
|---|---|---|
| p1_spawn_n | 9 | 9 |
| p2_spawn_s | 9 | 9 |
| p3_spawn_e | 9.5 | 9.5 |
| p4_spawn_w | 9.5 | 9.5 |
| p5_diag_ne | 9.5 | 9.5 |
| p6_diag_sw | 9.5 | 9.5 |
| p7_high | 9 | 9 |
| p8_top | 9 | 9.5 |
| c1_wall | 9.5 | 9.5 |
| c2_fountain | 9.5 | 9.5 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 9.5 | 9.5 |
| **sum** | **111.5** | **112** |
| **average** | **9.292 (9.29)** | **9.333 (9.33)** |

Arithmetic: four cameras at 9 make 36 and eight at 9.5 make 76, so the sum is 112. 112 / 12 = 9.333.

## Top-10 for the next pass (ranked by visual impact)
1. **Arch inner band teeth (c1, c2, c3, p1-p6).**
   - Remove the angled straight blocks around the inner arch.
   - Replace them with one smooth curved band that follows the arch curve: about 1 stud wide, 0.3 stud proud, (150,155,155).
     A curved mesh from the Blender kit, or 16+ short segments each tangent to the curve with no gaps or overlaps.
   - Keep the niche behind it dark (20,31,49); c1 (560,400) is now (126,164,188).
2. **Jet and niche water (c1, c3, p1-p6).**
   - Thin the dome jet to about 60% of its width and set Transparency 0.6, tint (150,200,215). c1 (640,380) is (203,235,240); target (62,99,117) to (16,46,60).
   - Add the back water sheet that should have come with pass 33: a plane about 4 studs wide, (62,99,117), Transparency 0.3,
     with a faint blue glow, falling from the back of the niche into the drum.
3. **p3 upper-left (saturation -13, the largest view gap).**
   - In front of the grey-green floating island (141,166,152), put a royal-blue tree canopy (16,63,204) about 25 studs wide
     and 20 tall over a dark rock (93,77,60), NE of the plaza at about x +55 to +75, z -25 to -45, top about 35 studs up.
     It should cover p3 x 60-320, y 60-260.
   - Darken the Raid doorway from (31,44,53) to (0,10,18).
4. **E ground finish (p8, p7; p8 saturation 88 vs 102).**
   - Replace the red/grey dither with solid red fields (184,69,62), with sparse white flower dots.
   - Turn the round green bushes into 4-6 flat flower patches, each about 10-15 studs across, (132,176,50) with white dots.
   - Break the SE black-cube cluster into a rounded rock mound (54,56,51) with 2-3 lighter top faces (90,95,90).
5. **Arch face overshoot on the shaded views (c2, p1, p2, p4).**
   - c2 (560,200) is (35,42,56) vs lit (100,113,134); p1 (150,330) (46,55,65) vs (83,85,98).
   - Lift the base face colour to about (85,92,100) and use a material that shades (Slate or SmoothPlastic, not a neutral
     dark Plastic), so the lit side reaches about 100-110 and the shaded side stays about 60. Recheck c1 stays near (73,85,85).
6. **Lagoon, S lawn and N canal (p7, p8), carried three rounds.**
   - Lagoon (72,102,165) -> (38,91,147).
   - S lawn (121,188,97) -> (112,181,60).
   - N canal: tint the canal strip north of the plaza (185,195,190) -> blue water (123,144,191), about 8 studs wide.
   - Add white surf and stone breaks on the W lagoon in p8 so it reads (119,133,145) from above.
7. **Falls finish and c3 cloud (c3, c4, p1).**
   - Drop the fall body to (196,240,247) and add a second plane 1.5x wider at Transparency 0.75 for a soft edge.
   - Add a mist part (200,230,235), Transparency 0.6, about 8 studs wide, at each foot.
   - Turn the c3 upper-left cloud away, or rotate the skybox, so the ref blue (99,203,241) shows at (300,40).
8. **Expeditions portal and orb (p2, p6).**
   - Split the difference: p6 is 25 dark, (11,128,149) vs (19,155,170); p2 is close, (12,143,157) vs (10,131,145). Lift the
     plane about 8 to (14,150,165).
   - Lower the island and ivy band behind the orb about 10 studs, or raise the orb about 8, so the orb hangs against sky (183,206,214).
   - Tone the bright cyan side pillars (88,226,242) to (107,123,131).
9. **Summon entry and c4 saturation (+11).**
   - Make the centre entry a bright arched door (226,216,138) with a lit inner door (193,170,115); it is now (104,93,81).
   - Desaturate the purple and gold canopy around the Summon by about 10.
   - Add 4-6 stalls or lamp posts on the stair top.
10. **Bollard and p6 canopy finish.**
    - Tone the bollard gold from lit (208,183,24) to an aged gold (170,145,35) with lower Reflectance, so it shades like the ref (76,66,10) to (143,123,18).
    - Grey the slab toward (200,198,180).
    - Make the dome squatter, about 0.7 x the current height.
    - p6: fill (800,250) (187,201,194) with dark canopy (66,80,59), and deepen the blue canopy toward royal (11,63,153).
