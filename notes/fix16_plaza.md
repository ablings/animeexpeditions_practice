# Fix pass 16: Anime Expeditions spawn plaza (missing pieces, red light on the Raid)

Builder report for `notes/fix_brief16.md`, answering the round-13 review `notes/verify13_plaza.md` (7.42/10).
Items 1-5 are done. Items 6-10 were not attempted (see "Not done").

**Captures:**
- Final set: `out/r16/r16_<cam>.png`, 12 cameras, 1452x793 (`capture_set2.py`, two frames per camera, the second kept).
- Contact sheet: `out/r16w/contact.jpg`.
- Working frames: `out/r16w/t1..t11_*`.
- Blender test renders: `out/r16w/blender_blade16.png`, `blender_bollard16.png`, `blender_trunk16.png`.
- Reference study (screen_capture only, live reference): `ref16_medal_top`, `ref16_bollard`, `ref16_raid_mid` in the
  session's capture store. They are described below; nothing was read from the reference place except pixels.
- Colours are 5x5 means (`out/r14w/samp.py`) against `out/verify13/v13_<cam>_ref.jpg`.

**Rules kept:**
- Pictures only. `ae_reference.blend` was not opened.
- Own geometry and textures only (the pass-14 leaf textures are reused).
- No computer use. The practice place is not saved and nothing is committed. `ae_kit.blend` is saved.

**How to rebuild** (on a pass-15 build, after importing `kit/own/ae_kit_r16.fbx` as `ae_kit_r16`):
- Run `fix/pass16.lua`. It merges the r16 kit into Kit and does everything below. It is idempotent: it rebuilds
  `Plaza.Pass16` on every run.
- Hidden old pieces get the attribute `P16Hidden`, with their transparency kept in `P16T`. Recoloured pieces keep their
  old colour in `P16Col`.
- Scaled island pieces keep their original CFrame and size (`P16CF0`, `P16Sz0`, `P16Sc0`, `P16P0`), and every run
  recomputes them from those.
- **Order:** run pass16 AFTER pass 15. The pass-15 spill clumps are laid on the island's current bounding box, so
  re-running pass 15 after pass 16 lays them on the scaled island. Pass 16 hides the N-island ones anyway.
- `fix/build_plaza.lua` has r16 in `IMPORTS` and carries the pass-16 block after the pass-15 block. That block was
  pasted, not run (I did not do a full rebuild).
- Run with `python cmd/runlua.py fix/pass16.lua <studio>` then `python mcpcli.py call execute_luau cmd/pass16.json`.

## 1. Raid lit red

**Why it read as daylit brick:**
- The facade faces west, and the sun is at (-0.27, 0.85, 0.45). The stone was lit by the sun head-on.
- Low red uplights cannot compete with that. Most of the red the reference shows is in the stone's own lit colour.

**Facade colours:**

| part | old | new |
|---|---|---|
| facade brick | (95,40,45) | (128,46,48) |
| trim and domes | (130,60,60) | (160,62,60) |
| K_Gothic stone | — | (170,84,82) |
| door back | — | (8,4,6) near black |
| skull bone | — | (196,112,100) |
| skull pillar | — | (150,62,60) |

The first try at (168,64,60) made the facade foot (165,55,62), where the reference foot is dark (50,45,47).

**Lights:**
- The pass-15 uplights are off. 4 new SpotLights (255,60,50), brightness 1.5, range 40, angle 50, sit at the stair foot
  (x 138, z ±10/±30), aimed at y 58.
- Doorway: a PointLight (255,50,40), range 20, brightness 2, inside the door. A red Neon strip (0.35) follows the pointed
  arch: legs at z ±6.6 up to y 18, then two arcs of radius 10.14 to the apex at y 27.5. The arch size was measured by
  raycasts into K_Gothic.

**Haze band** (pass-15 emitters off): one box-volume ParticleEmitter, `RaidHaze16`, 24 x 52 x 104 at (186, 68, 0). It sits
behind the facade plane, from the facade cap to the skull's eyes, and wider than tall.

| try | settings | p3 haze sample |
|---|---|---|
| t1 | box at y 22-66 | hidden behind the facade; sky (65,199,241) where the reference has haze |
| t2 | box 20 x 46 x 76 at y 80 | round glow behind the tower again |
| t3/t4 | wider box, (200,70,60), LightEmission 0.15, LightInfluence 0.4, T 0.4/0.5 | (186,134,162) to (227,147,159): sky leaking through, and lit |
| final | (176,92,84), unlit (LightEmission 0, LightInfluence 0), T 0.22/0.3, rate 10, size 16-24 | (157,104,117), (166,113,124), (200,105,105) |

The reference samples (161,116,110) and (146,108,113).

**Keystone skull:**
- The small pink plinth-and-skull over the door (the `K_Skull8` under 20 tall) is hidden.
- A 3.2-stud `K_Skull7` sits in the arch apex at (157.2, 29.6, 0), turned to face the plaza: bone (150,80,72) Slate, sockets
  (40,10,14), red Neon eyes. Behind it is a keystone block in K_Gothic stone.

**Palm:**
- The drooping `K_Soft13P` palm left of the door (z -26) is hidden.
- An upright `K_Palm6A` stands at (146, ground, -22): fronds (80,20,25), rim (120,30,36), trunk (70,30,30).

## 2. Skyline (`--SKY` block)

**N islands:**
- The 5 N islands (original centre z < -100) are scaled 1.6x about their original centre and dropped 12.
- Everything that belongs to them goes too, picked as in pass 15 (plan radius + 25, at most 45 below the centre):
  Islands, IslDress12, Trees13 clumps, pass-14 towers and aqueduct. 433 pieces.
- Parts: size × 1.6, position = c0 − (0,12,0) + (p0 − c0)·1.6.
- Models: `ScaleTo(scale0·1.6)` and then the same pivot formula. Both are recomputed from the stored originals, so
  re-runs don't drift.

**Dressing:**
- Island grass (105,185,70), vines (60,140,55).
- Every N-island fall is Neon (170,220,245), T 0.35, so the falls glow.
- Per island: a skirt of 16 green `K_Soft15K` clumps (scale 1.3-1.9) hung 2-8 below the rim, 3 trees (`K_Soft15R`/`U`,
  scale 1.6-2.1) raycast onto the top, and one new fall (3.6 x 34, T 0.3) with a mist emitter on the rim facing the plaza.
- The pass-15 spill clumps of the N islands are hidden.

**Result:**
- c4: green-capped islands with trees and towers fill the band from y 0 to about 230, and falls show at left and right.
- c3: the upper left is green islands with trees and towers, not open sky.
- p1: the islands fill the top centre, as in the reference p1. The towers reach the top edge, as the reference's do.

## 3. Bollards and medallion (r16 kit)

**What the reference shows (top capture and bollard close-up):**
- Medallion: a compact 8-blade shuriken about 0.55 of the pale disc's radius. Thick roots joined round a dark ring, hooked
  tips, a gold hub, and 8 gold studs on the pale disc inside the gold ring.
- Bollard: a light stone foot with a gold, pointed, faceted cap.

**Medallion:**
- `K_Medal_darkStone` (the 8 long sweeping blades reaching the rim) is hidden.
- `K_Blade16_dark` is placed on the pale disc top (raycast, y 0.40), turned 11°: (32,40,48) Slate.
  The first colour, (45,55,65), sampled (59,82,97).
- 8 gold Metal studs, 1.1 across, sit at r 6.9.

**Bollards:**
- The 4 `K_Bollard` models and the pass-14 cap/knob/tip are hidden.
- `K_Bollard16` stands in their place, turned with a face to the plaza centre. Body (150,155,160) Slate, cap (215,170,55)
  Metal.

## 4. W quarter (`--WEST` block)

**Lagoon:**
- Ellipse 50 x 40 at (-92, -34): water (60,170,220), a deeper centre (35,120,200), and a sand lip (225,205,150) 3 wider.
- Shape: Parts with a Cylinder SpecialMesh, which stretches to an ellipse.
- The 3 pass-13 palms that stood in the water are moved out to the rim (original pivot in `P16CF0`).
- A ring of 16 blue `K_Soft15B` bushes (scale 1.4-2.0) and 3 cloned blue palms surrounds it.

**Arena:**
- The pass-14 arena discs and studs are hidden.
- Three Marble steps, 0.9 high each, 46 / 40 / 34 across, colour (232,232,226). A 0.22 gold band sits under each step's
  top edge, and 24 gold studs are on the top step.
- The first rims sat ON the step tops, and the whole arena read as a gold disc in p8.

**Cover:**
- Blue bushes on 85% of the open 8-stud cells. "Open" means the raycast hits GroundW/N/S or a K_Patch lawn patch.
- Area: x -152..-42, z -100..64, keeping out of the arm (|z| < 15), the lagoon and the arena. 124 bushes.
- p8: the W half is now mostly blue foliage, water and the white arena.
- Flat blue disc beds in the gaps read as polka dots from p8 and were dropped.

**Story tree:**
- The straight pass-11 trunk cylinders are hidden.
- `K_Trunk16` is placed at (-122, ground, 0), scale 1.04, (150,110,75) Wood.
- The canopy gets 10 more clumps (clones of the pass-14 canopy clumps) on a ring of radius 28-33 at y 62-70, so it is
  about 75 across.
- In p4 the limbs show forking under the canopy.

## 5. Stair grass

**Lip strips:**
- For each lateral offset (every 1.5, outside the runner |l| > 5), march outward along the S (+Z) and W (−X) arms until the
  raycast leaves `K_Stairs_*`.
- Two rows of 1.3-1.7 `K_Grass` tufts (110,200,60) go there: 60 in all.

**Treads:** 16 tufts 2-3 tall per flight, on the treads or within 4 past the lip: 32 in all. p6 and p4 now read overgrown.

## Not done
- Items 6-10: foliage depth shading, Summon facade/stalls/pineapple, wing flanks and pods, litter, S side.
- The Raid facade foot is still lighter than the reference: (128,42,55) against (50,45,47).
- The skull's lit cheek is (221,76,78) against the reference (232,139,123).
- The haze still leaks a little sky blue at its upper-left edge: (133,124,153) in one frame.
- The p2 "shard ring" over the S gate is unchanged.

## Lessons (for the workflow vault)
1. **Check which way the sun hits a face before lighting it.** A facade facing into the sun cannot be made red with
   coloured lights in daylight. Put the colour in the material and use lights only for gradients and accents (the door
   glow).
2. **A haze emitter behind a solid facade does nothing for the facade.** It only shows where there is sky behind the
   silhouette, so place the band where it can actually be seen.
3. **Particle haze over sky: work out the colour from the target.**
   - A haze colour C at cover a over a sky S shows as a·C + (1−a)·S. Solve for C: C = (target − (1−a)·S) / a.
   - Turn off LightEmission and LightInfluence, so the emitter colour shows as set.
   - A thin, lit haze takes on the sky's blue and goes pink-mauve.
4. **Build a decorative ring as a band under the step's top edge, not a disc over it.** A slightly larger disc laid on a
   step covers the whole step.
5. **To stretch a cylinder into an ellipse, use a Part with a Cylinder SpecialMesh.** A Cylinder-shaped Part stays round.
6. **To scale a floating island with all its dressing, store each piece's original CFrame, size and scale on the piece.**
   Recompute from those every run: new = anchor − drop + (p0 − c0)·k. Models use `ScaleTo(scale0·k)` plus `PivotTo`. Then
   any k or drop can be retuned without drift.
7. **Find stair lips by marching raycasts until the hit leaves the stair mesh.** Grass, kerbs or any edge dressing then
   follows the real edge without hand-measured coordinates.
8. **When the reviewer says "N thin blades", look at the reference from above first.** The top capture showed blades about
   half the disc's radius with thick joined roots: closer to a solid star than to N strokes. That changes the mesh, not
   just the count.
9. **For ground cover, use dense small 3D clumps, not flat discs.** Flat discs read as polka dots from above; small bushes
   read as solid foliage.

## Objects built (for 5 Object Recipes)

### Medallion shuriken (`tools/ae_kit.py`: `build_blades16`)
- 8 × `extrude_outline(blade_outline(2π·i/8, r0 1.3, r1 4.9, sweep 0.62, w 0.95, n 12), depth 0.12)`, turned flat, normals
  flipped.
- Plus a dark disc of radius 2.1, merged and triangulated (`merge_objs`). 1024 triangles, 9.7 across.
- Studio: (32,40,48) Slate on the pale disc, a gold hub (existing), and 8 gold cylinder studs (1.1 across) at r 6.9.

### Squat bollard with a mitre cap (`build_bollard16`)
- Square sections are 4-segment lathes turned 45° (radius = half-side × √2).
- Foot: 3.0 wide, 0.5 tall, with a 0.12 chamfer.
- Body: tapers 2.4 to 2.0 up to y 2.3, then a 0.2 collar to 2.5.
- Cap: a faceted pointed gold square dome, profile half-sides 0.95 → 0.9 → 0.72 → 0.42 → 0, from y 2.5 to 4.55.
- 120 triangles. Grey Slate body, gold Metal cap.

### Gnarled trunk with 5 limbs (`build_trunk16`, `taper_tube`)
- `taper_tube(pts, radii, res, jitter)`: rings along a polyline with a radius per point and ±jitter roughness, capped ends.
- **Trunk:** 7 rings with radii 8.5 (root flare) → 6.2 → 5.2 → 4.6 → 4.9 → 4.4 up to y 29, with a slight lean and wobble.
- **Roots:** 5 buttresses from (r 4.5, y 5.5) to (r 10.5, y −0.6).
- **Limbs:** 5 from y 25, each reaching R 17-26 out and H 44-52 up through 3 jittered midpoints. Radii 3.0 → 0.9, and
  one side branch per limb.
- 866 triangles. Placed at scale 1.04 so the limb tips reach the canopy underside at about y 60-66.

### Raid door glow (Studio)
- Neon segments (0.35 square, (255,40,35)) along a pointed arch: legs, then two arcs of radius 10.14 whose centres sit
  3.54 past the axis.
- Each segment uses `CFrame.lookAt(midpoint, next point)` with length |b−a| + 0.2.
- A PointLight (255,50,40), range 20, inside the door.

### Lagoon (Studio)
- Three stacked ellipses (Parts with a Cylinder SpecialMesh): sand lip +6, water, and a deeper centre at 0.55 × 0.5.
- A ring of 16 bushes at the rim + 3.5, and palms at the rim + 4.

## Files
- `fix/pass16.lua` (new).
- `fix/build_plaza.lua`: r16 in `IMPORTS`; pass-16 block appended after pass 15.
- `tools/ae_kit.py`: pass-16 section (`build_all16`, `export_r16`, `build_blades16`, `build_bollard16`, `taper_tube`,
  `build_trunk16`). `ae_kit.blend` is saved; its test scene `T16` holds a camera.
- `kit/own/ae_kit_r16.fbx`: 5 meshes, including `K_Scale16_stone`. Imported.
- `out/r16/`, `out/r16w/`.
- Practice place: `#workspace.Plaza:GetDescendants()` = 13570 at the end. Selection cleared. Not saved.
