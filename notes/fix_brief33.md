# Fix brief, freestyle pass 33: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-30 judged frames are in `out/verify30/v30_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 33" section (`build_all33()`, `export_r33()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r33.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r33` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r33 out/r33`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify30/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 32 (Plaza 20209). Rebuild order is in notes/fix32_plaza.md; write your Studio side as `fix/pass33.lua`
  (idempotent, runs after pass 32) with measuring scripts in `out/r33w/`.
- Studio here is signed in to the original account; Import 3D uploads the r33 kit under it. That is expected.

## Inputs
`notes/verify30_plaza.md`: round-30 review (9.29; p3, p4, p5, p6, c1, c2, c4 at 9.5; p1, p2, p7, p8, c3 at 9). The judged frames are full size in
`out/verify30/v30_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix31_plaza.md` and `notes/fix32_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-30 order; full instructions with measured colours and pixel positions in the review)
The 9s left are p1, p2, p7, p8, c3: favour fixes those cameras see. Seven cameras at 9.5: re-check each after any change it sees.
1. p3 sky gap (largest saturation gap, -17): a dark mass (93,76,58) ~30 x 25 that actually shows from the p3 camera, covering p3
   x 120-300, y 100-280 (now sky (92,166,235)); prove it in a p3 capture before moving on. Darken the Boss Rush block (25,22,28)
   and the Raid door (99,81,87) -> (5,16,18).
2. East ground (p8, p7): red (239,107,95) -> (170,55,50) (set darker: sunlit red renders lighter); a grey rubble band (95,103,103)
   ~25 wide east from the E stair; a dark rock mass (50,53,51) ~30 x 30 in the SE corner; 4-6 green patches (124,172,47) in the
   red; thin the red trees by about a third.
3. Arch face (9 cameras): (133,143,145) -> (75,80,80), a 1-stud chamfered inner band (150,155,155) and one stepped bevel.
4. Lagoon (73,102,165) -> (43,95,147) and south lawn (121,188,97) -> (111,181,60), unchanged two rounds: cover the lawn with own
   pieces if the part colour cannot move it (lighting owns its blue).
5. Jet core: opaque white (233,253,254) -> T 0.4, tint (150,200,215); a back-niche water sheet (120,160,176) ~4 wide T 0.3.
6-10 if time: falls body (226,245,247) -> (196,240,247), a 1.5x wider plane T 0.75, mist at each foot, the white cloud in c3's
   upper left (228,232,235) where the reference shows blue sky (106,205,242); Boss Rush facade (35,25,40), magenta only round the
   sign; p2 portal (4,131,142) with an inset plane, island band behind the orb down ~10 or orb up ~8; Summon entry (226,220,158)
   with a lit door (193,171,115), canopy saturation -10 around the Summon (c4 91 vs 81), 4-6 stalls or lamps; Story ring interior
   (2,11,16); bollard slab (225,225,218) not clipped white, dome ~0.7x height.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint,
  and prove every new piece shows in the camera it is for.
- Do not overwrite tracked files outside your pass; keep scratch in out/r33w/.
- Report `notes/fix33_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
