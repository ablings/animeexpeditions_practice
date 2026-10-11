# Fix brief, freestyle pass 32: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-29 judged frames are in `out/verify29/v29_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 32" section (`build_all32()`, `export_r32()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r32.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r32` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r32 out/r32`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify29/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 31 (Plaza 19177). Rebuild order is in notes/fix31_plaza.md; write your Studio side as `fix/pass32.lua`
  (idempotent, runs after pass 31) with measuring scripts in `out/r32w/`.
- Studio here is signed in to the original account; Import 3D uploads the r32 kit under it. That is expected.

## Inputs
`notes/verify29_plaza.md`: round-29 review (9.21; p3, p4, c1, c2, c4 at 9.5, the rest at 9). The judged frames are full size in
`out/verify29/v29_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix30_plaza.md` and `notes/fix31_plaza.md` (their lessons: prove pixel ownership with a red
tint, a global colour fix moves every camera, re-read review boxes a new piece can cover, check "remove" items against the reference).
Never send Delete/Backspace/Ctrl+A to Studio. Technology and post effects stay. Atmosphere Haze is settled: do not re-test it.
Keep every 9 and 9.5 (re-check any 9 a change touches); p4, p6, p8 are where the next points are.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)

The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-29 order; full instructions with measured colours and pixel positions in the review)
1. Falls (c3, c4, p1): from grey-opaque (215,219,210) to glowing (195,240,249), T 0.45 top -> 0.85 foot, a 1-stud Neon core
   (230,250,255), 4-6 studs wide. Target (198,242,249) at c4 (670,230).
2. Sky gaps (p6 17 under in saturation, p3 16 under): blue palms and canopy (72,124,198) 25-35 tall behind the Story tree in p6
   (now sky (154,211,238)); a dark tree or rock mass (93,76,59) ~30 tall left of the Raid in p3; tone the beige island underside
   in p4 to (125,135,125) (it cost p4 3 saturation; p4 is a 9.5).
3. Expeditions portal (p2, p6): darken (0,174,200) -> (5,110,125), own swirl decal with a light core (60,200,200); raise the orb
   ring ~8 so its lower half leaves the island band at p2 (720,200) (check p6 stays uncropped).
4. Bollards: ~1.5 studs tall, 3 x 2 base slab with a 0.3 chamfer, (175,172,150), keep the gold dome.
5. Ground tints: south lawn (121,188,97) -> (112,181,60) (lighting owns some blue: cover if needed); lagoon (71,103,172) ->
   (35,90,148); p8 south-east gaps filled red, red trees (222,154,149) -> toward (150,70,65), grey rubble (106,112,106).
6-10 if time: fountain niche interior (61,105,129) -> (10,25,40), jet egg core T 0.4 and ~40 % smaller, back-niche water sheet
   (171,209,222); Summon bunting above the cornice, bright arched entry (226,224,174), canopy saturation -6 at c4; Boss Rush
   facade (55,35,60) with a magenta light range 20 brightness 2; arch stepped inner bands (70,80,95) and 0.3 chamfer; Story ring
   interior (5,10,20) with a blue rim glow (40,80,160); parasols, stalls, lamps, statues on the Summon stair top.
Five cameras are at 9.5 (p3, p4, c1, c2, c4): re-check each after any change it can see.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint.
- Do not overwrite tracked files outside your pass (pass 31 overwrote cmd/count.json); keep scratch in out/r32w/.
- Report `notes/fix32_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
