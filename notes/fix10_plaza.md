# Fix pass 10: Anime Expeditions spawn plaza (value and proportion corrections, recessed basin, triptych gate)

This is the builder report for `notes/fix_brief10.md`. It answers the round-7 review `notes/verify7_plaza.md` (5.92/10).

**Captures:** `out/r10/r10_<cam>.png`, 12 cameras, 1452x793. Each camera was captured twice and the second frame kept.
Every colour change was measured as 5x5 means on a capture of the same camera as the review's sample.

**Rules kept:**
- I built from the round-7 pictures (`out/verify7/*_ref.jpg`) and the review only. I did not capture or run code in the reference studio,
  and did not open `ae_reference.blend`.
- The practice place is not saved and nothing is committed. `ae_kit.blend` is saved.
- No computer use. The lead imported `kit/own/ae_kit_r10.fbx`. It arrived clamped to scale 16.52, measured from
  `K_Scale10_stone`; the script restored true sizes (`K_Hero_stone` 124 x 13.5 x 124, `K_Trip10_teal` 29 x 20 x 3) and dropped the cube.
- `fix/fix_lighting.lua` was re-run ("lighting matched"). `Lighting.Technology` was not checked.
- Terrain `GrassLength` cannot be set from a script; the lead sets it by hand (0.55 suggested).

## What changed, per priority

### 1. Islands
- **Colour.** The rock base is now (210,216,195) Slate, and each island has 3 soft PointLights 24 studs under the rock
  (colour (210,225,200), range 50, brightness 1.0, no shadows).
  - Undersides now render (100-139,109-150,115-146) in p1 and (120-165,120-171,113-151) in c3.
  - The targets were (120,135,125) in shade and (175,178,168) lit. In round 7 they were purple, (70,50,88).
- **Spikes halved.** The rock MeshPart is squashed to 0.6 of its height with its top kept, so the cap and vines stay attached.
- **Placement by elevation angle** (see measurements below):
  - undersides at about 25 degrees above the spawn eye: underside = 6 + 0.47 x distance;
  - the NE island at 0.55, so it still crowns c3;
  - the N pair is now 74 studs apart, with the far N island higher in the gap. p1 shows three separate islands with sky between them.
  - The S island moved 60 studs west, so the Expeditions shard ring now stands in open sky.
- **Trees, ruins and falls:**
  - Round puff trees: 5 per island, each a trunk plus 4 overlapping spheres, 15-20 studs, in (80-100,150-170,55-65).
  - Ruin towers are grey (150,156,150) Slate.
  - Falls are now 4 stacked Part segments at T 0.3 / 0.55 / 0.75 / 0.9, so each fades over its lower third. Each has a foam lip and a mist emitter at 70% of its length. The cloud discs are gone.

### 2. Fountain arches and gold
- **Two-tone arch**, set on the hero tokens:
  - `stone` (crest, horns, cheeks, outer band, wings) is (101,107,111). It renders **(119-129,125-137,123-138)** against the (130,135,135) target.
  - `rib` and `darkStone` (recessed inner bands) are (68,78,90) and (62,68,76). They render **(57-64,60-70,64-74)** against (55,62,72).
  - `vault` is (40,46,54).
- **Gold:**
  - Kit gold tokens are Metal (195,150,55). They render (143-146,126-130,44-52), between the lit and shade targets.
  - SmoothPlastic gold Parts use (150,128,48), which renders about (186,159,60).
  - The medallion went back to SmoothPlastic (150,128,48). As Metal, the flat disc rendered (141,122,28) against (179,164,63). Its ring now reads (180,147,29), but the raised boss top reads (223,194,54), brighter than the target.
- **Stairs:** treads are (125,126,126) Slate and render **(178-197,176-195,167-184)** in c4 against (189,192,188). Risers are (50,58,72).
- The wing flanks are part of the same `stone` mesh, so they could not get their own (75,85,95).

### 3. Raid
- **Skull fused into a gable, no plinth:**
  - The skull (2.0x, about 21 wide) is lowered 10, so its pedestal is buried. The chin is now about 15 above the doorway.
  - It is the head of a central gable: a 16-wide block plus two WedgePart shoulders, 26 wide at the foot, with two dark pinnacles.
- **Beam and letters:**
  - A Neon beam, 1 wide, runs from the mouth to the letters.
  - The letters sit on the gate gable above the keystone skull.
  - The letters are now pale glowing (255,215,205). Red on red was unreadable once the lights worked.
- **Colours:** facade/gate (175,100,100), trim (85,38,42), spires (62,30,36), all Slate. The facade renders (188-204,28-48,49-67), close to the reference's shade (203,48,53).
- **Lights and fog:** three red PointLights at range 32 / brightness 0.45. The fog is Rate 6, LightEmission 0.2.
- **Boss Rush:** the tower is now 12 x 24 x 12, at 15 north of Raid and in front of its line. Its purple portal shows left of Raid in p3 at x ≈ 500-570 px; the reference has it at x ≈ 480-560.

### 4. Fountain core
- **New hero export** (`build_hero10`):
  - the basin is 0.85x (foot r 5.45, bowl r 4.75);
  - it is 3.5 further back (centre w 33.1), so its back rim sits under the arch mouth;
  - the upper tier is removed (the pale 6-wide drum with 16 gold bars). **That tier was the oversized drum**: as soon as the pass-9 Part drum shrank, it showed around it.
- **Drum (Parts):**
  - 4 across x 1.8 tall on a dark stem, with 12 slats, a gold lip ring on top, a lower band and a water disc;
  - it measures about 42% of the basin width in c1 (the reference is about 38%).
- **Water sheet and ledge:** the sheet is 3 wide and falls from the ledge into the drum. The ledge stays in the arch mouth.

### 5. Story
- **Tree:**
  - The footprint is scaled 0.72x in plan only (X/Z sizes and offsets), at full height. p4 in the reference shows a tall tree, so a uniform shrink was wrong.
  - The canopy is (60,120,240), with rim (130,185,255).
  - Not done: the hanging strands and the clump split.
- **Letters:** pale (170,210,255) 2 above the ring crest, with a navy (20,30,70) outline. The outline is a 1.08x copy set 0.6 behind.
- **Ring:** silver (150,170,205).

### 6-10 (partial)
- **N avenue:** the first two terrain verges are removed, which was the tall-grass wall across the top of the N flight in c4. Stalls and Summon were not changed.
- **Expeditions (7):**
  - The own triptych `K_Trip10` replaces the greenhouse window.
  - The letters are lowered to 26.6.
  - The shard ring is 1.5x (was 1.15x), 10 higher, and in open sky.
- **Layout (8):** not done. Raid is not moved east and the arms are not extended.
- **Foliage (9):** leaf spills are cut to every third one, about 24 left.
- **Bug fixed from pass 9:** three statements sat after a `--` comment on the same line:
  - the vault light's `L.Parent`, so the light never existed;
  - the Raid lights' `L.Parent`, so the Raid had no red light in r9;
  - the water sheet's `CanCollide` / `CastShadow`.

## What I measured from the pictures
- **Island placement:** 11.3 px per degree (793 px over a 70-degree vertical FOV).
  - p1 reference undersides at y 60-150 px are 22-30 degrees above the eye.
  - The c3 reference island at y 0-260 px, with the camera pitched about 18 degrees up, is 30-53 degrees up. That is a big island whose near edge is about 100-150 out at a height of about 100.
  - Hence: undersides at 6 + 0.47-0.55 x distance at 155-280 out.
  - A first try at 1.3x the distance opened p1 but emptied the top of c3. It had to be both close and high.
- **Render ratios in this lighting:**
  - SmoothPlastic in sun is about 1.12-1.24x the base, with a warm cast.
  - Slate treads are about 1.45x.
  - Metal gold renders at about 0.75x and loses red.
  - A lit underside under the purple Ambient renders about 0.8 x Ambient x base, so no base colour can reach a green-grey there.
- **Raid:** the red fog plus the red lights cut G and B to 0.4-0.6 of the base, so the base needs much more G/B than the target.

## Still off / for the lead
1. The wing flank faces share the `stone` token, so they are mid grey, not (75,85,95). Fixing that needs the wings on their own token in the hero.
2. Layout (item 8): Raid is not moved about 60 east or scaled 1.3x; the arms are not extended.
3. Not done:
   - N avenue: stalls and pineapple, a larger Summon facade, the gold-tree mass.
   - Story: hanging strands and wispy clumps.
   - Medallion blades and floor joints.
   - Bollard height.
4. The S and W stair-top lawns are still terrain tall grass. Setting `GrassLength` should calm them. Item 8 also asks for a white courtyard at the S flight top instead.
5. Island rock still reads faceted and bright where a fill light is close (up to about 212 near a light in c3).

## Objects built (for 5 Object Recipes)
All the meshes below are in `tools/ae_kit.py`, in the pass-10 section at the end of the file: `build_hero10`, `build_trip10`, `build_scale10`, `build_all10`, `R10_PREFIXES`, `export_r10`.
They were authored Y-up, then passed through `to_zup_and_uv()` and exported by `export_r10()` (19 meshes with the cube).

### Hero corner with a recessed single-tier basin `K_Hero_*` (`build_hero10`)
- A text copy of `build_hero6` with these changes:
  - `bw` is 33.1 (was 29.6);
  - the basin lathes are scaled 0.85: foot r 5.45, bowl r 4.75 with an inner floor at 1.6 and water at 2.05, band r 4.8-4.9, gold lip r 4.15-4.8;
  - the upper tier, the bars, the curved sheet and the splash are deleted.
- The rest is unchanged: the arch bands, crest, wings, lanterns, pool, the 4-way mirror and the turf split.
- The basin still fits the block notch (|u| < 6.5, w 34-41) and the arch opening (half-width 6.5).

### Triptych gate `K_Trip10_*` (`build_trip10`)
Faces -Z; x is lateral.
- **Bays (teal):** three `bay()` wall bays, 3 deep, round-arched openings:
  - centre: hw 6, top 20, opening 4.5, springing 11;
  - sides: hw 4, top 14, opening 2.6, springing 7.5, at x ±10.5.
- **Trims (gold):** `tube_along` gold trims round each opening (pushed out 1.04x, 0.1 in front) and along each top.
- **Fields:**
  - the centre field (`portal`) and the side fields (`glass`) are `extrude_outline` of the opening outline, 0.3 thick, set 0.6 back;
  - the swirl is a 75-point Archimedean spiral (r = 0.21 t, y squashed 1.1), tubed at 0.18 (`swirl`, Neon in Studio).
- **Pale pieces:** a lathed statue on a plinth in front of the portal, and 4 lathed columns (15 or 11 tall) with urns between and beside the bays.
- **Crest (gold):** a 7-point tube rising to 24.2, plus two 16-point curls either side.
- 5.7k triangles in total. Studio colours: teal (40,140,140), gold (150,128,48), pale (205,228,222), portal (20,110,110), swirl Neon (90,220,205) T 0.15, glass (60,170,170) T 0.35.

### Scale cube `K_Scale10_stone`
- 10 studs. Dropped on merge.

### Studio-side constructions (`fix/build_plaza.lua`, pass-10 edits marked "pass 10")
- **Slatted drum:**
  - a stem cylinder 1.4 tall x 2.2;
  - a drum cylinder 1.8 x 4.0 with 12 slats 0.35 x 1.5 on r 2.02;
  - a gold lip ring 4.6 at the top, a 4.2 band below, and a water disc.
  - Its centre is the basin centre (`BASIN_R / √2` per axis).
- **Raid gable:**
  - a block 9 x 9 x 16 on the facade top;
  - two WedgeParts 9 x 8 x 5. A wedge is tall at +Z, so the one on +Z is turned 180 degrees to put its tall side against the gable;
  - two pinnacles;
  - the skull is lowered into it.
- **Island fills:** 3 invisible anchor parts per island with PointLights below the rock.
- **Island rock squash:** scale `Size.Y` by 0.6, then move the part so its top stays at the cap.
- **Puff tree:** a trunk Part plus 4 sphere blobs (one top, three round it at 0.25 d).
- **Fading fall:** 4 segments with stepped transparency and widening 0-15%, a lip, and a mist emitter at 0.7 of the length.
- **Plan-only shrink:** for a model whose parts are rotated only about Y, scale `Size.X`, `Size.Z` and the X/Z offsets from the pivot.

## Lessons (for the workflow vault)
1. **Before resizing a piece, find every mesh that draws it.** The "oversized drum" was two things: my Part drum and the hero's own
   upper basin tier underneath. Shrinking the Part only uncovered the bigger one. A one-off capture with each token painted a loud colour
   (red rib, green darkStone, blue vault, white stone) mapped the whole arch in one frame and made the two-tone fix a five-minute job.
2. **A colour target is a rendered value: fit the base colour with a ratio from one test capture.**
   - Base -> render ratios here:
     - SmoothPlastic in sun about 1.12-1.24x;
     - Slate treads about 1.45x;
     - Metal about 0.75x, and it greens and desaturates gold;
     - surfaces lit only by the Ambient (undersides) about 0.8 x Ambient x base.
   - One test capture, one corrected value, one check capture landed every arch and stair colour within about 10.
3. **When a face sees only the Ambient, no base colour reaches a target outside the Ambient's hue.** The purple Ambient caps green
   at 74 x base. The fix is light, not paint: a few soft no-shadow PointLights under each island turned violet (70,50,88) into
   grey-green (100-165) without touching the global Ambient.
4. **Place sky objects for every camera that sees them, using elevation angles.** Pushing the islands far out opened p1 but emptied
   c3. Converting each reference frame's pixel band into degrees above the eye gave one rule, underside about 6 + 0.47-0.55 x distance,
   that serves both the flat spawn views and the tilted close-ups.
5. **Never put code after a `--` comment on the same line.** Three r9 statements (two light parents, a collision flag) silently did
   nothing for a whole round. A `grep -nE -- "--.*; *[A-Za-z_.]+ *= "` sweep finds them. Write the comment last, or on its own line.
6. **Fixing a dead light changes the whole look.** Once the Raid lights really existed, the facade went flat red and the red letters
   vanished. Re-measure after any bug fix that touches lighting, and give text a contrasting value (pale on red).
7. **Coloured fog and coloured lights eat the other channels.** Red fog plus red lights rendered a (165,78,80) facade as
   (196,30,49). Thin the fog before raising the base G/B.
8. **Shrink in plan only when a review says "footprint".** A uniform 0.75x made the Story tree small in p4, where the reference tree is
   tall. Scaling X/Z sizes and offsets about the pivot works when the parts are rotated only about Y.
9. **Use the review's sizes as a direction and judge in the frame.** "Lift by 20-25" was right in spirit, but the frame that counted
   was the angle band. The right answer came from measuring pixels, not from adding studs.
10. **Some Terrain properties cannot be scripted from the MCP context** (`Decoration`, `GrassLength`). Wrap them in pcall and put
    them on the lead's checklist.

## Files
- `fix/build_plaza.lua`:
  - r10 merge entry, plus `HAS10` / `BASIN_R`;
  - hero two-tone, gold and stairs values;
  - drum, sheet and ledge;
  - Raid gable, lights, fog and Boss Rush;
  - Story;
  - triptych and shard ring;
  - island block rewritten (positions, colour, fills, squash, puff trees, fading falls);
  - N verges, spill thinning, and the three comment bugs.
- `tools/ae_kit.py`: pass-10 section. `ae_kit.blend` (saved). `kit/own/ae_kit_r10.fbx` (19 meshes, imported).
- `out/r10/r10_*.png`: 12 cameras.
