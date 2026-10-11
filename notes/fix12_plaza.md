# Fix pass 12: Anime Expeditions spawn plaza (own hazy skybox, Raid value swap, speckled litter, islands, horizon)

Builder report for `notes/fix_brief12.md`, answering the round-9 review `notes/verify9_plaza.md` (6.92/10).

**Captures:**
- Final set: `out/r12/r12_<cam>.png`, 12 cameras, 1452x793. Each camera was captured twice and the second frame kept.
- Working frames: `out/r12w/t1..t8_*`.
- Colours are 5x5 means against the round-9 reference frames `out/verify9/v9_<cam>_ref.jpg` (same cameras).

**Rules kept:**
- Pictures only. The reference studio was not touched at all this pass: no captures, no code. `ae_reference.blend` was not opened.
- No computer use. The practice place is not saved and nothing is committed.
- **No new meshes, so there is no `ae_kit_r12.fbx` and no import is needed.** Everything is Studio Parts, built-in shapes
  (Ball, Cylinder, Wedge, SpecialMesh Sphere) and clones of own kit pieces. `ae_kit.blend` is unchanged.
  `fix/build_plaza.lua` lists `ae_kit_r12` / `K_Scale12_stone` in `IMPORTS` for a later pass.
- Lighting.Technology and the post effects are unchanged (lead's note). `fix/fix_lighting.lua` only got the new sky ids.

**How to rebuild:** run `fix/build_plaza.lua`, then `fix/fix_lighting.lua`. The pass-12 block sits at the end of
`build_plaza.lua`. The same code is in `fix/pass12.lua`, which can be re-run on its own on top of a built plaza (it is idempotent).
The full rebuild was tested: 6470 descendants under Plaza, "lighting matched".

## What changed, per priority

### 1. Own pale hazy skybox (`tex/make_ae_tex12.py`, `tex/sky/ae_sky12_*.png`)
- **Face layout, measured with a debug skybox.** I uploaded one with coloured edge bars, then captured looking straight up
  and into one corner.
  - The side faces join left to right as Lf | Bk | Rt | Ft.
  - The Up image's top edge meets Lf, its right edge Ft, its bottom edge Rt, and its left edge Bk.
  - The pass-5 panorama assumed Ft | Rt | Bk | Lf, which is the wrong way round.
  - The horizon is the **middle row** of a side face, not its bottom edge: the lower half of each side face is below the horizon.
- **Method:** every pixel of every face becomes a 3D view direction, and the sky is computed from that direction:
  - a colour ramp by elevation;
  - 3D value-noise cumulus.

  The six faces therefore join with no seams, and clouds can sit above 45 degrees, on the Up face. Pass 5 could not do
  that, because its Up face was plain.
- **Fitting the colours:**
  - A first try at TOP (0.22,0.68,0.95) rendered as an over-saturated (14,191,245): the colour grade (Saturation 0.14,
    Contrast 0.12) pushes red down.
  - The second try was paler. Its clear sky rendered (135,203,232), too pale.
  - The final values are TOP (0.16,0.60,0.93), MID (0.30,0.70,0.94), HOR (0.80,0.87,0.92), with harder cloud edges.
- **Measured (r12 against the v9 reference):**

| Frame | Point | Practice r12 | Reference |
|---|---|---|---|
| c3 | near the islands | (200,219,232) | lead target (200,225,235) |
| c3 | clear sky | (100,198,235) | (61-105,187-206,240) |
| c3 | clouds | (227,231,234) | (212,230,237) |
| c4 | clear | (91,196,236) | (63,196,242) |
| c4 | haze/cloud | (203-222,218-225,224-231) | — |

  In the v9 practice frames the clear sky was (70-79,178,226-240) everywhere.
- **3D cloud blobs removed:** the 3 big low `K_Cloud7` blobs (over 250 wide, y 100-120). They read as snowy mountains
  behind Summon in c3 and c4; the sky now carries the clouds.

### 2. Raid light/dark swap
- **Facade:**
  - The facade, gable, tall gable, flanks, shoulders and the `_stone` of the arcades and gothic door are now (70,22,34).
  - The buttresses and cap are (52,14,22). The recesses and `darkStone` are (22,5,9).
  - In p3 the facade renders (86-148,14-27,23-36), against (216,78,88) in v9. The reviewer's target was (77,21,37).
- **Skull:**
  - Big skull bone: SmoothPlastic (175,95,95), with sockets (55,16,20) and a soft rose PointLight on its face.
  - At (205,125,125) it rendered (225,91,96) and read near-white in the haze, so it was backed off.
  - The skull is now the lightest mass on the temple, as in the reference.
- **Letters:**
  - Neon (190,80,85). At (225,105,110) they rendered (254,155,173), too pale.
  - They now render about (249,79,99), against the reference (235,121,122).
- **Smoke:** 3 own ParticleEmitters (the engine's `smoke_main.dds`), at the skull, the mid facade and the door.
  - The first version, (255,70,70) with LightEmission 0.4, burnt the facade to (169,24,36) flat red.
  - Final: (215,95,95) to (170,70,75), LightEmission 0, Transparency 0.8 at its densest, rate 3-5, size 13-30.
- **Beam light:** the beam's PointLight went from 1.2/26 to 0.35/16. It was lighting the gable above the letters bright red.
- **Palms:** the 2 dark red palms moved from the forecourt corners (z ±89) to the door sides (146, ±30), with leaves (110,22,32).

### 3. Red litter as fine speckle (`Pass12.Litter12`, about 3000 cards)
- **Removed:**
  - The 54 big `K_Patch` red cards from pass 11.
  - The red terrain beds: the NE corner bed and the two Raid flank beds.
- **Gravel:** the gravel road and a new `Gravel12` slab are (72,76,74) Slate. Pass 11's (62,66,64) rendered (89,99,99).
- **Leaves:** 100 clusters of 30 red leaves, each 6-12 studs across, with grey between the clusters.
  - Each leaf is 2-4 studs. Two in three are flat discs (a lying Cylinder); the rest are thin cards.
  - There are 4 base reds, from (112,32,33) to (128,42,40).
  - The leaves sit at y 6.34-6.38.
- **Also:** 12 green tuft clumps (70,120,32) and 160 white flower dots.
- **Measured in p8:**

| | Practice | Reference |
|---|---|---|
| Gravel | (92-102,103-104,98-99) | (100,109,101) |
| Red leaves | (161-199,53-73,59-76) | (175-197,69-100,72-84) |

- **The zone** is x 50-172, z -102..92, minus the road stripe |z| < 15.

### 4. Islands
- **Lift:**
  - The N, W and E islands (7 of 10) are lifted 18 studs.
  - Each island's dressing (falls, mist, trees, ruins, domes, aqueducts, fills) is assigned to its nearest island in XZ and moves with it.
  - The lift is stored as an attribute (`Lift12`), so a re-run does not lift again.
- **Rock and crevices:** rock is (150,162,148) Slate instead of (210,216,195); crevice fills are (92,102,96).
  In c3 the undersides now read grey-green with dark faceting, not pale paper.
- **New on each island:**
  - a grey tower 10x50x10 (165,170,165) with a band, a top block and 8 dark window slots;
  - 4 round trees: a trunk of 7-10 and 3 LeafyGrass balls of 7-10.

  The towers read in c3/c4. From below, the trees mostly hide behind the island rims.

### 5. Horizon and N avenue
- **Inner ring:** 15 masses at r 230-300, round the N half and the sides.
  - Odd ones are cream Slate buildings 30-55 tall with a cornice, dark arch slots, and a dome or a pitched wedge roof.
  - Even ones are clumps of 5-7 round trees in one colour family: blue, green, gold, purple or teal.
- **Outer ring:** 17 tree masses at r 340-430, 6 crowns each, 20-30 across on trunks 22-40 tall.
- In p7 the top of the frame is now trees and buildings to the edge, not bare baseplate.
- **Avenue:**
  - 6 blue cypress (40,90,220): a Part 4x14x4 with a SpecialMesh Sphere, which gives a non-uniform ellipsoid.
    They stand at x ±17, z -98/-126/-154.
  - 4 stalls at x ±28, with a counter, posts, a 6-strip striped awning tilted 14 degrees, and goods.

### 7. Ground plan and pedestals
- **Tall-grass blocks:** the three are gone (terrain cleared with Air): SE (80,70), SW (-80,70), and the Story lawn (-120,0).
- **Arm-end terraces:** white terraces at the E and W arm ends, at (±94, 0). Each has:
  - a 20x1.2x30 slab (230,230,225), a step, and two rails with 5 balusters each;
  - 2 carved plinths each: a base, a 4x4x4 body, a cap, a dark socket (40,50,60) and an own `K_Crystal`.
- **Pass-11 pedestals:** each gets a dark socket on the cap and a stepped foot.

### Not done (time)
- Items 6, 8 and 9:
  - Story canopy clumps, height cap, portal frame and arena;
  - dark wing flanks (these need the hero mesh split);
  - risers and the drum lip;
  - crystal pods on the arch tops.
- Item 10: medallion blades and the S gate.
- **Known nit:** the E terrace plinths show as two small white blocks at the foot of the Raid door in p3. Moving the
  E terrace to x ≈ 84, or dropping its plinths, would clear that.

## Lessons (for the workflow vault)
1. **Map an engine's skybox faces with a debug cube before painting one.**
   - What to upload: six faces with coloured edge bars and a white stripe on one side.
   - What to capture: one shot straight up and one into a corner.
   - That settles the face order and the Up-face rotation in two captures. Our earlier panorama had the side order reversed.
2. **Generate a skybox from view directions, not from per-face images.** Turn each face pixel into a direction and
   evaluate the sky (elevation ramp + 3D noise) there. The faces then join with no seams, and clouds can sit at any height.
3. **On a skybox side face the horizon is the middle row, not the bottom edge.** A gradient laid from top to bottom of a
   side face puts its "horizon" colour below the real horizon.
4. **Fit sky colours through the place's own grade, by measurement.** With Saturation and Contrast above 0 the grade is
   non-linear: a pale source can render over-saturated, and a deeper one can render pale through the Atmosphere.
   Render, sample, adjust, two or three times.
5. **Flat decals on the ground can be hidden by other flat layers.** The first 1650 leaf cards were invisible from above,
   under old 0.25-thick gravel patches. Query what lies above a height in the area before choosing a decal's Y.
6. **Speckle needs shape variety.** Same-shape rectangles at random yaw read as scattered red bricks at a 40-degree view.
   Mixing in flat discs (a lying Cylinder Part) made them read as leaves.
7. **Coloured smoke should not glow.** LightEmission on red smoke flattens everything behind it into one red. With
   LightEmission 0, a pinkish colour and high transparency, it gives haze and keeps the shading.
8. **Check every light that touches a focal object.** The beam's own PointLight was the reason the gable outshone the
   skull. Dimming it did more than recolouring the gable.
9. **Store one-off moves as attributes.** Lifting islands with a delta is not idempotent; `SetAttribute("Lift12", 18)`
   and moving by (target - done) is.
10. **Fill an empty horizon cheaply with two rings of simple masses.** A near ring of varied buildings plus a far ring of
    round tree crowns closed the bare baseplate in p7. The Atmosphere hazes the far ring for free.
11. **A SpecialMesh Sphere on a Part gives a non-uniform ellipsoid.** A Ball Part cannot do that. It is a quick cypress
    or topiary cone without a new mesh.

## Objects built (for 5 Object Recipes)
All of these are in `fix/pass12.lua` (and at the end of `fix/build_plaza.lua`), under `Plaza.Pass12`.

### Direction-based skybox (`tex/make_ae_tex12.py`)
- **Face table:**
  - Lf: centre d0, right d1;
  - Bk: centre d1, right -d0;
  - Rt: centre -d0, right -d1;
  - Ft: centre -d1, right d0;
  - Up: centre U, right -d1, top d0.
- **Per pixel:** dir = centre + u·right − v·up.
- **Colour:** elevation ramp HOR → MID (0-30 degrees) → TOP (30-80 degrees).
- **Clouds:**
  - fbm value noise on a direction flattened toward a cloud deck;
  - mask: threshold 0.46, ×6;
  - band: 2-78 degrees;
  - shading: grey-blue bottoms, white cores.
- Upload three at a time from `http://127.0.0.1:8767/tex/sky/...`, then set `Sky.Skybox*`.

### Raid smoke haze
- An invisible anchored holder Part with 3 Attachments, one each at the skull, the mid facade and the door.
- Each Attachment has a ParticleEmitter:
  - texture `smoke_main.dds`, LightEmission 0, Transparency 1 → 0.8 → 1;
  - Lifetime 6-9, Speed 0.5-1.5, spread 180, random rotation.

### Leaf-litter speckle
- `card(x, z, w, d, col)`:
  - two in three are a flat disc (a Cylinder Part, Size (0.06, 1.3d, 1.3d), rolled 90 degrees);
  - otherwise a 0.8w x 0.5d card;
  - random yaw, CanCollide and CastShadow off.
- Clusters: radius √(rand)·r. Chunk the clusters into Folders and parent each Folder with a `task.wait()` between them.

### Island tower and round tree
- **Tower:** a 10x50x10 block, a band at 34, a 12.5x3x12.5 top block, and 2 dark slots 2.2x6 per side, set
  0.05 proud of the face with `CFrame.lookAt`.
- **Tree:** a trunk 1.6 x (7-10), with 3 LeafyGrass balls of 7-10 jittered round the top.

### Horizon masses
- **Building:** a block w x h x d facing the centre, a cornice, 3 dark arch slots, and then one of:
  - a Ball dome of 0.55w;
  - two WedgeParts back to back as a pitched roof.
- **Tree mass:** 5-7 trunks with Ball crowns of 16-30, one colour family, lightened 0-20% toward white.

### Cypress cone and stall
- **Cypress:** a 1x2x1 trunk under a 4x14x4 Part with a SpecialMesh (Sphere).
- **Stall:**
  - a 7x3x3.5 counter and 2 posts;
  - an awning of 6 strips, alternating colour and white, each tilted -14 degrees;
  - a goods slab.

### Arm-end terrace with carved plinths
- A 20x1.2x30 slab, a step on the inner side, and 2 rails with 5 balusters each.
- Plinths: a 5x0.8x5 base, a 4x4x4 body, a 4.8 cap, a 2.8 dark socket and a cloned `K_Crystal`.

## Files
- `tex/make_ae_tex12.py`, `tex/sky/ae_sky12_*.png`, `tex/sky/dbg/*` (the debug skybox).
- `fix/pass12.lua`: new; the pass-12 code.
- `fix/build_plaza.lua`: the pass-12 block and the r12 `IMPORTS` entry.
- `fix/fix_lighting.lua`: the new sky ids (the old ones are kept in a comment).
- `out/r12/r12_*.png`: 12 cameras. `out/r12w/`: the working frames.
