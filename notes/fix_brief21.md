# Fix brief, freestyle pass 21: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-18 judged frames are in `out/verify18/v18_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 21" section (`build_all21()`, `export_r21()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r21.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r21` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885 r21 out/r21`.

## Inputs
`notes/verify18_plaza.md`: round-18 review (7.83/10, +0.08). Every colour target comes with its frame and pixel box: re-sample each
from `out/verify18/v18_<cam>_ref.jpg` and match by measurement (one change per capture pair, stop within ~15). Read it fully, and
`notes/fix20_plaza.md` (edge-pixel curve fitting, render-ratio colour scaling, camera-ray-to-plane tools in out/r20w/).
Never send Delete/Backspace/Ctrl+A to Studio. Technology and post effects match the reference: don't change them (Atmosphere is
an exception the review asks for: add one only if the reference frames' top-half saturation supports it, and measure it).

Before following any scale or count request, check it on every frame it concerns (pass 20 found two review sizes wrong).

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-18 order; full instructions with boxes in the review)
1. Background: replace the plain white box towers behind N/E/W with ruined arcade silhouettes (2-3 tiers of round arches) and two
   domed palaces; remove the round lollipop trees on the islands (2-3 irregular leaf-card canopies instead); falls and aqueduct if time.
   Measure the top-half saturation against the reference frames before and after.
2. West blue trees: cut ~40% (p8 blue cover 60% -> ~40%, p7 40% -> ~20%; boxes in the review), fill with palms, water, sand.
3. Arch: close the notch to a small dark U (remove the dark lintel and cyan slot), darken the outer slate to (36,46,54), add the gold
   tunnel ledge at a third of the opening height, fountain ~2 studs forward.
4. Stairs: risers (85,107,121); treads split into 4-6 stud bevelled blocks with offset joints; wedge spacers removed.
5. Grass: soft clumps (114,166,54) ~60% of the count; a lawn strip along the S and W stair-top lips.
6-10 if time: E/W cross arms 3x longer with raised gold-rimmed runners; Raid glow onto the tower and a rounded skull; teal basins
   (67,154,178); gate and Summon facade detail; splats, pineapple, E grass holes, duller bollard heads.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix21_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
