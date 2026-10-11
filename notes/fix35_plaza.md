# Fix pass 35: Anime Expeditions spawn plaza (stepped arch ledges kit, raised N crowns, teal niche sheet and dim jet base, blue N canal, lagoon banks, broken SE rock, aged-gold bollards)

Builder report for `notes/fix_brief35.md`, answering the round-32 review `notes/verify32_plaza.md` (9.38/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...` (`AE_practice.rbxl`). The reference studio `97946bf6-...` was not captured:
the full-size v32 frames were enough. **One kit this pass:** `kit/own/ae_kit_r35.fbx` (`K_ArchLedge35_stone` + scale cube
`K_Scale35_stone`), imported by the lead (Insert Using Scene Position + Anchored). About 75 + 30 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 Arch face | **Ledges (kit) done; the face colour was tried and reverted.** `K_ArchLedge35_stone` is two up-facing steps swept along the outermost K_Arch20 band outline o2, SmoothPlastic (150,155,160). **Red Neon tint test:** one continuous outer rim on every arch, with no gaps or floating pieces. Red px: c1 9140, c2 14617, p1 6840, p3 8235 (`out/r35w/tint_sheet.jpg`). In c2 it covers the whole outer shoulder. **Stone colour:** (62,67,73) took c1 (500,300) 88 -> 75 (ref 60) and p5 100 -> 87 (ref 76). But it also took c1 (860,300) 88 -> 74 (ref 89), p3 (150,330) 92 -> 77 (ref 134), p1 56 -> 47 (ref 83) and c2 40 -> 35 (ref 100), so the net was worse. It is back at the pass-34 (72,78,84). **The review boxes c2 (560,200), p1 and p3 (150,330) are on the U arm/crown (`K_Arch20_stone`), not on the shoulder** (pick), so the ledge does not move them; see Next. |
| 2 Crowns | Done. The N-corner Tree34 crowns are raised 4, their lowest third is at 0.7x, and their trunks are 4 longer. The NE crown is also shifted (1.5,0,-3.5). c1 saturation 110 -> **106** (ref 94); p5 98 (no change). p3 (150,120) (141,166,152) -> **(66,124,218)** vs (16,63,204); p3 saturation 96 -> 99 (ref 102). |
| 3 Niche water / jet | Done, toned down. `NicheSheet33` is 3.6 wide, (40,95,118) SmoothPlastic at T 0.3, moved 0.5 forward. The brief's 5 wide, (60,140,170) at T 0.2 rendered as a bright cyan box in c1. Jet parts below y 5.6 (36 parts) are (90,130,150) at T 0.85: c1 (640,420) (161,202,214) -> **(73,135,165)** vs (64,94,109). c2 (520,400) is unchanged at (16,21,33): K_Hero19 stone is in front of that pixel, not the sheet. |
| 4 Canal / lawn / lagoon | **Canal done:** Channel0, ChanSand0 and ChanKerb0 are hidden; one 8-wide strip (55,78,150) runs from the stair top (z -48.6) to z -152, with gold kerbs. p7 (640,250) (185,195,190) -> **(107,145,213)** vs (123,144,191). **SE sand:** 28 tiles (170,148,98) in an ellipse around (44,51). The p7 (900,600) box lands on our pool rim (our pool sits lower in the frame), so it cannot move with lawn colour. **Lagoon (part):** two sand-and-rock banks over the N half, each a white surf ring, a sand disc, 6 slate rocks and 5 grass discs. p8 (200,300) is unchanged (57,88,156): that pixel is the deep water and foliage south of the banks. |
| 5 SE rock | Done. Rock34 is hidden. In its place: a 29-stud Neon base disc (23,23,20) and 22 Neon rocks 3-6.5 studs with lit Neon tops (60,62,57); 35 % of them get a red Neon foliage cap. It reads as broken rock with lit tops (`out/r35w/zz_rock.jpg`), no longer as a hole. The box value is (49,58,64) vs (45,44,39). **Patches:** (66,88,25) -> (86,106,65); p8 (910,510) (97,151,77) -> **(137,193,100)** vs (153,187,94). |
| 9 Bollards | Done. 52 Boll32 parts: Metal gold -> SmoothPlastic (112,95,20), so it has no sheen; the dome is 0.7x tall on the same base; slab (150,150,143) -> (92,91,72). p5 (640,560) (215,186,21) -> **(147,119,19)** vs (143,123,18); p1 (360,520) (208,183,24) -> (134,108,20) vs a shaded (76,66,10); p5 slab (640,610) (242,242,232) -> (208,208,180) vs (167,164,126). |
| 6, 7, 8, 10 | Not attempted (p2 orb/pillars/portal, Raid door and wash, falls and c3 cloud, Summon entry and c4). |

## Captures
- **Final set:** `out/r35/r35_<cam>.png`, all 12 at full size **1284 x 793** (Import Queue closed). Contact sheet `out/r35/contact.jpg` (v32 reference left, r35 right).
- **Working sets:** `out/r35w/a` to `f`, plus `tint`. Check images: `tint_sheet.jpg`, `check4.jpg` (ref | v32 | r35 for p1, p4, c3, p5), `zz_rock.jpg`, `pp_*.jpg`.
- **Tools (`out/r35w/`):**
  - `run.sh` runs `build.sh` (head + params + body -> `fix/pass35.lua`) and then the script.
  - `lrun.sh <lua>` runs a Lua file in the practice studio; `some.sh <tag> <cams>` captures a subset of cameras.
  - `bx.py <tag> cam:x,y ...` prints the box colours (ref / v32 rep / new) and top-half saturation. `pair.py`, `trip.py` and `pick.py` are the pass-34 tools, pointed at v32.
  - `r35_info.json` holds the authored bbox centres.

**Top-half mean HSV saturation:**

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref v32 | 82 | 100 | 102 | 110 | 90 | 117 | 87 | 103 | 94 | 109 | 92 | 81 |
| rep v32 | 87 | 98 | 96 | 114 | 98 | 110 | 82 | 90 | 110 | 105 | 99 | 91 |
| **r35** | **87** | **97** | **99** | **114** | **98** | **109** | **82** | **90** | **106** | **104** | **98** | **91** |

**Change size against the v32 practice frame** (pixels changed by more than 30 levels): p1 8.0 %, p3 7.0 %, p8 6.2 %, p4 5.1 %, p5 4.5 %, c3 4.2 %, p7 4.1 %, c1 4.0 %, c2 2.5 %, p2 2.3 %, p6 1.5 %, c4 0.8 %.

**Checks on the 9s and 9.5s.** I compared ref / v32 / r35 by eye in `check4.jpg` and the contact sheet:
- **p1, p4, p5, c3:** gain the lighter outer arch step and the aged bollards. The crowns sit higher, so more trunk shows, as in the reference.
- **p6, c4:** almost untouched (1.5 % and 0.8 %).
- **p2, p7:** the canal and ledge changes only. The p2 orb, pillars and portal are unchanged.

No feature was lost.

## What I measured / proved
- **Ledge ownership:** the red Neon tint shows it in every target camera (pixel counts above).
- **Arch boxes:** a pick shows that c1 (500,300), c2 (560,200), p1 (150,330) and p3 (150,330) all hit `K_Arch20_stone` (the U arm and crown top), not the shoulder bands.
  - The ref's c1 (500,300) is the dark shoulder band, because the ref U arm is narrower than ours.
  - The ref's U arm is lighter than ours in every view (about 150 lit, 100-134 back-lit).
  - So darkening the stone helps only the two lit boxes and costs the four others.
- **The arch boxes are not in shadow:** sun rays from (20,9,-26), (-26,9,-20), (21,11,26), (21,8,-26) and (19,9,27) are all sunlit. The darkness is face orientation (sun (-0.27,0.85,0.45)), not a cast shadow.
- **Neon and colour:** Neon renders about 1.4-1.8x the colour value here, not 2x on every channel. The patch went from (110,140,55) to (195,247,80), and (86,106,65) gave (137,193,100).
- **Placement:** the ledge was placed by authored bbox centre (0,6.282,0) plus the K_Arch20 frame offset and landed where it was authored, with no tuning.
- **Idempotence:** repeated runs give the same report and **21650**.

## Built (method)
`fix/pass35.lua` is idempotent and runs after pass 34.
- Every touched part keeps its old value in a P35* attribute, and the script restores those first. New pieces go in `Plaza.Pass35` (Arch35, Ground35, East35).
- It merges `Workspace.ae_kit_r35` into `ServerStorage.Kit`, scaled by `K_Scale35_stone`. `fix/build_plaza.lua` IMPORTS also lists r35.

The blocks:
- **ARCH35:** clones the kit ledge at `LEDGE_BB + (K_Arch20.Position - ARCH_BB)`.
- **TREE35:** groups Crown34 parts by corner and finds each crown's lowest third from its Y range. It shrinks those parts and moves the N crowns with `moveTo`.
- **WATER35:** resizes and recolours the niche sheets and moves each one 0.5 toward the plaza axis. Jet parts below y 5.6 are faded.
- **WEST35:** the canal strip and kerbs; sand tiles laid with `groundY` and a Grass predicate; the lagoon banks are stacked flat cylinders (surf, bank, grass) plus Slate rocks.
- **EAST35:** the rock cluster uses sqrt-radius sampling, with size and height falling off from the centre. Each rock gets a thin top slab of a lighter Neon, and some get a red cap.
- **EXTRA35:** the bollards.

Kit: `tools/ae_kit.py` pass-35 section (`_ledge35_curve`, `build_ledge35`, `build_all35`, `r35_info`, `export_r35`).
- **Profile:** an 8-point closed profile in (outward offset d, depth w). It starts at the band front Wb2 and has two risers of 0.5 and two treads of 1.2, rising toward the back, with 0.08 chamfers.
- **Sweep:** along `_arc20(6.4, 7.2, s, 3.0)` with in-plane normals from finite differences, oriented away from the arc centre (cu, cy).
- **Sides:** the two sides are separate sweeps, because joining them would bridge the U opening. Mirrored to 4, 2272 tris.

## Lessons (for the workflow vault)
1. **Pick the review box before choosing the fix.** The "arch outer face" boxes were all on the U arm, and the ref shows a different, narrower piece at the same pixel. A ledge on the shoulder cannot move them, and neither can a colour. The real fix is the arm geometry (width) or a lighter arm.
2. **A global colour change should be scored on every box it touches.** Darkening the arch helped 2 boxes by 13 and hurt 4 by 9-15. I counted both before keeping it, then reverted.
3. **Sweep each side of a symmetric arch separately.** One sweep over the top would have bridged the gap between the U arms.
4. **A brief's colour may be a rendered target, not a part colour.** The 5-wide (60,140,170) sheet at T 0.2 rendered as a bright cyan box. Start at about 0.6x and measure.
5. **Make dark rock read as rock with lit tops on each block, not with a darker colour.** The flat dark mound read as a hole. Many small Neon blocks, each with a lighter top slab and some red caps over a dark base, reads as broken rock at the same mean value.
6. **Metal gold over-brightens in sun.** Switching to SmoothPlastic aged gold (112,95,20) hit the p5 target in two tries.

## Objects built (for 5 Object Recipes)
- **Stepped arch shoulder ledge (kit):**
  - Two 1.2-deep treads with 0.5 risers, rising toward the back, swept along the arch's outer outline (quarter ellipse plus a flared leg).
  - Each side is its own sweep, mirrored to the 4 corners, light grey (150,155,160).
- **Raised, thinned tree crown:** cloud clumps moved up 4 with the lowest third at 0.7x; the trunk is lengthened to match.
- **Niche water glow:** a 3.6 x 5.4 plane (40,95,118) at T 0.3, 0.5 in front of the niche back. The jet parts below the rim are faded to T 0.85 (90,130,150).
- **Blue canal strip:** an 8-wide (55,78,150) slab, 0.2 thick, laid on the walkway, with 0.7-wide gold kerbs (150,128,48).
- **Lagoon bank:** a white surf disc 2 wider than a sand disc (150,138,92), with 6 slate rocks (78,84,60) and 5 flat grass discs (70,105,45) on top.
- **Broken rock outcrop:** a 29-stud Neon base disc (23,23,20) and 22 Neon blocks 3-6.5 studs, tilted up to 0.25 rad. Each has a lighter top slab (60,62,57); 35 % get a red cap (102,38,33).
- **Aged gold bollard:** SmoothPlastic (112,95,20) with no metal, the dome at 0.7x height, and the slab (92,91,72).

## State at the end
- `#workspace.Plaza:GetDescendants()` = **21650** (pass 34: 21534). Workspace holds Camera, Terrain, SpawnLocation and Plaza; `ae_kit_r35` was merged into `ServerStorage.Kit` and removed.
- Nothing was saved or committed, and there was no computer use.
- Changed tracked files: `tools/ae_kit.py` (pass-35 section), `fix/build_plaza.lua` (IMPORTS r35) and `ae_kit.blend` (saved after the export). New files: `fix/pass35.lua`, `kit/own/ae_kit_r35.fbx` and this note.
- `fix_lighting.lua` was not re-run. Technology, post effects and Atmosphere are unchanged, and Haze was not tested.
- **How to rebuild:** on the pass-34 build with `ae_kit_r35` imported, run `sh out/r35w/run.sh`.

## Reference use
The round-32 frames in `out/verify32/` were used for every target. The reference studio was not captured: there was no execute_luau and no position read there, and `ae_reference.blend` was not opened. Only own meshes and Parts were used.

## Next
- **Arch U arm** (c2, p1, p3 boxes): narrow the arms or lift their colour toward the ref's pale arm (about 150 lit). Then add a dark slate shoulder band where c1 (500,300) sits. That needs a K_Arch20 rework (kit).
- **c2 niche:** a sloped cascade sheet from the back shelf to the drum, about 2 wide, in front of the hero stone.
- **W lagoon:** cover the deep water south of the banks, or recolour the foliage there.
- **Items 6, 7, 8, 10.**
