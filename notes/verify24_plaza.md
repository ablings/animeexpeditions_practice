# Verify round 24: Anime Expeditions spawn plaza (freestyle, after fix pass 26)

Independent review against the **live reference** on the Shadow PC, 2026-10-11. Round 23 (`verify23_plaza.md`, 8.67)
was read only for comparison. Every score below is fresh.

## Method
- **Reference:** studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, cameras from `cams.json`.
- **Practice:** studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885`, cameras from `cams_practice.json` (x - 3000, y - 3).
- **Tools:** `screen_capture` only, through `capture_set2.py` -> `mcpcli.py call screen_capture`. No code was run in either
  studio, nothing was modified or saved in either studio, and no computer use was used.
- **Captures:** each camera was captured twice per studio and the second frame was judged. The judged frames are
  `out/verify24/v24_<cam>_ref.jpg` and `v24_<cam>_rep.jpg` (1452x793). Raw PNGs are in `out/verify24/raw/`. Pixels that
  changed by more than 30 levels between the two frames: 0.9-6.5% in the reference (water, VFX, crowd) and 0.0-2.3% in
  practice. That is animation, not streaming.
- **Colours:** every RGB is a 5x5 mean from the judged JPEGs, given as frame + box (x0-x4, y0-y4). Each target was picked
  in the reference frame. Each box was checked on a 2x zoomed 120 px tile in both frames, and boxes that missed were moved
  and re-sampled (the rim gold and the Y core). Where the practice feature sits somewhere else, the practice box is moved
  onto it and both boxes are given. Stud sizes are estimates from the pictures.
- **Coverage metrics:** PIL HSV with the same thresholds as round 23. Columns are reference r24 / practice r23 /
  practice r24.
  - Top-half mean saturation: p1 84/96/90, p2 100/113/88, p3 102/109/91, p4 108/119/105, p5 93/107/101,
    p6 110/106/90, p7 87/82/76, p8 104/92/86, c1 97/117/112, c2 106/117/104, c3 94/93/90, c4 86/118/115.
  - W blue: p8 (x0-420 y150-650) 41.0 / 44.8 / 44.3; p7 (x0-450 y100-700) 13.4 / 22.6 / 21.4.
  - E green (x1000-1452 y100-700): p7 25.4 / 16.9 / 15.7; p8 3.7 / 8.8 / 8.1.
  - E red, same box: p7 19.9 / 18.2 / 18.0; p8 41.3 / 38.8 / 37.2.
  - c2 stair green (x800-1452 y400-793): 6.4 / 10.6 / **5.6**.

## Overall read
Pass 26 delivered most of what it targeted:
- **Stairs:** the risers now match. Tread-edge highlights make the steps read as stepped stone.
- **Runner rim gold:** now matches up close.
- **Grey undersides:** gone from the frame corners in p1, p2, p4 and c3.
- **Ferns:** lighter, flatter and close to the right amount. c2 stair green is 5.6 against 6.4.
- **Blue/red clumps:** in c1 they now stand where the reference has its blue (W) and red (E) sprays, instead of flat
  floor splats.
- **Sky:** paler, with cloud, and the p2/p3/p6 top halves now sit at or below the reference saturation.

What still separates the build from the reference, in order of impact:
1. c4/c1/p5 are still far too saturated, because of the mesh-baked blue/purple leaves. c4 is 115 against 86.
2. The giant tree crown still reads as pale fog in p2/p6.
3. The island canopies are faceted mint-grey shells with no waterfalls.
4. The stairs have no block segmentation.
5. The W half (p7/p8) is untouched for a third round.

| Fix (pass 26) | Evidence (ref vs rep) | Verdict |
|---|---|---|
| Skybox pale haze + cloud | p2 sky (172,215,236) ref box 760-764,20-24 vs (130,191,239) rep same box (r23 rep 60,196,240) | Much better. Still ~40 levels short in R and ~25 in G: more blue than the reference's near-white haze. |
| Riser colour on the joint slab | c4 riser (85,103,115) ref box 428-432,646-650 vs (90,110,119) rep box 400-404,505-509 (r23 109,137,149) | **Fixed.** Tread (186,191,185) vs (195,198,188), box 398-402,688-692: match. |
| Pale tread-edge highlights | c4 / c2 / p1 | Visible. The steps now read as stone steps, but as long smooth slabs; the reference has rounded blocks with joints. |
| Runner rim gold | c4 rim (181,168,66) ref box 539-543,675-679 vs (182,174,74) rep box 460-464,708-712 (both on the outer rim band) | **Fixed.** |
| Island above Summon darkened | c4 canopy (146,158,158) ref box 700-704,60-64 vs (159,182,141) rep box 610-614,40-44 (rep box moved onto the canopy) | Value close. The rep canopy is ~20 levels more yellow-green and still faceted and pale; the arches below it are white. |
| Corner islands out and down | p1, p2, p4, c3 corners now sky or buildings | **Fixed** except p3: a pale grey faceted disc remains at the top (x 800-975, y 0-60). |
| Island behind crown moved W | p2 crown (91,143,138) ref box 592-596,58-62 vs (91,149,133) rep same box | Colour matches, but the crown still reads as a translucent mint mass against the pale island and sky (see p2). |
| Ferns smaller, flatter, lime | c2 fern (114,166,54) ref box 928-932,588-592 vs (141,198,56) rep box 870-874,555-559 (rep box moved onto the clump) | Shape and size are now right. ~30 levels too light (overshoot from r23's 63,132,18). Stair green is on target. |
| Blue/red clumps for c1 splats | c1 blue (92,181,254) ref box 345-349,645-649 vs (69,158,247) rep box 292-296,613-617 (lit side) / (41,88,184) rep box 322-326,633-637 (shadow side); red (227,99,92) ref box 1155-1159,630-634 vs (254,93,80) rep box 1102-1106,603-607 | Right place, right hue, standing. The blue clump's shadow side is too dark and too low. Loose red flakes are still scattered on the floor. |

## Per camera (round 23 -> round 24)

### p1_spawn_n: 9 -> 9
- **Gains:** the grey underside in the top-left corner is gone (sky and a white building now). The sky is paler.
  The island top above the Summon still matches: (172,199,163) ref vs (182,201,170) rep, box 618-622,28-32 (both on the
  island canopy). The ferns at the runner foot are smaller and flatter. Top-half saturation is 90 vs 84.
- **Geometry:** the canopies are still faceted pale shells. The reference has layered soft green with waterfalls, the
  gold palace and blue palms in the top-left.
- **Colour:** the bollard head is still a smooth pale dome: (225,212,131) rep box 447-451,495-499 vs faceted dark gold
  (119,109,32) ref box 438-442,498-502 (both on the bollard head).
- **Missing:** crowd and parasols at the stair top. The Summon is still a cream box with bunting.

### p2_spawn_s: 8.5 -> 9
- **Gains:** the grey island undersides at both upper corners are gone. The sky is pale with cloud (table). Top-half
  saturation is 88 vs 100, no longer over.
- **Geometry/colour:** the crown matches in colour (table) but has no dark shadow lobes. A pale island still sits right
  behind it, so it reads as fog rather than a tree. The reference crown is a dark, lobed silhouette against white sky.
  The gate side panels are unchanged: (40,150,152) rep box 640-644,300-304 vs glazed (91,167,182) ref box 656-660,298-302
  (both on a side panel).
- **Missing:** crystal basins in front of the gate; the floating stone-ring fragments.

### p3_spawn_e: 9 -> 9
- **Gains:** the grey underside in the top-left is gone. Top-half saturation is 91 vs 102. The glow matches:
  (213,117,103) ref box 598-602,218-222 vs (197,114,111) rep box 640-644,170-174 (rep box moved onto the haze).
- **Geometry:** a pale grey faceted island disc still hangs at the top right of centre. The facade under the sign is still
  a plain dark box; the reference has a gothic arch door with a skull keystone and bare branches in front of the glow.

### p4_spawn_w: 8.5 -> 8.5
- **Gains:** the top-right island underside is gone; the sky is paler.
- **Unchanged:** the ring rim is too pale and grey: (158,162,195) rep box 683-687,345-349 vs (122,146,204) ref box
  674-678,295-299 (rep box moved onto the rim). It is a plain round ring; the reference is a horseshoe with a crest,
  a darker inner band, ivy and blue drips. The reference trunk is wider with roots. A white block stands at the right
  where the reference has the gold palace.

### p5_diag_ne: 8.5 -> 9
- **Gains:** a lime clump flanks each stair, with a blue clump left and a red clump right of the fountain. This is the
  reference's colour coding. The mint island above the fountain is replaced by white towers.
- **Losses/unchanged:**
  - Top-half saturation is still 101 vs 93.
  - The runner Y still reads as wire at distance. The ref gold band (196,176,59) (ref box 150-154,500-504) is ~10 px wide
    on each side of a ~20 px blue core (74,126,224) (ref box 200-204,500-504). The rep has two ~4 px pale lines
    (185,182,125) (rep box 150-154,500-504) around a ~5 px core, too narrow for a clean 5x5 box (rep box 170-174,500-504
    gives a gold/core mix of (163,170,136)).
  - The top-left mass above the Summon is a dark faceted grey shape.
- **Missing:** Summon facade detail; Boss Rush is still a purple spiral disc; crowd and parasols.

### p6_diag_sw: 8.5 -> 8.5
- Top-half saturation is 90 vs 110 (now under). The crown behind Expeditions is still pale mint and reads as fog. The Y
  is as in p5, the gate walls flat teal (as p2), the Story ring plain (as p4), the bollard as in p1. The ferns are
  better (flatter).

### p7_high: 9 -> 9
- No visible change. The S lawn is still too grey: (90,124,54) ref vs (97,119,85) rep, box 898-902,618-622 (both on
  lawn). The rep lawn is a dark noisy texture; the reference is bright yellow-green grass. W blue is 21.4 vs 13.4.
  E green is 15.7 vs 25.4. White plinth paths still dominate the S foreground.

### p8_top: 8.5 -> 8.5
- No visible change. W blue is 44.3 vs 41.0. The far W is still one huge blue canopy plus open lawn and sand discs; the
  reference has dense mixed canopy with water and stone circles. The E paths are straight grey strips; the reference
  paving is irregular. E red is 37.2 vs 41.3: close.

### c1_wall: 8.5 -> 9
- **Gains:** the flat blue/red floor splashes are replaced by standing blue (left) and red (right) clumps on the stair
  edges, matching the reference layout (table).
- **Remaining:**
  - Loose red flakes are scattered over the floor at right; the reference keeps the floor clean.
  - The blue clump's shadow side is too dark (41,88,184).
  - The notch tree is still a bare stick with two pods.
  - Top-half saturation is 112 vs 97.
  - The stair treads are long smooth slabs; the reference has rounded cut blocks.

### c2_fountain: 8.5 -> 9
- **Gains:** the fern is now a low, flat spray of the right size. Stair green is 5.6 vs 6.4, on target. Top-half
  saturation is 104 vs 106.
- **Remaining:** the fern is ~30 levels too light (table). The floor leaves are still flat lime decals in a ring. The
  treads are pale and smooth (reference: rounded blocks with dark joints and a stone texture). Boss Rush is still a
  spiral on a box.

### c3_pavilion: 9 -> 9
- **Gains:** blue/red clumps flank the fountain and the lime ferns are flatter. The island over the fountain is gone,
  which opens the sky the way the reference does.
- **Colour:** the W island canopy is still too grey: (148,189,135) ref box 150-154,100-104 vs (154,172,153) rep box
  40-44,60-64 (rep box moved onto the canopy). The Raid brick is mauve, not red rock: (127,94,107) rep box
  1360-1364,270-274 vs (204,91,78) ref box 1348-1352,278-282.
- **Missing:** waterfalls off the W islands, hanging vines on the pavilion, crowd at the Summon, the Raid arch door.

### c4_stairs: 8.5 -> 8.5
- **Gains:** risers and rim gold now match (table), and the pale tread edges give the steps a stone read. The sky is
  paler.
- **Unchanged (holds the score):**
  - Top-half saturation is 115 vs 86, still the worst frame: saturated blue palms and purple/blue trees against a blue
    sky. The reference shows the same species, but washed in pale haze, with the gold tree and the palace dominating.
  - The treads are uniform slabs with no block joints. The reference treads are rounded stone blocks ~4-6 studs long
    with dark joints.
  - The island above the Summon is still pale faceted shells with white arches.
- **Missing:** crowd, parasols, lamp posts; blue fern sprays on the stair flanks (one blue splash at right); a textured
  pineapple.

## Scores
| camera | r23 | r24 |
|---|---|---|
| p1_spawn_n | 9 | 9 |
| p2_spawn_s | 8.5 | 9 |
| p3_spawn_e | 9 | 9 |
| p4_spawn_w | 8.5 | 8.5 |
| p5_diag_ne | 8.5 | 9 |
| p6_diag_sw | 8.5 | 8.5 |
| p7_high | 9 | 9 |
| p8_top | 8.5 | 8.5 |
| c1_wall | 8.5 | 9 |
| c2_fountain | 8.5 | 9 |
| c3_pavilion | 9 | 9 |
| c4_stairs | 8.5 | 8.5 |
| **average** | **8.67** | **8.83** |

## Top-10 for the next pass (ranked by visual impact)
1. **Leaf saturation in the N/E player views (c4 115 vs 86, c1 112 vs 97, p5 101 vs 93, p4 105 vs 108).**
   - The sky is now fine. The remaining excess comes from the mesh-baked blue/purple leaf colours.
   - Re-export the blue palm, blue tree and purple tree leaf meshes with vertex colour/texture saturation cut ~25% and
     value raised ~10%. For example, a saturated blue (40,90,230) becomes about (90,140,230), toward the ref fern
     (92,181,254) (c1 ref box 345-349,645-649).
   - Alternatively, overlay a pale SurfaceAppearance tint.
   - Push the sky the last step toward (172,215,236) (p2 ref box 760-764,20-24) from (130,191,239), and raise
     Atmosphere Haze by ~0.5 so trees 60+ studs away wash toward white.
   - Target top-half saturation within ~8 of the reference in c4/c1.
2. **Giant tree crown (p2, p6).**
   - Keep the lit-top colour (91,143,138) (p2 ref box 592-596,58-62).
   - Add darker underside lobes at ~(55,100,85). Make every lobe fully opaque with no transparency.
   - Break the outline into 6-8 rounded lumps of 12-20 studs.
   - Move or lower the pale island directly behind the crown by another ~40 studs, so the crown silhouettes against sky.
3. **Island canopies and waterfalls (p1, c3, c4, p5, p3).**
   - Recolour the canopy from (154,172,153) toward (148,189,135) (c3 ref box 150-154,100-104).
   - Replace the faceted shells with 3-5 overlapping rounded lumps per island, 8-15 studs each.
   - Add 2-3 waterfalls, 30-60 studs tall, translucent ~0.5, tint ~(150,200,225), off the N/W island edges seen in c3/c4.
   - Remove or lower by ~30 studs the last grey disc in the p3 top centre (rep x 800-975, y 0-60).
4. **Stair blocks (c4, c1, c2, p1-p6).**
   - Risers and edges are done. Split each tread into blocks 4-6 studs long, with a 0.15-stud dark joint (70,85,95)
     between blocks.
   - Round each block's front edge (bevel ~0.3 stud), or use a stone-block texture.
   - The reference treads read as stacked rounded stones; ours read as long slabs.
5. **W half canopy and ground (p8, p7, p4); unchanged for three rounds.**
   - W blue is 44.3 vs 41.0 (p8) and 21.4 vs 13.4 (p7). Replace the single giant blue canopy in the far W with 6-10 mixed
     trees (blue, purple, gold; 15-25 stud crowns).
   - Fill the open lawn and sand discs with 2-3 water pools and stone circles.
   - Lawn from (97,119,85) to (90,124,54) (p7 ref box 898-902,618-622), as a brighter grass rather than the dark noisy
     texture.
   - Add some green to the E field (p7 E green 15.7 vs 25.4).
6. **Runner Y at distance (p5, p6, p1).**
   - The close-up (c4) is right now. At distance it is wire.
   - Widen each gold band to ~0.6 stud in (196,176,59) (p5 ref box 150-154,500-504).
   - Widen the blue core between them to ~1 stud in (74,126,224) (p5 ref box 200-204,500-504).
   - Make the arms the same width as the stem.
7. **Expeditions gate and Story portal (p2, p6, p4).**
   - Gate side panels from (40,150,152) to glazed pale cyan (91,167,182) (p2 ref box 656-660,298-302), with white/gold
     mullions.
   - Two crystal basins (~4 studs) in front of the gate.
   - Story ring rim from (158,162,195) to (122,146,204) (p4 ref box 674-678,295-299), plus a horseshoe crest, a darker
     inner band, and ivy/blue drips.
8. **Raid facade and rock (p3, p5, c1, c3).**
   - Replace the dark box under the sign with a gothic pointed-arch door (~8 wide x 14 high studs) with a skull keystone.
   - Retint the brick from (127,94,107) to red rock (204,91,78) (c3 ref box 1348-1352,278-282).
   - Put 3-4 dark bare branch silhouettes (10-15 studs) in front of the glow.
9. **Summon / Boss Rush facades, bollards, crowd props (p1, p5, c3, c4).**
   - Bollard heads: faceted (4-sided pyramid) dark gold (119,109,32) (p1 ref box 438-442,498-502), not the smooth
     (225,212,131) dome.
   - Summon: a white-gold palace face with blue arched windows and a medallion.
   - Boss Rush: a purple gothic shrine ~25 studs tall, replacing the spiral disc.
   - Add 6-10 parasols/stalls and lamp posts at the Summon stair top.
10. **Ground foliage clean-up (c1, c2, c3).**
    - Delete the loose red flakes on the c1 floor and the flat lime leaf ring on the c2 floor; the reference floors are
      clean stone.
    - Darken the lime fern from (141,198,56) to (114,166,54) (c2 ref box 928-932,588-592).
    - Lift the blue clump's shadow side from (41,88,184) toward (69,158,247), the clump's lit side (c1 rep box
      292-296,613-617); the ref spray is (92,181,254) (ref box 345-349,645-649).
    - Add 2 more blue sprays on the W stair flanks in c4.
