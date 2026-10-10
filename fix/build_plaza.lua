-- build_plaza.lua (practice place only): freestyle spawn plaza, pass 4.
-- The kit (ae_kit_r4) is authored in plaza coordinates: the hero piece (4 mirrored corners), the stairs (4 rotated
-- flights) and the floor/medallion import already in place, so they are placed at the identity CFrame.
-- Frame: lower plaza floor y=0, terrace y=6, -Z = north. Stair foot 28, stair top 48 studs from the centre.
-- Idempotent: rebuilds Workspace.Plaza.
local IMPORT_SCALE = 40.5585   -- Import 3D scale of the FBX (19.2-stud medallion arrived as 778.7)
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
local src = workspace:FindFirstChild("ae_kit_r4")
if src then -- first run after an import: move the imported model into ServerStorage.Kit at true size
	if kit then kit:Destroy() end
	kit = Instance.new("Folder"); kit.Name = "Kit"; kit.Parent = SS
	-- Import 3D scales by 40.5585 but shrinks the WHOLE model further when any MeshPart would pass 2048 studs (the
	-- 124-stud hero did: r4 arrived at 16.516). So measure the scale from a piece of known size: the dais is 40 across.
	local ref = src:FindFirstChild("K_Medal_pale", true)
	if ref then IMPORT_SCALE = ref.Size.X / 40.0 end
	for _, d in ipairs(src:GetDescendants()) do
		if d:IsA("MeshPart") then
			d.Size = d.Size / IMPORT_SCALE
			d.CFrame = CFrame.new(d.Position / IMPORT_SCALE) * (d.CFrame - d.CFrame.Position)
			d.Anchored = true; d.Parent = kit
		end
	end
	src:Destroy()
end
assert(kit and kit:FindFirstChild("K_Hero_stone"), "no r4 kit: import kit/own/ae_kit_r4.fbx first")
local rgb = Color3.fromRGB
local SM, GL, NE = Enum.Material.SmoothPlastic, Enum.Material.Glass, Enum.Material.Neon
-- colour/material per name token (the material split made in Blender). Values are set ~25-35% under the colours read
-- from the reference pictures: Brightness 3.5 + flat SmoothPlastic renders a 176 grey floor at 232-255 (clipped);
-- the reference floor renders about 168. Measure rendered pixels, not part colours.
local LOOK = {
	stone = { rgb(110, 115, 128), SM }, darkStone = { rgb(55, 60, 75), SM }, gold = { rgb(215, 175, 60), SM, 0.12 },
	goldLan = { rgb(215, 175, 60), SM, 0.12 }, blue = { rgb(40, 80, 190), SM }, glass = { rgb(90, 200, 255), NE, nil, 0.25 },
	water = { rgb(110, 200, 220), GL, nil, 0.3 }, pale = { rgb(132, 136, 145), SM }, slate = { rgb(62, 70, 88), SM },
	white = { rgb(178, 178, 186), SM }, wood = { rgb(110, 80, 50), SM }, leaf = { rgb(40, 90, 230), SM },
}
local RUNNER_BLUE = rgb(45, 90, 200)
local function look(p, tint)
	local grp, tok = p.Name:match("^K_([^_]+)_(%a+)")
	if tok == "leaf" and tint then p.Color = tint; p.Material = SM; p.CastShadow = (grp == "PuffTree"); return end
	local L = LOOK[tok] or LOOK.stone
	p.Color = L[1]; p.Material = L[2]; p.Reflectance = L[3] or 0; p.Transparency = L[4] or 0
	if (grp == "Stairs" or grp == "Medal") and tok == "blue" then p.Color = RUNNER_BLUE end
	if grp == "Medal" and tok == "darkStone" then p.Color = rgb(50, 60, 75) end
	if tok == "glass" or tok == "water" then p.CastShadow = false end
end
local old = workspace:FindFirstChild("Plaza"); if old then old:Destroy() end
local root = Instance.new("Folder"); root.Name = "Plaza"; root.Parent = workspace
local function place(prefix, cf, scale, tint, parent)
	scale = scale or 1
	local m = Instance.new("Model"); m.Name = prefix
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
			local c = k:Clone(); c.Size = k.Size * scale
			c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
			look(c, tint); c.Parent = m
		end
	end
	m.Parent = parent or root
	return m
end
local function part(name, size, cf, color, mat, shape, parent)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf
	p.Color = color; p.Material = mat or SM; if shape then p.Shape = shape end
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or root; return p
end
local function blob(name, size, pos, color, mat, parent) -- non-uniform sphere (SpecialMesh) for canopies, rocks, islands
	local p = part(name, Vector3.new(1, 1, 1), CFrame.new(pos), color, mat or SM, nil, parent)
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Scale = size; m.Parent = p
	p.Size = size; m.Scale = Vector3.new(1, 1, 1); return p
end
local function tex(p, id, stud)
	local t = Instance.new("Texture"); t.Texture = id; t.Face = Enum.NormalId.Top; t.StudsPerTileU = stud; t.StudsPerTileV = stud
	t.Color3 = rgb(150, 154, 163); t.Parent = p -- a Texture covers the part colour with its own (white by default): tint it
end
local FLOOR_TEX = "rbxassetid://82579788770020"   -- own pale slab texture (tex/make_ae_tex4.py), 12 studs = 2x2 slabs
local PALE, GOLD, SLATE, NEONCYAN = LOOK.pale[1], LOOK.gold[1], LOOK.slate[1], rgb(90, 220, 255)

-- 1. hero pieces (kit is in plaza coordinates)
for _, pre in ipairs({ "K_Hero", "K_Stairs", "K_Medal" }) do
	local m = place(pre, CFrame.new())
	for _, p in ipairs(m:GetChildren()) do pcall(function() p.CollisionFidelity = Enum.CollisionFidelity.PreciseConvexDecomposition end) end
end
task.wait()

-- 2. ground: sunken plaza floor (y 0) inside the terrace ring (y 6)
tex(part("PlazaFloor", Vector3.new(96, 2, 96), CFrame.new(0, -1, 0), PALE), FLOOR_TEX, 12)
local G = rgb(90, 160, 70)
part("GroundN", Vector3.new(600, 6, 252), CFrame.new(0, 3, -48 - 126), G, Enum.Material.Grass)
part("GroundS", Vector3.new(600, 6, 252), CFrame.new(0, 3, 48 + 126), G, Enum.Material.Grass)
part("GroundE", Vector3.new(252, 6, 96), CFrame.new(48 + 126, 3, 0), G, Enum.Material.Grass)
part("GroundW", Vector3.new(252, 6, 96), CFrame.new(-48 - 126, 3, 0), G, Enum.Material.Grass)
local rng = Random.new(11)
for i = 1, 10 do -- sand patches on the terrace
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(70, 120)
	part("Sand" .. i, Vector3.new(0.2, rng:NextNumber(14, 26), rng:NextNumber(14, 26)), CFrame.new(r * math.cos(a), 6.02, r * math.sin(a)) * CFrame.Angles(0, 0, math.rad(90)), rgb(225, 205, 150), Enum.Material.Sand, Enum.PartType.Cylinder)
end
part("WaterEdge", Vector3.new(900, 1, 900), CFrame.new(0, -2.6, 0), rgb(90, 180, 220), GL).Transparency = 0.2

-- 3. arms on the terrace: N wide avenue with a water channel, E/W/S narrow with a pointed plus-shaped end
local function arm(i, width, len, channel)
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a))
	local rot = CFrame.lookAt(Vector3.zero, dir) -- -Z along the arm
	local function at(d, y) return CFrame.new(dir * d + Vector3.new(0, y, 0)) * rot end
	tex(part("Arm" .. i, Vector3.new(width, 1, len), at(48 + len / 2, 5.6), PALE), FLOOR_TEX, 12)
	for s = -1, 1, 2 do part("ArmEdge" .. i, Vector3.new(0.5, 0.1, len), at(48 + len / 2, 6.12) * CFrame.new(s * (width / 2 - 0.6), 0, 0), GOLD) end
	if channel then
		part("Channel" .. i, Vector3.new(6, 0.2, len - 4), at(48 + len / 2 + 2, 5.75), LOOK.water[1], GL).Transparency = 0.15
		part("ChannelBed" .. i, Vector3.new(6, 0.2, len - 4), at(48 + len / 2 + 2, 5.3), rgb(40, 110, 170))
		for s = -1, 1, 2 do part("ChanKerb" .. i, Vector3.new(0.8, 0.5, len - 4), at(48 + len / 2 + 2, 6.15) * CFrame.new(s * 3.4, 0, 0), GOLD) end
		for s = -1, 1, 2 do part("Runner" .. i, Vector3.new(4, 0.08, len - 6), at(48 + len / 2 + 2, 6.13) * CFrame.new(s * 9, 0, 0), RUNNER_BLUE) end
	else
		part("Runner" .. i, Vector3.new(5, 0.08, len - 4), at(48 + len / 2, 6.13), RUNNER_BLUE)
		for s = -1, 1, 2 do part("RunEdge" .. i, Vector3.new(0.4, 0.1, len - 4), at(48 + len / 2, 6.14) * CFrame.new(s * 2.7, 0, 0), GOLD) end
		local e = 48 + len
		local tip = part("ArmTip" .. i, Vector3.new(width * 0.95, 1, width * 0.95), at(e, 5.6) * CFrame.Angles(0, math.rad(45), 0), PALE); tex(tip, FLOOR_TEX, 12)
		part("ArmCross" .. i, Vector3.new(width * 2.2, 1, 7), at(e - 6, 5.62), PALE)
		for k = 0, 1 do
			local gem = part("CyanDiamond" .. i, Vector3.new(2.6, 0.1, 2.6), at(e - 14 - 12 * k, 6.17) * CFrame.Angles(0, math.rad(45), 0), NEONCYAN, NE)
			gem.CastShadow = false
		end
		part("TipDiamond" .. i, Vector3.new(4.5, 0.12, 4.5), at(e, 6.13) * CFrame.Angles(0, math.rad(45), 0), NEONCYAN, NE)
	end
end
arm(0, 37, 62, true); arm(1, 17, 34); arm(2, 17, 34); arm(3, 17, 34)
task.wait()

-- 4. bollards: 2 white pedestals with gold caps at each stair foot, on the slate band
for i = 0, 3 do
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a)); local side = Vector3.new(math.cos(a), 0, math.sin(a))
	for s = -1, 1, 2 do place("K_Bollard", CFrame.new(dir * 26.5 + side * s * 7)) end
end

-- 5. planting (zone tints: blue W, red E, green S, mixed N)
local BLUE, PURPLE, GOLDT, CORAL = rgb(40, 90, 230), rgb(150, 110, 210), rgb(225, 175, 50), rgb(225, 85, 75)
for qx = -1, 1, 2 do for qz = -1, 1, 2 do -- blue tree on each pool island (pool centre 40,40 on the diagonal)
	place("K_PuffTree", CFrame.new(qx * 40, 9.5, qz * 40) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0), 1.35, BLUE)
end end
local trees = { { -70, -60, PURPLE }, { -58, -88, GOLDT }, { 66, -64, BLUE }, { 84, -96, PURPLE }, { -80, 62, BLUE }, { 72, 70, CORAL },
	{ -100, -20, BLUE }, { -96, 26, PURPLE }, { 100, -24, CORAL }, { 96, 30, rgb(200, 60, 50) }, { -30, 100, GOLDT }, { 34, 96, BLUE },
	{ -34, -96, GOLDT }, { 36, -150, PURPLE }, { -40, -150, GOLDT } }
for _, t in ipairs(trees) do
	place("K_PuffTree", CFrame.new(t[1], 6, t[2]) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0), rng:NextNumber(1.4, 1.65), t[3])
end
for i = 1, 70 do -- low clumps on step edges, terrace and block tops
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(30, 70)
	local p = Vector3.new(r * math.cos(a), 0, r * math.sin(a))
	local ax, az = math.abs(p.X), math.abs(p.Z)
	local y = 6
	if math.max(ax, az) < 48 then -- on the stairs: step height at that distance (skip the runner strip)
		local d = math.max(ax, az); local lat = math.min(ax, az)
		if lat < 5 or lat > 16 then continue end
		y = math.clamp(math.floor((d - 28) / 2.5) + 1, 0, 8) * 0.75
	end
	local tint = (p.X > 20 and CORAL) or (p.X < -20 and BLUE) or (p.Z > 20 and rgb(110, 205, 60)) or PURPLE
	local kind = (i % 4 == 0) and "K_Grass" or "K_BushRed"
	local m = place(kind, CFrame.new(p.X, y, p.Z) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0), rng:NextNumber(0.8, 1.2), kind == "K_Grass" and rgb(110, 205, 60) or tint)
	for _, q in ipairs(m:GetChildren()) do q.Size = Vector3.new(q.Size.X, q.Size.Y * 0.6, q.Size.Z) end
end
task.wait()

-- 6. landmark blockouts at each arm end and floating islands on the skyline
local LM = Instance.new("Folder"); LM.Name = "Landmarks"; LM.Parent = root
-- N: Summon hall (cream and gold)
local CREAM = rgb(240, 228, 195)
part("SummonHall", Vector3.new(44, 20, 16), CFrame.new(0, 16, -128), CREAM, SM, nil, LM)
part("SummonRoof", Vector3.new(46, 2, 18), CFrame.new(0, 27, -128), GOLD, SM, nil, LM)
part("SummonDoor", Vector3.new(10, 13, 1), CFrame.new(0, 12.5, -119.6), rgb(70, 60, 90), SM, nil, LM)
part("SummonDoorArch", Vector3.new(1, 12, 12), CFrame.new(0, 19, -119.4) * CFrame.Angles(0, 0, math.rad(90)), GOLD, SM, Enum.PartType.Cylinder, LM)
blob("SummonDome", Vector3.new(18, 16, 18), Vector3.new(0, 29, -128), rgb(230, 195, 90), SM, LM)
for s = -1, 1, 2 do
	part("SummonTower", Vector3.new(7, 34, 7), CFrame.new(s * 24, 23, -128), CREAM, SM, nil, LM)
	blob("SummonTowerCap", Vector3.new(8, 9, 8), Vector3.new(s * 24, 41, -128), GOLD, SM, LM)
	for k = 0, 2 do part("SummonWindow", Vector3.new(3, 6, 0.5), CFrame.new(s * (8 + 6 * k), 15, -119.8), rgb(80, 140, 220), SM, nil, LM) end
end
-- S: teal Expeditions portal, three arches
local TEAL = rgb(60, 200, 190)
for k = -1, 1 do
	local h = (k == 0) and 14 or 10; local x = k * 12; local w = (k == 0) and 9 or 7
	for s = -1, 1, 2 do part("PortalPillar", Vector3.new(2, h, 2), CFrame.new(x + s * w / 2, 6 + h / 2, 100), rgb(235, 240, 240), SM, nil, LM) end
	part("PortalBeam", Vector3.new(w + 3, 2, 2.6), CFrame.new(x, 6 + h + 1, 100), TEAL, SM, nil, LM)
	local f = part("PortalField", Vector3.new(w - 2, h - 1, 0.4), CFrame.new(x, 6 + (h - 1) / 2, 100), TEAL, NE, nil, LM); f.Transparency = 0.35
end
for s = -1, 1, 2 do -- crystal braziers
	part("BrazierBase", Vector3.new(3, 4, 3), CFrame.new(s * 22, 8, 96), rgb(235, 240, 240), SM, nil, LM)
	part("BrazierCrystal", Vector3.new(2, 3.5, 2), CFrame.new(s * 22, 11.8, 96) * CFrame.Angles(0, math.rad(45), math.rad(10)), TEAL, NE, nil, LM)
end
-- E: red Raid gate with a skull tower
local RED, DRED = rgb(190, 50, 50), rgb(110, 30, 35)
part("RaidGate", Vector3.new(10, 18, 30), CFrame.new(104, 15, 0), RED, SM, nil, LM)
part("RaidDoor", Vector3.new(1, 12, 10), CFrame.new(98.8, 12, 0), rgb(15, 10, 15), SM, nil, LM)
part("RaidTower", Vector3.new(12, 36, 12), CFrame.new(116, 24, 0), DRED, SM, nil, LM)
blob("RaidSkull", Vector3.new(12, 12, 11), Vector3.new(114, 46, 0), RED, SM, LM)
for s = -1, 1, 2 do blob("RaidEye", Vector3.new(2.6, 2.2, 1), Vector3.new(108.6, 47, s * 2.4), rgb(255, 60, 60), NE, LM) end
part("RaidBlade", Vector3.new(1, 30, 1.6), CFrame.new(109, 30, 0), rgb(255, 40, 40), NE, nil, LM)
for s = -1, 1, 2 do part("RaidSpire", Vector3.new(4, 26, 4), CFrame.new(104, 19, s * 17), DRED, SM, nil, LM) end
-- W: Story ring portal under a giant blue tree
for k = 0, 23 do
	local a = 2 * math.pi * k / 24
	part("StoryRing", Vector3.new(1.4, 1.6, 1.6), CFrame.new(-100, 12 + 5.5 * math.sin(a), 5.5 * math.cos(a)) * CFrame.Angles(-a, 0, 0), GOLD, SM, nil, LM)
end
local disc = part("StoryField", Vector3.new(0.3, 10, 10), CFrame.new(-100, 12, 0) * CFrame.Angles(0, 0, 0), rgb(80, 150, 255), NE, Enum.PartType.Cylinder, LM); disc.Transparency = 0.3
part("StoryBase", Vector3.new(6, 1.5, 14), CFrame.new(-100, 6.7, 0), rgb(235, 240, 240), SM, nil, LM)
part("GiantTrunk", Vector3.new(40, 5, 5), CFrame.new(-114, 26, 0) * CFrame.Angles(0, 0, math.rad(90)), rgb(110, 80, 50), SM, Enum.PartType.Cylinder, LM)
for k = 1, 9 do
	local a = 2 * math.pi * k / 9
	blob("GiantCanopy", Vector3.new(18, 12, 18), Vector3.new(-114 + 11 * math.cos(a), 44 + rng:NextNumber(-3, 4), 11 * math.sin(a)), BLUE, SM, LM)
end
blob("GiantCanopyTop", Vector3.new(22, 14, 22), Vector3.new(-114, 50, 0), BLUE, SM, LM)
-- floating islands: rock underside, grass cap, a waterfall on some
local isl = { { -70, 85, -230, 60 }, { 80, 70, -210, 45 }, { 50, 80, 230, 55 }, { -60, 65, 210, 40 }, { 230, 75, 40, 50 }, { -230, 90, -30, 60 }, { 200, 100, -170, 40 }, { -190, 70, 170, 45 } }
for i, s in ipairs(isl) do
	local x, y, z, w = s[1], s[2], s[3], s[4]
	blob("IslandRock", Vector3.new(w, w * 0.7, w * 0.9), Vector3.new(x, y - w * 0.18, z), rgb(130, 125, 135), SM, LM)
	part("IslandGrass", Vector3.new(3, w * 0.98, w * 0.88), CFrame.new(x, y + 0.5, z) * CFrame.Angles(0, 0, math.rad(90)), rgb(110, 190, 80), Enum.Material.Grass, Enum.PartType.Cylinder, LM)
	place("K_PuffTree", CFrame.new(x + w * 0.15, y + 1.5, z), 1.5, rgb(90, 170, 70), LM)
	if i % 2 == 1 then local f = part("Waterfall", Vector3.new(4, 60, 0.6), CFrame.new(x, y - 32, z + w * 0.4), rgb(200, 235, 255), NE, nil, LM); f.Transparency = 0.45 end
end

local n = 0; for _, d in ipairs(root:GetDescendants()) do if d:IsA("BasePart") then n += 1 end end
local sp = workspace:FindFirstChild("SpawnLocation"); if sp then sp.CFrame = CFrame.new(0, 0.6, 30); sp.Transparency = 1; sp.CanCollide = false; local dc = sp:FindFirstChildOfClass("Decal"); if dc then dc:Destroy() end end
local bp = workspace:FindFirstChild("Baseplate"); if bp then bp:Destroy() end
return "plaza parts " .. n
