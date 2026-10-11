# Fix brief, freestyle pass 38: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-35 judged frames are in `out/verify35/v35_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 38" section (`build_all38()`, `export_r38()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r38.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r38` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r38 out/r38`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify35/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 37 (Plaza 21880; kits up to ae_kit_r37). Rebuild order is in notes/fix37_plaza.md; write your Studio side as `fix/pass38.lua`
  (idempotent, runs after pass 37) with measuring scripts in `out/r38w/`.
- Studio here is signed in to the original account; Import 3D uploads the r38 kit under it. That is expected.

## Inputs
`notes/verify35_plaza.md`: round-35 review (9.50; all twelve cameras at 9.5). The judged frames are full size in
`out/verify35/v35_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix36_plaza.md` and `notes/fix37_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-35 order; full instructions with measured colours and pixel positions in the review)
All twelve cameras are at 9.5. The next half point needs a camera to read as near-identical: aim each change at a whole camera
(p3, c1, c3, p5 see the most of this list). Never trade a 9.5 away. The reference jet is animated; judge jets by shape and size.
1. Fountain jet (c1, c3, p1, p3, p5): from the front it reads as a pale block. A plume ~2 wide, 2.5 tall, keeping the c2 curl:
   body c1 (640,400) (126,201,230) -> (84,118,133); a white froth crown ~1.5 deep at c1 (640,430) -> (226,254,254); c3 (640,600)
   -> (100,143,159).
2. NE arch outer value: keep the c1 face dark and the grooves; lighten the outer pieces: p3 (150,330) (68,80,90) -> (130,132,136),
   c1 (900,300) rim (86,102,116) -> (175,185,190), p1 (80,330) (57,69,89) -> (91,95,93). (Pass 37 split the stone per corner and by
   face: a per-piece colour on the NE outer/shoulder piece is the tool.)
3. Raid arcade colour and interiors: arcade stone maroon (p3 (600,320) -> (104,49,55), (560,330) -> (79,38,49), p5 (1100,320)
   -> (103,24,31), c3 (1060,470) -> (74,68,65)); bay and door interiors (5,10,16); p4 ring (0,9,16).
4. c3 notch sill: recess ~1 stud with a thin gold sill, (640,500) (159,177,187) -> (60,65,80) (needs a kit change to the notch).
5. Near U arm: the stepped ledge on the arms (c2 (560,200) (69,78,109) -> (100,113,134), p1 (120,250) -> (102,104,117)).
6-10 if time: p5 shoulder band (520,300) (201,204,207) -> (160,162,128) and gold pipe (500,330) -> ~(60,85,115), p6 (500,330)
   -> (44,70,75); Summon side gold tree mass, c4 entry (209,178,105), canopy (127,165,177), two blue cypress; SE rock 4-6 rocks with
   lit tops, sand 60 %, p7 lawn (98,178,49); NE crowns (43,94,208)/(16,63,204), Story crown up ~5 and (100,117,206), p6 (800,250)
   dark canopy (66,80,59); lagoon edges (68,83,51), p7 west sandy rock, p8 ochre patches, sign teal (107,228,226).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint,
  and prove every new piece shows in the camera it is for.
- Do not overwrite tracked files outside your pass; keep scratch in out/r38w/.
- Report `notes/fix38_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
