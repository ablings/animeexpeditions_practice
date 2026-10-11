# Fix pass 37: Anime Expeditions spawn plaza (skybox turn, Raid arcade, niche spill, per-corner arch stone + shoulder grooves, p2 ring/sign/fringe)

Builder report for `notes/fix_brief37.md`, answering the round-34 review `notes/verify34_plaza.md` (9.46/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`). The reference studio `97946bf6-...` was not captured:
the full-size v34 frames were enough. **One kit:** `kit/own/ae_kit_r37.fbx` (12 split arch pieces `K_Arch37_<corner>_<class>`,
`K_Groove37_dark`, scale cube `K_Scale37_stone`), imported by the lead (Insert Using Scene Position + Anchored). About 90 + 35 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 c3 sky | **Done (global).** The white at c3 (300,40) is the skybox, not Terrain Clouds (Clouds off: no change). `Sky.SkyboxOrientation` Y tested at 0/15/30/55/90/180/270/330/340/345 (`out/r37w/t_sky*.jpg`). 90 fixed the box but c3 top-half saturation went 100 -> 117 (ref 94). **340:** (228,232,235) -> **(68,165,243)** vs (94,201,240); the cloud mass now sits centre-left as in the ref; c3 sat 104. The other sky cameras moved 1-3 in saturation (sheet `out/r37w/t_sky90.jpg` for the method). |
| 1 c3 recess under the arch (640,500) | **Not moved.** After the kit, the pixel is `K_Arch37_NE_armF`, but it is the sunlit notch sill top (up-facing), which renders (159,176,187) even at (56,61,66). It needs a deeper notch (geometry). |
| 1 Raid recesses | **Done as an arcade.** The pass-36 recesses were there (pick hit them) but the red lights washed (40,12,16) SmoothPlastic to the facade pink. New: a curved low wall each side of the door (x 151 -> 147, z 8.5 -> 31, 23 tall), 3 bays a side (5.2 x 15 + half disc, Neon (10,4,6)), a surround, pilasters, a cornice and a plinth. It reads in c3 and p3 like the ref's dark arcades. Stone (150,128,124) rendered (245,150,165); (96,88,84) renders grey-pink. c3 (1060,470) (129,64,95) -> (136,96,115) vs (90,79,68). (1100,450) is above the arcade on our taller facade: unchanged. |
| 1 Raid door | Not changed: it is black Neon; the lift is the (settled) Atmosphere. |
| 2 U arms | **Per-corner stone (kit).** The SE arch (c2 view) is (110,117,128): c2 (560,200) (40,49,68) -> **(69,78,109)** vs (100,113,134). (130,138,150) gave (86,97,129), but it made the SE/NW arches pale in p1/p2/p4, where the ref arches read dark, so I took the middle. NW is unchanged: the p1 (120,250) box is a distant Guild building (`K_Guild9_dark`), not the arch. The stepped ledge on the arms was not built. |
| 3 Front face, grooves, gold | **Done.** NE stone (56,61,66): c1 (500,300) (88,101,110) -> **(64,77,85)** vs (60,64,60); c1 (380,350) -> (63,74,83) vs (59,69,77); p5 (560,330) -> **(77,83,83)** vs (76,81,81). **Cost:** p3 (150,330) (92,104,114) -> (68,80,90) vs (134,135,139) (same NE face; the ref has a different piece there). Grooves (70,78,88): c2 (700,250) (71,76,100) -> (36,47,69) vs (45,52,62). They also land on c1 (900,300) (147 -> 86 vs 180) and p1 (80,330) (97 -> 57 vs 91): by eye they read like the ref's slatted shoulder, but those two boxes went down. Gold (195,150,55) -> (175,135,48): p5 (500,330) (178,152,64) -> (167,141,58). |
| 4 Niche and jet | **Done.** All Jet* parts (168) and NicheSheet33/Lip33 are hidden. Per corner there is a dark spout block with a gold lip, and a 3-wide water sheet that runs over the lip and curls down onto the drum, with froth at the lip and the landing and a soft plume. Niche lights off: c2 (600,400) (72,119,146) -> **(9,17,33)** vs (0,13,22). DrumWater is Neon (62,100,112): p5 (640,420) (201,233,210) -> **(90,176,172)** vs (59,138,169). c1 (640,400) (76,143,172) -> (126,201,230) vs frothy (165,218,231). c2 (480,250) is arch stone, not the niche: unchanged. |
| 5 p2 | **Done.** Ring segments are `Pass28.Cres28` (not `K_ExpRing8_stone`): Slate -> SmoothPlastic (160,166,176), (99,110,144) -> ~(133,143,174) vs (120,135,160). The sign is 1.5x and 6 lower, onto the gate crest. The S fringe band was lowered 10: (720,200) (100,135,111) -> **(144,178,186)** vs (180,203,215). |
| 6-10 | Not attempted. |

## Captures
- **Final set:** `out/r37/r37_<cam>.png`, all 12 at full size **1284 x 793** (Import Queue closed). Contact sheet `out/r37/contact.jpg` (v34 ref | v34 rep | r37).
- **Working sets:** `out/r37w/a` (baseline = v34), `b`-`h`, the sky tests `s<deg>` and `tint` (class tint: face red, armF green, side blue, groove yellow; `tint_sheet37.jpg`).
- **Tools (`out/r37w/`):**
  - `run.sh` runs `build.sh` (head + params + body -> `fix/pass37.lua`) and then the script.
  - `lrun.sh`, `some.sh`, `bx.py`, `tri.py`, `pick.py` and `pickn.py` (pick with the hit normal, first hit only).
  - `skyd.py` and `skysheet.py` are for the sky tests; `r37_info.json` holds the authored bbox centres.

**Top-half saturation (ref / v34 rep / r37) and change against the v34 practice frame:**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref | 82 | 99 | 102 | 110 | 91 | 116 | 87 | 101 | 94 | 110 | 94 | 84 |
| v34 | 87 | 97 | 97 | 114 | 98 | 109 | 82 | 88 | 103 | 101 | 99 | 92 |
| **r37** | **89** | **96** | **103** | **112** | **97** | **106** | **83** | **90** | **104** | **101** | **104** | **93** |
| change % | 4.7 | 11.1 | 11.5 | 7.8 | 5.3 | 7.4 | 1.8 | 3.0 | 8.2 | 9.5 | 16.8 | 3.4 |

**Checks on the 9.5s (contact sheet, by eye):**
- p1, p4, p6: the sky moved a little; the arches are as before (NW reverted). p6 lost 3 in saturation (ref 116).
- p2: grey ring stones, bigger sign, more sky above the band. The SE arch on the left is a little lighter than the ref's.
- p3: gains the Raid arcade. The NE arch is darker (box (150,330) worse, see item 3).
- p5, c1: darker NE face, grooves, spill in place of the box jet.
- c2: lighter SE arm, black niche, spill.
- p7, p8, c4: almost untouched (1.8-3.4 %).
- c3: blue sky, arcade, spill.

The risks to re-check are p3's darker NE arch and the c1/p1 groove boxes.

## What I measured / proved
- **Sky:** the Terrain Clouds toggle left (300,40) unchanged, so the patch is the skybox.
- **The split pieces render hollow single-sided.** The class tint showed that the visible front U face is in the "side" piece, because the K_Arch20 face normals do not point the way the geometry suggests. Once split, the arms rendered hollow (faces culled) until `MeshPart.DoubleSided = true`, which a script can set. With all of a corner's pieces the same colour, the split is now used **per corner**.
- **Red-lit facade:** SmoothPlastic (150,128,124) rendered (245,150,165) and (40,12,16) vanished into pink. Neon dark bays and a grey-green base stone (96,88,84) survive the red lights.
- **Drum water glare:** SmoothPlastic (60,140,175) still rendered (168,223,202) from the p5 angle. Neon (62,100,112) gives (90,176,172).
- **Picks:** the p1 (120,250) box is a distant Guild building, and the p2 ring is Cres28. Check the owner before you fix.
- **Final state:** `#workspace.Plaza:GetDescendants()` = **21880**, and repeated runs give the same line.

## Built (method)
`fix/pass37.lua` is idempotent and runs after pass 36.
- Every touched part keeps its old value in a P37* attribute, and the script restores those first. The skybox's original orientation is stored on `Sky` as `P37SkyO`.
- New pieces go in `Plaza.Pass37` (Raid37, Jet37, Arch37).
- The script merges `Workspace.ae_kit_r37` into `ServerStorage.Kit`, scaled by `K_Scale37_stone`. `fix/build_plaza.lua` IMPORTS lists r37.

The blocks:
- **SKY37:** sets `SkyboxOrientation`.
- **RAID37:** curved wall segments `P(t) = (x0 + back*t^1.5, s*(z0 + (z1-z0)t))`. Each segment is framed by `CFrame.fromMatrix(mid, T, up)` with the tangent flipped so that `T x up` faces the plaza. Each bay is a Neon rect plus a Cylinder half-disc, in front of a trim rect and disc. Pilasters sit at the segment ends.
- **JET37:** corner frame `d = (sx,0,sz).Unit` and `u = (-sz,0,sx).Unit`. The sheet is a flat run, then 6 arc segments (radius 1.2), each oriented by `fromMatrix(pos, u, radial normal)`, then a vertical drop. Froth and plume are sphere-mesh ellipsoids.
- **P2_37:** recolours Cres28, resizes and moves the sign, and moves the fringe models (pivot).
- **ARCH37:** clones each kit piece at `BB + (K_Arch20_stone.Position - ARCH_BB)`, colours it from `STONE37[corner_class] or STONE37[corner] or STONE37[class]`, sets it DoubleSided, and hides `K_Arch20_stone`. It also tones the gold.

Kit: `tools/ae_kit.py` pass-37 section (`build_split37`, `build_groove37`, `build_all37`, `r37_info`, `export_r37`).
- **Split:** the faces of `K_Arch20_stone` are split by corner (from the face centre sign) and by class. The class uses the face normal against the plaza direction and `_uwy` for the arm band. No new geometry: 16/92/344 tris per corner.
- **Grooves:** for each light band (po..o1, o1..o2), a 0.4-wide strip around the local middle of the band, from W-0.03 to W+0.05, swept with `arch_band` and mirrored to 4 (2240 tris).

## Lessons (for the workflow vault)
1. **A skybox turn is a global change, but a small one can be cheap.** Score it on the target box, on composition and on saturation together. 90 deg fixed the box but added +17 saturation; -20 deg fixed the box and kept the cloud mass where the ref has it.
2. **Splitting a mesh by face can expose its normals.** Tint every class before colouring. Here the visible front faces were in the class I thought was "back", and the split pieces rendered hollow until DoubleSided was on.
3. **Per-corner materials resolve a box conflict that one material cannot.** The lit NE front wants dark and the back-lit SE arm wants light. One colour can only trade between them; one colour per corner moves both.
4. **Coloured lights eat dark Plastic.** Under strong red point lights, a (40,12,16) recess rendered as facade pink. Use Neon for anything that must stay dark, and a desaturated base stone for anything that must stay neutral.
5. **Check what owns the review pixel before you fix it** (again): the p1 arm box was a building 150 studs away, and the p2 ring was a different model from the one named "Ring".
6. **A fine detail placed in the middle of a band can land on a review box.** The grooves read right by eye but darkened two light-band boxes. Measure the boxes after adding detail lines.

## Objects built (for 5 Object Recipes)
- **Gothic arcade wall:** curved wall segments (23 tall, 1.6 thick) with 3 arched bays a side. Each bay is a Neon near-black (10,4,6) rect 5.2 x 15 with a half-disc top, inside a 1-wider trim rect and disc (74,68,64), with pilasters 1.2 x 2.2 at the segment ends, a cornice 0.9 and a plinth 0.6. Base stone (96,88,84) under red light.
- **Fountain spill:** a dark spout block 3.6 x 1.4 x 2 with a gold lip rod, and a 3-wide water sheet (150,205,225) at T 0.1: a flat run, a 6-segment quarter curl of radius 1.2, and a 0.75 drop onto the drum. White froth ellipsoids sit at the lip (3.4 x 0.45 x 0.8) and at the landing, with a plume 2.2 x 1.5 at T 0.55. The niche lights are off.
- **Per-corner arch stone:** the existing arch mesh split by face per corner, so each arch is coloured on its own (NE (56,61,66), SE (110,117,128), others (72,78,84)). Set DoubleSided.
- **Shoulder grooves:** 0.4-wide dark strips (70,78,88) along the middle of each light shoulder band, 0.03 proud.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **21880**. Workspace holds Camera, Terrain, SpawnLocation and Plaza.
- `ae_kit_r37` was merged into `ServerStorage.Kit` and removed. `Lighting.Sky.SkyboxOrientation` is (0,340,0).
- Nothing was saved or committed, and there was no computer use. `RivalsPractice_replica.rbxl` was not touched.
- Changed tracked files: `tools/ae_kit.py` (pass-37 section), `fix/build_plaza.lua` (IMPORTS r37) and `ae_kit.blend` (saved after the export).
- New files: `fix/pass37.lua`, `kit/own/ae_kit_r37.fbx` and this note.
- `fix_lighting.lua` was not re-run. Technology, post effects and Atmosphere are unchanged, and Haze was not tested.
- **How to rebuild:** on the pass-36 build with `ae_kit_r37` imported, run `sh out/r37w/run.sh`.

## Reference use
The round-34 frames in `out/verify34/` were used for every target. There was no execute_luau and no position read in the reference, it was not captured, and `ae_reference.blend` was not opened. Only own meshes and Parts were used.

## Next
- **c3 (640,500):** deepen the U notch in the kit (sill from 9.0 to about 7.4, with a dark back), so the lit sill top drops out of the box.
- **p3 (150,330) vs c1 (500,300):** these are the same NE face with opposite targets. The ref has a separate dark band there, so a narrower U face and a dark shoulder band would serve both (kit).
- **Grooves:** move them off the c1 (900,300) and p1 (80,330) light boxes, or narrow them to 0.25.
- **Stepped ledge on the U arms** (item 2), the Raid door, and items 6-10.
