# Fix brief, freestyle pass 19: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-16 judged frames are in `out/verify16/v16_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 19" section (`build_all19()`, `export_r19()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r19.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r19` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r19 out/r19`.

## Inputs
`notes/verify16_plaza.md`: round-16 review (7.75/10, up from 7.58; c1 and c2 to 8). This reviewer gave every colour target as a 5x5
mean with its reference frame and pixel box: re-sample each one yourself from `out/verify16/v16_<cam>_ref.jpg` before using it, and
match by measurement (one change per capture pair, stop within ~15). Read it fully, and `notes/fix18_plaza.md`. Never send
Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md). Technology and post effects match the reference: don't change them.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-16 order; full instructions with boxes in the review)
1. Arch narrower and darker (9 of 12 frames): about 1.45x too wide (c1 spans x 260-1195 vs the reference's 410-1045); pull the outer
   sweep in to ~70%; one thick ~3 band + one groove + the inner lip instead of 4-5 rings; bands dark slate (74,81,87), grooves (25,39,51),
   keep the thin gold rims; ear blocks merged into a U-handle ~1.5 higher. Measure the arch span in c1 against the reference after the change.
2. Arch interiors lit: a back wall (120,130,140) ~4 behind the fountain column, a cyan PointLight (120,220,255) b2 r12 per tunnel, a glowing
   water column; target (169,232,244) at p5_ref (718-722, 398-402).
3. Raid haze as red glow: (178,77,76) at p3_ref (643-647, 173-177) and (153,52,57) at c3_ref (1348-1352, 278-282); spread to the stair top;
   4-6 red PointLights at door height; a 2-stud ember band across the full facade. Keep the eight pass-18 boxes within 15.
4. East ground: down from 48% red / 1% green to ~34% / ~10%: remove ~30% of the red cards (mostly near the plaza), 15-20 grass holes of 4-8
   studs (118,167,50) with white flower dots.
5. Blue trees at about half size (~15), incl. the south-fountain trees and the west cluster; 2 slim blue cypresses ~14 framing the N stairs;
   remove the big blue crystals at the N stair top.
6-10 if time: bollards (white base, squat rounded gold head) and flat medallion discs; the c1 splat pair swapped and soft; softer grass and
   lawn strips; the south side and beach; skyline and close props.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix19_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
