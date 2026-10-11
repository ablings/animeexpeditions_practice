-- pass21.lua (practice place only): freestyle pass 21 on top of the pass-20 build (notes/fix_brief21.md, verify18_plaza.md).
-- Run AFTER pass 20. Idempotent: new pieces live in Plaza.Pass21 (rebuilt each run); hidden old pieces get P21Hidden (old
-- transparency / CanCollide / CanQuery in P21T / P21CC / P21CQ); recoloured old pieces keep their pre-pass-21 colour/material in
-- P21Col / P21Mat; moved models keep P21CF0 / P21Sc0; changed emitters keep P21Em*.
-- Blocks: --SKY21, --WEST21, --ARCH21, --STAIR21, --GRASS21, --RAID21, --BASIN21, --KIT21 (needs ae_kit_r21).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r21 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r21")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale21_stone", true)
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
local old = root:FindFirstChild("Pass21"); if old then old:Destroy() end
local P21 = Instance.new("Folder"); P21.Name = "Pass21"; P21.Parent = root
local P20, P19, P16, P14, P13, P12, P9 = root.Pass20, root.Pass19, root.Pass16, root.Pass14, root.Pass13, root.Pass12, root.Pass9
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P21
	return p
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P21T") == nil then d:SetAttribute("P21T", d.Transparency); d:SetAttribute("P21CC", d.CanCollide); d:SetAttribute("P21CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P21Hidden", true)
		end
		if d:IsA("Decal") or d:IsA("Texture") then
			if d:GetAttribute("P21T") == nil then d:SetAttribute("P21T", d.Transparency) end
			d.Transparency = 1; d:SetAttribute("P21Hidden", true)
		end
		if d:IsA("ParticleEmitter") or d:IsA("PointLight") or d:IsA("SpotLight") then
			if d:GetAttribute("P21En") == nil then d:SetAttribute("P21En", d.Enabled) end
			d.Enabled = false; d:SetAttribute("P21Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P21Col") == nil then p:SetAttribute("P21Col", p.Color); p:SetAttribute("P21Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function moveModel(m, cf, k)
	if m:GetAttribute("P21CF0") == nil then m:SetAttribute("P21CF0", m:GetPivot()); m:SetAttribute("P21Sc0", m:IsA("Model") and m:GetScale() or 1) end
	if m:IsA("Model") then m:ScaleTo(m:GetAttribute("P21Sc0") * (k or 1)) end
	m:PivotTo(cf or m:GetAttribute("P21CF0"))
end
local function groundY(x, z, top, incl)
	local rp = RaycastParams.new()
	if incl then rp.FilterType = Enum.RaycastFilterType.Include; rp.FilterDescendantsInstances = incl
	else
		-- exclude every pass-21 piece except the new stair blocks (grass clumps must land on them)
		local ex = {}; for _, c in ipairs(P21:GetChildren()) do if c.Name:sub(1, 8) ~= "Stairs21" then table.insert(ex, c) end end
		rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = ex
	end
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -400, 0), rp)
	return r and r.Position.Y or nil
end
-- restore everything pass 21 touched, so every run starts from the pass-20 state
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P21Hidden") then
		if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then d.Transparency = d:GetAttribute("P21T") end
		if d:IsA("BasePart") and d:GetAttribute("P21CC") ~= nil then d.CanCollide = d:GetAttribute("P21CC"); d.CanQuery = d:GetAttribute("P21CQ") end
		if d:GetAttribute("P21En") ~= nil then d.Enabled = d:GetAttribute("P21En") end
		d:SetAttribute("P21Hidden", nil)
	end
	if d:GetAttribute("P21Col") ~= nil then d.Color = d:GetAttribute("P21Col"); d.Material = Enum.Material[d:GetAttribute("P21Mat")] end
	if d:GetAttribute("P21CF0") ~= nil then
		if d:IsA("Model") then d:ScaleTo(d:GetAttribute("P21Sc0")) end
		d:PivotTo(d:GetAttribute("P21CF0"))
	end
	if d:GetAttribute("P21Em") then d.Color = d:GetAttribute("P21EmCol"); d.Size = d:GetAttribute("P21EmSize"); d.Rate = d:GetAttribute("P21EmRate") end
	if d:GetAttribute("P21TT") ~= nil then d.Transparency = d:GetAttribute("P21TT"); d:SetAttribute("P21TT", nil) end
end
local function setT(p, t) if p:GetAttribute("P21TT") == nil then p:SetAttribute("P21TT", p.Transparency) end; p.Transparency = t end
local report = {}
local function tint(m, col, rim)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("MeshPart") then
			local c = d.Name:find("leafRim") and (rim or col) or (d.Name:find("leaf") and col)
			if c then
				d.Color = c
				local sa = d:FindFirstChildOfClass("SurfaceAppearance"); if sa then pcall(function() sa.Color = c end) end
			end
		end
	end
end
-- a deterministic thinning pick: keep k of every 5 (sorted by position, so the gaps spread over the area)
local function thin(list, keepOf5)
	table.sort(list, function(a, b) local pa, pb = a:GetPivot().Position, b:GetPivot().Position; return pa.Z + 0.01 * pa.X < pb.Z + 0.01 * pb.X end)
	local hid = {}
	for i, m in ipairs(list) do if (i % 5) >= keepOf5 then table.insert(hid, m) end end
	return hid
end

-- ================================================================ item 1: background (lollipop island trees, white box towers,
-- column falls). Targets: top-half saturation (out/r21w/metrics.py) of the v18 reference frames; the lollipop crowns are
-- K_Soft15K clumps above y 55, the white box towers are Parts (IslDress12, IslTower14*), the falls are 20 stacked Neon columns.
--SKY21
local SKY = { lollipop = true, towers = true, fallsKeep = 2, fallT = 0.4, fallCol = rgb(205, 235, 250), canopies = 2,
	canopyCol = rgb(195, 215, 160), canopyRim = rgb(220, 232, 190), islGrass = rgb(170, 205, 150), islRock = rgb(185, 200, 205),
	islVine = rgb(120, 160, 110), atmoHaze = nil } -- Haze 1 measured: p1 top-half saturation 114.1 -> 119.2 (worse), p2 sky 15 off: dropped
local towerSpots = {}
do
	local n = 0
	if SKY.lollipop then
		for _, f in ipairs({ P13.Trees13, P16.IslSkirt16, root.Pass15:FindFirstChild("IslSpill15") }) do
			if f then for _, m in ipairs(f:GetChildren()) do
				local l = m:IsA("Model") and m.Name == "K_Soft15K" and m:FindFirstChild("K_Soft15K_leaf")
				-- green (untextured-tint) clumps only: the gold / blue / purple terrace crowns use white + a leaf map
				if l and m:GetPivot().Position.Y > 55 and l.Color.R < 0.6 and l.Color.G > l.Color.R then hide(m); n += 1 end
			end end
		end
		for _, t in ipairs(root.Islands:GetChildren()) do if t.Name == "IslTrunk" then hide(t) end end
	end
	if SKY.towers then
		for _, d in ipairs(P12.IslDress12:GetChildren()) do
			if d.Name == "IslTower" then table.insert(towerSpots, { d.Position - Vector3.new(0, d.Size.Y / 2, 0), d.Size.Y }) end
			hide(d)
		end
		for _, d in ipairs(P14:GetChildren()) do
			if d.Name:sub(1, 8) == "IslTower" then
				if d.Name == "IslTower14" then table.insert(towerSpots, { d.Position - Vector3.new(0, d.Size.Y / 2, 0), d.Size.Y }) end
				hide(d)
			end
		end
	end
	-- falls: group the stacked segments by column (x, z), keep the SKY.fallsKeep northern columns nearest the axis
	local cols = {}
	for _, f in ipairs({ root.Islands, P16.IslSkirt16 }) do
		for _, d in ipairs(f:GetChildren()) do
			if d:IsA("BasePart") and (d.Name:sub(1, 4) == "Fall") then
				local k = string.format("%d_%d", math.floor(d.Position.X / 12 + 0.5), math.floor(d.Position.Z / 12 + 0.5))
				cols[k] = cols[k] or { x = d.Position.X, z = d.Position.Z, parts = {} }; table.insert(cols[k].parts, d)
			end
		end
	end
	local list = {}; for _, c in pairs(cols) do table.insert(list, c) end
	table.sort(list, function(a, b) return (a.z < -100 and 0 or 1) * 1000 + math.abs(a.x) < (b.z < -100 and 0 or 1) * 1000 + math.abs(b.x) end)
	local kept = 0
	for i, c in ipairs(list) do
		if i <= SKY.fallsKeep and c.z < -100 then
			kept += 1
			for _, p in ipairs(c.parts) do if p.Name:find("Fall1") and not p.Name:find("Lip") and not p.Name:find("Mist") then recol(p, SKY.fallCol); setT(p, SKY.fallT) end end
		else
			for _, p in ipairs(c.parts) do hide(p) end
		end
	end
	-- canopies: 2 irregular umbrella crowns per island (IslSkirt16 K_Soft15U / R clones), feet by raycast onto the island model
	local srcs = {}
	for _, m in ipairs(P16.IslSkirt16:GetChildren()) do if m.Name == "K_Soft15U" or m.Name == "K_Soft15R" then table.insert(srcs, m) end end
	local F = Instance.new("Folder"); F.Name = "Canopy21"; F.Parent = P21
	local ni = 0
	if #srcs > 0 and SKY.canopies > 0 then
		for _, isl in ipairs(root.Islands:GetChildren()) do
			if isl.Name == "K_Isl91" or isl.Name == "K_Isl92" then
				ni += 1
				local cf, size = isl:GetBoundingBox()
				for j = 1, SKY.canopies do
					local a = (ni * 2.1 + j * 2.6); local r = math.min(size.X, size.Z) * 0.22
					local x, z = cf.X + r * math.cos(a), cf.Z + r * math.sin(a)
					local y = groundY(x, z, cf.Y + size.Y, { isl })
					if y then
						local c = srcs[(ni + j) % #srcs + 1]:Clone(); c.Parent = F
						for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false end end
						c:ScaleTo(c:GetScale() * (0.8 + 0.25 * ((ni + j) % 3)))
						local pv = c:GetPivot(); local bcf, bs = c:GetBoundingBox()
						c:PivotTo(CFrame.new(x, y - (bcf.Y - bs.Y / 2 - pv.Y) - 0.5, z) * CFrame.Angles(0, a, 0))
						tint(c, SKY.canopyCol, SKY.canopyRim)
					end
				end
			end
		end
	end
	if SKY.islGrass then
		for _, isl in ipairs(root.Islands:GetChildren()) do
			for _, d in ipairs(isl:GetDescendants()) do if d:IsA("MeshPart") then
				if d.Name:find("_grass") then recol(d, SKY.islGrass) elseif d.Name:find("_rock") then recol(d, SKY.islRock) elseif d.Name:find("_vine") then recol(d, SKY.islVine) end
			end end
		end
	end
	-- Atmosphere haze (the review's exception; measured, see notes/fix21_plaza.md). The original values are kept in P21Atmo.
	local at = game.Lighting:FindFirstChildOfClass("Atmosphere")
	if at then
		if at:GetAttribute("P21Atmo") == nil then at:SetAttribute("P21Atmo", string.format("%g|%g|%s", at.Haze, at.Density, tostring(at.Color))) end
		local a = string.split(at:GetAttribute("P21Atmo"), "|"); at.Haze = tonumber(a[1]); at.Density = tonumber(a[2])
		if SKY.atmoHaze then at.Haze = SKY.atmoHaze end
	end
	table.insert(report, string.format("sky21: lollipops %d, tower spots %d, fall columns %d kept %d, islands %d", n, #towerSpots, #list, kept, ni))
end
--ENDSKY21

-- ================================================================ item 2: thin the W blue mass. p8 (x 0-420, y 150-650) blue cover
-- 60% -> ~40% and p7 (x 0-450, y 100-700) 40% -> ~20% (out/r21w/metrics.py rule b > r+40, b > g+20, b > 120 gives 60.1 / 39.4
-- on the v18 practice frames and 40.9 / 15.3 on the reference). Blue clumps = Trees13 K_Soft15K with the blue leaf map.
--WEST21
local WEST = { keepOf5 = 2, bushKeepOf5 = 2, highKeepOf5 = 3, palms = 3, sand = rgb(240, 236, 200) }
do
	local BLUE = "rbxassetid://118173022878419"
	local clumps, bushes, high = {}, {}, {}
	for _, m in ipairs(P13.Trees13:GetChildren()) do
		if m.Name == "K_Soft15K" then
			local l = m:FindFirstChild("K_Soft15K_leaf"); local sa = l and l:FindFirstChildOfClass("SurfaceAppearance")
			local p = m:GetPivot().Position
			if sa and sa.ColorMap == BLUE and p.X < -45 and l.Transparency < 1 then table.insert(p.Y < 45 and clumps or high, m) end
		end
	end
	for _, m in ipairs(P16.West16:GetChildren()) do if m.Name == "K_Soft15B" then table.insert(bushes, m) end end
	local hc = thin(clumps, WEST.keepOf5); local hb = thin(bushes, WEST.bushKeepOf5)
	for _, m in ipairs(hc) do hide(m) end
	for _, m in ipairs(hb) do hide(m) end
	local hh = WEST.highKeepOf5 and thin(high, WEST.highKeepOf5) or {}
	for _, m in ipairs(hh) do hide(m) end
	-- blue palms + sand in the gaps: spread over the hidden clumps (every k-th one)
	local F = Instance.new("Folder"); F.Name = "West21"; F.Parent = P21
	local src = P16.West16:FindFirstChild("LagoonPalm16")
	local placed = 0
	if src and WEST.palms > 0 and #hc > 0 then
		local step = math.max(1, math.floor(#hc / WEST.palms))
		for i = 1, #hc, step do
			if placed >= WEST.palms then break end
			local p = hc[i]:GetPivot().Position
			local gy = groundY(p.X, p.Z, 60) or 6
			local c = src:Clone(); c.Name = "WestPalm21"; c.Parent = F
			local pv = c:GetPivot(); local bcf, bs = c:GetBoundingBox()
			local k = 27 / bs.Y; c:ScaleTo(c:GetScale() * k)
			pv = c:GetPivot(); bcf, bs = c:GetBoundingBox()
			c:PivotTo(CFrame.new(p.X, gy - (bcf.Y - bs.Y / 2 - pv.Y), p.Z) * CFrame.Angles(0, i, 0))
			local s = part("WestSand21", Vector3.new(0.2, 14, 16), CFrame.new(p.X, gy + 0.08, p.Z) * CFrame.Angles(0, 0.5 * i, math.pi / 2), WEST.sand, Enum.Material.Sand, F)
			s.Shape = Enum.PartType.Cylinder; s.CanCollide = false
			placed += 1
		end
	end
	table.insert(report, string.format("west21: blue clumps %d hid %d, high %d hid %d, bushes %d hid %d, palms %d", #clumps, #hc, #high, #hh, #bushes, #hb, placed))
end
--ENDWEST21

-- ================================================================ item 3: arch crown notch, outer slate, tunnel ledge (c1).
-- c1 targets (re-sampled by out/r21w/box21.py): notch (718-722, 288-292) (62,69,71); outer slate rep (406-410, 349-353) vs ref
-- (469-473, 349-353) (36,46,54); gold ledge (558-562, 440-444) (78,75,16). The dark lintel + cyan slot = Pass9.Ledge (a 5.4 x 0.7 x 7
-- block at y 8.7 jutting 1.3 in front of the crown, lit cyan underneath by the vault light) -> hidden; the notch between the U arms
-- (u +-2.2, y 9-12.5, open from w 33 to 36.5) gets a dark back panel at w 36.4. Ledge: c1 ref pixels (524/914, 432/453) project onto
-- the tunnel back panel (w 38) at u -7.5..7.0, y 3.4-4.2 (out/r20w/plane.py).
--ARCH21
-- s3: the notch panel at y1 14.5 stood above the U arms (top 12.5) as a dark slab in p1: now w 35.6, y1 12.55.
-- s1: slate (74,81,87) rendered (89,102,109) -> (30,37,43): box 2 off. Notch panel (62,69,71) rendered (80,95,96) (x1.3) -> (48,54,60).
-- Ledge (120,105,30) Metal rendered (70,53,1) 22 off -> (135,150,60). s1 left the pass-9 gold LedgeLip floating at y 9 (w 31.7), 15 px
-- above the reference gold bar (275-283) and its dark step (285-298); on the w 33 plane those rows are y 8.95-8.75 and 8.7-8.37.
local ARCH = { slate = rgb(30, 37, 43), notch = { w = 35.6, hw = 2.35, y0 = 8.9, y1 = 12.55, col = rgb(48, 54, 60) },
	ledge = { w = 37.6, hw = 7.0, y = 3.8, h = 0.6, d = 0.8, col = rgb(128, 112, 60) }, hideLedge = true,
	sill = { w = 32.9, hw = 2.3, y0 = 8.72, y1 = 8.98, col = rgb(150, 128, 48) }, step = { w = 32.55, y0 = 8.35, y1 = 8.72, col = rgb(48, 54, 60) } }
do
	local sl = P20:FindFirstChild("K_Arch20_slate"); if sl and ARCH.slate then recol(sl, ARCH.slate) end
	if ARCH.hideLedge then for _, d in ipairs(P9:GetChildren()) do if d.Name == "Ledge" or d.Name == "LedgeLip" then hide(d) end end end
	for _, sx in ipairs({ -1, 1 }) do for _, sz in ipairs({ -1, 1 }) do
		local d = Vector3.new(sx, 0, sz).Unit
		if ARCH.notch then
			local N = ARCH.notch; local pos = d * N.w + Vector3.new(0, (N.y0 + N.y1) / 2, 0)
			local b = part("NotchBack21", Vector3.new(N.hw * 2, N.y1 - N.y0, 0.3), CFrame.lookAt(pos, pos - d), N.col, Enum.Material.Slate)
			b.CanCollide = false; b.CastShadow = false
		end
		if ARCH.sill then
			local S, T = ARCH.sill, ARCH.step
			local pos = d * S.w + Vector3.new(0, (S.y0 + S.y1) / 2, 0)
			local g = part("NotchSill21", Vector3.new(S.hw * 2, S.y1 - S.y0, 0.5), CFrame.lookAt(pos, pos - d), S.col, Enum.Material.Metal); g.CanCollide = false
			pos = d * (T.w + 0.2) + Vector3.new(0, (T.y0 + T.y1) / 2, 0)
			local k = part("NotchStep21", Vector3.new(S.hw * 2 - 0.2, T.y1 - T.y0, 0.4), CFrame.lookAt(pos, pos - d), T.col, Enum.Material.Slate); k.CanCollide = false
		end
		if ARCH.ledge then
			local L = ARCH.ledge; local pos = d * L.w + Vector3.new(0, L.y, 0)
			local g = part("TunnelLedge21", Vector3.new(L.hw * 2, L.h, L.d), CFrame.lookAt(pos, pos - d), L.col, Enum.Material.Metal)
			g.CanCollide = false
		end
	end end
	-- c1 splats (item 10): left rim (120,185,250) rendered (184,244,255) (x1.5, sunlit floor); right (240,135,125) -> (251,187,172).
	-- Targets (82,162,244) / (226,97,95): colour = target / ratio.
	for _, d in ipairs(P19:GetChildren()) do
		if d.Name:sub(1, 9) == "K_Splat17" then
			local blue = d.Color.B > d.Color.R
			if blue then recol(d, d.Name:find("rim") and rgb(50, 105, 185) or rgb(40, 95, 200))
			else recol(d, d.Name:find("rim") and rgb(200, 70, 68) or rgb(190, 60, 58)) end
		end
	end
	table.insert(report, "arch21 ok")
end
--ENDARCH21

-- ================================================================ item 4 (Studio half): stair risers. c4 riser target (428-432,
-- 653-657) (85,107,121). K_Stairs_riser (48,64,80) rendered (42,69,95) in v18 (ratio .88/1.08/1.19), so colour = target / ratio.
--STAIR21
local STAIR = { riser = rgb(71, 89, 101) } -- s1 (97,99,102) rendered (116,120,123) (x1.2) 31 off -> (71,89,101)
do
	local ks = root.K_Stairs
	if STAIR.riser then recol(ks.K_Stairs_riser, STAIR.riser) end
	-- kit r21: chunky stair blocks replace the K_Stairs stone + riser and the Nosing strips (before GRASS21, so clumps sit on them)
	if kit and kit:FindFirstChild("K_Stairs21_stone") then
		local ks = root.K_Stairs; local cf0 = ks.K_Stairs_stone.CFrame
		local srcS = kit:FindFirstChild("K_Stairs21_stone")
		local a = srcS:Clone(); a.Name = "Stairs21_stone"; a.Anchored = true; a.CFrame = cf0; a.Color = ks.K_Stairs_stone.Color; a.Material = ks.K_Stairs_stone.Material; a.CanCollide = true; a.Parent = P21
		local r = kit:FindFirstChild("K_Stairs21_riser"):Clone(); r.Name = "Stairs21_riser"; r.Anchored = true; r.CFrame = cf0 + Vector3.new(0, r.Position.Y - srcS.Position.Y, 0); r.Color = ks.K_Stairs_riser.Color; r.Material = ks.K_Stairs_riser.Material; r.CanCollide = false; r.Parent = P21
		hide(ks.K_Stairs_stone); hide(ks.K_Stairs_riser)
		for _, d in ipairs(root.Planting:GetChildren()) do if d.Name == "Nosing" then hide(d) end end
	end
	table.insert(report, "stair21 ok")
end
--ENDSTAIR21

-- ================================================================ item 5: grass. Spike blades (StairGrass16, K_Grass) -> soft leafy
-- clumps 1-1.5 tall at ~60% of the count in (114,166,54) (c2 ref box 928-932, 588-592); a soft lawn strip ~1 wide along the S and W
-- stair-top lips in (110,174,68) (p2 ref box 558-562, 376-380). Clumps are green K_Soft15K clones (own leaf-card clump) scaled down.
--GRASS21
local GRASS = { keepOf5 = 3, h = 1.3, col = rgb(150, 205, 70), rim = rgb(180, 225, 90), lawn = rgb(120, 180, 70), lawnW = 1.2 }
do
	local F = Instance.new("Folder"); F.Name = "Grass21"; F.Parent = P21
	local src
	for _, m in ipairs(P13.Trees13:GetChildren()) do
		local l = m:FindFirstChild("K_Soft15K_leaf")
		if m.Name == "K_Soft15K" and l and l.Color.G > l.Color.R + 0.2 and l.Color.R < 0.45 then src = m; break end
	end
	local sg = P16:FindFirstChild("StairGrass16")
	local blades = {}
	if sg then for _, m in ipairs(sg:GetChildren()) do table.insert(blades, m) end end
	local nk = 0
	for i, m in ipairs(blades) do
		local p = (m:IsA("Model") and m:GetPivot() or m.CFrame).Position
		hide(m)
		if src and (i % 5) < GRASS.keepOf5 then
			local c = src:Clone(); c.Name = "Clump21"; c.Parent = F
			for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false; d.CastShadow = false end end
			local bcf, bs = c:GetBoundingBox(); c:ScaleTo(c:GetScale() * GRASS.h / bs.Y)
			local pv = c:GetPivot(); bcf, bs = c:GetBoundingBox()
			local gy = groundY(p.X, p.Z, p.Y + 4) or p.Y
			c:PivotTo(CFrame.new(p.X, gy - (bcf.Y - bs.Y / 2 - pv.Y) - 0.15, p.Z) * CFrame.Angles(0, i, 0))
			-- squash: a clump is wider than tall
			tint(c, GRASS.col, GRASS.rim); nk += 1
		end
	end
	-- lawn strips on the S (+z) and W (-x) stair-top lips (flights d 28-48, top y 6, side blocks |lat| 4.3-17.7)
	if GRASS.lawn then
		for _, dir in ipairs({ Vector3.new(0, 0, 1), Vector3.new(-1, 0, 0) }) do
			for _, s in ipairs({ -1, 1 }) do
				local lat = Vector3.new(dir.Z, 0, -dir.X) * s
				local c = dir * (48 + GRASS.lawnW / 2) + lat * 11
				local gy = groundY(c.X, c.Z, 20) or 6
				local p = part("Lawn21", Vector3.new(13.4, 0.3, GRASS.lawnW), CFrame.lookAt(Vector3.new(c.X, gy + 0.1, c.Z), Vector3.new(c.X, gy + 0.1, c.Z) + dir), GRASS.lawn, Enum.Material.Grass, F)
				p.CanCollide = false
				-- tufts along the strip
				if src then
					for k = -2, 2 do
						local q = c + lat * (k * 2.8)
						local t = src:Clone(); t.Name = "Tuft21"; t.Parent = F
						for _, d in ipairs(t:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false; d.CastShadow = false end end
						local bcf, bs = t:GetBoundingBox(); t:ScaleTo(t:GetScale() * 1.0 / bs.Y)
						local pv = t:GetPivot(); bcf, bs = t:GetBoundingBox()
						t:PivotTo(CFrame.new(q.X, gy - (bcf.Y - bs.Y / 2 - pv.Y) - 0.1, q.Z) * CFrame.Angles(0, k, 0))
						tint(t, GRASS.lawn, GRASS.rim)
					end
				end
			end
		end
	end
	table.insert(report, string.format("grass21: blades %d -> clumps %d (src %s)", #blades, nk, tostring(src ~= nil)))
end
--ENDGRASS21

-- ================================================================ item 7: Raid glow onto the tower. c3 haze box (1348-1352, 278-282)
-- (183,60,71); p3 haze (618-622, 198-202) (178,95,67). The eight pass-18 Raid boxes (out/r18w/box.py) stay within ~15.
--RAID21
local RAID = { col = nil }
do
	local hz = P16:FindFirstChild("RaidHaze16"); local band = hz and hz:FindFirstChild("Band")
	if band and RAID.col then
		if band:GetAttribute("P21Em") == nil then
			band:SetAttribute("P21Em", true); band:SetAttribute("P21EmCol", band.Color); band:SetAttribute("P21EmSize", band.Size); band:SetAttribute("P21EmRate", band.Rate)
		end
		band.Color = ColorSequence.new(RAID.col)
	end
	table.insert(report, "raid21 ok")
end
--ENDRAID21

-- ================================================================ item 8: basins teal. p7 basin rep (378-382, 538-542) vs ref (918-922,
-- 468-472) (67,154,178).
--BASIN21
local BASIN = { col = rgb(76, 113, 138) } -- s3: s2 (120,112,137) rendered (143,152,177) 76 off; Glass is not linear, interpolated between s1 and s2 per channel -> (76,113,138). s2: s1 (55,120,150) rendered (30,166,195) 37 off (ratio .55/1.38/1.3) -> (120,112,137). s1: K_Hero_water Glass (110,175,195) rendered (119,222,227) (x1.08/1.27/1.16)
do
	local w = root.K_Hero:FindFirstChild("K_Hero_water"); if w and BASIN.col then recol(w, BASIN.col) end
	table.insert(report, "basin21 ok")
end
--ENDBASIN21

-- ================================================================ kit r21: chunky stair blocks (replace K_Stairs stone + riser and
-- the Nosing strips), ruined arcades and domed palaces on the hidden white-tower spots (SKY21 towerSpots).
--KIT21
local KIT = { stone = rgb(176, 180, 174), dark = rgb(70, 78, 86), dome = rgb(112, 132, 150), gold = rgb(190, 160, 70),
	minGap = 30, stairs = true }
do
	local function k(n) return kit and kit:FindFirstChild(n) end
	local F = Instance.new("Folder"); F.Name = "Kit21"; F.Parent = P21
	local function put(name, cf, col, mat, parent, collide)
		local src = k(name); if not src then return nil end
		local c = src:Clone(); c.Anchored = true; c.CFrame = cf * (src.CFrame - src.CFrame.Position) * CFrame.new(src.Position)
		c.Color = col; c.Material = mat or SM; c.CanCollide = collide or false; c.Parent = parent or F; return c
	end
	local n = 0
	if k("K_Arcade21_stone") then
		local placed = {}
		for i, sp in ipairs(towerSpots) do
			local p = sp[1]; local ok = true
			for _, q in ipairs(placed) do if (Vector3.new(p.X, 0, p.Z) - Vector3.new(q.X, 0, q.Z)).Magnitude < KIT.minGap then ok = false end end
			if ok then
				table.insert(placed, p); n += 1
				local m = Instance.new("Model"); m.Name = (n % 3 == 0) and "Palace21" or "Arcade21"; m.Parent = F
				local cf = CFrame.lookAt(p, Vector3.new(0, p.Y, 0)) * CFrame.Angles(0, (n % 2) * 0.35 - 0.17, 0)
				if m.Name == "Arcade21" then
					put("K_Arcade21_stone", cf, KIT.stone, SM, m); put("K_Arcade21_darkStone", cf, KIT.dark, SM, m)
				else
					put("K_Palace21_stone", cf, KIT.stone, SM, m); put("K_Palace21_darkStone", cf, KIT.dark, SM, m)
					put("K_Palace21_dome", cf, KIT.dome, SM, m); put("K_Palace21_gold", cf, KIT.gold, Enum.Material.Metal, m)
				end
			end
		end
	end
	table.insert(report, string.format("kit21: skyline pieces %d, stairs %s", n, tostring(k("K_Stairs21_stone") ~= nil)))
end
--ENDKIT21

return table.concat(report, " | ") .. " | Plaza " .. #root:GetDescendants()
end
