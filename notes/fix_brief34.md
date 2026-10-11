# Fix brief, freestyle pass 34: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-31 judged frames are in `out/verify31/v31_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 34" section (`build_all34()`, `export_r34()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r34.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r34` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r34 out/r34`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify31/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 33 (Plaza 20571). Rebuild order is in notes/fix33_plaza.md; write your Studio side as `fix/pass34.lua`
  (idempotent, runs after pass 33) with measuring scripts in `out/r34w/`.
- Studio here is signed in to the original account; Import 3D uploads the r34 kit under it. That is expected.

## Inputs
`notes/verify31_plaza.md`: round-31 review (9.33; p1, p2, p7, c3 at 9; the other eight at 9.5). The judged frames are full size in
`out/verify31/v31_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix32_plaza.md` and `notes/fix33_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-31 order; full instructions with measured colours and pixel positions in the review)
The 9s left are p1, p2, p7, c3. Eight cameras at 9.5: re-check each after any change it sees, and never trade one away.
1. Arch inner-band teeth (c1, c2, c3, p1-p6): the pass-33 band reads as a saw-tooth ring of light blocks. Replace it with ONE
   smooth curved band following the arch (~1 wide, 0.3 proud, (150,155,155)), a kit mesh is the right tool (own Blender, lathe or
   tube_along on the arch curve); keep the niche behind it dark (20,31,49): c1 (560,400) is now (126,164,188).
2. Jet and niche water: c1 (640,380) (203,235,240) vs (16,46,60), c3 (640,600) (192,231,237) vs (33,65,81). Dome jet ~60 % width,
   T 0.6, tint (150,200,215); back water sheet ~4 wide (62,99,117) T 0.3 with a faint blue glow.
3. p3 upper left (saturation 13 low): a royal-blue canopy (16,63,204) ~25 wide, 20 tall over a dark rock (93,77,60), covering p3
   x 60-320, y 60-260 (now a grey-green island (141,166,152)); Raid doorway (31,44,53) -> (0,10,18). Prove it in a p3 capture.
4. East ground finish: solid red (184,69,62) with sparse white flower dots in place of the red/grey speckle; green bushes as flat
   flower patches ~10-15 across (132,176,50) with white dots; the black-cube cluster rounded into a rock mound (54,56,51) with
   lighter tops (90,95,90). Keep the grey rubble band.
5. Arch face too dark in shade: base ~(85,92,100) in a shading material (Slate or SmoothPlastic), lit side ~100-110, shaded ~60;
   c1 stays near (73,85,85).
6-10 if time: lagoon (38,91,147), south lawn (112,181,60), north canal (123,144,191) ~8 wide, white surf and stone breaks on the
   west lagoon; falls body (196,240,247) with a 1.5x plane T 0.75, mist ~8 wide at each foot, turn the c3 cloud away from (300,40);
   p6 portal back up to ~(14,150,165), island/ivy band behind the orb down ~10, cyan side pillars (107,123,131); Summon bright arched
   entry (226,216,138) with a lit inner door, canopy saturation -10, 4-6 stalls or lamps; aged-gold bollards (170,145,35), slab
   (200,198,180), dome 0.7x; dark canopy (66,80,59) at p6 (800,250).

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5. Zoom-compare (reference crop next to practice crop) before you retint,
  and prove every new piece shows in the camera it is for.
- Do not overwrite tracked files outside your pass; keep scratch in out/r34w/.
- Report `notes/fix34_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
