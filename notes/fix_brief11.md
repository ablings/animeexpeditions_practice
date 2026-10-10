# Fix brief, freestyle pass 11: Anime Expeditions spawn plaza

You are the builder for this pass; a different agent reviews it afterwards. Build **freestyle**: from the reference
PICTURES only. Do not read part positions, sizes or CFrames from the reference place, and do not open
`ae_reference.blend` (that is the export of the reference: off limits for building). Scale comes from the pictures
and the player (5 studs tall).

## What you have (Shadow PC)
- All paths are under `C:/Users/Shadow/Documents/animeexp_practice` (ignore any `C:/Users/aroki`).
- Reference: the live reference place IS open on this PC: studio `12bdc68f-9f23-444b-9718-8043ca761440`, read-only,
  **screen_capture only** (never execute_luau there, never read part positions). Capture it from any camera you like to see a
  piece from more angles. The round-8 judged frames are in `out/verify8/v8_<cam>_ref.jpg` / `_rep.jpg`.
- Practice place: studio `ae13592b-5ca7-43d3-91a6-9135c14250eb` (`AE_practice.rbxl`). execute_luau and screen_capture allowed
  (MCP tools `mcp__Roblox_Studio__*` via ToolSearch, or `mcpcli.py`).
- Own kit generator: `tools/ae_kit.py` (run in Blender via the Blender MCP: open `ae_kit.blend`, `runpy.run_path`).
  Helpers: lathe, lathe_solid, rbox, tube_along, extrude_outline, flip_toward_axis, to_zup_and_uv. Author Y-up, then
  call `to_zup_and_uv()` before export. Add a "pass 11" section (`build_all11()`, `export_r11()`) like pass 7 and export only the
  new/changed pieces to `kit/own/ae_kit_r11.fbx`.
- Import: do NOT drive the screen yourself. Export the FBX (only new/changed pieces plus the 10-stud scale cube), then stop and
  tell the lead, who imports it; then continue with placement. Import uploads the meshes to the signed-in Roblox account
  (Edward's new account from pass 8 on; earlier kits belong to the original account: that is expected).
- Placement: `fix/build_plaza.lua` (idempotent, own layout table): make it look for `ae_kit_r11` as well. Run it with
  `cd C:/Users/Shadow/Documents/animeexp_practice && PYTHONIOENCODING=utf-8 python mcpcli.py call execute_luau <json>`.
- Lighting: `fix/fix_lighting.lua` (the reference's settings). Re-run it after rebuilding.
- Captures: `CAMS=cams_practice.json python capture_set2.py ae13592b-5ca7-43d3-91a6-9135c14250eb r11 out/r11`.

## Inputs
`notes/verify8_plaza.md`: round-8 review (6.50/10, up from 5.92; 8 cameras +1). The colour corrections worked. What holds it back
now: the layout from above (p7/p8 at 5), no glow/mood, a flat pink Raid without a beam, a small Summon, a blob Story tree, and
shard-carpet spills. Read it fully, and `notes/fix10_plaza.md`. Never send Delete/Backspace/Ctrl+A to Studio (see CLAUDE.md).

**Lighting note from the lead:** the practice already has Bloom, ColorCorrection, SunRays and Atmosphere, but passes 8-9 drifted
them from the reference's recorded values. Restore them in `fix/fix_lighting.lua` to exactly what `notes/settings_ref.txt` records
(Atmosphere Density 0.2, Offset 0.25, Haze 0, Glare 0, Color/Decay as recorded; Bloom Intensity 1, Size 56, Threshold 2;
ColorCorrection and SunRays as recorded). Do NOT use the reviewer's guessed post-effect numbers. The reference's "glow" comes from
emissive surfaces (Neon parts, lit crystals, the beam, portals) and a few coloured lights; add those to the pieces that lack them.

## How the reference builder works (learned by studying the export; use the METHOD, not their geometry)
The plaza centrepiece is ONE sculpted mesh with 4-way symmetry: raised centre, four corner water pools each backed by
a tall curved wall with an arched gate and canopy lip, pavilions (lanterns) on the wall ends, fountain bowls; stairs
as one ring mesh; floor + medallion as another. Small separate pieces: water discs, crystals, torches, planting.
**Do it the same way: generate one quarter of the plaza hero piece in Blender and mirror it twice into one mesh**
(colour-split into a few meshes by material: stone, darkStone, gold, blue, glass), plus separate stairs, floor/medallion,
water discs, lanterns, plants.

## Priorities (round-8 order; full instructions with RGB and sizes in the review)
1. Layout from above: arms from ~52 to ~80; Raid ~60 further east (160-220 out) and ~1.3x; grey gravel road (104,107,109) with red
   litter and black dead trees in the gap; west lagoon (60,170,220) with a sand beach (225,205,150), palms and pool rings; a 6-stud
   water channel (90,200,230) down the north avenue with sand strips; white paving (230,230,225) with 2 crystal pedestals instead of
   the grass blocks over the south/west flight tops. Measure on p7/p8 against the reference.
2. Raid glow: facade lit (195,40,45), recesses (100,10,15), spires (60,20,30); Neon letters (235,70,80); a Neon beam (255,40,40)
   1.5 wide from the skull's mouth ~20 down to the letters; a more angular skull (140,60,65); red lights + haze at the door (test:
   back off until shading survives); black dead trees and a dark red palm; Boss Rush as a purple swirl portal in a carved frame.
3. Lighting restore (see the note above) + emissive sources: glow inside the crystal pavilions (80,170,255), crystal pods with light.
4. Summon: an ornate 2-storey facade ~50x30 in gold/cream (215,190,120) with a blue band (50,90,180), gold letters ~20 wide, a gold
   tree mass (215,170,50) ~35 tall behind, flags/stalls/umbrellas in front.
5. Story: tan trunk ~12 thick with 4-5 spreading branches, 6-8 wispy clumps (30,90,220) with gaps, 10-15 hanging vines, ~30% smaller
   in plan; silver-blue ring around a Neon swirl portal (40,110,255).
6-10. Thin spills (2-3 patches per area, rounded cards, no red spill on the south floor, mixed-green lawn strips); arch wing flanks
   dark slate with bands, risers (95,105,115), a gold bowl lip on the drum; gold Metal (180,165,62), medallion blades, shorter
   bollards; island lift/dressing; crystal pods, cypress, foreground palm.

## Rules
- Never write to the reference studio or save it. Never copy reference meshes/textures/images/names/code.
- Do not save the practice place, do not commit; the lead does that.
- Verify with captures; time-box ~100 minutes. Prioritise 1-4 and 7.
- Report `notes/fix11_plaza.md`: what you built and how (method), what you measured from pictures, and **lessons**:
  anything about freestyle modelling that a builder should know next time (these go into the workflow vault).
