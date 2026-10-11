-- pass34.lua (practice place only): freestyle pass 34 on top of the pass-33 build (notes/fix_brief34.md, verify31_plaza.md).
-- Run AFTER pass 33 (sh out/r33w/run.sh; then sh out/r34w/run.sh). Idempotent: new pieces live in Plaza.Pass34 (rebuilt each run);
-- every old piece pass 34 touches keeps its pre-pass-34 value in a P34* attribute and is restored first.
-- Attributes: P34Col/P34Mat, P34T/P34CC/P34CQ + P34Hidden, P34CF, P34Size, P34En, P34SA, P34Tx.
-- Blocks: --KIT34, --ARCH34, --WATER34, --TREE34, --EAST34, --EXTRA34. Kit: ae_kit_r34 (K_ArchBand34_stone), merged below.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local NE = Enum.Material.Neon
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r34 kit merge (same as the IMPORTS loop of build_plaza.lua), in case a pass-34 kit is ever imported.
do
	local src = workspace:FindFirstChild("ae_kit_r34")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale34_stone", true)
		local sc = ref and ref.Size.X / 10.0 or 1
		for _, d in ipairs(src:GetDescendants()) do
			if d:IsA("MeshPart") then
				d.Size = d.Size / sc
				d.CFrame = CFrame.new(d.Position / sc) * (d.CFrame - d.CFrame.Position)
				d.Anchored = true
				for _, o in ipairs(kit:GetChildren()) do if o.Name == d.Name then o:Destroy() end end
				if d.Name:sub(1, 7) == "K_Scale" then d:Destroy() else d.Parent = kit end
			end
		end
		src:Destroy()
	end
end
local old = root:FindFirstChild("Pass34"); if old then old:Destroy() end
local P34 = Instance.new("Folder"); P34.Name = "Pass34"; P34.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P34Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P34T"); d.CanCollide = d:GetAttribute("P34CC"); d.CanQuery = d:GetAttribute("P34CQ") end
		for _, a in ipairs({ "P34Hidden", "P34T", "P34CC", "P34CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P34Col") ~= nil then d.Color = d:GetAttribute("P34Col"); d.Material = Enum.Material[d:GetAttribute("P34Mat")]; d:SetAttribute("P34Col", nil); d:SetAttribute("P34Mat", nil) end
	if d:GetAttribute("P34Size") ~= nil then d.Size = d:GetAttribute("P34Size"); d:SetAttribute("P34Size", nil) end
	if d:GetAttribute("P34CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P34CF")) else d.CFrame = d:GetAttribute("P34CF") end
		d:SetAttribute("P34CF", nil)
	end
	if d:GetAttribute("P34En") ~= nil then d.Enabled = d:GetAttribute("P34En"); d:SetAttribute("P34En", nil) end
	if d:GetAttribute("P34SA") ~= nil then d.Color = d:GetAttribute("P34SA"); d:SetAttribute("P34SA", nil) end
	if d:GetAttribute("P34Tx") ~= nil then d.Transparency = d:GetAttribute("P34Tx"); d:SetAttribute("P34Tx", nil) end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P34T") == nil then d:SetAttribute("P34T", d.Transparency); d:SetAttribute("P34CC", d.CanCollide); d:SetAttribute("P34CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P34Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P34Col") == nil then p:SetAttribute("P34Col", p.Color); p:SetAttribute("P34Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P34Size") == nil then p:SetAttribute("P34Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P34CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P34CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function setT(p, t) if p:GetAttribute("P34Tx") == nil then p:SetAttribute("P34Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:IsA("Light") and { inst } or inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P34En") == nil then d:SetAttribute("P34En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P34; return p
end
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P34; return c
end
local function ell(name, size, cf, col, mat, parent)
	local p = part(name, size, cf, col, mat, parent)
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	p.CanCollide = false; p.CanQuery = false; p.CastShadow = false
	return p
end
local function ghost(p) p.CanCollide = false; p.CanQuery = false; p.CastShadow = false; return p end
-- clone an existing model, strip every pass attribute (so older restores never touch the clone)
local function cloneClean(m)
	local c = m:Clone()
	for _, d in ipairs(c:GetDescendants()) do for k in pairs(d:GetAttributes()) do d:SetAttribute(k, nil) end end
	for k in pairs(c:GetAttributes()) do c:SetAttribute(k, nil) end
	return c
end
local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P34 }
local function groundY(x, z, maxY, pred)
	-- first hit below maxY on a down-ray (skips canopy above it)
	local o = Vector3.new(x, 80, z)
	local ex = { P34 }
	for i = 1, 8 do
		prm.FilterDescendantsInstances = ex
		local r = workspace:Raycast(o, Vector3.new(0, -120, 0), prm)
		if not r then break end
		if r.Position.Y < maxY and r.Instance.Transparency < 0.5 and (not pred or pred(r.Instance)) then prm.FilterDescendantsInstances = { P34 }; return r.Position.Y, r.Instance end
		table.insert(ex, r.Instance)
	end
	prm.FilterDescendantsInstances = { P34 }
	return nil
end
local report = {}
local report = {}
local function under(path) local r = root for s in path:gmatch("[^%.]+") do r = r and r:FindFirstChild(s) end return r end
local function each(inst, f) if not inst then return 0 end local n = 0 for _, d in ipairs(inst:GetDescendants()) do if d:IsA("BasePart") then f(d); n += 1 end end return n end
local function scaleCol(c, k) return Color3.new(c.R * k, c.G * k, c.B * k) end
local rnd = Random.new(34)
-- tuning (pass 34)
local ARCH_COL, ARCH_MAT = Color3.fromRGB(72, 78, 84), Enum.Material.SmoothPlastic
local ARCH_BB = Vector3.new(0, 6.25, 0) -- authored bbox centres (out/r34w/r34_info.json)
local BAND_BB = Vector3.new(0, 3.85, 0)
local BAND_COL = Color3.fromRGB(100, 104, 105) -- c1 (125,130,130) rendered (174,181,180) vs ref (134,136,138)
local JW, JT = 0.6, 0.7
local SHEET_COL = Color3.fromRGB(31, 50, 58)
local TREE_COL, TREE_COL2 = Color3.fromRGB(48, 98, 212), Color3.fromRGB(88, 138, 222)
local CROWN_K, CROWN_DY = 0.68, -2.5
local RED, RED_MAT = { 102, 38, 33 }, Enum.Material.Neon
local GREEN, GREEN_MAT = Color3.fromRGB(66, 88, 25), Enum.Material.Neon
local ROCK, ROCKTOP = Color3.fromRGB(27, 28, 26), Color3.fromRGB(45, 48, 45)
local DOOR_COL = Color3.fromRGB(0, 0, 0)

-- ================================================================ items 1 + 5: arch inner band and arch face.
-- The pass-33 band (56 straight segments tilted 30 deg) read as saw teeth: hidden. The new band is one smooth kit mesh
-- (K_ArchBand34_stone, own Blender: arch_band between two offset intrados ellipses, mirrored to the 4 corners), placed in the
-- K_Arch20 frame. Arch face lifted to a shading Slate.
--ARCH34
do
	local F = Instance.new("Folder"); F.Name = "Arch34"; F.Parent = P34
	local a33 = under("Pass33.Arch33"); if a33 then hide(a33) end
	local A = under("Pass20.K_Arch20_stone")
	if A then recol(A, ARCH_COL, ARCH_MAT) end
	local nb = 0
	local k = kit and kit:FindFirstChild("K_ArchBand34_stone")
	if k and A then
		-- authored in the plaza frame like K_Arch20: same frame offset (Studio centre - authored bbox centre of the arch)
		local off = A.Position - ARCH_BB
		local c = k:Clone(); c.Anchored = true; c.CFrame = CFrame.new(BAND_BB + off); c.Color = BAND_COL; c.Material = SM
		for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
		c.Name = "ArchBand34"; ghost(c); c.Parent = F; nb = 1
	end
	table.insert(report, "arch band " .. nb)
end
--ENDARCH34

-- ================================================================ item 2: jet 60 % width and fainter; dark blue glowing niche sheet.
--WATER34
do
	local C = { Vector3.new(23.4, 0, 23.4), Vector3.new(-23.4, 0, 23.4), Vector3.new(23.4, 0, -23.4), Vector3.new(-23.4, 0, -23.4) }
	local function axis(p) local best, bd = nil, 1e9 for _, c in ipairs(C) do local d = ((p - c) * Vector3.new(1, 0, 1)).Magnitude if d < bd then best, bd = c, d end end return best end
	local nj = 0
	each(under("Pass31.Jet31"), function(d)
		if d.Transparency < 0.95 then
			local c = axis(d.Position)
			moveTo(d, function(cf) local p = cf.Position; local np = Vector3.new(c.X + (p.X - c.X) * JW, p.Y, c.Z + (p.Z - c.Z) * JW); return CFrame.new(np) * (cf - cf.Position) end)
			resize(d, d.Size * Vector3.new(JW, 1, JW)); setT(d, math.max(d.Transparency, JT)); nj += 1
		end
	end)
	each(under("Pass30.Jet30"), function(d)
		if d.Transparency < 0.95 and d.Name ~= "JetFoam30" then
			if d.Name == "Jet30" or d.Name == "JetCore30" then resize(d, d.Size * Vector3.new(1, JW, JW)) end
			setT(d, math.max(d.Transparency, JT)); nj += 1
		end
	end)
	local ns = 0
	each(under("Pass33.Water33"), function(d)
		if d.Name == "NicheSheet33" then recol(d, SHEET_COL, Enum.Material.Neon); setT(d, 0.3); ns += 1 end
		if d.Name == "NicheLip33" then recol(d, Color3.fromRGB(70, 110, 128)); ns += 1 end
	end)
	table.insert(report, string.format("jet %d sheets %d", nj, ns))
end
--ENDWATER34

-- ================================================================ item 3: p3 upper-left. The reference's NE notch tree is a big royal-blue
-- crown over the arch (c3, p5 show it rising high; p3 sees it upper-left). Our Notch29 trees are 4-stud crowns topping at 20.
-- Each of the 4 gets a taller trunk and a royal-blue crown of own K_FluffyS_leaf clumps, ~16 wide, y 17-33.
--TREE34
do
	local F = Instance.new("Folder"); F.Name = "Tree34"; F.Parent = P34
	local n = 0
	for _, sg in ipairs({ { 1, -1 }, { 1, 1 }, { -1, -1 }, { -1, 1 } }) do
		local o = Vector3.new(sg[1] * 25.5, 0, sg[2] * 25.5)
		local out = Vector3.new(sg[1], 0, sg[2]).Unit
		local t = Vector3.new(-out.Z, 0, out.X)
		local tr = part("Trunk34", Vector3.new(9.5, 1.1, 1.1), CFrame.new(o + Vector3.new(0, 19.5, 0)) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(80, 60, 45), Enum.Material.Wood, F, Enum.PartType.Cylinder)
		ghost(tr)
		local CL = { { 0, 26, 0, 1.0 }, { 4.5, 23, 1.0, 0.7 }, { -4.5, 23.5, 0.5, 0.75 }, { 1.5, 30, -1, 0.7 }, { -2, 21, -3, 0.65 }, { 2.5, 21.5, 3, 0.6 } }
		for i, c in ipairs(CL) do
			local p = o + (t * c[1] + out * c[3]) * CROWN_K + Vector3.new(0, 17 + (c[2] - 17) * CROWN_K + CROWN_DY, 0)
			local col = (i % 2 == 0) and TREE_COL2 or TREE_COL
			local k = kp("K_FluffyS_leaf", CFrame.new(p - Vector3.new(0, 9.1 * c[4] * CROWN_K, 0)) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0), c[4] * CROWN_K, col, SM, F, "Crown34")
			if k then ghost(k); n += 1 end
		end
	end
	table.insert(report, "tree crowns " .. n)
end
--ENDTREE34

-- ================================================================ item 4: E ground. A solid red underlay (Neon tiles on the grass) in place of
-- the red/grey/green speckle, sparse white flower dots, flat green flower patches 10-15 across, and a rounded rock mound.
--EAST34
do
	local F = Instance.new("Folder"); F.Name = "East34"; F.Parent = P34
	local function inBand(x, z) return x > 58 and x < 178 and z > -9.5 and z < 12.5 end
	local function inRock(x, z) return (x - 124) ^ 2 / 19 ^ 2 + (z - 70) ^ 2 / 18 ^ 2 < 1 end
	local isGrass = function(i) return i.Material == Enum.Material.Grass or i.Material == Enum.Material.LeafyGrass end
	local nt = 0
	for x = 54, 178, 6 do
		for z = -104, 106, 6 do
			local px, pz = x + rnd:NextNumber(-1.5, 1.5), z + rnd:NextNumber(-1.5, 1.5)
			if not inBand(px, pz) and not inRock(px, pz) then
				local y = groundY(px, pz, 12, isGrass)
				if y then
					local s = rnd:NextNumber(7.5, 9)
					local v = rnd:NextNumber(-6, 6)
					local p = part("Red34", Vector3.new(s, 0.2, s), CFrame.new(px, y + 0.12, pz) * CFrame.Angles(0, rnd:NextNumber(0, 1.57), 0),
						Color3.fromRGB(RED[1] + v, RED[2] + v * 0.4, RED[3] + v * 0.4), RED_MAT, F)
					ghost(p); nt += 1
					if rnd:NextNumber() < 0.35 then
						ghost(part("Dot34", Vector3.new(0.5, 0.3, 0.5), CFrame.new(px + rnd:NextNumber(-3, 3), y + 0.3, pz + rnd:NextNumber(-3, 3)), Color3.fromRGB(240, 240, 232), SM, F))
					end
				end
			end
		end
		if x % 30 == 0 then task.wait() end
	end
	-- pass-32 grey scatter rubble outside the band reads as speckle: hide it
	local ng = 0
	each(under("Pass32.Ground32"), function(d)
		local p = d.Position
		if d.Material == Enum.Material.Slate and math.abs(d.Color.R - d.Color.G) < 0.05 and p.X > 40 and not inBand(p.X, p.Z) then hide(d); ng += 1 end
	end)
	-- flat flower patches: replace the pass-33 bush clusters; the pass-33 cube rock goes too
	local E33 = under("Pass33.East33")
	local nf = 0
	if E33 then for _, d in ipairs(E33:GetChildren()) do if d.Name == "Flower33" or d.Name == "FlowerW33" or d.Name == "Rock33" then hide(d) end end end
	local PT = { { 78, -40, 13 }, { 98, -30, 11 }, { 70, 32, 12 }, { 112, 38, 14 }, { 142, -24, 10 }, { 88, 64, 12 } }
	for _, c in ipairs(PT) do
		local y = groundY(c[1], c[2], 12, isGrass) or 6
		for j = 1, 3 do
			local d = c[3] * (j == 1 and 1 or rnd:NextNumber(0.5, 0.7))
			local px, pz = c[1] + (j == 1 and 0 or rnd:NextNumber(-c[3] * 0.4, c[3] * 0.4)), c[2] + (j == 1 and 0 or rnd:NextNumber(-c[3] * 0.4, c[3] * 0.4))
			ghost(part("Patch34", Vector3.new(0.3, d, d), CFrame.new(px, y + 0.25 + j * 0.02, pz) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), math.rad(90)), GREEN, GREEN_MAT, F, Enum.PartType.Cylinder))
		end
		for i = 1, 14 do
			local a, r = rnd:NextNumber(0, 6.28), math.sqrt(rnd:NextNumber()) * c[3] * 0.45
			ghost(part("Dot34", Vector3.new(0.6, 0.3, 0.6), CFrame.new(c[1] + math.cos(a) * r, y + 0.45, c[2] + math.sin(a) * r), Color3.fromRGB(245, 245, 238), SM, F))
		end
		nf += 1
	end
	-- rounded rock mound: overlapping ellipsoids, dark body with lighter tops
	local nr = 0
	local y0 = groundY(124, 70, 14) or 6
	local RK = { { 124, 70, 22, 9, 20 }, { 116, 62, 14, 8, 12 }, { 133, 77, 15, 7, 13 }, { 130, 61, 12, 6, 11 }, { 117, 79, 13, 6, 11 }, { 124, 70, 14, 12, 12 } }
	for i, r in ipairs(RK) do
		ell("Rock34", Vector3.new(r[3], r[4] * 2, r[5]), CFrame.new(r[1], y0 + (i == 6 and 1 or -0.5), r[2]) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0), ROCK, NE, F)
		nr += 1
	end
	for i = 1, 3 do
		local a = i * 2.1
		ell("RockTop34", Vector3.new(6, 1.6, 5), CFrame.new(124 + math.cos(a) * 4, y0 + 11.2 - i * 0.8, 70 + math.sin(a) * 4) * CFrame.Angles(0, a, 0), ROCKTOP, NE, F); nr += 1
	end
	table.insert(report, string.format("east tiles %d greyHid %d patches %d rock %d", nt, ng, nf, nr))
end
--ENDEAST34

--EXTRA34
do
	local d = under("Pass33.P3Sky33.RaidDoor33"); if d then recol(d, DOOR_COL) end
	local d2 = under("Pass33.P3Sky33.RaidDoorTop33"); if d2 then recol(d2, DOOR_COL) end
	table.insert(report, "door")
end
--ENDEXTRA34

return table.concat(report, " | ")
end
