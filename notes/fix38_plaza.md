# Fix pass 38: Anime Expeditions spawn plaza (jet plume, light NE U face, maroon Raid arcade, dark notch recess, lighter SE/NW arms, sign teal)

Builder report for `notes/fix_brief38.md`, answering the round-35 review `notes/verify35_plaza.md` (9.50/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`). Reference studio `97946bf6-...`: not captured (the full-size
v35 frames were enough). **No kit this pass:** item 4 (the notch) turned out to be a Studio-side fix. About 85 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 Jet | **Done.** The pass-37 sheet, froth and plume are hidden (44 parts). The new spill uses the same curl as pass 37 (c2), but it is 2 wide instead of 3 and SmoothPlastic (110,160,180) at T 0.55. A flat white froth crown (2.4 x 0.6 x 1.5, T 0.1) sits on the landing, and a misty plume comes from a smoke **ParticleEmitter** (engine texture `rbxasset://textures/particles/smoke_main.dds`, rate 40, life 1.3, LightEmission 0.25). Results: c1 (640,400) (126,201,230) -> **(60,116,151)** vs (84,118,133). c1 (640,430) -> **(254,254,254)** vs (226,254,254). c3 (640,600) -> **(59,114,148)** vs (100,143,159). An ellipsoid plume read as a glass orb (`out/r38w/t_jet4.jpg`). LightEmission 0.8 glowed white in c2 and p2 (`t_c2j.jpg`), so it was toned down (`t_jet8.jpg`). |
| 2 NE arch outer value | **Done, differently from the brief.** A zoom of the ref (`out/r38w/t_arch.jpg`, `t_ne1.jpg`, `t_p5z.jpg`) shows that the ref's NE **U face is light grey** in c1, p1, p3 and p5: c1 (560,330) is (134,136,138) and (740,320) is (139,139,141). The c1 (500,300) box that pass 37 darkened for lies on the ref's darker shoulder, not on the U face. The brief's p3 and c1 "outer" boxes are on our U face ("side" piece, tint `out/r38w/tint_sheet38.jpg`). NE (all three split pieces) (56,61,66) -> **(100,102,105)**: p3 (150,330) (68,80,90) -> **(133,138,140)** vs (134,135,139); c1 (740,320) (65,78,86) -> **(133,137,138)** vs (139,139,141). **Boxes that went the other way:** c1 (500,300) (64->132 vs 60) and p5 (560,330) (77->138 vs 76). In both, our wider arch puts its U face where the ref shows a shoulder or edge. By eye, the light U with dark shoulders now matches the ref arch in c1, p1, p3 and p5. c1 (900,300) and p1 (80,330) were not moved: in the ref, c1 (900,300) is the fountain behind a smaller arch, and p1 (80,330) is the gold rim (geometry, not colour). Material tests (Metal, Foil, Marble) gave no view-dependent lift. |
| 3 Raid arcade | **Colour done; interiors unchanged.** Arcade wall (96,88,84) -> (50,16,20) and trim -> (40,14,20). Measured: p3 (600,320) **(123,59,72)** vs (104,49,55); p3 (560,330) **(95,60,74)** vs (79,38,49); p5 (1100,320) **(100,56,70)** vs (103,24,31); c3 (1060,470) **(95,62,83)** vs (74,68,65). A first try at (92,30,36) rendered (179,63,76): the red lights add a lot. The door, the bays and the p4 ring are already black Neon (picked: `RaidDoor33`, `RaidDoorTop33`, `StoryOpening14` (0,2,5)), so their lift is Atmosphere, which is settled. |
| 4 c3 notch | **Done without a kit.** A tint (`out/r38w/t_tintn.jpg`) showed that the pale band is the hero vault face between the gold sill (`NotchSill21`) and `NotchWall22`. It is not the arch. A dark slab (34,40,52), 1.1 tall, sits 0.35 behind each gold sill (4 corners). c3 (640,500) (159,177,187) -> **(41,54,71)** vs (60,65,80). The gold sill stays at the front, so this reads as a dark recess with a thin gold sill. |
| 5 U arms | **Colour only.** SE armF -> (150,158,168): c2 (560,200) (69,78,109) -> **(104,113,144)** vs (100,113,134). NW (all pieces) -> (96,100,105): p1 (150,350) (55,67,81) -> **(80,87,103)** vs (89,91,103). p1 (120,250) is the Guild building (pass 37). The stepped ledge was not built. |
| 6 Shoulder band | **Tested, reverted.** Slate band (112,116,122) -> (92,96,102) cut c1 (340,300) from 148 to 118 (ref 143). p5 (520,300) did not move, so that box is a different piece (probably `ArchLedge35`). |
| 10 Sign teal | **Done.** `K_TxtExp9_letters` SmoothPlastic (100,230,200) -> (150,255,255): p2 (640,240) (65,174,173) -> **(103,188,205)** vs (107,228,226). |
| 7-9, rest of 10 | Not attempted. |

## Captures
- **Final set:** `out/r38/r38_<cam>.png`, all 12 at full size **1284 x 793**. Contact sheet `out/r38/contact.jpg` (v35 ref | v35 rep | r38).
- **Working sets:** `out/r38w/a` (baseline = v35), `b`-`i`, `tint` (arch classes), `tintn` (notch parts), `m_<Material>` (material test), `ne1` (NE light test).
- **Tools (`out/r38w/`):**
  - `run.sh` runs `build.sh` (head + params + body -> `fix/pass38.lua`) and then the script. `lrun.sh` runs a Lua file and `some.sh <tag> [cams]` captures a set.
  - `bx.py`, `pick.py`, `tri.py` now point at v35. `sheet.py <tagA> <tagB> <out> cam:box ...` makes rows of ref | A | B crops.
  - `tint38.lua`, `tintn.lua`, `untint38.lua` (restores every T38C tint) and `t_ne.lua`, `t_mat.lua` (tests).

**Top-half saturation (ref / v35 rep / r38) and change against the v35 practice frame (pixels > 30 levels):**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref | 82 | 100 | 102 | 110 | 91 | 117 | 87 | 100 | 95 | 109 | 91 | 84 |
| v35 | 89 | 96 | 101 | 112 | 97 | 106 | 82 | 88 | 104 | 100 | 104 | 93 |
| **r38** | **88** | **96** | **102** | **112** | **97** | **106** | **83** | **90** | **100** | **101** | **105** | **94** |
| change % | 2.7 | 1.3 | 4.3 | 0.7 | 3.0 | 0.8 | 0.9 | 2.2 | 7.5 | 1.7 | 4.4 | 0.7 |

c1 saturation moved toward the ref (104 -> 100, ref 95).

**Checks on the 9.5s (contact sheet, by eye):**
- c1, p3, p5, p1: the NE arch is now a light U with darker shoulders, like the ref. The jet reads as a dark sheet with a mist plume and a white crown.
- c2: the lighter near arm. The jet from the side is a soft mist over the curl, a little brighter than the ref.
- c3: the notch is dark, the jet is darker, and the arcade is maroon.
- p2: the sign is lighter teal. The jets show as soft white mist in the arches.
- p4, p6, p7, p8, c4: almost untouched (0.7-2.2 %).

**Risks to re-check:**
- c1 (500,300) and p5 (560,330) went light (see item 2).
- The particle plume is animated, so each frame differs a little (as the ref's does).

## What I measured / proved
- **Look at the ref before you trust a review box.** At full zoom, the NE U face is light in every ref camera. The c1 (500,300) box sits on a shoulder band that our wider arch does not have at that pixel. Measuring 4-5 more points on the same surface showed this.
- **Uniform materials have no view-dependent value.** Metal, Foil and Marble on the NE piece kept the p3/c1 ratio near 1.1, against 2.2 in the ref boxes. The box conflict was geometric, not a material effect.
- **The c3 pale band belonged to the hero vault**, not to the arch or the notch parts (tint). Pass 37 thought that it needed a kit change.
- **A smoke ParticleEmitter reads as a mist plume; a sphere-mesh ellipsoid reads as an orb.** Emitters render in Edit-mode captures. LightEmission above about 0.3 glows white from back-lit angles (c2, p2).
- **Red-lit dark Plastic:** (92,30,36) rendered (179,63,76), and (50,16,20) rendered (100-123,56-59,70-72).
- **Idempotence:** repeated runs give the same report line and **Plaza 21943**.

## Built (method)
`fix/pass38.lua` is idempotent and runs after pass 37.
- Every touched part keeps its old value in a P38* attribute, and the script restores those first.
- New pieces go in `Plaza.Pass38` (Jet38, Notch38).
- The script merges `Workspace.ae_kit_r38` if one is ever imported, and `fix/build_plaza.lua` IMPORTS lists r38.

The blocks:
- **JET38:** hides the Jet37 Sheet37/Froth37/Plume37 and keeps the spout and lip. It rebuilds the spill per corner in the frame `d = (sx,0,sz).Unit`, `u = (-sz,0,sx).Unit`: a flat run, 6 arc segments of radius 1.2 and a drop. It adds the lip froth and the landing crown (sphere-mesh ellipsoids), and a hidden source part with a smoke ParticleEmitter that emits upward.
- **ARCH38:** recolours the Pass37 split pieces by `STONE38[corner_class] or STONE38[corner]`. The `SLATE38` knob is nil (the test is described in params).
- **RAID38:** recolours ArcWall37 and the trim pieces.
- **NOTCH38:** for each `NotchSill21`, places a slab at `d * (|xz| + 0.35)`, y 8.95-10.05, framed by `CFrame.fromMatrix(pos, u, up)`.
- **SIGN38:** recolours the letters.

## Lessons (for the workflow vault)
1. **A review box can sit on a different surface in the ref than in the build.** Before you retint a piece for one box, zoom the ref and sample 4-5 points on the same surface. Pass 37 darkened a whole U face for a box that, in the ref, is on the shoulder. The whole arch read inverted (dark U, light shoulders).
2. **Prefer the whole-surface value over a single box.** When two boxes on one piece want opposite values, the piece's dominant value in the ref decides.
3. **Mist and froth want particles, not solids.** A translucent solid ellipsoid reads as a glass ball. A smoke emitter with the engine's default smoke texture gives a soft plume. Keep LightEmission low, or back-lit views turn it into a white glow.
4. **Tint before you plan a kit change.** The "notch sill" that pass 37 marked for a kit rework was another mesh's face. A 1-stud dark slab behind the gold sill fixed it.
5. **Under strong coloured lights, aim about half as bright as the target.** Red point lights doubled the red of a dark maroon.

## Objects built (for 5 Object Recipes)
- **Fountain jet (spill + plume):** a 2-wide water sheet (110,160,180) at T 0.55 that runs over the spout lip and curls down (6-segment quarter curl, radius 1.2). A flat white froth crown 2.4 x 0.6 x 1.5 sits on the landing. A smoke ParticleEmitter (`smoke_main.dds`) on a hidden source part: rate 40, life 0.9-1.3, speed 1.1-1.6 up, size 1.0 -> 1.9, transparency 0.3 -> 0.6 -> 1, colour (215,245,252) -> (110,180,215), LightEmission 0.25, light gravity -0.6.
- **Notch recess:** a dark slab (34,40,52), 1.1 tall and 0.12 thick, 0.35 behind a thin gold sill, which hides the lit face behind it.
- **Arch values per corner:** the sunlit NE U face (100,102,105) renders (133-138). The other corners are darker (NW (96,100,105), SW (72,78,84), SE (110,117,128)), with a lighter SE arm (150,158,168).
- **Maroon arcade under red light:** wall (50,16,20) and trim (40,14,20) render about (100-123,56-60,70).

## State at the end
- `#workspace.Plaza:GetDescendants()` = **21943** (pass 37: 21880). The Workspace children were not changed.
- Nothing was saved or committed, and there was no computer use. `RivalsPractice_replica.rbxl` was not touched. The reference studio was not used.
- Changed tracked files: `fix/build_plaza.lua` (IMPORTS r38). New files: `fix/pass38.lua` and this note.
- `tools/ae_kit.py` and `ae_kit.blend` are unchanged: no kit this pass.
- `fix_lighting.lua` was not re-run. Technology, post effects and Atmosphere are unchanged, and Haze was not tested.
- All test tints were restored (`untint38.lua`).
- **How to rebuild:** on the pass-37 build, run `sh out/r38w/run.sh`.

## Reference use
The round-35 frames in `out/verify35/` were used for every target. There was no execute_luau, no position read and no capture in the reference studio, and `ae_reference.blend` was not opened. Only own Parts, own meshes and an engine-default particle texture were used.

## Next
- **Arch geometry:** our arch is wider than the ref's in c1, so the c1 (500,300) and p5 (560,330) boxes land on our U face. A narrower U, or a dark shoulder panel with light ridges like the ref's (kit), would serve both.
- **Raid:** a slightly darker maroon, for example (40,12,16).
- **Items 6-9:** the shoulder band at p5 (find the owner first, probably ArchLedge35), the Summon side, the SE rock and sand, and the crowns.
