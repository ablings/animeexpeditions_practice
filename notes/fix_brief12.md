# Fix brief, freestyle pass 12: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-9 judged frames are in `out/verify9/v9_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 12" section (`build_all12()`, `export_r12()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r12.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r12` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r12 out/r12`.

## Inputs
`notes/verify9_plaza.md`: round-9 review (6.92/10, up from 6.50; the layout from above now matches). Read it fully, and
`notes/fix11_plaza.md`. Never send Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md).

**Lighting note from the lead (checked offline in both place files):** Lighting.Technology is ShadowMap (3) in BOTH, and
Brightness, ExposureCompensation and the Environment scales are identical; the post effects already match `notes/settings_ref.txt`.
Do NOT change Technology or the post effects, and do not use the reviewer's guessed numbers for them. The hazy pale sky in the
reference (about (200,225,235) near the islands vs our (101,189,239)) comes from its **skybox image**. Make our OWN skybox paler and
hazier toward the horizon (generate new own sky images with PIL into tex/, upload them with upload_image from
http://127.0.0.1:8767/tex/... three per call, and set the Sky faces), then measure the sky colour in p1/c3/c4 against the reference.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-9 order; full instructions with RGB and sizes in the review)
1. Pale hazy own skybox (see the note above); keep the post effects as they are.
2. Raid light/dark swap: facade (90,25,40), recesses (25,5,12); the skull the lightest thing on the temple, dusty rose (165,90,95)
   with dark sockets; letters (235,120,125) Neon; red smoke at the skull and door; red lights (test, back off until shading
   survives); 2 dark red palms ~25 tall by the door.
3. Red litter as fine speckle: 2-4 stud leaf cards at ~40% cover over grey gravel (103,108,105), reds (180,50,52)-(200,70,70) with
   white flower dots and green tufts; no solid red on the SE gravel.
4. Islands: underside rock (150,160,150) with darker crevices, no pale facets; lift N/W/E islands 15-20; 4-6 round trees 15-20
   tall, a grey 10x10x50 tower and vines per island; an aqueduct and a domed rotunda across the N pair.
5. Horizon and avenue: 8-12 building/tree masses 30-60 tall beyond ~150 out so p7 shows no empty baseplate; N avenue: 6 blue cypress
   cones (40,90,220) 4x14, 4-6 stalls with awnings, flags.
6-10. Story (drooping leafy clumps, height cap ~70, carved silver-blue frame round a dark opening with a faint swirl, a stepped white
   round arena ~40 across); ground plan (delete the 3 tall-grass blocks, white terraces at the E/W arm ends, carved plinths, mixed
   lawn tones, channel (85,140,225), lagoon (60,150,210)); arch wings dark slate with bands (needs the hero split: only if time),
   risers (140,150,155), drum gold lip; crystal pods per arch with light; medallion blades, bollards, S gate, shard ring grey.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix12_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
