# Fix pass 6: Anime Expeditions spawn plaza (freestyle, crown crest, tree mix, islands, zoning, landmarks)

This is the builder report for `notes/fix_brief6.md`. It answers the round-3 review `notes/verify3_plaza.md` (5.17/10).
- Sheet: `out/cmp_r6.jpg` (reference on the left, r6 on the right, 12 cameras).
- Captures: `out/r6/r6_<cam>.png`.

Rules kept:
- Nothing was run in the reference studio and no extra reference captures were taken. The 12-picture set was enough.
- `ae_reference.blend` was not opened.
- The practice place was not saved and nothing was committed.
- `ae_kit.blend` was saved, because it holds the kit source (same as pass 5).
- The kit went in once with Import 3D (Insert Using Scene Position + Anchored). Arrival was confirmed from Luau: 95 MeshParts under `workspace.ae_kit_r6`.
- **Import scale:** the measured import scale was 16.516, the same 2048 clamp as r5.

## What was built and how (method)
All new kit pieces are in `tools/ae_kit.py`, section "pass 6" (`build_all6()`, `export_r6()`).
- **Export:** `kit/own/ae_kit_r6.fbx`, 95 meshes. That is the r5 set plus the new pieces, with the hero piece replaced.
- **Triangle budget:** the largest mesh is `K_Hero_goldLan` at 18.7k triangles, under the 20k limit.

### Hero piece (`build_hero6`, still one NE corner in the diagonal frame `P(u, y, w)`, mirrored x4, one mesh per material)
- **Crown crest (review item 5):**
  - The crest is one extruded outline with sloping shoulders, from the band at u ±8 / y 7.9 up to the arm bases at u ±5.7 / y 10.7.
  - Two arms 3.3 wide rise to 13.5, with a chamfered outer top corner (the "hook").
  - Between the arms is a **4.8-wide window** (46% of the crest's top width) whose bottom is at 9.4. That is 4.1 deep, about 75% of the crest height. You can now see the pool tree through it in c1, c3 and p1.
- **Flat inset gold bands (item 6):** a new helper `ribbon_uy(name, outline, width, w0)` replaces the round `tube_along` trims.
  - It offsets any (u, y) outline inward by a miter offset. It picks the inward side from the sign of the polygon area, so it works on open arches and on the concave crest.
  - It builds a 0.14-proud flat strip.
  - It is used on the arch's outer edge (0.55 wide), on a second line inside it, on the rib step, and right round the crest (0.42).
  - `ribbon_xz` does the same on horizontal faces (block-top edges). The wing and stair-side trims are thin `prism` strips.
  - The basin rims are flat lathe rings, not tubes.
- **Vault:**
  - The back wall, top and shelf back are a new `vault` token, so they get their own colour.
  - A filler plate in the crest window also uses that colour.
  - The angled foam slab is gone. In its place is a **curved water sheet**: 13 double-sided rows arcing from the shelf lip out and down into the upper bowl, widening from 2.6 to 3.6.
- **Basin:** it is moved forward 2 studs (centre w 29.6), so its front half stands clear of the arch face. The lower drum band uses the mid-grey `rib` token.
- **Lanterns (`lantern6`):**
  - They are placed **2 studs lower**: the drum foot sinks into the corner block.
  - Each dome gets **10 gold rib tubes** along its meridians.
  - A small **hot core** lathe sits inside the glass (`core` token, Neon).

### Foliage (item 3)
- **`build_palm6`:**
  - A thicker trunk (0.85) with 11 soft ring bulges.
  - 8-9 **broad** fronds: 8 leaflet pairs per frond, 0.95 wide, instead of 14 thin pairs.
  - A 22-tall variant (`Palm6A`) and a 20-tall variant (`Palm6B`).
  - The trunk is recoloured tan (150,110,60) in Lua.
- **`build_fluffy6`:**
  - A round broadleaf canopy made of 10-18 small "puffs". Each puff is a dark icosphere core with 22-30 short leaf cards.
  - The trunk is thick, with a root flare.
  - Variants:
    - `Fluffy`: canopy about 22 across, used gold, purple, blue and teal.
    - `FluffyS`: canopy about 12 across.
    - `Wisteria`: about 20 across, plus 36 hanging strands of 5 cards each (purple weeping).
- **`build_deadtree6`:** a recursive 3-level branching tube tree for the Raid side.
- **`build_litter6`:** 46 leaf cards lying almost flat over a 4-stud disc. It is tinted per flight: red E, blue N, green S and W.

### Skyline (item 2)
`build_island6`, 80 across:
- a jittered grey rock underside 34 deep;
- a thick grass cap 3.6 high that overhangs the rim and drops 1.4 below it;
- **40 hanging vine strips**, 5-14 long;
- a 36-tall white ruined tower with broken crenels, a second tower and a broken arcade;
- 2 thin waterfalls.

It is placed 8 times at 1.2-1.9x, so 96-150 across:
- 4 to the N and NE at 170-330 out;
- each one carries a gold or purple or green fluffy tree, a small green tree, and on half of them a palm.

### Ground zoning (item 4)
- `build_patch6` makes organic blobs: a 40-point outline, with the radius modulated by 2, 3 and 5-lobe sines plus noise. There are 3 shapes: round r 20, elongated r 14 x 0.55, and small r 9.
- The terrace is now one neutral grass colour. On top of it, `build_plaza.lua` scatters **233 patches** 70-260 out, never inside the plaza square or the avenue:
  - **E:** grey Slate gravel with red litter patches (170,42,38) laid over it, and a few green islands;
  - **W:** green with water patches (Glass, 90,170,200) and white flower patches;
  - **N/S:** two greens and Sand patches.
- The straight zone edges are gone in p7 and p8.

### Landmarks (item 7)
- **Raid:**
  - It uses `build_gothic6`: a pointed (two-arc) archivolt in 2 stepped bands, an opening about 8.4 wide and 15 tall, a dark door, 2 columns with pinnacles, a back wall, and a gable with a gold rose disc. It is in weathered red.
  - The tower is 16 x 44, with the skull centre at 55 (about 49 above the terrace).
  - There are 2 `build_spire6` spires (25 tall), 2 dead trees, 2 red palms and a red PointLight in the gate.
- **Expeditions:**
  - It uses `build_exparch6`: a round arch 17 wide on 2 pale-teal columns with urns, a sign tablet, a finial and a teal glass field.
  - It also has 2 crystal braziers, a **ring of 8 rock slabs** (r 12, centre at y 31) and a white Neon glow in the middle.
- **Story:**
  - The ring is scaled **1.3x**, with a black void (15,15,20) and a very faint purple glow.
  - The GiantTree trunk is recoloured tan, with a 16-wide trunk sleeve and 6 sloping root wedges for the flare.
  - Blue palms flank it.

### Placement (`fix/build_plaza.lua`, rewritten for r6, idempotent)
- **Kit:** the script looks for `ae_kit_r6`, measures the scale from the dais, and asserts that `K_Hero_vault` is present.
- **Colours** (part colours; rendered values are higher):

  | element | part colour | notes |
  |---|---|---|
  | gate stone | (102,106,114) | neutral, no blue tint |
  | rib | (78,84,96) | |
  | darkStone | (76,82,96) | |
  | vault | (72,82,100) | |
  | gold | (170,146,50) | reflectance 0.05; medallion gold (165,146,52) |
  | medallion blades | (40,45,55) | |
  | lantern glass | (85,140,185) | Glass, transparency 0.25 |
  | glass core | (190,235,255) | Neon |
  | water | (110,175,195) | transparency 0.3 |
  | water sheet | (150,205,225) | |
  | foreground band | (60,65,75) | slate, was navy |
  | risers | (95,100,110) | |

- **Vaults:** each of the 4 has a cyan PointLight (120,200,230, range 16, brightness 3) and a mist ParticleEmitter at the foot of the water sheet.
- **Planting** (about 70% fewer palms and cones; no cypress cones at all now):
  - **N avenue:** 2 palms per side at z -64 and -90, all leaning 6° outward.
  - **Gold trees** (215,170,40) at (-24,-100) and (-34,-128).
  - **Purple wisterias** at (22,-88) and (30,-106), plus a teal tree.
  - **Pool rocks:** each carries a blue `FluffyS`, with 2 floating crystals between its lanterns.
  - **Per quadrant:** 1 palm and 2 fluffy trees.
  - **Outer ring:** 16 trees.
  - **Dressing:** 8 litter clumps and 4 ferns per flight on the step edges, 3 small litter patches at each stair foot, ferns at the basin feet, and a fern and litter carpet on the terrace.
- **Lighting (`fix/fix_lighting.lua`):**
  - **The pass-5 override of Ambient/OutdoorAmbient (110,115,130), ShadowSoftness 0.3 and Contrast 0.22 / Saturation 0.2 is removed.** The reference's own values, already set at the top of the script, now stand: Ambient (102,74,101), OutdoorAmbient (169,165,184), ShadowSoftness 0.2, Contrast 0.12, Saturation 0.14. The pass-5 override had been darker than the reference and was the main cause of the navy shade.
  - Atmosphere: Color (200,215,230), Haze 1.2 (was 1.0). The warm tint is (255,248,238).
  - Everything else is unchanged.
  - **Lighting.Technology was not checked. Recheck it by hand, or offline with `tools/set_technology.py`.**

## What I measured from the pictures
- **`ref_c1_wall`** (about 35 px/stud at the arch front, eye at y 6, horizon about y 396):
  - Crest arm tops at y 160 px, so about 12.7.
  - Window inner edges at x 568-715 (145 px), so about **4.1 wide**.
  - Window bottom at y 300 px, so about 8.7: the window opens down almost to the band.
  - Arms 505-610 and 680-785, so about **3 wide** each.
  - The crest outline flows from the arm bases (x 505 / 785) down sloping shoulders to the outer band at about x 330 / 955 near y 390. This is why the crest is now a crown with shoulders rather than tabs on top of a round arch.
- **`ref_c4_stairs`:**
  - Two palms per side frame the avenue. Their crowns are broad, about 8 wide fronds with few leaflets, and the trunks are tan.
  - The gold tree's canopy fills about 220 px left of centre.
  - The floating islands have thick green caps with hanging vines and towers.
  - These set the palm, fluffy-tree and island designs.
- **Rendered values after the change:**
  - The shaded gate band in p6 is now sampled (49,60,83). It was (16,45,86) in r5; the review's target was (55,62,75) or lighter.
  - The vault interior in p6 is (17,27,44). It was (0,0,10).
- **Median luma per camera** (ref / r5 / r6):

  | camera | ref | r5 | r6 |
  |---|---|---|---|
  | p1 | 149 | 154 | 154 |
  | p2 | 133 | 154 | 153 |
  | p3 | 123 | 154 | 155 |
  | p4 | 115 | 140 | 154 |
  | p5 | 140 | 127 | 153 |
  | p6 | 125 | 101 | 131 |
  | p7 | 137 | 128 | 145 |
  | p8 | 139 | 115 | 144 |
  | c1 | 128 | 109 | 151 |
  | c2 | 120 | 125 | 155 |
  | c3 | 148 | 148 | 148 |
  | c4 | 153 | 88 | 130 |

  The dark outliers (p6 and c4) are fixed. The practice now runs about 10-30 brighter than the reference in the spawn views, because its sky and floor are bright and it lacks the reference's dense dark foliage.

## Result (self-check on the sheet, not a review score)
- **Better:**
  - The gates no longer go navy or black.
  - The crown crest has a see-through window and reads like the reference's in c1, c3, p1 and p5.
  - The trims are flat gold bands.
  - The basin stands forward.
  - The lanterns sit lower with ribbed domes.
  - The skyline has big green-capped islands with vines and white towers (p1, p3, c3, c4).
  - The avenue has 2 tan palms per side with a gold tree and purple wisteria (c4).
  - The ground zoning has organic edges, with E gravel and red litter (p7, p8).
  - The Raid now has a pointed arch, spires, and a skull tower at about the reference's height.
  - The Expeditions portal is a columned arch with a rock ring and glow.
  - The Story ring is bigger, with a black void.
- **Still off:**
  - **Gate shading:** the shaded gate is still blue-tinted (49,60,83 against the reference's grey-slate). The sky-blue ambient is what tints it.
  - **Gate colour split:** the hood has no dark slate side panels. The reference hood has a pale band and crest, but dark wedge sides; ours is one stone colour.
  - **Vault fountain:** the vault fountain read is weak.
  - **Raid tower:** it is still a blocky red slab with a ball skull.
  - **Story trunk:** the trunk sleeve does not follow the curved trunk.
  - **Foliage density:** still well below the reference near the plaza (p1-p4 frame edges).
  - **Avenue clutter:** no umbrellas or stalls on the avenue.
  - **Floor litter:** the green litter patches on the plaza floor (c2) are a little too bright and large.
  - **Overall brightness:** a touch above the reference.

## Lessons (for the workflow vault)
1. **Check what the lighting override actually does before you recolour.** The navy shade came from an earlier "fix" that pushed Ambient/OutdoorAmbient *below* the reference's own values (110 against 169 outdoor). Restoring the reference values fixed more than any colour change could. Diff your Lighting against the reference's numbers first, then tune part colours.
2. **The Import 3D kit can arrive yawed 180° (x and z both flip).** Symmetric pieces (the 4-way hero, rotated stairs, round trees) hide this. The first one-sided piece showed it: the Raid gate's back wall faced the plaza and the palms leaned inward.
   - Test with one asymmetric marker piece.
   - Or compare a known offset after import (`K_Gothic_darkStone` authored at x +1.6 arrived at -1.6).
   - Then fix it once, in the placement helper (`yaw + math.pi`).
3. **Flat inset trims need a miter offset that knows "inside".** Compute the polygon's signed area and offset to the interior side. One helper then serves open arches and concave crests, and a flat 0.14-proud band reads as the reference's painted trim, where a round tube reads as piping.
4. **Model the crest as one outline that includes its shoulders.** The reference crest is a crown: shoulders that slope off the band, arms, and a deep window. Gluing tabs onto a round arch gives the wrong silhouette however big the notch is.
5. **Use organic zone edges, not rectangles.** A cheap noisy blob (a 40-point outline with 2, 3 and 5-lobe sine modulation) scattered by the hundred in a few tints and layered (gravel under red litter) removes the "colour plates" look in top and high views. It costs about 120 triangles per instance.
6. **Read tree type from silhouette before detail.** "Fluffy broadleaf" is many small puffs on a round canopy plus a thick flared trunk. "Palm" is few broad fronds plus a tan ringed trunk. Matching the type and count (2 palms per side, not 12) changed c4 more than any leaf detail did.
7. **Floating islands read as rock only with a thick cap and a hanging edge.** An overhanging grass lip and vines give the green-over-grey read even in haze. Haze tints a bare underside navy.
8. **Import recipe:** single computer-use calls went through. The `ctrl+a` key and the `wait` call were each refused with "user interrupt", but this did not matter: the name box was empty, so typing alone worked.
   - Arrival is fastest to confirm by polling the MeshPart count from Luau. The upload had finished by the first poll.

## Files
- `tools/ae_kit.py` (pass-6 section):
  - helpers: `ribbon_uy`, `ribbon_xz`, `lantern6`;
  - hero: `build_hero6`;
  - foliage: `build_palm6`, `build_fluffy6`, `build_deadtree6`, `build_litter6`;
  - skyline and ground: `build_island6`, `build_patch6`;
  - landmarks: `build_gothic6`, `build_spire6`, `build_exparch6`;
  - entry points: `build_all6`, `export_r6`.
- `ae_kit.blend` (saved), `kit/own/ae_kit_r6.fbx`.
- `fix/build_plaza.lua` (rewritten for r6), `fix/fix_lighting.lua` (the pass-5 ambient/contrast override removed, haze retinted).
- `out/r6/r6_*.png`, `out/cmp_r6.jpg`.
