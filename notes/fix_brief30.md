# Fix brief, freestyle pass 30: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-27 judged frames are in `out/verify27/v27_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 30" section (`build_all30()`, `export_r30()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r30.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r30` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r30 out/r30`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify27/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 29 (Plaza 17942). Rebuild order is in notes/fix29_plaza.md; write your Studio side as `fix/pass30.lua`
  (idempotent, runs after pass 29) with measuring scripts in `out/r30w/`.
- Studio here is signed in to the original account; Import 3D uploads the r30 kit under it. That is expected.

## Inputs
`notes/verify27_plaza.md`: round-27 review (9.00; p3 and c4 at 9.5, p6/p8 at 8.5, the rest at 9). The judged frames are full size in
`out/verify27/v27_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix28_plaza.md` and `notes/fix29_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-27 order; full instructions with measured colours in the review)
Pass 29 changed only 2-14 % of pixels per camera. Go for changes a player notices at a glance: big shapes and strong colour first.
1. Fountain jets (9 cameras): they read as glass lamps. Delete the top sphere; a burst instead: column 0.8 x 2.5, T 0.35,
   (200,240,250); a crown of 3-4 curved sheets ~3 studs across, T 0.3, (215,245,250); Neon core (235,255,255); double the spray.
   Target the c1 jet (214,246,251) and ~100 px wide in c1 (a kit mesh for the curved sheets is fine).
2. Summon facade (c4, p1, p5, c3, p7): face (215,195,130); gold pilasters, cornice and window frames (200,160,70) at least 1 stud
   wide; windows (60,100,200) and larger; medallion ~5 studs; one strand of bunting.
3. West lagoon and lawn (p7, p8, p6): lagoon (40,95,170) with rim (90,170,220), ~80 x 50 irregular shore; blue canopy (40,90,220)
   over the west sand discs; lawn (114,181,60); near palm (132,193,83). This is where p6/p8 (8.5) and the saturation gap live.
4. Left and north islands (c3, c4, p1, p3): island colour (169,192,130); bright falls (235,245,250), T 0.25, 3-5 wide, 30-60 long.
5. Story portal (p4, p6): rim (50,75,120); a real horseshoe crest ~6 wide, gold (200,170,60) with blue (40,70,160) inset (a kit
   mesh); inner band (30,45,90); glow plane (20,40,110).
6-10 if time: orb ring fully against sky (raise ~10 or drop the band ~30), Neon portal door (10,150,165) T 0.3, crystal basins;
   bollard base two-tier (230,231,224) with gold trim (200,175,60), arch face bevelled (150,155,165) with a (70,80,95) band;
   foliage tints (c1 red (227,92,90), palms (85,115,181), p1 gold tree (219,180,78), finer c2 fern); Boss Rush light/sign/spires;
   parasols, stalls, lamp posts, statues at the Summon stair top.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5.
- Report `notes/fix30_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
