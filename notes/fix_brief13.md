# Fix brief, freestyle pass 13: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-10 judged frames are in `out/verify10/v10_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 13" section (`build_all13()`, `export_r13()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r13.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r13` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r13 out/r13`.

## Inputs
`notes/verify10_plaza.md`: round-10 review (7.17/10, up from 6.92; the sky and Raid values now match). The biggest gap is now
**foliage style**: every practice tree is faceted crystal shards or smooth spheres where the reference uses soft dense drooping
leaf clumps. Read it fully, and `notes/fix12_plaza.md`. Never send Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md). Technology and
post effects match the reference: don't change them (Atmosphere Density is the one value you may test for far fade, measure it).

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-10 order; full instructions with RGB and sizes in the review)
1. Foliage kit, a new mesh family in Blender: soft clump trees built from 20-40 drooping leaf cards 3-5 studs each per clump
   (cards bent down at the tips, overlapping, two tones per clump: a darker inner and a lighter outer), clumps grouped into canopies on
   a tapering trunk with a few branches; a few silhouettes (round broadleaf, tall cypress, wisteria with hanging strands, palm frond
   set) in 4 colour families (blue (30,80,220)/(70,140,255), purple (150,110,220)/(190,150,240), gold (220,170,40)/(250,210,90), green
   (90,160,60)/(130,190,70)). Export them in ONE kit (ae_kit_r13 with the scale cube) and, after the import, swap the crystal-shard
   and sphere trees for them everywhere (plaza flanks, avenues, islands, horizon ring clustered in groups of 3-5 with the far ring
   tinted ~20% toward (170,210,235)). This is the main job of the pass.
2. Local glow and haze: visible Raid smoke round the skull and facade (test size/transparency until it shows like the reference's
   (159,113,99) air beside the skull), Raid red lights (back off until shading survives), Neon crystal cores with small lights.
3. Avenue and flank density: a gold tree mass behind Summon, a purple wisteria mass right of Summon and behind the NE arch, a gold
   pineapple by the W pavilion, bigger cypress pair, bunting between the lamp posts.
4. Islands: streams 2-3 wide (200,235,255) T 0.3 with mist instead of glass-panel falls; 2-3 towers 35-50 tall each; an aqueduct
   between the N pair; 4-6 trees each (from the new kit).
5. Story: the canopy from the new kit (8-10 drooping clumps in a ~50 dome), height ~70; carved silver-blue portal frame round a dark
   opening with a faint swirl; a stepped white arena ~40 across.
6-10. Raid finishing (delete the two white plinths at the door; spires; dead trees; a red glow strip on the bottom steps); lawn
   (100,150,40) with tufts and sand paths, lagoon 60x40 ringed with blue foliage and palms, terrace balustrades; arch wings and
   crystal pods; medallion blades and bollards; south side.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix13_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
