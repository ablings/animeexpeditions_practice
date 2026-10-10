# animeexpeditions_practice: shared instructions for every Claude session

Third map of Edward's level-design training. The goal is to learn **freestyle mesh building** (from images, without
coordinates) on a stylised fantasy sky-city lobby, because Edward's own game will be built that way.
Vault: `Documents/ObsidianVault/wiki/building-practice/anime-expeditions/` (practice log, How Anime Expeditions Is Built)
and the craft in `wiki/roblox-build-workflow/` (Construction Styles, 6 Blender Modelling Method "Freestyle").

## Hard rules
- Practice only. Never publish. The reference `ref/place_84515722934860_Anime_Expeditions.rbxl` is read-only: never write
  properties, create/destroy instances or save in it. `ref/` is gitignored; never commit or push reference files or exports.
- Never copy its meshes, textures, images, names or code into the practice build. The practice build is made from own
  geometry and own textures, modelled freestyle from images.
- Export copies only via `tools/strip_texturepacks.py` (blanks every TexturePack), opened, chunked (`tools/chunk.lua`),
  exported, never saved. `kit/ref_export/` is gitignored.
- File > Save to File for the practice place (never Ctrl+S). Lighting.Technology: read/set offline with tools/set_technology.py.
- After every review round: send Edward a comparison sheet; add new constructions to `5 Object Recipes`.
- Never send Delete, Backspace or Ctrl+A to Studio by computer use. Studio routes them to the Explorer when a text box has not
  taken focus, and Ctrl+A then Backspace deletes the whole Workspace (happened 2026-10-10 on the Shadow PC; undone with Edit >
  Undo). Clear filters with their X button, clear the selection with `Selection:Set({})` in Luau, and check
  `#workspace.Plaza:GetDescendants()` before every Save to File.
