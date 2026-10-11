# Review brief, freestyle round 25: Anime Expeditions spawn plaza

You are an independent reviewer; you did not build this. The practice plaza was built **freestyle**: from pictures of the
reference only (no part positions), with an own Blender kit and an own layout. Judge it the way an art lead judges a
rebuild from reference images: silhouette, proportion and layout, colour and material, lighting and mood, and what a
player would notice. Not pixel matching.

## Studios
- REFERENCE (read-only): studio_id `97946bf6-0aa4-48bc-9024-a884610ec79c`. screen_capture only.
- PRACTICE: studio_id `93d2d4f5-c7e7-40ed-bb6f-cd6824f11572`. screen_capture only.
Load `mcp__Roblox_Studio__screen_capture` with ToolSearch. Never run code; never modify anything. Capture each camera 2-3 times
and judge the last frame. Save nothing to the reference; judge from your own captures of both studios.

## Cameras
Reference cameras are in `C:/Users/aroki/Documents/animeexp_practice/cams.json`; the practice place has its plaza centre at
the origin, so practice cameras are the same with x - 3000 and y - 3 (`cams_practice.json`). Review all 12.

## Known gaps (do not just list them; rank them by visual impact)
Not built yet: dense foliage (blue/purple/gold trees, red bushes everywhere), palms at scale, water flow and VFX, the outer
islands/skyline/waterfalls and themed areas in the background, painted textures on meshes, signs.

## Report
Write `C:/Users/aroki/Documents/animeexp_practice/notes/verify25_plaza.md`: per camera a 0-10 score and the differences
(geometry/proportion; colour/material; lighting; missing pieces), then ONE ranked top-10 fix list, each item with a
concrete instruction a builder can act on (what to change, roughly how much: sizes/positions in studs estimated from the
pictures, colours as RGB). End your final message with the per-camera scores, the average, and the top-10.

## Round 25 context
Round 24 scored 8.83 (notes/verify24_plaza.md; eight cameras at 9, p4/p6/p8/c4 at 8.5). Pass 27 (notes/fix27_plaza.md, new kit
ae_kit_r27): stairs rebuilt as shorter rounded blocks with visible dark joints; less saturated leaf colour maps on the north and
north-east trees; the giant tree crown as dark, lobed lumps; three translucent waterfalls and rounded lumps on the north island;
one in three lagoon trees gold; gate side panels, Story ring, Raid brick and fern colours tuned; floor leaf splats removed.
Not done: runner Y width, bollards, Summon/Boss Rush facades, gate crystal basins, Story crest, Raid door, west pools.
Compare against round 24 camera by camera. Captures must be full size: if screen_capture returns a short frame (a Studio panel
open), say so in the report rather than judging blurred frames.
