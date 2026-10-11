# Fix pass 33: Anime Expeditions spawn plaza (dark Boss Rush towers in the p3 sky, black Raid doorway, E ground with rubble band, dark rock and flower patches, dark slate arches, softer jets with niche water sheets)

Builder report for `notes/fix_brief33.md`, answering the round-30 review `notes/verify30_plaza.md` (9.29/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`). The reference studio `97946bf6-...` was not captured:
the full-size v30 frames were enough. **No kit this pass.** All work is Studio-side (Parts, WedgeParts, SpecialMesh ellipsoids and
clones of our own kit pieces), so no Import 3D was needed and `ae_kit.blend` was not touched. About 95 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 p3 sky gap | Part. **Dark Boss Rush mass:** 2 own `K_Tower9` towers (1.05x, 0.95x), 2 `K_Spire` (2.1x, 2.4x) and 2 `K_Gothic` blocks (1.5x, 1.4x) in Slate (34,27,36), darks (20,16,22), roofs (48,30,52), at x 92-112, z -56..-92. They now fill p3 x 100-330, y 20-250 with dark gothic silhouettes, where there was sky and a light island. Top-half saturation p3 86 -> **92** (ref 103). The (200,200) box itself is still the lit blue tree in front (92,165,237); that tree is the same object the ref has there, only the ref's crown is darker. **Raid doorway:** black door (rect 11 x 23 plus an 11-stud round top) in front of the arch bands: (640,340) (137,60,71) -> **(32,43,53)**, (640,300) -> (31,43,54) vs (5,16,18). **Boss Rush block:** `BossTower` (70,40,90) -> (24,17,30), `GothBoss29_stone` -> (30,20,34), `DarkTree32` -> (30,23,27); p3 (300,250) (102,87,85) -> (57,63,74) vs (20,19,24); c2 (250,200) (98,81,135) -> (60,73,92). |
| 2 E ground | Done. **Red:** 1695 red ground pieces (Splats17/East18, Carpet31/32/24, Zoning patches) scaled R x0.62-0.72, G x0.8 of that, B x0.45 of that. **Rubble band:** red pieces inside x 58-178, z -9.5..12.5 hidden (224 incl. the rock area); 120 grey Slate slabs (34,37,37) +-5 at 4.5-7.5 studs plus ~40 stones. p8 (950,400) (241,73,86) -> **(111,122,123)** vs (95,103,103). **SE rock:** 26 pieces in an ellipse 32 x 30 at (124, 70): Neon (24,26,25) blocks plus SmoothPlastic wedges. p8 (1100,650) (235,118,99) -> **(48,57,64)** vs (50,53,51). **Flowers:** 6 patches of 7 own `K_ClumpG_leaf` (70,130,20) at 1.2-1.7x, plus 4 white flower balls each. **Trees:** 6 of the ~20 E trees hidden (2 Pass11 dead trees, 2 RedTree22, 2 Raid11 dead trees). |
| 3 Arch face | Done (colour); band not proven. `K_Arch20_stone` (101,107,111) -> (62,66,67): c1 (500,300) (133,143,145) -> **(73,85,85)** vs (60,64,60), (860,300) -> (74,84,85) vs (89,90,90). A 0.7-stud light band (124,129,131), tilted 30 deg, runs round each niche opening (56 segments). A pick at the opening edge hits the gold trim first, so **the band is probably hidden behind `K_Arch20_gold`**; move it 0.6 outward next pass, or remove it. No stepped bevel. |
| 4 Lagoon / S lawn | Not done. Lagoon (0,30,44) was tried and reverted: p8 W went (62,89,132) -> (63,90,111), further from the ref (109,129,145). The p7 "lagoon" box (260,250) is a blue tree (`K_Soft13P_leaf`) in our frame, not water. Lawn not touched (lighting owns its blue, see pass 31/32). |
| 5 Jet core | Done. 160 Jet30/Jet31 parts (column, core, arcs, plume) are now (150,200,215) at T >= 0.4; the Neon core is now SmoothPlastic. c1 (640,400) (233,253,254) -> **(203,238,242)** vs (190,223,233). **Back-niche water sheet:** for each of the 4 `TunnelBack20` panels, a 4 x 5.4 plane (120,160,176) at T 0.3, 0.3 studs in front, with a lip (175,215,228) at T 0.2. |
| 7 Boss Rush facade | Part (with item 1). It is darker; the magenta sign is unchanged at (176,90,182). |
| 8 Portal | Done (compromise). Portal31 plane (10,108,122) -> (9,102,116), swirl arms and core x0.94. p2 (640,330) (10,160,174) -> **(12,143,157)** vs (4,131,142). p6 door (11,141,161) -> (11,128,149) vs (15,155,168). A 0.8x try put p2 on target (10,133,147) but took p6 (a 9.5) to (12,119,137), so I settled between. No inset plane; the orb was not moved. |
| 10 Story ring / bollard | **Ring:** `StoryOpening14` SmoothPlastic (6,12,28) -> Neon (0,2,5): p4 (620,320) (29,40,54) -> **(12,22,30)** vs (2,11,16). **Bollard slab:** (226,226,218) -> (150,150,143): p5 (640,610) (255,255,255) -> (242,242,232); p1 box (251,252,245) -> (212,213,202) vs (230,231,223). The dome was not changed. |
| 6, 9 | Not attempted (falls finish, c3 cloud, Summon entry/door, c4 desaturation, stalls). |

## Captures
- **Final set:** `out/r33/r33_<cam>.png`, all 12 at full size **1284 x 793** (second frame of `capture_set2.py`). Contact sheet `out/r33/contact.jpg` (v30 reference left, r33 right).
- **Baseline:** the round-30 practice frames `out/verify30/v30_<cam>_rep.jpg`. The saved place was the pass-32 state; descendant count 20209 was confirmed at the start.
- **Working sets:** `out/r33w/a` (first run), `b` (Raid door tests), `c`, `d`, `e`; pairs `out/r33w/pair_<cam>.jpg` (ref above, ours below); crops `out/r33w/zz_<cam>.jpg`.
- **Tools (`out/r33w/`):**
  - `run.sh` runs `fix/pass33.lua` (built as `head.lua` + `body.lua`).
  - `lrun.sh <lua>` writes its JSON to `out/r33w/json/`.
  - `some.sh <tag> <cams>` captures a subset of cameras; `run_cap.sh` captures the final set.
  - `metrics.py <tag> [dir]` compares against the v30 ref and v30 rep; `redm.py` gives the mean of the red pixels in the E half.
  - `pick.py` (4 hits per pixel), `zz.py` (ref crop next to ours), `pair.py`, the queries `q_*.lua` and `q_arch.lua` (the ray probe of the arch opening).
  - Scratch tests `t_*.lua`. They disabled the Raid haze, smoke and ember emitters; all of them were restored to their pass-32 state (RaidSmoke13 stays off, as pass 14 left it).

## Results
**Top-half mean HSV saturation:**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref v30 | 83 | 100 | 103 | 109 | 91 | 112 | 86 | 102 | 94 | 110 | 92 | 81 |
| base (v30 rep) | 77 | 90 | 86 | 106 | 95 | 105 | 83 | 92 | 103 | 102 | 95 | 91 |
| **r33** | **80** | **91** | **92** | **107** | **95** | **106** | **82** | **90** | **105** | **103** | **95** | **91** |

- p3 is up 6 and p1 up 3.
- **p8 is down 2 and p7 down 1.** The grey band and the dark rock are grey, so they lower the top-half mean even though the reference has them too. The E red is less pink now: the mean red pixel in p8 went (200,90,91) -> (174,80,83), vs ref (164,67,59).
- c1 is up 2 (the dark arch faces).

**The seven 9.5 cameras**, checked by eye in the contact sheet:
- p3 gains the dark towers and the black door.
- p4 gains the black Story ring.
- p5 gains the black Raid door and the darker arch faces.
- p6: the portal is a little darker than before (see item 8).
- c1 and c2: the arches are darker and the jet softer.
- c4 is unchanged.

None lost a feature.

## What I measured / proved
- **Raid door ownership.** The first door, SmoothPlastic (3,8,10), rendered (137,60,71).
  - Turning off the Raid haze band, the smoke emitters and the embers changed nothing. A green Neon test then proved that the door owns the pixel.
  - `RaidDoorLight16` sits 0.2 studs behind the door, so the PointLight lit a near-black plane red.
  - Neon ignores lighting, so Neon (3,8,10) renders (32,43,53).
- **Ambient floor.** Top-lit SmoothPlastic never renders darker than about (65,78,87), even at a colour of (12,12,10).
  - The SE rock reached (50,53,51) only as Neon (24,26,25), because Neon renders at about 2x its colour and ignores light.
  - Slate in sun renders about 2x: rubble (60,64,63) rendered (124,136,134).
  - The red PatchA (95,27,9) renders (171,81,80). Most of its G and B comes from ambient, so tinting the parts cannot reach the ref's (164,67,59).
- **Arch opening by ray probe.**
  - Rays were cast outward along the diagonal against the arch meshes only. The arch face is 33 studs out.
  - The niche opening is a half-ellipse 5.3 wide x 3.6 tall above y 2. The arch face top is at y 11.5.
  - The opening's edge is the gold trim, so a light band laid on the stone face next to it is hidden.
- **p3 box geometry.** In the p3 frame, a dark mass at x ~100 has to reach y 55-75 to cover y 30-150. A mass in front of x 60 would sit in the middle of c3, so the towers stand at x 92-112.
- **Portal trade-off.** p2 and p6 look at the same plane. p2 wants it about 20 % darker, while p6 was already on target. I used x0.94.
- **Idempotence.** Two more runs of pass 33 give the same report and the same descendant count, **20571**.

## Built (method)
`fix/pass33.lua` is idempotent and runs after pass 32.
- Every touched part keeps its old value in a P33* attribute, and the script restores those first.
- New pieces go in `Plaza.Pass33` (P3Sky33, East33, Arch33, Water33).
- It also merges `Workspace.ae_kit_r33` if one is ever imported (scale cube `K_Scale33_stone`).

The blocks:
- **P3SKY33:** `kp()` clones of own kit towers, spires and gothic blocks on `groundY`, each yawed to face -x with a +-12 deg jitter. The Raid door is a Neon rectangle plus a Neon cylinder. Boss parts are recoloured.
- **EAST33:**
  - `redden()` scales R, G and B separately, cutting B the most.
  - Pieces whose centre falls in the band or the rock ellipse are hidden.
  - Band slabs sit on a jittered 5 x 4.75 grid on `groundY`, with a slight tilt.
  - Rock pieces are spread with sqrt-radius sampling, and their height falls off from the centre.
  - Flower patches use `kp("K_ClumpG_leaf")`.
  - The trees to hide are matched by bounding-box centre within 3 studs.
- **ARCH33:** recolours the stone. The band is built from 14 segments per half-ellipse, using `CFrame.fromMatrix(mid, outward, -normal, tangent)` with a 30 deg tilt about the tangent.
- **WATER33:** recolours and fades the jet parts (`setT`, max with 0.4). Each niche sheet is placed with `CFrame.lookAt` from the panel toward the plaza axis.
- **EXTRA33:** colour matching uses a tolerance (`near()`). An exact `Color3 ==` check failed on the gate.

## Lessons (for the workflow vault)
1. **Prove a dark piece with a bright Neon test before tuning its colour.** The Raid door owned the pixel; a PointLight inside it was what made it red. Three emitter tests had changed nothing.
2. **Dark targets need Neon.** Under this lighting, top-lit SmoothPlastic and Slate have an ambient floor of about (65,78,87). A near-black target such as a doorway, a ring interior or a dark rock reaches its colour only as Neon (about 2x the colour value, and no lighting).
3. **Grey and dark fixes can cost saturation even when they are correct.** The p8 rubble band and rock match the reference and still lowered the top-half saturation by 2. Judge them by the box colours and by eye, not only by the saturation metric.
4. **Probe a mesh's shape with rays when the kit source is not at hand.** A 21 x 33 grid of include-list rays gave the arch opening's half-ellipse in one call. Check what sits on the edge (here the gold trim) before laying a band there.
5. **One plane seen by two cameras is a compromise.** Measure both cameras before retinting a shared piece; the portal fix for p2 overshot p6.
6. **Compare colours with a tolerance.** `Color3 ==` failed on a colour that a script had set.

## Objects built (for 5 Object Recipes)
- **Dark gothic skyline mass:** 2 towers, 2 spires and 2 facade blocks from own kit, Slate (34,27,36), with darker trim (20,16,22) and roofs (48,30,52), spaced across 35 studs at 100-120 studs from the viewer.
- **Black arched doorway:** a Neon (3,8,10) rectangle 11 x 23 plus an 11-stud Neon disc for the arched top, set 0.1 in front of the arch frame. It ignores the red door light.
- **Rubble band:** jittered 4.5-7.5-stud Slate slabs (34,37,37) +-5, 0.3-0.7 thick and slightly tilted, with 35 % of grid points getting a 0.8-1.8 stone; the ground cover underneath is hidden.
- **Dark rock mound:** 26 blocks and wedges in an ellipse 32 x 30, height falling off from the centre (2-13). Blocks are Neon (24,26,25), wedges SmoothPlastic (12,12,10).
- **Flower patch:** 7 own grass clumps (70,130,20) at 1.2-1.7x in a 6-stud cluster, plus 4 white 0.7 balls.
- **Niche water sheet:** a 4 x 5.4 plane (120,160,176) at T 0.3, 0.3 in front of the niche back, with a lip (175,215,228) 4.4 x 0.3 x 0.5 at T 0.2.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **20571** (pass 32: 20209). Workspace holds only Camera, Terrain, SpawnLocation and Plaza.
- Nothing was saved or committed, and no kit was exported. `ae_kit.blend` and `fix/build_plaza.lua` are untouched (no r33 kit, so no IMPORTS entry was needed), and no tracked `cmd/*.json` was overwritten.
- `fix_lighting.lua` was not re-run (no lighting change). Technology, post effects and Atmosphere are unchanged, and Haze was not tested.
- **How to rebuild:** on the pass-32 build, run `sh out/r33w/run.sh`. It is idempotent.

## Reference use
The round-30 frames in `out/verify30/` were used for every target. I did not capture, run execute_luau in or read positions from the reference studio, and did not open `ae_reference.blend`. No computer use. Only own meshes and Parts were used.

## Next
- **Arch band:** move it 0.6 outward past the gold trim and prove it with a red tint in c1, or drop it. Add the stepped bevel.
- **p3 (200,200):** the remaining gap is the lit blue tree crown in front, (92,165,237) vs the ref's darker branch (93,76,58). Try a darker blue (20,60,200) on that one tree, `Pass29.Notch29`, and check p4 and p6.
- **Boss sign:** make the magenta letters a glow around dark letters. **Summon** entry and door. **c4** desaturation. **Falls** finish and the c3 cloud.
- **Lagoon:** the p8 W reference is lighter, with white surf and stone. Add surf and stone pieces rather than a darker tint.
