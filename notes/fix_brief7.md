# Fix brief, freestyle pass 7: Anime Expeditions spawn plaza

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
  apply_unit_scale, mesh_smooth_type FACE, use_mesh_modifiers). Name the file `kit/own/ae_kit_r7.fbx`.
- Import: in the practice Studio window use Home > Import (the Import 3D button), pick the FBX, tick **Insert Using Scene
  Position** and **Anchored**, Import. Studio scales the FBX by 40.5585; `fix/build_plaza.lua` divides that out and
  moves the imported model into ServerStorage.Kit (update it to look for `ae_kit_r7`; it measures the import scale from a known piece, keep that). The Studio window can be brought
  forward with PowerShell `(New-Object -ComObject WScript.Shell).AppActivate(<pid>)`; the Malwarebytes pop-up sometimes
  steals focus: wait 4 s and retry.
- Placement: `fix/build_plaza.lua` (idempotent, own layout table). Run it with mcpcli: `cd C:/Users/aroki/Documents/animeexp_practice
  && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>` where the json is {studio_id, datamodel_type: "Edit", code}.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py <practice id> r7 out/r7` then
  `python tools/compare_sheet.py out/refset out/r7 r7 out/cmp_r7.jpg <cams>`.

## Inputs
`notes/verify4_plaza.md`: round-4 review (6.00/10, up from 5.17), ranked top-10 with RGB and sizes; read it fully, and
`notes/fix6_plaza.md` (pass 6 and lessons: the kit imports turned 180 degrees and the placement helper compensates; the
Lighting is back to the reference values - do NOT override Ambient/OutdoorAmbient again). Keep everything that matches.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-4 review order)
1. Islands: rock (137,148,145), wide irregular slabs, ~1.5x farther and 30 higher, clustered vines, ~40-stud ruins, 3-4 wide waterfalls, big clouds.
2. Raid landmark: carved skull (125,85,72) with glowing red eyes and a red beam, darker walls (150,65,65), side towers and
   arcade wings ~3x wider, red light and haze. Use an own simple "Raid" sign text (generic word, own font).
3. Grass/bush clumps: 6-10 mounded clumps per flight (3-5 across), yellow-green (150,178,75); lawns at the top of S and W stairs.
4. Stairs value: steps ~(110,118,128), risers (75,85,95), pale nosing (190,192,190).
5. Summon hall back ~15 as an ornate cream-and-gold facade with own sign; umbrellas/stalls along the avenue; north runner ~25% narrower.
6-10. Expeditions arch x1.7 with floating rock shards; Story ring black + crown + thicker tree; basins back/smaller with spray;
   ground/horizon fixes; medallion/crest/floor/bollard details - per the review.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix7_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).

## Shadow PC click positions (single 1920x1080 screen, Studio maximised, frame 1456x819)
- Home > Import 3D button: (570, 80). Open dialog File name box: (350, 378), Open: (598, 401).
- Import Preview (as in the RIVALS sessions on this PC): Insert Using Scene Position (871, 370), Anchored (871, 457), Import (967, 646). Both ticks reset each time; zoom to confirm.
- File menu: (12, 25); Save to File: (40, 211).
- Practice studio_id `aa9c5bb9-9006-4f4c-9b3b-feba1f0b256d`; paths: `C:/Users/Shadow/...` instead of `C:/Users/aroki/...`.
