# Verify round 3: Anime Expeditions spawn plaza (freestyle, after fix pass 5)

This is an independent review. I used `screen_capture` only and took 2 captures per camera in each studio. The frames were identical
each time, and I judged the last one. Reference studio is `ecdeebfb-...`, practice studio is `efa46ce6-...`. Cameras come from
`cams.json` and `cams_practice.json`. I ran no code and changed nothing in either Studio.

RGB values marked "sampled" come from the captured frames (3x3 average, read from the saved JPEGs). Every other colour, and all
sizes, are estimates from the pictures. Rule of thumb: 1 stud at d studs is about 565/d px wide in a 1284 px frame.

## Overall read
Pass 5 is a clear step up again. These now read right at player height:
- The gate silhouette: a squared-U crest, a deep vault and the basin under the arch.
- The bollards in the foreground, the lanterns on drums and the big blue Story tree.
- The skyline: there is finally something in it (floating islands, waterfalls, palms).

From the spawn the composition now matches the reference closely. The gap is now about **finish and density**, not layout:
1. **Shading goes navy and black.** In the round-2 report the problem was pale and flat. Now any gate face away from the sun
   reads deep navy, sampled (16,45,86), against the ref's grey-slate (36,44,62) to (54,61,68). The vaults are nearly black,
   sampled (0,0,10) to (9,17,43), against the ref (26,36,46) with a lit fountain. In p6 the whole gate is a silhouette.
2. **The sky half is still thin.** The islands are slate-blue saucers, underside sampled (43,90,137), with a hairline grass rim.
   The ref has grey rock (about 150,150,140) under thick green caps, with vines, ruined white towers and big white cumulus.
   The practice sky is saturated, sampled (75,180,228), with only small wisps of cloud.
3. **The planting is the wrong type.** Rows of tall, dark-trunked feather palms, trunk sampled (44,38,49), plus blue cone
   cypresses replace the ref mix: few palms, and big fluffy gold, purple and blue broadleaf trees.
4. **Hard-edged ground zoning** (p7/p8). There are three straight rectangles: blue-grey west, maroon east, green north/south.
   Their edges line up with the plaza edge.
5. **The landmarks are still toy blockouts.** The Raid skull reads as a cartoon face, and the Expeditions arch is a plain
   teal box.

## Per camera (round-2 score in brackets)

### p1_spawn_n: 6/10 (5)
- Geometry/proportion:
  - Gates, basins, bollards, stairs, runner and the hall at the end now line up almost one-for-one with the ref.
  - The crest is the right squared-U idea, but the notch is narrow and shallow: about 55 px wide and 50 px deep. The ref
    notch is about 145 px wide and 145 px deep, a see-through window.
  - The lantern domes now sit about 30 px higher than the ref, and are smooth instead of ribbed.
  - The medallion blades are still broad crescent swirls. The ref has 8 thin hooked blades.
- Colour/material:
  - The gold ring is orange-gold, sampled (187,134,21), against (145,124,18) to (180,166,62) in the ref.
  - The lantern glass is pure cyan, sampled (0,216,254), against a softer (85,138,180) with a glowing core.
  - The floor is right in value (about 200,200,192) but has no tile grout.
- Lighting: the vaults are black holes, with no fountain glow. There is no haze, and the far end of the avenue is as crisp
  as the foreground.
- Missing:
  - The gold tree left of the avenue and the purple wisteria right of it.
  - The blue trees with floating crystals behind each gate.
  - The stall and umbrella clutter on the avenue.
  - Island caps with towers. The practice islands are thin saucers.

### p2_spawn_s: 5/10 (4)
- Geometry:
  - The Expeditions portal is a plain teal arch about 95 px tall. The ref is an ornate stained-glass arch with columns, a
    sign and two crystal braziers, about 150 px tall to the finial.
  - The ref has a ring of about 8 floating rock slabs above it, around a white glow. The practice has one dark slab that
    reads as debris.
- Colour: the gate stone on this sun-facing side reads navy (about 20,40,80), where the ref is mid grey with gold.
- Missing:
  - The giant green palm on the top right.
  - Grass spilling over the stair edges and stair tops. This is the main identity of the ref's south side.
  - The domed towers on the far left.

### p3_spawn_e: 5/10 (4)
- Geometry:
  - The Raid block now spans the right width (about 235 px against about 300 px with spires), but the skull top is at
    y=190 against y=30. The tower needs about 2x the height.
  - The entry is a dark rectangle, where the ref has a pointed gothic arch with columns and a "Raid" pediment and skull.
  - The spires are black egg shapes.
- Colour: deep maroon (about 120,30,40), flat. The ref is weathered red stone (170,70,60) to (200,90,80) with a red glow.
  There are now red and gold palms behind it, which is good.
- Missing: the bare dead trees, the red leaf litter on the steps (only about 4 small clumps now), the glow and haze.

### p4_spawn_w: 5/10 (4)
- Geometry:
  - The giant blue tree finally exists and centres the view (canopy about 300 px). The trunk is about 75 px wide against
    about 200 px in the ref, and has no root flare.
  - The Story ring is about 70 px against about 95 px.
- Colour:
  - The trunk is near black, where the ref is tan-brown (130,90,60).
  - The ring interior is navy blue, where the ref is a black void (15,15,20).
  - The ring has no gold crown or crest above it.
- Missing: the blue palms flanking the ring, the fluffy blue trees and crystals, the green ground plants on the stairs.

### p5_diag_ne: 6/10 (5)
- Geometry:
  - This is still the best match. The gate, basin, near bollard and both runner arms sit where the ref has them.
  - The gate is now about 540 x 255 px (w:h about 2.1) against about 460 x 280 px (about 1.65). That is a touch wide and
    flat, mainly because the crest is short and the shoulders are long.
  - The lanterns rise about 45 px above the ref's.
- Colour:
  - The runners are good, but the foreground band is navy (about 20,40,80). The ref is dark slate (60,65,75) with pale stone.
  - The Summon hall (left) is a sand box with a gold onion dome. The ref is a cream and gold arcaded facade.
- Missing: the purple trees, the blue tree with crystals behind the gate, the red leaf litter on the right flight.

### p6_diag_sw: 5/10 (5)
- Geometry: the layout is correct, matching p5.
- Colour/lighting: this is the worst case for the shading problem.
  - The whole gate face is in shadow and reads as a navy silhouette, sampled (16,45,86), crest (8,29,60). The ref shaded
    gate stays grey-slate, about (36,44,62), with readable gold bevels.
  - The vault and basin go black.
- Missing:
  - The grass carpets on both flights and the floor (the ref's strongest colour here).
  - The ornate Expeditions arch with its floating rock ring (the practice shows dark beams top-left).
  - The palms.
- No gain over round 2 here, because the darker stone cancels out the geometry wins.

### p7_high: 5/10 (4)
- Geometry:
  - The sunken cross, the four corner pools with lanterns, the diamond medallion court and the long runners read well.
  - The corner pools and lanterns are slightly oversized: the south pools are about 220 px wide against about 180 px.
- Colour/material:
  - The ground is flat colour plates with straight edges. The ref is textured grass with sand patches, water channels on
    the west, and red litter on grey gravel to the east.
  - The far horizon shows a flat green plane meeting the sky, where the ref has buildings out to the frame edge.
- Missing: the avenue clutter, the umbrellas, the big foreground palm with a sand patch, the plaza grass tufts.

### p8_top: 6/10 (5)
- Geometry:
  - The footprint matches closely: cross arms about 345-945 px against 350-935, and pool centres within about 10-15 px.
  - The practice centre diamond is about 160 px against about 140, and the stair blocks show a brick grid that the ref
    does not have.
- Colour/material:
  - The zones split at x=455 and x=830 in dead-straight lines.
  - West is uniform blue-grey (the ref is a patchwork of blue foliage, white flowers, green, water and stone).
  - East is flat maroon (the ref is vivid red litter (190,45,40) on grey gravel with green islands).
- Missing: the north water channel (the ref avenue is a pool with sand beaches), the south arcaded courtyard.

### c1_wall: 5/10 (4)
- Geometry:
  - The arch, vault, two-tier basin with gold slats and lantern pair are all present.
  - The crest is two box tabs with a 55 px notch. The ref has thick 60 px hooked arms framing a 145 px window, and the
    tree shows through it.
  - The trims are round tubes, about 0.5-stud cylinders. The ref uses flat inset gold bands that follow the bevels.
  - The basin's lower band is navy and black. In the ref it is mid grey (83,91,100).
- Colour: the gold is orange (about 190,130,20). The ref gold is yellower with highlights (about 200,175,60).
- Lighting:
  - The vault is black, sampled (0,0,10). The ref is (26,36,46) with a lit fountain spray.
  - The lantern glass is flat cyan with no inner glow shape.
- Missing: the water spray VFX, the blue tree and crystals between the lanterns, the ribbed lantern domes, and the
  foliage clumps at the basin foot (there are 2 small ones).

### c2_fountain: 4/10 (3)
- Geometry:
  - In the ref the basin stands forward of the arch, by about 4-5 studs of its diameter. In the practice it is tucked half
    inside.
  - The arch band is thinner and has no stepped bevels.
- Material:
  - The "foam cascade" is a glowing cyan slab sticking out of the vault at an angle. It reads as a glitch.
  - The steps are big plain blocks with no worn edges or tile split.
  - A navy gutter (about 25,35,70) runs under the camera.
- Missing: water falling from the upper ledge into the bowl, cracked floor slabs, grass clumps, the depth of the ref
  background (Raid and Boss Rush are both visible there).

### c3_pavilion: 5/10 (4)
- Geometry:
  - Gate and lanterns are framed like the ref.
  - The palms on the left splay outward at mixed 10-25 degree leans, like a dropped bundle. The ref has one palm leaning
    gently.
  - The Raid block on the right is a flat wall with a ball head.
- Sky:
  - The upper 45% is nearly empty blue. The ref fills it with big cumulus, two green-capped islands with 2-3 waterfalls,
    ruined towers and a skull tower about 2x taller.
  - The practice islands are dark slate saucers.
- Missing: the purple and gold trees, the umbrellas and stalls of the Summon avenue, the dead red tree.

### c4_stairs: 5/10 (5)
- Geometry:
  - The stair, runner and lantern framing are a near-exact match: the top step is at y=455 in both.
  - The avenue holds about 12 tall palms per side plus a row of blue cones. The ref has 2 big palms per side (about 22
    studs), a huge gold tree (about 25 studs across) and purple, blue and teal trees around them.
- Colour:
  - The runner is good (ref sampled (56,97,216)).
  - The palm trunks are near black (44,38,49) with ring bands. The ref trunks are tan (150,110,60).
  - The steps lack the darker risers (about 95,100,110) that give the ref treads their read.
- Missing: the umbrellas, the pineapple house and stall clutter, the ornate Summon facade, the waterfalls straight ahead.

## Scores
| camera | r2 | r3 |
|---|---|---|
| p1_spawn_n | 5 | 6 |
| p2_spawn_s | 4 | 5 |
| p3_spawn_e | 4 | 5 |
| p4_spawn_w | 4 | 5 |
| p5_diag_ne | 5 | 6 |
| p6_diag_sw | 5 | 5 |
| p7_high | 4 | 5 |
| p8_top | 5 | 6 |
| c1_wall | 4 | 5 |
| c2_fountain | 3 | 4 |
| c3_pavilion | 4 | 5 |
| c4_stairs | 5 | 5 |
| **average** | **4.33** | **5.17** |

## Top-10 fixes (ranked by visual impact)
1. **Stop shadows going navy and black.**
   - Set every gate, crest and basin stone part to a neutral grey: Color (150,155,165), and remove any blue tint.
   - Raise Lighting `Ambient` and `OutdoorAmbient` to about (140,140,150).
   - Set vault interior surfaces to (60,68,85).
   - Add a PointLight in each vault, 2 studs above the upper bowl: colour (120,200,230), range 12, brightness 1.5.
   - Add an Atmosphere (density about 0.3, haze about 1.5, colour (200,215,230)) so distance softens.
   - Target: the shaded gate in p6 at about (55,62,75) or lighter. (Check `Lighting.Technology` by hand.)
2. **Make the skyline read as the ref's.**
   - Recolour the island undersides to rock (150,150,140). Give them 2-3 stud green caps (110,170,70) with hanging vine
     strips.
   - Scale the islands about 2x. Put 3-4 of them N and NE at 150-300 studs out, at heights that fill y=0-250 px in p1, c3
     and c4.
   - Add 2 ruined white towers (about 8x8x50 studs) on top.
   - Desaturate the sky to about (120,190,235) and add large white cumulus cards behind the islands.
3. **Swap the palm rows for the ref's tree mix.**
   - On the north avenue, keep 2 palms per side (about 22 studs tall). Recolour the trunks to tan (150,110,60). Use broad
     6-8 leaf blue fronds instead of feathers. Lean them 5-10 degrees, consistently outward.
   - Remove about 70% of the palms and cone cypresses.
   - Add a gold broadleaf tree (canopy about 25 studs, (215,170,40)) at about (-15, 0, -95).
   - Add purple wisteria trees (150,110,210) at about (+15 to +25, -85 to -100).
   - Add a fluffy blue tree (canopy about 10 studs, (40,90,230)) with 2 floating crystals behind each gate, between its
     lanterns.
   - Fix the splayed palm bundle in c3.
4. **Break up the ground zoning.**
   - Replace the three straight rectangles with organic edges, starting 6-10 studs from the plaza.
   - West: grass with water channels (90,170,200), blue shrubs and white flower patches.
   - East: grey gravel (95,95,100) under irregular red leaf-litter patches (190,45,40), with green islands.
   - North and south: textured grass and sand patches.
   - Hide the horizon edge of the green plane in p7.
5. **Fix the crest proportion and the lantern heights.**
   - Widen the crest notch to about 45% of the crest width (about 5 studs of 11) and deepen it to about 60% of the crest
     height, so it opens as a window down to the arch band.
   - Make the arms about 2.5 studs thick with hooked outer corners.
   - Lower each lantern by about 2 studs. Give the domes 10 gold ribs.
   - Change the glass from (0,216,254) to about (85,140,185), with a bright inner core part.
6. **Turn the gold trims into flat inset bands.**
   - Replace the round tube trims with flat 0.3 x 0.6 stud strips that follow the bevels.
   - Gold Color (200,172,60), Metal, slight reflectance.
   - Recolour the medallion disc to about (190,170,60). Redraw the blades as 8 thin, hooked, near-black (40,45,55) blades,
     each about 1 stud wide at the root and tapering to a curled tip.
7. **Bring the landmarks to ref scale and silhouette.**
   - Raid:
     - Raise the skull tower to about 40 studs above the terrace.
     - Add a pointed gothic arch entry (about 8 wide x 14 tall) with columns and a pediment.
     - Replace the black eggs with 25-stud red spires.
     - Use stone (175,75,65) and add a red PointLight.
   - Expeditions:
     - Build an arch with 2 columns in teal (40,140,140) with pale-teal trim, plus 2 crystal braziers.
     - Replace the dark slab with a ring of 8 rock slabs (radius about 12 studs, about 25 studs up) around a white glow.
   - Story:
     - Make the ring interior black (15,15,20) and scale the ring 1.3x. Add a gold crown on top.
     - Widen the tree trunk about 2.5x, with a root flare, in (130,90,60).
8. **Fix the water and basin.**
   - Move each basin out about 4 studs so it stands in front of the arch.
   - Delete the angled cyan "cascade" slab. Add a narrow translucent water sheet from the upper ledge into the upper bowl,
     plus a ParticleEmitter mist.
   - Water colour (125,188,204), Transparency 0.3.
   - Recolour the basin's lower bands from navy to mid grey (95,100,110).
9. **Add grass and litter on stairs and floor.**
   - South and west flights: grass tufts spilling over 30-50% of step edges, plus floor patches 3-6 studs wide.
   - East flight: red leaf litter.
   - Blue litter on the north flight sides.
   - 6-10 clumps per flight.
10. **Add surface detail to stone.**
    - Darken the step risers to about (95,100,110) and add a bevel nosing.
    - Give the floor a 4-stud tile grout grid (165,170,172) and cracked slab borders around the medallion ring.
    - Change the foreground navy bands to slate (60,65,75).
