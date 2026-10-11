# Fix pass 23: Anime Expeditions spawn plaza (fall ribbons, gate front, Story horseshoe, Raid red, 7-riser slab stairs, one-piece runner, tunnel light)

Builder report for `notes/fix_brief23.md`, answering the round-20 review `notes/verify20_plaza.md` (8.21/10).

**Status by review item**

| Item | Status |
|---|---|
| 1 Falls + Haze | Falls: done (kit `K_Ribbon23`, mist puffs). Haze: **tested on all 12 cameras and rejected** (see below). |
| 2 Gate + portal | Done: gate front kit `K_Gate23` (pilasters, archivolt, gold filigree crest, dark swirl door, lamp posts, crystal basins); Story horseshoe `K_Portal23` with 7 gems. |
| 3 Raid red | Done: skull, haze, tower, red facade light, sign moved onto the gable. |
| 4 Stairs | Done: **7 risers** (projection, see below) of long slabs with a 0.15 chamfer (`K_Stairs23`); tread lightened. |
| 5 Runners | Done: one ramp per flight (`K_Runner23`): rounded foot, gold rim, big low Y, one gem. Replaces `Runner22` and the `K_Stairs` runner pieces. |
| 8 (part) Tunnel | The pass-22 cyan fill light was what turned the tunnel teal; retuned. Notch tree and arch width not attempted. |
| 6, 7, 9, 10 | Not attempted (time box). |

**Captures**
- Final set: `out/r23/r23_<cam>.png` (capture_set2.py, second frame kept); contact sheet `out/r23/contact.jpg` (v20 reference left, r23 right).
- Working frames `out/r23w/<letter>_<cam>.png`: `a_` baseline, `h125_`/`hg125_` Haze tests, `b_`-`f_` Studio-only colour steps, `g_` onward after the kit import, `z_` = copy of the final set.
- Tools (`out/r23w/`): `box23.py` (v20 boxes, targets re-sampled from `v20_<cam>_ref.jpg` on every run), `cap.sh` (two captures, judge the second), `all.sh` + `satall.py` (all 12 cameras, top-half saturation against v20 ref), `stairproj.py` (riser bands through the c4 camera), `run.sh` (runs `fix/pass23.lua`). `out/r22w/pick.py` was used for picks.

**Rules kept**
- Pictures only: every target re-sampled from the v20 reference frames; the reference studio was not touched (not even screen_capture).
- Own geometry only, no computer use. Place not saved, nothing committed. `ae_kit.blend` saved before the export.

**State at the end**
- `#workspace.Plaza:GetDescendants()` = **17217** (17177 after pass 22 + `Pass23` folder and its pieces).
- Workspace holds only **Camera, Terrain, SpawnLocation, Plaza**. `ae_kit_r23` was merged into `ServerStorage.Kit` by the header of `pass23.lua` (16 meshes in, scale cube destroyed).
- Atmosphere unchanged from pass 22 (Density 0.28, Haze 0, Color (200,220,235)).

**How to rebuild** (on the pass-22 build with `ae_kit_r23` imported): `sh out/r23w/run.sh`. Idempotent: every touched piece is restored from its `P23*` attributes first (hidden parts, colours, the TunnelFill22 / SkullLight22 lights, the Raid sign scale and pivot). Blocks: `--FALL23`, `--GATE23`, `--PORTAL23`, `--RAID23`, `--STAIR23`, `--RUN23`, `--ARCH23`. Each kit block has a Studio-only fallback. `fix/build_plaza.lua` has r23 in `IMPORTS`.

## Results (final set `out/r23`, 5x5 means, max channel difference against the v20 reference box)

| box | v20 practice | r23 | target (v20 ref) |
|---|---|---|---|
| p1 fall | 20 (opaque white column) | **10** (translucent ribbon) | (200,235,243) |
| p3 skull | 46 | **8** | (218,118,98) |
| p3 haze | 54 | **9** | (206,118,105) |
| c3 Raid tower | 75 | **6** | (225,86,89) |
| p6 gate door | 49 | **20** (dark teal with lighter swirl; R sits on the fog floor) | (3,121,134) |
| p5 rim | 204 (white) | **38** (the box lands on the rim/silver edge; the rim itself is gold, 11 off when measured on the old rim part) | (156,141,39) |
| c4 tread | 19 | **7** | (186,191,185) |
| c1 tunnel | 106 | **36** | (44,54,62) |
| c4 riser | 10 | 91: the box now lands on a tread, because the 7-riser flight moves the bands (see stairs) | (85,107,121) |
| c4 / p5 runner blue | 5 / 11 | 13 / 11 | |

Top-half saturation (12-camera mean of rep minus ref): baseline +11.4, final +12.4. p2 (128 against 100) and c4 (123 against 86) are still the most over-saturated: both look up into clean blue sky where the reference has overhead islands (see Lessons).

## 1. Falls (`--FALL23`, kit `K_Ribbon23_water`)
- The two Fall22 sheets and Fall16 are hidden and each replaced by a ribbon at the same x/z, top and height (6 wide, cupped, lip curling over), SmoothPlastic.
- Colour fit on p1 (735-739, 113-117) against p1 ref (751-755, 138-142): (175,235,250) at T 0.4 gave 36 off (the sky shows through); (215,245,255) at T 0.25 gave 17; **(190,250,255) at T 0.15** gives 10. A translucent sheet against sky needs low transparency and an over-bright colour.
- Mist: three soft balls (235,245,248), T 0.55-0.75, at each fall foot.

## Haze test (brief: all 12 cameras, keep only if the set average gets closer)

| setting (Density 0.28) | mean abs(rep - ref) top-half sat | mean signed |
|---|---|---|
| Haze 0 (pass 22, kept) | 12.7 | +11.4 |
| Haze 1.25, Color (185,208,170) | 21.0 | +21.0 |
| Haze 1.25, Color (200,200,200) | 19.7 | +19.7 |

Haze raised saturation on every camera (+8 to +16), whatever its colour. The p1 "mist" box (618-622, 28-32) did not move at all, (122,204,236) to (122,203,235): it is skybox, and the reference box lands on the underside of an overhead green island, not on mist. Rejected; the Atmosphere stays as pass 22 left it.

## 2. Expeditions gate (`--GATE23`, kit `K_Gate23_*`, origin (0, 7.0, 84.5))
- The "white statue" in the door is part of the `K_Trip10_pale` mesh (not the pass-20 cloud stack, which is hidden too). It is covered by a door panel (block 10.8 x 13.4 + a round-top cylinder) at z 86.0, in front of the statue; the kit swirl is moved forward 2.75 to sit on it.
- Door (0,140,150) SmoothPlastic, swirl (30,150,160): door box 20 off (R 23 against 3: the fog floor).
- Pale pilasters (214,232,226), gold Metal (205,165,70) capitals/bases/arch trim/crest, dark Metal lamp posts with Neon lanterns and PointLights (brightness 1.5, range 10), stone basins with glass water under the existing crystals.

## 3. Story portal (`--PORTAL23`, kit `K_Portal23_*`, origin (-86.6, 16, 0), facing +X)
- `StoryFrame14` blocks, `StoryFrameRing14`, `StoryJamb14` and `K_Ring9` hidden. Silver (205,212,225) SmoothPlastic horseshoe, gems Neon (55,120,255).

## 4. Raid (`--RAID23`)
- Skull bone (215,145,105) + SkullLight22 retuned to (255,90,80), brightness 5: cheek-forehead box 8 off. (255,120,92) with brightness 7 overshot R (242,101,99).
- Haze band (215,135,120): measured twice (particles move), 11 and 9 off. (225,112,85) read orange, (225,105,110) too dark in G.
- RaidGable (the c3 tower box) (255,40,45) SmoothPlastic: 6 off (was Brick, which kept it brown).
- A red PointLight (255,60,55), brightness 3, range 34 at (140, 30, 0); the "Raid" sign scaled 0.62 and moved to (153, 47, 0.2), onto the gable apex over the door, off the drip.

## 5. Stairs (`--STAIR23`, kit `K_Stairs23`)
- **Count by projection** (`out/r23w/stairproj.py`). Luminance down x 1135-1165 of `v20_c4_ref`: dark riser bands at about 442 / 500 / 550 / 600 / 720 (5 in frame). On our footprint (d 28-48, rise 6), flights projected through the c4 camera give: 6 risers 478/516/576/680 (4 bands), **7 risers 475/506/550/616/730 (5 bands, mean error 13)**, 8 risers 474/499/533/582/654/778 (6 bands, error 25). A free fit (N, rise, tread, top) is ambiguous (errors 9-12 for N 5-8), so the footprint must be fixed first.
- After the import, ours shows 5 bands at 478/508/559/622/739 (ref 442/500/550/600/720).
- Slabs: rows alternate [6.7, 6.7] and [3.35, 6.7, 3.35] per side, chamfer 0.15 (1 segment). Tread (130,133,128) Slate: 7 off.

## 6. Runners (`--RUN23`, kit `K_Runner23`)
- One ramp per flight from a rounded foot at d 17 up to the stair top at d 48.4 (top 0.55 at the foot, 0.9 at d 28, 6.35 at d 48.4).
- Silver (170,172,178) (the first (215,218,224) read pure white), gold rim SmoothPlastic (94,79,5), face (58,82,160), gem Neon (90,220,240) T 0.2.
- Gold fit on p5: Metal (150,125,35) rendered (121,126,56); SmoothPlastic (185,160,30) -> (249,233,56), (118,98,12) -> (197,170,49), (65,70,0) -> (107,127,53); interpolated **(94,79,5) -> (162,141,50)**, 11 off.

## 7. Tunnel (`--ARCH23`)
- The pass-22 `TunnelFill22` lights (150,235,185), brightness 2.2, were what made the tunnel teal. At (150,170,140), brightness 0.45 the box goes from 106 to 36 off; what remains is the sky ambient on `K_Arch20_stone`.

## Lessons (for the workflow vault)
1. **Test a global knob on the whole set, and check what the target pixel really is.** The review's "misty green-grey sky" box was the underside of an overhead island. Haze cannot produce that; it raised saturation on all 12 cameras. Missing geometry (big islands overhead) is the lever for the top-half saturation of p2 and c4, not the Atmosphere.
2. **Fix the footprint, then count steps.** A free fit of steps through a camera is ambiguous when the flight's foot is out of frame (N 5-8 all fit within a few pixels). With the run and the rise fixed by the layout, only the count was free, and 7 matched the band count and positions.
3. **Changing the geometry moves the boxes.** After the 7-riser flight, the c4 riser box lands on a tread. Re-pick a box's target part before reading its number as better or worse.
4. **A light can be the cause, not just the cure.** The "teal marble" was a pass-22 fill light; the right fix was retuning that light, not recolouring the stone.
5. **Mesh-baked details can't be hidden part by part.** The gate statue was inside the `K_Trip10_pale` mesh. Cover it with a new piece in front, or rebuild the mesh; a name search finds nothing.
6. **Translucent pieces against sky need low transparency and an over-bright colour.** At 0.4 the ribbon took the sky's colour; at 0.15 with (190,250,255) it lands within 10.
7. **SmoothPlastic gold under sun is very non-linear.** Three points per channel and interpolation (not a linear fit) brought the rim from 49 to 11 off. Metal reads green-grey at a distance.
8. **Author kit pieces in Studio coordinates and export their bbox centres.** `kit/own/ae_kit_r23_centres.json` placed every piece correctly on the first run after the import, independent of where the importer dropped the model.
9. **Particle boxes need two measurements.** The Raid haze box read 5 off one run and 42 the next with no change. Judge particle colours on two captures.

## Objects built (for 5 Object Recipes)

### Slab stairs, 7 risers (`tools/ae_kit.py`: `build_stairs23`)
- 4 flights (rot4), d 28-48, rise 6/7, tread 20/7, lateral 4.3-17.7. Each step is a row of full-height `rbox` slabs, chamfer 0.15 with 1 segment; rows alternate [W/2, W/2] and [W/4, W/2, W/4] so the joints are offset.
- The riser split keeps only faces whose normal points down the flight. 5,168 + 816 triangles.
- Studio: tread (130,133,128) Slate; riser keeps the pass-22 colour.

### One-piece runner ramp (`build_runner23`, `runner_layer23`, `loft23`)
- One lofted cross-section per layer along d: the width follows a quarter-circle for the first W studs (rounded foot); the top follows `_surf23(d)` (floor rise to d 28, then up the stairs to the top).
- Layers: silver 8.6 wide (bottom on the floor up to d 28, then 1.4 below the top), gold rim 7.9 (+0.08), blue face 6.9 (+0.14), gold Y tubes (r 0.24) following the surface (stem d 20.4-33, arms to x ±2.55 at d 47.6), one rbox gem near the foot. rot4.
- Studio: silver (170,172,178), gold SmoothPlastic (94,79,5), face (58,82,160), gem Neon (90,220,240) T 0.2.

### Fall ribbon (`build_ribbon23`)
- A 30 x 8 grid, 6 x 40: cupped across (edges back 0.8), lip curling from z -2.5 with exp(-14t), widening 25 % and swaying 0.5. Two sheets 0.15 apart with opposite normals (rendered from both sides).
- Studio: scaled to the old fall's height, SmoothPlastic (190,250,255), T 0.15, no shadow; three mist balls at the foot.

### Expeditions gate front (`build_gate23`)
- Origin = gate step top centre, front plane z 0. Four pale pilasters 1.8 x 20.4 with gold capitals and bases; a pale archivolt tube (r 6.1) and a gold trim tube (r 7.0) round the door's round top.
- Gold filigree crest: two ogee tubes rising to a lathed finial, plus three pairs of spiral C-scrolls (`spiral23`).
- Door swirl: three spiral tubes. Lamp posts: lathed dark posts 7.2 tall, glass lantern and gold cap. Lathed basins with a water disc.
- Studio: covering door panel (block + round-top cylinder) over the mesh statue, door (0,140,150), swirl (30,150,160).

### Story horseshoe portal (`build_portal23`)
- Two 0.75-radius tubes at r 6.9 and 7.9, from -50 to 230 degrees with legs down to the base (a 2.5 x 1.5 band), a keystone, two feet, six gems on the front of the arc plus a key gem. Built in XY, then turned 90 degrees about Y to face +X.
- Studio: silver (205,212,225), gems Neon (55,120,255).

### Raid red (Studio)
- Bone (215,145,105) + red skull light (255,90,80) b 5; haze band (215,135,120); RaidGable (255,40,45) SmoothPlastic; facade PointLight (255,60,55) b 3 r 34; sign at 0.62 scale on the gable apex.

## Files
- `fix/pass23.lua` (new), `fix/build_plaza.lua` (r23 in `IMPORTS`).
- `tools/ae_kit.py`: pass-23 section (`build_stairs23`, `loft23`, `_surf23`, `runner_layer23`, `build_runner23`, `build_ribbon23`, `spiral23`, `build_gate23`, `build_portal23`, `build_scale23`, `r23_info`, `build_all23`, `export_r23`).
- `kit/own/ae_kit_r23.fbx` (17 meshes incl. the scale cube; largest 5,228 triangles), `kit/own/ae_kit_r23_centres.json`. `ae_kit.blend` saved.
- `out/r23/` (set + contact sheet), `out/r23w/` (tools and working frames).
