# Fix brief, freestyle pass 35: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-32 judged frames are in `out/verify32/v32_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 35" section (`build_all35()`, `export_r35()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r35.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r35` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r35 out/r35`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify32/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 34 (Plaza 21534; kits up to ae_kit_r34). Rebuild order is in notes/fix34_plaza.md; write your Studio side as `fix/pass35.lua`
  (idempotent, runs after pass 34) with measuring scripts in `out/r35w/`.
- Studio here is signed in to the original account; Import 3D uploads the r35 kit under it. That is expected.

## Inputs
`notes/verify32_plaza.md`: round-32 review (9.38; p2, p7, c3 at 9; the other nine at 9.5). The judged frames are full size in
`out/verify32/v32_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix33_plaza.md` and `notes/fix34_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-32 order; full instructions with measured colours and pixel positions in the review)
The 9s left are p2, p7, c3. Nine cameras at 9.5: re-check each after any change it sees, and never trade one away.
Note: the reference fountain jet is animated (c3 (640,600) ranges (33,65,81) to (211,247,254)); judge jets by shape and size.
1. Arch outer face shades too hard: lit too light (c1 (88,101,110) vs (60,64,60), p5 (100,106,104) vs (76,81,81)), shaded too
   dark (c2 (40,49,68) vs (100,113,134), p1 (56,66,80) vs (83,85,98), p3 (92,104,114) vs (134,135,139)). Base ~(75,82,90); two
   upward-facing stepped ledges along the arch curve ~1.2 wide, 0.5 proud, (150,155,160) (kit sweep like the pass-34 band).
2. Crowns oversaturate c1 (+16), c4 (+10), p5 (+8): raise the north corner crowns ~4 studs and thin their lower third ~30 %,
   colour stays (33,73,189); push the p3 crown ~4 further out to cover (150,120) (now (141,166,152) vs (16,63,204)).
3. Niche water sheet: c2 (520,400) (16,21,33) vs (38,76,93); ~5 wide (60,140,170) T 0.2; dim the c1 jet base (640,420)
   (161,202,214) toward (64,94,109).
4. Lagoon, south lawn, canal (four rounds): canal (185,195,190) -> (123,144,191) ~8 wide; south lawn (88,159,115) -> sand
   (192,171,115); west lagoon banks of sand and rock (69,83,55) with white surf.
5. SE rock reads as a hole: 4-6 rocks 3-6 studs with lit tops (95,98,92), ~30 % covered by red foliage; flower patches
   (97,151,77) -> (153,187,94).
6-10 if time: p2 orb against sky ((720,200) (100,134,113) vs (174,200,212)), orb (220,235,240), cyan pillars (107,123,131), p6
   portal (17,159,171); Raid door interior (5,8,12), red wash (246,155,143) at half brightness, three arch recesses on the c3
   facade; falls (196,240,247) with a soft-edge plane and mist, c3 cloud at (300,40) gone, c3 jet plume ~3 wide; bollards aged
   gold (150,128,30) Reflectance 0, dome 0.7x, slab (180,178,150); c4 Summon entry (209,177,102), c4 canopy (640,350)
   (105,151,177), stalls or lamps, p6 (800,250) dark canopy (73,91,82).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint,
  and prove every new piece shows in the camera it is for.
- Do not overwrite tracked files outside your pass; keep scratch in out/r35w/.
- Report `notes/fix35_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
