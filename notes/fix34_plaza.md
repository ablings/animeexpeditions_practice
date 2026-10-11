# Fix pass 34: Anime Expeditions spawn plaza (smooth arch inner band kit, narrower jets, royal-blue notch trees, solid red E ground with flat flower patches and a rounded rock mound)

Builder report for `notes/fix_brief34.md`, answering the round-31 review `notes/verify31_plaza.md` (9.33/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`). The reference studio `97946bf6-...` was not captured:
the full-size v31 frames were enough. **One kit this pass:** `kit/own/ae_kit_r34.fbx` (`K_ArchBand34_stone` + scale cube
`K_Scale34_stone`), imported by the lead (Insert Using Scene Position + Anchored). About 60 + 25 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 Arch inner band | Done. The pass-33 band (`Pass33.Arch33`, 56 straight Parts tilted 30 deg) is hidden. The new band, `K_ArchBand34_stone`, is one smooth mesh from own Blender (`build_band34()`, `tools/ae_kit.py`). It follows the K_Arch20 opening (ellipse hw 7.6, springing 1.1, rise 5.4, legs to the floor), sits 0.2-1.2 outward from the opening edge, clear of the 0.15 gold rim, and stands 0.3 proud (w 32.7 -> 33.05). The front edges have 0.12 chamfers; it is smooth shaded, mirrored to the 4 corners, 3104 tris. It is placed at the K_Arch20 frame offset in SmoothPlastic (100,104,105). **Red Neon tint test:** one smooth arc just inside the gold rim on every corner, 39k red px in c1 and 24k in c3 (`out/r34w/tint_c1.jpg`). c1 (560,400) (126,164,188) -> **(17,34,56)** vs ref (20,31,49). The band face at c1 (560,330) is (150,159,159) vs the ref's light inner band (134,136,138). |
| 2 Jet and niche water | Done. 156 jet parts. The Jet31 arcs are pulled to 60 % of their distance from the jet axis and made 0.6x wide; the Jet30 column and core are 0.6x thick; all are at T >= 0.7. c1 (640,380) (203,235,240) -> **(116,171,186)** vs (16,46,60). c3 (640,600) (192,231,237) -> **(88,134,153)** vs (33,65,81). The pass-33 niche sheets are now Neon (31,50,58) at T 0.3, with lips (70,110,128). Note: the reference frames themselves show a glowing cyan splash at the c1 box, so the dark box target is probably next to the splash, not on it. |
| 3 p3 upper left | Done, as a tree. The reference's blue mass upper-left in p3 is the **NE notch tree**: the same tree rises over the arch in c3 and p5, and the matching trees show in p1, p2 and p4. Each of the 4 `Notch29` trees gets a trunk to y 24 and a crown of 6 own `K_FluffyS_leaf` clumps (0.68 x 0.6-1.0 scale), alternating (48,98,212) and (88,138,222). The crowns are about 11 studs wide, y 15-28. p3 (250,150) (68,77,97) -> **(33,73,189)** vs (44,93,209). The (150,120) box is still island and sky: the 0.68 crown stops short of it, see the saturation trade-off below. **Raid doorway:** black Neon (0,0,0) changed nothing, still (31,44,53) vs (0,10,18). The lift comes from haze or glow in front of the door, not from the door colour. |
| 4 E ground | Done. **Red ground:** 600 Neon tiles (102,38,33) +-6, 7.5-9 square with random yaw, laid on the Grass (multi-hit `groundY`) over x 54-178, z -104..106. They skip the rubble band and the rock, and 35 % get a white dot. p8 (950,480) (167,104,83) -> **(182,54,59)** vs (184,69,62). **Speckle:** 131 pass-32 grey scatter stones outside the band are hidden. **Flower patches:** the 6 pass-33 bush clusters are replaced by flat patches, each 3 overlapping Neon discs (66,88,25), 10-14 across, with 14 white dots. **Rock:** the black-cube cluster is replaced by a mound of 6 overlapping Neon ellipsoids (27,28,26) with 3 lighter top caps (45,48,45); p8 (1100,650) stays (48,57,63) vs (54,56,51). |
| 5 Arch face | Done, as a compromise. `K_Arch20_stone` (62,66,67) -> SmoothPlastic **(72,78,84)**. Slate (85,92,100) was tried and rejected: c1 (500,300) rendered (97,110,119) with a rough stone texture the reference does not have. c1 (500,300) (73,85,85) -> (88,101,110) (ref 60-89). c2 (560,200) (35,42,56) -> (40,49,68) vs (100,113,134). p1 (150,330) (46,55,65) -> (56,66,80) vs (83,85,98). The c2 box is the backlit face. One colour cannot lift it to the ref without over-lighting c1; it needs a lit side face, which is geometry. |
| 6-10 | Not attempted. |

## Captures
- **Final set:** `out/r34/r34_<cam>.png`, all 12 at full size **1284 x 793** (second frame of `capture_set2.py`, Import Queue closed).
  Contact sheet `out/r34/contact.jpg` (v31 reference left, r34 right).
- **Working sets:** `out/r34w/a` to `e`, plus `tint` (the red band test).
- **Images:** triptychs `out/r34w/t_<cam>.jpg` (ref | v31 rep | new) and `tint_c1.jpg`.
- **Tools (`out/r34w/`):**
  - `run.sh` builds `fix/pass34.lua` from `head.lua`, `params.lua` and `body.lua` (`build.sh`), then runs it.
  - `lrun.sh` and `some.sh <tag> [cams]` are the same as in pass 33.
  - `bx.py <tag> cam:x,y ...` prints the box colours and top-half saturation (ref, v31 rep, new). `trip.py <tag> <cam>` makes the triptychs.
  - `metrics.py`, `pick.py` and `zz.py` are the pass-33 tools, pointed at v31.
  - `r34_info.json` holds the authored bbox centres used for placement.

## Results
**Top-half mean HSV saturation:**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref v31 | 82 | 99 | 102 | 107 | 91 | 114 | 86 | 102 | 95 | 110 | 90 | 80 |
| base (v31 rep) | 80 | 91 | 89 | 107 | 90 | 106 | 81 | 88 | 104 | 101 | 94 | 91 |
| crowns 0.8x royal (set d) | 92 | 104 | 104 | 120 | 100 | 112 | 84 | 92 | 111 | 107 | 102 | 91 |
| **r34 (final)** | **87** | **98** | **99** | **114** | **98** | **110** | **83** | **92** | **110** | **105** | **99** | **91** |

- **Gaps closed:** p2 is on target (98 vs 99), p3 is -3 (it was -13), p6 is -4 (it was -8), and p8 has gained 4.
- **Overshoots:**
  - p4 +7 and p5 +7 (both 9.5): the reference has blue notch trees in both, ours are a flatter blue.
  - c1 +15 (9.5): it was +9 already. The extra comes from the crown at the frame top, and the jet is now bluer and less white.
  - c3 +9.

**Crown trade-off (decision).** The first crowns were 1.0x royal blue (14,50,175). They pushed p1 to 104 and reached the frame top. The 0.8x royal crowns of set d pushed p4 to 120. The final crowns are 0.68x and a lighter blue, about the size of the reference crowns in p2 and p4. I kept them because every view now has the reference's tree in the same place (p1, p2, p3, p4, p5, c1, c3). If the reviewer marks the p4 or c1 saturation, the knob is `TREE_COL` and `CROWN_K` in `out/r34w/params.lua`.

**The eight 9.5 cameras** (p3, p4, p5, p6, p8, c1, c2, c4), checked by eye in the contact sheet and the triptychs:
- p3, p4 and p5 gain the notch trees.
- c1 gains the smooth band and the darker niche.
- p8 gains solid red, flat patches and the round rock.
- p6, c2 and c4: no feature lost. c4 is unchanged; its tread (189,196,189) is the same as before.

## What I measured / proved
- **Band ownership.** A red Neon tint on the band showed one continuous smooth arc in c1 and c3, with nothing in front of it. The first colour, (125,130,130), rendered (174,181,180), too light against the ref (134,136,138); (100,104,105) renders (150,159,159).
- **Placement by authored bbox.** `r34_info()` gives authored centres in Studio axes: K_Arch20_stone (0,6.25,0), band (0,3.85,0). In Studio the band lands at (0,3.85,0), size 59.18 x 7.7, exactly where it was authored.
- **The p3 box geometry.** p3 x 60-320 / y 60-260 from (-10,6,0) is 30-46 deg left and 13-31 deg up. At the notch tree (34 studs out, 25 north) that is a crown of about 15 x 16 at y 15-31. The reference shows the same tree in c3 and p5, so it is the notch tree, not a separate canopy further out (pass 32/33 had found that a far mass blocks c3).
- **Saturation and crown size.** The crown scale moves p1/p4 saturation about 6-10 points per 0.15x.
- **The Raid door does not own its colour.** Black Neon gave the same (31,44,53) as (3,8,10). It is the glow and haze in front.
- **Idempotence.** Runs before the kit gave 21533 every time; with the kit band, **21534**.

## Built (method)
`fix/pass34.lua` is idempotent and runs after pass 33.
- Every touched part keeps its old value in a P34* attribute (Col/Mat, T/CC/CQ + Hidden, CF, Size, Tx), and the script restores those first.
- New pieces go in `Plaza.Pass34` (Arch34, Tree34, East34).
- It merges `Workspace.ae_kit_r34` into `ServerStorage.Kit`, scaled by `K_Scale34_stone`. `fix/build_plaza.lua` IMPORTS also lists r34.
- The source is split into `head.lua` (helpers), `params.lua` (all tuning colours and scales) and `body.lua` (blocks), so a retune touches only `params.lua`.

The blocks:
- **ARCH34:** hides Arch33 and recolours the arch. It clones the kit band at `BAND_BB + (K_Arch20.Position - ARCH_BB)`.
- **WATER34:** finds each jet part's nearest jet axis. `moveTo` scales its offset from the axis by `JW`, then it is resized and given `setT`.
- **TREE34:** for each corner, it builds the frame `out`/`t`. Crown clumps sit at `o + (t*a + out*b)*K` and rise by `17 + (y-17)*K + dy`. Each clump is a `kp("K_FluffyS_leaf")` sunk by its kit offset (9.1 x scale).
- **EAST34:** lays tiles on a 6-stud jittered grid, using `groundY` with a Grass predicate and band/rock masks. Patches are flat cylinders (Size X = thickness, rotated 90 deg about Z). The rock is SpecialMesh ellipsoids.

## Lessons (for the workflow vault)
1. **A curved trim is a kit mesh, not Parts.** Straight segments around an ellipse, tilted for a chamfer, read as saw teeth at 20 studs. A mesh swept along the same parametric curve as the parent piece, with normal offsets (`P + n*d`) and a chamfered 6-point cross-section, is smooth and costs 3k tris.
2. **Author an add-on piece in the parent's frame and place it by bbox centres.** The band was built in the K_Arch20 plaza frame and mirrored the same way. Placement is just `authored centre + (parent Studio centre - parent authored centre)`, and it landed exactly with no tuning.
3. **Find what a review box shows before adding geometry.** The "royal-blue canopy over a dark rock" in p3 is the notch tree the other views also show. Growing the existing tree fixed p3 and also matched c3, p5, p2 and p4, where a separate canopy would have stood in the c3 frame.
4. **A new saturated piece seen by many cameras moves every camera's saturation.** Tune its size and colour against all of them at once. The first crown fixed p3 (+17) and overshot p1 (+24) and p4 (+13). Two steps of size and lightness brought all of them to within 7 of the reference, except c1.
5. **Solid ground colour from Neon tiles.** Under this lighting, a sunlit red part gains G and B from ambient light. Neon tiles at about half the target colour, laid on the grass with a ground-predicate ray, hit the red target in one try ((182,54,59) vs (184,69,62)) and remove the dither.
6. **When a dark target does not move with its own colour, stop tinting.** The Raid door at (3,8,10) and at (0,0,0) rendered the same; what lifts it is in front of the door.

## Objects built (for 5 Object Recipes)
- **Smooth arch inner band (kit):** a sweep along the arch opening ellipse (hw 7.6, rise 5.4, springing 1.1) plus straight legs.
  - Cross-section: 6 points, 1.0 wide (0.2-1.2 off the edge) x 0.35 deep, with 0.12 chamfers, smooth shaded.
  - Mirrored to the 4 corners in one mesh, SmoothPlastic (100,104,105).
- **Narrow translucent jet:** the arc segments pulled to 0.6 of their radius and 0.6 wide, T 0.7, tint (150,200,215).
- **Big notch tree crown:** a trunk cylinder 1.1 x 9.5 up to y 24.
  - Crown: 6 cloud clumps (0.4-0.68 scale), offset up to 3 studs sideways and 3-9 up.
  - Colours alternate royal (48,98,212) and light (88,138,222).
- **Solid flower field:** Neon tiles (102,38,33) +-6, 7.5-9 square with random yaw, 0.2 thick, 0.12 above the grass. 35 % get a 0.5 white dot.
- **Flat flower patch:** 3 overlapping flat Neon discs (66,88,25), 10-14 across, plus 14 white 0.6 dots.
- **Rounded rock mound:** 6 overlapping Neon ellipsoids (27,28,26), 12-22 across and 12-24 tall, with 3 lighter caps (45,48,45) 6 x 1.6 x 5 on top.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **21534** (pass 33: 20571). Workspace holds Camera, Terrain, SpawnLocation and Plaza; the `ae_kit_r34` import model was merged into `ServerStorage.Kit` and removed.
- Nothing was saved or committed, and there was no computer use.
- Changed tracked files: `tools/ae_kit.py` (pass-34 section), `fix/build_plaza.lua` (IMPORTS r34) and `ae_kit.blend` (saved after the export).
- New files: `fix/pass34.lua`, `kit/own/ae_kit_r34.fbx` and this note.
- `fix_lighting.lua` was not re-run. Technology, post effects and Atmosphere are unchanged, and Haze was not tested.
- **How to rebuild:** on the pass-33 build with `ae_kit_r34` imported, run `sh out/r34w/run.sh`.

## Reference use
The round-31 frames in `out/verify31/` were used for every target. The reference studio was not captured; no execute_luau and no position reads were done there, and `ae_reference.blend` was not opened. Only own meshes and Parts were used.

## Next
- **c2 and p1 arch face:** these are backlit faces. They need a lit chamfer or side face on the arch (kit), not a colour.
- **Jet:** the reference shows a glowing cyan splash with a dark niche around it. Try a small Neon cyan core about 1 stud wide inside the faint dome.
- **Crowns:** if the p4 or c1 saturation is marked, use the lighter crown colour or 0.6x.
- **Raid door:** find the glow or haze in front of it (a beam, a ParticleEmitter or a PointLight brightness) and test with it disabled.
- **Items 6-10:** lagoon, lawn, canal, falls, portal, Summon entry, bollard finish.
