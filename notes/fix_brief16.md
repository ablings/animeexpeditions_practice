# Fix brief, freestyle pass 16: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-13 judged frames are in `out/verify13/v13_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 16" section (`build_all16()`, `export_r16()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r16.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r16` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r16 out/r16`.

## Inputs
`notes/verify13_plaza.md`: round-13 review (7.42/10, up from 7.33; clump facets, the toy skull and the islands over the spawn views
are fixed). The reviewer says what is left is mostly **missing pieces** plus red light on the Raid, so this pass builds. Read it
fully, and `notes/fix15_plaza.md`. Never send Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md). Technology and post effects match
the reference: don't change them. Reuse existing kit pieces and Parts where they do the job; export new meshes only where needed.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-13 order; full instructions with RGB and sizes in the review)
1. Raid lit red: replace the round halo with a ~60x40 band (200,70,60) hugging the temple from stair top to spires; 3-4 red SpotLights
   (255,60,50) aimed up the facade from the stair foot (find values where the stone reads red-washed, not flat red: test one change
   at a time, sample one pixel); a doorway glow (PointLight + red Neon strip in the arch); a 3-stud carved keystone skull instead of
   the pink plinth-and-skull over the door; an upright dark-red palm ~20 left of the door.
2. Skyline as a lush backdrop: keep the top ~120 px clear at player height, but scale the N islands 1.5-2x and lower them 10-15 behind
   Summon so they fill ~y 80-300 in c4; green grass and vines hanging 6-10 over the edges, 2-3 trees each, two 3-4 wide falls with mist
   in c4 and two in c3, towers 35-50, one 4-arch aqueduct.
3. Bollards and medallion (foreground of every spawn view): squat grey (150,155,160) stone bollards ~3x3x2.5 with a pointed faceted gold
   cap ~2 tall; medallion of 8 thin hooked dark blades (45,55,65), a gold hub and 8 gold rim studs.
4. West quarter: a ~50x40 lagoon (60,170,220) ringed by blue clumps and 4-6 blue palms; a stepped white arena ~40 round the Story tree;
   80%+ of the west ground covered; Story trunk with 4-5 gnarled limbs, canopy ~75.
5. Grass on the S and W stairs: 12-20 tufts 2-3 tall (110,200,60) on treads and stair tops, long grass strips along the lips.
6-10 if time: foliage depth shading (core/outer/tip per family), Summon arcade facade with statue, stalls, bunting and a pineapple;
   wing flanks and pods; ground litter splats; south side.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix16_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
