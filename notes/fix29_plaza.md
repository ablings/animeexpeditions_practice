# Fix pass 29: Anime Expeditions spawn plaza (translucent jets, twisted notch trees, orb in open sky, grounded sky ruins, Story crest, white-gold Summon, purple Boss Rush shrine)

Builder report for `notes/fix_brief29.md`, answering the round-26 review `notes/verify26_plaza.md` (9.04/10).
Main PC, 2026-10-11. Practice studio `93d2d4f5-...`, reference studio `97946bf6-...` (not used: the full-size v26 frames
were enough). **No kit this pass:** everything is Studio-side, built from our own earlier kit pieces and Parts, so no Import 3D
was needed. Time-boxed at about 100 minutes.

## Status by review item

| Item | Status |
|---|---|
| 1 Fountain jets | Done (Studio). The opaque `K_Splash20_water` mushroom is hidden. In its place: a 1.3 x 2.2 translucent column (T 0.45), a dimmed Neon core, a soft translucent cap and froth, a spray ParticleEmitter and a PointLight (range 8). c1 jet (640,400) (99,184,211) -> (135,201,219); the reference (66,120,139) is still darker. |
| 1b Arch notch | Done (Studio). The 3 dark balls, stick trunk and plank are hidden. A twisted tree grows from each notch: 7 tapering cylinder segments on a helix, with 3 own `K_FluffyS_leaf` clumps (2 green (90,150,60), 1 blue (40,90,220)). |
| 2 Sky frame | Done (Studio). Every floating ruin with no ground under its foot (20 of 32: Arcade21, Palace21, K_Rot9, K_Ruin8) gets an own `K_Island_rock` cone (120,125,130) Slate, 1.5x its width and about 0.8x its height, a `K_Island_grass` cap (110,170,70) Grass and 4 leafy lumps. Isl24_4 pale pads (195,220,150) -> (150,178,110). The c3 falls were not added (pass 28's falls stay). |
| 3 Expeditions orb | Done (Studio). Crown tree (bark, crown, rim, Crown25, the 14 Crown27 lobes) moved 40 studs E. Orb ring moved (-8,+4,0), so it sits right of the sign as in the reference. Pass-28 crescents x1.4 on a 1.25x radius, (130,138,155). Outer K_ExpRing8 crescents from Slate (150,155,160), which rendered purple, to SmoothPlastic (185,190,202). The south island band (Isl24_3, the south K_Isl92, the Sky25 south fringe and ruins, and 2 ruins standing on them) is 50 studs lower. |
| 4 Story portal | Done (Studio, Parts). Crest on the ring top: a silver disc 6 studs across, a dark inner disc, a notch and a Neon blue gem. A (40,60,120) inner band behind the ring and 6 blue ivy drips (3.5-6.5 long) with leaves off the outer rim. |
| 5 Summon facade | Done (Studio). Cream (205,178,108) -> warm white (240,228,192). Capitals and cornice are gold Metal (200,165,60), with gold caps on the pilasters. The 4 dark upper arches of K_Summon9 (found by a raycast depth map) now have blue (60,100,200) arched glass in gold frames, with a mullion and a transom. The 5 colonnade windows are enlarged into blue arches in gold frames, and there is a gold medallion with a blue centre on the attic. |
| 6 Boss Rush | Done (Studio). The spiral disc (BossPortal, Rim, Swirl and 8 frame blocks) is hidden. Our pass-28 gothic door is cloned at 1.1x (about 26 tall) in (70,40,90), with a magenta Neon leaf (150,40,140) and a light. It has 2 pillar spires with magenta caps and faceted finials (Boll28_head x3), and a "BOSS RUSH" sign plate (SurfaceGui, Scale size). BossTower retinted (70,40,90). |
| 7-10 | Not attempted (W lagoon, arch bevel and bollard base, foliage accents, props). |

## Captures
- **Final set:** `out/r29/r29_<cam>.png`, all 12 at full size **1284 x 793**, the second frame of `capture_set2.py`. Contact sheet `out/r29/contact.jpg` (v26 reference left, r29 right).
- **Baseline:** pass-28 state in `out/r29w/base/`. Working sets: `out/r29w/a`-`e`.
- **Tools (`out/r29w/`):** `run.sh` (runs `fix/pass29.lua`), `lrun.sh <lua>`, `pick.py <cam> x,y ...` (part under a pixel), `run_cap.sh` (final set), `metrics.py` (saturation table and boxes), `q.lua` (scratch queries).

## Results
**Top-half mean HSV saturation** (same PIL metric as the review; ref = v26 judged frames, base = pass 28 here):

| cam | p1 | p2 | p3 | p4 | p5 | p6 | p7 | p8 | c1 | c2 | c3 | c4 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ref | 82 | 100 | 103 | 109 | 91 | 115 | 88 | 97 | 95 | 110 | 91 | 83 |
| base | 83 | 91 | 90 | 104 | 97 | 98 | 74 | 84 | 103 | 105 | 98 | 93 |
| **r29** | **82** | **93** | **93** | **104** | **95** | **99** | **74** | **86** | **103** | **104** | **97** | **92** |

Mean |rep - ref| is 9.0 -> 8.0. The changes are mostly form: the same accents moved and were re-shaped, so saturation moved
only 1-3 per camera. p6 (-16), p7 (-14) and p8 (-11) are still the large gaps (the W/S canopy and lawn, item 7).

**Boxes (5x5 means):**

| box | ref | base | r29 |
|---|---|---|---|
| c1 jet 640,350 | (66,120,139) at 640,400 | (135,216,232) | (118,175,195) |
| c1 jet 640,400 | (66,120,139) | (99,184,211) | (135,201,219) (the column now reaches this box) |
| c4 tread (a 9.5) | (191,192,189) | (189,196,189) | (189,196,189) unchanged |
| c4 palm | (80,112,180) | (108,143,204) | unchanged (item 9 not done) |
| p1 gold tree | (215,176,77) | (186,151,90) | unchanged |

The p2 crescent box (580,95) no longer lands on a crescent: the ring moved (-8,+4). By eye in `r29_p2_spawn_s.png`, the ring
sits right of the sign with 8 outer and 8 inner crescents around the orb, much as in the reference. Behind it there is still
some pale island band (lowered 50) and the right edge of the crown.

**By eye (contact sheet):**
- p3 (a 9.5): the three hanging ruins now sit on grey rock cones with green caps. The top-left cone is large and dark. Re-check.
- c4 (a 9.5): only the Summon changed: a white-gold face, with gold frames and blue glass in the upper arches. They are small at that range.
- p5 and c2: Boss Rush is now a purple tower and shrine with a magenta glow and a "BOSS RUSH" plate, which shows in c2.

## What I measured / proved
- **Jet ownership:** c1 640,350 / 640,400 = `Pass20.K_Splash20_water` (120,205,235) T 0.15 at (23,7,-23). The notch balls are `Pass22.Arch22.NotchPod22` (Ball parts). The stick and plank are `NotchTrunk22` / `NotchBranch22`. The notch floor sits right above each jet (y 9).
- **Jet colour:** the first jet (T 0.4 column, Neon core T 0.25, light brightness 1.2) read (236,254,254) at c1 640,400: the Neon core owned the box. Core T 0.8 and light 0.5 brought it to (135,201,219). The reference (66,120,139) is a dark teal: our column is lit by the sun and seen against a lit tunnel.
- **Orb background (p2 picks):** behind the orb were `Tree24_bark` (15,46,142), `Crown25` and the `Crown27` lobes; above them `Isl24_3` pads (y 216) and `K_Isl92` (y 120). The dark purple shards around the orb were the **outer** `K_ExpRing8_stone` crescents (Slate), not the pass-28 Cres28. After the move the ring reads as a crescent ring around the orb.
- **Ruins on islands:** a ruin is "grounded" if a ray from its bounding-box foot (+3, down 9) hits a visible part. 12 of 32 were grounded. Lowering the south band un-grounded 2 ruins (islands 20 -> 22). Fixed by moving the riders with their island: a raycast against the band models only, made before the move.
- **Summon openings:** a raycast depth map of K_Summon9 (x -26..26, y 29..42, from z -165) found 4 arched recesses (x -20/-10/10/20, 3-4 wide, about 5 deep, top y 35) on a wall face at z -183. Our first windows went on `Colonnade17` (y 23), where the bunting and the sign hide them. The visible dark arches belong to the box behind.
- **Boss Rush:** `Raid11.BossPortal` Neon (95,35,160) disc 19.8 across at (139.8,20.4,-54), facing -x; ground y 8.7; `BossTower` 21.6 x 43 x 21.6 behind it. The pass-28 Raid door's foot is at y 8.6, so the clone needs only a translation and a 1.1x scale about the foot.

## Built (method)
`fix/pass29.lua`: idempotent and runs after pass 28. Every touched part keeps its old value in a P29* attribute (Col/Mat, Size, CF, Hidden), and the attributes are restored first. New pieces go in `Plaza.Pass29`. It merges `Workspace.ae_kit_r29` if one is ever imported, removing **every** same-named old kit piece (the pass-28 lesson). Blocks:
- **JET29:** for each `K_Splash20_water`, raycast down from y 8.6 (excluding the water) for the pedestal top. Then a cylinder column, a Neon core, a cap ball and a froth ball, an Attachment with a ParticleEmitter (Rate 30, life 0.6-1, speed 3-5, spread 25, gravity -14, light emission 0.4) and a PointLight.
- **NOTCH29:** the trunk is a helix march, `p + (cos a, i*0.95, sin a)*r + out*u^2*1.6`, with 75 degrees per segment. Each segment is a cylinder from `CFrame.lookAt(prev, next)`, rotated 90 degrees about Y (the cylinder axis is X), tapering 0.65 -> 0.3. 3 leaf clumps sit round the top.
- **ORB29:** `moveTo` with a P29CF base for the crown parts, the ring model and the band. The crescents are rescaled about the orb centre.
- **SKY29:** for each ungrounded ruin: `kp()` clones a kit MeshPart with a per-axis scale about the kit origin (`cf * CFrame.new(k.Position*s)`), removes its SurfaceAppearance and sets the colour. Rock is (W/74, H/32, W/74) and the cap is (W/73, 1, W/73), with a yaw that varies per island and 4 lumps on a 0.42 W ring.
- **STORY29:** Parts only (cylinders facing +x).
- **SUMMON29:** an HSV filter recolours the cream colonnade parts (s < 0.45, v > 0.7, hue 0.05-0.2). Windows are a rectangle plus a half-buried cylinder arch, each in front of a gold rectangle and cylinder 0.4 larger, with a gold mullion and transom.
- **BOSS29:** clones the `Goth28_*` parts with `CFrame.new(at + (p - foot)*k) * rotation` and `Size*k`.
- `fix/build_plaza.lua` IMPORTS now lists `ae_kit_r29` / `K_Scale29_stone` too (nothing to import this pass).

## Lessons (for the workflow vault)
1. **Neon owns the pixel.** A 0.3-stud Neon core inside a translucent column made the whole jet read white at range. When the target is a dark, glowing water read, keep the core faint (T 0.8) and the light weak. The glow should come from the translucency, not the core.
2. **Check which ring you are looking at.** The "thin purple crescents" were the old outer ring in Slate, which renders dark under shade; the pass-28 crescents were hidden behind them. Pick before retinting.
3. **Moving the ground moves what stands on it.** Lowering the island band left 2 ruins hanging. Collect riders with a raycast against the moved set *before* the move and move them together.
4. **Map a mesh facade with a raycast depth grid.** One query (rays every stud, depth printed as digits) shows where a mesh's openings are, without opening the mesh. It also showed that our first windows had gone on the wrong layer.
5. **Reuse your own kit at a new scale for a new landmark.** The Raid door's gothic arch became the Boss Rush shrine (clone, 1.1x about the foot, recolour, Neon leaf, spires). With no new kit, there was no import round-trip.
6. **Ground every floating object.** A generic rule (ray from the bounding-box foot; if nothing, add a rock cone 1.5x wide plus a cap and lumps) fixed 20 ruins in one block. The width and height ratios came from the review, read from the pictures.

## Objects built (for 5 Object Recipes)
- **Translucent fountain jet:** a cylinder column (1.3 x 2.2, T 0.45, (80,150,180)), a Neon core 0.3 (T 0.8), a cap ball (2.6 x 1.6, T 0.7) and a froth ball (1.8 x 1.3, T 0.6), a spray ParticleEmitter on an Attachment at the cap, and a PointLight (range 8, brightness 0.5).
- **Twisted notch tree:** 7 cylinder segments on a helix (r 0.35, 75 degrees per step, lean out by u^2 x 1.6), tapering 0.65 -> 0.3, in Wood (96,72,52), with 3 K_FluffyS_leaf clumps at 0.3x (green, blue, green).
- **Grounded sky ruin:** under each floating ruin, K_Island_rock scaled to 1.5 W x 0.8 H, a K_Island_grass cap and 4 small leaf lumps on the rim.
- **Horseshoe crest (Parts):** a silver cylinder disc 6 across, a dark inner disc 3.6, a notch block and a Neon gem ball on the top of a portal ring. Ivy drips are thin Grass parts with 3 leaf balls each.
- **Arched window in a gold frame (Parts):** a glass rectangle plus a cylinder arch, a gold rectangle plus a cylinder 0.4-0.8 larger behind it, a gold mullion and transom.
- **Gothic shrine from a door kit:** clone the door's stone, leaf and boss at 1.1x about the foot, purple stone, a magenta Neon leaf and a light, 2 pillar spires with Neon caps and faceted finials, and a sign plate with a SurfaceGui label.

## State at the end
- `#workspace.Plaza:GetDescendants()` = **17942** (pass 28: 17647). Workspace holds only Camera, Terrain, SpawnLocation and Plaza.
- Nothing was saved or committed. No kit was exported, so `ae_kit.blend` is unchanged and was not touched.
- Technology, post effects and Atmosphere are unchanged; Haze was not tested. `fix_lighting.lua` was not re-run (no lighting change).
- **How to rebuild:** on the pass-28 build, run `sh out/r29w/run.sh`. It is idempotent.

## Reference use
- No capture of the reference studio: the round-26 frames in `out/verify26/` were used for every target. No execute_luau in the reference, no position reads. `ae_reference.blend` was not opened. No computer use. Own meshes and Parts only.

## Next
- Jet colour is still about 60 levels too light against the reference's dark teal. Try a darker column (50,110,135) or a Glass/ForceField material, with the cap smaller.
- W lagoon and lawn (item 7), arch bevel and bollard base (item 8), foliage accents (item 9: p1 gold tree (186,151,90) vs (215,176,77), palms 30 light), props (item 10).
- A meshed horseshoe crest and Boss Rush spires (kit) would read better than Parts close up.
- The Summon's upper arches are small at c4 range; the reference face has more, larger blue windows across its width.
