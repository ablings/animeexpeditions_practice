# Fix brief, freestyle pass 17: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-14 judged frames are in `out/verify14/v14_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 17" section (`build_all17()`, `export_r17()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r17.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r17` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r17 out/r17`.

## Inputs
`notes/verify14_plaza.md`: round-14 review (7.50/10, up from 7.42; the Raid reads red, the north skyline is lush, the west is covered,
stairs have grass). Read it fully, and `notes/fix16_plaza.md`. Never send Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md). Technology
and post effects match the reference: don't change them.

**Lead's note on the Raid:** it has swung four rounds running (pink -> black -> mauve -> salmon). This time treat it as a measurement
problem: the target is the RENDERED value the reviewer sampled on the reference in p3 (stone about (95,45,55); lit arch rims peaking
near (200,70,65); skull and tower about (125,75,72); haze (200,60,50)). Change ONE thing at a time (base colour first, then each light),
re-capture p3 twice, sample the same 5x5 boxes as the review, and stop when each box is within ~15 per channel. Write the box
coordinates and every intermediate value into the report.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-14 order; full instructions with RGB and sizes in the review)
1. Raid as dark stone lit red (see the note): base (95,45,55) Slate/Brick, SpotLights re-aimed to graze edges and arch rims, skull and
   tower (125,75,72), haze (200,60,50) down to the stair top with no mauve edge, the dark-red palm moved in front-left of the door,
   3-4 recessed arch bands round the door.
2. Wing flanks (8 of 12 cameras): dark slate (52,61,64) with 2 recessed bands and a gold top rim, curving down toward the plaza (~6 at
   the pavilion to ~2 at the end). This is part of the hero mesh: re-export the hero with the wings as a separate mesh token if needed.
3. Summon and the avenue: clear ~20 either side of the avenue centre; a 5-arch colonnade ~30x18 (235,210,150) with a central dome, a
   gold statue and the sign; 4-6 stalls with umbrellas and bunting; a gold pineapple ~8 by the west pavilion.
4. East ground: ragged leaf-splat cards 3-6 across merged into patches (~60% near Raid to ~30% by the plaza), (187,53,54) with
   (130,30,35) edges and green holes; 2-3 gravel paths; 3-4 red palms.
5-10 if time: south side (grey shard ring 1.3x lower, gate 1.3x with a cloudy door and crystal fountains, palm, orange tree, domes);
   soft grass clumps and lawn strips; south beach; bollards 60% height with low white base and squat gold head; c1 splats and splash;
   Story trunk split higher and lettering; skyline falls and aqueduct.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix17_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
