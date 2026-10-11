# Verify round 18: Anime Expeditions spawn plaza (freestyle, after fix pass 20)

An independent reviewer scored the build against the **live reference** on the Shadow PC on 2026-10-10.
Round 17 (`verify17_plaza.md`, 7.75) was read only for comparison. Every score below is fresh.

> Note on the brief: the "Round 18 context" paragraph in `verify_brief18.md` repeats the round-17 text (pass 19).
> The build captured here is **pass 20** (`notes/fix20_plaza.md`, commit 019f520). It has a squat arch, dark tunnels, low
> white bollards, the Raid lit on the building and a new south gate, ring and beach. This review compares it with round 17.

## Method
- **Reference:** studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- **Practice:** studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only, through `capture_set2.py` / `mcpcli.py`. No code was run in either studio, and nothing
  was modified or saved in either studio.
- **Captures:** each camera was captured twice in each studio, and the second frame was judged. The judged frames are
  `out/verify18/v18_<cam>_ref.jpg` and `v18_<cam>_rep.jpg`, 1452x793.
  - Pixels changing by more than 30 levels between the two frames: 1.0-6.2% in the reference (water, VFX, crowd) and
    0.0-1.1% in the practice (fountain mist). That is animation, not streaming.
- **Colours:** every RGB below is a 5x5 mean from those JPEGs, given with its frame and pixel box (x0-x1, y0-y1).
  - Targets are sampled from the reference frame.
  - Each box was checked visually with zoomed tiles, to confirm it lands on the named feature.
  - Stud sizes are estimates from the pictures.

## Overall read
Pass 20 fixed most of the round-17 top-5:

| Fix | Evidence |
|---|---|
| **Tunnels are dark** | Tunnel now (63,71,79) (c1 rep, box 898-902, 418-422) against (44,54,62) (c1 ref, box 878-882, 468-472). Only the water is bright, as in the reference. |
| **Arch opening is squat** | In c1 the opening top is at y≈365 in both frames. |
| **Bollards are right** | White block base with a round gold head, the reference type. Rim beads are now flat discs. |
| **Raid is lit on the building** | Door frame (179,87,89) (p3 rep, box 688-692, 328-332) against (181,108,113) (p3 ref, box 693-697, 298-302). Round 17 had (81,27,35). |
| **Stairs have depth** | Pale treads (182,190,185) (c4 rep, box 243-247, 728-732) against (186,191,185) (c4 ref, box 398-402, 688-692), with dark risers. |
| **South side rebuilt** | Grey ring shards, a teal gate with a statue, a green palm upper right, sand discs and swim rings in the foreground. |

What now separates the build from the reference, by visual impact:
1. **The background.** The practice skyline is plain white boxes and towers, with round green lollipop trees and green-drip
   islands in a clean, saturated sky.
   - The reference has ruined arcades, domed palaces, two wide falls, an aqueduct and soft haze.
   - Mean saturation of the top half: reference 55-64, practice 71-95. The practice background is harder and more
     saturated than the reference.
   - It shows in every player-height camera.
2. **West blue mass.** It is still far too big. Blue cover in p8 x 0-420, y 150-650 is 60% against 39%. In p7 x 0-450,
   y 100-700 it is 40% against 15%.
3. **Arch crown detail (c1, p1-p6).**
   - The centre notch is open to the sky and the blue trees, with a dark lintel and a cyan slot under it. The reference
     notch is closed, small and dark.
   - The outer slate band is too light.
   - The gold ledge across the tunnel is missing.
4. **Stair blocks.** Risers are tall flat navy bands across the whole width. The reference reads as chunky separate
   blocks with bevels.
5. **Grass** is still tall green spikes on the stairs (c2, p2, p4, p6).
6. **Basins** are bright cyan, not teal. **Runners** are flat and too dark a blue.

## Per camera (round 17 -> round 18)

### p1_spawn_n: 8 -> 8
- **Gains:**
  - Bollards are now low white blocks with round gold heads, matching the reference type and position.
  - Flat rim discs.
  - Dark tunnels with bright water.
- **Geometry:**
  - **Arch notch:** open to the sky. The reference notch is closed and filled with a dark tree and pods.
  - **Bollard heads:** about 15% too large, and polished.
    - Head (223,224,168) (rep, box 438-442, 483-487) against a duller (119,109,32) (ref, box 438-442, 498-502).
    - The reference head has a groove ring and a darker gold.
- **Colour:**
  - Paving matches: (202,207,204) (rep, box 998-1002, 718-722) against (193,195,188) (ref, same box).
  - The central N runner reads light blue at the stair foot: (101,156,203) (rep, box 718-722, 458-462). The reference has
    a pale stone landing there, (149,160,160) (ref, box 718-722, 448-452).
- **Missing:**
  - Wide falls and the aqueduct; the boxy white towers stand where these should be.
  - Crowd and parasols on the N terrace.
  - Gold trees are present but read as clipped balls.

### p2_spawn_s: 7 -> 7.5
- **Gains:** grey ring shards around the white disc, a big green palm upper right and a teal gate. The composition
  now matches.
- **Geometry:**
  - **Gate:** a flat teal box with a white statue and three plain arches. The reference is an ornate turquoise frame with
    filigree, side lamp posts, crystal fountains and a cloud-swirl door.
  - **Ring:** shards about the right size. The reference adds pale cloud mass around the ring.
- **Colour:**
  - Sky is right: (50,195,240) (rep, box 818-822, 98-102) against (41,186,241) (ref, same box). The practice has far
    fewer clouds and islands.
  - Stair-top lawn missing: (108,132,126) (rep, box 558-562, 376-380) against a soft lawn (110,174,68) (ref, same box).
- **Missing:**
  - Tree on the rock pillar upper left.
  - Domed palaces at left.

### p3_spawn_e: 8 -> 8.5
- **Gains:** the Raid facade is lit red.
  - Door frame (179,87,89) (rep, box 688-692, 328-332) against (181,108,113) (ref, box 693-697, 298-302).
  - Haze near the tower (162,70,46) (rep, box 618-622, 198-202) against (178,95,67) (ref, same box).
  - The door arch width matches: ref x≈680-765, rep x≈682-770.
  - Bollards and tunnels are fixed.
- **Geometry:**
  - **Skull tower:** a tall slab with a flat face. The reference skull is rounded and sits on a red rock mound flanked by
    spires.
  - **Raid sign:** sits on the tower, about 1.5x too large. The reference sign sits on the door gable.
- **Missing:**
  - Dense dark-red tree canopy and red palms around the facade.
  - The rock mass at left.

### p4_spawn_w: 8 -> 8
- **Gains:** bollards and tunnels.
- **Geometry:** the Story tree is still a short trunk under a single blue blob. The reference trunk is huge and gnarled,
  with roots and limbs through the top third.
  - The portal interior is dark in both: (10,19,34) (rep, box 718-722, 328-332) against (6,16,18) (ref, same box). That
    part is right.
- **Colour:** tall spiky grass on the W stairs. The reference has low leafy clumps.
- **Missing:** the blue palm fringe either side of the portal, and the palace at right.

### p5_diag_ne: 8 -> 8
- **Gains:** the bollard in the centre foreground is now the right type and size.
- **Geometry:**
  - **Side runners:** flat inlays on the plaza.
    - The reference runners are raised, bevelled slabs with thick gold rims, (208,190,89) (ref, box 148-152, 498-502),
      and a cyan gem near the foot.
    - They stand about 2x taller in frame: ref y≈380-670, rep y≈400-540.
  - **Summon building:** a plain cream box with bunting. The reference is an ornate gold-and-stone palace.
- **Colour:** runner blue too dark: (42,83,179) (rep, box 148-152, 408-412).

### p6_diag_sw: 7 -> 7.5
- **Gains:** teal Expeditions gate; the green palm sits behind the arch, as in the reference; bollard.
- **Geometry:**
  - **Gate:** a plain teal box, as in p2.
  - **Story frame:** reads as a ring of stone blocks. The reference is a smooth silver horseshoe with blue gems.
- **Colour:** spiky grass on both stairs.
- **Missing:**
  - The soft lawn, the orange tree and the lamp posts at the Expeditions gate.
  - The palm grove to the right of the arch.

### p7_high: 7 -> 7
- **Gains:** sand discs and a swim ring in the S foreground.
- **Geometry:** the W side is a blanket of blue crowns: 40% blue against 15% (x 0-450, y 100-700). The reference W is
  mixed blue palms, water, rock and sand.
- **Colour:**
  - Basins: practice cyan (119,222,227) (rep, box 378-382, 538-542); reference teal (67,154,178) (ref, box 918-922,
    468-472).
  - E side green: 10% against 23% (x 1000-1452, y 100-700).
- **Missing:** the large green palm cluster and the beach props in the S foreground. In the practice, white plinth
  paths dominate there.

### p8_top: 8 -> 8
- **Layout matches.**
  - Basin centres: ref (590/860, 250/520), rep (580/870, 245/530).
  - E red/green: 36% / 7% against 36% / 9%.
- **Geometry:**
  - **E/W arms:** about a third of the reference length.
    - The reference arms are long, pale-bordered crosses (each about 220 px from the medallion edge) with blue runners and
      cyan tips.
    - In the practice they are short blue strips, about 60 px. The W arm runs into a separate white platform.
  - **Medallion diamond:** about 1.3x too large (ref ≈130 px across, rep ≈170 px).
  - **Small arches by the basins:** read from above as chunky grey blocks. The reference shows gold-trimmed curves.
- **Colour:**
  - E red matches: (197,65,57) (rep, box 1098-1102, 298-302) against (200,65,54) (ref, box 1248-1252, 298-302).
  - E grass holes are round lime discs, (110,156,72) (rep, box 998-1002, 198-202). The reference has irregular holes,
    (132,172,53) (ref, box 988-992, 298-302), with white flowers.
  - W blue is 60% against 39%.

### c1_wall: 8 -> 8
- **Gains:** the tunnel is dark slate, with a bright splash only. The opening top is at y≈365 in both frames.
- **Geometry:**
  - **Notch:** open between the ears.
    - Rep x≈617-806, with a shelf at y≈263, a heavy dark lintel to y≈310 and a cyan slot light, (89,138,157) (rep, box
      718-722, 288-292).
    - The reference notch is x≈650-800 and closed at y≈302 by the pale band. Its interior is dark, (62,69,71) (ref, box
      718-722, 288-292).
  - **Opening:** about 1.2x wider at y≈450 (ref x≈506-1016, rep x≈448-1073). The fountain sits inside the mouth; in the
    reference it stands in front of it.
  - **Gold ledge missing:** the reference has a gold ledge across the tunnel at y≈432-453, x≈524-914, (78,75,16) (ref, box
    558-562, 440-444).
- **Colour:**
  - Outer slate band too light: (89,102,108) (rep, box 406-410, 349-353) against (36,46,54) (ref, box 469-473, 349-353).
  - Pale band close: (130,141,143) (rep, box 554-558, 328-332) against (119,124,127) (ref, box 554-558, 349-353).
  - Splats still washed out:
    - Left (184,244,254) (rep, box 398-402, 688-692) against (82,162,244) (ref, box 338-342, 668-672).
    - Right (250,187,171) (rep, box 1098-1102, 698-702) against (226,97,95) (ref, box 1118-1122, 628-632).

### c2_fountain: 8 -> 7.5
- **Gains:** the tunnel is dark, as in c1.
- **Geometry:**
  - **Grass:** spiky blades fill the lower-right stairs.
    - Practice cover 6.6% of x>800, y>400, against 4.2%.
    - Practice blades are 3-4x taller and hard-edged, (97,184,55) mean. The reference is one soft clump, (114,166,54)
      (ref, box 928-932, 588-592).
  - **Stair risers:** read as near-black bands under thin pale treads, so the stair is stripy. The reference stair is a
    solid grey block stack.
- **Colour:**
  - Basin water is close: (166,200,206) (rep, box 508-512, 428-432) against (133,196,205) (ref, box 518-522, 463-467).
  - The Raid haze is a brown cloud above the facade.
- **Missing:**
  - The Boss Rush building is a pink box with a purple spiral. The reference is a lit purple gothic shrine.
  - The orange tree and the grey palace domes at right.

### c3_pavilion: 8 -> 8
- **Gains:** dark tunnel; the arch reads correctly from below; the Raid door is lit.
- **Geometry:** the skyline is white box towers with round green trees on islands. The reference has ruined arcades, two
  falls and dense foliage.
- **Colour:**
  - The Raid glow wraps the reference tower, (183,60,71) (ref, box 1348-1352, 278-282). The practice glow is a brown
    cloud beside the tower.
  - Stairs read navy and stripy.
- **Missing:** the tall blue palm left of the pavilion, and the Summon facade detail.

### c4_stairs: 8 -> 8
- **Gains:**
  - Tread tone now matches: (182,190,185) (rep, box 243-247, 728-732) against (186,191,185) (ref, box 398-402, 688-692).
  - The risers are dark.
- **Geometry:**
  - **Risers:** continuous navy bands, (42,69,95) (rep, box 243-247, 653-657), the full width of the stair, with small
    wedge spacers.
    - The reference riser shadow is lighter, (85,107,121) (ref, box 428-432, 653-657).
    - The reference treads are split into 4-6 stud blocks with rounded bevels.
  - **Pineapple:** still a smooth gold pot, (202,167,5) (rep, box 198-202, 398-402), against a textured fruit, (134,92,24)
    (ref, box 188-192, 408-412).
- **Colour:** the runner is too dark and saturated: (28,55,168) (rep, box 638-642, 698-702) against (75,126,225) (ref,
  box 658-662, 698-702).
- **Missing:** the aqueduct, the falls, the lamp posts and the crowd.

## Scores
| camera | r17 | r18 |
|---|---|---|
| p1_spawn_n | 8 | 8 |
| p2_spawn_s | 7 | 7.5 |
| p3_spawn_e | 8 | 8.5 |
| p4_spawn_w | 8 | 8 |
| p5_diag_ne | 8 | 8 |
| p6_diag_sw | 7 | 7.5 |
| p7_high | 7 | 7 |
| p8_top | 8 | 8 |
| c1_wall | 8 | 8 |
| c2_fountain | 8 | 7.5 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 8 | 8 |
| **average** | **7.75** | **7.83** |

## Top-10 for the next pass (ranked by visual impact)
1. **Background skyline and haze.** Seen in p1-p6, c1-c4.
   - Replace the plain white box towers behind N/E/W with 3-4 ruined arcade silhouettes: 2-3 tiers of round arches,
     about 30-40 studs tall, stone (180,185,180).
   - Add 2 domed palaces, about 25 studs, with blue-grey domes.
   - Add two wide translucent falls (4-6 studs wide, transparency 0.4) dropping from the N islands, and a 4-arch aqueduct
     between them.
   - Delete the round green lollipop trees on the islands. Use 2-3 irregular canopies per island instead.
   - Add Atmosphere haze (Density about 0.3, Haze 1-2, colour (200,220,235)) to soften the background. The top-half
     saturation should drop from 71-95 to about 60.
2. **Thin the W blue mass.** Seen in p7, p8, p4, p6.
   - Delete about 40% of the W blue crowns, so blue cover in p8 (x 0-420, y 150-650) drops from 60% to about 40%. In p7
     (x 0-450, y 100-700) it should drop from 40% to about 20%.
   - Fill the gaps with 3-4 blue palms (25-30 studs), open water and sand.
3. **Arch notch, outer band and tunnel ledge.** Seen in c1, p1-p6.
   - Close the notch:
     - Narrow it from x≈617-806 to x≈650-800 in c1, about 20% narrower.
     - Remove the dark lintel and the cyan slot light.
     - Extend the pale band up to y≈302 so the notch is a small closed U, dark inside, (62,69,71) (c1 ref, box 718-722,
       288-292).
   - Darken the outer slate band from (89,102,108) to (36,46,54) (c1 ref, box 469-473, 349-353).
   - Add a gold ledge across the tunnel, about 0.6 studs tall and the full tunnel width, at about one third of the
     opening height (c1 ref y≈432-453, x≈524-914), in (78,75,16) (c1 ref, box 558-562, 440-444).
   - Narrow the opening about 15% at mid-height, and move the fountain about 2 studs forward so it stands in front of the
     arch mouth.
4. **Stair blocks.** Seen in c4, c2, c3, p1-p6.
   - Lighten the risers from (42,69,95) to (85,107,121) (c4 ref, box 428-432, 653-657).
   - Cut each tread into 4-6 stud blocks with a 0.2-0.3 stud rounded bevel, and offset the joints row to row.
   - Remove the wedge spacers.
5. **Grass style.** Seen in c2, p2, p4, p6.
   - Replace the spike blades with soft leafy clumps 1-1.5 studs tall, at about 60% of the present count, in
     (114,166,54) (c2 ref, box 928-932, 588-592).
   - Run a soft lawn strip about 1 stud wide along the S and W stair-top lips, in (110,174,68) (p2 ref, box 558-562,
     376-380).
6. **E/W cross arms and side runners.** Seen in p8, p5, p6.
   - Extend the E and W arms to about 3x their present length (about 20 more studs each). Give them pale stone borders,
     a blue runner and a cyan diamond tip, as on the N/S arms.
   - Remove the separate white W platform, or merge it into the arm.
   - Raise the plaza-side runners into bevelled slabs about 1 stud high, with gold rims about 0.5 stud thick,
     (208,190,89) (p5 ref, box 148-152, 498-502), and a cyan gem near the foot.
   - Runner blue from (28,55,168) to (75,126,225) (c4 ref, box 658-662, 698-702).
7. **Raid glow on the tower and skull shape.** Seen in c2, c3, p3, p5.
   - Pull the brown haze cloud onto the skull tower, so it wraps the tower down to the door. Retint it to (183,60,71)
     (c3 ref, box 1348-1352, 278-282).
   - Round the skull, and seat it on a red rock mound with two lit spires, about 8 studs, either side.
   - Move the "Raid" sign down onto the door gable, at about 65% of its present size.
8. **Basins teal.** Seen in p7, p8, c2.
   - Water from (119,222,227) to (67,154,178) (p7 ref, box 918-922, 468-472).
   - Add a darker teal rim ring and a bright splash only at the centre jet.
9. **Gate and Summon facades.** Seen in p2, p6, p5, c3.
   - Expeditions gate: add filigree gold or turquoise arch tops, two lamp posts and two small crystal fountains either
     side. Replace the flat teal door with a cloud-swirl door (turquoise (60,180,180) with a lighter swirl).
   - Summon: add an ornate gold cornice, columns and a central gold medallion over the door.
   - Shrink the medallion diamond to about 75% (p8: from about 170 px to about 130 px across).
10. **Splats and close props.** Seen in c1, p5, c4, p8.
    - c1 left splat from (184,244,254) to (82,162,244) (c1 ref, box 338-342, 668-672).
    - c1 right splat from (250,187,171) to (226,97,95) (c1 ref, box 1118-1122, 628-632).
    - Pineapple: textured diamond-pattern fruit, (134,92,24) (c4 ref, box 188-192, 408-412), about 6 studs, with a
      spiky crown.
    - E ground: replace the round lime discs with irregular grass holes, (132,172,53) (p8 ref, box 988-992, 298-302),
      with white flower dots.
    - Bollard heads: 15% smaller, duller gold (119,109,32) (p1 ref, box 438-442, 498-502), with a groove ring.
