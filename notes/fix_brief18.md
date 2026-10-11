# Fix brief, freestyle pass 18: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-15 judged frames are in `out/verify15/v15_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 18" section (`build_all18()`, `export_r18()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r18.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r18` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r18 out/r18`.

## Inputs
`notes/verify15_plaza.md`: round-15 review (7.58/10, up from 7.50; Summon and the east ground landed). Read it fully, and
`notes/fix17_plaza.md`. Never send Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md). Technology and post effects match the reference.

**Lead's finding on the Raid: the pass-17 targets were wrong.** They came from a reviewer's prose, not from the reference frame. Sampled
by the lead on `out/verify15/v15_p3_spawn_e_ref.jpg` at pass 17's own boxes (5x5 means, 1452x793):
| box | pixel | REFERENCE (true target) | practice now |
|---|---|---|---|
| skull forehead | (725,35) | (230,152,130) | (127,80,81) |
| tower under skull | (690,150) | (150,86,72) | (132,74,69) |
| door arch rim | (700,315) | (154,80,76) | (213,86,81) |
| haze L / R | (620,165)/(830,160) | (147,76,67) / (150,80,71) | (198,69,57) / (206,75,60) |
| shaded wall right | (790,330) | (78,24,37) | (84,25,39) |
| lower facade by door L / R | (650,330)/(760,340) | (125,61,72) / (137,44,58) | (174,76,91) / (139,54,71) |
(stoneA at (670,260) hits a different object in the reference; skip it.) **Take every target from the reference frame yourself** (sample
`v15_*_ref.jpg`, or a fresh reference capture from the same camera), never from review text. Same loop as pass 17: one change per capture
pair, the boxes above, stop within ~15. The skull needs to be much LIGHTER and warmer (lit from above, as the reviewer says: red
SpotLights from the roof line), the haze less saturated, the rim dimmer, the lower facade darker.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-15 order; full instructions with RGB and sizes in the review)
1. Wing flanks: no pale tops. Tops slate (55,65,75) with a thin gold (200,165,60) rim on the outer edge only; merge each flank into the
   arch (outer band ~3 thick, 2 grooves (40,48,58)), sweeping down into the stair balustrade ~8 out; delete the black plinth blocks under
   the slide ends. Verify on c1, c2, p6 (sample the reference frames for the flank top colour first).
2. Raid by measurement with the corrected targets above (skull lit from the roof line, haze spread into 3-4 emitters from the stair top to
   the skull, a low red fire line ~1.5 tall along the base).
3. Big red palm ~25 in front of the Raid, crown at skull height, ~6 toward the plaza so it breaks the sky in c3; 8-10 drooping fronds.
4. East splats: cards 1.5x and overlapping (~60% near Raid to ~30%), (185,55,55) with (130,30,35) edge cards, 10-15 green holes; ~50% red
   on the east stair treads.
5-10 if time: south side; corner blue trees halved; softer grass and lip strips; bollards and flat medallion studs; skyline falls,
   aqueduct and ruined towers; close-up props (c1 splats, fountain splash, pineapple, beach).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix18_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
