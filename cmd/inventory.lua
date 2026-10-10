-- READ-ONLY construction inventory of workspace.Lobby (safe in the reference).
local root = workspace.Lobby
local out = {}
local function add(s) table.insert(out, s) end
local function bump(t, k, n) t[k] = (t[k] or 0) + (n or 1) end
local function top(t, n, fmt)
	local a = {}; for k, v in pairs(t) do table.insert(a, { k, v }) end
	table.sort(a, function(x, y) return x[2] > y[2] end)
	for i = 1, math.min(n, #a) do add(string.format(fmt or "  %6d  %s", a[i][2], tostring(a[i][1]))) end
	return #a
end
-- per section
add("== sections (top-level children of Lobby, and of Lobby.Parts)")
local function sect(f)
	local c = {}; local n = 0
	for _, d in ipairs(f:GetDescendants()) do n += 1; if d:IsA("BasePart") then bump(c, d.ClassName) end end
	local s = {}; for k, v in pairs(c) do table.insert(s, k .. " " .. v) end; table.sort(s)
	add(string.format("  %-40s desc %6d  %s", f:GetFullName():gsub("Workspace.Lobby.", ""), n, table.concat(s, ", ")))
end
for _, f in ipairs(root:GetChildren()) do sect(f) end
if root:FindFirstChild("Areas") then for _, f in ipairs(root.Areas:GetChildren()) do sect(f) end end
local mat, col, meshes, meshSize, cls, neon, light, imgs, sa = {}, {}, {}, {}, {}, 0, {}, {}, 0
local partsVol = { Part = 0, MeshPart = 0, UnionOperation = 0 }
for _, d in ipairs(root:GetDescendants()) do
	if d:IsA("BasePart") then
		bump(cls, d.ClassName)
		bump(mat, d.Material.Name .. (d.MaterialVariant ~= "" and (" / " .. d.MaterialVariant) or ""))
		local c3 = d.Color; bump(col, string.format("%3d,%3d,%3d %s", c3.R * 255 + .5, c3.G * 255 + .5, c3.B * 255 + .5, d.Material.Name))
		if d.Material == Enum.Material.Neon then neon += 1 end
		local v = d.Size.X * d.Size.Y * d.Size.Z
		if partsVol[d.ClassName] then partsVol[d.ClassName] += v end
		if d:IsA("MeshPart") then bump(meshes, d.MeshId); meshSize[d.MeshId] = meshSize[d.MeshId] or d:GetFullName():gsub("Workspace.Lobby.", "") end
	elseif d:IsA("Light") then
		local c3 = d.Color
		local extra = d:IsA("SpotLight") and (" angle " .. d.Angle .. " face " .. d.Face.Name) or (d:IsA("SurfaceLight") and (" angle " .. d.Angle .. " face " .. d.Face.Name) or "")
		bump(light, string.format("%-12s br %.2f range %.0f col %d,%d,%d shadows %s%s", d.ClassName, d.Brightness, d.Range, c3.R * 255 + .5, c3.G * 255 + .5, c3.B * 255 + .5, tostring(d.Shadows), extra))
	elseif d:IsA("Decal") or d:IsA("Texture") then bump(imgs, d.ClassName)
	elseif d:IsA("SurfaceGui") or d:IsA("BillboardGui") then bump(imgs, d.ClassName)
	elseif d:IsA("SurfaceAppearance") then sa += 1
	elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then bump(imgs, d.ClassName) end
end
add("\n== base parts by class"); top(cls, 10)
add(string.format("  volume share: Part %.0f, MeshPart %.0f, Union %.0f (stud^3)", partsVol.Part, partsVol.MeshPart, partsVol.UnionOperation))
add("  Neon parts " .. neon .. ", SurfaceAppearances " .. sa)
add("\n== materials (material / variant)"); top(mat, 30)
add("\n== palette (colour + material, top 40)"); top(col, 40)
add("\n== meshes: unique ids and reuse (top 40; example placement)")
local u = 0; for _ in pairs(meshes) do u += 1 end; add("  unique mesh ids " .. u)
local a = {}; for k, v in pairs(meshes) do table.insert(a, { k, v }) end; table.sort(a, function(x, y) return x[2] > y[2] end)
for i = 1, math.min(40, #a) do add(string.format("  %5d  e.g. %s", a[i][2], meshSize[a[i][1]])) end
add("\n== lights (grouped by settings)"); local nl = 0; for _, v in pairs(light) do nl += v end; add("  total lights " .. nl); top(light, 40)
add("\n== images / effects"); top(imgs, 20)
return table.concat(out, "\n")
