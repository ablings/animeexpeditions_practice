# Fix brief, freestyle pass 22: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `1c7bc18a-1703-489c-bdcf-e4ced52e2a1b`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-19 judged frames are in `out/verify19/v19_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 22" section (`build_all22()`, `export_r22()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r22.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r22` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885 r22 out/r22`.

## Inputs
`notes/verify19_plaza.md`: round-19 review (7.92/10, +0.09). Every colour target comes with its frame and pixel box: re-sample each
from `out/verify19/v19_<cam>_ref.jpg` and match by measurement (one change per capture pair, stop within ~15). Read it fully, and
`notes/fix21_plaza.md` (SurfaceAppearance colour, appearance-class filters, two-point glass interpolation, plane projection).
Never send Delete/Backspace/Ctrl+A to Studio. Technology and post effects match the reference: don't change them.

Two review items conflict with what pass 21 measured; settle them on the frames, don't just follow the prose:
- Atmosphere: pass 21 found Haze 1 raised top-half saturation (114 -> 119). Try one low-haze/high-density setting with a pale
  colour, measure, and keep it only if saturation drops; otherwise paint distant pieces paler.
- Stair count: pass 21 counted ~6 risers in the reference; round 19 asks for ~8 at 0.75x height. Count the risers in v19_c4_ref,
  v19_c2_ref and v19_p1_ref yourself and build to the count.
Save ae_kit.blend before any long Studio loop (the PC session can drop).

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-19 order; full instructions with boxes in the review)
1. Background: break the island canopies into 3-4 lumps each in the reference mix (blue, purple, gold) with hanging vines under the
   rims; two wide translucent falls from the N islands and a 4-arch aqueduct between them; the Atmosphere test above.
2. Foliage density: red canopy trees and bushes on the E grey ground with lawn holes and white flowers; blue palms either side of
   the N avenue; a green palm cluster, sand and beach props in the S foreground instead of the white plinth paths.
3. Stair grass: delete ~60% of the round shrub balls, the rest as low flat fern sprays on the tread lips (114,166,54); a lawn strip
   2-3 deep at the S and W stair tops that shows in p2 under the gate (115,177,79).
4. Arch: replace the flat notch plug with a recessed U (~1.5 deep, floor ~2 below the ear tops) with pale band and gold rim, 2-3
   dark pods and a small tree inside; check the "1.17x too wide" on c1 by stud measurement before narrowing; tunnel back wall
   (44,54,62).
5. Runners: raised bevelled slabs angled toward the stairs, blue (84,141,230), thick gold rims (156,141,39), a cyan gem at the foot.
6-10 if time: E/W arms 3x longer; Raid skull lit and the haze swapped for a red tower glow; stair count/tread tone; facades;
   bollards, pineapple, fewer E red blobs.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix22_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
