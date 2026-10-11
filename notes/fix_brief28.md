# Fix brief, freestyle pass 28: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-25 judged frames are in `out/verify25/v25_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 28" section (`build_all28()`, `export_r28()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r28.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r28` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r28 out/r28`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify25/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 27 (Plaza 17575). Rebuild order is in notes/fix27_plaza.md; write your Studio side as `fix/pass28.lua`
  (idempotent, runs after pass 27) with measuring scripts in `out/r28w/`.
- Studio here is signed in to the original account; Import 3D uploads the r28 kit under it. That is expected.

## Inputs
`notes/verify25_plaza.md`: round-25 review (8.88; nine cameras at 9, p4/p6/p8 at 8.5). The judged frames are full size in
`out/verify25/v25_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix27_plaza.md` (its lessons: prove pixel ownership with a red
tint, a global colour fix moves every camera, re-read review boxes a new piece can cover, check "remove" items against the reference).
Never send Delete/Backspace/Ctrl+A to Studio. Technology and post effects stay. Atmosphere Haze is settled: do not re-test it.
Keep all nine 9s (re-check any 9 a change touches); p4, p6, p8 are where the next points are.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)

The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-25 order; full instructions with measured colours in the review)
1. Stair blocks overshot: blocks 3.5-4x as long as the step is high (4-6 studs), joints 0.08-0.1 stud and shallow, flatter tops,
   close the dark slot under each row (kit re-export via `build_stairs27` parameters; Stairs stay at 7 risers).
2. Colour accents and sky: palms back to ~(75,110,190), blue column trees ~(35,75,190), gold tree (191,150,71)-(221,183,78);
   sky top toward (70,190,240) keeping the horizon haze (own skybox, `tex/make_ae_tex26.py` approach). Target every camera within ~8
   of the reference top-half saturation without losing the c4/c1 match (the north desaturation stays where it is).
3. Islands and falls: brighter, whiter falls (T ~0.25, 30-60 studs), 2 more off the west islands; grey rock undersides; leafy lumps
   (163,188,129); remove or lower the grey disc at the top of p3.
4. Runner and Y: panel (60,100,215), gold rims ~3x wider, grey stone edge ~1 stud instead of the white edge, Y core (49,64,137);
   delete the stray blue water decal on the c4 steps.
5. West half (p4/p6/p8): a blue lagoon ~60 x 40 studs with blue palms on its edge in place of the lawn and sand discs; lawn
   (80,136,104) -> (112,181,61); replace the blocky green palm near the p7 camera.
6-10 if time: Expeditions gate (pale island band, opaque crown lobes, 8 stone crescents round the orb, crystal basins); Raid gothic
   door ~8x14 with keystone and bare branches, move the red tree hiding it; Story crest and ivy, palace corner for the white block
   in p4; bollard heads faceted dark gold (140,131,53), Summon white-gold front, Boss Rush purple shrine, parasols/stalls/lamps;
   translucent fountain jets, delete c2 red flower decals, c1 red clump (227,92,90), finer c2 fern spray.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5.
- Report `notes/fix28_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**
  (these go into the workflow vault), plus "Objects built" for 5 Object Recipes.
