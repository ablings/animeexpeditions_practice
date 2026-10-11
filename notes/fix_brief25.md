# Fix brief, freestyle pass 25: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-22 judged frames are in `out/verify22/v22_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 25" section (`build_all25()`, `export_r25()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r25.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r25` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885 r25 out/r25`.

## Inputs
`notes/verify22_plaza.md`: round-22 review (8.46/10, +0.13; p3 at 9). Every colour target comes with its frame and pixel box:
re-sample each from `out/verify22/v22_<cam>_ref.jpg` and match by measurement (one change per capture pair, stop within ~15). Read it
fully, and `notes/fix24_plaza.md` (same-pixel check before calling a contradiction, place by the feature not the bbox, background
shadows, draped ribbons, unmovable channels are light).
Never send Delete/Backspace/Ctrl+A to Studio. Technology, post effects and Atmosphere (Density 0.28, Haze 0) stay as they are.
Stairs stay at 7 risers. Count triangles before export (each mesh < 20k). Save ae_kit.blend before long loops. Background pieces:
CastShadow off. Don't lose p3's 9: re-check p3 after every Raid change.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-22 order; full instructions with boxes in the review)
1. Background islands: push ~100 studs further out and lower so their green, ruin-topped tops show from the stairs (p1/c3/c4 top
   band toward (188,209,167)); warm the undersides; remove the pale vine fringe. Re-measure top-half saturation on all 12.
2. Raid glow: replace the pink bubble domes with glow cards or particles hugging the facade; 3-4 rock spires; brick retint. Keep p3.
3. Runner Y smaller: 0.4 outline, arms across ~60 % of the runner width, a long stem down to the gem (likely a re-export).
4. E ground balance: a green lawn strip back along the plaza edge (p7 green toward 25 %), grey paving paths through the red, red
   (197,89,76), remove the flat grey slab east of the plaza.
5. Giant tree crown greener (98,156,145) in 3-4 lobes; trunk ~20 studs west of the gate axis.
6-10 if time: W blue canopy thinned with mixed tree colours (p8 ~37 %); standing 3D fern clumps instead of flat floor splashes at the
   stair edges and fountain bases; risers (85,103,115) with a dark joint line, less rounded treads; gate glazed cyan panels and
   crystal basins, Story crest; Summon front, Boss Rush shrine, dark-gold faceted bollard heads, translucent falls.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix25_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
