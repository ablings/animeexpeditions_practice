# Fix brief, freestyle pass 10: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-7 judged frames are in `out/verify7/v7_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 10" section (`build_all10()`, `export_r10()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r10.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r10` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r10 out/r10`.

## Inputs
`notes/verify7_plaza.md`: round-7 review against the live reference (5.92/10, up from 5.67). Pass 9 added the right pieces but
several overshot in colour or size: purple island undersides that form a lid, near-black fountain arches, a cartoon skull on a
plinth, an oversized fountain drum, landmarks crowding the arms. Read it fully, and `notes/fix9_plaza.md` (pass-9 method and
lessons). This pass is mostly about **correcting values and proportions of what exists**, measured on captures against the
reference, not adding new things. Keep what matches; do not override Ambient/OutdoorAmbient.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-7 order; full instructions with RGB and sizes in the review)
1. Islands: rock lit (175,178,168) / shade (120,135,125) (counter-tint against the purple Ambient, or a soft fill under each); halve
   the spikes; lift the four islands nearest the spawn axes 20-25 and open 2-3 sky gaps; thicker caps and round trees; grey 10x10x50
   ruin towers instead of small white boxes; falls without cloud discs, fading over the lower third, with mist.
2. Fountain arches two-tone: crest/horns/top/outer band (130,135,135), inner bands and vault (55,62,72), wing flanks (75,85,95);
   gold (180,160,65) Metal; tread tops (175,180,180) with risers (60,70,85).
3. Raid: skull fused as the top of a central gable (22-25 wide, chin ~15 above the door), no plinth; beam ~20 to the letters over
   the door; facade (200,80,88), trim (95,35,45), spires (70,30,40); the Boss Rush portal visible from p3.
4. Fountain core: drum ~4 wide x 1.5 tall with a gold lip, sheet ~3 wide; basin ~15% smaller and 3-4 back under the arch mouth.
5. Story tree: canopy (60,120,240) in 6-8 wispy clumps showing the trunk, hanging strands, footprint -30%; letters on the ring crest.
6-10. N avenue (remove the tall grass strip, stalls, cypress, a visible Summon facade), Expeditions triptych + shard ring in open sky,
   layout around the arms (Raid ~60 further east and 1.3x, gravel road E, lagoon W, channel N, courtyard S), foliage spills to ~25%
   cover, plaza props.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix10_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
