# Fix pass 7: Anime Expeditions spawn plaza (freestyle: slab islands, carved skull Raid, clumps, Story tree, signs)

Builder report for `notes/fix_brief7.md`, answering the round-4 review `notes/verify4_plaza.md` (6.00/10).
- Sheet: `out/cmp_r7.jpg` (reference left, r7 right, 12 cameras). Captures: `out/r7/r7_<cam>.png`.

Rules kept: nothing run in the reference studio, no extra reference captures taken (the 12-picture set was enough);
`ae_reference.blend` not opened; the practice place not saved; nothing committed. `ae_kit.blend` was saved (kit source).
Kit imported once with Import 3D (Insert Using Scene Position + Anchored); arrival confirmed from Luau: **132 MeshParts**
under `workspace.ae_kit_r7`. The r7 FBX has no piece over 2048 studs after the 40.5585 scale, so the measured import scale
came back 40.5585 (not the 16.5 clamp of r5/r6; the first run printed 13.48 because the helper measured off the stale
`K_Medal_pale` size before the move - harmless, the second idempotent run reported 40.5585 and all pieces sit at true size).

## What was built and how (method)
All new pieces are in `tools/ae_kit.py`, section "pass 7" (`build_all7()`, `export_r7()`); 13 new piece families.
- **Slab islands `build_island7`** (3 seeds): a 40-point noisy outline (2/3/5-lobe sines) swept down through 6 rings that
  shrink and jitter (x/z x0.86-1.12, y +-3) to a point at -30, so the plan is about 120 x 58 and the underside is jagged;
  7 hanging rock spikes (5-sided lathes); a 3-ring grass cap with an overhanging lip (R x1.055 at y 0.6, back under to
  -1.4); 4 **clustered vine curtains** of 9 strips (longest in the middle); `ruin_tower` = stacked 10-tall levels, each
  face a wall bay (`rect_like` + `_band_xy`) round a round-arched opening, floor slab per level, the top level broken
  (random faces dropped, uneven tops); a 3-bay broken arcade between the two towers; 3 waterfall sheets 3.5 wide x 70.
  Placed 8x at 1.2-1.6x (145-200 across), 170-275 up, 300-570 out, long side turned to the plaza (`CFrame.lookAt` at
  the origin). Colours: rock (137,148,145) Slate, cap (112,165,62) Grass, ruins (222,220,210), falls Glass 0.3.
- **Clouds `build_cloud7`**: 11 overlapping squashed icospheres with a clipped flat bottom (90 x 30 x 40); 9 placed at
  2.2-3.2x, 105-200 up, 500-820 out, (241,242,236).
- **Carved skull `build_skull7`**: a UV sphere scaled 5 x 6 x 4.8 and deformed per vertex (jaw narrowing below y -1,
  flattened face side, two Gaussian eye sockets pushed 2.9 in, a nose cavity, a brow ridge). Faces whose socket weight
  is above 0.33 are **split into a separate dark mesh** so the sockets read without a texture; two sphere eye cores
  (Neon 255,50,50); a jaw block with 2 rows of 8 teeth; a tapered pedestal prism. Placed 1.5x on a 16 x 30 tower
  block, so about 15 wide and 60 up; a red Neon beam runs down the face to an own "Raid" sign.
- **Raid wings**: `build_rtower7` (round drum + slim upper drum with slit windows + onion dome + needle + ball) at 1.2x
  either side, and `build_arcade7` (4 pointed bays, dark back wall, parapet merlons, 20 long) beyond them, so the
  complex is ~90 wide in p3 (was 32). Walls (150,65,65), trim (92,40,48), red PointLight range 40 brightness 2 at the
  gate, a second red light at the skull, and a slow red haze ParticleEmitter (size 10-22, life 6-9 s) over the forecourt.
- **Clumps `build_clump7`**: a squashed icosphere mound (R 2, 0.38 R tall) bristling with cards: `ClumpG` 80 thin
  upright grass blades, `ClumpB` 55 broad leaf cards. The mound is tinted dark (tint lerped 35% to near-black) and the
  card tips carry the full colour, so the clump reads as a solid mound with bright edges rather than confetti. 8 per
  flight at 0.8-1.25x (3.2-5 across): grass (150,178,75) S/W, red (190,45,40) E, blue (40,90,230) N; 4 more at each stair
  foot on the floor; grass lawns 8.6 x 16.5 either side of the S and W stair tops with 4 clumps each.
- **Stairs**: step bodies (110,118,128), risers (75,85,95), and 16 pale (190,192,190) 0.36-wide nosing strips per flight.
- **Story**: `build_bigtree7` (trunk r 6.5 in 3 tapering tube segments, 15-radius root flare + 6 buttress roots,
  5 twisting branches each ending in a puff, 27 puffs on an 80-wide canopy) plus 2 extra `K_Fluffy` crowns inside the
  canopy to close its centre; `build_crown7` (band, 5 points with balls, jewel) over an own "Story" sign; void (0,9,16);
  plinth (120,100,82); 6 blue palms.
- **Summon**: moved back 15 (z -185); `K_Arcade7` at 2x as the 4-bay facade with gold bands, 2 `K_RTower7` corner towers
  recoloured cream/gold, a dome behind, own "Summon" sign; 6 `build_umbrella7` (8-panel canopy, pole, table) in 6
  colours with stall boxes and 6 blue cypress cones down the avenue.
- **Signs**: `sign()` helper = plate + SurfaceGui TextLabel (Bangers font, own generic words "Raid"/"Story"/"Summon").
- **Ground**: terrace base (116,150,56) and patch greens (132,165,60)/(105,140,60); far water patches dropped past
  r 150 (they read as dark holes in p7); red litter patches smaller (0.5-0.95x).
- `fix/build_plaza.lua` looks for `ae_kit_r7`, asserts `K_Skull7_bone`; `fix/fix_lighting.lua` unchanged (reference
  Ambient/OutdoorAmbient stand, no override). Lighting.Technology not checked (needs the hand check).

## What I measured from the pictures
- `ref_c4_stairs`: the islands span the top 180 px of the frame with a plan aspect of about 3-4:1 and a thickness of
  about 1/4 of their width; the vine curtains hang in 3-5 bunches, not a comb; the towers are about 4 tower-widths tall.
  That set the slab (120 x 58 x 30), the 4 curtains, and 8 x 8 x 40 towers.
- `ref_p3_spawn_e`: the skull is about 1.1 gate-widths across and sits about 2 gate heights above the terrace with the
  beam running the full height of the tower face; the complex spans 440 px (about 3.3x the gate). That set the 15-wide
  skull at y 60, the 22-tall beam, and the wing spacing (towers at z +-22, arcades at +-37).
- `ref_c4_stairs` umbrellas are about 1.4 player-heights across (7 studs) and the stalls sit at the runner edge.
- Sampled after the pass (5x5 means): c4 tread in sun (94,111,125) against the ref's (74,100,117) at the same spot;
  the sunlit nosing/tread edges still sample bright (185-230) where the ref is 60-100, see below.

## Still off (self-check on the sheet)
- **Stairs still read light in c4/c1**: the darker body colour helps on shaded faces, but sunlit tread tops render
  (160-230) because the floor is SmoothPlastic under Brightness 3.5; a Slate/Concrete material or a tread texture is the
  next step, not a darker colour.
- The skull reads as a stone head rather than a carved relief: it needs the socket shadow to be darker/deeper and a
  cracked-stone texture; the pedestal is plain.
- Islands are right in c4/c3 (thin slabs high and far) but their ruins are small from the spawn; the far clouds are
  flat-lit white blobs.
- Raid haze is faint in stills (particles are sparse in a single frame); the Boss Rush tower left of Raid is not built.
- No tile grout on the floor, bollards unchanged, medallion unchanged (items 9/10 not reached in the time box).
- The Story canopy was a hollow ring from the spawn until the 2 filler crowns went in; the puff shell needs interior puffs.

## Lessons (for the workflow vault)
1. **Sample the render before recolouring.** The round-4 stair fix asked for (110,118,128) treads; set exactly that, the
   sunlit treads still sample 160-230 because SmoothPlastic under Brightness 3.5 adds ~70. Match the *rendered* value:
   pick the material (Slate/Concrete) first, then the colour, and sample a 5x5 mean on the capture.
2. **Split "shadow" faces into their own mesh by a weight.** Deforming a sphere into sockets is cheap, but a flat-lit
   stylised render loses the depth; exporting the socket faces as a separate dark-coloured mesh (threshold on the
   deform weight) gives the eyes without a texture.
3. **Clumps need a dark mound and bright tips.** Tinting the whole clump one colour gives confetti; mound 35% to
   black, cards full colour, 3-5 across, placed 8 per flight, reads as the reference's mounds.
4. **Puff-shell canopies go hollow from below/side.** A canopy of puffs on a sphere surface is see-through at the
   centre from the spawn height; add interior puffs or a filler crown.
5. **Face big landmarks with `CFrame.lookAt`, not fixed yaws.** Slab islands and clouds placed round the plaza need
   their long side toward the centre; one `lookAt(pos, Vector3.new(0, y, 0))` per instance does it.
6. **One wall-bay helper covers towers, arcades and facades.** `rect_like(inner)` (same point count as the arch
   outline) plus `_band_xy` makes any opening in a rectangular wall; stack bays for towers, row them for arcades, scale
   2x for a facade.
7. **Import scale depends on the kit's largest piece.** r5/r6 clamped to 16.5 because the hero piece exceeded 2048
   studs after x40.5585; r7's largest piece is smaller so the scale is the plain 40.5585. Keep measuring it from a known
   piece; and run the placement script twice after an import (the first run measures before the move).
8. **Import 3D recipe worked with single computer-use calls**: AppActivate pid, click Import, click the name box, type
   the path (clipboard fast path), Open, tick Scene Position + Anchored, zoom to confirm, Import; confirm by counting
   MeshParts from Luau (132).

## Files
- `tools/ae_kit.py` pass-7 section: `rect_like`, `bay`, `ruin_tower`, `build_island7`, `build_cloud7`, `build_skull7`,
  `build_rtower7`, `build_arcade7`, `build_clump7`, `build_bigtree7`, `build_crown7`, `build_umbrella7`, `build_all7`,
  `R7_PREFIXES`, `export_r7`.
- `ae_kit.blend` (saved), `kit/own/ae_kit_r7.fbx` (132 meshes, largest `K_Hero_goldLan` 18.7k tris).
- `fix/build_plaza.lua` (r7 kit, tokens, clumps, nosing, lawns, signs, Raid/Story/Summon rebuilt, slab islands, clouds).
- `out/r7/r7_*.png`, `out/cmp_r7.jpg`.
