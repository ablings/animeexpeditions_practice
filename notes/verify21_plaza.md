# Verify round 21: Anime Expeditions spawn plaza (freestyle, after fix pass 23)

Independent review against the **live reference** on the Shadow PC, 2026-10-11. Round 20 (`verify20_plaza.md`, 8.21)
was read only for comparison; every score below is fresh.

## Method
- **Reference:** studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, cameras from `cams.json`.
- **Practice:** studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only (via `capture_set2.py` / `mcpcli.py`). No code was run in either studio; nothing was
  modified or saved in either studio. No computer use.
- **Captures:** each camera captured twice per studio; the second frame was judged. Judged frames:
  `out/verify21/v21_<cam>_ref.jpg` and `v21_<cam>_rep.jpg` (1452x793). Raw PNGs in `out/v21ref_*` / `out/v21rep_*`.
  Pixels changing by >30 levels between frames: 0.4-3.4% ref (water, VFX, crowd), 0.0-1.2% practice. Animation, not
  streaming.
- **Colours:** every RGB is a 5x5 mean from the judged JPEGs, given with its frame and box (x0-x1, y0-y1). Targets come
  from the reference frame. Each box was checked on a 2x zoomed 120 px tile in both frames; where the practice box
  cannot land on the same feature (missing or different), it says so. Stud sizes are estimates from the pictures.
- **Coverage metrics** (PIL HSV, same boxes as rounds 19-20), ref / rep:
  - Top-half mean saturation: p1 85/101, p2 101/127, p3 102/106, p4 108/119, p5 93/99, p6 111/117, p7 88/85,
    p8 102/95, c1 97/108, c2 106/114, c3 95/94, c4 89/121. (Round 20 rep: 100, 128, 106, 119, 98, 120, 84, 95, 109,
    115, 95, 121: essentially unchanged.)
  - W blue (p8 x0-420 y150-650): 36.2% / 48.4%. (p7 x0-450 y100-700): 12.9% / 21.7%.
  - E green (x1000-1452 y100-700): p7 25.9% / 24.8%; p8 3.9% / 14.9%.
  - E red, same box: p7 18.8% / 10.7%; p8 35.7% / 22.4%.
  - c2 stair green (x800-1452 y400-793): 6.9% / 0.1%.

## Overall read
Pass 23 landed its list at the facade and runner level; the frame-wide gaps (sky/background, E/W ground cover) did not
move, so the gains are real but local.

| Fix | Evidence |
|---|---|
| Runner rims gold | p5: (162,142,56) rep box 294-298,510-514 against (156,141,39) ref box 260-264,498-502. Match. |
| One-piece runner | p5/p6 now one slab with rounded foot and one cyan gem. Runner blue matches: c4 (80,138,238) vs (75,126,225), both box 658-662,698-702. |
| Expeditions gate | Arch, filigree crest, swirl door, lamp posts all read. Door (15,109,137) rep box 710-714,298-302 vs (4,122,134) ref box 722-726,298-302: close. |
| Story portal | Silver ring with 7 cyan gems. Reads as a portal now, but plain (see p4). |
| Raid | Sign on the gable, red-eyed skull, salmon haze. Skull and tower still not red (see p3/c3). |
| Stairs | c4 now shows 6 tread rows each side, as the reference. Riser colour matches: (73,105,125) rep box 428-432,626-630 vs (85,107,121) ref box 428-432,646-650. |
| Tunnel fill | Now dark slate, slightly too dark: (18,32,48) rep box 896-900,467-471 vs (44,54,62) ref box 878-882,468-472. |
| Falls | Now a narrow pale ribbon, but still reads as a solid strip (see p1). |

## Per camera (round 20 -> round 21)

### p1_spawn_n: 8.5 -> 8.5
- **Gains:** one-piece runner with gold rim and large low Y; fall is now a ribbon, not a column.
- **Geometry:** fall ribbon is a straight even-width strip with no mist or lip vines visible; the reference has two
  layered translucent streams. Bollards unchanged: smooth dome on a white block.
- **Colour:**
  - Fall: (192,230,232) rep box 737-741,123-127 vs (139,186,208) ref box 797-801,64-68 (both on the fall). Practice is
    pale and opaque; the reference lets the rock show through.
  - Background: (121,204,236) clean sky (rep box 618-622,28-32) where the reference has an island/foliage band
    (176,202,164) (ref, same box). Feature missing in practice.
  - Bollard head (214,200,117) rep box 444-448,500-504 vs faceted dark gold (119,109,32) ref box 438-442,498-502; base
    (249,248,243) rep box 434-438,538-542 vs shaded cream (128,129,138) ref box 438-442,573-577.
- **Missing:** the crowd/parasols mass and gold canopy density at the stair top; Summon is still a cream box.

### p2_spawn_s: 8 -> 8.5
- **Gains:** the gate now reads as a gate: arch, crest, swirl door, lamp posts, flanking palms, lawn strips.
- **Geometry:** the gate is a flat teal wall with an arch cut in it; the reference is a glazed, many-paned frame with
  pilasters, crystal basins in front and a huge tree trunk rising behind it (missing).
- **Colour:**
  - Gate side panels: flat teal (29,140,139) rep box 656-660,298-302 vs pale cyan glazed panel (92,166,183) ref, same box.
  - Still the most saturated frame: top half 127 vs 101. The practice sky is open blue; the reference fills it with the
    tree, rock pillars and pale cloud.

### p3_spawn_e: 8.5 -> 8.5
- **Gains:** sign on the gable, red glowing eyes and drip, red trees, haze behind.
- **Colour:**
  - Skull forehead: (146,107,104) rep box 721-725,44-48 vs (207,108,93) ref box 718-722,38-42. Still tan-grey.
  - Haze: (205,134,123) rep box 638-642,148-152 vs (226,124,111) ref box 598-602,218-222. Close in hue, but in practice
    it is a band in the sky behind the tower; in the reference the red glow wraps the facade and door at mid-height.
- **Geometry:** the facade is a dark brick block under the skull; the reference is a red rock mass with spires and the
  skull merges into it.

### p4_spawn_w: 8 -> 8.5
- **Gains:** silver portal ring with gems; tree trunk now fills the frame centre with a blue crown and drips; trunk tone
  OK: (117,97,91) rep box 698-702,148-152 vs (89,74,63) ref, same box (slightly light and pink).
- **Geometry:** the ring is a plain round stargate; the reference is a horseshoe with a blue crest/horseshoe on top and
  a darker inner band. The reference trunk is about 1.5x wider with roots and limbs at the plaza level.
- **Colour:** ring (142,169,196) rep box 682-686,316-320 vs richer blue-silver (122,145,201) ref box 674-678,295-299.
- **Missing:** ivy and blue drips over the portal; the gold palace at right (a white block stands there).

### p5_diag_ne: 8.5 -> 8.5
- **Gains:** one-piece runners with gold rims (matched, see table).
- **Geometry:** the Y is a single thin gold stick; the reference Y is outlined (two gold lines with a dark blue core) and
  the foot has a round gem in a gold teardrop; practice has a flat cyan bar. Summon still a cream box with bunting.
- **Missing:** Boss Rush shrine (purple spiral on a box); crowd and parasols.

### p6_diag_sw: 8 -> 8.5
- **Gains:** gate and Story portal both now read correctly at a glance.
- **Geometry:** same runner Y/gem note as p5; bollard as p1.
- **Colour:** gate door matches (see table); gate walls too flat teal (see p2).

### p7_high: 8 -> 8
- No visible change from round 20.
- **Colour:** S lawn (117,178,87) rep box 898-902,618-622 vs (92,123,54) ref, same box (too pale, too saturated). E red
  10.7% vs 18.8%; W blue 21.7% vs 12.9%.
- **Geometry:** the E field is green lawn with red heart blobs and lime discs; the reference is a red carpet under the
  trees. White plinth paths still dominate the S foreground.

### p8_top: 8 -> 8
- No visible change.
- **Colour:** E ground (113,153,99) green lawn at rep box 1120-1124,486-490 against red carpet (194,82,75) ref box
  1160-1164,526-530. (The rep box at the ref position lands on a red palm crown, so it was moved onto the ground beside
  it.) W blue 48.4% vs 36.2%.
- **Geometry:** W side is flat pale pools and lawn where the reference is dense blue canopy; lime-green disc decals on
  the E side have no counterpart.

### c1_wall: 8.5 -> 8.5
- **Gains:** tunnel interior now slate; long stair slabs.
- **Colour:** tunnel slightly too dark (see table).
- **Geometry:** notch tree still a bare stick with two dark pods; reference has a gnarled trunk and a blue crown.
  The arch side bands read darker and heavier than the reference's grey frame.

### c2_fountain: 8 -> 8
- **Geometry:** treads are now long pale slabs with no joints; the reference treads are grey blocks with joints about
  every 4-5 studs and a crisp dark bevel line. The practice tread texture reads noisy/soft (like snow) at this range.
- **Missing:** the fern spray on the stair edge by the fountain: (114,166,54) ref box 928-932,588-592; the practice box
  lands on bare tread (192,196,188). Stair green 0.1% vs 6.9%. Boss Rush still a spiral on a box.

### c3_pavilion: 8.5 -> 8.5
- **Gains:** Raid sign on gable, skull eyes, left fall as a ribbon.
- **Colour:** behind the facade the reference is a red rock/glow mass, (176,77,62) ref box 1348-1352,278-282; practice
  brick tower is purple-brown (108,80,95) rep box 1328-1332,298-302 (moved off a red stripe onto brick).
- **Missing:** hanging vines, the gold tree mass at far left, crowd at Summon.

### c4_stairs: 8 -> 8
- **Gains:** 6 tread rows each side, matching the reference; riser colour and runner blue match.
- **Geometry:** the runner Y is now a long V whose arms run the full visible slab; the reference Y is an outlined Y in
  the middle third of the slab. Treads have no joints (see c2).
- **Colour:**
  - Tread mean OK: (193,196,185) rep vs (186,191,185) ref, both box 398-402,688-692; but the texture is mottled white.
  - Runner gold: (162,137,28) rep box 698-702,618-622 (Y arm) vs (183,175,89) ref box 638-642,558-562 (rim gold;
    paler, less orange).
  - Top half 121 vs 89: still the second most saturated frame (open blue sky in place of the island/arcade mass).
- **Missing:** crowd, parasols, lamp posts; textured pineapple; Summon still a cream box.

## Scores
| camera | r20 | r21 |
|---|---|---|
| p1_spawn_n | 8.5 | 8.5 |
| p2_spawn_s | 8 | 8.5 |
| p3_spawn_e | 8.5 | 8.5 |
| p4_spawn_w | 8 | 8.5 |
| p5_diag_ne | 8.5 | 8.5 |
| p6_diag_sw | 8 | 8.5 |
| p7_high | 8 | 8 |
| p8_top | 8 | 8 |
| c1_wall | 8.5 | 8.5 |
| c2_fountain | 8 | 8 |
| c3_pavilion | 8.5 | 8.5 |
| c4_stairs | 8 | 8 |
| **average** | **8.21** | **8.33** |

## Top-10 for the next pass (ranked by visual impact)
1. **Fill the open sky in N and S views (p2, c4, p1).** Haze was rejected, so fix it with content: add 3-4 large
   background island masses with foliage and a waterfall each, 150-300 studs out on the N and S axes, tops 60-120 studs
   above the plaza, so they cover the upper third of p2 and c4. Behind the Expeditions gate add the giant tree trunk
   (about 12-15 studs wide, rising 80+ studs, blue-green crown). Target the band colour (176,202,164) (p1 ref box
   618-622,28-32). Goal: top-half saturation p2 127 -> ~105, c4 121 -> ~95.
2. **E ground red carpet and W thinning (p8, p7).** Replace the E lawn and lime disc decals with a continuous red ground
   cover (194,82,75) (p8 ref box 1160-1164,526-530) under the red trees; target p7 E red 10.7% -> ~18%, p8 22% -> ~35%.
   Cut W blue canopy by a quarter (p8 48% -> ~36%) and replace the flat W pools with canopy. Darken the S lawn from
   (117,178,87) to (92,123,54) (p7 ref box 898-902,618-622).
3. **Raid red mass (p3, c3, p5).** Recolour the skull from (146,107,104) to (207,108,93) (p3 ref box 718-722,38-42).
   Wrap the haze round the facade at door height (a 30x20 stud glow card or ParticleEmitter in front of the brick, red
   (226,124,111), p3 ref box 598-602,218-222) rather than a band in the sky. Retint the brick tower from (108,80,95)
   toward red rock (176,77,62) (c3 ref box 1348-1352,278-282) and add 2-3 rock spires.
4. **Stair tread joints and texture (c2, c4, c1, p5).** Keep the 7 risers. Split each tread into blocks about 4-5 studs
   long with a 0.15-0.2 stud dark chamfer line (99,113,122) (c4 ref riser/bevel box 428-432,638-642) and replace the
   mottled white texture with flat grey stone (186,191,185) (c4 ref box 398-402,688-692).
5. **Runner Y and gem (c4, p5, p6).** Shorten the Y to the middle third of the slab and make it outlined: two gold lines
   about 0.3 stud wide with a dark blue core. Gold toward (183,175,89) (c4 ref box 638-642,558-562), not the orange
   (162,137,28). Replace the flat cyan bar at the foot with a round cyan gem in a gold teardrop setting about 1.5 studs.
6. **Expeditions gate detail (p2, p6).** Replace the flat teal side walls (29,140,139) with glazed panels in pale cyan
   (92,166,183) (p2 ref box 656-660,298-302) divided by white/gold mullions; add the two crystal basins in front of the
   gate (about 4 studs wide, blue crystal on a gold dish).
7. **Summon and Boss Rush facades (p1, p5, c3, c4, c2).** Summon: white and gold palace face with blue arched windows,
   gold cornice and a gold medallion (ref "Summon" face is near white (245,248,221), c4 ref box 717-721,374-378). Boss
   Rush: purple gothic shrine about 25 studs tall with lit pink/purple windows, replacing the spiral on a box.
8. **Bollards (p1-p6).** Base about 25% smaller and shaded cream (target the shadow side (128,129,138), p1 ref box
   438-442,573-577; lit side about (225,220,205)); head a faceted gold eye on a gold pyramid, (119,109,32) (p1 ref box
   438-442,498-502), not a smooth pale dome.
9. **Falls (p1, c3, c4).** Make the ribbon translucent (Transparency ~0.5) and tinted (139,186,208) (p1 ref box
   797-801,64-68), split into 2 layered streams of uneven width, and add the mist puff visibly at the foot and vines
   at the lip.
10. **Close details (c2, c1, p4).** Add 1-2 fern sprays on the stair edge by each fountain ((114,166,54), c2 ref box
    928-932,588-592). Give the notch tree a gnarled trunk with 2-3 limbs and a blue crown about 4 studs across. Lift the
    tunnel back wall from (18,32,48) to (44,54,62) (c1 ref box 878-882,468-472). Add a blue horseshoe crest on top of the
    Story ring and deepen its colour to (122,145,201) (p4 ref box 674-678,295-299).
