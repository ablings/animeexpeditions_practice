# Fix pass 17: Anime Expeditions spawn plaza (Raid by measurement, wing flanks, Summon avenue, east ground)

Builder report for `notes/fix_brief17.md`, answering the round-14 review `notes/verify14_plaza.md` (7.50/10).
Items 1-4 are done; item 7 (S beach) and items 5, 6, 8-10 were not attempted (see "Not done").

**Captures**
- Final set: `out/r17/r17_<cam>.png` (12 cameras, 1452x793, `capture_set2.py`, second frame kept). Contact sheet `out/r17w/contact.jpg`.
- Raid measurement frames: `out/r17w/s1..s23(_a).png`, final check `fin2(_a).png`. c1 flank frames `c1t1..c1t4(_a).png`.
- Reference study (screen_capture only, live reference): `out/refA17_1.png` (high oblique of the NE corner), `out/refB17_1.png`
  (side view of the NE arch). Practice equivalents `out/repA17_1.png`, `out/repB17_1.png`.

**Rules kept:** pictures only (no positions read from the reference, `ae_reference.blend` not opened); own geometry only; no computer
use; place not saved, nothing committed; `ae_kit.blend` saved.

**How to rebuild** (on a pass-16 build, with `ae_kit_r17` imported):
- `python cmd/runlua.py fix/pass17.lua <studio>` then `python mcpcli.py call execute_luau cmd/pass17.json`. It merges the r17 kit into
  Kit and runs blocks `--RAID`, `--SUMMON`, `--EAST`, `--KIT17`. Idempotent: rebuilds `Plaza.Pass17`; hidden pieces get `P17Hidden`
  (`P17T` = old transparency), recoloured pieces keep `P17Col`/`P17Mat`, lights `P17En`/`P17B`, moved models `P17CF0`/`P17Sc0`.
- Run it AFTER pass 16 (it re-aims pass-16 uplights, rescales the pass-16 palm, re-styles the pass-16 haze emitter).
- `fix/build_plaza.lua` has r17 in `IMPORTS`; the pass-17 block is NOT pasted into it yet (run `fix/pass17.lua` after the rebuild).
- Measurement tools: `out/r17w/p3cap.sh <tag>` (two p3 frames), `out/r17w/p3box.py <png>...` (the boxes below),
  `out/r17w/cap.sh <cam> <tag>`, `out/r17w/pick.py <cam> x,y ...` (raycast the practice place through a pixel: which part is there).

## 1. Raid by measurement (p3)

**Boxes** (5x5 means, 1452x793 practice frame; targets are the lead's reference values; stoneB uses the reference's own sample at the
same place, (780,310) on `v14_p3_spawn_e_ref.jpg`, because that wall is in shade in both):

| box | pixel | target |
|---|---|---|
| stoneA, facade left of the door (K_Gothic stone, door hood) | (670,260) | (95,45,55) |
| stoneB, wall right of the door, shaded face (K_Spire) | (790,330) | (82,29,44) |
| rim, the door arch moulding (first try (690,290) was on the hood, moved onto the rim the reference box sits on) | (700,315) | (200,70,65) |
| skull forehead | (725,35) | (125,75,72) |
| tower, skull pillar under the skull | (690,150) | (125,75,72) |
| hazeL / hazeR (first tries (605,130)/(860,130) were above the band, moved into it) | (620,165) / (830,160) | (200,60,50) |

**Steps** (one change each, p3 captured twice; values from the kept frame):

| step | change | stoneA | stoneB | rim | skull | tower | haze L / R |
|---|---|---|---|---|---|---|---|
| base | pass 16 | (182,80,83) | (73,14,22) | (121,27,38)* | (242,150,137) | (180,67,70) | sky / mauve |
| s1 | stone base (88,47,56) all facade stone, trim, domes | (87,47,62) OK | (38,13,23) | (47,17,29)* | same | (158,68,74) | |
| s2/s3 | skull bone (102,56,53) -> (82,49,43) | | | | (156,86,89) -> (127,80,80) OK | | |
| s4 | tower (skull pillar + gable) (119,68,59) | | | | | (159,80,73): R did not move | |
| s5 | RaidBeam11 PointLight off | no change: put back on | | | | (157,80,74) | |
| d2 | diagnostic: pillar painted (0,255,0) | | | | | (108,147,59): ~100 of R is added light | |
| s6/s7 | pass-12 RaidSmoke12 PointLight (150,86,0) 0.6 -> 0.3 -> 0.1 | | | | | (141,76,71) -> (129,74,69) OK | |
| s8 | uplights to x 154, aim (159,40), b 3 (grazing) | | | (43,17,30)* | | | |
| s9/s10 | uplights x 147, aim (157,32), angle 35, b 4 -> 12 | | | (212,24,36) | | | |
| s11/s12 | uplight colour (255,60,50) -> (255,120,100) -> (255,195,150) | | | (211,43,51) -> (207,82,74) OK | | | |
| s13/s14 | fill PointLights at (150,22,+-16), r 14, b 1.5, (255,120,110) -> (255,210,220) | | (85,16,25) -> (85,24,39) OK | | | | |
| s15 | haze colour (225,40,20) | | | | | | core (221,17,2), thin (206,72,75) |
| s16 | haze (212,58,42) | | | | | | (153,125,158) flicker / (201,64,62) |
| s17 | haze rate 10 -> 20 | | | | | | (219,26,8) / (214,46,33) |
| s18/s19 | haze (205,95,80) -> (200,86,72) | | | | | | (203,66,51) / (200,60,42) OK |
| s21 | haze box 24x52x104 at y68 -> 24x84x124 at y54 (down to the stair top), rate 34 | | | | | | (202,64,49) / (209,61,41) |
| s22/s23 | 4 recessed arch bands; uplights b 12 -> 9 | | | (227,99,90) -> (212,84,80) | | | |

(* = the old rim box at (690,290).)

**Final** (`fin2.png`, after every other pass-17 change; both frames): stoneA (84,45,60), stoneB (84,25,39), rim (213,86,81),
skull (127,80,81), tower (132,74,69), haze (208,61,41) / (210,60,38). All within 12 except the rim at 16 (G channel).
One regression caught in the final check: a new E-zone red palm at (116,-8) stood in front of the door (rim (168,69,68)); moved to
(120,-60).

**Other Raid pieces:** the upright red palm (pass-16 RaidPalm16) is scaled 1.7 (about 39 tall) and stands at (139,-27), left of the
door in front of the facade, crown above the sign line. 4 arch bands follow the pass-16 pointed arch offset by 1.3/2.4/3.5/4.6,
alternating dark recess (40,16,22) at x 156.9 and proud lit stone (105,52,60) at x 156.3-156.4.

## 2. Wing flanks (kit r17, `--KIT17`)

**What the pictures showed** (`refA17`, `refB17` vs `repA17`, `repB17`): the reference has no tall wall along the stair sides. The
dark "flank" is the arch leg carried FORWARD toward the plaza: a scroll that falls from the arch shoulder to about 2 above the floor
beside the basin, dark slate sides with recessed bands, pale top with gold edges. The practice wing ran the other way (from the
arch shoulder outward along the stair to the terrace) as a pale ramp.

- `K_Hero17_stone/gold`: the pass-10 hero meshes with the 8 shoulder-wing prisms (and their gold strips) deleted. They replace
  `K_Hero_stone/gold` (properties and children copied; old ones hidden).
- `K_Flank17_slate/groove/gold`: 8 flanks (u 7.6..10 each side of each arch, w 33.3 -> 25), top y = 2 + 6 t^1.7.
- Studio colours (c1, 5x5 on the outer side faces (120,730) and (1340,730)): slate (40,46,48) -> (41,54,57)/(35,46,50);
  (50,52,54) -> (47,55,58)/(51,59,62) against (52,61,64). Top: the kit's "gold" top slab read as a big gold ramp, so it is pale
  stone (116,124,128) (rendered (190,202,202) against the reference top (170,183,188)), and gold edge lines (Parts, 0.32 square,
  12 segments per edge on the same t^1.7 profile) run along both top edges. Groove (22,26,28) Slate.

## 3. Summon avenue (`--SUMMON`)
- 19 canopy/horizon clumps (`K_Soft15K`/`K_Soft15W` in Trees13 and HorizonRing14) with centre |x| < 20, z -55..-185 hidden;
  palms and cypresses stay.
- Colonnade from Parts at z -177.5, in front of the Summon hall: 44 wide, cream (235,210,150), 5 arched openings (dark rectangle +
  Cylinder half-disc head, (70,52,45)), piers with gold capitals and keystones, cornice and entablature with gold bands, an upper
  row of 5 small arched windows, an attic, a drum and a 10-stud dome with a gold band and finial. Gold statue (robe, body, head,
  raised arm, staff) on a plinth in the middle arch. The "Summon" sign (scaled 0.7) sits over the middle arch.
- Bunting: 3 sagging lines of 22 wedge pennants (red, white, blue, yellow) at z -72/-98/-124 (the first try at -140 crossed the sign).
  The stalls and umbrellas from earlier passes line the avenue.
- Gold pineapple (Ball + Sphere mesh 4.6x5.4, 3 dark rings, 7 leaves) at (-24,-52) by the W pavilion at the N stair top.

## 4. East ground (`--EAST`, `--KIT17`)
- The pass-12 red dot litter (10 `Red` folders, about 2770 dots) is hidden.
- 458 leaf splats (`K_Splat17`: lobed core (187,53,54) over a toothed fringe (130,30,35), 4.6 across x0.8-1.3) on a 4-stud jittered
  grid over x 50..138, |z| < 88, cover 30% at x 50 rising to 60% at x 135, only on flat hits below y 12 that are not stairs, hero or
  glass. The gaps are the green/grey holes.
- 3 gravel paths (Pebble (110,110,105), 10 wobbling 4-stud segments each) and 4 dark-red palms (K_Palm6A/B, 1.1-1.4).

## Not done
- Item 5 (S side shard ring, gate, palms), 6 (grass style), 7 (S beach), 8 (bollard height, flat medallion studs), 9 (c1 splat swap,
  splash, crystal pods), 10 (Story trunk, falls, aqueduct).
- The flanks are 2-3 studs longer than the reference's (they reach w 25; the reference ends about at the basin front, w ~27.5); in
  the close c1 view they read large. Shortening needs a re-export (change `W0` in `build_flank17`).
- The rim box sits at 16 on G; the reference haze also wraps in front of the side towers (flame-like), the practice band is behind.
- `fix/build_plaza.lua` does not carry the pass-17 block yet.

## Lessons (for the workflow vault)
1. **Treat colour as a measurement loop, one variable per capture.** Fix the sample boxes first, write them down, and change one
   thing (a base colour, then one light) per capture pair. Four rounds of guessing swung the Raid; this loop converged in about 20
   captures and every step is explainable.
2. **When a channel will not move with the base colour, look for a light.** Painting the part pure green showed ~100 of red was
   added light; a raycast-free search for enabled lights near the box found a forgotten pass-12 PointLight. Diagnostic colours
   (pure green) are the fastest way to separate material from light.
3. **Check what is under a sample box before tuning it.** Cast a ray through the pixel (`pick.py`), or look at a 2x crop with the box
   drawn. Two of the first box positions were on the wrong surface (the hood, empty sky above the haze).
4. **Grazing lights must not be parallel to the face.** A SpotLight 3 in front of a wall aimed straight up lit nothing; 10 in front,
   aimed at the rim height with a narrow cone, lit the arch mouldings. Then tune the light's colour, not just its brightness: the
   reference rims are warm pink, so the light colour carries green and blue.
5. **Post grading saturates dense particles.** A dense haze of (212,58,42) rendered (219,26,8); the emitter colour must be
   desaturated toward grey to land on the target. Density and colour are separate knobs: first make the band dense enough that the
   sky does not flicker through, then solve the colour.
6. **Every new prop near a sightline can break an earlier measurement.** Re-run the measurement after the whole pass, not only after
   the step: a palm placed for the E ground covered the Raid door.
7. **Read a feature's direction from a side view before modelling it.** The "wing" was a scroll running forward from the arch, not a
   ramp along the stairs; one oblique and one side capture of the reference settled it.
8. **Cut a mesh piece out of a merged hero by a vertex test,** not by rebuilding: copy the mesh, delete faces whose every vertex lies
   inside the unwanted piece's box (mirrored with abs()), and swap the copy in Studio with the old part's properties.
9. **A "gold rim" is an edge, not a slab.** A gold cap as wide as the wall reads as a gold ramp from a low camera; pale top + thin gold
   edge lines matches the reference.

## Objects built (for 5 Object Recipes)

### Scroll flank (`tools/ae_kit.py`: `build_flank17`, `sweep17`, `flank_top17`)
- `sweep17(bm, ws, u0, u1, yb(w), yt(w), mirror)`: a rectangle in (u, y) swept along the corner diagonal w (plaza point
  P(u,y,w) = ((w+u)/sqrt2, y, (u-w)/sqrt2)), ends capped, normals recalculated; mirrored (+-x, +-z) for the 4 corners.
- Body u 7.6..10 (and mirrored -u), w 25..33.3, from y 0 to top y = 2 + 6 t^1.7 (t = (w-25)/8.3): 19 sections.
- Top slab 0.15 wider each side, 0.3 thick on the top line; 2 groove strips per face 0.06 thick, 0.5 tall, 1.15 and 2.35 below the top.
- Studio: slate (50,52,54) Slate, grooves (22,26,28), top (116,124,128), gold edge Parts along both top edges.

### Hero without wings (`build_hero17`)
- Copy `K_Hero_stone/gold`; delete faces with every vertex in |x| 16.9..19.7, |z| 31..48.05, y >= 6 (or x/z swapped); gold: x
  16.8..17.1, y >= 6.62 (so the stair stringers, which stop at y 6.6, stay). 96 faces each.

### Leaf splat card (`build_splat17`)
- 48-point lobed core r = 1.55 + 0.35 sin(3a + 0.7) +- 0.15, 0.06 above a fringe disc r = core + 0.75 / 0.25 alternating + up to 0.35;
  each disc double-sided (two fans). Studio core (187,53,54), fringe (130,30,35), SmoothPlastic, no shadow, no collision.

### Colonnade facade (Studio Parts, `--SUMMON`)
- Back wall 44 x 26 x 2; per bay (8.8): dark opening (bay-2.6) x 8.5 + Cylinder half-disc head of the same diameter, a small
  arched window above, a gold keystone; 6 piers 1.8 x 13.4 with gold capitals, pilasters above; cornice + gold band at 15, entablature
  + gold band at 22; attic 14 wide; drum (Cylinder 5 x 10) + Ball dome 10 + gold band + finial.

### Raid arch bands and grazing lights (Studio)
- Bands: the pointed arch (legs, then arcs of radius 10.14 + d centred 3.54 past the axis, up to the apex where z = 0), Parts built
  with `CFrame.fromMatrix(mid, xAxis, xAxis:Cross(dir))` so a vertical segment does not break `lookAt`.
- Lights: 4 SpotLights at (147, ground + 0.8, -22/-9/9/22) aimed at (157, 32, z), angle 35, range 32, brightness 9, (255,195,150).

## Files
- `fix/pass17.lua` (new); `fix/build_plaza.lua` (r17 in `IMPORTS`).
- `tools/ae_kit.py`: pass-17 section (`build_all17`, `export_r17`, `build_flank17`, `build_hero17`, `build_splat17`, `build_scale17`).
- `kit/own/ae_kit_r17.fbx`: 8 meshes including `K_Scale17_stone`. Imported by the lead. `ae_kit.blend` saved.
- `out/r17/`, `out/r17w/`.
- Practice place: `#workspace.Plaza:GetDescendants()` = 15041 at the end. Selection cleared. Not saved.
