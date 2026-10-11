# Fix brief, freestyle pass 36: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-33 judged frames are in `out/verify33/v33_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 36" section (`build_all36()`, `export_r36()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r36.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r36` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r36 out/r36`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify33/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 35 (Plaza 21650; kits up to ae_kit_r35). Rebuild order is in notes/fix35_plaza.md; write your Studio side as `fix/pass36.lua`
  (idempotent, runs after pass 35) with measuring scripts in `out/r36w/`.
- Studio here is signed in to the original account; Import 3D uploads the r36 kit under it. That is expected.

## Inputs
`notes/verify33_plaza.md`: round-33 review (9.42; p2 and c3 at 9; the other ten at 9.5). The judged frames are full size in
`out/verify33/v33_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix34_plaza.md` and `notes/fix35_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-33 order; full instructions with measured colours and pixel positions in the review)
The 9s left are p2 and c3. Ten cameras at 9.5: re-check each after any change it sees, and never trade one away.
The reference fountain jet is animated; judge jets by shape and size.
1. Arch outer band (c1, c2, p1, p3, p5): the band between the gold pipes is navy (41,52,59)/(41,49,69) where the reference shows a
   lit shoulder (178,171,168): recolour it ~(100,112,128); widen the ledge to ~2 studs; run a ledge along the U arms too (c2 (560,200)
   -> (100,114,135), p1 (120,250) -> (103,105,118)); flat front face (88,101,110) -> ~(62,66,64). Pick each box first (pass 35 lesson).
   The arm geometry may need a kit change (narrower or lighter U arm).
2. Bare notch-tree poles (p3, c3): pass 35 raised the crowns and exposed a straight brown trunk. Add 3-4 crown clusters 3-4 studs
   (33,73,189) from mid-height up, or split the trunk into branches; targets c3 (630,250) (47,115,240), p3 (205,120) (21,69,205).
3. p2 orb and portal: raise the orb ~8 so (720,200) shows sky (187,209,215) (check p6 stays uncropped); orb (220,235,240) T 0.3;
   pillars (87,226,243) -> (107,124,132); p6 portal (12,128,149) -> (1,81,93).
4. Raid: door interior (3,10,16) (the lift is something in front of the door: find it); red wash (253,41,54) -> (243,138,135) at
   half brightness; 3 carved recesses (60,20,25) ~3 wide on the c3 facade.
5. c3 sky and falls: cloud at (300,40) (228,232,235) -> blue (102,205,241); falls (226,246,247) -> (196,240,247) with a wider
   translucent plane and an 8-stud mist part (200,230,235) at each foot; the recess under the arch (161,177,187) -> (60,65,80).
6-10 if time: SE rock as 4-6 rocks over ~18 x 12 with lit tops (144,129,115) under a red palm, sand patch ~60 % tinted
   (192,171,116), lawn (98,180,48) back at p7 (1000,650); rounded jet plume ~3 x 4 (175,221,233) base T 0.6; Summon side gold tree
   mass (183,142,70) ~12 behind the north stair, entry (197,168,101), canopy (117,159,177), 2 blue cypress (66,120,232), 4-6 stalls;
   lagoon edges (75,86,53), thinner west blue foliage at p7 (150,300), ochre (143,119,50) patches in the east field; Story crown up
   ~5 and lighter (96,114,207) with 2-3 trunk arms, p6 (800,250) dark canopy (66,80,59).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint,
  and prove every new piece shows in the camera it is for.
- Do not overwrite tracked files outside your pass; keep scratch in out/r36w/.
- Report `notes/fix36_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
