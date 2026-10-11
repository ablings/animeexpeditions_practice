# Fix brief, freestyle pass 29: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (main PC, 2026-10-11 overnight)
- All paths are under `C:/Users/aroki/Documents/animeexp_practice` (main PC).
- Reference: the live reference place IS open on this PC: studio `97946bf6-0aa4-48bc-9024-a884610ec79c`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-26 judged frames are in `out/verify26/v26_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 29" section (`build_all29()`, `export_r29()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r29.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r29` as well. Run it with
  `cd C:/Users/aroki/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py 93d2d4f5-c7e7-40ed-bb6f-cd6824f11572 r29 out/r29`.

## Main PC notes (2026-10-11)
- Reference frames: `out/verify26/` (full size, this PC). Recapture more angles from the reference studio with `cams.json` if needed.
- Blender 5.2 is open on `ae_kit.blend` with the MCP add-on (port 9876). File server `tools/serve.py` is running on 8767.
- The saved place is pass 28 (Plaza 17647). Rebuild order is in notes/fix28_plaza.md; write your Studio side as `fix/pass29.lua`
  (idempotent, runs after pass 28) with measuring scripts in `out/r29w/`.
- Studio here is signed in to the original account; Import 3D uploads the r29 kit under it. That is expected.

## Inputs
`notes/verify26_plaza.md`: round-26 review (9.04; p3 and c4 at 9.5, p4/p6/p8 at 8.5, the rest at 9). The judged frames are full size in
`out/verify26/v26_<cam>_ref.jpg` / `_rep.jpg` (1284 x 793 here; close any Studio bottom panel before capturing: an open Import Queue
shrank captures to 1266 x 418 in pass 27). Read it fully, and `notes/fix27_plaza.md` and `notes/fix28_plaza.md` (their lessons: prove pixel ownership with a red
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

## Priorities (round-26 order; full instructions with measured colours in the review)
1. Fountain jets (9 cameras): translucent stream ~1 x 5 studs, T 0.4, (110,190,220), 0.3-stud Neon core (200,245,255), own spray
   ParticleEmitter and a PointLight, in place of the opaque mushroom jet; swap the 3 dark spheres in each arch notch for a small
   twisted tree (leaves (90,150,60) and (40,90,220)).
2. Sky frame (p2-p6, c3): every floating ruin gets a rock cone underneath (120,125,130) ~1.5x its width, grass cap (110,170,70)
   and leafy lumps, or is deleted; island shells (151,172,154) -> (172,193,130); two bright falls on the left island.
3. Expeditions orb (p2, p6): the crescent ring must sit against sky (move the crown tree ~25 studs E or raise the orb ~12);
   crescents ~1.5 thick, 8-12 long, (130,138,155); lower the island band behind the crown ~50 studs.
4. Story portal (p4, p6): horseshoe crest ~6 studs, inner band (40,60,120), 4-6 blue ivy drips (40,90,220), dark glow plane inside.
5. Summon facade: white-gold face, 3 blue arched windows (60,100,200) in gold frames, gold medallion over the door, gold-capped
   pilasters, in place of the cream box.
6-10 if time: Boss Rush purple gothic shrine ~25 tall (70,40,90) with magenta glow; W lagoon deeper (40,95,170) with a lighter rim,
   ~80 x 50 irregular shore, canopy over the sand discs, lawn (114,181,60); fountain arch bevelled grey bands, bollard base two-step
   with gold trim; foliage accents (c1 red clump, finer c2 fern, palm leaves (80,112,180), p1 gold tree (216,176,77)); parasols,
   stalls, lamp posts at the Summon stair top, crystal basins at the gate, glowing teal Expeditions door.
   p3/p6/p7/p8 are 13-17 under the reference in top-half saturation: favour changes that add saturated colour there.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that. No computer use; the lead runs Import 3D.
- Verify with captures; time-box ~100 minutes. Prioritise 1-5.
- Report `notes/fix29_plaza.md`: what you built and how (method), what you measured from pictures, **lessons** (for the workflow
  vault) and "Objects built" (for 5 Object Recipes).
