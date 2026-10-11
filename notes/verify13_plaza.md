# Verify round 13: Anime Expeditions spawn plaza (freestyle, after fix pass 15)

Scored against the **live reference** on the Shadow PC on 2026-10-10 by an independent reviewer who had not seen the build
before. Round 12 (`verify12_plaza.md`) was read for context only; every score below is fresh.

## Method
- **Reference:** studio `12bdc68f-9f23-444b-9718-8043ca761440`, cameras from `cams.json`.
- **Practice:** studio `ae13592b-5ca7-43d3-91a6-9135c14250eb`, cameras from `cams_practice.json`.
- **Tools:** `screen_capture` only. No code was run; nothing was modified or saved in either studio.
- **Captures:** `v13_<cam>_ref_a` / `v13_<cam>_ref` and `v13_<cam>_rep_a` / `v13_<cam>_rep`, all 1452x793.
  - Pixels changing by more than 30 levels within a pair: at most 5.7% in the reference (p8, animated water/VFX/crowd)
    and at most 0.5% in the practice place (fountain mist). The second frame was judged; no third frame was needed.
- **Files:** `out/verify13/v13_<cam>_ref.jpg` and `v13_<cam>_rep.jpg`, with the `_a` frames alongside.
- **Colours:** "sampled" RGB is a 5x5 average from those JPEGs. Other colours and all stud sizes are estimates.

## Overall read
Pass 15 fixed what it set out to fix, and the build now has no single object that breaks the picture. What is left is mostly
**absence** (W lagoon, S beach, grass, Summon facade, skyline mass) and **mood** (Raid is lit by daylight, not red light).

**Foliage interiors (asked specifically): fixed.**
- At c1 range the blue tree over the pavilion is now continuous fine noise of 1-1.5 stud cards. No flat facet over about
  1 stud is visible in any camera; the "cabbage head" read is gone in blue, purple, teal and gold.
- What remains is **depth**: every clump is the same mid value right through. Practice blue samples (27,107,201) to
  (71,111,180) in both lit and core areas; the reference runs from (90,165,253) lit tips to (7,61,157) in the core. The
  clumps read a little like blue confetti rather than a lit volume.
- **Gold:** the row of spheres is now one continuous canopy behind Summon (good, p1/c4). Lit gold samples (215,189,80) to
  (228,202,86), a touch lemon against the reference (196,157,73) to (208,177,108); the olive shadow is gone.

**Raid skull and facade (asked specifically): mostly fixed.**
- **Skull:** brick-rose now, sampled (172,80,79) against the reference (153,86,91) body / (208,103,95) lit. It grows out of a
  carved tapering pillar and reads as stone. This is the right read in p3, c2 and c3.
- **Facade:** brick, sampled (86,45,53) to (90,28,37). Mid-dark, close to the reference's shadowed stone (75,43,58); no
  longer a black silhouette. But its lit faces are lit by **daylight**: there is no red on the stone. The low uplights do
  not read in any camera.
- **Haze:** wider, but it is a **round pink-mauve halo** sampled (156,108,151) to (174,102,140) sitting behind the tower
  like a sticker. The reference haze is red-orange (192,77,84) and wraps the whole temple from the stair top up, with red
  glow on every surface.
- **Door skull:** still a small pink plinth-and-skull toy over the door (p3, p5, c3). The reference has a small carved skull
  in the arch keystone.
- **Island:** clear of the skull in p3 (now at the upper-right corner). Good.

**Sky bands in c4/p1/p6 (asked specifically): cleared, but now too thin.**
- No undersides hang across the top of c4, p1 or p6 any more; the sky is open and the islands sit behind Summon. That
  fixes the "crowded ceiling".
- But the reference's player-height skyline is **not** empty. In c4 and p1 the reference has big green-topped islands
  across the upper third, with vines, glowing waterfalls, an aqueduct and 150 px towers. The practice islands are now small,
  grey-white, far away, with tiny towers and hairline falls. The skyline went from "too close" to "too thin".
- In c3 the same move cost a little: the reference's upper-left is dominated by a near island with two falls; the practice
  upper-left is mostly sky.

**Unchanged from round 12:** 5-swirl medallion; white bollard plinth with a gold ball; pale wing flanks rising outward; c1
splats swapped and starburst-shaped; polka-dot red litter; open W lawn; no S beach; clean stairs (no grass); Summon is a gold
pediment only; glassy stair-top hedges; spiral Expeditions gate.

## Per camera (round 12 -> round 13)

### p1_spawn_n: 7 -> 8
- **Gains:**
  - The blue arch trees are now fine-textured leaf masses, no facets.
  - The gold is one continuous canopy behind Summon, about 300 px wide, as in the reference.
  - The island undersides are gone from the top; towers and islands sit far behind Summon.
- **Geometry:**
  - **Summon:** still only a gold pediment roof showing. The reference shows a domed arcade with "Summon" and a statue.
  - **Skyline:** the reference's upper third is green islands, falls, an aqueduct and the Guilds facade (upper left). The
    practice is mostly open sky with small grey islands.
  - **Bollards/medallion:** unchanged (white step box + ball; 5 broad swirls vs 8 thin hooked blades and 8 gold rim studs).
- **Colour:** blue on target; gold slightly lemon (215,189,80) vs (196,157,73).
- **Missing:** crowd/stalls clutter, bunting, Guilds facade at upper left (the practice has a cream building there, close).

### p2_spawn_s: 7 -> 7
- **Gains:** clumps are fine-textured.
- **Geometry:**
  - **Shard ring:** navy segments round a white oval. The reference ring is grey stone.
  - **Gate:** about 180 px with a cyan spiral and a white statue. The reference is about 220 px with a turquoise cloudy door
    and crystal fountains either side.
  - **Island:** one still sits at upper right with a tower.
- **Missing:** the big green palm at upper right, the tree on a rock pillar at upper left, tall grass along the stair top
  and treads (reference: about 8 clumps), bloom on the gate.

### p3_spawn_e: 8 -> 8
- **Gains:**
  - Skull is brick-rose stone on a carved tapering pillar: the toy read is gone.
  - Facade is mid-dark brick with spires and onion domes, not a black cut-out.
  - Island clear of the skull.
- **Geometry:**
  - Door skull is a pink plinth toy; the reference has a carved keystone skull.
  - Palms still droop like bat wings; the reference has an upright dark-red palm left of the door with spread fronds.
- **Colour and lighting:**
  - The haze is a round pink-mauve halo (156,108,151). The reference haze is red-orange (192,77,84) and fills the whole
    temple, stair top to spires.
  - No red light on the facade; it is daylit brick. The reference has red glow on every surface and a glowing doorway.
- **Missing:** red splats on the stairs are thin (a few petals); the carved arch detail round the door.

### p4_spawn_w: 8 -> 8
- **Gains:** Story canopy is now fine-textured, with drip vines.
- **Geometry:**
  - **Trunk:** still a straight tan cylinder. The reference trunk is gnarled and splits into 4-5 thick limbs filling the
    upper centre.
  - **Canopy:** about 330 px; reference about 450 px, cut by the top edge.
  - **Story sign:** a slab on the trunk; the reference has blue lettering arched over the portal.
- **Missing:** green palms at left, blue clumps at the portal base, grass on the stairs (the practice has a few green splats).

### p5_diag_ne: 8 -> 8
- **Gains:** fine-textured purple/teal/gold masses at left; Raid is stone, not pink plastic.
- **Geometry:** Summon is a yellow pediment; bollard white plinth + ball; door skull toy.
- **Colour:** the reference's whole right third glows red (233,108,117) on the arch. The practice right third is daylit
  brick with a dark door (41,13,22).
- **Missing:** the red palm in front of Boss Rush, Summon stalls and lamps.

### p6_diag_sw: 7 -> 7
- **Gains:** the island is now upper left-centre with towers, which echoes the reference's ruin tower island. The top
  centre is no longer an underside.
- **Geometry:** Expeditions gate spiral; Story sign tilted on the trunk.
- **Missing:** tall grass on the stairs (the reference stairs are heavily overgrown), the big green palm at top centre,
  the orange tree behind the fountain, lanterns, crystal fountains at the gate.

### p7_high: 7 -> 7
- **Gains:** every clump on the horizon is now a fine leaf mass; the horizon reads like dense foliage.
- **Geometry:**
  - **W lagoon:** missing. The reference fills the left third with water ringed by blue foliage and palms. The practice
    has lawn and a white crystal plinth.
  - **S foreground:** lawn and white plinth path. The reference has a sand beach, a big green palm with a pineapple, beach
    rings.
  - **E:** flat grey disc with red polka dots. The reference is ragged continuous red cover with green holes and a carved
    Boss Rush shrine.
- **Colour:** fine.

### p8_top: 7 -> 7
- **Gains:** clumps read as leaf masses from above.
- **Geometry:**
  - W half still about 50% open lawn with scattered palms. The reference W is solid blue foliage, a stepped round arena
    and water.
  - E is a grey disc with dots. The reference is about 60% red cover, gravel paths, red palms.
- **Missing:** S sand beach with green palms, W arena steps, dark-water fountain basins.

### c1_wall: 7 -> 7
- **Gains:** the blue tree above the pavilion: no facets close up, which was the round-12 complaint. Purple and teal also
  fine.
- **Geometry:**
  - **Wing flanks:** still pale slab ramps rising outward. The reference is dark slate with recessed bands, curving down.
  - **Fountain:** a translucent box column. The reference has a sculpted water splash.
- **Colour:**
  - Foreground splats still swapped: red at left, blue/red at right. The reference has blue left, red right.
  - Practice splats are low-poly starbursts; the reference splats are soft fringed leaf splats about 250 px across.
  - Raid at right is daylit brick; the reference is red-glowing.
  - Clump has no dark core; the reference tree has deep blue shadow inside.
- **Missing:** the big crystal pods beside the pavilions.

### c2_fountain: 7 -> 7
- **Gains:** the hot-pink stacked block is gone; the tower is now brick on a pillar, and no longer the loudest thing in
  frame.
- **Geometry:** wing still a long pale ramp rising to the right; skull tower sits behind a pink round halo.
- **Colour:** the reference's whole left half is red-lit (Boss Rush, Raid, red palm). The practice has a red bush and
  daylit brick.
- **Missing:** the orange tree and grey palace domes at right (the practice has sky and a white box); tall grass at the
  right stair top; the red palm at left.

### c3_pavilion: 8 -> 8
- **Gains:** the skull is now brick-rose stone on its tower at upper right, in the same place as the reference skull.
- **Geometry:**
  - **Islands:** now small and far. The reference upper-left has a near island with green spill, two glowing falls and an
    aqueduct; the practice upper-left is mostly sky.
  - **Door skull:** a pink plinth toy under "Raid".
- **Colour:** haze is a pink-mauve blob at right, the reference a red-orange wash (237,129,108 lit) over the whole temple.
- **Missing:** the dark-red palm in front of Raid; the Summon statue and arcade.

### c4_stairs: 7 -> 7
- **Gains:** the top third is no longer three undersides; gold is a continuous canopy; clumps are fine-textured.
- **Geometry:**
  - **Skyline:** now small islands far off. The reference upper third is big green islands with vines, two glowing falls,
    an aqueduct and 150 px towers. Both versions have islands up there; the reference's are near, green and lush.
  - **Summon:** only a gold pediment behind clumps. The reference shows the facade with the statue.
  - **Hedges:** the stair-top masses are still smooth glassy blue blobs.
  - **Cypress:** small.
- **Missing:** the gold pineapple at left, bunting and flags, crowd and stalls, the Summon facade.

## Scores
| camera | r12 | r13 |
|---|---|---|
| p1_spawn_n | 7 | 8 |
| p2_spawn_s | 7 | 7 |
| p3_spawn_e | 8 | 8 |
| p4_spawn_w | 8 | 8 |
| p5_diag_ne | 8 | 8 |
| p6_diag_sw | 7 | 7 |
| p7_high | 7 | 7 |
| p8_top | 7 | 7 |
| c1_wall | 7 | 7 |
| c2_fountain | 7 | 7 |
| c3_pavilion | 8 | 8 |
| c4_stairs | 7 | 7 |
| **average** | **7.33** | **7.42** |

## Top-10 fixes (ranked by visual impact)
1. **Raid: red light, not a pink sticker.** (p3, p5, c1, c2, c3.)
   - Replace the round halo with a band about 60 studs wide by 40 tall that hugs the temple from the stair top to the spire
     tips, colour (200,70,60), soft edge, Transparency about 0.5 at the centre. Remove the mauve/pink tint entirely.
   - Make the stone take red light: 3-4 SpotLights (255,60,50), Brightness 3-5, Range 40, from the stair foot aimed up the
     facade; a PointLight (255,50,40) range 20 in the doorway; a red Neon strip in the door arch so the door glows.
   - Replace the pink plinth-and-skull over the door with a 3-stud carved keystone skull in facade brick (150,80,72).
   - Add 1 upright dark-red palm (80,20,25 fronds), about 20 studs, left of the door, spread fronds, not drooping.
2. **Skyline: bring the islands back as a lush backdrop, not a ceiling.** (c4, p1, c3, p2.)
   - Keep them clear of the top 120 px at player height (do not move them back over the avenue), but scale the N group
     1.5-2x and lower them 10-15 studs behind Summon so they fill the band y≈80-300 in c4.
   - Green tops spilling over the edges (grass skirt and vines hanging 6-10 studs), 2-3 trees per island.
   - Falls 3-4 studs wide (200,235,255), Transparency 0.3, with a mist emitter at the base. Two visible in c4, two in c3.
   - Towers 35-50 studs; one 4-arch aqueduct between two islands in c4.
3. **Bollards and medallion.** (Foreground of every spawn camera.)
   - Bollard: squat grey stone body (150,155,160), about 3x3x2.5 studs, with a pointed faceted gold cap (bishop mitre) about
     2 studs tall. Remove the white box and the ball.
   - Medallion: 8 thin hooked dark blades (45,55,65), about 1 stud wide at the root tapering to a hook; gold hub; 8 gold studs
     on the rim ring.
4. **W quarter: lagoon and arena.** (p7, p8, p4, p6.)
   - A lagoon about 50x40 studs of water (60,170,220), ringed by blue clumps and 4-6 blue palms.
   - A stepped round white-stone arena about 40 studs across round the Story tree.
   - Cover at least 80% of the W ground with foliage, water or stone.
   - Story trunk: 4-5 gnarled limbs splitting at about 2/3 height, visible through the canopy; widen the canopy to about
     75 studs.
5. **Grass on the S/W stairs and stair tops.** (p2, p4, p6, c2.)
   - 12-20 tall grass tufts (2-3 studs, (110,200,60)) along the S and W stair-top edges and on the treads, plus long grass
     strips (1.5 studs tall) along each stair-top lip. The reference stairs read overgrown; the practice reads clean.
6. **Foliage depth.** (All cameras, most visible at c1, p4, p1.)
   - Shade the cards by depth: cards in the inner 40% of the clump radius (15,60,160), outer cards (70,140,230), top
     5-10% tips (110,180,255). Same scheme for purple and teal.
   - Gold lit (200,160,75), core (150,115,45) — drop the lemon.
   - Re-skin the glassy stair-top hedge blobs (c4, p1) with the same cards.
7. **Summon facade.** (p1, c4, p5, c3.)
   - Thin the clumps directly in front so a 5-arch column arcade (facade (235,210,150)) with a central dome shows, about
     30 studs wide, with a gold statue in the middle arch and the "Summon" sign over it.
   - Add stalls, umbrellas and bunting between the lamp posts on the avenue; gold pineapple about 8 studs by the W pavilion.
8. **Arch wings and pods.** (c1, c2, c3, p5.)
   - Wing flanks dark slate (60,70,72), 2 recessed bands, gold rim on top, sloping down toward the plaza.
   - 2 faceted crystal pods (Glass/Neon (40,110,230), 4x6 studs, PointLight range 12) beside each pavilion at c1.
9. **Ground litter.** (p7, p8, c1, p3.)
   - E zone: replace round dots with ragged leaf-splat cards 3-6 studs, merged into continuous patches: about 60% cover near
     Raid falling to 30% by the plaza, with green holes; 6-8 red splats on the E stairs.
   - c1: swap the splats (blue at left/Summon side, red at right/Raid side) and use soft fringed splats about 4 studs across.
10. **S side.** (p2, p6, c2, p7.)
    - Shard ring to grey stone (150,155,160).
    - Expeditions gate 1.2x, turquoise cloudy door instead of the spiral, a crystal fountain either side.
    - Big green palm (about 30 studs) at upper right of the gate; orange tree (240,150,60) behind the Expeditions fountain
      and in c2 right; grey palace domes behind c2 right.
    - S foreground in p7: sand beach (225,205,150) with a green palm, a pineapple and beach rings.
