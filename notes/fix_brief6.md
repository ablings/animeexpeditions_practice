# Fix brief, freestyle pass 6: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have
- Picture set: `out/refset/ref_<cam>.png` (12 cameras, `cams.json`; practice cameras = x-3000, y-3: `cams_practice.json`).
  You may also screen_capture the REFERENCE studio (`ecdeebfb-c2e0-4ac2-b13e-69e509aee13d`, read-only, screen_capture only,
  never execute_luau there) from any extra camera you like, to see a piece from more angles.
- Practice place: studio `efa46ce6-9954-4c7c-87c2-a920fb1fc6e9` (`AE_practice.rbxl`). execute_luau and screen_capture allowed.
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export (Blender is Z-up; Roblox gets Y-up from the FBX). Export FBX like the existing
  r3 export (see the end of the ae_kit.py history in git, or use the same export call: use_selection, object_types MESH,
  apply_unit_scale, mesh_smooth_type FACE, use_mesh_modifiers). Name the file `kit/own/ae_kit_r6.fbx`.
- Import: in the practice Studio window use Home > Import (the Import 3D button), pick the FBX, tick **Insert Using Scene
  Position** and **Anchored**, Import. Studio scales the FBX by 40.5585; `fix/build_plaza.lua` divides that out and
  moves the imported model into ServerStorage.Kit (update it to look for `ae_kit_r6`; it measures the import scale from a known piece, keep that). The Studio window can be brought
  forward with PowerShell `(New-Object -ComObject WScript.Shell).AppActivate(<pid>)`; the Malwarebytes pop-up sometimes
  steals focus: wait 4 s and retry.
- Placement: `fix/build_plaza.lua` (idempotent, own layout table). Run it with mcpcli: `cd C:/Users/aroki/Documents/animeexp_practice
  && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>` where the json is {studio_id, datamodel_type: "Edit", code}.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py <practice id> r6 out/r6` then
  `python tools/compare_sheet.py out/refset out/r6 r6 out/cmp_r6.jpg <cams>`.

## Inputs
`notes/verify3_plaza.md`: round-3 review (5.17/10, up from 4.33) with a ranked top-10 and RGB/sizes; read it fully, and
`notes/fix5_plaza.md` (pass 5 and its lessons). Keep everything that already matches (layout, gate shapes, stairs, emblem placement, foliage kit).

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-3 review order)
1. Shading: gate/crest/basin stone neutral grey (~150,155,165), vault interiors (~60,68,85) with a small cyan PointLight
   inside each vault. IMPORTANT: the Lighting settings are the reference's own values (fix/fix_lighting.lua) - the reference
   looks lighter in shade because its painted textures carry baked light. Fix this first with colours/value in our meshes
   (lighter stone, lighter undersides, an emissive-ish lit band) and only adjust Ambient/OutdoorAmbient as a last resort,
   noting any change in the report.
2. Skyline islands: rock undersides with green caps and vines, ~2x larger, 3-4 north/northeast at 150-300 out; ruined white towers; softer sky.
3. Trees: thin the avenue to 2 palms per side (~22 tall, tan trunks, broad fronds), remove ~70% of palms/cones; a gold tree
   (~25 canopy) at about (-15,-95), purple trees at +x 15-25 / -z 85-100, a blue tree with crystals behind each gate; fix the c3 palm bundle.
4. Ground zoning with organic edges (west grass+water, east red litter on gravel, north/south grass+sand).
5. Crest notch/arms and lanterns (lower 2, 10 gold ribs, glass (85,140,185) with a bright core).
6. Gold trims as flat inset bands (200,172,60); medallion recolour and thin hooked blades.
7. Landmarks (Raid, Expeditions, Story) per the review.
8-10. Basins forward, real water sheet instead of the cyan slab; litter/grass on stairs; risers, grout, slate bands.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix6_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
