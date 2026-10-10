# Fix pass 9: Anime Expeditions spawn plaza (big close islands, mid-distance architecture, glowing Raid, slate arches, fountain core, terrain lawns, 3D letters)

This is the builder report for `notes/fix_brief9.md`. It answers the round-6 review `notes/verify6_plaza.md` (5.67/10, live reference).

**Captures:** `out/r9/r9_<cam>.png`, 12 cameras, 1452x793 (the same frame size as verify6). Each camera was captured twice and the second frame kept.

**Rules kept:**
- I built only from the pictures (`out/verify6/*_ref.jpg`) and the review. I did not open or capture anything in the reference studio, and I did not open `ae_reference.blend`.
- The practice place is not saved and nothing is committed. `ae_kit.blend` is saved.
- No computer use. The lead imported the FBX.

**Import.** The lead imported `kit/own/ae_kit_r9.fbx` with Import 3D (Scene Position + Anchored).
- 38 MeshParts arrived.
- The scale was clamped to **14.37**, measured from `K_Scale9_stone`. `K_Isl92` is about 142 studs long, so the importer shrank the whole model.
- `build_plaza.lua` merged the pieces into `ServerStorage.Kit` by name and dropped the cube. Any `K_Scale*` piece is now dropped.

## What changed, per priority

### 1. Islands (big, close, lush)
- **Placement.** The pass-7/8 islands, which sat 400-700 out, are removed. In their place are 10 own `K_Isl91` / `K_Isl92` slabs:
  - 0.85-1.1x scale, so about 95-150 long;
  - 110-250 out (most at 150-180);
  - tops at 92-135, undersides at about 65-105.
- **Each island carries:**
  - a 10x10x50 ruin tower (`K_Ruin8` at 1.25x);
  - a rotunda (`K_Rot9`) or a domed tower (`K_Dome8`) on alternate islands;
  - an aqueduct (`K_Aque9`) on every other island;
  - 5 green trees (90-100,160-170,55-65);
  - 2 wide falls (`K_Fall9`), found by a raycast onto the rock from the plaza side.
- 3 big cumulus banks (`K_Cloud7` at 4.2-4.5x) sit behind them.
- **Result:** in c3, c4, p1 and p2 the top third of the frame is now filled with island rock, vines, towers and falls, which is the reference's composition.
- **Still off: the undersides render purple-dark**, sampled **(68-74,52-56,88-89)** in c3 against a light grey in the reference. The undersides are lit only by the reference's purple Ambient (102,74,101).
  - The rock base went from (160,162,155) to (196,198,190) to (222,225,218) Slate; each step was still violet.
  - **Next step:** shift the rock base toward green/cyan to cancel the purple, or add a soft white fill light under each island.

### 2. Mid-distance architecture
- Own `K_Guild9` (about 57 x 49) at NW, cream (225,215,185), with gold trim, blue domes and own green 3D "Guilds" letters on the attic.
- Two own `K_Palace9` domed palaces (blue domes (40,80,170)) at SE and SW, 158 out.
- Three own `K_Tower9` grey towers (8 x 8 x 74, slate spire) at NNW, NNE and WSW.
- p7 shows them closing the gaps between the landmarks.

### 3. Raid
- **Facade and skull:**
  - The brick tower is replaced by a red facade (150,58,64) Slate, 44 wide x 30, with buttresses and glowing red windows.
  - The skull is `K_Skull8` at 2.0x (about 21 wide), sunk into the facade so that only the top of its pedestal shows. It is coloured (185,75,80) with Neon eyes.
  - I tried 2.3x first. It overpowered c3: about 230 px wide, against about 160 px in the reference.
- **Sign and keystone:**
  - A short neon beam runs from the mouth to own 3D "Raid" letters, Neon (255,90,90), about 14 x 5, set in front of the pedestal foot.
  - A small bone-white skull keystone sits over the gate.
- **Lights and fog:**
  - There are three red PointLights at **range 45 / brightness 1.2**. The brief's range 50 / brightness 3 burnt every face to flat (255,0,0) in the first p3 capture.
  - The fog is denser and lower: Rate 14, LightEmission 0.35.
  - Dead trees are black (40,30,35), on the Raid and in the east cover.
- **Boss Rush tower:** a dark gothic block 15 x 15 x 34 with a spire, a purple Neon portal (200,80,255) with a light, and own purple 3D "Boss Rush" letters. It stands left of Raid as seen from the spawn.
- **Sampled:** the skull in p3 reads (133-146,38-42,60-66), against (203,84,88) in the reference. It is the right hue family but darker and more magenta. **Next step:** raise the skull base to about (215,105,105).

### 4. Fountain arches
- `K_Hero_stone` is now (56,60,68) and renders **(56,68,82)** on the c1 cheek. The target is (65,72,85). The gold edges are kept.
- The vault is now (36,42,48).
- The cyan vault light went from brightness 3 to 0.5. It had been tinting the vault navy, sampled (26,54,95) in verify6.

### 5. Fountain core
- **The egg dome was two hero tokens:** the glass `K_Hero_sheet` dome with the Neon `K_Hero_foam` inside it. Both are hidden (Transparency 1).
- **New Part construction per basin:**
  - a slatted drum (50,60,70) with 16 slats and two gold bands, covering the old pale drum and the gold rods;
  - a water disc on top;
  - a slate ledge with a gold lip at the arch crown;
  - a 4-wide water sheet (120,210,235) SmoothPlastic at T 0.3. As Glass at T 0.3 it vanished against the dark vault.
  - spray particles.
- **Not done:** pulling the basin back 4 studs. The basin is part of the hero mesh, so it needs a hero re-export.

### 6. Summon
- Own `K_Summon9`, a two-storey arcade 50 wide x 35, replaces the pass-7 hall:
  - 5 big arches below and 7 above;
  - cream (225,210,170), a blue band (50,90,180), a gold frieze and a pediment;
  - own gold 3D "Summon" letters.
- The corner towers moved out 6 and the dome was raised.
- The 4 gold trees are now 2.1-2.6x, about 35-40 tall. The 6 blue cypresses are 1.2x.
- The statue and the avenue stalls/flags were not changed.

### 7. Foliage and far field (with the lead's terrain correction)
- **Lawns are Terrain:**
  - Roblox Terrain Grass is painted with `Terrain:FillBlock` as 4-stud slabs centred at y 4.6, so the surface lands just above the terrace at y 6.
  - The grass colour is set with `SetMaterialColor` to (110,170,70). It samples **(104,175,70)** on the S lawn in p2.
  - Painted areas: the S/W stair-top lawns, the S-top strip, 12 N-avenue verges, the 4 planting beds behind the pools and a Story lawn.
  - The Lawn/LawnTop Parts are removed.
  - The grass decoration blades render, so `Terrain.Decoration` is on. Scripts cannot set it from the MCP context ("not a valid member"); the lead is confirming it in Properties.
- **Coloured beds:** two red beds beside the Raid forecourt are painted in Glacier, with an own plain-colour `MaterialVariant` "AE_RedBed" as the Glacier base-material override and a red material colour (200,60,55).
- **Spills replace mounds:** all 70 small mesh clumps on the stairs, the floor and the lawns are replaced by own flat `K_Spill9` leaf spills, under 0.4 tall:
  - blue (60,130,230), red (220,70,70), green (120,190,60);
  - the 2.4-3.6x red bush mounds in the east field are removed.
- **Far field:**
  - **East:** the gravel patches are now grey (104,107,109), with the red litter kept.
  - **West:** a blue lagoon (60,170,220) with a sand beach (225,205,150), 126 / 150 across.
  - **South:** a white courtyard (90 x 64) behind Expeditions, ringed by 9 white arcade wings (`K_Arcade7` at 1.3x).
  - **North:** the existing water channel is kept.

### 8. Story
- Own `K_Ring9`, a thin ring (2.4 deep against about 10 before):
  - silver-blue (130,160,210) with gold trims front and back, 8 blue gems and a fan crest with a gem;
  - a black void (2,4,10), with the blue glow overlay at T 0.96;
  - own blue 3D "Story" letters (90,150,255).
- The old ring, void, plate and crown are removed. The trunk is tan (150,115,80).
- In p4 the ring now reads as a frame, not a barrel.

### 9. Expeditions (partial)
- Own teal 3D "Expeditions" letters (100,230,200) replace the plate.
- The halo shards are grey stone (110,125,145) and the halo is lowered 5 studs.
- The triptych gate was not built.

### 10. Details (partial)
- 8 gold studs (Metal) ring the medallion.
- The bollards are white (235,237,230). They are not shortened.
- 8 blue crystal pods (`K_Pod8` at 0.95x) sit on the terrace beside the kiosks. At 1.4x they walled in c4.
- Not done: the medallion blades and the floor tile joints.

## What I measured from the pictures
- **c4 / c3 islands.**
  - In c4 the reference island band fills y 0-280 of 793 px. From the c4 camera (eye 6, looking up about 7 degrees) that is an elevation of about 25-40 degrees.
  - An island at 150 out therefore needs its underside at about 65-80 and its top near 95-105.
  - The islands span most of the frame width, so they must be about 100+ long at 150 out.
- **p3 skull.** About 120 px wide at about 100 studs from the camera, which is about 18-22 studs. Hence 2.0x (about 21), not 2.3x.
- **c1 arch.** The reference cheeks are as dark as the vault mouth surround. Only the gold bands and the top rim read lighter. Hence the whole stone token goes slate.
- **p1 / p4 letters.** The landmark words are chunky serif letters about 1/3 of the facade width. Georgia Bold at 4-5.6 cap height gives 14-20 wide words.

## Still off / for the lead
1. **Island undersides render violet-dark** (see item 1). This is the biggest remaining colour gap in c3, c4, p1 and p2.
2. **The waterfalls read as pale pillars**: SmoothPlastic (190,225,245) at T 0.4. They are better than opaque white, but a little solid. Try T 0.5 or a faint Neon foam.
3. **The skull is darker and more magenta** than the reference (see item 3).
4. **Not done:** the basin move, the Expeditions triptych, the medallion blades, the floor tile joints, bollard height, and avenue stalls/flags.
5. Lighting is re-applied (`fix_lighting.lua`). `Lighting.Technology` was not checked.

## Objects built (for 5 Object Recipes)
All the pieces below are in `tools/ae_kit.py`, pass-9 section: authored Y-up in studs, then `to_zup_and_uv()`, then `export_r9()`.

### Island slab `K_Isl91` / `K_Isl92` (R 50 / 56, aspect 0.56 / 0.5)
- **Rim:** a 44-point noisy outline (sin 2/3/5 harmonics plus jitter).
- **Rock:** 6 shrinking rings down to y -26 (random scale and height below the second ring) plus a bottom point, and 9 hanging lathed spikes 8-20 long.
- **Grass cap:** 4 rings:
  - a domed top at 3.0;
  - an overhang at 1.05R, y 1.6;
  - a lip at 1.07R, y -0.8;
  - a **jagged skirt at 1.035R, y -2 to -5**, which gives the drooping lawn edge.
- **Vines:** 7 curtains of 11 double-sided strips, 10-20 long, longest in the middle.
- **Colours:** rock Slate (222,225,218 base), grass (110,170,70) Grass, vines (70,140,60).

### Aqueduct `K_Aque9`
- 5 `bay()` arch bays: 8 wide, opening 5.8 wide with the springing at 8, and a deck at 13.6 with parapet lips.
- The last bay is broken (lower top) and has a rubble stub.

### Rotunda `K_Rot9`
- A 2-step lathed base (r 8), 8 lathed columns on r 6, an entablature ring, a dome to 21.6 and a lantern to 24.

### Wide fall `K_Fall9`
- A double-sided bowed grid sheet, 7 wide widening to 9.5, 50 long, drifting 2 out as it falls.
- A 4-sphere foam lip and a 9-sphere mist foot.

### Guild facade `K_Guild9`
- A cream block 46 x 33 x 12 with 6 pilasters and 3 gold cornices.
- Dark arched windows on 3 floors (`arch_win`: an extruded arch outline set 0.1 proud) and an arched portal with a gold tube trim.
- An attic with a pediment prism and a gold tube outline.
- 2 corner towers with blue lathed domes and gold finials.
- Tokens: cream, gold, dark, blue.

### Domed palace `K_Palace9`
- A cream block 24 x 20 x 24 with arched windows on all 4 sides (the outlines transformed by rotation).
- A drum (r 9) with 12 window slots, and a blue dome to 43 with a gold lantern.
- 4 corner turrets (r 3.2) with blue domes.

### Grey tower `K_Tower9`
- An 8x8 shaft 52 tall with cornice bands every 13 and arched windows on 4 faces x 3 levels.
- An open 4-bay belfry and a 4-sided lathed spire (4 segments, turned 45 degrees) to 74.

### Summon facade `K_Summon9`
- 5 `bay()` arches below (hw 5) and 7 above (hw 3.57).
- A blue band and gold strip between the storeys, a gold frieze, an attic, and a pediment with a gold tube.
- A dark back wall and a body block behind.

### Thin Story ring `K_Ring9`
- A `_band_xy` annulus (r 7.4-9.4, 2.4 deep) with gold tube trims on both faces and 8 bipyramid gems per face.
- A fan crest (a 13-point star outline, extruded), a gem, 2 prism feet and a void disc.

### Leaf spill `K_Spill9`
- A ragged 28-point base splash at 0.08, plus 70 near-horizontal leaf cards (`card()` with a 0.02-0.1 rise).
- Under 0.4 tall in total; the leaf/leafRim split is tinted at placement.

### 3D letters `K_Txt*9` (`build_text9`)
- A Blender FONT curve in an installed system font (Georgia Bold), with extrude 0.5-0.7, bevel 0.12 at bevel resolution 0 and `resolution_u` 4.
- Converted with `new_from_object`, rotated 180 degrees about Y so it reads from -Z, and triangulated.
- That gives 4-10k triangles per word. The defaults gave 20-44k.

### Scale cube `K_Scale9_stone`
- 10 studs, dropped on merge.

### Studio-side constructions (`fix/build_plaza.lua`, pass-9 block)
- **Slatted drum:** a Part cylinder plus 16 slats on r 3.35, gold band rings below the rim (not a disc on top), a water disc, a ledge, a sheet and a spray emitter.
- **Raid facade:** Parts, with the skull at 2.0x sunk into it, three red lights and fog.
- **Boss Rush tower:** a Part block, `K_Spire` at 1.6x, and a Neon cylinder portal with a rim and a light.
- **Lagoon and beach:** cylinder Parts.
- **Courtyard:** a slab plus white arcade wings.
- **Terrain lawns and beds:** `FillBlock` slabs plus the `AE_RedBed` MaterialVariant, as described in item 7.

## Lessons (for the workflow vault)
1. **Lawns and coloured ground belong in Terrain, not meshes.**
   - Paint Grass with `FillBlock` (4-stud slabs centred about 1.4 below the floor top, so the smoothed surface lands just proud of it) and tint it with `SetMaterialColor`. Terrain decoration grows the swaying blades.
   - Give coloured beds an own plain `MaterialVariant` set as the base-material override.
   - Mesh clumps on steps read as "hedgehogs"; terrain grass reads as lawn at once.
   - `Terrain.Decoration` cannot be set from an MCP/command script: tick it in Properties.
2. **Size from angles, not from "3x".** Turn the reference's screen band into an elevation angle from the camera (y px / frame height x vertical FOV). That gives height and distance together. "Close and big" meant moving the islands from 400-700 out to 150-180 out, more than scaling them.
3. **Even close geometry can be lit by Ambient alone.** Island undersides face away from the sun, so they render the Ambient colour (here purple) times the base. Raising the base brightness alone stays violet. Counter-tint the base, or add fill light.
4. **The brief's light numbers are a direction, not a setting.** Three PointLights at range 50 / brightness 3 flattened the Raid to pure red. Test, sample, and back off until the shading returns (here brightness 1.2).
5. **Find what an object is made of before removing it.** The "egg dome" was a Neon core inside a glass dome, from two different tokens. Hiding one token and capturing after each change settled it in two captures.
6. **Glass at low transparency disappears against dark backgrounds.** For a water sheet in a dark vault, or a waterfall against sky, SmoothPlastic at T 0.3-0.4 reads better.
7. **Text as own geometry is cheap in Blender**, but cut the curve resolution (`resolution_u` 4, bevel resolution 0). The defaults made 20-44k triangles per word.
8. **A cube in the export is what makes partial kits safe.** One 142-stud island clamped the whole import to 14.37x, and only the 10-stud cube let the script restore true sizes.
9. **Keep the placement script parseable and run it whole.** One bad string edit gave a parse error. Nothing ran, so the scene survived, but I captured a stale build once. Check the script's return line before capturing.

## Files
- `tools/ae_kit.py`, pass-9 section:
  - builders: `build_island9`, `build_aque9`, `build_rot9`, `build_fall9`, `arch_win`, `build_guild9`, `build_palace9`, `build_tower9`, `build_summon9`, `build_ring9`, `build_spill9`, `build_text9`, `build_scale9`;
  - batch and export: `build_all9`, `R9_PREFIXES`, `export_r9`.
- `ae_kit.blend` (saved).
- `kit/own/ae_kit_r9.fbx`: 38 meshes, imported.
- `fix/build_plaza.lua`: the r9 merge import, the hero recolour, the vault light, and the pass-9 block (fountain core, details, Raid, Boss Rush, Summon, Story, Expeditions, buildings, islands, far field, terrain lawns/beds, spills).
- `fix/fix_lighting.lua`: unchanged, re-run.
- `out/r9/r9_*.png`: 12 cameras.
