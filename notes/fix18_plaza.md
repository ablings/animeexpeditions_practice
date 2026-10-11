# Fix pass 18: Anime Expeditions spawn plaza (arch sweep band, Raid re-measured, big red palm, east ground)

Builder report for `notes/fix_brief18.md`, answering the round-15 review `notes/verify15_plaza.md` (7.58/10).
Items 1-4 are done. Items 5-10 were not attempted (see "Not done").

**Captures**
- Final set: `out/r18/r18_<cam>.png` (12 cameras, `capture_set2.py`, second frame kept). Contact sheet: `out/r18w/contact.jpg`.
- Raid measurement frames: `out/r18w/s1..s10(_a).png`. The final check after every other change is `fin(_a).png`, and the
  crops with the boxes drawn are `crop_base.png` and `crop_s7.png`.
- Flank checks: `c1a`, `c2a`, `c3b`, `c3c` and `p6a` (each with `_a`). The side-by-sides with the v15 reference frames are
  `cmp_c2a.png` and `cmp_p6a.png`, and the E-ground top view is `cmp_p8b/c.png`.
- Tools: `out/r18w/step.sh <tag>` runs pass18.lua, captures p3 twice and prints the boxes. `out/r18w/box.py <cam> <png>...`
  samples the boxes, and it takes its targets from `out/verify15/v15_<cam>_ref.jpg` itself, never from a typed table.
  `out/r18w/cap.sh <cam> <tag>` captures any camera twice, and `out/r18w/crop.py` makes box crops.

**Rules kept:**
- I used the pictures only. No positions were read from the reference, and the reference studio got screen_capture only.
- Own geometry only. No computer use.
- The place is not saved and nothing is committed. `ae_kit.blend` is saved.

**How to rebuild** (on a pass-17 build with `ae_kit_r18` imported):
- Run `python cmd/runlua.py fix/pass18.lua <studio>`, then `python mcpcli.py call execute_luau cmd/pass18.json`.
- It merges the r18 kit into Kit and runs the blocks `--RAID`, `--RAIDFX`, `--PALM`, `--EAST` and `--KIT18`.
- It is idempotent: it rebuilds `Plaza.Pass18`.
  - Hidden pieces get `P18Hidden` (`P18T` = old transparency).
  - Recoloured pieces keep `P18Col`/`P18Mat`.
  - Lights keep `P18En`/`P18B`.
  - Splat cards keep `P18Size0`.
- Run it AFTER pass 17. `fix/build_plaza.lua` has r18 in `IMPORTS`, but the pass-18 block is not pasted into it.

## 1. Wing flanks -> the arch's own outer sweep band (kit r18, `--KIT18`)
**What the pictures showed:**
- In the frontal reference frames (c1, c3) the "flank" is the arch's own outer horseshoe band. It is about 3 studs thick and
  runs from the crest arms outward and down to the floor beside the stair stringer, with 2 dark grooves following the curve.
- Nothing projects forward toward the plaza.
- Pass 17 had read the refB17 side view as a forward scroll. In the side view that band's foreshortened outer face looks like
  a ramp.

**Reference samples** (5x5, v15 frames):
- band front face (lit): (162,164,150) in c3 (520,520) and (169,179,186) in c3 (930,520)
- grooves and shade: (57,64,72) in c3 (545,560), and (16-37, 26-46, 38-55) in c2
- slate side faces: (61-67,67-81,69-97) in c1

**Built:**
- `K_Sweep18_stone/groove/gold` (`build_sweep18`). Each side of each arch is a quarter ellipse centred (u ±5.7, y 4.5), from
  the top at u ±5.7 down to u ±(10..13) at y 4.5, then a straight leg to the floor.
- 5 radial rings: stone 0-0.28, groove 0.28-0.38, stone 0.38-0.62, groove 0.62-0.72, stone 0.72-1.
- The stone rings run from w 33.0 to 36.5. The grooves are recessed 0.45.
- A gold tube (r 0.22) runs along the outer front edge only. Mirrored to the 4 corners.

**Studio:**
- The pass-17 `K_Flank17_*` and `FlankGold17` are hidden. Their front ends were the "black plinth blocks".
- Band stone is (135,137,130), material as the hero stone. With the hero stone colour (101,107,111) it rendered
  (100,110,117) in c3; at (135,137,130) it renders (132-146,137-146,130-140).
- Grooves are (30,36,44) Slate. Gold uses the hero gold colour and material.

**Checked on c1, c2, c3 and p6:** no pale slide is left, and the arch reads as one grooved horseshoe whose legs meet the stair
stringers. The small gold stubs at the band feet are the existing stair stringer ends, which is where the reference's
balustrade starts.

## 2. Raid by measurement (p3, `--RAID`, `--RAIDFX`)
**Targets** were sampled by `box.py` from `v15_p3_spawn_e_ref.jpg` and match the lead's corrected table. stoneA was skipped.
One change per capture pair, except s2, where the skull and the pillar changed together: they are separate parts with their
own boxes.

| step | change | skull | tower | rim | hazeL / R | shadeR | lowL | lowR |
|---|---|---|---|---|---|---|---|---|
| target | | (230,152,130) | (150,86,72) | (154,80,76) | (147,76,67) / (150,80,71) | (78,24,37) | (125,61,72) | (137,44,58) |
| base | pass 17 | (127,80,81) | (132,74,69) | (213,86,81) | (198,69,57) / (206,75,60) | (84,25,39) | (174,76,91) | (139,54,71) |
| s1 | skull bone (82,49,43) -> (150,93,72) | (210,129,106) | | | | | | |
| s2 | bone (165,110,90); pillar (119,68,59) -> (136,79,61) | (222,148,127) | (139,77,69) | | | | | |
| s3 | pass-17 uplights b 9 -> 5 | | | (180,64,67) | | | (164,70,88) | |
| s4 | uplights b 3.5 | | | (163,55,62) | | | (160,69,86): did not move | |
| s5 | left RaidFill17 (z -16) b 1.5 -> 0.6 (pick.py: lowL is K_Spire stone at z -22.5, inside that fill's range) | | | (156,51,56) | | | (114,39,54) | |
| s6 | left fill 0.9 | | | (158,52,58) | | | (132,50,65) | |
| s7 | raised arch bands (105,52,60) -> (108,74,70); haze (200,86,72) -> (150,100,95) | | | (159,70,63) | (150,87,85) / (159,85,78) | | | |
| s8 | + fire line, + 3 haze emitters on the facade sides | | (138,63,54) | | | (102,28,33) | (142,47,45) | |
| s9 | side haze off (it was brown smog over the facade) | | (139,77,69) | | (156,88,82) / (148,93,95): sky shows | (83,25,40) | (139,60,78) | |
| s10 | haze rate 34 -> 44 | | | | (152,81,75) / (150,80,74) | | | |

**Final** (`fin.png`, after all pass-18 changes):
- skull (222,148,127), tower (139,77,69), rim (161,73,66)
- haze (151,80,74) / (150,80,75)
- shadeR (83,25,40), lowL (139,60,78), lowR (136,59,73)

Every box is within 15 of the reference.

**Also built:**
- A fire line: 19 flame emitters (built-in `fire_main` particle texture, (255,90,50) -> (200,20,20), size 1.2 -> 0.4,
  lifetime 0.5-0.8 s, 14/s) along the facade base, every 3 studs over z -27..27, plus 3 red PointLights (range 9, b 1.2).
- The skull got lighter through its base colour. I did not add the roof-line SpotLights.
- The "haze wraps the towers" request conflicts with the boxes: the side emitters spoil 3 boxes. They are left in the file
  (`FX.side = false`) for a reviewer to judge.

## 3. Big red palm (`--PALM`)
- The reference palm stands at p3 x≈530 and c3 x≈980.
- I cast practice camera rays through those pixels. They cross along a line where p3 x≈510 holds for every depth, so the two
  frames agree.
- The crown heights (p3 y≈130, c3 y≈270-300) fix the depth at about x 100, z -41.5, with the crown at y≈52-55.
- `RaidPalm16` is now at (100,-41.5), scaled 2.0 from the pass-16 size, about 46 tall (top y 52.5).
- That is taller than the review's "~25". The two frames, not the prose, set it. In p3 the crown now covers x 400-620 at
  y 140-200 (reference 440-620 at y 100-160). In c3 it stands at x≈970 in front of the skull tower edge.

## 4. East ground (`--EAST`)
- The pass-17 splat cards are scaled 1.5x, so neighbours now overlap.
- Colour: (185,55,55) rendered a red mean of (223,64,70) on p8 against the reference's (191,73,59). Scaled per channel, the
  core is (160,62,46) and the rim (112,34,29), rendering (210,71,61).
- The reference p8 shows a wide grey gravel lane on the E axis from the stairs to the Raid forecourt. Cards with
  |z| < 8 + 3 sin(x/9) and x > 48 are hidden to open it.
- 31 splat pairs on the E stair treads, at 50% of a 1.5 x 3 grid.
- 14 green grass holes (3 stacked Cylinder discs, 3-6 across, (105,160,70) / (130,185,85)).

## Not done
- Item 5 (S side), 6 (corner blue trees), 7 (grass and lawn strips), 8 (bollards and studs), 9 (skyline), 10 (close-up props).
- The band's legs sit about 2-3 studs inside the bottom of each stair flight's outer edge, because the arch is diagonal and
  the flights are axis-aligned. They act as a balustrade there.
- The reference haze glows saturated red right round the skull silhouette. The practice now has a neutral warm band that
  matches the boxes but does not glow.
- `fix/build_plaza.lua` does not carry the pass-17 or pass-18 blocks yet.

## Lessons (for the workflow vault)
1. **Never take a colour target from prose.** The pass-17 skull target came from a review sentence and was 100 levels too
   dark. The box tool now reads its targets from the reference frame on every run, so a typed number cannot drift.
2. **Locate a feature in 3D from two frames.** Cast a ray from each reference camera through the pixel where the feature
   stands. Where the rays cross gives the position, and the screen height in each frame gives the height. This put the palm in
   10 minutes and overruled a size estimate that was half the true one.
3. **Read a shape in the frontal view before the oblique one.** A side view foreshortens an arch's outer band into what looks
   like a forward ramp. Pass 17 built a ramp from it; c1 and c3 straight on showed the band curving outward in the arch's own
   plane.
4. **When a box will not move with a light, pick the surface and list the lights in range.** lowL ignored the uplights
   because it was lit by a fill light 6 studs away, put in for a different box (shadeR) on the other side of the door.
5. **More haze is not more glow.** Extra translucent emitters in front of a facade turn it to brown smog and shift every box
   behind them. Keep haze where the boxes are over sky, and get glow from emissive parts or lights instead.
6. **Match hue by averaging a whole region.** Sample a large region's mean red with a mask in both frames, then scale the part
   colour per channel. One step was enough for the E-ground splats.

## Objects built (for 5 Object Recipes)

### Arch outer sweep band (`tools/ae_kit.py`: `sweep_outline18`, `build_sweep18`)
- Outline at radial fraction f, side s: a quarter ellipse centred (s*5.7, 4.5) with radii (4.3 + 3f, 4.5 + 3f), sampled
  from the top (k = 0) to the side (k = 16): (s*(5.7 + a sin θ), 4.5 + b cos θ). Then 3 points straight down to y 0.
- `arch_band` between outlines f0 and f1, from w0 to 36.5. The rings are stone 0-0.28 / 0.38-0.62 / 0.72-1 (front at w 33.0)
  and groove 0.28-0.38 / 0.62-0.72 (front recessed 0.45).
- `tube_along` gold r 0.22 on the f = 1 outline at w 32.98. `merge_objs(..., mirror4=True)`.
- Studio: stone (135,137,130), grooves (30,36,44) Slate, gold as the hero gold.

### Ember fire line (Studio)
- An invisible 2.6 x 0.4 x 2.6 Part every 3 studs along the facade foot.
- Each holds a ParticleEmitter: built-in `fire_main` texture, Top direction, speed 1.5-2.5, lifetime 0.5-0.8, size 1.2 -> 0.4,
  transparency 0.35 -> 1, LightEmission 0.8, rate 14.
- 3 low red PointLights (range 9) carry the glow onto the stone.

### Grass hole (Studio)
- 3 stacked flat Cylinder discs (0.12 thick, 3-6 across, each 22% smaller), (105,160,70) under (130,185,85), each jittered
  0.8 off centre so the edge is ragged. No collision, no shadow.

## Files
- `fix/pass18.lua` (new). `fix/build_plaza.lua` (r18 added to `IMPORTS`).
- `tools/ae_kit.py`: pass-18 section (`sweep_outline18`, `build_sweep18`, `build_scale18`, `build_all18`, `export_r18`).
- `kit/own/ae_kit_r18.fbx`: 4 meshes including `K_Scale18_stone`. Imported by the lead. `ae_kit.blend` saved.
- `out/r18/`, `out/r18w/`.
