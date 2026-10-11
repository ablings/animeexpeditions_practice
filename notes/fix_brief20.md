# Fix brief, freestyle pass 20: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-17 judged frames are in `out/verify17/v17_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 20" section (`build_all20()`, `export_r20()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r20.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r20` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r20 out/r20`.

## Inputs
`notes/verify17_plaza.md`: round-17 review (7.75/10, flat; real gains but no camera moved a full point). Every colour target comes
with its frame and pixel box: re-sample each from `out/verify17/v17_<cam>_ref.jpg` and match by measurement (one change per capture
pair, stop within ~15). Read it fully, and `notes/fix19_plaza.md` (stud measurement from frames, cutting old mesh, ray picks).
Never send Delete/Backspace/Ctrl+A to Studio. Technology and post effects match the reference: don't change them.

The score is on a plateau, so aim at the cameras closest to the next point: the review says c4 and p1 are near 9 (skyline, arches,
stair tone) and p2/p6/p7 are held at 7 by the unbuilt south side. Prefer items that touch several of those cameras.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-17 order; full instructions with boxes in the review)
1. Raid: light the building, not the sky: haze ~50% spread, no higher than the skull top, (162,66,74); red lights at door height (test,
   the pass-19 attempt overshot: measure the door frame box p3 693-697/298-302 to (181,108,114) and the side towers 848-852/168-172 to
   (124,39,59)); a 2-stud ember band across the facade base.
2. Arch: opening ~2 studs lower and wider at the base (low horseshoe; c1 top from y≈300 to ≈365 px), the outer slate band as two stepped
   1.5 bands with gold edges onto the stair rail; tunnel walls (44,54,61) with the cyan light down (b1, r8, aimed at the water); only the
   water bright (196,248,254); a sculpted splash ~3 tall instead of the glass tube.
3. Bollards ~60% height (white base (240,239,230) ~3x3x1.5, squat round gold head (223,214,144) ~1.5, no facets/point); remove the domed
   rim beads, keep the flat discs.
4. Stair tone: treads (158,164,162), risers (75,97,113) (c4 boxes in the review); 0.2 bevel, treads split into 4-6 stud blocks.
5. South side (holds p2/p6/p7): grey shard ring 1.3x and ~15 lower; gate 1.3x with a turquoise cloud door; a 30-stud green palm upper
   right; a sand beach (250,249,215) ~40x20 with a palm, pineapple and swim rings instead of the south lawn and path.
6-10 if time: soft grass clumps and lip strips; west blue trees thinned with palms, teal basins; east ground patches; splat saturation;
   skyline and close props.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix20_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
