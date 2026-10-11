# Fix brief, freestyle pass 14: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-11 judged frames are in `out/verify11/v11_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 14" section (`build_all14()`, `export_r14()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r14.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r14` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r14 out/r14`.

## Inputs
`notes/verify11_plaza.md`: round-11 review (7.25/10, up from 7.17). The leaf-card method is right but the cards are too big: up
close each clump breaks into a few flat planes ("crumpled paper"), lit faces glint pale, gold goes olive in shade. Read it fully, and
`notes/fix13_plaza.md` (the foliage method). Never send Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md). Technology and post effects
match the reference: don't change them.

**Lead's finding:** the "two white plinths at the Raid door" (three rounds running) are the rail and balusters of the pass-12 EAST
terrace, `Workspace.Plaza.Pass12.Terraces12` (TerraceRail at (94,7.9,-14.5), TerraceBalusters at x 89.5 and 98.5, z +-14.5): the
Raid moved east onto them. Remove or relocate the east terrace in `fix/pass12.lua` / `build_plaza.lua` (keep the west one), and check
p3 afterwards. Always ray the reviewer's pixels before deciding what an object is.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-11 order; full instructions with RGB and sizes in the review)
1. Foliage refinement (new kit r14, rebuilt from the pass-13 generator): leaf cards 1.5-2.5 studs, 40-80 cards per clump; leaf
   textures carrying 15-30 small leaves of 0.3-0.5 studs per card (repaint them finer); SurfaceAppearance with no glint (Roughness
   map 1 / Metalness 0, or the equivalent); a dark-core to bright-tip gradient baked into the textures or the inner/rim split: blue
   (10,40,150)->(60,150,255), gold (170,120,30)->(250,210,90), purple (110,70,170)->(200,160,245). Keep each tree under ~4k
   triangles. Swap the same way as pass 13 (idempotent holding folder).
2. Raid: the east terrace fix above; red haze (230,40,40)-ish behind and around the facade (not in front of the skull), so the skull
   is the focal point again; facade dark maroon (100,25,30); skull dusty rose (225,100,105) with a small red light. Measure on p3.
3. Islands: N/NE/NW 20-25 higher and 30 further out; towers 35-50; one aqueduct span; streams 2-3 wide (200,235,255) T 0.3 with mist.
4. Horizon: extend the ring to ~200 out so p7's top corners show no baseplate; far trees grouped in 3-5 with no trunks showing; grey
   palace domes at S/E.
5. Story: trunk upright and thick (8-10 at the base, it still lies across p8), a ~60 dome canopy with hanging moss, a carved
   silver-blue frame round a dark opening (no graphic spiral), a stepped white arena ~40 across.
6-10. Bollards and medallion; arch wings and crystal pods; ground litter as ragged splats (blue on the Summon side, red on the Raid
   side); N avenue (pineapple, hedges, bunting, Summon arcade and statue); S side (grey shard ring, gate 1.2x with crystal fountains,
   palm, orange tree, stair tufts).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix14_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
