# Fix pass 15: Anime Expeditions spawn plaza (clumps without facets, Raid balance, islands out of the spawn views)

Builder report for `notes/fix_brief15.md`, answering the round-12 review `notes/verify12_plaza.md` (7.33/10). As the brief asked,
this pass works only on the reviewer's top three items, and does them thoroughly.

**Captures:**
- Final set: `out/r15/r15_<cam>.png`, 12 cameras, 1452x793 (`capture_set2.py`, two frames per camera, the second kept).
  p3, p5, c2 and c3 were re-shot after the last haze change.
- Working frames are in `out/r15w/`:
  - `t1..t7_*`: tries for the islands and the Raid.
  - `t6_*`: close-ups after the swap (tree front/back, skull, gold).
  - `blender_*`: Blender test renders.
  - `skull_cmp.png`: the p3 skull, practice next to the reference.
- Reference study (screen_capture only): `ref15_tree_close`, `ref15_skull_close`, `ref15_skull_mid`, `ref15_gold_back`.
- Colours are 5x5 means (`out/r14w/samp.py`), compared with `out/verify12/v12_<cam>_ref.jpg`.

**Rules kept:**
- Pictures only: the reference studio was only captured, and `ae_reference.blend` was not opened.
- Own geometry and own textures only (the pass-14 leaf textures are reused).
- No computer use. The practice place is not saved and nothing is committed. `ae_kit.blend` is saved.

**How to rebuild** (on a built plaza, after importing `kit/own/ae_kit_r15.fbx` as `ae_kit_r15`):
1. `fix/pass15.lua`: merges the kit into Kit and does the Raid and island work.
2. `fix/pass13.lua`: the tree swap. It now uses generation 15 when `K_Soft15R_leaf` is in Kit.
3. `fix/pass14.lua`: the Story canopy and horizon ring, now built from `K_Soft15K`.
4. `fix/pass15.lua` again: pass 14 resets the facade and haze, so they need re-applying.

`fix/build_plaza.lua` now carries the current pass-13, pass-14 and pass-15 blocks in that order, and has r15 in `IMPORTS`.
Wrap a file for `mcpcli.py` with `python cmd/runlua.py fix/<f>.lua <studio>`.

## 1. Clump interiors (`tools/ae_kit.py` pass-15 section, `ae_kit_r15.fbx`)

**What the reference foliage is** (new close capture `ref15_tree_close.png`):
- A loose burst of small flat leaf sprays at every angle.
- See-through at the edge, with no shell plane and no core card at all.

The round-12 "facets" were the pass-14 crossed filler cards (2r across) and the level card, which show as 3-5 stud planes
with a crease where they cross.

**What changed:**
- **Removed:** every filler and level card. There is no `leafPad` mesh any more.
- **No large cards:** the biggest card is 2.2 studs in the kit, and the trees are placed at scale 1.0-1.6.
- **Cards per clump:** `clump15` fills each clump with 120-200 cards (`card15`), 1.3-2.2 studs long and 0.65-0.85 of that wide.
  - Each card faces a random direction and has a random roll, so neighbouring cards never share a plane.
  - Positions run from 0.35r to r, biased toward the shell (`0.35 + 0.65·u^0.35`).
  - Cards inside 0.62r go to the darker `_leaf` mesh (tinted 225), so the core reads dark. Outer cards go to `_leafRim`.
  - Outer cards get 35% of the radial direction blended into their normal, so the rim is never seen edge-on
    (pass-14 lesson 4).
- **Normals:** `soft_normal14(k 0.9, up 0.12)` points them out of the clump centre. `Leaves15` keeps each side's normal in its
  own hemisphere, with a floor of 0.25 (0.35 in pass 14). The Blender check found 0 of 47,496 leaf loop normals facing away.
- **1 segment per card** (4 triangles with the back twin).
- **First try was too sparse:** cards of 1.1-2.0 studs, 0.55-0.7 as wide, showing a lot of sky. Widening the cards and
  pushing them out to the shell fixed that without adding triangles.

**Triangles:**

| tree | tris |
|---|---|
| R (round) | 4796 |
| C (cloud, arch trees) | 4128 |
| U (umbrella) | 4952 |
| W (wisteria, racemes now chains of 2-3 small cards) | 4228 |
| Y (cypress, 260 cards, no crossed pads) | 1132 |
| K (loose clump) | 800 |
| B (bush) | 480 |
| G (gold canopy) | 5020 |

**Gold:**
- `build_gold15` is one continuous canopy: 11 overlapping clumps (r 5-6.5) on an uneven ellipsoid, about 30 x 23 x 17.
- It sits on a bent trunk that forks into limbs at 0.62 of the base height.
- It is placed once at (-68, -198), scale 1.15, replacing the 2 umbrella trees and 6 balls of the old "gold mass" (`pass13.lua`).

**Tested before swapping:**
- Blender renders of one clump (`blender_k15_front/back/below`) and one arch tree (`blender_c15b_front/back`), next to r14,
  with backface culling on.
- r14 shows its X of filler planes from both sides. r15 shows none, from the front or from behind.

**Swap:**
- Same placement and seeds: `gen()` maps Soft13 to Soft15, and the palm stays `K_Soft13P`.
- Result: 69 trees and 880 clumps on r15, plus the Story canopy and horizon ring on `K_Soft15K`.

**Measured:**

| sample | round 12 | now | reference |
|---|---|---|---|
| p1 blue, shade | (23,67,184) | (26,86,185), (34,85,199) | (19,66,200) |
| p1 blue, lit | (77,144,222) | (42,109,202) | (60,127,228) |
| p1 gold, shade | olive | (167,134,50) | target (170,130,55) |
| p1 gold, lit | — | (216,189,81) | (207,168,74) |

- Close up (`t6_tree_close.png`, `t6_tree_back.png`): fine blue speckle with no planes, from both sides.

## 2. Raid balance (`fix/pass15.lua`)

**Skull tower:**
- New kit piece `K_Skull15`: the pass-8 head and jaw WITHOUT the stepped pedestal (the "2-tier pink toy plinth").
- It stands on a separate `pillar` mesh:
  - an 8-sided tapered shaft, 8.6 to 12.4 across, with 4 carved bands;
  - 4 diagonal ribs that hug the shaft and flare out at the foot;
  - two channel lips for the red beam, and a collar under the jaw.
- The first ribs stood 0.6 off the shaft and read as a birdcage.
- Placement: in the old skull's kit frame (scale 2.88). The old skull is hidden (attribute `P15Hidden`).
- Colours:
  - bone (150,80,72) Slate;
  - sockets (60,15,20);
  - pillar in facade colour.
- Light: a PointLight (255,90,80), range 20, brightness 0.7, above and in front of the face. At 1.4 the skull sampled
  (201,58,59). The pass-14 skull light is off.

**Facade:**
- RaidFacade and Gable parts: (95,40,45) Brick, so the brick courses show.
- Buttress, pinnacle, cap and pins: (130,60,60).
- The kit meshes K_Gothic, K_Spire, K_RTower7 and K_Arcade7 have their stone parts recoloured (95,40,45), dark stone
  (60,18,24) and domes (130,60,60).

**Uplights:**
- 3 SpotLights (255,70,60) at the stair foot (x 134, z -22/0/22), aimed at (176,70), range 60, angle 55, brightness 0.4.
- Brightness tries (facade foot, sampled):

| uplight brightness | facade foot |
|---|---|
| 2.2 | (178,11,24) |
| 0.9 | (170,12,21) |
| 0.4, low haze puffs moved behind the flanks, pass-13 foot lights at 0.15 | (63,19,32) |

- With the uplights at 0.9 the foot was still pure red: the red came from the low haze puffs and the pass-13 foot lights,
  not mainly from the uplights.
- Reference facade foot: (60,52,46) / (76,44,61).

**Haze:**
- `RaidSmoke15` uses the pass-14 v3 emitter, now 12 attachments in a band from the flanks (z ±46) to the skull's jaw,
  all behind or beside the facade.
- The first band reached y 118 and turned the sky round the skull pink-violet (158,95,134). Lowered, the sky above the skull
  is blue (53,188,235), as in the reference. `RaidSmoke14` is off.

**Island above Raid:** moved 45 out, 35 up and 45 to the side (+Z). From p3 it now sits to the right of the skull.

**Result in p3:** the skull is brick-rose with dark sockets, on a carved tower. The temple is mid-value brick washed in red.

## 3. Islands out of the player-height views

Every moved piece stores the delta it has received (attribute `P15D`). Re-running the file moves a piece by
(wanted − applied), so the moves can be retuned without drift. Direction and region come from the island's ORIGINAL centre.

| islands | move | why |
|---|---|---|
| N / NE / NW (z < -100) | 60 out, **35 down** | 60 out alone (t1) still filled c4's top corners down to y 150. In the reference c4 the islands are far and low (tops at y 110-130), with towers and sky above. |
| S / SW / SE (z > 100) | 90 out, 10 up | At 50 out / 45 up (t2) the SW island still filled p6's top centre at about 31° up. Farther and lower puts it on the skyline at about 21°. |
| E (over Raid) | 45 out, 35 up, 45 to the side | See item 2. |

- **What moves with an island:**
  - everything in `Islands` and `IslDress12`;
  - stashed island balls;
  - island clumps in `Trees13`;
  - pass-14 towers and aqueduct.
- **Height filter:** a piece moves only if it is within the island's plan radius + 25 AND at most 45 below the island centre.
  The first version also caught the far-N horizon clumps (y ~55, under the N islands in plan) and dropped them 35. Fixed and
  rebuilt.
- `pass13.lua` copies `P15Isl`/`P15D` onto clumps rebuilt from moved balls, and pass-14 towers count as already in place.
  Re-runs move 0 pieces.
- **Falls:** 3.5 wide, (200,235,255), T 0.3. The lip is 4.2 wide. The mist emitter is on: (235,248,255), size 5-9, rate 3.
- **Grass spill:** 10 green `K_Soft15K` clumps per island (100 in all), hung 3-6 studs below the rim on 0.43 of the island
  footprint.
- **Result:**
  - c4, p1: sky across the top 100 px with towers. The islands sit at y about 100-230 (the reference has them at y 110-280).
  - p6: sky at the top centre; the SW island is at y 100-180.
  - c3: islands with towers, sky between them.

## Remaining issues seen on the final set
- p7: the S island now casts a large shadow on the S foreground lawn.
- A few pale flecks remain at the top of the arch tree from behind (`t6_tree_back.png`): sky seen between cards, not glints.
- The skull's eyes are still solid red Neon balls. The reference has red-rimmed hollow sockets.
- The haze is a band about the facade's width (x 560-890 in p3), not yet the full "wrap from the stairs".
- Not attempted (brief items 4-10): bollards, medallion, W lagoon, wings and pods, litter, stair grass, N avenue, S side.

## Lessons (for the workflow vault)
1. **A foliage clump must not contain any plane bigger than its leaf cards.** Large filler cards that "fill the volume" become
   the dominant read at mid range (crossed planes with a crease). Fill the volume with many small cards instead (120-200 per
   clump), and spend the triangle budget on count, not size.
2. **Random orientation kills facets; a radial bias keeps the rim readable.** Fully random cards are sometimes edge-on at the
   silhouette. Blending about 35% of the radial direction into the outer cards' normals keeps them visible without making
   neighbours coplanar.
3. **Fix density with card area and shell bias before adding cards.** Making cards 30% wider and moving them toward the shell
   closed the see-through gaps at the same triangle count.
4. **Moving a floating island OUT lowers it in the view; moving it UP raises it.** To clear a camera's top band, compute the
   elevation (atan(height above eye / distance)) against the camera's half-FOV. Pick "farther and lower" (skyline) or "higher"
   (out of frame) on purpose: the first S move (out and up) only slid the island down into the frame.
5. **Store applied deltas on moved instances (an attribute), not just a "moved" flag.** Then a move can be retuned and re-run
   without drift. Derive each island's direction from its ORIGINAL centre so a sideways move does not feed back into itself.
6. **Filter moved sets by height as well as plan distance.** Plan-distance alone caught far-horizon trees lying under an
   island in plan.
7. **Coloured light: find the actual source before turning things down.** The pure-red facade foot (G≈11) barely changed when
   the uplights went from 2.2 to 0.9. The low haze puffs in front of the facade and the old foot lights were the real source.
   Sample one pixel after each single change.
8. **Swap a merged mesh part by putting a new kit piece in the old one's kit frame.** When a kit mesh bakes in a part you need
   to drop (the skull's pedestal), rebuild the piece without it and place it with world = oldPart.CFrame · oldKitRot⁻¹ ·
   (kitPos · s), with s from the old part's size. Hide the old piece; don't destroy it.

## Objects built (for 5 Object Recipes)

### Facet-free leaf clump (`tools/ae_kit.py`: `Leaves15`, `rand_unit`, `card15`, `clump15`)
- `card15(LV, p, n, L, W, c)`: a flat quad centred at p with face normal n and a random roll. V runs along L (the spray
  texture's stem). It goes through `Leaves15.quad`: a back twin 0.02 behind, and per-side normals clamped to n·gn >= 0.25.
- `clump15(r, n=150, flat, Lc=(1.3,2.2), core=0.62)`: for each of n cards:
  - direction = random unit vector, Y squashed by flat; radius t = 0.35 + 0.65·u^0.35;
  - L in Lc, W = 0.65-0.85 L;
  - outer cards (t > core): random normal flipped outward, then blended 0.65 random + 0.35 radial;
  - inner cards go to the `_leaf` mesh, outer cards to `_leafRim`.
- Trees (`build_*15`) are the pass-14 skeletons with `clump15` and per-tree n: R 158, C 190, U 145, W 150.
- Cypress: 260 cards in a tapering column.

### Gold cloud canopy (`build_gold15`)
- 11 clumps: one top centre at base + 0.68 Hc, and 10 round an ellipse of 0.5-0.8 × W/2 (x 0.82, z 0.6).
  Every 3rd clump is lifted by Hc·0.25.
- Clump r 5-6.5, n 106, flat 0.8, cards 1.4-2.2.
- Trunk: a two-bend trunk to a fork at 0.62·base, then limbs to every 2nd clump and to the top.

### Skull tower (`build_skull15`)
- Head and jaw: the pass-8 sculpt minus the pedestal (split into bone/dark/eye meshes).
- Pillar:
  - Shaft: an 8-segment flat lathe from y -26 to -6, radius 6.2 at the foot to 4.3 under the jaw, with 4 stepped bands (+0.4).
    Z is scaled 1.12 and the shaft is turned 22.5°.
  - 4 ribs: tubes (r 0.95) on the diagonals through r 4.1/4.6/5.2/6.9 at y -7/-13/-19.5/-25.8.
  - 2 channel lips and a collar.

### Red uplight (Studio)
- An invisible 0.6 part at the stair foot, turned with `CFrame.lookAt(base, aim) * Angles(-90°, 0, 0)`, so its Top face
  points at the aim.
- A SpotLight on Face Top: (255,70,60), range 60, angle 55, brightness 0.4.

### Island rim spill (Studio)
- 10 `K_Soft15K` clumps per island in the grey texture tinted green (70,150,55) / (120,195,70).
- Each at angle i/10·2π ± 0.2, on 0.43 of the bounding box, 3-6 below the top surface (centre + 0.32·height), scale 0.9-1.3.

## Files
- `tools/ae_kit.py`: pass-15 section (`build_all15`, `export_r15`, `build_gold15`, `build_skull15`). `ae_kit.blend` is saved;
  its test scene `T15` holds only a camera and a sun.
- `kit/own/ae_kit_r15.fbx`: 27 meshes, including the 10-stud scale cube. Imported.
- `fix/pass15.lua` (new).
- `fix/pass13.lua`: generation 15, the gold canopy, the `P15Isl`/`P15D` copy.
- `fix/pass14.lua`: Story canopy and horizon ring now use `K_Soft15K`.
- `fix/build_plaza.lua`: r15 in `IMPORTS`; the pass-13, 14 and 15 blocks are synced.
- `out/r15/`, `out/r15w/`.
