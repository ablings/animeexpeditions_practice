# Fix pass 13: Anime Expeditions spawn plaza (soft leaf-card foliage kit, Raid haze, lawn value, wisteria/gold masses)

Builder report for `notes/fix_brief13.md`, answering the round-10 review `notes/verify10_plaza.md` (7.17/10).

**Captures:**
- Final set: `out/r13/r13_<cam>.png`, 12 cameras, 1452x793 (`capture_set2.py`, two frames per camera, the second kept).
- Working frames: `out/r13w/t0..t4_*` (before/after tests), `out/r13w/blender_kit13*.png` (Blender check renders),
  `out/r13w/tex_preview.png` (the two leaf textures on green).
- Reference study (screen_capture only, no code in the reference studio): `out/r13w/ref_bluetree_wide.jpg`,
  `ref_bluetree_close.jpg`, `ref_avenue_gold_cypress.jpg`.
- Colours are 5x5 means against the round-10 reference frames `out/verify10/v10_<cam>_ref.jpg`.

**Rules kept:**
- Pictures only: the reference was only captured, from three extra cameras close to its trees. `ae_reference.blend` was not opened.
- No computer use. The practice place is not saved and nothing is committed. `ae_kit.blend` is saved (pass-13 pieces).
- Own textures only: the two leaf images are painted by `tex/make_ae_tex13.py` (PIL polygons), nothing taken from the reference.

**How to rebuild:** run `fix/build_plaza.lua` (it merges `ae_kit_r13` if it is in Workspace, measured from `K_Scale13_stone`;
the import scale came out 72.2), then `fix/fix_lighting.lua`. The pass-13 block sits at the end of `build_plaza.lua`; the
same code is `fix/pass13.lua`, which re-runs alone on top of a built plaza (idempotent: swapped-out trees wait in
`ServerStorage.Pass13Old` and are put back before each swap). `cmd/runlua.py <file.lua> <studio>` wraps a Lua file as
`execute_luau` args for `mcpcli.py`.

## What changed, per priority

### 1. Soft leaf-clump foliage kit (`tools/ae_kit.py` pass-13 section, `kit/own/ae_kit_r13.fbx`)
- **What the reference trees are made of (from close captures):** close up, a reference clump is not geometry detail at all.
  It is dozens of flat cards carrying a cut-out texture of many small rounded oval leaves, radiating out of the clump and
  drooping, with two tones (darker inside, lighter tips). The cypress shows a clear X from the side: crossed upright cards.
  Every earlier practice tree tried to make the leaves out of polygons (spiky cards, icospheres, Ball parts), which is why
  they read as crystal shards or lollipops.
- **Leaf textures** (`tex/make_ae_tex13.py`, `tex/leaf13/`):
  - `leaf13_sprig.png` 256x512: a stem with 24 alternate rounded leaves, values 150-255 (darker at the base, light at the tip).
  - `leaf13_pad.png` 512x512: a round heap of 650 small oval leaves with a ragged edge, darker in the middle and bottom.
  - Grey-white so one image serves every colour family; uploaded with `upload_image` (sprig `rbxassetid://139984766645372`,
    pad `rbxassetid://130347176621349`).
- **Tint and cut-out in Studio:** tested first on a scrap mesh. A `SurfaceAppearance` with `AlphaMode = Transparency`,
  `ColorMap` = the leaf image and `Color` = the tint cuts the leaves out and tints them. `MeshPart.TextureID` does neither:
  the texture shows untinted and the transparent pixels render black.
- **Pieces** (all Y-up authored, `to_zup_and_uv()`, leaf cards carry their own 0..1 UVs and custom normals pointing out of
  the clump centre, so a clump shades as one soft ball):

| piece | what | tris |
|---|---|---|
| Soft13R | round broadleaf: trunk, branches, 7 clumps on a dome | 2668 |
| Soft13C | cloud/bonsai: twisting trunk, 5 flattened pads at different heights | 1728 |
| Soft13U | umbrella/acacia: thick trunk, 4 limbs, flat-topped canopy of 8 clumps (gold mass) | 2744 |
| Soft13W | wisteria: 6 clumps + 26 hanging strands (long sprig cards pointing down) | 2032 |
| Soft13Y | cypress: 3 tiers of 3 crossed pad cards + 40 short sprig cards | 448 |
| Soft13P | feather palm: ringed trunk, 9 fronds of two long sprig cards in a V | 892 |
| Soft13B | low bush (one squashed clump) | 280 |
| Soft13K | loose clump, the unit for big canopies, horizon and islands | 376 |

  Meshes per tree: `_wood`, `_leaf` (inner cards, dark tint), `_leafRim` (outer cards, light tint), `_leafPad` (crossed filler
  cards, pad texture, dark tint). Plus `K_Scale13_stone`.
- **Clump construction** (`clump13`): 3 crossed pad cards 2r across, turned 60 degrees apart and leaned ±0.4 rad (from any
  side one shows its round leafy outline) + one level pad card for the view from above + 22-30 drooping sprig cards on a
  Fibonacci sphere (y ≥ -0.35), base 0.2-0.4r out, length 0.75-1.0r, width 0.6 of the length, droop 0.3-0.5 x L x t².
  The first Blender render (cards only, plus one big level card) read as lettuce rosettes; the crossed, leaned pad cards made
  it a ball.
- **Swap in Studio** (`fix/pass13.lua` item 1, 975 new models under `Plaza.Pass13.Trees13`, 597 old pieces stashed):
  - every `K_Fluffy`, `K_FluffyS`, `K_Wisteria`, `K_Cypress`, `K_Palm6A/B` → a soft tree of the same height and foot, family
    from the old leaf hue (blue/purple/gold/green/teal/red). Silhouette: cypress → Y, palms → P, wisteria or purple → W,
    the 4 arch trees on the pool rocks → C at 28 tall (the reference arch tree is about 1.5x the old one), gold over 22 → U,
    the rest R or C.
  - **Densify:** each R/C/U/W gets 4 (U: 6) extra loose clumps round its canopy shell. The kit tree alone read sparse through
    the cut-out leaves; the extra clumps made the masses fill the frame like the reference.
  - avenue cypress cones (Parts) → Soft13Y 17 tall; horizon Ball crowns → 2 soft clumps each (the far ring, r > 330, tinted
    20% toward (170,210,235), the near ring 8%); island LeafyGrass balls and sphere puffs → green soft clumps; the Story tree's
    49 Parts clumps → blue soft clumps (the drip vines stay).
  - the red tree at the SE (left of p2) is blue now (review item 10).
- **Colour fit:** the tint multiplies the texture (150-255), so the review's family colours render darker. Blue
  (30,80,220)/(70,140,255) rendered (27-38,64-71,145-174) in p1 against the reference (16-44,61-103,196-226); purple rendered
  (85-88,64-88,150-155). Final tints: blue (38,98,240)/(95,165,255), purple (175,135,240)/(215,180,255); gold
  (220,170,40)/(250,210,90) rendered (208,183,74) against (200,161,70) and was kept.

### 2. Local glow and haze
- **Raid haze:** a second holder `RaidSmoke13` with 5 emitters (either side of the skull, the facade top, both facade flanks),
  size 30-46, Transparency 1 → 0.62 → 1, colour (215,128,100) → (170,98,85), LightEmission 0.1, lifetime 8-11, rate 2-3, and
  6 puffs emitted at once. The pass-12 puffs (T 0.8, size 13-30) never showed from the spawn.
  - First try (T 0.55, (205,110,95), LightEmission 0.15) was a flat pink blob: (214,103,92) right of the skull against the
    reference (196,147,119).
  - Final, p3 beside the skull: (188,137,133) / (192,143,140) against the reference (205,92,81) / (196,147,119): a warm haze
    with the facade still shaded.
- 3 red PointLights (255,60,55) range 30, brightness 0.9, no shadows, at the facade foot; a 3-strip Neon (200,40,40) glow at the
  door threshold.
- Every `K_Crystal` got a Neon (60,150,255) core (ellipsoid 0.35 x 0.5 of the crystal) with a PointLight (80,170,255), range 12.

### 3. Avenue and flank density
- Purple wisteria mass right of Summon (4 W trees about 22 tall + 12 clumps, about 40 x 30) and behind the NE arch (3 trees
  about 19 tall + 9 clumps); 2 more gold U trees 30 tall left-behind of Summon. Ground height by raycast.
- The avenue cypress pair are 5 x 17 soft cypresses now.
- Not done: gold pineapple, bunting.

### 6/7. Raid plinths and lawn
- The two white plinths at the Raid door were the E terrace plinths of pass 12; the E plinth sets (and their crystals) are gone.
- **The lawn is Parts, not Terrain.** The big lawns are the Grass-material ground Parts `GroundN/S/E/W` (74,124,28), rendering
  (110,167,62) in p7. Base x target/rendered gives (68,112,16): it now renders (103,158,55) against the reference (102,152,33).
  (I first changed the Terrain Grass colour, measured no change, found the Parts with a raycast and put Terrain back.)

### Not done (time)
- Items 4 (island streams, taller towers, aqueduct), 5 (portal frame, stepped arena), 8-10 (wing flanks, pods, medallion,
  bollards, S gate), lawn tufts and sand paths, the W lagoon ring.

## Lessons (for the workflow vault)
1. **Look at the reference foliage from a metre away before modelling it.** At plaza distance the trees read as "soft
   clumps"; one close capture showed what they are: flat cards with a cut-out leaf texture. Ten passes of polygon leaves
   (spiky cards, spheres, Ball parts) could never get there.
2. **Stylised foliage = textured cards, not leaf polygons.** One grey-white leaf image, tinted per family, carries the whole
   look: the silhouette edge comes from the texture's alpha, not the mesh. A tree then costs 300-2700 triangles.
3. **In Roblox, tint and cut out with a SurfaceAppearance**, `AlphaMode = Transparency`, `ColorMap` = the leaf image,
   `Color` = the tint. `MeshPart.TextureID` does not tint and draws transparent pixels black. Test this on a scrap mesh
   before building the kit.
4. **A clump needs crossed cards for its body and radiating cards for its edge.** Radiating cards alone read as a rosette (or a
   starburst); 3 crossed, leaned "pad" cards with a round leaf-heap texture give the ball, the drooping cards give the fuzz.
5. **Point the leaf normals out of the clump centre.** Flat card normals shade every card differently (facets); clump normals
   make a canopy shade like a soft ball. Blender: `mesh.normals_split_custom_set`, export with smoothing off; the importer
   keeps them.
6. **Cut-out foliage reads thinner than a solid mesh of the same size.** Budget for density: extra loose clumps round each
   canopy doubled the mass and matched the reference's "packed to the frame edge" look.
7. **A multiplied tint renders darker than the tint.** The texture's values (150-255) multiply it; fit the tint by one capture
   and the ratio, as with base colours.
8. **Swap, don't destroy, when replacing scene pieces from a re-runnable script.** Moving the old pieces into a holding folder
   with an ObjectValue to their parent, and putting them back at the start of each run, makes the swap idempotent and
   reversible.
9. **Find what is drawn before changing its colour** (again): the lawn was Grass-material Parts, not Terrain; one raycast
   settled it.

## Objects built (for 5 Object Recipes)

### Leaf textures (`tex/make_ae_tex13.py`)
- `leaf(dr, x, y, angle, L, W, value)`: a pointed oval polygon (half-width W·sin(πt)^0.8·(1-0.25t)), a 0.82x darker rim,
  an inner 0.72-width fill and a lighter midrib line. Drawn at 2x and downsampled (LANCZOS) for soft edges.
- **Sprig:** a slightly wavy stem, 24 alternating leaves angled 0.75-1.15 rad off the stem, length shrinking up the stem,
  value 150 → 250 from base to tip, one tip leaf.
- **Pad:** 650 leaves in a disc (radius √rand), pointing outward, value lighter to the top and the rim, inner leaves drawn first.

### Leaf card and clump (`tools/ae_kit.py`: `Leaves13`, `lcard13`, `padcard13`, `clump13`)
- `Leaves13`: collects quads with per-loop UVs and normals; each quad gets a reversed twin 0.02 behind (Roblox culls back faces).
- `lcard13`: a 3-segment strip along d, sagging droop·L·t², width W, UV (0..1 across, 0 → 1 base to tip), normals out of the clump.
- `clump13(r)`: 3 crossed pad cards 2r across leaned ±0.4, one level pad card 1.6r, 22-30 sprig cards over a Fibonacci sphere.
- Trees: `build_round13`, `build_cloud13`, `build_umb13`, `build_wis13` (hanging strands = sprig cards pointing down),
  `build_cyp13` (3 tiers of 3 crossed pad cards + short sprigs), `build_palm13` (two sprig cards per frond in a V, droop 0.85),
  `build_bush13`, `build_clump13`.

### Soft tree placement (`fix/pass13.lua`, `soft(prefix, foot, scale, family, parent, yaw, haze)`)
- Clone the kit pieces, scale about the kit origin, put the lowest point on `foot`; leaves get a SurfaceAppearance (sprig or
  pad, tint dark/light by token), CastShadow and collisions off; wood (105,76,52) keeps collision.
- Family colours (dark/light): blue (38,98,240)/(95,165,255), purple (175,135,240)/(215,180,255), gold (220,170,40)/(250,210,90),
  green (90,160,60)/(130,190,70), teal (40,150,160)/(90,200,200), red (120,25,35)/(175,55,60); far trees lerped 20% to (170,210,235).
- Densify with 4-6 `K_Soft13K` clumps (scale H/20) round the canopy shell at 0.32H out (0.5H for the umbrella).

### Raid haze v2
- An invisible holder with 5 Attachments (skull sides, facade top, both flanks), ParticleEmitter `smoke_main.dds`, size 30-46,
  T 1 → 0.62 → 1, warm (215,128,100) → (170,98,85), LightEmission 0.1, lifetime 8-11, rate 2-3, `Emit(6)` on build.

### Crystal core
- A Neon (60,150,255) SpecialMesh-sphere Part at the crystal's bounding-box centre, 0.35 x 0.5 x 0.35 of its size, with a
  PointLight (80,170,255) range 12, brightness 1.2.

## Files
- `tools/ae_kit.py` (pass-13 section), `ae_kit.blend` (saved), `kit/own/ae_kit_r13.fbx`.
- `tex/make_ae_tex13.py`, `tex/leaf13/leaf13_sprig.png`, `tex/leaf13/leaf13_pad.png`.
- `fix/pass13.lua` (new), `fix/build_plaza.lua` (r13 in `IMPORTS`, the pass-13 block), `cmd/runlua.py` (new helper).
- `out/r13/r13_*.png`, `out/r13w/`.
