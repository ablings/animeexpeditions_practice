# Fix pass 5: Anime Expeditions spawn plaza (freestyle, quarter-and-mirror + foliage kit)

This is the builder report for `notes/fix_brief5.md`. It answers the round-2 review `notes/verify2_plaza.md` (4.33/10).
- Sheet: `out/cmp_r5.jpg` (reference on the left, r5 on the right, 12 cameras).
- Captures: `out/r5/r5_<cam>.png`.

Rules kept:
- Nothing was run in the reference studio. No extra reference captures were taken: the 12-picture set was enough.
- `ae_reference.blend` was not opened.
- The practice place was not saved and nothing was committed.
- `ae_kit.blend` was saved because it holds the kit source.
- The kit went in with Import 3D (Insert Using Scene Position + Anchored), twice: the first import, then a re-import after thinning the medallion blades.

## What was built and how (method)
All pass-5 kit pieces are new functions in `tools/ae_kit.py`, section "pass 5" (`build_all5()`, `export_r5()`):
- they are exported to `kit/own/ae_kit_r5.fbx`: 58 meshes;
- the export uses the r3/r4 call: use_selection, MESH, apply_unit_scale, FACE smoothing, use_mesh_modifiers, Y up;
- the import arrived at 16.516 instead of 40.5585 (the 124-stud hero triggers the 2048 clamp), and `build_plaza.lua` measures this from the 40-stud dais.

### Hero piece (one NE corner authored in the diagonal frame `P(u, y, w)`, mirrored x4, one mesh per material)
- **Gate:** the outer arch is 20 wide x 10 tall and the vault is **6.5 deep** (w 33 to 39.5). It is an archivolt of three bands, each with its own mesh and colour:
  - a pale outer band;
  - a recessed `rib` band, inset 0.6 and stepped back 0.7;
  - a `darkStone` inner rib, inset another 0.6 and stepped back 1.4.
  The opening is 13 wide. A gold outline runs round the outer and first inner edge at the front, and round the back.
- **Crest:** one **squared U** (`extrude_uy`) with 3.2-wide pillars, a 2-wide slot and its top at **13.5**. Its bottom bar sits in the band crown (band top 10, so the horns rise 3.5 above it). One continuous gold tube runs round the U, front and back.
- **Vault interior:** a dark back wall at w 40.2 with a gold shelf. A foam cascade (a sloping slab plus a splash cone, Neon at 0.45 transparency) runs from the shelf down into the upper basin.
- **Basin:** moved out from w 27.5 to **31.6**, so its back rim sits under the arch opening. It keeps the two tiers, now with a dark band on the outer drum and a **grille of 16 gold bars** round the upper tier.
- **Corner block:** the notch is deepened to w 41 for the vault. The block top faces at y 6 are split into a separate `K_Hero_turf` mesh (Grass), so the bare grey squares are gone.
- **Pool:** pulled in from w 56.6 to 55 (centre about ±38.9) and narrowed to r 14.5.
- **Lanterns:** the pass-4 lantern is scaled **1.4x** about its base. The pedestal becomes a 7-tall drum, the dome is about 9.4 across and the spike tip reaches about **31.5**. The domes now sit clearly above the crest in c1, c3 and p1.
- **Mesh budget:** the gold is split into `gold` (12.0k triangles), `goldBas` (basin, 9.2k) and `goldLan` (lanterns, 7.5k). The colour lookup in Lua treats any `gold*` token as gold.

### Stairs (north flight authored, rotated x4)
- Each step's riser and side faces are split from the treads by face normal (`split_by_normal`) into `K_Stairs_riser`, which is darker.
- A 3-wide navy centre panel sits on the 7-wide blue runner.
- The Y-chevron is a double line: two parallel 0.12 gold tubes.
- The kerbs are white and stand proud (0.8 wide, top about 0.25 above the nosing line), with two gold rails each.

### Floor and medallion
- 8 thinner hooked blades (base width about 1.1 instead of 2.5; the r 2.2-8.0 sweep is unchanged), dark.
- The gold disc shrinks to r 1.6, with a dark centre ring and a dark ring round it.
- A **raised gold ring** at r 8.5-9.5, 0.4 proud.
- A **dark slate band** at r 9.4-12.5 with a gold edge. This gives the dark and gold foreground arc of the reference in p1-p6.
- The diamond bands are raised to 0.1, so they no longer z-fight with the textured floor.

### Bollard
- A stepped square plinth, 3.5 across and 0.4 tall.
- A tapering white pedestal, 2.5 square at the base.
- A gold dome cap, 2 across, with a dark slot.
- Four bollards stand on the diagonals at (±9.6, ±9.6), facing the gates. The 8 stair-foot bollards are gone, so c2 is clear.

### Foliage kit (priority 1): all leaf geometry is double-sided leaf cards
- `card()` makes one spiky card with a drooping midrib and a pointed tip. Each card is split base/tip into two meshes:
  - `leaf` (the tint) and `leafRim` (the tint lightened 25-35%);
  - this gives every canopy a light rim with no texture.
- Every face is duplicated reversed and pushed back 0.03 (`ds_quad`), because Roblox culls back faces.
- **Card trees** (`build_cardtree`): a curved trunk with a root flare and branches. The canopy is 7-11 clusters on an ellipsoid; each cluster is a small dark icosphere core with 15-18 cards pointing outward.
  - Variants: TreeA (20 tall), TreeB (23), TreeC (17), and a GiantTree (64 tall, canopy about 60 across, trunk 11 across).
  - Each variant is 1.5-7k triangles.
- **Palms** (`build_palm5`): a curved trunk of about 25 with 13 ring bulges and a boss. The crown has 9-10 arched fronds of 8.5-9.5; each frond carries 14 pairs of leaflet cards plus a rachis strip. There are 2 variants (A bends one way, B the other).
- **Cypress cone:** 12 rings of upward cards round a core cone, 3.4 x 12.
- **Fern clump:** 13 radiating drooping cards plus 5 upright ones, about 3.4 across x 0.7 tall.
- **Crystal cluster:** 3 hexagonal crystals, Glass in Lua.

### Skyline (priority 2)
- **Floating island** (`build_island5`), about 72 across, made of:
  - a faceted rock underside 30 deep (a lathe with per-vertex jitter);
  - a grass cap;
  - 3 ruin towers with broken crenels;
  - a domed shrine;
  - 2 waterfalls 55 long with lips.
  It is placed 10 times at scale 1.0-1.6 (72-115 across), 240-330 out and 80-150 up, each with a card tree and on half of them a palm.
- **Sky:**
  - `tex/make_ae_tex5.py` makes an own skybox, uploaded as `ae_sky5_*`. The 4 side faces are cut from **one panorama noise**, so the seams match; the cloud band sits in the lower third and fades out before the top edge; the up face has no clouds.
  - This removed the c3 artefact. **Cause:** the pass-4 up face had clouds right to its edges while the side faces were plain at the top, so each cube corner showed a cloud patch cut off at the seam: the "diamond".
  - The haze still eats most of that cloud band, so `fix_lighting.lua` also adds Roblox's built-in `Terrain.Clouds` (Cover 0.55, Density 0.55). Cumulus now show in c3 and c4.

### Placement (`fix/build_plaza.lua`, rewritten for r5, idempotent)
- **Kit:** the script looks for `ae_kit_r5`, measures the import scale from the dais and moves the kit to `ServerStorage.Kit`.
- **Colours and materials:** set per name token (stone, rib, darkStone, gold\*, blue, glass, water, foam, turf, pale, slate, white, navy, riser, rock, grass, silver), with group overrides for the stairs, medallion, crystal and island. The values sit about 1/1.5 under the review's rendered targets:

  | element | part colour | material and notes |
  |---|---|---|
  | gold | (150,112,30) | reflectance 0 |
  | runner | (40,68,140) | navy inset (28,38,95) |
  | water | (80,140,155) | Glass, transparency 0.25 |
  | gate stone | (98,102,112) | rib (52,56,68), vault (34,38,48) |
  | stair treads | (135,137,139) | risers (84,90,100) |
  | floor texture tint | (128,132,136) | |
  | glass cores | (45,120,175) | Neon, transparency 0.2 |

- **Ground:** the slabs are now 1700 wide and reach 850 out; the water plane is 4000 wide, so the baseplate edge is gone. The terrace is zoned:
  - N: green;
  - E: red Ground (118,50,34), with slate gravel paths;
  - W: blue-tinted grass (55,95,140), with ponds;
  - S: olive grass, with sand patches.
- **Arms:** the E, W and S arms are shortened to 22, so they end about 82 out with the tip. The N avenue is 104 long and runs to the Summon hall.
- **Planting:**
  - a blue TreeC on each pool rock, plus 2 blue crystal clusters per pool beside the lanterns;
  - per corner quadrant: 2 palms (fronds blue W and N, dark red E, green S), 4 card trees in the zone colours and 2 blue cypresses;
  - the N avenue has 6 blue palms per side at 12-stud spacing, with cypresses between them;
  - an outer ring of 40 trees and palms, 105-185 out;
  - 105 fern clumps tinted by zone (coral E, blue W and N, green S): on the step edges outside the runner, at the basin feet (6 per basin), and as a carpet on the terrace;
  - plus grass tufts.
- **Landmarks** (still blockouts, re-proportioned):
  - **Summon:** moved to z -170 (42 further down the avenue). It now has a colonnade with arches, a cornice, an attic, a gold dome and two towers.
  - **Expeditions:** a teal arched portal 15 tall with pale-teal columns and a Glass field (no cyan neon), 2 crystal braziers, and a ring of 10 floating rock slabs above it.
  - **Raid:**
    - weathered red stone, with a gothic arch on piers and a dark doorway;
    - a skull tower whose skull top is at about 46, 40 above the terrace, with dark eye sockets and a jaw;
    - a red blade, 2 spires with dark tips, and 2 red palms.
  - **Story:**
    - the own silver torus ring (12 across, 2 thick) with a gold crown and band, over a black void with a faint purple glow;
    - the GiantTree 16 studs behind it, about 70 above the terrace;
    - 2 blue palms.
- **Lighting** (`fix/fix_lighting.lua`): the reference settings are unchanged, plus a pass-5 block:
  - Ambient and OutdoorAmbient (110,115,130), ShadowSoftness 0.3;
  - ColorCorrection Contrast 0.22, Saturation 0.2, Tint (255,245,230);
  - Bloom 0.5 / 1.1;
  - Atmosphere Density 0.3, Haze 1.0, Color (200,220,255);
  - the new sky ids and Terrain Clouds.
  - **Lighting.Technology was not checked by hand. Please recheck it.**

## What I measured from the pictures
- **`ref_c1_wall` is the gate elevation.** The camera is at (12,6,-12), so it stands 17 studs out along the diagonal and the arch front is about 16 away, giving about 35 px/stud.
  - Crest top at y 155 px: about 6.9 above eye height, so about **13.5**.
  - Outer band edges at x 325-965: about **18-20 wide**.
  - Opening edges at x 410-880: about **13 wide**.
  - Arch crown inside at y 370: about 7 tall.
  - Crest: pillars at x 505-610 and 680-785, so about **3 wide each**, with a 2-wide slot. The slot bottom is at about y 285, so about 10.5-11.
  - Basin rim: 465 px at about 14 studs, so r about 5.7, which is the same as pass 4. The basin was too close, not too big, so I moved it rather than shrinking it.
- **`ref_c1`, archivolt:** the reference arch reads as concentric stepped bands receding inward, and the basin's upper tier carries vertical gold bars.
- **Pool centres:** the review's p8 numbers (±43 against ±40) set the pool pull-in. The lantern tip target of 30-32 came from the review's c1 and c3 dome positions.
- **Medallion:** in the top view the reference blades are thin dark spikes. The p8 crop comparison after the change matches their width.

## Result (self-check on the sheet, not a review score)
- **Better:**
  - **Foliage:** every frame top now has palms, spiky card trees and cypresses, the N avenue is lined, and p7 and p8 are no longer a lawn. The zones read: blue W, red E, green and gold S.
  - **Gate:** c1 and c3 now show the squat U crest under fully visible lantern domes, a deep dark vault with stepped ribs, and the basin tucked under the arch with its bar grille.
  - **Colour:** the gold is deeper, the runner is royal with a navy inset, the water is less cyan, and the stone is mid grey with dark ribs.
  - **Skyline:** islands with ruins and waterfalls fill the upper third of p1, p2, c3 and c4; there are clouds; the c3 artefact and the baseplate edge are gone.
  - **Medallion:** it has the dark and gold foreground arc, and the bollards are on the diagonals.
- **Still off:**
  - **Foliage density:** still below the reference near the plaza, especially the stair edges and around the gates, where the reference has big blue canopies right behind the crest.
  - **Islands:** they read as dark saucers from below (haze tints the shaded underside navy).
  - **Island waterfalls:** too opaque and white.
  - **Landmarks:** still part blockouts; the Raid tower and the Expeditions portal are small in p2 and p3.
  - **Brightness:** p6 (101) and c4 (88) are darker than the reference (125 and 153), mostly from the large dark palm trunks and fronds in shade. The other cameras are within about 15.
  - **Vault interior:** the foam cascade still reads a little like a pale slab in p1-p4.
  - **Gate outer faces:** they are vertical; the reference arch has a bevelled, sloping outer facet.

## Lessons (for the workflow vault)
1. **Build foliage from double-sided leaf cards, not blobs.** A spiky card (a drooping midrib, 4 segments, a pointed tip) instanced by the dozen round small dark cores reads as stylised foliage at any distance and costs only 1-3k triangles per tree.
   - Duplicate each face reversed and offset by about 0.03, because Roblox culls back faces.
   - Split each card base/tip into two meshes (`leaf`, `leafRim`), so one tint plus a lightened tint gives the light-rimmed canopy look with no textures.
2. **One generator with seeds and parameters gives the whole palette.** The same `build_cardtree(H, R, clusters, cards, cl)` produced three tree variants and the 64-stud giant. Colour is set at placement (a tint per zone), so the kit needs no colour variants.
3. **Skybox seams:**
   - Build the 4 side faces from one wrapping panorama.
   - Keep the up face free of anything that touches its edges, or every cube corner shows a cut-off patch: the c3 "diamond" artefact.
   - Atmosphere haze above about 1 hides a horizon cloud band. Roblox's built-in `Terrain.Clouds` is a cheap way to get cumulus that the haze cannot hide.
4. **Split faces by normal after merging** to get a second colour without new geometry: stair risers against treads, and block tops as turf. This is often the cheapest fix for "flat, one-colour" review notes.
5. **Fix proportion from one elevation picture with a pixel scale.** At about 565/d px per stud (1284 px frame), c1 alone gave the crest height, the opening, the band width, the slot and the basin radius. It also showed the basin was the right size but in the wrong place, which a review note ("rim spans 700 px") does not tell you.
6. **Keep the triangle budget per material in mind when adding detail.** The bars, rims and outlines pushed the hero gold past 20k. Split the material by sub-part (`gold`, `goldBas`, `goldLan`) and match colours by token prefix in Lua.
7. **Measure value after each colour pass, but expect foliage to dominate the medians.** Once trees fill the frame, dark shaded fronds and trunks pull the median down far more than the stone colours do. Tune the leaf tints (and wood) brighter than the review RGB (about 1.2-1.3x).
8. **Import 3D recipe:** it worked twice. The **batched** computer-use calls were interrupted every time ("user interrupt"), but **single** click, type and zoom calls went through.
   - Malwarebytes stole focus once: wait 4 s, AppActivate the PID, retry.
   - Confirm arrival from Luau by polling for 58 MeshParts under `workspace.ae_kit_r5`, not by watching the screen.
   - Re-importing the same name works because `build_plaza.lua` replaces `ServerStorage.Kit` whenever `workspace.ae_kit_r5` exists.
9. **Leave the import-scale log alone after the first run.** The script prints the default 40.5585 when the kit is already in ServerStorage; the measured 16.516 only appears on the run right after an import.

## Files
- `tools/ae_kit.py` (pass-5 section: `ds_quad`, `card`, `build_cardtree`, `build_palm5`, `build_cypress5`, `build_fern5`, `build_crystal5`,
  `build_island5`, `build_ring5`, `split_by_normal`, `extrude_uy`, `lantern5`, `build_hero5`, `build_stairs5`, `build_floor5`, `build_bollard5`,
  `build_all5`, `export_r5`), `ae_kit.blend` (saved), `kit/own/ae_kit_r5.fbx`
- `fix/build_plaza.lua` (rewritten for r5), `fix/fix_lighting.lua` (sky v2 ids, the pass-5 contrast/haze block, Terrain clouds)
- `tex/make_ae_tex5.py`, `tex/sky/ae_sky5_*.png`
- `out/r5/r5_*.png`, `out/cmp_r5.jpg`
