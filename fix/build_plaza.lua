-- build_plaza.lua (practice place only): freestyle spawn plaza, pass 5.
-- The kit (ae_kit_r5, tools/ae_kit.py build_all5) is authored in plaza coordinates: the hero piece (4 mirrored
-- corners), the stairs (4 rotated flights) and the floor/medallion import already in place, so they are placed at the
-- identity CFrame. Foliage, islands, ring, crystals and bollards are authored at the origin and instanced.
-- Frame: lower plaza floor y=0, terrace y=6, -Z = north. Stair foot 28, stair top 48 studs from the centre.
-- Idempotent: rebuilds Workspace.Plaza.
local IMPORT_SCALE = 40.5585   -- Import 3D scale of the FBX (before any 2048-stud clamp)
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
local src = workspace:FindFirstChild("ae_kit_r5")
if src then -- first run after an import: move the imported model into ServerStorage.Kit at true size
	if kit then kit:Destroy() end
	kit = Instance.new("Folder"); kit.Name = "Kit"; kit.Parent = SS
	-- Import 3D scales by 40.5585 but shrinks the WHOLE model further when any MeshPart would pass 2048 studs (the
	-- 124-stud hero does). So measure the scale from a piece of known size: the dais is 40 across.
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
assert(kit and kit:FindFirstChild("K_Hero_rib"), "no r5 kit: import kit/own/ae_kit_r5.fbx first")
local rgb = Color3.fromRGB
local SM, GL, NE, GR = Enum.Material.SmoothPlastic, Enum.Material.Glass, Enum.Material.Neon, Enum.Material.Grass
-- Colour/material per name token (the material split made in Blender). Part colours sit about 1/1.5 of the rendered
-- target values from the round-2 review (Brightness 3.5 + SmoothPlastic renders brighter than the part colour).
local LOOK = {
	stone = { rgb(98, 102, 112), SM }, rib = { rgb(52, 56, 68), SM }, darkStone = { rgb(34, 38, 48), SM },
	gold = { rgb(150, 112, 30), SM }, blue = { rgb(48, 78, 150), SM }, glass = { rgb(45, 120, 175), NE, 0, 0.2 },
	water = { rgb(80, 140, 155), GL, 0, 0.25 }, foam = { rgb(120, 170, 190), NE, 0, 0.45 }, turf = { rgb(78, 128, 58), GR },
	pale = { rgb(124, 127, 131), SM }, slate = { rgb(40, 44, 58), SM }, white = { rgb(170, 170, 178), SM },
	navy = { rgb(28, 38, 95), SM }, riser = { rgb(84, 90, 100), SM }, wood = { rgb(105, 76, 50), SM },
	rock = { rgb(140, 138, 136), SM }, grass = { rgb(82, 135, 58), GR }, silver = { rgb(150, 153, 162), SM, 0.15 },
}
local RUNNER_BLUE = rgb(40, 68, 140)
local function lighten(c, k) return c:Lerp(Color3.new(1, 1, 1), k) end
local function look(p, tint, rim)
	local grp, tok = p.Name:match("^K_([^_]+)_(%a+)")
	if tok and tok:sub(1, 4) == "leaf" and tint then
		p.Color = (tok == "leafRim") and (rim or lighten(tint, 0.3)) or tint; p.Material = SM
		p.CastShadow = not (grp == "Fern" or grp == "Grass"); return
	end
	if tok and tok:sub(1, 4) == "gold" then tok = "gold" end
	local L = LOOK[tok] or LOOK.stone
	p.Color = L[1]; p.Material = L[2]; p.Reflectance = L[3] or 0; p.Transparency = L[4] or 0
	if tok == "blue" and (grp == "Stairs" or grp == "Medal") then p.Color = RUNNER_BLUE end
	if tok == "stone" and grp == "Stairs" then p.Color = rgb(135, 137, 139) end
	if tok == "foam" and grp == "Island" then p.Color = rgb(185, 215, 232); p.Material = SM; p.Transparency = 0.3 end
	if tok == "darkStone" and grp == "Medal" then p.Color = rgb(30, 33, 42) end
	if tok == "glass" and grp == "Crystal" then p.Color = tint or rgb(60, 110, 230); p.Material = GL; p.Transparency = 0.15 end
	if tok == "glass" or tok == "water" or tok == "foam" then p.CastShadow = false end
end
local old = workspace:FindFirstChild("Plaza"); if old then old:Destroy() end
local root = Instance.new("Folder"); root.Name = "Plaza"; root.Parent = workspace
local function place(prefix, cf, scale, tint, parent, rim)
	scale = scale or 1
	local m = Instance.new("Model"); m.Name = prefix
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
			local c = k:Clone(); c.Size = k.Size * scale
			c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
			look(c, tint, rim); c.Parent = m
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
local function blob(name, size, pos, color, mat, parent) -- non-uniform sphere for skull, cones, rocks
	local p = part(name, size, CFrame.new(pos), color, mat or SM, Enum.PartType.Ball, parent)
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	return p
end
local function tex(p, id, stud)
	local t = Instance.new("Texture"); t.Texture = id; t.Face = Enum.NormalId.Top; t.StudsPerTileU = stud; t.StudsPerTileV = stud
	t.Color3 = rgb(128, 132, 136); t.Parent = p -- a Texture covers the part colour with its own (white by default): tint it
end
local FLOOR_TEX = "rbxassetid://82579788770020"   -- own pale slab texture (tex/make_ae_tex4.py), 12 studs = 2x2 slabs
local PALE, GOLD, SLATE = LOOK.pale[1], LOOK.gold[1], LOOK.slate[1]
local rng = Random.new(11)
local function rot() return CFrame.Angles(0, rng:NextNumber(0, 6.28), 0) end

-- 1. hero pieces (kit is in plaza coordinates)
for _, pre in ipairs({ "K_Hero", "K_Stairs", "K_Medal" }) do
	local m = place(pre, CFrame.new())
	for _, p in ipairs(m:GetChildren()) do pcall(function() p.CollisionFidelity = Enum.CollisionFidelity.PreciseConvexDecomposition end) end
end
task.wait()

-- 2. ground: sunken plaza floor (y 0) inside the terrace ring (y 6), zoned terrace, far water past 850 studs
tex(part("PlazaFloor", Vector3.new(96, 2, 96), CFrame.new(0, -1, 0), PALE), FLOOR_TEX, 12)
local ZN, ZS, ZE, ZW = rgb(72, 122, 55), rgb(92, 122, 40), rgb(118, 50, 34), rgb(55, 95, 140)
part("GroundN", Vector3.new(1700, 6, 800), CFrame.new(0, 3, -48 - 400), ZN, GR)
part("GroundS", Vector3.new(1700, 6, 800), CFrame.new(0, 3, 48 + 400), ZS, GR)
part("GroundE", Vector3.new(800, 6, 96), CFrame.new(48 + 400, 3, 0), ZE, Enum.Material.Ground)
part("GroundW", Vector3.new(800, 6, 96), CFrame.new(-48 - 400, 3, 0), ZW, GR)
-- zone overlays on the N/S slabs so the E/W colours run into the corners (thin plates just above the terrace)
for s = -1, 1, 2 do
	part("ZoneE", Vector3.new(300, 0.1, 140), CFrame.new(200, 6.03, s * 115), ZE, Enum.Material.Ground)
	part("ZoneW", Vector3.new(300, 0.1, 140), CFrame.new(-200, 6.03, s * 115), ZW, GR)
end
for i = 1, 6 do -- E gravel paths, W ponds, S sand
	part("Gravel" .. i, Vector3.new(rng:NextNumber(30, 60), 0.12, 6), CFrame.new(rng:NextNumber(70, 160), 6.06, rng:NextNumber(-90, 90)) * rot(), rgb(78, 78, 82), Enum.Material.Slate)
	part("Pond" .. i, Vector3.new(0.3, rng:NextNumber(16, 30), rng:NextNumber(16, 30)), CFrame.new(rng:NextNumber(-170, -75), 6.05, rng:NextNumber(-100, 100)) * CFrame.Angles(0, 0, math.rad(90)), LOOK.water[1], GL, Enum.PartType.Cylinder).Transparency = 0.2
	part("Sand" .. i, Vector3.new(0.2, rng:NextNumber(18, 32), rng:NextNumber(18, 32)), CFrame.new(rng:NextNumber(-100, 100), 6.04, rng:NextNumber(70, 160)) * CFrame.Angles(0, 0, math.rad(90)), rgb(160, 145, 105), Enum.Material.Sand, Enum.PartType.Cylinder)
end
part("WaterEdge", Vector3.new(4000, 1, 4000), CFrame.new(0, -2.6, 0), rgb(70, 130, 160), GL).Transparency = 0.2

-- 3. arms on the terrace: N long avenue with a water channel to the Summon hall; E/W/S narrow arms ending about 82 out
local function arm(i, width, len, channel)
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a))
	local r = CFrame.lookAt(Vector3.zero, dir)
	local function at(d, y) return CFrame.new(dir * d + Vector3.new(0, y, 0)) * r end
	tex(part("Arm" .. i, Vector3.new(width, 1, len), at(48 + len / 2, 5.6), PALE), FLOOR_TEX, 12)
	for s = -1, 1, 2 do part("ArmEdge" .. i, Vector3.new(0.6, 0.12, len), at(48 + len / 2, 6.12) * CFrame.new(s * (width / 2 - 0.6), 0, 0), GOLD) end
	if channel then
		part("Channel" .. i, Vector3.new(6, 0.2, len - 4), at(48 + len / 2 + 2, 5.75), LOOK.water[1], GL).Transparency = 0.15
		part("ChannelBed" .. i, Vector3.new(6, 0.2, len - 4), at(48 + len / 2 + 2, 5.3), rgb(30, 70, 110))
		for s = -1, 1, 2 do part("ChanKerb" .. i, Vector3.new(0.8, 0.5, len - 4), at(48 + len / 2 + 2, 6.15) * CFrame.new(s * 3.4, 0, 0), GOLD) end
		for s = -1, 1, 2 do part("Runner" .. i, Vector3.new(4, 0.08, len - 6), at(48 + len / 2 + 2, 6.13) * CFrame.new(s * 9, 0, 0), RUNNER_BLUE) end
	else
		part("Runner" .. i, Vector3.new(5, 0.08, len - 4), at(48 + len / 2, 6.13), RUNNER_BLUE)
		part("RunInset" .. i, Vector3.new(2.2, 0.1, len - 6), at(48 + len / 2, 6.14), LOOK.navy[1])
		for s = -1, 1, 2 do part("RunEdge" .. i, Vector3.new(0.4, 0.12, len - 4), at(48 + len / 2, 6.15) * CFrame.new(s * 2.7, 0, 0), GOLD) end
		local e = 48 + len
		local tip = part("ArmTip" .. i, Vector3.new(width * 0.95, 1, width * 0.95), at(e, 5.6) * CFrame.Angles(0, math.rad(45), 0), PALE); tex(tip, FLOOR_TEX, 12)
		part("ArmCross" .. i, Vector3.new(width * 2.0, 1, 7), at(e - 6, 5.62), PALE)
		part("TipDiamond" .. i, Vector3.new(4.5, 0.12, 4.5), at(e, 6.13) * CFrame.Angles(0, math.rad(45), 0), LOOK.navy[1])
		part("TipGem" .. i, Vector3.new(2.2, 0.16, 2.2), at(e, 6.15) * CFrame.Angles(0, math.rad(45), 0), LOOK.glass[1], NE).Transparency = 0.3
	end
end
arm(0, 37, 104, true); arm(1, 17, 22); arm(2, 17, 22); arm(3, 17, 22)
task.wait()

-- 4. bollards: 4 on the diagonals at the dais edge, facing the gates (the 8 stair-foot ones are gone)
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	place("K_Bollard", CFrame.new(qx * 9.6, 0.3, qz * 9.6) * CFrame.Angles(0, math.atan2(qx, qz), 0))
end end

-- 5. planting. Zones (review): blue W and N, dark red E, green S; trees blue/purple/gold/red.
local P = Instance.new("Folder"); P.Name = "Planting"; P.Parent = root
local BLUE, BLUER, PURPLE, GOLDT, RED = rgb(50, 105, 240), rgb(115, 160, 255), rgb(140, 100, 205), rgb(205, 155, 40), rgb(150, 32, 42)
local FB, FR, FG = rgb(60, 115, 240), rgb(135, 30, 38), rgb(95, 155, 55)          -- palm fronds W/N, E, S
local function zone(x, z)
	if math.abs(x) >= math.abs(z) then return x > 0 and "E" or "W" end
	return z > 0 and "S" or "N"
end
local FROND = { N = FB, W = FB, E = FR, S = FG }
local FERN = { E = rgb(160, 55, 48), W = rgb(45, 85, 170), S = rgb(95, 140, 40), N = rgb(55, 90, 175) }
local TREEC = { N = { BLUE, PURPLE, GOLDT }, W = { BLUE, BLUE, PURPLE }, E = { RED, GOLDT, RED }, S = { GOLDT, BLUE, PURPLE } }
-- pool islands: a blue tree on each pool rock (pool centre 55 out on the diagonal = 38.9, 38.9)
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	place("K_TreeC", CFrame.new(qx * 38.9, 9.4, qz * 38.9) * rot(), 0.85, BLUE, P, BLUER)
	for s = -1, 1, 2 do -- crystals beside the lanterns, standing in the pool
		local u, w = s * 7.5, 46
		local x, z = math.abs((w + u) / 1.4142) * qx, math.abs((u - w) / 1.4142) * qz
		place("K_Crystal", CFrame.new(x, 6.6, z) * rot(), 1.3, rgb(60, 110, 235), P)
	end
end end
-- per quadrant behind the pools: 2 palms, 3-4 trees, 2 cypress cones
local corner = { { 1, -1 }, { -1, -1 }, { 1, 1 }, { -1, 1 } }
for ci, q in ipairs(corner) do
	local qx, qz = q[1], q[2]
	local spots = { { 72, 52, "palm" }, { 54, 76, "palm" }, { 92, 70, "tree" }, { 70, 96, "tree" }, { 108, 100, "tree" }, { 86, 124, "tree" }, { 64, 66, "cyp" }, { 76, 58, "cyp" } }
	for k, s in ipairs(spots) do
		local x, z = qx * s[1], qz * s[2]
		local zn = zone(x, z)
		if s[3] == "palm" then
			place((k % 2 == 0) and "K_PalmB" or "K_PalmA", CFrame.new(x, 6, z) * rot(), rng:NextNumber(0.92, 1.1), FROND[zn], P, lighten(FROND[zn], 0.25))
		elseif s[3] == "tree" then
			local c = TREEC[zn][(k + ci) % 3 + 1]
			place(({ "K_TreeA", "K_TreeB", "K_TreeC" })[(k + ci) % 3 + 1], CFrame.new(x, 6, z) * rot(), rng:NextNumber(1.0, 1.15), c, P, lighten(c, 0.35))
		else
			place("K_Cypress", CFrame.new(x, 6, z) * rot(), 1.0, BLUE, P, BLUER)
		end
	end
	task.wait()
end
-- N avenue: 6 blue palms per side at 12-stud spacing, with blue cypresses between
for k = 0, 5 do
	for s = -1, 1, 2 do
		place((k % 2 == 0) and "K_PalmA" or "K_PalmB", CFrame.new(s * 21, 6, -58 - 12 * k) * rot(), rng:NextNumber(0.9, 1.05), FB, P, lighten(FB, 0.25))
		if k < 5 then place("K_Cypress", CFrame.new(s * 22, 6, -64 - 12 * k) * rot(), 0.9, BLUE, P, BLUER) end
	end
end
-- outer ring of trees and palms so the frame tops fill (100-180 out)
for i = 1, 40 do
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(105, 185)
	local x, z = r * math.cos(a), r * math.sin(a)
	if math.abs(x) < 26 or math.abs(z) < 26 then continue end
	local zn = zone(x, z)
	if i % 3 == 0 then
		place("K_PalmA", CFrame.new(x, 6, z) * rot(), rng:NextNumber(0.95, 1.15), FROND[zn], P, lighten(FROND[zn], 0.25))
	else
		local c = TREEC[zn][i % 3 + 1]
		place(({ "K_TreeA", "K_TreeB", "K_TreeC" })[i % 3 + 1], CFrame.new(x, 6, z) * rot(), rng:NextNumber(1.0, 1.3), c, P, lighten(c, 0.35))
	end
end
task.wait()
-- fern clumps: on the step edges outside the runner (lateral 13-17), at the basin feet, and on the terrace
local function stepY(d) return math.clamp(math.floor((d - 28) / 2.5) + 1, 0, 8) * 0.75 end
local nf = 0
for i = 0, 3 do
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a)); local side = Vector3.new(math.cos(a), 0, math.sin(a))
	for k = 1, 10 do
		local d = rng:NextNumber(29, 47); local lat = (k % 2 == 0 and 1 or -1) * rng:NextNumber(13.5, 17)
		local p = dir * d + side * lat
		place("K_Fern", CFrame.new(p.X, stepY(d), p.Z) * rot(), rng:NextNumber(0.9, 1.3), FERN[zone(p.X + side.X * lat, p.Z + side.Z * lat)], P); nf += 1
	end
end
for qx = -1, 1, 2 do for qz = -1, 1, 2 do -- basin feet: an arc of ferns either side of each basin
	for k = 1, 6 do
		local u = (k <= 3 and -1 or 1) * rng:NextNumber(6.2, 8.5); local w = rng:NextNumber(27.5, 32.5)
		local x, z = (w + u) / 1.4142, (u - w) / 1.4142 -- NE frame, then mirror
		x, z = math.abs(x) * qx, math.abs(z) * qz
		local zn = (u * qx * -qz > 0) and zone(x * 2, z * 0.5) or zone(x * 0.5, z * 2)
		place("K_Fern", CFrame.new(x, 0, z) * rot(), rng:NextNumber(1.0, 1.35), FERN[zn], P); nf += 1
	end
end end
for i = 1, 70 do -- terrace carpet
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(52, 130)
	local x, z = r * math.cos(a), r * math.sin(a)
	if math.abs(x) < 20 or math.abs(z) < 20 then continue end
	if math.abs(x) < 62 and math.abs(z) < 62 then continue end -- corner blocks: pools and lanterns
	local zn = zone(x, z)
	if i % 4 == 0 then place("K_Grass", CFrame.new(x, 6, z) * rot(), rng:NextNumber(1.2, 1.8), rgb(95, 150, 45), P)
	else place("K_Fern", CFrame.new(x, 6, z) * rot(), rng:NextNumber(1.2, 1.8), FERN[zn], P) end
	nf += 1
end
task.wait()

-- 6. landmarks at each arm end (blockouts, re-proportioned per the review), floating-island skyline
local LM = Instance.new("Folder"); LM.Name = "Landmarks"; LM.Parent = root
-- N: Summon hall, 40 studs further down the avenue, columns, arches, gold dome
local CREAM, CREAMD = rgb(190, 180, 150), rgb(140, 130, 105)
local HZ = -170
part("SummonHall", Vector3.new(48, 18, 18), CFrame.new(0, 15, HZ), CREAM, SM, nil, LM)
part("SummonCornice", Vector3.new(51, 1.6, 20), CFrame.new(0, 24.5, HZ), GOLD, SM, nil, LM)
part("SummonAttic", Vector3.new(30, 5, 14), CFrame.new(0, 27.5, HZ), CREAM, SM, nil, LM)
blob("SummonDome", Vector3.new(20, 18, 20), Vector3.new(0, 31, HZ), rgb(165, 125, 40), SM, LM)
part("SummonFinial", Vector3.new(1, 5, 1), CFrame.new(0, 41.5, HZ), GOLD, SM, nil, LM)
for k = -3, 3 do -- colonnade with arches in front
	part("SummonCol", Vector3.new(1.6, 14, 1.6), CFrame.new(k * 6.6, 13, HZ + 10.5), CREAM, SM, nil, LM)
	if k < 3 then part("SummonArch", Vector3.new(0.8, 5.2, 5.2), CFrame.new(k * 6.6 + 3.3, 19, HZ + 10.5) * CFrame.Angles(0, math.rad(90), 0), CREAMD, SM, Enum.PartType.Cylinder, LM) end
end
part("SummonDoor", Vector3.new(9, 12, 1), CFrame.new(0, 12, HZ + 9.1), rgb(40, 35, 60), SM, nil, LM)
part("SummonSign", Vector3.new(14, 2.4, 0.6), CFrame.new(0, 22.5, HZ + 11.6), rgb(45, 75, 160), SM, nil, LM)
for s = -1, 1, 2 do
	part("SummonTower", Vector3.new(8, 32, 8), CFrame.new(s * 28, 22, HZ), CREAM, SM, nil, LM)
	blob("SummonTowerCap", Vector3.new(9, 10, 9), Vector3.new(s * 28, 39, HZ), rgb(165, 125, 40), SM, LM)
end
-- S: Expeditions, teal arched portal with pale-teal columns, crystal braziers, ring of floating rock slabs
local TEAL, PTEAL = rgb(28, 98, 98), rgb(120, 170, 165)
local EZ = 88
for s = -1, 1, 2 do part("ExpCol", Vector3.new(2.4, 13, 2.4), CFrame.new(s * 7, 12.5, EZ), PTEAL, SM, nil, LM) end
for k = 0, 12 do -- pointed-round arch of segments, top at about 21 (15 above the terrace)
	local a = math.pi * k / 12
	part("ExpArch", Vector3.new(2.6, 1.6, 2.2), CFrame.new(7 * math.cos(a), 19 + 4 * math.sin(a), EZ) * CFrame.Angles(0, 0, a + math.pi / 2), TEAL, SM, nil, LM)
end
local fld = part("ExpField", Vector3.new(11.6, 15, 0.4), CFrame.new(0, 13.5, EZ), rgb(40, 140, 140), GL, nil, LM); fld.Transparency = 0.35
part("ExpStep", Vector3.new(20, 1, 8), CFrame.new(0, 6.5, EZ), rgb(150, 155, 160), SM, nil, LM)
for s = -1, 1, 2 do
	part("BrazierBase", Vector3.new(3, 5, 3), CFrame.new(s * 13, 8.5, EZ - 2), PTEAL, SM, nil, LM)
	place("K_Crystal", CFrame.new(s * 13, 11.2, EZ - 2), 0.9, rgb(50, 170, 170), LM)
end
for k = 0, 9 do
	local a = 2 * math.pi * k / 10
	part("FloatRock", Vector3.new(4, 2, 8), CFrame.new(10 * math.cos(a), 34 + 1.5 * math.sin(3 * a), EZ + 10 * math.sin(a) * 0.35) * CFrame.Angles(rng:NextNumber(-0.4, 0.4), a, rng:NextNumber(-0.5, 0.5)), rgb(95, 92, 96), SM, nil, LM)
end
-- E: Raid, weathered red stone: gothic arch gate 14 tall, skull tower to about 44 (38 above the terrace), 2 spires
local WR, WR2, DK = rgb(115, 48, 42), rgb(135, 60, 52), rgb(40, 17, 20)
local RX = 92
for s = -1, 1, 2 do
	part("RaidPier", Vector3.new(4, 14, 4), CFrame.new(RX, 13, s * 7), WR2, SM, nil, LM)
	part("RaidArchL", Vector3.new(3, 10, 3), CFrame.new(RX, 22, s * 3.6) * CFrame.Angles(math.rad(s * 30), 0, 0), WR2, SM, nil, LM)
end
part("RaidDoor", Vector3.new(1, 15, 10), CFrame.new(RX + 1, 13.5, 0), rgb(12, 8, 12), SM, nil, LM)
part("RaidWall", Vector3.new(8, 18, 34), CFrame.new(RX + 6, 15, 0), WR, SM, nil, LM)
part("RaidTower", Vector3.new(14, 30, 14), CFrame.new(RX + 16, 21, 0), WR, SM, nil, LM)
blob("RaidSkull", Vector3.new(11, 11, 12), Vector3.new(RX + 13, 41, 0), rgb(150, 70, 62), SM, LM)
part("RaidJaw", Vector3.new(6, 3, 7), CFrame.new(RX + 11, 35.5, 0), rgb(130, 60, 52), SM, nil, LM)
for s = -1, 1, 2 do blob("RaidEye", Vector3.new(1.5, 2.6, 2.4), Vector3.new(RX + 7.9, 42, s * 2.4), DK, SM, LM) end
part("RaidBlade", Vector3.new(0.8, 26, 1.4), CFrame.new(RX + 8.9, 21, 0), rgb(200, 30, 30), NE, nil, LM)
for s = -1, 1, 2 do
	part("RaidSpire", Vector3.new(5, 20, 5), CFrame.new(RX + 4, 16, s * 19), WR, SM, nil, LM)
	blob("RaidSpireTip", Vector3.new(5, 12, 5), Vector3.new(RX + 4, 31, s * 19), DK, SM, LM)
	place("K_PalmA", CFrame.new(RX - 4, 6, s * 28) * rot(), 1.0, FR, LM, lighten(FR, 0.25))
end
-- W: Story ring portal (own torus kit piece, silver with a gold crown) with a black void, giant blue tree behind
local SX = -88
part("StoryBase", Vector3.new(6, 1.5, 14), CFrame.new(SX, 6.75, 0), rgb(170, 170, 178), SM, nil, LM)
place("K_Ring", CFrame.new(SX, 6, 0), 1.0, nil, LM)
local void = part("StoryVoid", Vector3.new(0.4, 10.2, 10.2), CFrame.new(SX, 13.5, 0), rgb(10, 10, 14), SM, Enum.PartType.Cylinder, LM)
local glow = part("StoryGlow", Vector3.new(0.3, 10.6, 10.6), CFrame.new(SX + 0.1, 13.5, 0), rgb(70, 40, 120), NE, Enum.PartType.Cylinder, LM); glow.Transparency = 0.7
place("K_GiantTree", CFrame.new(SX - 16, 6, 0) * CFrame.Angles(0, 0.6, 0), 1.0, BLUE, LM, BLUER)
for s = -1, 1, 2 do place("K_PalmB", CFrame.new(SX + 4, 6, s * 22) * rot(), 1.05, FB, LM, lighten(FB, 0.25)) end
task.wait()
-- floating islands: own kit piece (72 across) scaled 0.9-1.6, 150-300 out, 60-140 up, a tree or two on top
local ISL = Instance.new("Folder"); ISL.Name = "Islands"; ISL.Parent = root
local isl = { { -90, 95, -240, 1.3 }, { 120, 125, -270, 1.1 }, { 15, 150, -330, 1.6 }, { -130, 95, 230, 1.2 }, { 100, 115, 260, 1.4 },
	{ 250, 105, -70, 1.2 }, { 240, 80, 110, 1.0 }, { -260, 120, 60, 1.5 }, { -230, 85, -120, 1.0 }, { 170, 115, -180, 1.2 } }
for i, s in ipairs(isl) do
	local cf = CFrame.new(s[1], s[2], s[3]) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0)
	place("K_Island", cf, s[4], nil, ISL)
	local c = ({ BLUE, rgb(60, 125, 45), PURPLE, GOLDT })[i % 4 + 1]
	place(({ "K_TreeA", "K_TreeB" })[i % 2 + 1], cf * CFrame.new(-14 * s[4], 2.2 * s[4], 10 * s[4]), 1.4 * s[4], c, ISL, lighten(c, 0.35))
	if i % 2 == 0 then place("K_PalmA", cf * CFrame.new(18 * s[4], 2.2 * s[4], -16 * s[4]), 1.2 * s[4], rgb(60, 125, 45), ISL, rgb(110, 170, 70)) end
end

local n = 0; for _, d in ipairs(root:GetDescendants()) do if d:IsA("BasePart") then n += 1 end end
local sp = workspace:FindFirstChild("SpawnLocation"); if sp then sp.CFrame = CFrame.new(0, 0.6, 30); sp.Transparency = 1; sp.CanCollide = false; local dc = sp:FindFirstChildOfClass("Decal"); if dc then dc:Destroy() end end
local bp = workspace:FindFirstChild("Baseplate"); if bp then bp:Destroy() end
return "plaza parts " .. n .. ", ferns " .. nf .. ", import scale " .. IMPORT_SCALE
