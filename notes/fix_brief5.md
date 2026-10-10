# Fix brief, freestyle pass 5: Anime Expeditions spawn plaza

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
  apply_unit_scale, mesh_smooth_type FACE, use_mesh_modifiers). Name the file `kit/own/ae_kit_r5.fbx`.
- Import: in the practice Studio window use Home > Import (the Import 3D button), pick the FBX, tick **Insert Using Scene
  Position** and **Anchored**, Import. Studio scales the FBX by 40.5585; `fix/build_plaza.lua` divides that out and
  moves the imported model into ServerStorage.Kit (update it to look for `ae_kit_r5`; it measures the import scale from a known piece, keep that). The Studio window can be brought
  forward with PowerShell `(New-Object -ComObject WScript.Shell).AppActivate(<pid>)`; the Malwarebytes pop-up sometimes
  steals focus: wait 4 s and retry.
- Placement: `fix/build_plaza.lua` (idempotent, own layout table). Run it with mcpcli: `cd C:/Users/aroki/Documents/animeexp_practice
  && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>` where the json is {studio_id, datamodel_type: "Edit", code}.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py <practice id> r5 out/r5` then
  `python tools/compare_sheet.py out/refset out/r5 r5 out/cmp_r5.jpg <cams>`.

## Inputs
`notes/verify2_plaza.md`: the round-2 review (4.33/10, up from 2.25) with a ranked top-10 and sizes/RGB. Read it fully, and
`notes/fix4_plaza.md` (what pass 4 built, its lessons). Keep everything pass 4 got right (layout, gates, stairs, emblem, landmark placement).

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (from the round-2 review, in its order)
1. Foliage at reference density: spiky leaf-card canopies (blue/purple/gold/red), palms 22-28 tall (2 per quadrant + north
   avenue), flat fern clumps 20-30 per quadrant by zone colour. Build these as own kit pieces (leaf cards = thin double-sided
   planes on bent stems; one tree generator with variants), instanced many times.
2. Skyline: own cloudy skybox without the c3 artefact; floating islands 60-120 across with ruins/waterfalls, 150-300 out, 60-140 up.
3. Colour pass per the review's RGB values (gold darker, runner and water less cyan, stone with darker bevels, floor, less neon).
4. Gate shape: crest ~13.5 as one squared U, deeper arch (6-7) with stepped ribs, basins tucked under the arch, foamy waterfall.
5. Lanterns ~1.45x on stone drums, tips ~30-32.
6. Landmarks re-proportioned and recoloured per the review.
7-10. Emblem, bollards, ground zoning and baseplate edge, lighting contrast.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix5_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
