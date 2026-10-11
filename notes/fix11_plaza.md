# Fix pass 11: Anime Expeditions spawn plaza (layout from above, Raid glow, lighting restore, Story tree, Summon)

This is the builder report for `notes/fix_brief11.md`. It answers the round-8 review `notes/verify8_plaza.md` (6.50/10).

**Captures:**
- Final set: `out/r11/r11_<cam>.png`, 12 cameras, 1452x793. Each camera was captured twice and the second frame kept.
- Working frames are in `out/r11w/t1..t9_*`.
- Colours are 5x5 means, measured against the round-8 reference frames from the same cameras (`out/verify8/v8_<cam>_ref.jpg`).
- The layout was judged on p7_high and p8_top against those reference frames.

**Rules kept:**
- I used pictures only. I made no captures and ran no code in the reference studio, and did not open `ae_reference.blend`.
- No computer use.
- The practice place is not saved and nothing is committed.
- **No new meshes this pass, so there is no `ae_kit_r11.fbx` and no import is needed.** Everything was built in Studio from Parts and existing kit pieces. `fix/build_plaza.lua` already lists `ae_kit_r11` / `K_Scale11_stone` in `IMPORTS`, in case a later pass exports one.
- `ae_kit.blend` is unchanged.

**Lead's checklist:**
- `fix/fix_lighting.lua` was re-run ("lighting matched").
- `Lighting.Technology` was not checked.
- Terrain `GrassLength` and `Decoration` still need setting by hand.

## What changed, per priority

### 3 first: lighting restore (lead's note)
- `fix/fix_lighting.lua` no longer has the pass 6-8 drift lines: warm TintColor, Bloom 0.5/1.1, and Atmosphere 0.26/Haze 0.5/Offset 0.1 with a greyer colour.
- Atmosphere, Bloom, ColorCorrection and SunRays are now exactly what `notes/settings_ref.txt` records. The reviewer's guessed numbers are not used.
- The terrain clouds and the own skybox stay.

### 1. Layout from above (p7, p8)
- **Raid moved out and enlarged.** Every Raid object in Landmarks/Pass9 within x>60 and |z|<62 is scaled 1.8x about the gate foot (x 80) and moved 60 east. That covers the gate, facade, gable, towers, wings, spires, palms, dead trees, lights, haze and Boss Rush. They are regrouped as `Plaza.Pass11.Raid11`.
  - The gate foot is now at about 140 and the facade at 176. Boss Rush lands at about (151, -54); in p8 the reference glow is at about (155, -58).
  - In p8, Raid now sits at the right frame edge (x > 1300 px), as the reference forecourt does.
- **The E island collided with the taller Raid** and hid the skull. It moved from (180, 30) at 113 up to (255, 40) at 150.
- **E gap** (gravel and red carpets):
  - A gravel road 84 x 64 (base (62,66,64) Slate) runs from the E arm to Raid. It renders **(89,99,99)** against the reference gravel (103-105,110-115,99-109).
  - The E-wedge gravel patch colour got the same base.
  - 14 small red litter patches lie on the road.
  - 40 red carpet patches flank it: z 26-48 south, 26-90 north, base (100-132,34-52,30-38). They render **(168-173,43-54,49-57)** against the reference (142-174,73-79,50-59).
  - 7 black dead trees, 1.5-1.9x.
  - Planting in the road footprint was removed.
  - The NE terrain bed is the red variant, recoloured (125,60,42).
- **W lagoon:** NW at about (-104,-78), between the W arm and Story.
  - Three overlapping water discs (55,160,210), 30-44 wide, on sand-beach discs 10 wider.
  - 3 pool rings (pink, white, yellow) and 4 green palms.
  - The NW terrain bed was dropped and the trees in the water removed.
- **Flight tops:**
  - White paving 44 x 26 now covers the E, S and W flight tops, at y 5.9: between the ground at 6.0 and the arm at 6.1, so it does not z-fight either.
  - S and W each get 2 crystal pedestals (6x5x6 plus cap, blue crystal, PointLight). They stand at 68 out and 38 to the side, so in p7 they sit at the bottom frame corners like the reference's.
  - The terrain lawns there are removed, and so is the S lawn strip.
- **N avenue:**
  - The channel is now bright cyan SmoothPlastic (85,170,215). It was dark glass. It renders **(124,235,255)** against (133,218,245).
  - Sand strips run either side of the channel.
  - Sand beaches (16 x 34) sit beyond the avenue's far half.
- **Lawn:**
  - Ground parts are (74,124,28) and the terrain grass colour is (74,130,28).
  - At the intermediate value (84,140,44) the lawn rendered (116-143,175-187,62-79) against (92-115,166-170,39-47). The final value, fitted from that ratio, renders **(105-111,165-175,60-68)** in the final p7.

### 2. Raid glow
- **Skull and gable:**
  - The skull is lifted 26 at 0.8 of the group scale onto a new tall gable block. The gable has stepped flanks, dark recessed panels and two dark pinnacles.
  - Now the skull mouth is about as far above the letters as the letters are above the base. The reference p3 proportion is 135 px against 140 px.
  - Skull: (118,52,56) Slate with near-black sockets.
- **Beam:** Neon (255,40,40), 1.5 x 3, from the mouth to the letters, with a soft red PointLight.
- **Letters:** Neon (235,70,80).
- **Colours:**
  - Facade (160,74,76) Slate, recesses (72,14,18), spires (48,16,24). All are fitted from the r8 ratio, where (175,100,100) rendered (219,64,74).
  - p3 red pixels in the facade box average **(182,42,58)**, covering 35% of the box. The reference is (182,62,67) at 30%. In r8 the practice facade was flat pink (219,64,74).
- **Lights:**
  - 3 doorway lights in (255,50,50), range 45. At brightness 0.8 they burnt the facade to (189,34,51); backed off to 0.3, the facade shading survives.
  - The pass-9 lights are at 0.25.
- **Palms:** dark red leaves (120,30,40).
- **Boss Rush:**
  - The portal is a Neon (95,35,160) disc with an own purple Neon spiral (a clone of the own `K_Trip10_swirl`, scaled to the disc).
  - A carved frame of 8 dark Slate blocks surrounds it.

### 3. Emissive sources
- 16 PointLights (80,170,255), range 12, inside the crystal pavilions.
- The crystal pods are Neon glass (40,100,220), T 0.25, each with a light.
- The pedestal crystals have lights.
- The Story swirl has a light.

### 4. Summon
- The hall group (facade, letters, corner towers) is scaled 1.5x about its foot. The dome and finial were removed: they made it read as a pavilion.
- Cream is (205,178,108) and gold is (170,140,50).
- In p1 the facade is now about 150 px wide. The reference is 150-160; it was 100.
- The gold-tree mass is **not** scaled: at 1.5x it walled the avenue in brown. It is recoloured lighter instead: leaves (235,190,60), rim (255,225,110).

### 5. Story
- The `K_BigTree8` blob is replaced by a parts tree at (SX-34):
  - a tan trunk (150,115,80), 14 thick and 40 tall, on a 20-wide flare, with 4 roots;
  - 5 branches in two segments (7 then 4.2 thick) reaching 22-27 out and up to 70-80;
  - a leader to 82;
  - 7 clumps, each of 7 flattened LeafyGrass balls in (25-45,75-110,200-235), with sky between clumps;
  - 14 hanging vines (40,100,220).
- In p4 the trunk and branches are now the main shape rising behind the ring, as in the reference.
- The ring void is dark Neon (12,30,90) with a bright own Neon spiral (120,190,255) and a blue light. The old navy hole and the glow disc are gone.

### 6-10 (partial)
- **Spills:**
  - E tread red litter cut from 14 to 4, and the E floor red litter from 8 to 0.
  - Per flight: tread litter cut from 3 to 2, and floor patches from 3 to 1.
  - Spill conversion cut from a third to a fifth.
- **Risers:** (78,86,96). They render (72-79,93-95,111-115) in c4 against the reference's (77,105,124) shaded riser. In r8 they were (34,50,73).
- **Medallion gold:**
  - At (140,128,50) it rendered (211-213,198-200,62-74) against (181,165,62).
  - The final value, (120,107,41) fitted from that ratio, renders **(188-191,171-172,49-63)** in p1.
- **Bollards:** 35% lower, squashed about the foot (white body 2.95 to 1.9).
- **Not done:**
  - The arch wing flanks still share the hero `stone` token. Dark slate flanks need the wings on their own token in a new hero export.
  - The drum bowl lip.
  - Medallion blades.
  - Island trees and vines.
  - Cypress and stall clutter.

## What I measured from the pictures
- **p8 scale:**
  - The camera is 160 above the floor with a 70-degree vertical FOV, which gives about 3.5-3.75 px per stud: 566 px focal length divided by the depth.
  - The reference E forecourt starts at about 1270 px, about 145 studs out.
  - The red carpets cover x 930-1150 except for a gravel stripe at y 330-450, about 32 studs wide.
  - The lagoon is at about x 200-420, y 0-180, so about (-140..-80, -105..-58).
- **p3:**
  - The reference has base-to-letters at 140 px and letters-to-mouth at 135 px. The practice had 150 and 60. That is why the skull is lifted on its own gable instead of the whole Raid being scaled more.
  - At 186 studs, a skull top at y=30 px would need about 130 studs of height. I compromised at 1.8x plus the 26 lift.
- **p7:**
  - The bottom frame edge meets the terrace at about z 71.
  - The reference pedestals at x 250 and 1200 px are about 44 to the side at depth 53, so they stand at about (±40, 66).
- **p1:** Summon is about 150 px wide, with its top 146 px above the horizon, which is about 56 tall at 195 out.

## Lessons (for the workflow vault)
1. **Moving a landmark is a group transform, not a re-author.** Collect everything by pivot inside a box, then for every BasePart set `Size *= s` and `CFrame = CFrame.new(P + (pos - P) * s + offset) * rotation`, and multiply light ranges. One loop moved and enlarged roughly 30 Raid objects of mixed kinds (MeshParts, Parts, WedgeParts, lights, emitters) in place.
2. **After moving something big and tall, check what it now runs into in the sky.** The enlarged Raid put its skull inside an island, and the island hid the skull in p3. Sky objects are placed by elevation angle, so a taller landmark needs the islands above it re-checked.
3. **Match proportions as well as size.** The reference landmark had a different internal ratio: the skull sat far above the letters. Uniform scaling could not match both width and height. Lifting one sub-part on a new block fixed the ratio that the eye reads.
4. **`CFrame.lookAt(a, b)` is degenerate when b is straight above a.** A vertical trunk built that way lay on its side. Pass `Vector3.xAxis` as the up vector when the direction is near vertical.
5. **A flat colour standing in for a textured carpet must hit the hue, not the sampled mean.** The reference red carpet averages (150,75,55) because its red leaves mix with grey and green specks. A flat patch at that mean read as orange-brown mud. A deeper red that matches the red leaves themselves reads right from above.
6. **Coloured lights: start low and raise until the shading is just visible.** Red lights at brightness 0.8 erased the facade's relief. At 0.3 the arch, buttresses and recesses read again, and the red-pixel mean matched the reference R channel.
7. **Use a flat cover layer's height to fix z-fighting.** The white paving at 5.98-6.13 hid the arm runner. Putting it between the ground top (6.0) and the arm top (6.1) fixed it.
8. **Scale a building group, but recolour its tree mass instead of scaling it.** At 1.5x the gold trees became a brown wall, because their shaded sides dominate. Keeping their size and raising the leaf value gave the gold mass the reference shows.
9. **Reuse your own kit pieces as decals.** The own spiral tube from the triptych (`K_Trip10_swirl`), cloned, rescaled and set to Neon, made both the Boss Rush and Story portals without a new export.
10. **Material on a primitive can stand in for foliage texture.** LeafyGrass on flattened balls broke the smooth toy look of the Story clumps without a mesh.

## Objects built (for 5 Object Recipes)
All the objects below are in `fix/build_plaza.lua`, in the "pass 11" block before the final count. They are Studio Parts plus clones of existing own kit pieces; there are no new meshes.

### Raid relocation group (`Raid11`)
- The box gather and the group transform described in lesson 1.
- **Tall gable:** a block 16 x 30 x 25 on top of the old gable, with:
  - 2 stepped flanks;
  - 2 recessed dark panels (0.6 deep);
  - 2 dark pinnacles 2.6 x 40.
- **Beam:** a Neon Part 1.5 x L x 3 from the mouth to the letters, with a PointLight.
- **Boss Rush carved portal:**
  - a Neon disc;
  - a cloned own spiral scaled to 0.85 of the disc and turned 90 degrees to face -X;
  - 8 Slate blocks 1.6 x 3.2 x 3.2 on a 0.56 x d ring, each rolled to its angle.

### Gravel road with red carpets
- A slab plus scaled `K_PatchA/B/C` cards in three reds, kept off a central stripe.
- Black `K_DeadTree` at 1.5-1.9x.

### Lagoon
- 3 overlapping cylinder discs (water at y 6.12) over 3 sand discs 10 wider (y 6.06).
- Pool rings: a 3.2 coloured disc plus a 1.4 water-coloured disc on top.

### Crystal pedestal
- A 6x5x6 white block with a 7 x 0.8 x 7 cap, plus `K_Crystal` at 1.0 and a PointLight (80,170,255), range 10.

### Parts tree (`StoryTree11`)
- `limb(a, b, d)`: a Cylinder Part along a to b, using `CFrame.lookAt(mid, b, up) * CFrame.Angles(0, pi/2, 0)`.
- Trunk, flare and roots.
- 5 branches in two segments, each with a tip.
- At each tip: 7 flattened LeafyGrass balls (8-13 across, 0.55 high) and 2 thin hanging vine Parts.

### Portal swirl
- Clone `K_Trip10_swirl` from the Kit and scale it to the opening (×1.55 for the Story ring).
- Set it to Neon and turn it to face the opening, with a PointLight.

### Summon scale-up
- The same group transform at 1.5x about (0,6,HZ), with the dome and finial removed.

### Squashed bollard
- Scale each part's `Size.Y` by 0.65 and its height above the foot by 0.65.

## Files
- `fix/build_plaza.lua`:
  - the r11 `IMPORTS` entry;
  - risers, medallion gold, the channel and its sand strips;
  - spill counts;
  - terrain beds and lawns;
  - the E island position;
  - the pass-11 block.
- `fix/fix_lighting.lua`: the drift lines removed; the recorded values stand.
- `out/r11/r11_*.png`: 12 cameras. `out/r11w/`: the working captures.
