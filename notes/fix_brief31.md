# Fix brief, freestyle pass 31: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-28 judged frames are in `out/verify28/v28_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 31" section (`build_all31()`, `export_r31()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r31.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r31` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r31 out/r31`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify28/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 30 (Plaza 18390). Rebuild order is in notes/fix30_plaza.md; write your Studio side as `fix/pass31.lua`
  (idempotent, runs after pass 30) with measuring scripts in `out/r31w/`.
- Studio here is signed in to the original account; Import 3D uploads the r31 kit under it. That is expected.

## Inputs
`notes/verify28_plaza.md`: round-28 review (9.13; p3, p4 and c4 at 9.5, the rest at 9). The judged frames are full size in
`out/verify28/v28_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix29_plaza.md` and `notes/fix30_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-28 order; full instructions with measured colours in the review)
1. Falls (c3, c4, p1): the opaque white strips (254,254,254) read as columns holding the islands up. Planes 3-4 wide, T 0.4,
   (200,240,250), fading toward the bottom (a gradient texture of your own, or stacked segments with rising transparency), a mist
   emitter at the foot, each fall ending 10-20 studs above the canopy. Target (204,243,250). Includes the old pass-23 strips.
2. Jets (9 cameras): colour now matches; change the shape. 4-6 thin curved sheets ~0.3 x 2.5, T 0.35, arcing over the basin lip
   (a small kit mesh is fine), streak particles (speed 6-8, lifetime 0.6, gravity -20) in place of the round puffs.
3. Ground colour: south lawn (108,194,102) -> (112,181,60); join the east red blobs into a continuous carpet (220,60,60) over ~70 %
   of that ground; lagoon (76,122,206) -> (35,90,150); red ground cover on the p3 stairs. Keep the c2 lime fern (190,234,98): pass 30
   turned that spot into a red clump.
4. Expeditions gate (p2, p6): glowing portal plane (15,170,185) T 0.3 in place of the painted spiral; two crystal basins ~4 wide;
   raise the orb ~10 studs (cropped at the top of p6, lower half on the island band in p2).
5. Bollards: slim grey (200,205,210) post ~2 x 2 x 3 with a gold (220,180,60) dome ~1.2, in place of the white slab and pyramid.
6-10 if time: Boss Rush PointLight (220,60,160) range 20 brightness 2 and magenta door trim; Summon bunting above the cornice, bright
   arched entry (229,229,209) with a gold emblem, canopy around it ~10 % less saturated (c4 94 vs 80); palms (85,115,181), p1 gold
   tree (219,180,78); arch stepped inner bands, (70,80,95) band, 0.3 chamfer, faint blue glow; parasols, stalls, lamp posts,
   statues at the Summon stair top; Story ring glow plane (20,40,110).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint.
- Report `notes/fix31_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
