# Fix brief, freestyle pass 8: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Picture set: the live reference place is NOT on this PC. Pictures: `out/refsheet/r1_spawn_gold_purple.png` (p1),
  `r2_spawn_expeditions.png` (p2), `r3_spawn_raid.png` (p3), `r4_spawn_story.png` (p4) and five aerials `r5`..`r9`; plus the
  round-4 and round-5 reviewers' written descriptions of every reference camera (`notes/verify4_plaza.md`, `notes/verify5_plaza.md`).
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 8" section (`build_all8()`, `export_r8()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r8.fbx`.
- Import (computer use, Roblox Studio is granted): Home > Import 3D at (570, 80); File name box (350, 378), Open (598, 401);
  in Import Preview tick Insert Using Scene Position (871, 370) and Anchored (871, 457), zoom to confirm both, Import (967, 646).
  Frame is 1456x819 on one 1920x1080 screen with Studio maximised. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r8` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r8 out/r8`.

## Inputs
`notes/verify5_plaza.md`: round-5 review (6.42/10 provisional, up from 6.00), ranked top-10 with RGB and sizes; read it fully,
and `notes/fix7_plaza.md` (pass 7 method and lessons). Keep everything that matches; do not override Ambient/OutdoorAmbient.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-5 review order; read the full instructions there)
1. Islands ~1.5x farther and ~30 higher, rock (137,148,145) with less blue haze, 2-3 waterfall curtains 4-6 wide per island with
   mist, ruin towers ~8x8x40 with arches, +2 islands and 3-4 clouds in the empty c3 sky.
2. Raid weathered: walls (130,55,58), trim (92,40,48), towers (60,25,30); skull grey-red (125,85,72) Slate with 2-3 studs of
   relief; keep neon eyes/beam; red light + haze; 6-8 dead red trees (120,30,35) 10-15 tall.
3. Expeditions: 8 curved shards (~6x1.5) on a radius-12 ring ~10 above the arch round a 5x8 white Neon oval; arch x1.5, teal
   (60,170,170) glass with gold frames, own 14x3 "Expeditions" sign, lawn strip at the top of the south flight.
4. Stairs: treads on EVERY flight (115,120,135) with 0.3 nosing (190,192,190) (north flight still pale); north runner ~1.5 narrower.
5. East quadrant: ~60% of the bare gravel covered with dense red trees/bushes; red litter on the east stairs and floor.
6-10. Summon back ~15 and 40x30 cream/gold facade with gold trees; Story tree tan and thicker; basin/water/vault; ground and
   horizon (island rim with cliffs 150-200 out, east/west landings, water channels); medallion/bollard/crystal pod details.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix8_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
