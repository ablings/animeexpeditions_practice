-- pass24.lua (practice place only): freestyle pass 24 on top of the pass-23 build (notes/fix_brief24.md, verify21_plaza.md).
-- Run AFTER pass 23. Idempotent: new pieces live in Plaza.Pass24 (rebuilt each run); hidden old pieces get P24Hidden (old
-- transparency / CanCollide / CanQuery in P24T / P24CC / P24CQ); recoloured old pieces keep their pre-pass-24 colour/material in
-- P24Col / P24Mat; retuned lights keep P24LCol / P24LB / P24LR.
-- Blocks: --SKY24, --GROUND24, --RAID24, --STAIR24, --RUN24, --TUNNEL24. Kit pieces (ae_kit_r24) are optional: every block has a
-- Studio-only fallback so the file also runs before the import.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE, ME, SL, GR = Enum.Material.SmoothPlastic, Enum.Material.Neon, Enum.Material.Metal, Enum.Material.Slate, Enum.Material.Grass
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r24 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r24")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale24_stone", true)
		local sc = ref and ref.Size.X / 10.0 or 1
		for _, d in ipairs(src:GetDescendants()) do
			if d:IsA("MeshPart") then
				d.Size = d.Size / sc
				d.CFrame = CFrame.new(d.Position / sc) * (d.CFrame - d.CFrame.Position)
				d.Anchored = true
				local old = kit:FindFirstChild(d.Name); if old then old:Destroy() end
				if d.Name:sub(1, 7) == "K_Scale" then d:Destroy() else d.Parent = kit end
			end
		end
		src:Destroy()
	end
end
-- bbox centres of the r24 pieces in their authored frame (kit/own/ae_kit_r24_centres.json): placement = origin + centre
local C24 = {
--C24
	K_Gem24_gem = { 0.0, 1.075, 0.0 },
	K_Gem24_gold = { 0.0, 0.899, 0.0 },
	K_RunY24_core = { 0.0, 2.435, 0.0 },
	K_RunY24_gold = { 0.0, 2.459, 0.0 },
	K_Runner24_gold = { 0.0, 3.321, 0.0 },
	K_Stairs24_joint = { 0.0, 2.94, 0.0 },
	K_Stairs24_riser = { 0.0, 3.0, 0.0 },
	K_Stairs24_stone = { 0.0, 3.0, 0.0 },
	K_Tree24_bark = { 6.841, 42.0, -4.249 },
	K_Tree24_crown = { 10.395, 82.202, -1.137 },
	K_Tree24_crownRim = { 10.357, 85.887, -1.541 },
}
local old = root:FindFirstChild("Pass24"); if old then old:Destroy() end
local P24 = Instance.new("Folder"); P24.Name = "Pass24"; P24.Parent = root
local P23, P22, P19, P18, P17, P16, P15, P11, P9 = root.Pass23, root.Pass22, root.Pass19, root.Pass18, root.Pass17, root.Pass16, root.Pass15, root.Pass11, root.Pass9
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P24
	return p
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P24T") == nil then d:SetAttribute("P24T", d.Transparency); d:SetAttribute("P24CC", d.CanCollide); d:SetAttribute("P24CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P24Hidden", true)
		end
		if d:IsA("Decal") or d:IsA("Texture") then
			if d:GetAttribute("P24T") == nil then d:SetAttribute("P24T", d.Transparency) end
			d.Transparency = 1; d:SetAttribute("P24Hidden", true)
		end
		if d:IsA("ParticleEmitter") or d:IsA("PointLight") or d:IsA("SpotLight") then
			if d:GetAttribute("P24En") == nil then d:SetAttribute("P24En", d.Enabled) end
			d.Enabled = false; d:SetAttribute("P24Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P24Col") == nil then p:SetAttribute("P24Col", p.Color); p:SetAttribute("P24Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function relight(l, col, b, r)
	if l:GetAttribute("P24LCol") == nil then l:SetAttribute("P24LCol", l.Color); l:SetAttribute("P24LB", l.Brightness); l:SetAttribute("P24LR", l.Range) end
	if col then l.Color = col end; if b then l.Brightness = b end; if r then l.Range = r end
end
-- restore everything pass 24 touched, so every run starts from the pass-23 state
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P24Hidden") then
		if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then d.Transparency = d:GetAttribute("P24T") end
		if d:IsA("BasePart") and d:GetAttribute("P24CC") ~= nil then d.CanCollide = d:GetAttribute("P24CC"); d.CanQuery = d:GetAttribute("P24CQ") end
		if d:GetAttribute("P24En") ~= nil then d.Enabled = d:GetAttribute("P24En") end
		d:SetAttribute("P24Hidden", nil)
	end
	if d:GetAttribute("P24Col") ~= nil then d.Color = d:GetAttribute("P24Col"); d.Material = Enum.Material[d:GetAttribute("P24Mat")] end
	if d:GetAttribute("P24LCol") ~= nil then d.Color = d:GetAttribute("P24LCol"); d.Brightness = d:GetAttribute("P24LB"); d.Range = d:GetAttribute("P24LR") end
end
local function has(name) return kit and kit:FindFirstChild(name) ~= nil end
-- place a r24 kit piece: origin CFrame o, centre from C24 rotated with it, optional uniform scale s
local function kp(name, o, col, mat, parent, newName, s)
	local src = kit and kit:FindFirstChild(name); if not src or not C24[name] then return nil end
	s = s or 1
	local c = src:Clone(); c.Name = newName or name:gsub("^K_", ""); c.Anchored = true; c.CanCollide = false; c.CanQuery = false
	c.Size = src.Size * s
	local cc = C24[name]; c.CFrame = o * CFrame.new(cc[1] * s, cc[2] * s, cc[3] * s)
	c.Color = col; c.Material = mat or SM; c.Parent = parent or P24
	return c
end
-- clone every older kit part <prefix>_<tok> as one model (kit pieces carry their authored offset in Position)
local function kitModel(prefix, cf, scale, parent, colf)
	local m = Instance.new("Model"); m.Name = prefix
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
			local c = k:Clone(); c.Size = k.Size * scale; c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
			c.Anchored = true; c.CanCollide = false; c.CanQuery = false
			if colf then colf(k.Name:match("_(%a+)$"), c) end
			c.Parent = m
		end
	end
	m.Parent = parent or P24; return m
end
local function kitExt(prefix)
	local lo, hi = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then lo = lo:Min(k.Position - k.Size / 2); hi = hi:Max(k.Position + k.Size / 2) end
	end
	return lo, hi
end
local function blob(name, size, pos, col, tr, parent)
	local p = part(name, size, CFrame.new(pos), col, SM, parent); p.Shape = Enum.PartType.Ball
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	p.Transparency = tr or 0; p.CanCollide = false; p.CanQuery = false; p.CastShadow = false
	return p
end
local function light(parent, pos, col, b, r)
	local a = part("Light24", Vector3.new(0.3, 0.3, 0.3), CFrame.new(pos), rgb(255, 255, 255), SM, parent)
	a.Transparency = 1; a.CanCollide = false; a.CanQuery = false
	local l = Instance.new("PointLight"); l.Color = col; l.Brightness = b; l.Range = r; l.Shadows = false; l.Parent = a
	return a, l
end
local report = {}

-- ================================================================ item 1: open N and S sky. The reference fills the upper third of p2 / c4
-- with near, big floating islands (grey rock underside, green cap, vines, falls) and a giant tree behind the Expeditions gate.
-- p1 ref box (618-622, 28-32) (176,202,164) is an island underside. Goal: top-half saturation p2 127 -> ~101, c4 121 -> ~89.
-- Islands reuse the pass-7 slab island kit (K_Isl77x: rock, grass, vine); top-centre placement, rock turned to face the plaza.
--SKY24
local SKY = {
	rock = rgb(170, 168, 158), grass = rgb(120, 165, 80), vine = rgb(95, 150, 70),
	isl = { -- prefix, top centre x, y, z, scale, extra yaw
		{ "K_Isl771", -75, 125, 215, 1.35, 0.15 }, { "K_Isl772", 105, 140, 255, 1.35, -0.2 }, { "K_Isl773", 10, 190, 320, 1.4, 0 },
		{ "K_Isl772", 0, 150, -215, 1.6, 0.1 }, { "K_Isl771", -135, 175, -270, 1.3, -0.25 },
	},
	fall = rgb(190, 235, 250), fallT = 0.2,
	tree = { x = -24, z = 118, base = 4, bark = rgb(120, 98, 82), crown = rgb(70, 150, 140), crownRim = rgb(110, 185, 165), s = 1 },
}
do
	local F = Instance.new("Folder"); F.Name = "Sky24"; F.Parent = P24
	local n = 0
	for i, s in ipairs(SKY.isl) do
		local pre, sc = s[1], s[5]
		if kit:FindFirstChild(pre .. "_rock") then
			local lo, hi = kitExt(pre)
			local gr = kit[pre .. "_grass"] -- top = the grass cap (the ruin tower pokes above it)
			local topC = Vector3.new((lo.X + hi.X) / 2, gr.Position.Y + gr.Size.Y / 2, (lo.Z + hi.Z) / 2)
			local pos = Vector3.new(s[2], s[3], s[4])
			local cf = CFrame.lookAt(Vector3.new(s[2], 0, s[4]), Vector3.new(0, 0, 0)) * CFrame.Angles(0, s[6], 0)
			cf = cf - cf.Position + pos
			local m = kitModel(pre, cf * CFrame.new(-topC * sc), sc, F, function(tok, c)
				c.CastShadow = false
				if tok == "rock" then c.Color = SKY.rock; c.Material = SL
				elseif tok == "grass" then c.Color = SKY.grass; c.Material = GR
				elseif tok == "vine" then c.Color = SKY.vine; c.Material = SM
				elseif tok == "fall" then c.Color = SKY.fall; c.Material = SM; c.Transparency = (s[4] < 0) and 1 or SKY.fallT -- N islands: the kit fall drops straight down the middle of c4 (in front of Summon); ribbons below instead
				elseif tok == "white" then c.Color = rgb(222, 220, 210); c.Material = SM end
			end)
			m.Name = "Isl24_" .. i; n += 1
			-- N islands: two translucent ribbons (pass-23 kit) off the c4 centre line, from under the rim
			if s[4] < 0 and kit:FindFirstChild("K_Ribbon23_water") then
				for _, fx in ipairs({ -38, 30 }) do
					local r = kit.K_Ribbon23_water:Clone(); r.Name = "IslFall24"; r.Anchored = true; r.CanCollide = false; r.CanQuery = false; r.CastShadow = false
					local H = 55; r.Size = Vector3.new(r.Size.X * 1.2, H, r.Size.Z)
					r.CFrame = CFrame.new(s[2] + fx, s[3] - 40 - H / 2, s[4] + 32); r.Color = SKY.fall; r.Material = SM; r.Transparency = 0.25; r.Parent = m
				end
			end
			-- crown foliage on the cap: two kit soft trees (green), so the island reads lush from below
			for j, o in ipairs({ { -0.28, 0.1 }, { 0.22, -0.05 } }) do
				local w = (hi.X - lo.X) * sc
				local p = (cf * CFrame.new(o[1] * w, 0, o[2] * w)).Position
				local tp = (j == 1) and "K_Soft14U" or "K_Soft14C"
				if kit:FindFirstChild(tp .. "_wood") then
					local tlo = kitExt(tp)
					kitModel(tp, CFrame.new(p - Vector3.new(0, tlo.Y * 2.2 * sc / 1.35, 0)) * CFrame.Angles(0, i + j, 0), 2.2 * sc / 1.35, m, function(tok, c)
						c.CastShadow = false
						if tok == "wood" then c.Color = rgb(110, 90, 70) else c.Color = (tok == "leafRim") and rgb(150, 200, 95) or rgb(95, 160, 70); c.Material = SM end
					end)
				end
			end
		end
	end
	-- giant tree behind the Expeditions gate: kit r24 trunk + crown if imported, else the older K_GiantTree scaled up
	local T = SKY.tree
	if has("K_Tree24_bark") then
		local o = CFrame.new(T.x, T.base, T.z) * CFrame.Angles(0, 0.3, 0)
		-- no shadows: the crown's shadow darkened the gate door and the S lawn boxes
		kp("K_Tree24_bark", o, T.bark, SM, F, "Tree24_bark", T.s).CastShadow = false
		kp("K_Tree24_crown", o, T.crown, SM, F, "Tree24_crown", T.s).CastShadow = false
		kp("K_Tree24_crownRim", o, T.crownRim, SM, F, "Tree24_crownRim", T.s).CastShadow = false
		table.insert(report, "tree24 kit")
	elseif kit:FindFirstChild("K_GiantTree_wood") then
		local lo = kitExt("K_GiantTree"); local sc = 2.2
		kitModel("K_GiantTree", CFrame.new(T.x, T.base - lo.Y * sc, T.z), sc, F, function(tok, c)
			c.CastShadow = false
			if tok == "wood" then c.Color = T.bark else c.Color = (tok == "leafRim") and T.crownRim or T.crown; c.Material = SM end
		end).Name = "GiantTree24"
		table.insert(report, "tree24 fallback")
	end
	table.insert(report, "sky24 islands " .. n)
end
--ENDSKY24

-- ================================================================ item 2: E red carpet (194,82,75) p8 ref (1160-1164, 526-530) under the red trees
-- (p7 E red ~18 %, p8 ~35 %); lime disc decals (GrassHole18/19) off; W pools (Lagoon11, Lagoon16/LagoonDeep16) off -> lawn + canopy;
-- S lawn (117,178,87) -> (92,123,54) p7 ref (898-902, 618-622).
--GROUND24
local GROUND = { carpet = rgb(155, 55, 35), carpetMat = SM, eGrassToRed = true, holes = "hide", lawnS = rgb(42, 57, 0), lawnSMat = Enum.Material.LeafyGrass,
	path = rgb(100, 100, 96), seGreen = rgb(88, 138, 52),
	westPools = "hide", westTrees = 3 }
do
	local F = Instance.new("Folder"); F.Name = "Ground24"; F.Parent = P24
	-- carpet under everything E of the plaza (x > 52), the grey path patches and trees stay on top
	if GROUND.carpet then
		-- p8 ref: red reaches the plaza edge on the N half, a green lawn band hugs it on the S half (red from x ~73), red ends at z ~ +85
		part("Carpet24", Vector3.new(170, 0.2, 135), CFrame.new(75 + 85, 6.08, -42.5), GROUND.carpet, GROUND.carpetMat, F).CanQuery = false
		part("Carpet24n", Vector3.new(22, 0.2, 130), CFrame.new(54 + 11, 6.08, -45), GROUND.carpet, GROUND.carpetMat, F).CanQuery = false
	end
	-- p8 ref: a wide dark cobble path runs E from the plaza through the red (rows 330-450 -> z -18..+14)
	if GROUND.path then part("Path24", Vector3.new(90, 0.2, 26), CFrame.new(102, 6.42, -3), GROUND.path, SL, F).CanQuery = false end
	local nr, nh, ng = 0, 0, 0
	for _, d in ipairs(root.Zoning:GetDescendants()) do
		-- p7 ref: a green lawn band hugs the plaza on the SE (x < 74, z > 15): the old red patches there turn lawn green
		if d:IsA("BasePart") and d.Material == SM and d.Color.R > 0.6 and d.Color.G < 0.3 and d.Position.X < 74 and d.Position.Z > 15 and GROUND.seGreen then
			recol(d, GROUND.seGreen, GR); ng += 1
		end
		if d:IsA("BasePart") and d.Material == GR and ((d.Position.X > 74 and d.Position.Z < 25) or (d.Position.X > 52 and d.Position.Z < 20)) and GROUND.eGrassToRed then recol(d, GROUND.carpet, GROUND.carpetMat); nr += 1 end
	end
	for _, f in ipairs({ P18, P19 }) do
		for _, d in ipairs(f:GetDescendants()) do
			if d:IsA("BasePart") and (d.Name == "GrassHole18" or d.Name == "GrassHole19") and GROUND.holes == "hide" then hide(d); nh += 1 end
		end
	end
	if GROUND.lawnS then recol(root.GroundS, GROUND.lawnS, GROUND.lawnSMat) end
	local nw = 0
	if GROUND.westPools == "hide" then
		for _, d in ipairs(P11:GetChildren()) do if d.Name == "Lagoon11" then hide(d); nw += 1 end end
		local W = P16:FindFirstChild("West16")
		if W then for _, d in ipairs(W:GetChildren()) do if d.Name == "Lagoon16" or d.Name == "LagoonDeep16" then hide(d); nw += 1 end end end
	end
	table.insert(report, string.format("ground24 red %d green %d holes %d pools %d", nr, ng, nh, nw))
end
--ENDGROUND24

-- ================================================================ item 3: Raid red mass. Skull (147,107,104) p3 rep (721-725, 44-48) -> (207,108,93)
-- p3 ref (718-722, 38-42); a red glow round the facade at door height (226,124,111) p3 ref (598-602, 218-222) (practice box there
-- lands on the K_RTower7 dome); brick tower (108,80,95) c3 rep (1328-1332, 298-302) RaidFacadeCap -> red rock (176,77,62) c3 ref
-- (1348-1352, 278-282); 2-3 rock spires.
--RAID24
local RAID = { bone = rgb(185, 105, 85), boneMat = SM, light = { b = 5 }, rock = rgb(165, 48, 20), rockMat = SL,
	glow = rgb(240, 135, 115), glowT = 0.45, spire = rgb(150, 44, 34) }
do
	local F = Instance.new("Folder"); F.Name = "Raid24"; F.Parent = P24
	local sk = P15:FindFirstChild("K_Skull15")
	local bone = sk and sk:FindFirstChild("K_Skull15_bone")
	if bone and RAID.bone then recol(bone, RAID.bone, RAID.boneMat) end
	local l22 = P22:FindFirstChild("SkullLight22"); local pl = l22 and l22:FindFirstChildOfClass("PointLight")
	if pl and RAID.light then relight(pl, RAID.light.col, RAID.light.b, RAID.light.r) end
	local r11 = P11:FindFirstChild("Raid11"); local nt = 0
	if r11 and RAID.rock then
		for _, d in ipairs(r11:GetChildren()) do
			if d:IsA("BasePart") and (d.Name == "RaidFacade" or d.Name == "RaidFacadeCap") then recol(d, RAID.rock, RAID.rockMat); nt += 1 end
		end
		for _, m in ipairs(r11:GetChildren()) do
			if m.Name == "K_RTower7" then for _, d in ipairs(m:GetChildren()) do
				if d:IsA("BasePart") and (d.Name:find("_stone") or d.Name:find("_dome") or d.Name:find("_darkStone")) then recol(d, RAID.rock, RAID.rockMat); nt += 1 end
			end end
		end
	end
	-- red glow round the facade: soft translucent blobs either side of the door, from door height up the towers
	if RAID.glow then
		for _, g in ipairs({ { 138, 22, -24, 30, 26 }, { 138, 22, 24, 30, 26 }, { 140, 46, -34, 26, 34 }, { 140, 46, 34, 26, 34 }, { 136, 12, 0, 40, 14 } }) do
			blob("RaidGlow24", Vector3.new(2, g[5], g[4]), Vector3.new(g[1], g[2], g[3]), RAID.glow, RAID.glowT, F)
		end
	end
	-- rock spires: older kit spire (K_Spire_stone) scaled, red rock, leaning out from behind the facade
	if RAID.spire and kit:FindFirstChild("K_Spire_stone") then
		for i, s in ipairs({ { 170, -30, 3.2, 0.12 }, { 175, 27, 2.7, -0.15 }, { 182, -8, 3.6, 0.05 } }) do
			local lo = kitExt("K_Spire")
			kitModel("K_Spire", CFrame.new(s[1], 6, s[2]) * CFrame.Angles(s[4], i, s[4] * 0.7) * CFrame.new(0, -lo.Y * s[3], 0), s[3], F, function(tok, c)
				c.Color = RAID.spire; c.Material = SL
			end).Name = "RaidSpire24"
		end
	end
	table.insert(report, "raid24 tower parts " .. nt)
end
--ENDRAID24

-- ================================================================ item 4: stair treads. Long slabs, mottled Slate (193,196,185) c4 rep (398-402,
-- 688-692) -> flat grey stone (186,191,185) in 4-5 stud blocks with a dark 0.15-0.2 chamfer line (99,113,122) c4 ref (428-432, 638-642).
-- Kit r24: K_Stairs24_stone (blocks) + K_Stairs24_joint (dark joint strips) + K_Stairs24_riser.
--STAIR24
local STAIR = { tread = rgb(126, 129, 125), mat = SM, joint = rgb(85, 95, 105) }
do
	local s23, r23 = P23:FindFirstChild("Stairs23_stone"), P23:FindFirstChild("Stairs23_riser")
	if has("K_Stairs24_stone") and s23 then
		local a = kp("K_Stairs24_stone", CFrame.new(), STAIR.tread, STAIR.mat, P24, "Stairs24_stone"); a.CanCollide = true; a.CanQuery = true
		kp("K_Stairs24_riser", CFrame.new(), r23.Color, r23.Material, P24, "Stairs24_riser")
		kp("K_Stairs24_joint", CFrame.new(), STAIR.joint, SM, P24, "Stairs24_joint")
		hide(s23); hide(r23)
		table.insert(report, "stair24 kit")
	elseif s23 then recol(s23, STAIR.tread, STAIR.mat); table.insert(report, "stair24 recolour") end
end
--ENDSTAIR24

-- ================================================================ item 5: runner Y outlined (two 0.3 gold lines, dark blue core) in the middle third,
-- gold (183,175,89) c4 ref (638-642, 558-562); a round cyan gem in a gold teardrop at the foot. Kit r24: K_RunY24_gold / _core,
-- K_Gem24_gold / _gem replace the Y tubes and the bar gem of K_Runner23_gold / _gem (the rim stays).
--RUN24
local RUN = { gold = rgb(108, 101, 44), goldMat = SM, core = rgb(25, 40, 110), gem = rgb(90, 220, 240) }
do
	if has("K_Runner24_gold") then
		local g23 = P23:FindFirstChild("Runner23_gold"); local m23 = P23:FindFirstChild("Runner23_gem")
		local rim = kp("K_Runner24_gold", CFrame.new(), g23 and g23.Color or rgb(94, 79, 5), g23 and g23.Material or SM, P24, "Runner24_rim")
		kp("K_RunY24_gold", CFrame.new(), RUN.gold, RUN.goldMat, P24, "RunY24_gold")
		kp("K_RunY24_core", CFrame.new(), RUN.core, SM, P24, "RunY24_core")
		kp("K_Gem24_gold", CFrame.new(), RUN.gold, RUN.goldMat, P24, "Gem24_gold")
		local g = kp("K_Gem24_gem", CFrame.new(), RUN.gem, NE, P24, "Gem24_gem"); if g then g.Transparency = 0.15 end
		if g23 then hide(g23) end; if m23 then hide(m23) end
		table.insert(report, "run24 kit")
	end
end
--ENDRUN24

-- ================================================================ item 10 (part): tunnel back wall (18,32,48) c1 rep (896-900, 467-471) -> (44,54,62)
-- c1 ref (878-882, 468-472): the pass-23 TunnelFill22 retune (b 0.45) overshot dark; lift it.
--TUNNEL24
local TUN = { col = rgb(160, 170, 165), b = 1.6, r = 10 }
do
	local n = 0
	local a22 = P22:FindFirstChild("Arch22")
	if a22 and TUN.b then for _, d in ipairs(a22:GetDescendants()) do
		if d:IsA("PointLight") and d.Parent.Name == "TunnelFill22" then relight(d, TUN.col, TUN.b, TUN.r); n += 1 end
	end end
	table.insert(report, "tunnel24 lights " .. n)
end
--ENDTUNNEL24

return table.concat(report, " | ") .. " | Plaza " .. #root:GetDescendants()
end
