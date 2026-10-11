# Fix brief, freestyle pass 26: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-23 judged frames are in `out/verify23/v23_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 26" section (`build_all26()`, `export_r26()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r26.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r26` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885 r26 out/r26`.

## Inputs
`notes/verify23_plaza.md`: round-23 review (8.67/10, +0.21; p1, p3, p7, c3 at 9). Every colour target comes with its frame and pixel
box: re-sample each from `out/verify23/v23_<cam>_ref.jpg` and match by measurement (one change per capture pair, stop within ~15).
Read it fully, and `notes/fix25_plaza.md` (rim dressing, pale distant colour, opening the sky exposes the skybox, glow cards, riser
split by normal, stroke widths through the camera).
Never send Delete/Backspace/Ctrl+A to Studio. Technology and post effects stay. Atmosphere Haze is settled (rejected on all 12
cameras in passes 21 and 23): do not re-test it. The sky fix is the skybox itself: our own skybox (vault 7.10, built in an
earlier pass) is cyan (60,196,240) where the reference sky is pale hazy blue with cloud (172,215,236) at v23_p2 box 760-764/20-24.
Rebuild or recolour our own skybox images toward that (own images only), then measure top-half saturation on all 12.
Risers: pass 25 measured 11 off, round 23 reads (109,137,149) vs (85,103,115) at c4 428-432/646-650 — pick the part under that box
and check its material/colour in Place1 before changing anything.
Stairs stay at 7 risers. Count triangles before export (each mesh < 20k). Save ae_kit.blend before long loops. Background pieces:
CastShadow off. Keep the four 9s (p1, p3, p7, c3): re-check them after each change that touches them.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-23 order; full instructions with boxes in the review)
1. Sky: our skybox paler and cloudier toward (172,215,236); if top-half saturation is still high, drop the blue/purple leaf
   saturation ~10 %. Targets: c4 ~95, c1 ~105, p1 ~88.
2. Island canopies yellow-green (152,192,134) in 3-5 rounded lumps each; the mass above Summon darker (152,162,159); hide the grey
   undersides left in the frame corners (p1, p2, p3); translucent falls (130,187,218) off W/N island edges.
3. Giant tree crown opaque, shadow sides (80,140,110), lit tops (100,156,146); no pale island directly behind it in p2.
4. Stair stone: risers (85,103,115) after checking the part under the box; dark 0.15 joints (70,85,95) every 4-6 studs; a tread-edge
   highlight.
5. Ferns ~60 % size, flatter sprays, (114,166,54), blue on the W side and red on the E; remove the flat c1 floor splats and put clumps
   on those stair edges.
6-10 if time: runner Y outline ~0.5 wide (196,176,59), arms filled with the core, rim (183,175,89); W canopy as 6-10 mixed trees and
   pools, lawn (91,126,55); gate glazed panels and basins, Story ring rim and crest; Raid gothic door and bare branches, brick red
   rock; Summon/Boss Rush, faceted bollard heads, parasols and lamps.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix26_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
