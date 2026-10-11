# Fix brief, freestyle pass 27: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-24 judged frames are in `out/verify24/v24_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 27" section (`build_all27()`, `export_r27()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r27.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r27` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r27 out/r27`.

## Main PC notes (2026-10-11)
- The round-24 judged frames (`out/verify24/`) stayed on the Shadow PC. Recapture the reference frames you need from the reference
  studio with the same cameras (`cams.json` for the reference, `cams_practice.json` for the practice place; `capture_set2.py` with
  CAMS=...). The reference set from earlier is in `out/refset/`.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- Pass 27 was started on the Shadow PC and stopped before the kit export: `fix/pass27.lua`, `tex/make_ae_tex27.py`, `tex/leaf27/`
  and `out/r27w/` are its partial work, NOT applied in the saved place (which is pass 26). Reuse what is sound.
- Studio here is signed in to the original account; Import 3D uploads the r27 kit under it. That is expected.

## Inputs
`notes/verify24_plaza.md`: round-24 review (8.83/10, +0.16; eight cameras at 9, p4/p6/p8/c4 at 8.5). Every colour target comes with
its frame and pixel box: re-sample each from `out/verify24/v24_<cam>_ref.jpg` and match by measurement (one change per capture pair,
stop within ~15). Read it fully, and `notes/fix26_plaza.md` (prove pixel ownership with a red tint, skybox 0-35 deg band, vertex
colours need a re-export, contradictory targets on one surface, pick pixels inside a metric box).
Never send Delete/Backspace/Ctrl+A to Studio. Technology and post effects stay. Atmosphere Haze is settled: do not re-test it.
The four cameras still at 8.5 (p4, p6, p8, c4) are where the next points are; keep all eight 9s (re-check any 9 a change touches).
- Leaf saturation lives in vertex colours: re-export the blue/purple/gold leaf kit pieces with ~20-25 % less saturated vertex colours
  (own kit, `tools/ae_kit.py`), then measure c4/c1 top-half saturation and every 9.
- Stair joints: the review sees long smooth treads with no joints; pass 24/25 built 4.5-stud blocks with a joint slab. Prove what
  the c4/c2 tread pixels belong to (red tint) before rebuilding anything.
Stairs stay at 7 risers. Count triangles before export (each mesh < 20k). Save ae_kit.blend before long loops. Background pieces:
CastShadow off.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-24 order; full instructions with boxes in the review)
1. Leaf saturation down ~25 % by kit re-export of the leaf vertex colours (targets in the review: c4 ~86, c1 ~97 top-half).
2. Giant tree crown: dark, fully opaque lobes against open sky in p2/p6 (shadow sides darker than the lit tops).
3. Island canopies as rounded lumps, warmer, plus 2-3 translucent waterfalls off the island edges.
4. Stair tread joints visible in c4/c2 (after proving what the tread pixels are).
5. West half (holds p4/p8/p6): mixed trees (blue, purple, gold), pools, brighter lawn; pick inside the p7/p8 W metric boxes first.
6-10 if time: runner Y wider gold bands and core; gate glazing, crystal basins, Story crest; Raid gothic door and branches; bollards,
   Summon/Boss Rush facades, props; clear floor leaf decals, fern colour.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix27_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
