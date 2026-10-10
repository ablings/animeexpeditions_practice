# Fix brief, freestyle pass 9: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-6 judged frames are in `out/verify6/v6_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 9" section (`build_all9()`, `export_r9()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r9.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r9` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r9 out/r9`.

## Inputs
`notes/verify6_plaza.md`: round-6 review against the LIVE reference (5.67/10). It corrects round 5 (provisional, overrated):
islands must be BIG and CLOSE and lush, the Raid must GLOW red (pass 8 went matte maroon), treads are fine as they are, and the
foliage should be flat spills, not mounds. Read it fully, and `notes/fix8_plaza.md` (pass-8 method and lessons). Keep what
matches; do not override Ambient/OutdoorAmbient.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-6 order; full instructions in the review)
1. Islands big, close, lush: slabs ~3x (80-120 studs), 110-170 out, undersides 50-80 up; grass caps (110,170,70) with 10-20 stud
   vines and 4-6 green trees each; grey ruins (175,180,175) 10x10x50 towers, an aqueduct and a rotunda; 2 falls each 6-10 x 40-60,
   (220,240,250) T 0.2; 3 cumulus banks behind.
2. Close the horizon with buildings 90-130 out: a cream-and-gold Guild facade ~50x40 with own "Guilds" sign, domed palaces with blue
   domes (40,80,170), 2-3 grey towers 8x8x60.
3. Raid as a glowing red set piece: lit faces (170,70,75), trim (90,35,45), a 25-stud skull (200,85,88) set into the facade with Neon
   eyes and the beam down to an own "Raid" sign ~16x5, three red PointLights (range 50, brightness 3), red fog at the base, black dead
   trees (40,30,35), a Boss Rush tower with a purple Neon portal. (Pass 8's lesson about washed-out lights stands: test it in captures.)
4. Fountain arches: side panels (134,170,186) -> slate (65,72,85) keeping gold edges; vault interior (35,45,55).
5. Fountain core: remove the egg dome and gold rods; dark slatted drum (50,60,70), a 4-stud water sheet (120,210,235) T 0.3 from a
   back ledge, spray; basin ~4 back under the arch.
6-10. Summon ornate arcade with gold trees and blue cypress; flat foliage spills and far-field ground (lagoon W, channel N, grey gravel
   E, white courtyard S); Story ring 3 deep with silver-blue frame; Expeditions triptych; plaza details. See the review.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix9_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
