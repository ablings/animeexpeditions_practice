-- build_plaza.lua (practice place only): freestyle spawn plaza, pass 6.
-- The kit (ae_kit_r6, tools/ae_kit.py build_all6 + the pass-5 pieces) is authored in plaza coordinates: the hero piece
-- (4 mirrored corners), the stairs (4 rotated flights) and the floor/medallion import already in place, so they are
-- placed at the identity CFrame. Foliage, islands, patches, landmarks are authored at the origin and instanced.
-- Frame: lower plaza floor y=0, terrace y=6, -Z = north. Stair foot 28, stair top 48 studs from the centre.
-- Idempotent: rebuilds Workspace.Plaza.
local IMPORT_SCALE = 40.5585   -- Import 3D scale of the FBX (before any 2048-stud clamp)
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
local src = workspace:FindFirstChild("ae_kit_r6")
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
assert(kit and kit:FindFirstChild("K_Hero_vault"), "no r6 kit: import kit/own/ae_kit_r6.fbx first")
local rgb = Color3.fromRGB
local SM, GL, NE, GR = Enum.Material.SmoothPlastic, Enum.Material.Glass, Enum.Material.Neon, Enum.Material.Grass
-- Colour/material per name token (the material split made in Blender).
-- Pass 6 (round-3 review item 1): neutral, lighter stone with no blue tint; vault interior slate (60,68,85) instead of
-- near black; yellower gold; softer lantern glass with a hot core. With the reference's own ambient restored
-- (fix_lighting.lua) these no longer go navy in shade.
local LOOK = {
	stone = { rgb(102, 106, 114), SM }, rib = { rgb(78, 84, 96), SM }, darkStone = { rgb(76, 82, 96), SM },
	vault = { rgb(72, 82, 100), SM }, gold = { rgb(170, 146, 50), SM, 0.05 }, blue = { rgb(48, 78, 150), SM },
	glass = { rgb(85, 140, 185), GL, 0, 0.25 }, core = { rgb(190, 235, 255), NE, 0, 0.1 },
	water = { rgb(110, 175, 195), GL, 0, 0.3 }, sheet = { rgb(150, 205, 225), GL, 0, 0.35 }, foam = { rgb(200, 235, 245), NE, 0, 0.55 },
	turf = { rgb(78, 128, 58), GR }, pale = { rgb(132, 135, 138), SM }, slate = { rgb(60, 65, 75), SM },
	white = { rgb(185, 185, 190), SM }, navy = { rgb(28, 38, 95), SM }, riser = { rgb(95, 100, 110), SM },
	wood = { rgb(140, 102, 62), SM }, rock = { rgb(150, 150, 140), SM }, grass = { rgb(110, 170, 70), SM },
	silver = { rgb(150, 153, 162), SM, 0.15 }, vine = { rgb(78, 140, 60), SM }, teal = { rgb(40, 140, 140), SM },
	patch = { rgb(90, 140, 60), GR },
}
local RUNNER_BLUE = rgb(40, 68, 140)
local function lighten(c, k) return c:Lerp(Color3.new(1, 1, 1), k) end
local function look(p, tint, rim)
	local grp, tok = p.Name:match("^K_([^_]+)_(%a+)")
	if tok and tok:sub(1, 4) == "leaf" and tint then
		p.Color = (tok == "leafRim") and (rim or lighten(tint, 0.3)) or tint; p.Material = SM
		p.CastShadow = not (grp == "Fern" or grp == "Grass" or grp == "Litter"); return
	end
	if tok and tok:sub(1, 4) == "gold" then tok = "gold" end
	local L = LOOK[tok] or LOOK.stone
	p.Color = L[1]; p.Material = L[2]; p.Reflectance = L[3] or 0; p.Transparency = L[4] or 0
	if tok == "patch" then p.Color = tint or L[1]; p.CastShadow = false end
	if tok == "blue" and (grp == "Stairs" or grp == "Medal") then p.Color = RUNNER_BLUE end
	if tok == "stone" and grp == "Stairs" then p.Color = rgb(124, 126, 130) end
	if tok == "foam" and (grp == "Island" or grp == "Isl6") then p.Color = rgb(200, 225, 240); p.Material = SM; p.Transparency = 0.35 end
	if tok == "darkStone" and grp == "Medal" then p.Color = rgb(40, 45, 55) end
	if tok == "gold" and grp == "Medal" then p.Color = rgb(165, 146, 52) end
	if tok == "white" and grp == "Isl6" then p.Color = rgb(215, 215, 205) end
	if tok == "glass" and grp == "Crystal" then p.Color = tint or rgb(60, 110, 230); p.Material = GL; p.Transparency = 0.15 end
	if tok == "wood" and tint and (grp == "DeadTree") then p.Color = tint end
	if tok == "glass" or tok == "water" or tok == "foam" or tok == "sheet" or tok == "core" or tok == "vine" then p.CastShadow = false end
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
local function blob(name, size, pos, color, mat, parent) -- non-uniform sphere for skull, glows
	local p = part(name, size, CFrame.new(pos), color, mat or SM, Enum.PartType.Ball, parent)
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	return p
end
local function tex(p, id, stud)
	local t = Instance.new("Texture"); t.Texture = id; t.Face = Enum.NormalId.Top; t.StudsPerTileU = stud; t.StudsPerTileV = stud
	t.Color3 = rgb(128, 131, 134); t.Parent = p -- a Texture covers the part colour with its own (white by default): tint it
end
local FLOOR_TEX = "rbxassetid://82579788770020"   -- own pale slab texture (tex/make_ae_tex4.py), 12 studs = 2x2 slabs
local PALE, GOLD, SLATE = LOOK.pale[1], LOOK.gold[1], LOOK.slate[1]
local rng = Random.new(11)
local function rot() return CFrame.Angles(0, rng:NextNumber(0, 6.28), 0) end
local R2 = math.sqrt(2)

-- 1. hero pieces (kit is in plaza coordinates)
for _, pre in ipairs({ "K_Hero", "K_Stairs", "K_Medal" }) do
	local m = place(pre, CFrame.new())
	for _, p in ipairs(m:GetChildren()) do pcall(function() p.CollisionFidelity = Enum.CollisionFidelity.PreciseConvexDecomposition end) end
end
-- vault lights and fountain mist (round-3 item 1/8): a small cyan PointLight in each vault, mist at the sheet's foot
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	local function at(u, y, w) return Vector3.new(qx * (w + u) / R2, y, qz * (w - u) / R2) end
	local a = part("VaultLight", Vector3.new(0.2, 0.2, 0.2), CFrame.new(at(0, 6.2, 37.5)), rgb(0, 0, 0)); a.Transparency = 1; a.CanCollide = false
	local L = Instance.new("PointLight"); L.Color = rgb(120, 200, 230); L.Range = 16; L.Brightness = 3; L.Shadows = false; L.Parent = a
	local m = part("Mist", Vector3.new(2.4, 0.2, 2.4), CFrame.new(at(0, 4.4, 30.6)), rgb(0, 0, 0)); m.Transparency = 1; m.CanCollide = false
	local e = Instance.new("ParticleEmitter"); e.Color = ColorSequence.new(rgb(220, 245, 255)); e.LightEmission = 0.4
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1.8) })
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(1, 1) })
	e.Lifetime = NumberRange.new(0.8, 1.4); e.Rate = 18; e.Speed = NumberRange.new(1.5, 3); e.SpreadAngle = Vector2.new(35, 35)
	e.Acceleration = Vector3.new(0, -2, 0); e.Parent = m
end end
task.wait()

-- 2. ground: sunken plaza floor (y 0) inside the terrace (y 6), one neutral grass terrace, organic zone patches on top
tex(part("PlazaFloor", Vector3.new(96, 2, 96), CFrame.new(0, -1, 0), PALE), FLOOR_TEX, 12)
local ZBASE = rgb(78, 128, 56)
part("GroundN", Vector3.new(1700, 6, 800), CFrame.new(0, 3, -48 - 400), ZBASE, GR)
part("GroundS", Vector3.new(1700, 6, 800), CFrame.new(0, 3, 48 + 400), ZBASE, GR)
part("GroundE", Vector3.new(800, 6, 96), CFrame.new(48 + 400, 3, 0), ZBASE, GR)
part("GroundW", Vector3.new(800, 6, 96), CFrame.new(-48 - 400, 3, 0), ZBASE, GR)
part("WaterEdge", Vector3.new(4000, 1, 4000), CFrame.new(0, -2.6, 0), rgb(70, 130, 160), GL).Transparency = 0.2
local G = Instance.new("Folder"); G.Name = "Zoning"; G.Parent = root
local GRAVEL, REDL, WATERC, SAND, WHITEF, GREEN2 = rgb(95, 95, 100), rgb(170, 42, 38), rgb(90, 170, 200), rgb(176, 160, 118), rgb(225, 228, 235), rgb(96, 150, 58)
local function patch(kind, x, z, sc, col, layer, mat)
	local m = place("K_Patch" .. kind, CFrame.new(x, 6.0 + 0.05 * layer, z) * rot(), sc, col, G)
	if mat then for _, p in ipairs(m:GetChildren()) do p.Material = mat end end
	return m
end
local function zoneAt(x, z) -- which zone owns (x, z): wedges by angle, organic edges come from the patches themselves
	if math.abs(x) >= math.abs(z) then return x > 0 and "E" or "W" end
	return z > 0 and "S" or "N"
end
local function inPlaza(x, z, pad) -- keep patches off the plaza ring / arms: plaza square 62 + pad, arm strips
	pad = pad or 6
	if math.abs(x) < 62 + pad and math.abs(z) < 62 + pad then return true end
	if math.abs(x) < 20 + pad and z < 0 and z > -160 then return true end -- N avenue
	return false
end
local nPatch = 0
for i = 1, 260 do
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(70, 260)
	local x, z = r * math.cos(a), r * math.sin(a)
	if not inPlaza(x, z, 8) then
		local zn = zoneAt(x, z); local k = ({ "A", "B", "C" })[i % 3 + 1]
		if zn == "E" then
			patch(k, x, z, rng:NextNumber(1.0, 1.8), GRAVEL, 1, Enum.Material.Slate)
			if i % 3 ~= 0 then patch(({ "B", "C" })[i % 2 + 1], x + rng:NextNumber(-8, 8), z + rng:NextNumber(-8, 8), rng:NextNumber(0.8, 1.4), REDL, 2, SM) end
			if i % 7 == 0 then patch("C", x + 10, z - 6, 0.8, GREEN2, 3, GR) end
		elseif zn == "W" then
			if i % 4 == 0 then patch(k, x, z, rng:NextNumber(0.6, 1.1), WATERC, 2, GL)
			elseif i % 4 == 1 then patch("C", x, z, rng:NextNumber(0.5, 0.9), WHITEF, 2, SM)
			else patch(k, x, z, rng:NextNumber(0.9, 1.5), rgb(70, 125, 75), 1, GR) end
		else
			if i % 3 == 0 then patch(k, x, z, rng:NextNumber(0.6, 1.2), SAND, 1, Enum.Material.Sand)
			else patch(k, x, z, rng:NextNumber(0.9, 1.6), (i % 2 == 0) and GREEN2 or rgb(70, 118, 50), 1, GR) end
		end
		nPatch += 1
	end
	if i % 40 == 0 then task.wait() end
end

-- 3. arms on the terrace: N long avenue with a water channel to the Summon hall; E/W/S narrow arms ending about 82 out
local function arm(i, width, len, channel)
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a))
	local r = CFrame.lookAt(Vector3.zero, dir)
	local function at(d, y) return CFrame.new(dir * d + Vector3.new(0, y, 0)) * r end
	tex(part("Arm" .. i, Vector3.new(width, 1, len), at(48 + len / 2, 5.6), PALE), FLOOR_TEX, 12)
	for s = -1, 1, 2 do part("ArmEdge" .. i, Vector3.new(0.6, 0.12, len), at(48 + len / 2, 6.12) * CFrame.new(s * (width / 2 - 0.6), 0, 0), GOLD) end
	if channel then
		part("Channel" .. i, Vector3.new(6, 0.2, len - 4), at(48 + len / 2 + 2, 5.75), LOOK.water[1], GL).Transparency = 0.15
		part("ChannelBed" .. i, Vector3.new(6, 0.2, len - 4), at(48 + len / 2 + 2, 5.3), rgb(50, 95, 125))
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
		part("TipGem" .. i, Vector3.new(2.2, 0.16, 2.2), at(e, 6.15) * CFrame.Angles(0, math.rad(45), 0), rgb(85, 160, 210), NE).Transparency = 0.3
	end
end
arm(0, 37, 104, true); arm(1, 17, 22); arm(2, 17, 22); arm(3, 17, 22)
task.wait()

-- 4. bollards: 4 on the diagonals at the dais edge, facing the gates
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	place("K_Bollard", CFrame.new(qx * 9.6, 0.3, qz * 9.6) * CFrame.Angles(0, math.atan2(qx, qz), 0))
end end

-- 5. planting (round-3 item 3): few palms, big fluffy broadleaf trees in gold / purple / blue, bare red trees east.
local P = Instance.new("Folder"); P.Name = "Planting"; P.Parent = root
local BLUE, BLUER, PURPLE, GOLDT, RED = rgb(45, 95, 235), rgb(120, 170, 255), rgb(150, 110, 210), rgb(215, 170, 40), rgb(160, 34, 40)
local FB = rgb(55, 110, 235)
local PALMWOOD = rgb(150, 110, 60)
local function palm(name, x, z, sc, frond, lean, yaw, parent, y)
	-- palm bends toward +X in the kit; yaw turns the bend outward, lean tilts the whole trunk a little more
	-- the imported kit is yawed 180 deg against the authoring frame (x and z both flip), so add pi to point the bend outward
	local m = place(name, CFrame.new(x, y or 6, z) * CFrame.Angles(0, yaw + math.pi, 0) * CFrame.Angles(0, 0, -math.rad(lean)), sc, frond, parent or P, lighten(frond, 0.3))
	for _, p in ipairs(m:GetChildren()) do if p.Name:find("_wood") then p.Color = PALMWOOD end end
	return m
end
local function fluffy(name, x, y, z, sc, col, parent)
	local m = place(name, CFrame.new(x, y, z) * rot(), sc, col, parent or P, lighten(col, 0.35))
	for _, p in ipairs(m:GetChildren()) do if p.Name:find("_wood") then p.Color = rgb(130, 92, 60) end end
	return m
end
local FERN = { E = rgb(170, 50, 45), W = rgb(55, 110, 200), S = rgb(95, 150, 45), N = rgb(60, 105, 210) }
local TREEZ = { N = { GOLDT, PURPLE, BLUE }, W = { BLUE, BLUE, rgb(60, 160, 170) }, E = { RED, GOLDT, RED }, S = { rgb(95, 160, 60), GOLDT, BLUE } }
-- behind each gate, on the pool rock: a fluffy blue tree with 2 floating crystals (between the lanterns)
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	fluffy("K_FluffyS", qx * 38.9, 9.4, qz * 38.9, 1.25, BLUE)
	for s = -1, 1, 2 do
		local u, w = s * 5.5, 50
		local x, z = qx * math.abs((w + u) / R2), qz * math.abs((u - w) / R2)
		place("K_Crystal", CFrame.new(x, 16 + 2 * s, z) * rot() * CFrame.Angles(0.3, 0, 0.2), 1.1, rgb(70, 130, 240), P)
	end
end end
-- N avenue: 2 palms per side (about 22 tall), leaning consistently outward; gold tree left, purple wisteria right
for k = 0, 1 do
	for s = -1, 1, 2 do
		palm(k == 0 and "K_Palm6A" or "K_Palm6B", s * 23, -64 - 26 * k, 1.0 + 0.05 * k, FB, 6, s > 0 and 0 or math.pi)
	end
end
fluffy("K_Fluffy", -24, 6, -100, 1.15, GOLDT)
fluffy("K_Fluffy", -34, 6, -128, 0.9, GOLDT)
fluffy("K_Wisteria", 22, 6, -88, 1.0, PURPLE)
fluffy("K_Wisteria", 30, 6, -106, 0.85, PURPLE)
fluffy("K_FluffyS", 26, 6, -128, 1.1, rgb(60, 170, 175))
-- per quadrant behind the pools: 1 palm, 2 fluffy trees (zone colours)
local corner = { { 1, -1 }, { -1, -1 }, { 1, 1 }, { -1, 1 } }
for ci, q in ipairs(corner) do
	local qx, qz = q[1], q[2]
	local x, z = qx * 74, qz * 56
	local zn = zoneAt(x, z)
	palm(ci % 2 == 0 and "K_Palm6A" or "K_Palm6B", x, z, 1.0, zn == "E" and RED or (zn == "S" and rgb(80, 150, 55) or FB), 5, math.atan2(-qz, qx))
	fluffy("K_Fluffy", qx * 96, 6, qz * 84, 0.95, TREEZ[zoneAt(qx * 96, qz * 60)][ci % 3 + 1])
	fluffy("K_FluffyS", qx * 66, 6, qz * 96, 1.3, TREEZ[zoneAt(qx * 40, qz * 96)][(ci + 1) % 3 + 1])
end
-- outer ring: 16 trees and palms, 105-200 out
for i = 1, 16 do
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(110, 200)
	local x, z = r * math.cos(a), r * math.sin(a)
	if not inPlaza(x, z, 20) then
		local zn = zoneAt(x, z)
		if i % 4 == 0 then palm("K_Palm6A", x, z, rng:NextNumber(1.0, 1.2), zn == "E" and RED or FB, 6, rng:NextNumber(0, 6.28))
		elseif zn == "E" and i % 2 == 0 then place("K_DeadTree", CFrame.new(x, 6, z) * rot(), rng:NextNumber(1.0, 1.4), rgb(95, 30, 32), P)
		else fluffy(i % 3 == 0 and "K_FluffyS" or "K_Fluffy", x, 6, z, rng:NextNumber(0.9, 1.3), TREEZ[zn][i % 3 + 1]) end
	end
end
task.wait()
-- stairs and floor dressing (round-3 item 9): grass/litter spilling over the step edges, 8 per flight, plus floor patches
local function stepY(d) return math.clamp(math.floor((d - 28) / 2.5) + 1, 0, 8) * 0.75 end
local FLIGHT = { [0] = rgb(70, 115, 230), [1] = rgb(180, 45, 40), [2] = rgb(95, 160, 50), [3] = rgb(95, 160, 50) } -- N blue, E red, S/W green
local nf = 0
for i = 0, 3 do
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a)); local side = Vector3.new(math.cos(a), 0, math.sin(a))
	for k = 1, 8 do
		local d = rng:NextNumber(28.5, 47); local lat = (k % 2 == 0 and 1 or -1) * rng:NextNumber(6.5, 16)
		local p = dir * d + side * lat
		place("K_Litter", CFrame.new(p.X, stepY(d), p.Z) * rot(), rng:NextNumber(0.9, 1.3), FLIGHT[i], P); nf += 1
		if k % 2 == 0 then place("K_Fern", CFrame.new(p.X, stepY(d), p.Z) * rot(), rng:NextNumber(0.9, 1.2), FLIGHT[i], P); nf += 1 end
	end
	for k = 1, 3 do -- floor patches 3-6 wide at the stair feet
		local d = rng:NextNumber(20, 26); local lat = (k % 2 == 0 and 1 or -1) * rng:NextNumber(8, 15)
		local p = dir * d + side * lat
		place("K_Litter", CFrame.new(p.X, 0, p.Z) * rot(), rng:NextNumber(0.6, 0.85), FLIGHT[i]:Lerp(rgb(60, 70, 60), 0.2), P); nf += 1
	end
end
for qx = -1, 1, 2 do for qz = -1, 1, 2 do -- basin feet: ferns either side of each basin
	for k = 1, 4 do
		local u = (k <= 2 and -1 or 1) * rng:NextNumber(6.5, 8.5); local w = rng:NextNumber(26, 31)
		local x, z = qx * math.abs((w + u) / R2), qz * math.abs((u - w) / R2)
		place("K_Fern", CFrame.new(x, 0, z) * rot(), rng:NextNumber(1.0, 1.35), FERN[zoneAt(x * (k <= 2 and 2 or 0.5), z * (k <= 2 and 0.5 or 2))], P); nf += 1
	end
end end
for i = 1, 60 do -- terrace carpet: ferns and litter in zone colours
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(52, 130)
	local x, z = r * math.cos(a), r * math.sin(a)
	if math.abs(x) < 20 or math.abs(z) < 20 then continue end
	if math.abs(x) < 62 and math.abs(z) < 62 then continue end
	local zn = zoneAt(x, z)
	place(i % 2 == 0 and "K_Litter" or "K_Fern", CFrame.new(x, 6.3, z) * rot(), rng:NextNumber(1.2, 1.8), FERN[zn], P); nf += 1
end
task.wait()

-- 6. landmarks at each arm end (round-3 item 7)
local LM = Instance.new("Folder"); LM.Name = "Landmarks"; LM.Parent = root
-- N: Summon hall (as pass 5)
local CREAM, CREAMD = rgb(200, 190, 160), rgb(150, 140, 115)
local HZ = -170
part("SummonHall", Vector3.new(48, 18, 18), CFrame.new(0, 15, HZ), CREAM, SM, nil, LM)
part("SummonCornice", Vector3.new(51, 1.6, 20), CFrame.new(0, 24.5, HZ), GOLD, SM, nil, LM)
part("SummonAttic", Vector3.new(30, 5, 14), CFrame.new(0, 27.5, HZ), CREAM, SM, nil, LM)
blob("SummonDome", Vector3.new(20, 18, 20), Vector3.new(0, 31, HZ), rgb(175, 140, 50), SM, LM)
part("SummonFinial", Vector3.new(1, 5, 1), CFrame.new(0, 41.5, HZ), GOLD, SM, nil, LM)
for k = -3, 3 do
	part("SummonCol", Vector3.new(1.6, 14, 1.6), CFrame.new(k * 6.6, 13, HZ + 10.5), CREAM, SM, nil, LM)
	if k < 3 then part("SummonArch", Vector3.new(0.8, 5.2, 5.2), CFrame.new(k * 6.6 + 3.3, 19, HZ + 10.5) * CFrame.Angles(0, math.rad(90), 0), CREAMD, SM, Enum.PartType.Cylinder, LM) end
end
part("SummonDoor", Vector3.new(9, 12, 1), CFrame.new(0, 12, HZ + 9.1), rgb(40, 35, 60), SM, nil, LM)
part("SummonSign", Vector3.new(14, 2.4, 0.6), CFrame.new(0, 22.5, HZ + 11.6), rgb(45, 75, 160), SM, nil, LM)
for s = -1, 1, 2 do
	part("SummonTower", Vector3.new(8, 32, 8), CFrame.new(s * 28, 22, HZ), CREAM, SM, nil, LM)
	blob("SummonTowerCap", Vector3.new(9, 10, 9), Vector3.new(s * 28, 39, HZ), rgb(175, 140, 50), SM, LM)
end
-- S: Expeditions: own round-arch kit piece (teal, pale-teal columns and urns, sign, glass field), 2 crystal braziers,
-- a ring of 8 floating rock slabs (r 12, about 25 up) round a white glow
local EZ = 88
local ex = place("K_ExpArch", CFrame.new(0, 6, EZ) * CFrame.Angles(0, math.pi, 0), 1.0, nil, LM) -- kit arrives yawed 180
for _, p in ipairs(ex:GetChildren()) do
	if p.Name:find("_pale") then p.Color = rgb(150, 200, 195) end
	if p.Name:find("_glass") then p.Color = rgb(70, 190, 200); p.Material = GL; p.Transparency = 0.4 end
end
part("ExpStep", Vector3.new(26, 1, 9), CFrame.new(0, 6.5, EZ), rgb(160, 165, 168), SM, nil, LM)
for s = -1, 1, 2 do
	part("BrazierBase", Vector3.new(3, 5, 3), CFrame.new(s * 15, 8.5, EZ - 3), rgb(150, 200, 195), SM, nil, LM)
	place("K_Crystal", CFrame.new(s * 15, 11.2, EZ - 3), 0.9, rgb(50, 190, 190), LM)
end
for k = 0, 7 do
	local a = 2 * math.pi * k / 8
	part("FloatRock", Vector3.new(5, 2.4, 8), CFrame.new(12 * math.cos(a), 31 + 12 * math.sin(a) * 0.55, EZ + 4 + 3 * math.sin(a)) * CFrame.Angles(0, 0, a) * CFrame.Angles(rng:NextNumber(-0.3, 0.3), 0, 0), rgb(150, 145, 140), SM, nil, LM)
end
local eg = blob("ExpGlow", Vector3.new(7, 7, 2), Vector3.new(0, 31, EZ + 4), rgb(235, 250, 255), NE, LM); eg.Transparency = 0.2
-- E: Raid: own gothic gate kit piece in weathered red, skull tower about 40 above the terrace, 2 spires, bare trees, red glow
local WR, WR2, DK = rgb(122, 58, 52), rgb(148, 70, 60), rgb(40, 17, 20)
local RX = 90
local rg = place("K_Gothic", CFrame.new(RX, 6, 0) * CFrame.Angles(0, math.pi, 0), 1.0, nil, LM) -- kit arrives yawed 180
for _, p in ipairs(rg:GetChildren()) do if p.Name:find("_stone") then p.Color = WR2 end; if p.Name:find("_darkStone") then p.Color = rgb(14, 8, 12) end end
part("RaidTower", Vector3.new(16, 44, 16), CFrame.new(RX + 14, 28, 0), WR, SM, nil, LM)
blob("RaidSkull", Vector3.new(15, 15, 16), Vector3.new(RX + 12, 55, 0), rgb(160, 78, 68), SM, LM)
part("RaidJaw", Vector3.new(8, 4, 9), CFrame.new(RX + 9, 47.5, 0), rgb(140, 64, 56), SM, nil, LM)
for s = -1, 1, 2 do blob("RaidEye", Vector3.new(2, 3.4, 3.2), Vector3.new(RX + 4.8, 56, s * 3.2), DK, SM, LM) end
part("RaidBlade", Vector3.new(0.8, 22, 1.4), CFrame.new(RX + 5.9, 33, 0), rgb(220, 40, 40), NE, nil, LM)
local rl = part("RaidLight", Vector3.new(0.2, 0.2, 0.2), CFrame.new(RX - 3, 14, 0), rgb(0, 0, 0), SM, nil, LM); rl.Transparency = 1
local pl = Instance.new("PointLight"); pl.Color = rgb(255, 70, 60); pl.Range = 24; pl.Brightness = 2; pl.Parent = rl
for s = -1, 1, 2 do
	local sp = place("K_Spire", CFrame.new(RX + 2, 6, s * 18), 1.0, nil, LM)
	for _, p in ipairs(sp:GetChildren()) do p.Color = p.Name:find("_stone") and WR or DK end
	place("K_DeadTree", CFrame.new(RX - 8, 6, s * 26) * rot(), 1.2, rgb(95, 30, 32), LM)
	palm("K_Palm6B", RX + 6, s * 32, 1.0, RED, 5, s > 0 and math.pi / 2 or -math.pi / 2, LM)
end
-- W: Story ring portal 1.3x with a black void, giant blue tree behind with a widened tan trunk and root flare
local SX = -88
part("StoryBase", Vector3.new(7, 1.5, 18), CFrame.new(SX, 6.75, 0), rgb(170, 170, 178), SM, nil, LM)
place("K_Ring", CFrame.new(SX, 6, 0), 1.3, nil, LM)
part("StoryVoid", Vector3.new(0.4, 13.2, 13.2), CFrame.new(SX, 6 + 7.5 * 1.3, 0), rgb(15, 15, 20), SM, Enum.PartType.Cylinder, LM)
local glow = part("StoryGlow", Vector3.new(0.3, 13.8, 13.8), CFrame.new(SX + 0.12, 6 + 7.5 * 1.3, 0), rgb(70, 40, 120), NE, Enum.PartType.Cylinder, LM); glow.Transparency = 0.85
local gt = place("K_GiantTree", CFrame.new(SX - 18, 6, 0) * CFrame.Angles(0, 0.6, 0), 1.0, BLUE, LM, BLUER)
for _, p in ipairs(gt:GetChildren()) do if p.Name:find("_wood") then p.Color = rgb(130, 90, 60) end end
local trunk = part("GiantTrunk", Vector3.new(26, 16, 16), CFrame.new(SX - 18, 6 + 13, 0) * CFrame.Angles(0, 0, math.rad(90)), rgb(130, 90, 60), SM, Enum.PartType.Cylinder, LM)
for k = 0, 5 do -- root flare: 6 sloping wedges round the trunk
	local a = 2 * math.pi * k / 6 + 0.3
	part("Root", Vector3.new(4, 7, 9), CFrame.new(SX - 18 + 9 * math.cos(a), 8.5, 9 * math.sin(a)) * CFrame.Angles(0, -a + math.pi / 2, 0) * CFrame.Angles(math.rad(-35), 0, 0), rgb(120, 82, 55), SM, nil, LM)
end
for s = -1, 1, 2 do palm("K_Palm6A", SX + 4, s * 22, 1.05, FB, 6, s > 0 and math.pi / 2 or -math.pi / 2, LM) end
task.wait()

-- 7. skyline (round-3 item 2): own island kit piece (80 across) at 1.3-1.9x, grey rock, thick green caps, vines,
-- white ruined towers; 4 to the N/NE at 150-330 out, 4 elsewhere; trees on top
local ISL = Instance.new("Folder"); ISL.Name = "Islands"; ISL.Parent = root
local isl = { { -70, 105, -250, 1.6 }, { 95, 130, -235, 1.4 }, { 210, 100, -170, 1.3 }, { 15, 175, -330, 1.9 },
	{ -140, 100, 240, 1.3 }, { 130, 120, 265, 1.5 }, { -270, 115, 40, 1.4 }, { 260, 95, 95, 1.2 } }
for i, s in ipairs(isl) do
	local cf = CFrame.new(s[1], s[2], s[3]) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0)
	place("K_Isl6", cf, s[4], nil, ISL)
	local c = ({ rgb(90, 160, 60), GOLDT, rgb(90, 160, 60), PURPLE })[i % 4 + 1]
	local p1 = (cf * CFrame.new(-16 * s[4], 3.4 * s[4], 14 * s[4])).Position
	local p2 = (cf * CFrame.new(20 * s[4], 3.4 * s[4], 12 * s[4])).Position
	local p3 = (cf * CFrame.new(-4 * s[4], 3.4 * s[4], -22 * s[4])).Position
	fluffy("K_Fluffy", p1.X, p1.Y, p1.Z, 1.2 * s[4], c, ISL)
	fluffy("K_FluffyS", p2.X, p2.Y, p2.Z, 1.5 * s[4], rgb(80, 150, 55), ISL)
	if i % 2 == 0 then palm("K_Palm6A", p3.X, p3.Z, 1.1 * s[4], rgb(70, 150, 60), 4, 0, ISL, p3.Y) end
end

local n = 0; for _, d in ipairs(root:GetDescendants()) do if d:IsA("BasePart") then n += 1 end end
local sp = workspace:FindFirstChild("SpawnLocation"); if sp then sp.CFrame = CFrame.new(0, 0.6, 30); sp.Transparency = 1; sp.CanCollide = false; local dc = sp:FindFirstChildOfClass("Decal"); if dc then dc:Destroy() end end
local bp = workspace:FindFirstChild("Baseplate"); if bp then bp:Destroy() end
return "plaza parts " .. n .. ", dressing " .. nf .. ", patches " .. nPatch .. ", import scale " .. IMPORT_SCALE
