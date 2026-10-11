# Verify round 12: Anime Expeditions spawn plaza (freestyle, after fix pass 14)

Scored against the **live reference** on the Shadow PC on 2026-10-10 by an independent reviewer who had not seen the build
before. Round 11 (`verify11_plaza.md`) was read for context only; every score below is fresh.

## Method
- **Reference:** studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- **Practice:** studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only. No code was run; nothing was modified or saved in either studio.
- **Captures:** `v12_<cam>_ref_a` / `v12_<cam>_ref` and `v12_<cam>_rep_a` / `v12_<cam>_rep`, all 1452x793.
  - Pixels changing by more than 30 levels within a pair: at most 4.6% in the reference (c4: animated water, VFX, crowd)
    and at most 0.7% in the practice place. The second frame was judged; no third frame was needed.
- **Files:** `out/verify12/v12_<cam>_ref.jpg` and `v12_<cam>_rep.jpg`, with the `_a` frames alongside.
- **Colours:** "sampled" RGB is a 5x5 average from those JPEGs. Other colours and all stud sizes are estimates.

## Overall read
Pass 14 lands three of round 11's top-5 fixes:
- **Blue foliage colour is fixed.** Practice blue samples (23,67,184) in shade and (77,144,222) lit, against the
  reference's (14,60,198) and (77,143,230). The white glints are gone.
- **The Story portal is right.** A carved silver-blue ring round a dark opening now reads like the reference in p4, p6 and
  p8. The Story canopy is a dense dome on an upright trunk, and the trunk no longer lies across p8.
- **The islands are lifted in c3.** There is sky between them and towers on top, so c3 now reads high and far.
- Also gone: the white plinths at the Raid door, and the baseplate at the p7 horizon (now closed by clumps and buildings).

**Foliage texture up close (asked specifically).** Better, but still not the reference style.
- The silhouettes now break up finely at the edges, and the purple and teal clumps read as speckle at mid distance.
- Inside the outline, though, each clump still shows **large flat triangular facets** with a crease down the middle:
  - about 40-80 px per facet at c1/p1 range, i.e. 3-5 studs;
  - so blue and gold clumps still read as **faceted balls / cabbage heads**, not as leaf masses.
- The 1.5-2.5 stud leaf cards are there at the rim, but the clump's core shell (or a few large cards at its centre) still
  dominates the read.
- The reference has no visible planes at all: its lit faces are continuous fine noise (0.3-0.5 stud leaves) with a soft
  dark core.
- **Gold:** better in light, sampled (232,210,85) and (173,140,54) against the reference's (215,174,76) and (171,146,88).
  Its shadow facets still go olive-brown, and each gold clump is a near-perfect sphere. The reference gold canopy is one
  big continuous, cloud-like mass.

**Raid: the haze colour is fixed, but the skull overshot.**
- **Haze:** red at last, sampled (197,68,91) against the reference's (191,76,67). It sits behind the facade as a
  soft-edged blob.
- **Skull:** now a **hot pink toy block**. The skull and its stacked plinth sample (241,70,92), saturated and flat. The
  reference skull is weathered brick-rose: (143,80,70) body, (233,127,112) highlights, and dark sockets.
- **Facade:** at (31,15,26) it is now near-black, much darker than the reference's lit stone (99,90,95) to (150,80,75).
- **Result:** the skull now pops too much and reads as plastic, and the temple behind it is a black silhouette. The
  reference reads as carved stone washed in red light.

**Unchanged from round 11:**
- The 5-swirl medallion.
- Tall white bollard plinths. They are shorter now, but still white boxes with a ball on a step.
- Pale wing flanks.
- c1 splats colour-swapped.
- Polka-dot red litter.
- Islands overhead in c4, p1 and p6.

## Per camera (round 11 -> round 12)

### p1_spawn_n: 7 -> 7
- **Gains:**
  - The blue arch trees are now properly saturated.
  - Gold and purple masses frame the avenue.
  - Blue palms at the Summon flanks.
- **Geometry:**
  - **Islands:** three undersides still hang across the top edge (y 0-130), with thin straight white streams.
    The reference shows a skyline: islands beyond, towers and an aqueduct, with the Guilds facade at upper left.
  - **Summon:** hidden behind gold balls; only a gold pediment roof shows. The reference shows a domed arcade, about 150 px
    wide, with "Summon" and a statue.
  - **Gold clumps:** 6 spheres in a row. The reference gold is one tall continuous canopy, about 300 px wide.
  - **Bollards:** white step box plus a gold ball. The reference has a squat grey plinth with a pointed, faceted gold cap.
  - **Medallion:** 5 broad swirls. The reference has 8 thin hooked blades and 8 gold studs at the rim.
- **Colour:** blue is now on target. Gold is OK in light but olive in shadow.
- **Missing:** the tall gold tree behind Summon, crowd/stall clutter, the Guilds sign and facade.

### p2_spawn_s: 7 -> 7
- **Gains:** grey/white domed palaces now appear at left and behind the gate.
- **Geometry:**
  - **Shard ring:** still navy segments round a white oval. The reference ring is grey stone, with the green palm through it.
  - **Gate:** about 180 px with a cyan spiral face. The reference is about 220 px, with a turquoise cloudy door and crystal
    fountains either side.
  - **Island:** an underside still sits at upper right.
- **Missing:**
  - The big green palm at upper right.
  - The tree on a rock pillar at upper centre-left.
  - The tall grass tufts along the stair top and on the treads (the reference has about 8 visible clumps).
  - Bloom on the gate.

### p3_spawn_e: 8 -> 8
- **Gains:**
  - The white plinths are gone.
  - The haze is red and behind the facade.
  - The skull is now the focal point.
  - The temple silhouette has spires and onion domes.
- **Geometry:**
  - **Skull tower:** the skull sits on a stacked pink plinth block (2 tiers) that reads as a toy. The reference skull grows
    out of a carved tapering pillar.
  - **Island:** an underside clips the top of the skull (y 0-40), so the island sits right above the Raid.
  - **Palms:** they still droop like bat wings. The reference has an upright red palm left of the door with spread fronds.
- **Colour and lighting:**
  - Skull hot pink (241,70,92) against brick-rose (143,80,70).
  - Facade near-black (31,15,26) against the reference's warm lit stone. The reference temple is mid-value with red light
    on every surface.
  - The haze is a single soft blob. The reference haze wraps the whole temple from the stairs up.
- **Missing:** red spill on the steps (the practice has a few petals, the reference about 8 splats) and the carved arch
  detail around the door.

### p4_spawn_w: 7 -> 8
- **Gains:**
  - The portal is a carved ring round a black opening, the right read.
  - The Story canopy is a dense blue dome with drip vines on a thick upright trunk.
  - Blue palms flank the portal.
- **Geometry:**
  - **Canopy:** about 330 px wide and stopping at y≈0. The reference canopy is about 450 px, with gnarled branches visible
    and hanging moss.
  - **Trunk:** a straight tan cylinder. The reference trunk is gnarled and splits into 4-5 thick limbs.
  - **Story sign:** a flat slab on the trunk. The reference has blue lettering over the portal.
- **Colour:** the background at right is cream/white buildings. The reference has a gold/cream Guild facade with columns.
- **Missing:** green palms at left, blue clumps at the portal base, grass on the stairs.

### p5_diag_ne: 8 -> 8
- **Gains:**
  - Raid is now a dark temple instead of a flat red slab.
  - Teal mass under the purple.
  - Saturated blue tree over the arch.
- **Geometry:**
  - **Summon:** a plain yellow pediment behind gold balls.
  - **Bollard:** a white plinth with a gold ball on a step.
  - **Raid sign and skull:** they read as pink plastic at the right edge.
- **Colour:** in the reference this whole right third glows red. In the practice it is dark maroon with only a small haze
  puff at the top.
- **Missing:** the red palm in front of Boss Rush, a blue palm left of the arch, and Summon stalls and lamps.

### p6_diag_sw: 7 -> 7
- **Gains:** the Story portal is right (dark opening, carved ring), and the domed buildings fill the gaps.
- **Geometry:**
  - **Island:** an underside still fills the top centre (y 0-150). The reference shows a big green palm, a ruin tower and
    sky.
  - **Expeditions gate:** a spiral face again.
- **Missing:**
  - Tall grass on the stairs (the reference stairs are heavily overgrown).
  - The orange tree behind the fountain.
  - Lanterns.
  - Crystal fountains by the gate.

### p7_high: 7 -> 7
- **Gains:**
  - No baseplate at the top: the horizon is now clumps, Summon and the Guilds building.
  - Blue clumps give the S arches mass.
- **Geometry:**
  - **W lagoon:** missing. The reference fills the left third with water ringed by blue foliage and palms. The practice has
    flat lawn and a white crystal plinth.
  - **S foreground:** flat lawn and a white plinth path. The reference has a sand beach, a big green palm with a pineapple,
    beach rings, and grass with flowers.
  - **E terraces:** the plain boxes are gone (good), but the E zone is now a large flat grey disc.
- **Colour:** the red litter is still round polka dots (sampled (198,52,59)). The reference red is ragged leaf cover in big
  continuous patches.
- **Missing:** the carved Boss Rush shrine. The practice has a flat box with a spiral.

### p8_top: 7 -> 7
- **Gains:**
  - The Story trunk is upright with a round platform.
  - The N quarter has purple, gold and blue masses.
  - Blue clumps at all four arches.
- **Geometry:**
  - **W half:** still about 50% open green lawn with scattered palms. The reference W is solid blue foliage round a stepped
    round arena with water.
  - **E:** a flat grey disc with polka dots. The reference is about 60% solid red cover, grey gravel paths and red palms.
- **Missing:** the S sand beach with green palms at the corners, the W arena steps, and dark-water fountain basins.

### c1_wall: 7 -> 7
- **Gains:** saturated blue tree, purple and teal masses at left, dark temple at right.
- **Geometry:**
  - **Wing flanks:** still pale (128,138,142) slab ramps rising outward. The reference wing is dark slate (64,72,70) with
    recessed bands and curves down.
  - **Fountain:** a translucent box column. The reference has a sculpted water splash.
- **Colour:**
  - The foreground splats are still swapped: red at left, blue and red at right. The reference has blue left and red right.
  - The practice splats are low-poly starbursts. The reference's are soft fringed leaf splats about 250 px across.
- **Close-up foliage:** the blue tree above shows triangular facets about 60 px, which is the "crumpled" read.
- **Missing:** blue crystal pods beside the pavilions (the practice has pale glass inside the cages only).

### c2_fountain: 7 -> 7
- **Gains:** glowing blue crystal pods by the pavilion (new and right), and Boss Rush with dead trees.
- **Geometry:**
  - **Skull plinth:** fills the upper left as a hot-pink stacked block, the loudest thing in frame. The reference tower here
    is a dark red carved spire with a glowing beam.
  - **Wing:** still a long pale ramp rising to the right.
- **Missing:**
  - The orange tree and grey palace domes at right (the practice has sky and a white box).
  - Tall grass at the right stair top.
  - The red palm at left.

### c3_pavilion: 8 -> 8
- **Gains:**
  - The islands are high and separated, with sky between them and towers on top. This is the round-11 fix, and it works
    here.
  - Haze behind Raid.
- **Geometry:**
  - **Islands:** flat grey wedges with straight thin white lines for falls. The reference islands have green tops spilling
    over, trees, an aqueduct, and wider glowing falls with mist.
  - **Towers:** about 60-80 px. The reference towers are about 150 px.
  - **Skull:** a large pink block at right. The reference skull is darker brick and sits higher.
- **Colour:** gold in shadow samples (113,143,125), grey-green, against the reference's (174,145,74).
- **Missing:** the dark red palm in front of Raid, and the Summon statue and arcade.

### c4_stairs: 7 -> 7
- **Gains:** twin blue palms, gold, purple and teal masses, and blue glass hedge masses at the stair tops.
- **Geometry:**
  - **Islands:** from here they still crowd the top third (three undersides, y 0-200). Lifting them did not clear this
    camera.
  - **Summon:** only a gold pediment, behind a wall of gold balls.
  - **Cypress:** still small (about 100 px). The reference cypress pair is about 210 px.
  - **Hedges:** the stair-top masses are smooth glassy blobs. The reference has blue foliage hedges with the same fine
    texture as the trees.
- **Missing:** the gold pineapple at left, bunting and flags, crowd and stalls, the Summon facade with statue, and the tall
  gold tree.

## Scores
| camera | r11 | r12 |
|---|---|---|
| p1_spawn_n | 7 | 7 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 8 | 8 |
| p4_spawn_w | 7 | 8 |
| p5_diag_ne | 8 | 8 |
| p6_diag_sw | 7 | 7 |
| p7_high | 7 | 7 |
| p8_top | 7 | 7 |
| c1_wall | 7 | 7 |
| c2_fountain | 7 | 7 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 7 | 7 |
| **average** | **7.25** | **7.33** |

## Top-10 fixes (ranked by visual impact)
1. **Kill the facets inside the clumps.** (All cameras.) The leaf colour is right now; the structure is not.
   - Remove or hide each clump's inner shell and any card larger than 2.5 studs.
   - Fill the volume with 120-200 small cards (1-2 studs), randomly rotated through 360° so no two adjacent cards share a
     plane.
   - Set the normals to point outward from the clump centre (spherical normal transfer). The shading should then fall
     smoothly from lit top to dark core instead of breaking per card.
   - Target: no flat facet over 1 stud visible at the c1 range.
   - Gold: break the spheres. Merge 3-5 gold clumps into one irregular canopy mass about 30 studs wide by 20 studs tall
     behind Summon, and lift the shadow colour to (170,130,55).
2. **Raid: re-balance the skull and facade.** (p3, p5, c2, c3.)
   - Skull: brick-rose (150,80,72), with highlights (230,125,110) from a PointLight (255,90,80) at range 20. Keep the eye
     sockets dark (60,15,20).
   - Replace the 2-tier pink plinth with a tapering carved pillar in facade colour, so the skull grows out of the tower.
   - Facade: lift it to (95,40,45), with trim (130,60,60).
   - Add 2-3 red SpotLights (255,70,60) aimed up the facade from the stair foot, so the stone reads lit-red rather than
     black.
   - Widen the haze from one blob to a band about 60 studs wide from the stair top to the spires.
   - Move the island above Raid at least 25 studs up or out, so it does not clip the skull in p3.
3. **Islands: clear the player-height cameras.** (c4, p1, p6, p2.)
   - In c4, p1 and p6, three undersides still fill the top 130-200 px.
   - Push the N islands another 40 studs out (or raise them another 20), so they sit behind Summon rather than over the
     avenue.
   - Move the S/SW island at least 50 studs further out.
   - Replace the straight white stream lines with 3-4 stud falls (200,235,255) at Transparency 0.3, with a mist emitter at
     the base.
   - Spill grass and vine over the island edges.
   - Towers: 35-50 studs. Add one 4-arch aqueduct.
4. **Bollards and medallion; they are in the foreground of every spawn camera.** (p1-p6.)
   - Bollard: a squat grey stone body (150,155,160), about 3x3x2.5 studs, with a pointed, faceted gold cap (bishop-mitre
     shape) about 2 studs tall. No white box.
   - Medallion: 8 thin hooked dark blades (45,55,65), each about 1 stud wide at the root, tapering to a hook. Add a gold
     hub and 8 gold studs on the rim ring.
5. **W quarter: lagoon and arena.** (p7, p8, p4, p6.)
   - Replace the open W lawn with:
     - a lagoon about 50x40 studs of water (60,170,220);
     - ringed by blue clumps and 4-6 blue palms;
     - a stepped round white-stone arena about 40 studs across round the Story tree.
   - Cover at least 80% of the W ground with foliage, water or stone.
   - Story trunk: 4-5 gnarled limbs splitting at about 2/3 height, visible through the canopy.
   - Canopy: widen it to about 75 studs.
6. **Arch wings and pods.** (c1, c2, c3, p5.)
   - Wing flanks: dark slate (60,70,72), with 2 recessed bands and a gold rim on top. Slope them down toward the plaza,
     not up and out.
   - Put 2 faceted crystal pods beside each pavilion at c1 (Glass/Neon (40,110,230), 4x6 studs, PointLight range 12), as
     already done at c2.
7. **Ground litter.** (p7, p8, c1, p3.)
   - Red zone: replace the round dots with ragged leaf-splat cards (3-6 studs), merged into continuous patches. Cover about
     60% near Raid, falling to 30% by the plaza, with green holes.
   - Lay 6-8 red splats on the E stairs.
   - c1: swap the splats so blue is on the left (Summon side) and red on the right (Raid side).
   - Use fringed soft splats about 4 studs across instead of starbursts.
8. **Grass on the S/W stairs and stair tops.** (p2, p4, p6, c2.)
   - Add 10-15 tall grass tufts (2-3 studs, (110,200,60)) on the S and W stair treads and along the stair-top edges.
   - The reference stairs read overgrown; the practice stairs read clean.
9. **N avenue dressing and Summon.** (c4, p1, p5.)
   - Summon: thin the gold balls in front of it so the facade shows. Add a 5-arch column arcade, a central dome, and a gold
     statue in the middle arch. Facade (235,210,150).
   - Gold pineapple about 8 studs tall by the W pavilion.
   - Cypress pair: about 5x18 studs, same fine leaf cards.
   - Re-skin the glassy stair-top hedge blobs with the foliage cards.
   - Add bunting between the lamp posts.
10. **S side and horizon.** (p2, p6, c2, p7.)
    - Shard ring to grey stone (150,155,160).
    - Expeditions gate: scale it 1.2x and replace the spiral with a turquoise cloudy door, plus a crystal fountain either
      side.
    - Big green palm (about 30 studs) at upper right of the gate.
    - Orange tree (240,150,60) behind the Expeditions fountain and in c2 right.
    - Grey palace domes behind c2 right.
    - S foreground in p7: a sand beach (225,205,150) with a green palm, a pineapple and beach rings.
