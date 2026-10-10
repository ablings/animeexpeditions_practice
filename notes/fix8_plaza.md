# Fix pass 8: Anime Expeditions spawn plaza (freestyle: waterfall curtains, weathered Raid, Expeditions halo, Story trunk)

This is the builder report for `notes/fix_brief8.md`. It answers the round-5 review `notes/verify5_plaza.md` (6.42/10, provisional).
- Captures are in `out/r8/r8_<cam>.png` (12 cameras, two shots per camera, the second one kept).
- I made no compare sheet: there is no `ref_<cam>.png` set on this PC, so the lead pairs `out/refsheet/` with `out/r8/`.

Rules I kept:
- I built only from the pictures and the two reviews. I did not open the reference place, its export or `ae_reference.blend`.
- I did not save the practice place or commit anything. I did save `ae_kit.blend`, which is the kit source.

**Import.** The lead imported `kit/own/ae_kit_r8.fbx` with Import 3D (Insert Using Scene Position + Anchored).
- 20 MeshParts arrived under `workspace.ae_kit_r8`.
- The import scale was clamped to **24.17**, measured from the 10-stud cube `K_Scale8_stone`. It is not 40.56 because the mist piece is 85 tall and would pass 2048 studs at 40.56.
- `build_plaza.lua` **merged** the 19 pieces into `ServerStorage.Kit`: it replaced same-named pieces and dropped the cube. Kit now holds 151 pieces (the 132 from r7 plus 19).

## What changed, per priority
1. **Islands (item 1).**
   - Every island is now 1.5x farther out, 30 studs higher and 1.15x bigger.
   - The pass-7 hairline falls are removed at placement.
   - Each island has 2-3 own **waterfall curtains** (`K_Fall8`). Each curtain is 4.5 wide at the lip and 6.5 at the foot, bowed, with a foam lip and a mist cluster at the foot, coloured (200,230,245) Glass 0.3. 23 curtains in all.
   - The curtains sit on the rim that faces the plaza. Placement raycasts from the plaza side onto the island's rock MeshPart to find the edge.
   - Each island carries an own 8x8x40 arched ruin tower (`K_Ruin8`) and a domed round tower (`K_Dome8`).
   - Two extra islands (NE/E) and 4 extra clouds fill the empty c3 sky.
   - Atmosphere haze is lowered from 1.2 to 0.5 and the colour is greyer (205,212,215), in `fix_lighting.lua`.
   - The rock base is now (175,170,155) Slate. It renders grey on its sunlit faces, and (101-104,121-123,147) on the shaded undersides in c3. Those were (74-103,128-139,167-188) before.
2. **Raid (item 2).**
   - The walls and gate are Slate in (104-108,44-50), darker than the (130,55,58) target because sun plus red light adds about 40. They now render (79-116,24-34,43-51), against (167-185,39-47,62-70) before.
   - The onion towers and spires are near-black red (60,25,30) Slate, with domes in (70,28,34).
   - The skull is the new `K_Skull8`, in grey-red (125,85,72) Slate. It has a heavy brow ridge with a notch, deeper sockets, cheekbones that stand 1.4 out (2.1 studs at the 1.5x placement), temple hollows, a chin-forward jaw with bigger teeth, and a pedestal with 3 cornices.
   - There are 8 dead red trees (120,30,35), 10-15 studs tall, round the base.
   - Red light: the gate light is now range 30 / brightness 0.9 and the skull light range 12 / 1.2. At range 40 / 2 the light washed everything pink. The haze runs at Rate 6.
   - The neon eyes and the beam are kept.
3. **Expeditions (item 3).**
   - The new gate `K_ExpGate8` is 1.5x the old one: 35 wide, with the arch top at 25.5.
     - It has a teal (40,140,140) frame, gold (200,172,60) outer and inner trims, and a teal (60,170,170) Glass 0.35 field with gold mullions, a transom and a rose ring.
     - Pale columns carry gold capitals and teal domes, and there is a gold crest.
   - A new 14x3 "Expeditions" sign plate sits on the crest.
   - The halo `K_ExpRing8` is 8 crescent shards on a radius-12 ring, placed at 1.15x, round a 5x8 Neon oval (240,250,255). Its centre is 16 above the arch top so it clears the sign.
   - The braziers moved to x ±21.
   - A lawn strip (12.8 x 5.2 per side, with clumps) runs across the top of the S flight.
4. **Stairs (item 4).**
   - On every flight the tread body (`K_Stairs_stone`) is now base (78,82,94) Slate. In c4 the N flight in sun samples **(100-112,113-128,130-141)**. That was (173-190,184-192,188), and the S-flight target is (119,122,139).
   - The nosing is now 0.3 wide, base (150,152,150).
   - The N runner is **not** narrowed: it is part of the stair mesh. That needs a kit change.
5. **East (item 5).**
   - 94 pieces now cover the east wedge (x 66-230): red broadleaf trees, red bush mounds at 2.4-3.6x and dead trees, in 4 reds.
   - The east gravel patches are re-tinted red-brown (105,72,68). p8 now reads as a red-brown treed quadrant.
   - There are 14 red litter cards on the E treads and 8 on the floor below them.
6. **Summon (item 6), partly done.** 4 big gold trees (220,175,50), 25-30 tall, stand behind and beside the hall. I did not change the facade.
7. **Story (item 7).**
   - The new `K_BigTree8` trunk is r 10.5 (it was 6.5) with a 22-radius root flare. It splits low into 7 branches of r 4.2 then 2.8, plus twigs, and the canopy has interior puffs.
   - The wood is tan (150,110,75) and samples (93,86,69) in p4. The plinth is (88,74,62). The pass-7 filler crowns are removed.
   - There are 2 blue crystal pods (`K_Pod8`, (40,110,230) Glass) beside the ring and 2 more blue palms.
   - The void stays (0,9,16). It samples (2,9,38) under the purple glow.
8-10. Not reached, beyond the gold trees and pods above.

## What I measured from the pictures
- **r2.** The halo is about 1.4 gate-widths across and sits just above the sign. Its shards are crescents with the outer edge leading: a pinwheel, not a ring of blocks. The gate is about 1.3x the lantern-pavilion height, and the glass is split by gold bars into 3-4 lights. These set the 12-radius ring, the 35-wide gate and the 3 mullions plus transom.
- **r1 and r2.** The falls are broad bright sheets, about 1/4 to 1/3 of a tower width at that distance and slightly wider at the foot. There are 2-3 per island, on the side facing the viewer. Hence the 4.5 to 6.5 taper and the plaza-side raycast.
- **r3.** The skull reads by its shadow shapes: dark brow over the sockets, cheek planes, teeth. So the relief had to be big (2 studs or more) to survive flat lighting.
- **r4.** The trunk is about as wide as the ring and forks well below the canopy into 6 or more limbs. Hence r 10.5 against the ring's ~10 radius, with branches starting about 16 up.

## Still off / for the lead
- **The Raid skull has 3 thin black "antenna" bars sticking up from the crown.** They are crack strips that float in front of the receding forehead, and they are part of the `K_Skull8_dark` MeshPart, so Lua cannot remove them.
  - The fixed piece is exported as `kit/own/ae_kit_r8b.fbx`: the skull without cracks, plus the scale cube.
  - **Please import it** with Import 3D (Scene Position + Anchored), then run `fix/build_plaza.lua`. It already looks for `ae_kit_r8b` and merges it.
  - I did not drive the screen, as the coordinator asked.
- **The capture frame is now 1452x615 (it was 1452x793 in verify5).** The Studio viewport is shorter, probably because a panel was opened during the import. Restore the layout before the review, or the reviewer compares different crops.
- The Raid still reads saturated in hue, because the red light and haze tint it. It is darker now; to go further, lower the red light again or use a warmer red.
- The Expeditions halo is small from the spawn (about 120 px) and the shards are thin in silhouette. Scale it to 1.4 or thicken the shards (radial 1.45 to 2.5) if the reviewer wants it bolder.
- The c3 sky is fuller, but its top-centre is still open sky.
- **Not done:**
  - the N runner width;
  - the Summon facade rebuild;
  - item 8 (basin, egg dome, vault), item 9 (ground rim, landings, channels) and item 10 (medallion, bollards, wall-top pods).
- `Lighting.Technology` was not checked. It needs the offline `tools/set_technology.py` check.

## Objects built (for 5 Object Recipes)
All are in `tools/ae_kit.py`, pass-8 section. They are authored Y-up in studs, then `to_zup_and_uv()` and FBX export.
- **Waterfall curtain `K_Fall8`.**
  - Construction: a 5x14 grid sheet 80 long (top at y 0), widening from 4.5 to 6.5. It bows outward (z = -1.2 cos(pi u)) and drifts out by 1.5 t² as it falls. It is double-sided: a second grid 0.18 behind with reversed winding.
  - Foam: 3 squashed spheres for the lip. Mist: 8 squashed spheres (r 3-5.5) at the foot.
  - Colours: (200,230,245) Glass 0.3 for the sheet, (235,245,250) at 0.25 transparency for the foam and mist. Neither casts shadows nor collides.
  - Placement: a raycast onto the island rock from the plaza side, set 1.2 out from the hit point, scale 0.85-1.0x the island's.
- **Ruin tower `K_Ruin8`.** The pass-7 `ruin_tower`: 4 levels of 10, each face a wall bay round a round arch, a floor slab per level, and the top broken. It is 8x8x40, in (222,220,210).
- **Domed tower `K_Dome8`.** A lathed drum (r 5.6 to 5.0, 26 tall, base step and cornice), a dome to 34.4 and a needle to 39. Two rows of 8 dark rounded-box windows (0.8 x 6 / 5 x 1.8), the second row offset half a bay. Stone (225,222,212), windows (70,76,88).
- **Weathered skull `K_Skull8`.**
  - Base: a 48x32 UV sphere scaled 5.2 x 6 x 5, with the jaw narrowing below y -1.
  - The relief is a sum of Gaussian bumps weighted by a "front" mask, so the sides stay round:
    - sockets pushed 3.6 in;
    - a nose hole 1.9 in;
    - a brow ridge 1.7 out with a central notch 0.7 in;
    - cheekbones 1.4 out and 0.5 wider;
    - an under-cheek hollow;
    - temple pinches;
    - a sine wobble on the crown.
  - The socket and nose faces (weight above 0.3) are split into the dark mesh.
  - Jaw: a jaw box, a chin box forward, and 2 rows of 8 teeth (0.9 wide).
  - Pedestal: a tapered prism with 3 cornice slabs. Eye cores are half-sphere lathes.
  - Colours: bone (125,85,72) Slate, dark (30,12,14), eyes Neon (255,50,50). Placed at 1.5x on the 16x30 tower.
- **Expeditions halo `K_ExpRing8`.**
  - 8 crescents. Each is a 14-step arc over 0.52 rad at R 12. The inner edge is R - 0.35 sin, and the outer edge is R + 1.45 sin, advanced 0.10 sin rad (the swirl). The depth is 1.5, and it is closed with end faces.
  - Oval core: a sphere 5 x 8 x 1.2.
  - Colours: shards (175,180,192) SmoothPlastic, core Neon (240,250,255). Placed at 1.15x, centre 16 above the arch top.
- **Ornate gate `K_ExpGate8`.**
  - `_band_xy` arch bands: frame from (hw 12 / 9.6, legs 13.5, round top), gold trims at 12.7/12 and 9.6/9.0.
  - The glass field is the inner arch outline extruded 0.3, with 3 gold mullions (each cut to the arch at its x), a transom at 13.5 and a rose tube ring (r 3.4).
  - Columns: lathes at x ±15.2, 19 tall, with gold capitals, rings, teal domes and finials. There is a gold crest on the top.
  - Colours: teal (40,140,140), gold (200,172,60), glass (60,170,170) Glass 0.35 with no collision, pale (205,228,222).
  - The sign plate is a Part with a SurfaceGui (Bangers font): (30,70,80) plate, (150,255,235) text.
- **Story tree `K_BigTree8`.**
  - Trunk: 3 tube segments of r 10.5 / 8.2 / 6.4 along a gently snaking path to 25 up. Root flare: a lathe of radius 22. 7 buttress roots of r 2.4.
  - Branches: 7, each a 2-part tube (r 4.2 then 2.8) curving out and up, with 2 twigs each.
  - Canopy: 31 leaf-card puffs on the shell plus 9 interior puffs, about 80 across.
  - Colours: wood (150,110,75), leaves (45,95,235), rims (120,170,255).
- **Crystal pod `K_Pod8`.** A 6-sided faceted lathe spindle 4 x 6.6 on a gold cradle ring. Colours: (40,110,230) Glass 0.1, gold (200,172,60). Placed at 1.15x, tilted.
- **Scale cube `K_Scale8_stone`.** A 10-stud cube used only to measure the import scale. It is dropped on merge.

Studio-side constructions:
- The east red cover (scatter in the east wedge: every 3rd piece a red broadleaf tree, every 7th a dead tree, the rest red bush mounds at 2.4-3.6x).
- The S-top lawn strip.
- The 4 gold trees round Summon.

## Lessons (for the workflow vault)
1. **Export only the new pieces, and ship a scale marker.** A partial kit is smaller and does not overwrite the Studio kit. Two things make it work:
   - Add a known-size cube, so the import scale can be measured even when a big piece forces the 2048-stud clamp. This pass's 85-tall mist piece clamped it to 24.17.
   - Make the placement script **merge** the imported pieces by name instead of replacing the kit folder.
2. **Darken the base colour until the render matches; do not set the target colour as the base.**
   - Stairs: base (115,120,135) Slate still rendered about 170 in sun. Base (78,82,94) renders (105-112,117-128,131-141), which is the target.
   - Raid: the walls needed a base about 20-25 darker than the review's RGB, because sun plus red light adds back.
   - Far rock needed a **warm** base (175,170,155) to render grey through the blue haze.
   - Sample a 5x5 mean on the capture after every colour change.
3. **Find the visible part before recolouring it.** The pale "treads" in c4 were the stone token. I first tried the `white` token, which turned out to be the runner kerbs. A raycast or one test recolour plus one capture settles it in a minute.
4. **Place attachments with a raycast onto your own mesh.** The island outline is noisy, so a fixed offset leaves falls floating or buried. Casting from the viewer's side onto the rock MeshPart (an Include filter on just that part) gives the true rim for any seed, scale or yaw.
5. **Relief must be big to survive flat stylised lighting.** About 2 studs of brow and cheek at placement scale reads; 0.5 does not. Shape relief with Gaussian bumps times a "front" mask, so the back of the head stays clean.
6. **Never float small detail strips in front of a curved surface.** The crack strips sat at a fixed x while the skull curved away above the brow, and from below they read as antennae. Detail on a curved mesh must be cut into it (deform or split faces), or projected onto it, not boxed on.
7. **Point lights wash out material colour.** A red PointLight at range 40, brightness 2 turned every Raid surface into the same pink, so "weathered" colours never showed. For a coloured mood, keep the light small (range 30, brightness 1 or less) and let haze and neon carry it.
8. **When one dimension is fixed by the brief, check what sits next to it.** The halo had to be "10 above the arch top", but that collided with the new sign and crest, so it moved to 16. Lay out stacked landmarks (gate, sign, halo) as one vertical budget.

## Files
- `tools/ae_kit.py`, pass-8 section:
  - builders: `build_scale8`, `build_fall8`, `build_ruin8`, `build_skull8`, `build_expring8`, `build_expgate8`, `build_bigtree8`, `build_pod8`;
  - batch: `build_all8`;
  - exports: `R8_PREFIXES`, `export_r8`, `R8B_PREFIXES`, `export_r8b`.
- `ae_kit.blend` (saved).
- `kit/own/ae_kit_r8.fbx`: 20 meshes, imported.
- `kit/own/ae_kit_r8b.fbx`: the fixed skull plus the cube, 4 meshes, **not imported yet**.
- `fix/build_plaza.lua`: r8/r8b merge import, and the pass-8 Raid, Expeditions, Story, east cover, Summon trees, stairs and islands.
- `fix/fix_lighting.lua`: Atmosphere haze 0.5 and greyer colour.
- `out/r8/r8_*.png`: 12 cameras.
