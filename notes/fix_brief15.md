# Fix brief, freestyle pass 15: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-12 judged frames are in `out/verify12/v12_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 15" section (`build_all15()`, `export_r15()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r15.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r15` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r15 out/r15`.

## Inputs
`notes/verify12_plaza.md`: round-12 review (7.33/10, up from 7.25; blue leaf colour, Story, islands in c3, Raid haze and the horizon
now match). Gains have been under 0.25 for two rounds, so this pass goes after the three items the reviewer ranks biggest and does
them thoroughly, rather than many small ones. Read it fully, and `notes/fix14_plaza.md` (the fine leaf method). Never send
Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md). Technology and post effects match the reference: don't change them.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-12 order; full instructions with RGB and sizes in the review)
1. Clump interiors: no visible flat facets. Drop each clump's inner crossed filler shell and any card over 2.5 studs; fill with
   120-200 cards of 1-2 studs at random orientations (no two neighbours in one plane), normals out of the clump centre; keep each
   tree under ~5k triangles. Gold: merge 3-5 balls into one uneven canopy ~30x20 behind Summon, shadow (170,130,55). New kit r15,
   same swap (pass13/pass14 holding folder), test one clump from front AND behind before swapping.
2. Raid balance: skull brick-rose (150,80,72) with (230,125,110) highlights from a small PointLight (255,90,80) range 20, dark sockets
   (60,15,20); a tapering carved pillar instead of the two-tier pink plinth; facade (95,40,45) with (130,60,60) trim, 2-3 red uplights
   from the stair foot (back off until the stone reads as stone washed in red, not black); haze widened to a ~60 band; the island
   above Raid up or out by 25+ so it no longer clips the skull in p3.
3. Islands out of the player-height views: N islands ~40 further out (or ~20 higher), the S/SW island ~50 out, so c4/p1/p6 show
   sky in their top 130-200 px like the reference; falls 3-4 wide (200,235,255) T 0.3 with mist; grass spilling over the edges.
4-10 only if time remains: bollards and medallion; west quarter (lagoon ring of blue clumps and palms, wider Story canopy with
   gnarled limbs); arch wings and pods; ground litter splats; stair tufts; N avenue; south side.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix15_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
