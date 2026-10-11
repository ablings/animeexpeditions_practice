# Verify round 17: Anime Expeditions spawn plaza (freestyle, after fix pass 19)

Scored against the **live reference** on the Shadow PC on 2026-10-10 by an independent reviewer who had not seen the build
before. Round 16 (`verify16_plaza.md`) was read for context only; every score below is fresh.

## Method
- **Reference:** studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- **Practice:** studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only. No code was run in Studio; nothing was modified or saved in either studio.
- **Captures:** `v17_<cam>_ref_a` / `v17_<cam>_ref` and `v17_<cam>_rep_a` / `v17_<cam>_rep`, all 1452x793 JPEG, saved in
  `out/verify17/`. p4 and p6 have one extra reference frame (`_ref_b`).
  - Pixels changing by more than 30 levels within a pair: 2.2-4.9% in the reference (water, VFX, portals, crowd) and
    0.0-0.4% in the practice (fountain mist). That is animation, not streaming, so the second frame was judged.
- **Colours:** every RGB is a 5x5 mean from those JPEGs, given with frame and pixel box (x0-x1, y0-y1). Stud sizes are
  estimates from the pictures.

## Overall read
Pass 19 fixed two of the round-16 headline problems:
- **The arch mouths are no longer black voids.** In every spawn view and in c1, c2, c3 the tunnel is now lit cyan with a
  back wall. The composition of c1 (Summon left, arch with ears and two pods centre, Raid right, blue splat left, red
  splat right) now matches the reference.
- **The arch width is right in c1.** Reference x≈405-1045, practice x≈400-1050. The dark-slate outer band and pale
  front band read correctly from c1 and c2.
- **E ground ratio is right.** In p8 (region x 930-1300, y 150-650) practice is 31% red / 7% green against the reference's
  32% / 10%.
- **The N stair-top cypresses** match: practice (22,73,169) against reference (33,65,183) (c4 ref, box 313-317, 298-302).
  The big crystals at the N stair top are gone.

What now separates the build from the reference, by visual impact:
1. **The Raid is still lit by a brown cloud, not red light.** The haze is a wide rust cloud in the sky behind the skull;
   the facade itself stays dull. Door frame: practice (81,27,35), reference (181,108,114) (p3, box 693-697, 298-302).
2. **The arch tunnel overshot.** It is now uniformly bright cyan inside, (55,130,175) (c1 rep, box 538-542, 438-442).
   The reference interior is dark slate, (44,54,61) (c1 ref, box 878-882, 468-472) and (30,52,72) (c1 ref, box
   598-602, 398-402); only the water splash is bright, (196,248,254) (c1 ref, box 718-722, 428-432). The crown band is
   also too thin: in c1 the reference pale band runs from y≈155 to the opening at y≈365 (210 px), the practice from
   y≈145 to y≈300 (155 px), so the practice opening is a tall rounded doorway where the reference is a squat horseshoe.
3. **Bollards and rim beads are unchanged** and are the largest objects in the lower half of p1, p3-p6.
4. **Stairs have no tonal depth.** Practice treads and risers are almost the same pale grey.

Unchanged since round 16: spiky grass, the S side (shard ring, gate, palm, beach), the boxy skyline, the pot-pineapple,
the bright basins, the heavy W blue-tree mass in p7/p8.

## Per camera (round 16 -> round 17)

### p1_spawn_n: 8 -> 8
- **Gains:** both tunnels lit; the corner blue trees are smaller and no longer dominate the top corners.
- **Geometry:**
  - **Arches:** right width but the opening is too tall and the crown too thin; the outer slate sweep stops short. In
    the reference it fans down to the stair rails in two or three stepped slate bands.
  - **Bollards:** still faceted gold pyramids on a tapered grey pedestal, about 1.5x the reference height. The reference is
    a low white base with a round gold head.
  - **Rim:** domed gold beads remain on the medallion rim.
- **Colour:** tunnel interior (58,77,96) at box 198-202, 398-402 is close to the reference arch slate (71,78,91) (p1 ref,
  box 248-252, 298-302) at the edges, but the centre of each mouth is saturated cyan.
- **Missing:** wide falls and aqueduct; plain box towers; the crowd.

### p2_spawn_s: 7 -> 7
- **Gains:** lit tunnels, as in p1.
- **Geometry:** the shard ring still floats as navy fragments in clear sky (reference: grey rock shards in a cloudy rock
  skyline). The Expeditions gate is about 70% of the reference width, spiral door instead of turquoise cloud door.
- **Colour:** stair grass is tall dark spikes; the reference has a soft lawn strip, (118,183,72) (p2 ref, box 558-562,
  376-380).
- **Missing:** big green palm upper right; tree on a rock pillar upper left.

### p3_spawn_e: 8 -> 8
- **Gains:** lit tunnels; the haze is bigger and redder than round 16.
- **Lighting:** the haze sits in the sky as a rust cloud, (151,88,86) (rep, box 598-602, 148-152), and the facade stays in
  neutral daylight. In the reference the red light is on the building: door frame (181,108,114) (ref, box 693-697,
  298-302), side towers (124,39,59) (ref, box 848-852, 168-172), haze close to the skull (162,66,74) (ref, box 643-647,
  173-177). Practice door frame is (81,27,35) at the same box.
- **Geometry:** the skull tower is a tall flat-sided block; the reference skull sits on a rounded mound with lit spires
  either side. The ember band is still a 1-2 px red line, (131,18,20) (rep, box 698-702, 376-380).
- **Missing:** rock mass and green palm at left.

### p4_spawn_w: 8 -> 8
- **Gains:** lit tunnels; west blue cluster smaller.
- **Geometry:** Story trunk still short and capped just above the sign; the reference trunk is huge, gnarled, with limbs
  through the top third.
- **Colour:** spiky grass on the W stairs. Story portal interior is a flat black disc (reference: blue swirl).

### p5_diag_ne: 8 -> 8
- **Gains:** arch now has a lit interior and the right dark/pale banding; big red palm and Summon arcade in place.
- **Geometry:**
  - **Bollard:** dominates the lower centre: faceted gold cap (207,173,13) (rep, box 718-722, 478-482) on a grey pedestal
    (169,173,177) (rep, box 718-722, 598-602). Reference head (223,214,144) (ref, box 718-722, 543-547) on a white
    base (240,239,230) (ref, box 718-722, 638-642), about 60% of the practice height.
  - **Arch:** about 0.8x the reference span here (ref x≈518-915, rep x≈563-885). Opening too tall.
- **Colour:** E stair splats are thin pink streaks; the reference has dense red clumps.

### p6_diag_sw: 7 -> 7
- **Gains:** lit tunnel; the blue tree above the arch is smaller.
- **Geometry:** dominant faceted bollard; Expeditions gate with spiral door; Story portal flat black.
- **Missing:** big green palm at top centre, orange tree, soft lawn, crystal fountains at the gate.

### p7_high: 7 -> 7
- **Gains:** the S fountain trees are smaller.
- **Geometry:** the W side is still a solid blanket of blue tree crowns (x 0-300, y 350-700) hiding the W pavilions.
  The reference W side is mixed blue palms, water, rock and sand.
- **Colour:** basins bright cyan (130,230,234) (rep, box 378-382, 538-542); reference basins are teal.
- **Missing:** S beach (250,249,215) (ref, box 378-382, 638-642) with green palm, pineapple and swim rings.

### p8_top: 8 -> 8
- **Gains:** E red/green ratio now matches (31% / 7% against 32% / 10%).
- **Geometry:** the E cover reads as stamped heart-shaped red cards and round lime discs (polka dots). The reference is
  continuous painted ground with irregular green holes and white flowers.
- **Colour:** red cards are close; lime discs (111,155,70) (rep, box 998-1002, 198-202) against grass holes (123,169,50)
  (ref, box 988-992, 298-302). Basins read bright blue; reference (117,205,213) (ref, box 558-562, 248-252).
- **Missing:** S beach props and palms; W blue trees still about 1.5x the reference area.

### c1_wall: 8 -> 8
- **Gains:** width now matches; splats are on the right sides; pale front band with dark outer band; lit tunnel.
- **Geometry:**
  - **Crown:** too thin. Lower the opening top by about 2 studs (≈65 px in this frame) so the pale band is about 35%
    deeper, and widen the opening at its springing so it is a low horseshoe, not a tall rounded doorway.
  - **Outer band:** one flat slate band with a blue marble texture; the reference has two stepped slate bands with gold
    edges.
  - **Fountain:** a clear glass tube with mist on a dark drum; the reference has a sculpted splash shape.
- **Colour:**
  - Interior bright cyan (55,130,175) (rep, box 538-542, 438-442); target dark slate (44,54,61) (ref, box 878-882,
    468-472).
  - Splats are pale: left (145,202,158) (rep, box 398-402, 658-662) against (80,163,247) (ref, box 338-342, 668-672);
    right (255,145,136) (rep, box 1148-1152, 688-692) against (227,96,93) (ref, box 1118-1122, 628-632).

### c2_fountain: 8 -> 8
- **Gains:** arch side reads dark slate, (30,45,69) (rep, box 638-642, 288-292) against (50,56,77) (ref, same box);
  lit tunnel.
- **Geometry:** tall spiky grass blades fill the lower-right quarter; the reference has one soft clump (114,166,54) (ref,
  box 928-932, 588-592).
- **Colour:** Raid haze still a brown cloud behind the skull tower.
- **Missing:** orange tree (158,117,80) (ref, box 1298-1302, 208-212); grey palace domes at right (practice: white blobs).

### c3_pavilion: 8 -> 8
- **Gains:** lit tunnel; red palm silhouette right; pods and blue tree match.
- **Lighting:** haze (142,113,126) (rep, box 1378-1382, 218-222) against (246,98,100) (ref, box 1348-1352, 278-282):
  the reference glow is twice as saturated and wraps the tower down to the door.
- **Geometry:** boxy skyline towers; reference has ruined arcades, domes, two wide falls and an aqueduct. Tall blue palm
  left of the pavilion missing.

### c4_stairs: 8 -> 8
- **Gains:** two slim blue cypresses frame the steps and match in colour; stair-top crystals removed.
- **Geometry:** pineapple still a gold pot with flat leaves, (201,167,5) (rep, box 218-222, 398-402), against a textured
  fruit (140,96,24) (ref, box 188-192, 408-412) with a spiky crown.
- **Colour:** stair treads now too pale and flat: (201,203,197) (rep, box 298-302, 558-562) against (158,164,162) (ref,
  same box); riser shadow (196,197,190) (rep, box 398-402, 518-522) against (75,97,113) (ref, same box).
- **Missing:** aqueduct, wide falls, lamp posts, crowd.

## Scores
| camera | r16 | r17 |
|---|---|---|
| p1_spawn_n | 8 | 8 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 8 | 8 |
| p4_spawn_w | 8 | 8 |
| p5_diag_ne | 8 | 8 |
| p6_diag_sw | 7 | 7 |
| p7_high | 7 | 7 |
| p8_top | 8 | 8 |
| c1_wall | 8 | 8 |
| c2_fountain | 8 | 8 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 8 | 8 |
| **average** | **7.75** | **7.75** |

No camera moved a whole point. Pass 19 removed the two worst defects (black mouths, oversized arch) and the build is a
strong 8 in c1, p1, p3, p5; what holds it back now is the Raid lighting, bollards, stair tone and the unbuilt S side.

## Top-10 fixes (ranked by visual impact)
1. **Raid: light the building, not the sky.** (p3, p5, c1, c2, c3.)
   - Shrink the haze cloud to about 50% of its present spread and keep it hugging the skull and towers (top no higher
     than the skull crown); retint to (162,66,74) (p3 ref, box 643-647, 173-177).
   - Put 4-6 red PointLights/SpotLights (255,60,50), brightness 3-4, range 18-20, at door height in front of the facade
     and one inside the door arch, so the door frame reads (181,108,114) (p3 ref, box 693-697, 298-302) and the side
     towers (124,39,59) (p3 ref, box 848-852, 168-172). Practice door frame is (81,27,35).
   - Replace the 1-px red line at the base with a 2-stud-tall ember/glow band (Neon (200,40,30), transparency 0.4, plus
     ember particles) across the full facade width.
2. **Arch: thicker crown, lower opening, darker tunnel.** (p1-p6, c1, c2, c3.)
   - Lower the opening top by about 2 studs (c1: from y≈300 to y≈365 px) and widen the springing so the opening is a low
     horseshoe; keep the outer width as it is.
   - Split the outer slate band into two stepped bands, about 1.5 studs each, with gold edges, fanning down onto the
     stair rail.
   - Recolour the tunnel walls/back wall to dark slate (44,54,61) (c1 ref, box 878-882, 468-472); cut the cyan light to
     brightness 1, range 8, aimed at the water only. Keep the water/splash bright, (196,248,254) (c1 ref, box 718-722,
     428-432).
   - Swap the glass tube for a sculpted splash mesh (a 3-lobe wave, about 3 studs tall) on the drum.
3. **Bollards and rim beads.** (p1, p3-p6, c3.)
   - Bollard at about 60% of present height: white base (240,239,230) (p5 ref, box 718-722, 638-642), about 3x3x1.5
     studs; squat round gold head (223,214,144) (p5 ref, box 718-722, 543-547), about 1.5 studs. No facets, no point.
   - Delete the domed gold beads on the medallion rim; keep only flat discs.
4. **Stair tone.** (c4, p1-p6, c1, c3.)
   - Treads to (158,164,162) (c4 ref, box 298-302, 558-562); risers/undersides to (75,97,113) (c4 ref, box 398-402,
     518-522). Add a 0.2-stud bevel/chamfer and split each tread into 4-6 stud blocks.
5. **Grass style and lawn strip.** (c2, p2, p4, p6.)
   - Replace tall spikes with soft clumps 1.5-2 studs tall, (114,166,54) (c2 ref, box 928-932, 588-592), at about one
     third of the present count.
   - Run a 1-stud lawn strip (118,183,72) (p2 ref, box 558-562, 376-380) along the S and W stair-top lips.
6. **W blue trees and basins.** (p7, p8, p4, p6.)
   - Thin the W blanket of blue crowns by about 40% and break it with 3-4 blue palms (25-30 studs) and open water/sand.
   - Basins to teal (117,205,213) (p8 ref, box 558-562, 248-252); practice reads (130,230,234) from p7.
7. **S side.** (p2, p6, p7.)
   - Shard ring: grey rock (150,155,160), drop about 15 studs, scale 1.3x.
   - Gate: scale 1.3x; turquoise cloud door in place of the spiral.
   - 30-stud green palm upper right of the gate.
   - S foreground: sand beach (250,249,215) (p7 ref, box 378-382, 638-642), about 40x20 studs, with palm, pineapple and
     swim rings, in place of the lawn and plinth path.
8. **E ground pattern.** (p8, p7.)
   - Keep the ratio; merge the heart-shaped red cards into larger irregular patches (8-15 studs) in (211,83,57) (p8 ref,
     box 1248-1252, 298-302).
   - Replace round lime discs with irregular grass holes (123,169,50) (p8 ref, box 988-992, 298-302) with white flower
     dots; add about 3 points of green (10-12 more holes).
9. **Splat saturation.** (c1, p5, p3.)
   - c1 left: (80,163,247) (c1 ref, box 338-342, 668-672); practice is pale (145,202,158).
   - c1 right: (227,96,93) (c1 ref, box 1118-1122, 628-632); practice is pink (255,145,136).
   - E stair treads: dense red clumps, about 40% cover on the bottom steps.
10. **Skyline and close props.** (p1, c2, c3, c4.)
    - Pineapple: textured fruit (140,96,24) (c4 ref, box 188-192, 408-412), about 6 studs, diamond pattern, spiky crown.
    - Orange tree (158,117,80) (c2 ref, box 1298-1302, 208-212) behind the SE pavilion.
    - Two wide translucent falls (4 studs) and a 4-arch aqueduct between the N islands; ruined arcade tops on the box
      towers.
