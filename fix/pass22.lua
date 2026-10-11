-- pass22.lua (practice place only): freestyle pass 22 on top of the pass-21 build (notes/fix_brief22.md, verify19_plaza.md).
-- Run AFTER pass 21. Idempotent: new pieces live in Plaza.Pass22 (rebuilt each run); hidden old pieces get P22Hidden (old
-- transparency / CanCollide / CanQuery in P22T / P22CC / P22CQ); recoloured old pieces keep their pre-pass-22 colour/material in
-- P22Col / P22Mat; lights keep P22L*; Atmosphere keeps P22Atmo.
-- Blocks: --SKY22, --FOL22, --GRASS22, --ARCH22, --RUN22 (needs ae_kit_r22), --RAID22, --STAIR22 (needs ae_kit_r22).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r22 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r22")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale22_stone", true)
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
local old = root:FindFirstChild("Pass22"); if old then old:Destroy() end
local P22 = Instance.new("Folder"); P22.Name = "Pass22"; P22.Parent = root
local P21, P20, P19, P17, P16, P15, P13, P11 = root.Pass21, root.Pass20, root.Pass19, root.Pass17, root.Pass16, root.Pass15, root.Pass13, root.Pass11
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P22
	return p
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P22T") == nil then d:SetAttribute("P22T", d.Transparency); d:SetAttribute("P22CC", d.CanCollide); d:SetAttribute("P22CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P22Hidden", true)
		end
		if d:IsA("Decal") or d:IsA("Texture") then
			if d:GetAttribute("P22T") == nil then d:SetAttribute("P22T", d.Transparency) end
			d.Transparency = 1; d:SetAttribute("P22Hidden", true)
		end
		if d:IsA("ParticleEmitter") or d:IsA("PointLight") or d:IsA("SpotLight") then
			if d:GetAttribute("P22En") == nil then d:SetAttribute("P22En", d.Enabled) end
			d.Enabled = false; d:SetAttribute("P22Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P22Col") == nil then p:SetAttribute("P22Col", p.Color); p:SetAttribute("P22Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
	local sa = p:FindFirstChildOfClass("SurfaceAppearance")
	if sa then
		if p:GetAttribute("P22SACol") == nil then p:SetAttribute("P22SACol", sa.Color) end
		pcall(function() sa.Color = col end)
	end
end
-- restore everything pass 22 touched, so every run starts from the pass-21 state
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P22Hidden") then
		if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then d.Transparency = d:GetAttribute("P22T") end
		if d:IsA("BasePart") and d:GetAttribute("P22CC") ~= nil then d.CanCollide = d:GetAttribute("P22CC"); d.CanQuery = d:GetAttribute("P22CQ") end
		if d:GetAttribute("P22En") ~= nil then d.Enabled = d:GetAttribute("P22En") end
		d:SetAttribute("P22Hidden", nil)
	end
	if d:GetAttribute("P22Col") ~= nil then d.Color = d:GetAttribute("P22Col"); d.Material = Enum.Material[d:GetAttribute("P22Mat")] end
	if d:GetAttribute("P22SACol") ~= nil then local sa = d:FindFirstChildOfClass("SurfaceAppearance"); if sa then pcall(function() sa.Color = d:GetAttribute("P22SACol") end) end end
	if d:GetAttribute("P22Em") then d.Color = d:GetAttribute("P22EmCol") end
	if d:GetAttribute("P22LCol") ~= nil then d.Color = d:GetAttribute("P22LCol"); d.Brightness = d:GetAttribute("P22LB"); d.Range = d:GetAttribute("P22LR") end
end
local function setLight(l, col, b, r)
	if l:GetAttribute("P22LCol") == nil then l:SetAttribute("P22LCol", l.Color); l:SetAttribute("P22LB", l.Brightness); l:SetAttribute("P22LR", l.Range) end
	l.Color = col; l.Brightness = b; l.Range = r
end
local function groundY(x, z, top, incl)
	local rp = RaycastParams.new()
	if incl then rp.FilterType = Enum.RaycastFilterType.Include; rp.FilterDescendantsInstances = incl
	else
		local ex = {}; for _, c in ipairs(P22:GetChildren()) do if c.Name:sub(1, 8) ~= "Stairs22" then table.insert(ex, c) end end
		rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = ex
	end
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -400, 0), rp)
	return r and r.Position.Y or nil
end
local function prep(c, parent, name)
	if name then c.Name = name end
	for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false end end
	c.Parent = parent; return c
end
-- seat a model with its bounding-box bottom at y (pivot moved), at x, z, yaw a, scaled so its height is h (or scale k)
local function seat(c, x, y, z, a, h, k)
	local bcf, bs = c:GetBoundingBox()
	if h then c:ScaleTo(c:GetScale() * h / bs.Y) elseif k then c:ScaleTo(c:GetScale() * k) end
	local pv = c:GetPivot(); bcf, bs = c:GetBoundingBox()
	c:PivotTo(CFrame.new(x, y - (bcf.Y - bs.Y / 2 - pv.Y), z) * CFrame.Angles(0, a or 0, 0))
end
local function tint(m, col, rim)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("MeshPart") then
			local c = d.Name:find("leafRim") and (rim or col) or (d.Name:find("leaf") and col)
			if c then d.Color = c; local sa = d:FindFirstChildOfClass("SurfaceAppearance"); if sa then pcall(function() sa.Color = c end) end end
		end
	end
end
-- leaf-clump sources by leaf map (Trees13 K_Soft15K, white tint + map): blue / gold / purple
local MAPS = { blue = "rbxassetid://118173022878419", gold = "rbxassetid://94449468583229", purple = "rbxassetid://108341914835015",
	tinted = "rbxassetid://92399071475046" }
local function clumpSrc(map, name, colTest)
	for _, m in ipairs(P13.Trees13:GetChildren()) do
		if m.Name == (name or "K_Soft15K") then
			local l = m:FindFirstChild(m.Name .. "_leaf"); local sa = l and l:FindFirstChildOfClass("SurfaceAppearance")
			if sa and sa.ColorMap == map and (not colTest or colTest(l.Color)) then return m end
		end
	end
end
local report = {}

-- ================================================================ item 1: background. Lollipop island canopies -> 3-4 lumps each in
-- the reference mix (blue, purple, gold, pale green); two wide translucent falls and a 4-arch aqueduct north of the plaza on a small
-- floating island (falls project from p1 ref x 780 / 905 and c4 ref x 760 / 900 to x ~15 and ~55 at z -160..-200, top y ~115;
-- the aqueduct from c4 ref x 585-700, y 40-80 to x -47..-9, y 132-147 at z -200). Atmosphere: one low-haze / high-density pale test.
--SKY22
local SKY = { lumps = true, lumpMix = { "blue", "purple", "gold", "green", "purple", "blue", "gold" }, green = rgb(150, 190, 120),
	northIsl = { x = 15, y = 128, z = -235, k = 0.42 }, aque = { x = -10, z = -235 }, falls = { 5, 40 }, fallW = 9, fallT = 0.2,
	fallCol = rgb(228, 242, 250), atmo = { 0.28, 0, rgb(200, 220, 235) } } -- atmo = { density, haze, colour } test result: see notes/fix22_plaza.md
do
	local nl, nc = 0, 0
	local F = Instance.new("Folder"); F.Name = "Sky22"; F.Parent = P22
	if SKY.lumps then
		local srcs = { blue = clumpSrc(MAPS.blue), purple = clumpSrc(MAPS.purple), gold = clumpSrc(MAPS.gold),
			green = clumpSrc(MAPS.tinted, nil, function(c) return c.G > c.R + 0.15 end) }
		local crowns = {}
		for _, m in ipairs(P16.IslSkirt16:GetChildren()) do if (m.Name == "K_Soft15U" or m.Name == "K_Soft15R") then table.insert(crowns, m) end end
		local c21 = P21:FindFirstChild("Canopy21"); if c21 then for _, m in ipairs(c21:GetChildren()) do table.insert(crowns, m) end end
		for i, m in ipairs(crowns) do
			local vis = false; for _, d in ipairs(m:GetDescendants()) do if d:IsA("BasePart") and d.Transparency < 1 then vis = true end end
			if vis then
				nc += 1
				local bcf, bs = m:GetBoundingBox()
				-- the crown = the leaf parts; keep the wood (trunk) visible
				local lcf, ls
				for _, d in ipairs(m:GetDescendants()) do if d:IsA("MeshPart") and d.Name:find("leaf") then hide(d); lcf, ls = d.CFrame, d.Size end end
				lcf = lcf or bcf; ls = ls or bs
				local n = 3 + (i % 2); local R = math.min(ls.X, ls.Z) * 0.32
				for j = 1, n do
					local key = SKY.lumpMix[(i + j) % #SKY.lumpMix + 1]
					local s = srcs[key] or srcs.blue
					if s then
						local a = j * 2 * math.pi / n + i
						local rr = (j == n) and 0 or R; local yb = (j == n) and (lcf.Y - ls.Y * 0.1) or (lcf.Y - ls.Y * 0.3 + 0.12 * ls.Y * (j % 2))
						local c = prep(s:Clone(), F, "Lump22")
						local _, cs = c:GetBoundingBox(); c:ScaleTo(c:GetScale() * math.max(ls.X, ls.Z) * (0.5 + 0.08 * (j % 3)) / math.max(cs.X, cs.Z))
						seat(c, lcf.X + rr * math.cos(a), yb, lcf.Z + rr * math.sin(a), a)
						if key == "green" then tint(c, SKY.green) end
						nl += 1
					end
				end
			end
		end
	end
	-- north floating island with an aqueduct and two falls
	local I = root.Islands
	local srcI, srcA
	for _, m in ipairs(I:GetChildren()) do if m.Name == "K_Isl92" and not srcI then srcI = m end; if m.Name == "K_Aque9" and not srcA then srcA = m end end
	if srcI and SKY.northIsl then
		local N = SKY.northIsl
		local c = prep(srcI:Clone(), F, "NorthIsl22"); c:ScaleTo(c:GetScale() * N.k)
		local bcf = c:GetBoundingBox(); c:PivotTo(c:GetPivot() + (Vector3.new(N.x, N.y, N.z) - bcf.Position))
		local cf, sz = c:GetBoundingBox()
		local top = groundY(N.x, N.z, 300, { c }) or (cf.Y + sz.Y / 2)
		local bot = cf.Y - sz.Y / 2
		if srcA then
			local a = prep(srcA:Clone(), F, "Aque22")
			local acf, as = a:GetBoundingBox()
			local yaw = (as.X >= as.Z) and 0 or math.pi / 2
			seat(a, SKY.aque.x, groundY(SKY.aque.x, SKY.aque.z, 300, { c }) or top, SKY.aque.z, yaw)
		end
		local fsrc = kit and kit:FindFirstChild("K_Fall8_fall")
		if fsrc then
			for _, fx in ipairs(SKY.falls) do
				local f = fsrc:Clone(); f.Name = "Fall22"; f.Anchored = true; f.CanCollide = false; f.CanQuery = false; f.CastShadow = false
				local h = math.max(40, bot + 8 - 10)
				f.Size = Vector3.new(SKY.fallW, h, f.Size.Z * SKY.fallW / f.Size.X)
				f.CFrame = CFrame.new(fx, bot + 8 - h / 2, N.z + 14) ; f.Color = SKY.fallCol; f.Material = SM; f.Transparency = SKY.fallT
				f.Parent = F
			end
		end
	end
	-- Atmosphere (the brief's one test). The original values are kept in P22Atmo and restored first.
	local at = game.Lighting:FindFirstChildOfClass("Atmosphere")
	if at then
		if at:GetAttribute("P22Atmo") == nil then at:SetAttribute("P22Atmo", string.format("%g|%g|%g|%g|%g", at.Density, at.Haze, at.Color.R, at.Color.G, at.Color.B)) end
		local a = string.split(at:GetAttribute("P22Atmo"), "|")
		at.Density = tonumber(a[1]); at.Haze = tonumber(a[2]); at.Color = Color3.new(tonumber(a[3]), tonumber(a[4]), tonumber(a[5]))
		if SKY.atmo then at.Density = SKY.atmo[1]; at.Haze = SKY.atmo[2]; at.Color = SKY.atmo[3] end
	end
	table.insert(report, string.format("sky22: crowns %d -> lumps %d", nc, nl))
end
--ENDSKY22

-- ================================================================ item 8 (kit r22): 8 shallower steps (rise 0.75, tread 2.5) replace the
-- pass-21 6-step blocks. Count read from the frames (c4 ref dark bands 476/509/554/626/755 = an 8-step flight through the c4 camera;
-- p1 ref shows 8 bands, ours 6). Tread (186,191,185) c4 ref (398-402, 688-692). Runs before GRASS22 so the ferns land on the new steps.
--STAIR22
local STAIR = { tread = rgb(122, 125, 121), riser = nil }
do
	local s21, r21 = P21:FindFirstChild("Stairs21_stone"), P21:FindFirstChild("Stairs21_riser")
	if kit and kit:FindFirstChild("K_Stairs22_stone") and s21 then
		local srcS = kit.K_Stairs22_stone
		local a = srcS:Clone(); a.Name = "Stairs22_stone"; a.Anchored = true; a.CFrame = s21.CFrame; a.Color = STAIR.tread or s21.Color; a.Material = s21.Material; a.CanCollide = true; a.Parent = P22
		local r = kit.K_Stairs22_riser:Clone(); r.Name = "Stairs22_riser"; r.Anchored = true; r.CFrame = s21.CFrame + Vector3.new(0, r.Position.Y - srcS.Position.Y, 0)
		r.Color = STAIR.riser or r21.Color; r.Material = r21.Material; r.CanCollide = false; r.Parent = P22
		hide(s21); hide(r21)
		table.insert(report, "stair22 kit")
	elseif s21 and STAIR.tread then recol(s21, STAIR.tread) end
end
--ENDSTAIR22

-- ================================================================ item 3: stair grass. Pass-21 shrub balls (Clump21) -> 40 % kept as low
-- flat fern sprays (Planting K_Fern, ~3.6 across, 1 tall) on the treads, (114,166,54) c2 ref (928-932, 588-592); a tall grass fringe
-- along the S and W stair tops (p2 ref y 360-385 across the whole flight, (115,177,79) at 558-562, 376-380).
--GRASS22
local GRASS = { keepOf5 = 1, lip = { { 10, 30.4 }, { -13, 29.6 }, { 6.5, 33.2 }, { -8, 35.8 }, { 14.5, 38.5 } }, fern = rgb(100, 150, 48), fernRim = rgb(125, 172, 62), fernW = 3.6, fringe = rgb(120, 185, 75), fringeH = 2.6, fringeStep = 0.9 }
do
	local F = Instance.new("Folder"); F.Name = "Grass22"; F.Parent = P22
	local g21 = P21:FindFirstChild("Grass21")
	local fsrc; for _, m in ipairs(root.Planting:GetChildren()) do if m.Name == "K_Fern" and m:IsA("Model") and m.K_Fern_leaf.Transparency < 1 and not m.K_Fern_leaf:GetAttribute("P21Hidden") then fsrc = m; break end end
	local nf, nh = 0, 0
	if g21 then
		local i = 0
		for _, m in ipairs(g21:GetChildren()) do
			if m.Name == "Clump21" then
				i += 1; local p = m:GetPivot().Position; hide(m); nh += 1
				if fsrc and (i % 5) < GRASS.keepOf5 then
					local c = prep(fsrc:Clone(), F, "Fern22")
					for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.CastShadow = false end end
					local _, cs = c:GetBoundingBox(); c:ScaleTo(c:GetScale() * GRASS.fernW / math.max(cs.X, cs.Z))
					local gy = groundY(p.X, p.Z, p.Y + 4) or p.Y
					seat(c, p.X, gy - 0.1, p.Z, i * 1.3)
					tint(c, GRASS.fern, GRASS.fernRim); nf += 1
				end
			end
		end
	end
	-- lip ferns: the same (lat, d) list on each flight (c2 ref fern at (930, 590) projects to x 10, z 30.8 on the S flight)
	if fsrc and GRASS.lip then
		for q = 0, 3 do
			local dir = CFrame.Angles(0, q * math.pi / 2, 0):VectorToWorldSpace(Vector3.new(0, 0, 1)); local lat = Vector3.new(dir.Z, 0, -dir.X)
			for i, o in ipairs(GRASS.lip) do
				local p = dir * o[2] + lat * o[1] * ((q % 2 == 0) and 1 or -1)
				local c = prep(fsrc:Clone(), F, "Fern22")
				for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.CastShadow = false end end
				local _, cs = c:GetBoundingBox(); c:ScaleTo(c:GetScale() * GRASS.fernW / math.max(cs.X, cs.Z))
				seat(c, p.X, (groundY(p.X, p.Z, 12) or 1) - 0.1, p.Z, i * 2.3 + q)
				tint(c, GRASS.fern, GRASS.fernRim); nf += 1
			end
		end
	end
	-- fringe of K_Grass blades along the S (+z) and W (-x) stair-top lips
	local gsrc = kit and kit:FindFirstChild("K_Grass_leaf")
	local nb = 0
	if gsrc and GRASS.fringe then
		for _, dir in ipairs({ Vector3.new(0, 0, 1), Vector3.new(-1, 0, 0) }) do
			local lat = Vector3.new(dir.Z, 0, -dir.X)
			for s = -1, 1, 2 do
				local k = 0
				for l = 4.9, 17.3, GRASS.fringeStep do
					k += 1
					for row = 0, 1 do
						local c = dir * (48.4 + row * 0.9) + lat * s * (l + row * 0.5)
						local gy = groundY(c.X, c.Z, 20) or 6
						local b = gsrc:Clone(); b.Name = "Fringe22"; b.Anchored = true; b.CanCollide = false; b.CanQuery = false; b.CastShadow = false
						local h = GRASS.fringeH * (0.8 + 0.25 * ((k + row) % 3)); b.Size = b.Size * (h / b.Size.Y)
						b.CFrame = CFrame.new(c.X, gy + h / 2 - 0.1, c.Z) * CFrame.Angles(0, k * 1.7 + row, 0)
						b.Color = GRASS.fringe; b.Material = SM; b.Parent = F; nb += 1
					end
				end
			end
		end
	end
	table.insert(report, string.format("grass22: clumps hid %d -> ferns %d, fringe blades %d", nh, nf, nb))
end
--ENDGRASS22

-- ================================================================ item 4: arch notch. The pass-21 flat panel (NotchBack21 at w 35.6, flush
-- with the ear tops) -> a recessed U: low back wall 1.5 behind the front plane (w 34.6, y 8.9-10.6), a floor, 3 dark pods (50,54,70)
-- c1 ref (686-690, 260-264) and a small tree (trunk + blue lumps) growing out of it.
--ARCH22
local ARCH = { back = { w = 34.6, y0 = 8.9, y1 = 10.6, col = rgb(44, 50, 58) }, pod = rgb(63, 56, 64), tree = true, treeH = 7.5, fill = { col = rgb(150, 235, 185), b = 2.2, r = 9, w = 34.5, y = 3.2 } }
do
	local F = Instance.new("Folder"); F.Name = "Arch22"; F.Parent = P22
	for _, d in ipairs(P21:GetChildren()) do if d.Name == "NotchBack21" then hide(d) end end
	local blue = clumpSrc(MAPS.blue)
	for _, sx in ipairs({ -1, 1 }) do for _, sz in ipairs({ -1, 1 }) do
		local d = Vector3.new(sx, 0, sz).Unit; local u = Vector3.new(-d.Z, 0, d.X)
		local B = ARCH.back
		local pos = d * B.w + Vector3.new(0, (B.y0 + B.y1) / 2, 0)
		local b = part("NotchWall22", Vector3.new(4.7, B.y1 - B.y0, 0.4), CFrame.lookAt(pos, pos - d), B.col, Enum.Material.Slate, F); b.CanCollide = false
		pos = d * 33.8 + Vector3.new(0, 8.85, 0)
		local fl = part("NotchFloor22", Vector3.new(4.6, 0.3, 1.8), CFrame.lookAt(pos, pos - d), B.col, Enum.Material.Slate, F); fl.CanCollide = false
		for k, o in ipairs({ { -1.4, 1.3 }, { 0.15, 1.6 }, { 1.45, 1.2 } }) do
			local pp = d * (33.9 + 0.1 * k) + u * o[1] + Vector3.new(0, 9.0 + o[2] * 0.45, 0)
			local pod = part("NotchPod22", Vector3.new(o[2], o[2], o[2]), CFrame.new(pp), ARCH.pod, SM, F)
			pod.Shape = Enum.PartType.Ball; pod.CanCollide = false
		end
		if ARCH.fill then
			-- tunnel back wall (K_Hero19_stone (101,107,111)) rendered purple (33,26,47): a cool green-cyan fill light toward (44,54,62)
			local L = ARCH.fill; local a = part("TunnelFill22", Vector3.new(0.3, 0.3, 0.3), CFrame.new(d * L.w + Vector3.new(0, L.y, 0)), rgb(255, 255, 255), SM, F)
			a.Transparency = 1; a.CanCollide = false; a.CanQuery = false
			local l = Instance.new("PointLight"); l.Color = L.col; l.Brightness = L.b; l.Range = L.r; l.Shadows = false; l.Parent = a
		end
		if ARCH.tree then
			local base = d * 34.0 + u * 0.4 + Vector3.new(0, 9.0, 0)
			local tr = part("NotchTrunk22", Vector3.new(0.55, ARCH.treeH, 0.55), CFrame.new(base + Vector3.new(0, ARCH.treeH / 2, 0)) * CFrame.Angles(0.12 * sx, 0, -0.1 * sz), rgb(92, 66, 46), SM, F)
			tr.CanCollide = false
			local br = part("NotchBranch22", Vector3.new(0.35, 3.2, 0.35), CFrame.new(base + Vector3.new(0, ARCH.treeH * 0.6, 0) + u * 0.9) * CFrame.Angles(0, 0, 0.6), rgb(92, 66, 46), SM, F); br.CanCollide = false
			if blue then
				for j = 1, 2 do
					local c = prep(blue:Clone(), F, "NotchCrown22")
					seat(c, base.X + u.X * (j - 1.5) * 2.2, base.Y + ARCH.treeH - 1.2 + j * 0.4, base.Z + u.Z * (j - 1.5) * 2.2, j, 3.6)
				end
			end
		end
	end end
	table.insert(report, "arch22 ok")
end
--ENDARCH22

-- ================================================================ item 5: runners. Blue: p5 (148-152, 408-412) (84,141,230), c4 (658-662,
-- 698-702) (75,126,225); K_Stairs_blue (40,68,140) rendered (41,74,177) in p5 / (28,55,168) in c4. Kit r22: raised bevelled slabs at
-- the stair feet (d 16.5-28), silver frame, thick gold rim (156,141,39) p5 (260-264, 498-502), blue face, cyan gem at the foot.
--RUN22
local RUN = { blue = rgb(58, 80, 160), navy = rgb(53, 75, 143), slab = true, silver = rgb(205, 210, 215), gold = rgb(160, 135, 45), face = rgb(58, 82, 160), gem = rgb(90, 220, 240) }
do
	local ks = root.K_Stairs
	if RUN.blue then recol(ks.K_Stairs_blue, RUN.blue) end
	if RUN.navy then recol(ks.K_Stairs_navy, RUN.navy) end
	if RUN.slab and kit and kit:FindFirstChild("K_Runner22_silver") then
		local s0 = kit.K_Runner22_silver
		for _, nm in ipairs({ "silver", "gold", "blue", "gem" }) do
			local src = kit:FindFirstChild("K_Runner22_" .. nm)
			local c = src:Clone(); c.Name = "Runner22_" .. nm; c.Anchored = true; c.CanCollide = (nm == "silver")
			-- the kit pieces share one origin: keep their offsets from the silver frame, silver bottom on the floor (y 0)
			c.CFrame = CFrame.new(src.Position.X - s0.Position.X, src.Position.Y - s0.Position.Y + s0.Size.Y / 2, src.Position.Z - s0.Position.Z) * (src.CFrame - src.CFrame.Position)
			c.Color = (nm == "silver" and RUN.silver) or (nm == "gold" and RUN.gold) or (nm == "blue" and RUN.face) or RUN.gem
			c.Material = (nm == "gold") and Enum.Material.Metal or (nm == "gem" and NE or SM); if nm == "gem" then c.Transparency = 0.2 end
			c.Parent = P22
		end
		table.insert(report, "run22 slabs")
	end
end
--ENDRUN22

-- ================================================================ item 7: Raid skull lit and a red glow. p3 cheek (718-722, 78-82)
-- (216,128,102); c3 haze (1348-1352, 278-282) (183,61,67).
--RAID22
-- The Atmosphere (SKY22) lifts the distant Raid facade: offset = now - pass-21 baseline (lowL +10/+24/+26, lowR +19/+22/+25, tower
-- +10/+23/+31). New colour = (target - offset) / pre-fog render ratio. shadeR (shadow side) cannot reach (78,24,37) under the fog.
local RAID = { light = { col = rgb(255, 150, 115), b = 6, r = 22 }, haze = rgb(145, 95, 86), bone = rgb(235, 150, 100),
	spire = rgb(72, 2, 5), gable = rgb(138, 29, 0), band = rgb(125, 84, 70) }
do
	local sk = P15:FindFirstChild("K_Skull15")
	if sk and RAID.light then
		local bone = sk:FindFirstChild("K_Skull15_bone")
		local a = part("SkullLight22", Vector3.new(0.4, 0.4, 0.4), CFrame.new(bone.Position + Vector3.new(-7, 1, 0)), rgb(255, 255, 255), SM)
		a.Transparency = 1; a.CanCollide = false; a.CanQuery = false
		local l = Instance.new("PointLight"); l.Color = RAID.light.col; l.Brightness = RAID.light.b; l.Range = RAID.light.r; l.Shadows = false; l.Parent = a
		if RAID.bone then recol(bone, RAID.bone) end
	end
	local r11 = P11:FindFirstChild("Raid11")
	if r11 then for _, d in ipairs(r11:GetDescendants()) do
		if d:IsA("BasePart") then
			if RAID.spire and (d.Name == "K_Spire_stone" or d.Name == "K_Gothic_stone") then recol(d, RAID.spire) end
			if RAID.gable and d.Name == "RaidGableTall" then recol(d, RAID.gable) end
		end
	end end
	if RAID.band then for _, d in ipairs(P17:GetChildren()) do if d.Name == "RaidArchBand17" and d.Color.R > 0.3 then recol(d, RAID.band) end end end
	local hz = P16:FindFirstChild("RaidHaze16"); local band = hz and hz:FindFirstChild("Band")
	if band and RAID.haze then
		if band:GetAttribute("P22Em") == nil then band:SetAttribute("P22Em", true); band:SetAttribute("P22EmCol", band.Color) end
		band.Color = ColorSequence.new(RAID.haze)
	end
	table.insert(report, "raid22 ok")
end
--ENDRAID22

-- ================================================================ item 2: foliage. E: 40 % of the red splats hidden, the lime grass holes
-- retinted to lawn (128,170,54) p8 ref (988-992, 298-302), the grey patches S of the E arm turned to lawn, red canopy trees on the grey;
-- N avenue: blue palms either side; S: the white pads (WhitePave) -> lawn, the beach sand discs tan, a green palm cluster.
--FOL22
local FOL = { splatKeepOf5 = 3, hole = rgb(110, 150, 50), seLawn = rgb(88, 138, 52), redTrees = 8, redLeaf = rgb(150, 35, 40), redRim = rgb(190, 70, 70),
	nPalms = 6, pave = rgb(92, 145, 58), sand = rgb(222, 204, 160), sPalms = 3 }
do
	local F = Instance.new("Folder"); F.Name = "Fol22"; F.Parent = P22
	-- E red splats: group rim + core by position, keep FOL.splatKeepOf5 of 5
	local groups, keys = {}, {}
	for _, f in ipairs({ P17:FindFirstChild("Splats17"), root:FindFirstChild("East18", true) }) do
		if f then for _, d in ipairs(f:GetDescendants()) do
			if d:IsA("BasePart") and d.Name:sub(1, 9) == "K_Splat17" and d.Position.X > 35 and d.Transparency < 1 then
				local k = string.format("%d_%d", math.floor(d.Position.X + 0.5), math.floor(d.Position.Z + 0.5))
				if not groups[k] then groups[k] = {}; table.insert(keys, k) end; table.insert(groups[k], d)
			end
		end end
	end
	table.sort(keys); local hs = 0
	for i, k in ipairs(keys) do if (i % 5) >= FOL.splatKeepOf5 then for _, d in ipairs(groups[k]) do hide(d) end; hs += 1 end end
	-- lawn holes
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and (d.Name == "GrassHole18") then recol(d, FOL.hole, Enum.Material.Grass) end
	end
	-- grey patches south of the E arm -> lawn
	local ns = 0
	for _, d in ipairs(root.Zoning:GetDescendants()) do
		if d:IsA("BasePart") and d.Position.X > 30 and d.Position.Z > 12 and d.Color.R < 0.3 and math.abs(d.Color.R - d.Color.G) < 0.05 then recol(d, FOL.seLawn, Enum.Material.Grass); ns += 1 end
	end
	-- red canopy trees on the E grey ground (Trees13 K_Soft15R red clones)
	local rs = clumpSrc(MAPS.tinted, "K_Soft15R", function(c) return c.R > c.G * 2 end)
	local nr = 0
	if rs then
		local spots = { { 62, -30 }, { 80, -48 }, { 96, -22 }, { 70, -70 }, { 105, -55 }, { 88, 20 }, { 110, 35 }, { 120, -5 } }
		for i = 1, math.min(FOL.redTrees, #spots) do
			local x, z = spots[i][1], spots[i][2]
			local gy = groundY(x, z, 60)
			if gy and gy < 15 then
				local c = prep(rs:Clone(), F, "RedTree22"); seat(c, x, gy - 0.3, z, i * 1.1, 14 + (i % 3) * 3)
				tint(c, FOL.redLeaf, FOL.redRim); nr += 1
			end
		end
	end
	-- blue palms either side of the N avenue (Arm0, x +-18.5, z -55..-150) and a green palm cluster S
	local bp = P16.West16:FindFirstChild("LagoonPalm16")
	local np = 0
	if bp then
		for i = 1, FOL.nPalms do
			local s = (i % 2 == 0) and 1 or -1; local z = -60 - 16 * math.floor((i - 1) / 2) - (s > 0 and 8 or 0)
			local x = s * 21.5; local gy = groundY(x, z, 60)
			if gy then local c = prep(bp:Clone(), F, "NPalm22"); seat(c, x, gy - 0.2, z, i * 0.9, 26 + (i % 3) * 2); np += 1 end
		end
	end
	for _, d in ipairs(P11:GetChildren()) do if d.Name == "WhitePave" then recol(d, FOL.pave, Enum.Material.Grass) end end
	local b20 = P20:FindFirstChild("Beach20"); if b20 then for _, d in ipairs(b20:GetDescendants()) do if d:IsA("BasePart") and d.Name == "Sand20" then recol(d, FOL.sand) end end end
	local gp
	for _, d in ipairs(root:GetDescendants()) do if d:IsA("Model") and d.Name:find("Palm") then local l = d:FindFirstChild("K_Palm6A_leaf") or d:FindFirstChild("K_PalmA_leaf"); if l and l.Color.G > l.Color.B + 0.15 and l.Transparency < 1 then gp = d; break end end end
	local ng = 0
	if gp then
		for i, o in ipairs({ { -22, 82 }, { -30, 92 }, { 24, 88 } }) do
			if i > FOL.sPalms then break end
			local gy = groundY(o[1], o[2], 60)
			if gy then local c = prep(gp:Clone(), F, "SPalm22"); seat(c, o[1], gy - 0.2, o[2], i * 2.1, 18 + i * 3); ng += 1 end
		end
	end
	table.insert(report, string.format("fol22: splats %d hid %d, SE lawn %d, red trees %d, N palms %d, S palms %d (src %s)", #keys, hs, ns, nr, np, ng, gp and gp.Name or "nil"))
end
--ENDFOL22

return table.concat(report, " | ") .. " | Plaza " .. #root:GetDescendants()
end
