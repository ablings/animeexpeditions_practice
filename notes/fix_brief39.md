# Fix brief, freestyle pass 39: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-36 judged frames are in `out/verify36/v36_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 39" section (`build_all39()`, `export_r39()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r39.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r39` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r39 out/r39`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify36/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 38 (Plaza 21943; kits up to ae_kit_r37). Rebuild order is in notes/fix38_plaza.md; write your Studio side as `fix/pass39.lua`
  (idempotent, runs after pass 38) with measuring scripts in `out/r39w/`.
- Studio here is signed in to the original account; Import 3D uploads the r39 kit under it. That is expected.

## Inputs
`notes/verify36_plaza.md`: round-36 review (9.50; all twelve cameras at 9.5, flat). The judged frames are full size in
`out/verify36/v36_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix37_plaza.md` and `notes/fix38_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-36 order; full instructions with measured colours and pixel positions in the review)
All twelve at 9.5 and the last round was flat. Pick ONE camera to take to near-identical (the review's list says c1 or p5: jets,
shoulder bands, pipe) and finish it fully, rather than spreading small changes. Never trade a 9.5 away.
1. Jets: plume body translucent blue (127,186,203), pure white only for flecks and the top 0.5 of the crown; spout froth disc
   (200,235,245); plume ~1.6x wider (~60 % of the niche width); restore the c2 forward ribbon (32,122,151). Targets c1 (640,430)
   (254,254,254) -> (125,209,237); p3 (1040,410) and p6 (640,400) -> dark niche (6,29,41) (the far jet must not glow white).
2. Arch shoulder bands: keep the light U face; darken the two inner shoulder bands (~0.6 each) to (60,65,62): c1 (500,300)
   (132,136,139) -> (60,64,60), p5 (560,330) (138,137,129) -> (76,81,81), p5 (520,300) (201,204,207) -> (160,166,137); outer bevel
   rim c1 (900,300) (86,102,116) -> (181,194,206).
3. Raid arcade: redder surround (p3 (69,60,73) -> (103,46,53), p5 (100,56,70) -> (103,23,32), c3 (95,62,83) -> (74,66,65));
   doors and bays (3,8,14), p4 ring (0,8,16).
4. NW arch and U arm (p1): shoulder (57,69,89) -> (91,96,93), U-arm face (54,67,91) -> (101,103,117).
5. Pipe vs groove: p5 (167,141,58) -> (48,93,140); p6 (148,121,45) -> (44,69,76); p6 recess (54,59,66) -> (21,29,40).
6-10 if time: Summon side (gold tree mass (188,145,69), entry (216,185,106), canopy (121,162,177), 2 blue cypresses); c2 foreground
   reds (165,13,24) and (34,29,37); SE rock 4-6 rocks lit tops (148,132,115), SE sand 60 %, p7 lawn (100,180,49); NE crowns
   (43,92,208)/(16,63,204), Story crown up ~5 (101,118,208), p6 (800,250) (66,80,59); sign (106,229,226), orb ring (38,186,242),
   lagoon edges (78,89,60), p7 W foreground (100,97,65), p8 ochre patches (152,125,49).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint,
  and prove every new piece shows in the camera it is for.
- Do not overwrite tracked files outside your pass; keep scratch in out/r39w/.
- Report `notes/fix39_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
