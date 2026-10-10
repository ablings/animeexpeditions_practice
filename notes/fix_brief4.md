# Fix brief, freestyle pass 4: Anime Expeditions spawn plaza

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
  apply_unit_scale, mesh_smooth_type FACE, use_mesh_modifiers). Name the file `kit/own/ae_kit_r4.fbx`.
- Import: in the practice Studio window use Home > Import (the Import 3D button), pick the FBX, tick **Insert Using Scene
  Position** and **Anchored**, Import. Studio scales the FBX by 40.5585; `fix/build_plaza.lua` divides that out and
  moves the imported model into ServerStorage.Kit (update it to look for `ae_kit_r4`). The Studio window can be brought
  forward with PowerShell `(New-Object -ComObject WScript.Shell).AppActivate(<pid>)`; the Malwarebytes pop-up sometimes
  steals focus: wait 4 s and retry.
- Placement: `fix/build_plaza.lua` (idempotent, own layout table). Run it with mcpcli: `cd C:/Users/aroki/Documents/animeexp_practice
  && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>` where the json is {studio_id, datamodel_type: "Edit", code}.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py <practice id> r4 out/r4` then
  `python tools/compare_sheet.py out/refset out/r4 r4 out/cmp_r4.jpg <cams>`.

## Inputs
`notes/verify1_plaza.md`: the round-1 review (2.25/10) with a ranked top-10 and sizes. Read it fully.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (from the review)
1. Corners: open arched fountain gates facing the centre on the diagonal (~16 wide, ~12 tall, crest 16-17), two-tier basin
   in front, open pool ~35x35 with a low rim behind, back wall dark slate (not black).
2. Lanterns on the arch shoulders (pedestal, gold columns around a cyan glowing core, ribbed blue dome, spike tip 24-26).
3. Stairs: feet at ~27 studs from centre, 6-7 steps, runner flush with a gold Y-chevron inlay; white pedestals with gold caps
   instead of the blue boxes.
4. Floor: pale stone slabs ~6x6 with slate bands, thin flush gold inlays (no raised bars); emblem 8 hooked blades ~15 studs.
5. Arms: E/W/S ~17 wide with pointed ends, N ~37 with a water channel; ground: grass, sand, water instead of a flat plate.
6. Foliage: fluffy blue/purple/gold trees 18-22 tall; coral (225,85,75) bushes; palms 20-25 tall with 8-10 fronds, or none.
7. Simple blockout landmarks at each stair top (Summon hall N, teal Expeditions portal S, red Raid skull tower E, Story ring
   portal under a giant blue tree W) and a few floating islands on the skyline, so no view ends in empty sky.
8. Sky: an own cloudy skybox (generate with Python like the Sniper Duels sky: `C:/Users/aroki/Documents/sniperduels_practice/tex/sky/make_sky.py`),
   upload with mcp__Roblox_Studio__upload_image from the file server http://127.0.0.1:8767/ (already running; serves this repo).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix4_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
