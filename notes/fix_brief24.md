# Fix brief, freestyle pass 24: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-21 judged frames are in `out/verify21/v21_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 24" section (`build_all24()`, `export_r24()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r24.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r24` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885 r24 out/r24`.

## Inputs
`notes/verify21_plaza.md`: round-21 review (8.33/10, +0.12). Every colour target comes with its frame and pixel box: re-sample each
from `out/verify21/v21_<cam>_ref.jpg` and match by measurement (one change per capture pair, stop within ~15). Read it fully, and
`notes/fix23_plaza.md` (target pixel identity, lights as causes, translucent-against-sky, non-linear gold, bbox centres JSON).
Never send Delete/Backspace/Ctrl+A to Studio. Technology, post effects and Atmosphere (Density 0.28, Haze 0) stay as they are.

Settle on the frames:
- Raid: pass 23 measured tower 6 off, skull 8, haze 9 on the v20 boxes; round 21 reads the skull (146,107,104) and the tower
  (108,80,95), far off. Measure the v21 boxes on two captures (particles flicker); find which part or light makes the difference.
- Stairs stay at 7 risers (projection-settled). Item 4 is joints and tone only.
- Count triangles before export (each mesh < 20k). Save ae_kit.blend before long loops.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-21 order; full instructions with boxes in the review)
1. Fill the open N and S sky with content: 3-4 large background island masses with foliage and a fall each, 150-300 studs out on
   the N and S axes, tops 60-120 above the plaza, covering the upper third of p2 and c4; a giant tree (trunk 12-15 wide, 80+ tall,
   blue-green crown) behind the Expeditions gate. Measure top-half saturation p2/c4 before and after (targets ~105 / ~95).
   Reuse island and canopy kit pieces where possible.
2. E red ground carpet (194,82,75) under the red trees (p7 E red ~18 %, p8 ~35 %); W blue down a quarter (p8 ~36 %), flat W pools
   to canopy; S lawn darker (92,123,54).
3. Raid red mass: skull (207,108,93), a glow card or emitter in front of the brick at door height (226,124,111), tower toward red
   rock (176,77,62) with 2-3 rock spires.
4. Stair treads split into 4-5 stud blocks with a dark 0.15-0.2 chamfer line (99,113,122); flat grey stone (186,191,185), no mottled
   texture.
5. Runner Y outlined (two 0.3 gold lines, dark blue core) in the middle third, gold (183,175,89); a round cyan gem in a gold teardrop.
6-10 if time: gate glazed side panels and crystal basins; Summon and Boss Rush facades; bollards; layered falls; fountain ferns,
   notch tree, tunnel wall (44,54,62), Story ring crest.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix24_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
