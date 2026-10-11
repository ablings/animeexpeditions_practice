# Fix brief, freestyle pass 23: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-20 judged frames are in `out/verify20/v20_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 23" section (`build_all23()`, `export_r23()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r23.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r23` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885 r23 out/r23`.

## Inputs
`notes/verify20_plaza.md`: round-20 review (8.21/10, +0.29). Every colour target comes with its frame and pixel box: re-sample each
from `out/verify20/v20_<cam>_ref.jpg` and match by measurement (one change per capture pair, stop within ~15). Read it fully, and
`notes/fix22_plaza.md` (Atmosphere knobs, fog-compressed colour response, step count by luminance projection, kit reuse, triangle limit).
Never send Delete/Backspace/Ctrl+A to Studio. Technology and post effects match the reference: don't change them.

Settle on the frames, not the prose:
- Atmosphere Haze: pass 21 measured Haze raising saturation and pass 22 kept Haze 0 at Density 0.28. The review asks Haze 1-1.5 with
  a green-grey colour; test it on ALL 12 cameras and keep it only if the set average of top-half saturation gets closer.
- Stair rows: pass 22 settled 8 risers by luminance projection; round 20 sees 6 rows in c4. Re-run the projection on v20_c4_ref
  before changing the count; tread length and edge (long slabs, crisp 0.15 chamfer) are the safe part of item 4.
- Kit export: count triangles before export (each mesh under 20k; split the stairs if needed). Save ae_kit.blend before long loops.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-20 order; full instructions with boxes in the review)
1. Falls as translucent curved ribbons (5-6 wide, transparency ~0.4, (200,235,243)) with a mist puff at the foot; the Haze test above.
2. Expeditions gate (filigree arch top, pale stone and gold pilasters, dark cloud-swirl door (3,121,134), two lamp posts, two small
   crystal fountains) and the Story portal as a smooth silver horseshoe ring with 6-8 blue gems.
3. Raid red: skull (213,112,95), haze glow (206,118,105), tower brick toward (225,86,89), a red facade light; sign onto the gable.
   The Raid boxes are re-baselined on the v20 frames: match these targets, not the pass-18 ones.
4. Stairs: long tread slabs (joints every 6-8 studs) with a crisp 0.15 chamfer, treads (186,191,185); the riser count only if the
   projection on v20_c4_ref says so.
5. Runners: gold rims (156,141,39) ~0.5 wide; slab and apron as one piece with a rounded foot and one gem; a larger, lower Y.
6-10 if time: Boss Rush purple gothic shrine and Summon cornice/medallion; foliage balance (W blue down a third, E red ground carpet,
   darker lawns); tunnel marble to slate and a limbed notch tree; E/W arms and medallion; bollards, pineapple, Story tree trunk.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix23_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
