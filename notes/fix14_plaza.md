# Fix pass 14: Anime Expeditions spawn plaza (fine leaf cards, Raid focal point, islands, horizon, Story)

Builder report for `notes/fix_brief14.md`, answering the round-11 review `notes/verify11_plaza.md` (7.25/10).

**Captures:**
- Final set: `out/r14/r14_<cam>.png`, 12 cameras, 1452x793 (`capture_set2.py`, two frames per camera, the second kept).
- Working frames in `out/r14w/`:
  - `t1..t6_*`: before/after tests (t1-t5 are the Raid haze tries).
  - `blender_kit14*.png`: Blender check renders.
  - `tex14_preview.png`: the new textures.
  - `close_arch_r14_white.jpg`, `textest_back.jpg`, `close_arch_r14b.jpg`: the white-card bug and its fix.
- Reference study (screen_capture only, no code in the reference studio): `out/r14w/ref_gold_close.jpg`,
  `ref_gold_mid.jpg`, `ref_purple_cypress_close.jpg`.
- Colours are 5x5 means (`out/r14w/samp.py`) against `out/verify11/v11_<cam>_ref.jpg`.

**Rules kept:**
- Pictures only: the reference was only captured; `ae_reference.blend` was not opened.
- Own textures only: `tex/make_ae_tex14.py` paints them with PIL polygons.
- No computer use. The practice place is not saved and nothing is committed. `ae_kit.blend` is saved.

**How to rebuild:**
- On a built plaza, run in this order:
  1. `fix/pass14.lua`: merges `ae_kit_r14b` (or `ae_kit_r14`) from Workspace into `ServerStorage.Kit`.
  2. `fix/pass13.lua`: the tree swap. It now builds from `K_Soft14*` whenever they are in Kit.
  3. `fix/pass14.lua` again: it retunes the Raid smoke and lights that pass 13 rebuilds.
- `fix/build_plaza.lua` carries both blocks in the same order, and r14/r14b are in its `IMPORTS`.
- Wrap a file for `mcpcli.py` with `python cmd/runlua.py fix/<f>.lua <studio>`.
- Two kit exports exist: `kit/own/ae_kit_r14.fbx` (first, with the white-card bug) and `kit/own/ae_kit_r14b.fbx` (the one to use).

## What changed, per priority

### 1. Foliage: fine leaf cards (`tools/ae_kit.py` pass-14 section, `ae_kit_r14b.fbx`)
**What the reference foliage is made of (from new close captures):**
- At a few studs away, a reference canopy is high-frequency speckle: many small rounded leaves, about 1/30 of a clump across.
- Colour is near-flat and saturated, darker inside and lighter at the rim, with no sheen.
- The pass-13 cards carried one 3-5 stud leaf shape each, so the shading broke into planes.

**Textures** (`tex/make_ae_tex14.py`, `tex/leaf14/`; asset ids in `out/r14w/leaf14_assets.json`):
- `leaf14_spray_<fam>.png` (256x512): a twig with 5 side twigs carrying 35 small leaves. Each leaf is 0.11-0.14 of the card
  length, which is 0.3-0.5 studs on a 2-stud card.
- `leaf14_pad_<fam>.png` (1024x1024): a heap of 2600 leaves, each about 1/32 of the width (0.3-0.45 studs on a 10-14 stud
  filler card). The core is dark and the rim and top are bright.
- The dark-core-to-bright-tip gradient is baked in for blue (10,40,150)->(60,150,255), gold (170,120,30)->(250,210,90) and
  purple (110,70,170)->(200,160,245). A grey version (0.45-1.0) is tinted for green, teal and red.
- `leaf14_rough.png` (white, roughness 1) and `leaf14_metal.png` (black, metalness 0) go into every SurfaceAppearance.

**Clump** (`clump14`):
- 3 crossed filler cards plus a level card, as in pass 13.
- 40-80 small spray cards of an absolute 1.4-1.9 studs. Kit trees are authored near their placed height, so the Studio
  scale is 1.0-1.6 and a placed card is about 1.5-2.5 studs.
- 60% of the cards are **shingles** lying in the clump shell, facing out. The first r14 render had only radial cards; those
  are seen end-on from the front, so the crossed filler cards showed as an "X".
- 40% are radial drooping cards for the fuzzy outline.
- Shingles have 1 segment and radial cards 2.

**Triangles:**

| tree | tris |
|---|---|
| R (round) | 3312 |
| C (cloud, arch trees) | 2648 |
| U (umbrella, gold) | 3448 |
| W (wisteria) | 3208 |
| Y (cypress) | 848 |
| K (loose clump) | 376 |
| B (bush) | 264 |

All are under 4k. The palm stays `K_Soft13P`.

**The white planes** (the probable cause of round 11's "white glints" too):
- After the first import, the pad cards rendered as glossy white planes when seen from below or behind.
- The texture rendered fine in isolation from the front. From behind, the same test clump went white.
- Cause: `Leaves13.quad` gave the card's back twin the SAME shading normals as its front. Seen from behind, the normal
  points away from the camera and Roblox draws a pale sky-reflection sheen, even with roughness 1.
- Fix: `Leaves14.quad` keeps each side's normal in that side's own hemisphere (n·gn >= 0.35). The clump direction survives
  in the tangent part, so the clump still shades as one ball. The upward bias on the clump normals was cut from 0.35 to 0.15.
- Blender check: 0 of 25,344 leaf loop normals face away from their side. Re-exported as r14b.

**Swap:**
- `pass13.lua` maps every `K_Soft13X` to `K_Soft14X`, keeping the same placement, seeds and holding folder (`Pass13Old`).
- For blue/gold/purple, Color is white (225 on the inner cards) because the colour is in the texture.
- Result: 69 trees and 886 clumps on r14b; the 21 palms stay on r13.

**Measured:**

| sample | round 11 | now | reference |
|---|---|---|---|
| p1 blue tree, lit side | (126,168,228) with glints | (47,114,204) | (22,69,210) / (60,127,228) |
| p1 blue, left tree | — | (18,68,167) / (19,63,163) | (38,95,224) |
| gold in shade | (144,109,32) olive | (190,155,55) | (192,155,72) |
| gold, lit | — | (234,208,82) | — |

Close up (`close_arch_r14b.jpg`), a clump now reads as deep blue speckle instead of crumpled paper.

### 2. Raid (`pass14.lua` item 2)
- **"White plinths":**
  - Rayed the reviewer's p3 pixels with the p3 camera, FOV 70.
  - (640,377) hits `TerraceRail` (84,8.2,-14.3), (648,372) and (800,372) hit `TerraceBaluster` at (93.3,-14.2) and (97.8,14.1),
    and (805,377) hits `TerraceBaluster` (88.9,13.8).
  - The east terrace is removed (14 pieces). `pass12.lua` and `build_plaza.lua` now build only the west one.
  - Those pixels now sample (74,19,43) and (69,27,35): the dark facade.
- **Facade:** dark maroon (100,25,30); buttresses, cap and pinnacles (70,18,24).
- **Red lights:** the facade-foot lights went from 0.2-0.9 to 0.12 (RaidLight9/11) and 0.35 (pass-13 lights). They had lit the
  whole facade bright red.
- **Skull:** dusty rose (225,100,105), plus a PointLight (255,90,90), range 20, in front of it. It is now the lightest
  thing on the temple.
- **Haze:**
  - The old pink emitters (RaidSmoke12, RaidHaze, RaidSmoke13) are off.
  - New `RaidSmoke14`: 8 emitters behind and beside the facade (z ±32-46, behind the facade top, low flanks), none in front
    of the skull.
  - Tries, sampled beside the skull (target about (190,75,80)):

| try | settings | sample |
|---|---|---|
| 1 | (230,40,40), LightEmission 0.6, T 0.55 | (254,156,195) pink blobs |
| 2 | (205,35,40), LE 0.08, T 0.42 | (253,23,44) |
| 3 | rate 3 | (234,53,59) solid red wall |
| 4 | (185,75,78), T 0.74 | (186,130,166) sky through |
| 5 (final) | (160,38,36)->(140,32,32), T 0.63/0.72, LE 0.05, LightInfluence 0.5, size 1.1-1.45 x 26-30, rate 1.2 | (195,62,85) / (202,64,83) |

  - The final colour was fitted from tries 3 and 4: about 3.5 puff layers deep, a lit gain of about 1.3, and the sky behind
    at about (100,190,240).

### 3. Islands
- **Lifted and pushed out:** the N/NE/NW islands (centre z < -100) are 22 studs higher and 30 further out. 533 pieces moved:
  the island bodies plus everything in `Islands` and `IslDress12`, the stashed island balls and their soft clumps, each
  assigned to its nearest island.
  - Each moved piece is tagged `P14Isl`, so it never moves twice; pass 13 copies the tag onto rebuilt island clumps.
- **Towers:** 2 new towers per N island, 35-50 tall, with a dark band and windows, topped by a dome or a spire.
- **Aqueduct:** one 4-arch span (60 long, 20 high) with a water channel on the far N island.
- **Falls:** 2.5-wide (200,235,255) streams at T 0.3 (they were 9-wide white slabs).
- c3 now shows sky between the islands.

### 4. Horizon
- **Palaces:** 4 grey domed palaces in the SE (150,215), (225,150), (80,255), (255,60). Each has a block body, cornice, dark
  arches, drum, main dome, lantern and 2 side domes.
- **Foliage ring:**
  - 22 groups of 3-5 overlapping r14 clumps (scale 2.0-2.6) plus a low clump that hides the foot.
  - They sit on a ring 150-215 out from W round N to E, skipping the Raid backdrop, and are hazed 8-25% toward the sky.
  - The old horizon trunks are hidden.
- **p7 top corners:** they sampled baseplate green in round 11; now (46,75,132) (blue foliage) at top left and (63,39,61)
  at top right.

### 5. Story
- **Portal:** the spiral is hidden. In its place: a dark (15,20,40) opening disc, a silver-blue frame of 16 blocks with 4 bigger
  keystones (150,170,205 / 105,125,165), a ring behind, two jambs and a sill.
- **Arena:** a stepped white arena of 3 tiers (42 / 36 / 30 across) around the tree, with 24 gold studs on the top edge.
- **Canopy:** 34+6 r14 blue clumps on a dome about 60 across centred over the trunk, plus 40 hanging moss strands. The old
  vines are hidden.
- **Trunk:** it is actually upright. The "bar lying across p8" is the perspective of a tall trunk seen from 160 up. The canopy
  now covers most of it; the lower trunk still shows inside the arena from p8.

### 6/7. Bollards and pods
- **Bollards:** 35% lower, grey (150,155,160) body. The smooth gold dome is hidden and replaced by a small stepped knob:
  2 slabs, a ball and a spike.
  - The first try (steps 0.8 of the width) read as a gold ziggurat.
- **Pods:** 8 crystal pods by the pavilions, Glass (40,110,230) 3.2x6 with a Neon core and a PointLight of range 12.

### Not done (time)
- Item 7 wing flank faces (they are part of the hero mesh).
- Items 8-10: litter splats, avenue dressing, S side.
- The medallion.
- Stair tufts.

## Remaining issues seen on the final set
- From the spawn cameras, clumps still show the round outlines of the crossed filler cards. Next step: more shingles and
  smaller filler cards, or break the filler cards' outline with a ragged alpha.
- The Story moss reads as straight blue sticks with ball tips from p7. Use thin spray cards instead.
- The Story sign behind the portal reads back-to-front from p7.

## Lessons (for the workflow vault)
1. **A double-sided card needs its own normal per side.** If the back twin copies the front's custom normals, every card seen
   from behind or below lights as a pale white sheen (sky reflection), even at roughness 1. Keep each side's shading normal
   in that side's hemisphere (n·gn >= ~0.35) and put the "soft ball" direction in the tangent part. Check it in Blender by
   counting loop normals with `loop.normal · poly.normal < 0`.
2. **Test a new texture or material on one isolated clump from the front AND from behind before judging the kit.** A test from
   one side passed; the bug only showed from below.
3. **Leaf size is set by the texture, card size by the mesh: fix both.** Fine foliage needs both small leaves in the texture
   and small cards (absolute studs, not a fraction of the clump), plus enough cards to overlap.
4. **Radial cards are invisible face-on.** Cards that point out of a clump are seen end-on from the front, so the filler cards
   show through. Lay most cards in the shell, facing out (shingles), and keep radial cards for the silhouette fringe.
5. **Bake the gradient into the texture rather than relying on a tint.** A white-coloured SurfaceAppearance over a coloured
   texture keeps a saturated dark core and bright tips. A multiplied tint only darkens.
6. **Fit particle haze by measuring.** Haze colour is the puff colour times the light gain, blended with the sky through about
   N layers of puffs. Two tries with measured samples give the gain and the layer count; the third lands on the target.
   LightEmission adds to the sky behind (pink on blue).
7. **Ray the reviewer's pixels before deciding what an object is.** The "two white plinths" were a terrace rail and
   balusters, not plinths. Removing the plinths in pass 13 missed them for two more rounds.
8. **A tall vertical object seen from straight above looks like a bar lying down.** Perspective from 160 up projects a
   45-stud trunk as a long radial bar. Cover it from above (canopy) instead of rotating it.
9. **Move scene pieces with a tag.** Mark moved instances with an attribute and pass the tag on to anything rebuilt from them,
   so re-running the scripts never moves anything twice.

## Objects built (for 5 Object Recipes)

### Fine leaf textures (`tex/make_ae_tex14.py`)
- `leaf(dr, x, y, ang, L, W, fam, t)`: a pointed oval with a 0.85x darker rim and a 0.65-width fill. Colour comes from
  `col(fam, t)`, interpolating core->tip. No midrib.
- **Spray:** a main twig plus 5 side twigs fanning to ±0.2-0.26 of the width. 10 leaves on the main twig and 5 per side twig,
  angled ±0.35-0.8 rad off the twig. t rises from base to tip, base leaves are drawn first.
- **Pad:** 2600 leaves in a disc of radius 0.42, pointing outward ±1 rad, with t = 0.15 + 0.45·rim^1.5 + 0.35·top.
- Everything is drawn at 2x and downsampled (LANCZOS).

### Fine clump (`tools/ae_kit.py`: `Leaves14`, `lcard14`, `padcard14`, `clump14`, `ncards`)
- `Leaves14.quad`: adds the face and a reversed twin 0.02 behind; each side's normals are clamped to n·gn >= 0.35.
- `clump14(r, n)`: 3 crossed filler cards 2r across, leaned ±0.4, plus a level card 1.7r.
  - n cards on a Fibonacci sphere, every 5: 3 shingles and 2 radial cards.
  - Shingle: direction = down-the-shell 0.75 + sideways ±0.6 + out 0.3, base at 0.82-0.98r, normal out of the clump.
  - Radial card: base at 0.75-0.95r (inner 0.45-0.65r), drooping 0.6-1.2 x droop.
- `ncards(r, k)` = clamp(k·4πr²/10, 40, 80).
- Trees: `build_round14` (H 20), `build_cloud14` (H 26), `build_umb14` (H 28), `build_wis14` (H 20, 30 hanging racemes),
  `build_cyp14` (90 cards), `build_clump14`, `build_bush14`.

### Red haze v3 (`pass14.lua`)
- An invisible holder with 8 attachments: beside the skull at z ±32-36 (y 72 and 100), behind the facade top (196,112,0)
  and (194,62,0), low flanks (168,38,±46).
- Emitter: `smoke_main.dds`, colour (160,38,36)->(140,32,32), LightEmission 0.05, LightInfluence 0.5, T 1->0.63->0.72->1,
  size 1.1-1.45 x 26-30, rate 1.2, lifetime 8-11, `Emit(4)`.

### Story portal frame
- Opening: a Cylinder disc 0.4 x 12.6 (15,20,40) facing +X, with a frame-colour disc 15.6 behind it.
- 16 blocks round radius 7.4, each 4th a keystone 3.2x2.6x2.2, the rest 2.5x2.0x1.6, rotated a+90 degrees.
- 2 jambs at ±7.4 and a sill.

### Stepped arena
- 3 cylinder tiers 42/36/30 across, 1/2/3 tall, in white stone (215-232), with 24 gold ball studs at r 14.6 on the top tier.

### Grey palace
- Block w x h x d, a cornice +1.5, 5 dark arch insets on the front face.
- A Cylinder drum 0.42w, a Ball dome 0.5w, a lantern, 2 side domes 0.22w at ±0.38w.

### Stepped bollard cap
- Body cut to 0.65 height about its base (originals kept in attributes `P14Size`/`P14CF`/`P14Col`).
- Gold slabs 0.5w and 0.36w (0.35 thick), a Ball knob 0.3w, a spike 0.1 x 0.32w turned 45 degrees.

### Crystal pod
- Glass (40,110,230) 3.2 x 6 x 3.2 at T 0.15, turned 45 degrees and tilted 8 degrees, with a Neon core 1.6 x 4 and a 45/45
  degree tip cube.
- PointLight (80,160,255), range 12, brightness 1.4.
- Placed 4.5 studs outward of each PavGlow on the ground ray.

## Files
- `tools/ae_kit.py` (pass-14 section), `ae_kit.blend` (saved).
- `kit/own/ae_kit_r14.fbx` (superseded) and `kit/own/ae_kit_r14b.fbx`.
- `tex/make_ae_tex14.py`, `tex/leaf14/*.png`, `out/r14w/leaf14_assets.json`.
- `fix/pass14.lua` (new).
- `fix/pass13.lua` (generation switch to r14, `P14Isl` tag, return fix).
- `fix/pass12.lua` and `fix/build_plaza.lua` (west terrace only; pass-13 sync; pass-14 block; r14/r14b in `IMPORTS`).
- `cmd/chk14.lua`.
- `out/r14/`, `out/r14w/`.
