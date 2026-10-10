-- build_plaza.lua (practice place only): freestyle spawn plaza from the own kit (ae_kit_r1) and own layout.
-- Layout estimated from the picture set (top view at 0.28 stud/px, player = 5 studs). Idempotent: rebuilds Workspace.Plaza.
local IMPORT_SCALE = 40.5585   -- Import 3D scale of the FBX (19.2-stud medallion arrived as 778.7)
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
local src = workspace:FindFirstChild("ae_kit_r1")
if src then -- first run: move the imported model into ServerStorage.Kit at true size
	if kit then kit:Destroy() end
	kit = Instance.new("Folder"); kit.Name = "Kit"; kit.Parent = SS
	for _, d in ipairs(src:GetDescendants()) do
		if d:IsA("MeshPart") then
			d.Size = d.Size / IMPORT_SCALE
			d.CFrame = CFrame.new(d.Position / IMPORT_SCALE) * (d.CFrame - d.CFrame.Position)
			d.Anchored = true; d.Parent = kit
		end
	end
	src:Destroy()
end
assert(kit, "no kit")
local COL = { stone = Color3.fromRGB(128, 134, 150), gold = Color3.fromRGB(226, 160, 28), blue = Color3.fromRGB(34, 76, 200),
	glass = Color3.fromRGB(90, 200, 255), water = Color3.fromRGB(80, 190, 255), dark = Color3.fromRGB(34, 34, 44), wood = Color3.fromRGB(120, 82, 52),
	leaf = Color3.fromRGB(40, 100, 255) }
local function look(p) -- colour/material by the name token after the piece prefix
	if p.Name == "K_Hood_stone" then p.Color = Color3.fromRGB(92, 98, 116); p.Material = Enum.Material.SmoothPlastic; return end
	local tok = (p.Name:match("^K_[^_]+_(%a+)") or "stone"):lower()
	for k, c in pairs(COL) do if tok:sub(1, #k) == k then
		p.Color = c
		p.Material = (k == "gold" and Enum.Material.SmoothPlastic) or ((k == "glass" or k == "water") and Enum.Material.Glass) or Enum.Material.SmoothPlastic
		if k == "glass" or k == "water" then p.Transparency = 0.35 end
		if k == "gold" then p.Reflectance = 0.15 end
		return end end
end
local old = workspace:FindFirstChild("Plaza"); if old then old:Destroy() end
local root = Instance.new("Folder"); root.Name = "Plaza"; root.Parent = workspace
local function place(prefix, cf, scale)
	scale = scale or 1
	local m = Instance.new("Model"); m.Name = prefix; m.Parent = root
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
			local c = k:Clone(); c.Size = k.Size * scale
			c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
			look(c); c.Parent = m
		end
	end
	return m
end
local function part(name, size, cf, color, mat, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf
	p.Color = color; p.Material = mat or Enum.Material.SmoothPlastic; if shape then p.Shape = shape end
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = root; return p
end
local function tex(p, id, stud) -- own tiling texture on the top face of a floor part
	local t = Instance.new("Texture"); t.Texture = id; t.Face = Enum.NormalId.Top; t.StudsPerTileU = stud; t.StudsPerTileV = stud; t.Parent = p
	for _, f in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right }) do
		local s = t:Clone(); s.Face = f; s.Parent = p end
end
local STONE, TILE = COL.stone, Color3.fromRGB(150, 154, 166)
local FLOOR_TEX, STONE_TEX = "rbxassetid://110802131136105", "rbxassetid://87016735224776"
-- ground and plaza floor
part("Grass", Vector3.new(400, 2, 400), CFrame.new(0, -1.2, 0), Color3.fromRGB(96, 190, 70), Enum.Material.Grass)
tex(part("PlazaFloor", Vector3.new(76, 2, 76), CFrame.new(0, -1, 0) * CFrame.Angles(0, math.rad(45), 0), TILE), FLOOR_TEX, 20)
tex(part("PlazaCross", Vector3.new(150, 2, 42), CFrame.new(0, -0.98, 0), TILE), FLOOR_TEX, 20)
tex(part("PlazaCross2", Vector3.new(42, 2, 150), CFrame.new(0, -0.98, 0), TILE), FLOOR_TEX, 20)
place("K_Medal", CFrame.new(0, 0, 0))
-- diamond rim (gold trim on a low kerb)
for i = 0, 3 do
	local a = math.rad(45 + 90 * i)
	part("Kerb" .. i, Vector3.new(24, 0.6, 1.2), CFrame.new(12 * math.cos(a), 0.3, 12 * math.sin(a)) * CFrame.Angles(0, -a + math.rad(90), 0), COL.gold)
	place("K_Bollard", CFrame.new(17 * math.cos(math.rad(90 * i)), 0, 17 * math.sin(math.rad(90 * i))))
end
-- four avenues: 8 steps up either side of the channel, then the raised avenue
for i = 0, 3 do
	local a = math.rad(90 * i)
	local dir = Vector3.new(math.cos(a), 0, math.sin(a))
	local rot = CFrame.lookAt(Vector3.zero, dir) -- -Z points along the avenue
	for s = 0, 7 do
		local d = 22 + s * 1.7
		for side = -1, 1, 2 do
			place("K_Step", CFrame.new(dir * d + Vector3.new(0, s, 0)) * rot * CFrame.new(side * 11.5, 0, 0) * CFrame.Angles(0, 0, 0), 1).Name = "Step"
		end
	end
	tex(part("AvenueDeck" .. i, Vector3.new(42, 8, 60), CFrame.new(dir * (22 + 8 * 1.7 + 30) + Vector3.new(0, 4 - 0.02, 0)) * rot, TILE), FLOOR_TEX, 20)
	-- channel panel: down the steps (tilted) and flat on the deck
	local tilt = math.atan(8 / (8 * 1.7))
	place("K_Channel", CFrame.new(dir * (22 + 4 * 1.7) + Vector3.new(0, 4.1, 0)) * rot * CFrame.Angles(tilt, 0, 0), 1)
	place("K_Channel", CFrame.new(dir * (22 + 8 * 1.7 + 25) + Vector3.new(0, 8.05, 0)) * rot)
	for side = -1, 1, 2 do
		place("K_Plinth", CFrame.new(dir * 20.5) * rot * CFrame.new(side * 8.5, 0, 0) * CFrame.Angles(0, math.rad(180), 0), 0.7)
	end
end
-- four corner fountain blocks, hoods opening toward the plaza centre
for i = 0, 3 do
	local a = math.rad(45 + 90 * i)
	local c = Vector3.new(39 * math.cos(a), 0, 39 * math.sin(a))
	local cf = CFrame.lookAt(c, c * 2) -- -Z away from the centre, so the hood's open +Z side faces the plaza
	part("BlockPlatform" .. i, Vector3.new(2, 34, 34), CFrame.new(c + Vector3.new(0, 0.5, 0)) * CFrame.Angles(0, 0, math.rad(90)), STONE, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
	place("K_Hood", cf * CFrame.new(0, 1, 0))
	place("K_Fountain", cf * CFrame.new(0, 1, 1))
	place("K_PuffTree", cf * CFrame.new(0, 1, -6), 1.1)
	for side = -1, 1, 2 do place("K_Pav", cf * CFrame.new(side * 15.5, 1, 4)) end
	place("K_Palm", cf * CFrame.new(0, 0, -24) * CFrame.Angles(0, math.rad(40 * i), 0), 1.2)
end
local n = 0; for _, d in ipairs(root:GetDescendants()) do if d:IsA("BasePart") then n += 1 end end
local sp = workspace:FindFirstChild("SpawnLocation"); if sp then sp.CFrame = CFrame.new(0, 0.6, 30); sp.Transparency = 1; sp.CanCollide = false; local dc = sp:FindFirstChildOfClass("Decal"); if dc then dc:Destroy() end end
local bp = workspace:FindFirstChild("Baseplate"); if bp then bp:Destroy() end
return "plaza parts " .. n
