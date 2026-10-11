# Fix brief, freestyle pass 37: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-34 judged frames are in `out/verify34/v34_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 37" section (`build_all37()`, `export_r37()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r37.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r37` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r37 out/r37`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify34/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 36 (Plaza 21745; kits up to ae_kit_r35). Rebuild order is in notes/fix36_plaza.md; write your Studio side as `fix/pass37.lua`
  (idempotent, runs after pass 36) with measuring scripts in `out/r37w/`.
- Studio here is signed in to the original account; Import 3D uploads the r37 kit under it. That is expected.

## Inputs
`notes/verify34_plaza.md`: round-34 review (9.46; c3 at 9; the other eleven at 9.5). The judged frames are full size in
`out/verify34/v34_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix35_plaza.md` and `notes/fix36_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-34 order; full instructions with measured colours and pixel positions in the review)
Only c3 is at 9; eleven cameras at 9.5: re-check each after any change it sees, never trade one away. The reference fountain jet
is animated; judge jets by shape and size.
1. c3 (the last 9): sky at (300,40) blue (95,201,241) not cloud (228,232,235) (the cloud is in the own skybox: a skybox change moves
   every camera; consider a local fix such as a piece in front, or prove a skybox tweak keeps all 9.5s); the recess under the arch
   (161,177,187) -> (60,65,80); three Raid recesses ~3 x 6, set back 1, inside (20,8,12), surround (152,119,111), placed where p3/c3
   actually see them (pass 36's were not visible: capture-check each); door interior (5,12,16).
2. U-arm arch boxes (kit rework of K_Arch20): light band on the arms (c2 (560,200) (41,49,69) -> (100,114,135); p1 (120,250)
   (55,68,91) -> (97,101,117)) and the stepped ledge on the arms.
3. Arch band grooves and front face: 2 grooves ~0.4 wide (45,53,62) in the light band; front face (88,101,110) -> (62,66,64)
   (p5 target (76,81,82)); gold pipe at p5 (500,330) (178,153,65) -> ~(150,125,45).
4. Fountain niche and jet: niche interior near black (8,12,20) (now (72-88,109-120,135-146)); a curved water sheet ~3 wide
   (165,218,232) with white froth at the lip in place of the box jet; p5 jet base (201,233,210) -> (60,138,169).
5. p2 island band and orb: lower or trim the band ~10 so (720,200) shows sky (180,203,216); orb ring segments grey-blue
   (120,135,160); Expeditions sign 1.5x.
6-10 if time: SE rock (4-6 rocks over ~18 x 12, lit tops (151,134,116), red palm), sand 60 % (192,171,116), lawn (98,179,49) at
   p7 (1000,650); Summon side gold tree mass (197,154,72), c4 entry (204,174,104), canopy (115,158,178), 2 blue cypress
   (71,123,233) ~8 tall; lagoon edges (67,82,51), thinner west foliage at p7 (150,300), ochre (150,124,50) patches east; NE crown
   (35,80,205), cover the trunk stub at c3 (630,250); Story crown up ~5 and (94,113,206), p6 (800,250) dark canopy (66,80,59),
   p6 recess (22,29,40).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint,
  and prove every new piece shows in the camera it is for.
- Do not overwrite tracked files outside your pass; keep scratch in out/r37w/.
- Report `notes/fix37_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
