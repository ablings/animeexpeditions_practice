-- pass35.lua (practice place only): freestyle pass 35 on top of the pass-34 build (notes/fix_brief35.md, verify32_plaza.md).
-- Run AFTER pass 34 (sh out/r34w/run.sh; then sh out/r35w/run.sh). Idempotent: new pieces live in Plaza.Pass35 (rebuilt each run);
-- every old piece pass 35 touches keeps its pre-pass-35 value in a P35* attribute and is restored first.
-- Attributes: P35Col/P35Mat, P35T/P35CC/P35CQ + P35Hidden, P35CF, P35Size, P35En, P35SA, P35Tx.
-- Blocks: --ARCH35, --TREE35, --WATER35, --WEST35, --EAST35, --EXTRA35. Kit: ae_kit_r35 (K_ArchLedge35_stone), merged below.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local NE = Enum.Material.Neon
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r35 kit merge (same as the IMPORTS loop of build_plaza.lua), in case a pass-35 kit is ever imported.
do
	local src = workspace:FindFirstChild("ae_kit_r35")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale35_stone", true)
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
local old = root:FindFirstChild("Pass35"); if old then old:Destroy() end
local P35 = Instance.new("Folder"); P35.Name = "Pass35"; P35.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P35Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P35T"); d.CanCollide = d:GetAttribute("P35CC"); d.CanQuery = d:GetAttribute("P35CQ") end
		for _, a in ipairs({ "P35Hidden", "P35T", "P35CC", "P35CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P35Col") ~= nil then d.Color = d:GetAttribute("P35Col"); d.Material = Enum.Material[d:GetAttribute("P35Mat")]; d:SetAttribute("P35Col", nil); d:SetAttribute("P35Mat", nil) end
	if d:GetAttribute("P35Size") ~= nil then d.Size = d:GetAttribute("P35Size"); d:SetAttribute("P35Size", nil) end
	if d:GetAttribute("P35CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P35CF")) else d.CFrame = d:GetAttribute("P35CF") end
		d:SetAttribute("P35CF", nil)
	end
	if d:GetAttribute("P35En") ~= nil then d.Enabled = d:GetAttribute("P35En"); d:SetAttribute("P35En", nil) end
	if d:GetAttribute("P35SA") ~= nil then d.Color = d:GetAttribute("P35SA"); d:SetAttribute("P35SA", nil) end
	if d:GetAttribute("P35Tx") ~= nil then d.Transparency = d:GetAttribute("P35Tx"); d:SetAttribute("P35Tx", nil) end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P35T") == nil then d:SetAttribute("P35T", d.Transparency); d:SetAttribute("P35CC", d.CanCollide); d:SetAttribute("P35CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P35Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P35Col") == nil then p:SetAttribute("P35Col", p.Color); p:SetAttribute("P35Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P35Size") == nil then p:SetAttribute("P35Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P35CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P35CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function setT(p, t) if p:GetAttribute("P35Tx") == nil then p:SetAttribute("P35Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:IsA("Light") and { inst } or inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P35En") == nil then d:SetAttribute("P35En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P35; return p
end
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P35; return c
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
local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P35 }
local function groundY(x, z, maxY, pred)
	-- first hit below maxY on a down-ray (skips canopy above it)
	local o = Vector3.new(x, 80, z)
	local ex = { P35 }
	for i = 1, 8 do
		prm.FilterDescendantsInstances = ex
		local r = workspace:Raycast(o, Vector3.new(0, -120, 0), prm)
		if not r then break end
		if r.Position.Y < maxY and r.Instance.Transparency < 0.5 and (not pred or pred(r.Instance)) then prm.FilterDescendantsInstances = { P35 }; return r.Position.Y, r.Instance end
		table.insert(ex, r.Instance)
	end
	prm.FilterDescendantsInstances = { P35 }
	return nil
end
local report = {}
local function under(path) local r = root for s in path:gmatch("[^%.]+") do r = r and r:FindFirstChild(s) end return r end
local function each(inst, f) if not inst then return 0 end local n = 0 for _, d in ipairs(inst:GetDescendants()) do if d:IsA("BasePart") then f(d); n += 1 end end return n end
local function scaleCol(c, k) return Color3.new(c.R * k, c.G * k, c.B * k) end
local rnd = Random.new(35)
-- tuning (pass 35)
local ARCH_COL = Color3.fromRGB(72, 78, 84) -- kept at pass 34: (62,67,73) took c1 (860,300) 88->74 (ref 89) and p3 (150,330) 92->77 (ref 134)
local ARCH_BB = Vector3.new(0, 6.25, 0) -- authored bbox centres (out/r35w/r35_info.json)
local LEDGE_BB = Vector3.new(0, 6.282, 0)
local LEDGE_COL = Color3.fromRGB(150, 155, 160)
local CROWN_UP, CROWN_THIN = 4, 0.7 -- N corner crowns: raise, and scale the lower third
local NE_PUSH = Vector3.new(1.5, 0, -3.5) -- NE crown extra shift (p3 (150,120))
local SHEET_COL, SHEET_T, SHEET_W, SHEET_MAT = Color3.fromRGB(40, 95, 118), 0.3, 3.6, Enum.Material.SmoothPlastic
local JETLOW_T, JETLOW_COL = 0.85, Color3.fromRGB(90, 130, 150)
local CANAL_COL, CANAL_W = Color3.fromRGB(55, 78, 150), 8
local SAND_COL = Color3.fromRGB(170, 148, 98)
local ROCK_COL, ROCK_TOP = Color3.fromRGB(23, 23, 20), Color3.fromRGB(60, 62, 57)
local PATCH_COL = Color3.fromRGB(86, 106, 65)
local BOLL_GOLD, BOLL_SLAB, DOME_K = Color3.fromRGB(112, 95, 20), Color3.fromRGB(92, 91, 72), 0.7 -- item 9

-- ================================================================ item 1: arch face. Stone darker (lit faces read too light); the stepped
-- up-facing ledges are one own kit mesh (K_ArchLedge35_stone, ae_kit.py build_ledge35) placed in the K_Arch20 frame, if imported.
--ARCH35
do
	local F = Instance.new("Folder"); F.Name = "Arch35"; F.Parent = P35
	local A = under("Pass20.K_Arch20_stone")
	if A then recol(A, ARCH_COL, SM) end
	local nb = 0
	local k = kit and kit:FindFirstChild("K_ArchLedge35_stone")
	if k and A then
		local c = k:Clone(); c.Anchored = true; c.CFrame = CFrame.new(LEDGE_BB + (A.Position - ARCH_BB)); c.Color = LEDGE_COL; c.Material = SM
		for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
		c.Name = "ArchLedge35"; ghost(c); c.Parent = F; nb = 1
	end
	table.insert(report, "arch ledge " .. nb)
end
--ENDARCH35

-- ================================================================ item 2: north notch-tree crowns up 4 and the lower third thinned (c1, p5
-- saturation); the NE crown pushed out toward the p3 (150,120) box.
--TREE35
do
	local T = under("Pass34.Tree34")
	local n = 0
	if T then
		local lo, hi = {}, {}
		for _, d in ipairs(T:GetChildren()) do
			if d.Name == "Crown34" then
				local key = (d.Position.X > 0 and "E" or "W") .. (d.Position.Z > 0 and "S" or "N")
				lo[key] = math.min(lo[key] or 1e9, d.Position.Y); hi[key] = math.max(hi[key] or -1e9, d.Position.Y)
			end
		end
		for _, d in ipairs(T:GetChildren()) do
			local p = d:GetAttribute("P35CF") and d:GetAttribute("P35CF").Position or d.Position
			if p.Z < 0 then
				local key = (p.X > 0 and "E" or "W") .. "N"
				local push = Vector3.new(0, CROWN_UP, 0) + (key == "EN" and NE_PUSH or Vector3.zero)
				if d.Name == "Crown34" then
					if p.Y < lo[key] + (hi[key] - lo[key]) / 3 + 0.01 then resize(d, (d:GetAttribute("P35Size") or d.Size) * CROWN_THIN) end
					moveTo(d, function(cf) return cf + push end); n += 1
				elseif d.Name == "Trunk34" then
					local s = d:GetAttribute("P35Size") or d.Size
					resize(d, Vector3.new(s.X + CROWN_UP, s.Y, s.Z))
					moveTo(d, function(cf) return cf + Vector3.new(push.X * 0.5, CROWN_UP / 2, push.Z * 0.5) end)
				end
			end
		end
	end
	table.insert(report, "crowns moved " .. n)
end
--ENDTREE35

-- ================================================================ item 3: niche water sheet (teal, 5 wide, 0.5 forward) and a dimmer jet base.
--WATER35
do
	local ns, nj = 0, 0
	each(under("Pass33.Water33"), function(d)
		if d.Name == "NicheSheet33" then
			recol(d, SHEET_COL, SHEET_MAT); setT(d, SHEET_T)
			local s = d:GetAttribute("P35Size") or d.Size
			resize(d, Vector3.new(SHEET_W, s.Y, s.Z))
			moveTo(d, function(cf) local p = cf.Position; return cf + (-(p * Vector3.new(1, 0, 1))).Unit * 0.5 end)
			ns += 1
		end
	end)
	for _, path in ipairs({ "Pass30.Jet30", "Pass31.Jet31" }) do
		each(under(path), function(d)
			if d.Transparency < 0.95 and d.Position.Y < 5.6 then recol(d, JETLOW_COL); setT(d, math.max(d.Transparency, JETLOW_T)); nj += 1 end
		end)
	end
	table.insert(report, string.format("sheets %d jetlow %d", ns, nj))
end
--ENDWATER35

-- ================================================================ item 4: N canal 8 wide blue, SE lawn sand, W lagoon N half banks + surf.
--WEST35
do
	local F = Instance.new("Folder"); F.Name = "Ground35"; F.Parent = P35
	-- N canal: one 8-wide blue strip over Arm0 from the stair top, gold kerbs moved out
	local nc = 0
	for _, d in ipairs(root:GetChildren()) do
		if d.Name == "ChanKerb0" or d.Name == "ChanSand0" or d.Name == "Channel0" then hide(d); nc += 1 end
	end
	local z0, z1 = -48.6, -152
	ghost(part("Canal35", Vector3.new(CANAL_W, 0.2, z0 - z1), CFrame.new(0, 6.15, (z0 + z1) / 2), CANAL_COL, SM, F))
	for _, sx in ipairs({ -1, 1 }) do
		ghost(part("CanalKerb35", Vector3.new(0.7, 0.45, z0 - z1), CFrame.new(sx * (CANAL_W / 2 + 0.35), 6.25, (z0 + z1) / 2), Color3.fromRGB(150, 128, 48), SM, F))
	end
	-- SE lawn: sand tiles on the grass, ~28 x 26 around (44, 52)
	local isGrass = function(i) return i.Material == Enum.Material.Grass or i.Material == Enum.Material.LeafyGrass end
	local nsd = 0
	for x = 30, 58, 5 do for z = 38, 64, 5 do
		local px, pz = x + rnd:NextNumber(-1, 1), z + rnd:NextNumber(-1, 1)
		if ((px - 44) / 15) ^ 2 + ((pz - 51) / 14) ^ 2 < 1 then
			local y = groundY(px, pz, 12, isGrass)
			if y then ghost(part("Sand35", Vector3.new(6.5, 0.2, 6.5), CFrame.new(px, y + 0.1, pz) * CFrame.Angles(0, rnd:NextNumber(0, 1.57), 0), SAND_COL, SM, F)); nsd += 1 end
		end
	end end
	-- W lagoon N half: white surf ring, sand-rock bank, a few rocks
	local BK = { { -112, -36, 28, 28 }, { -90, -42, 24, 24 } }
	for _, b in ipairs(BK) do
		ghost(part("Surf35", Vector3.new(0.12, b[3] + 2, b[4] + 2), CFrame.new(b[1], 6.32, b[2]) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(235, 245, 245), SM, F, Enum.PartType.Cylinder))
		local c = ghost(part("Bank35", Vector3.new(0.14, b[3], b[4]), CFrame.new(b[1], 6.36, b[2]) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(150, 138, 92), SM, F, Enum.PartType.Cylinder))
		for i = 1, 6 do
			local a, r = rnd:NextNumber(0, 6.28), math.sqrt(rnd:NextNumber()) * 0.38
			local s = rnd:NextNumber(3, 5.5)
			ghost(part("BankRock35", Vector3.new(s, s * rnd:NextNumber(0.4, 0.7), s * rnd:NextNumber(0.7, 1)), CFrame.new(b[1] + math.cos(a) * r * b[3], 6.4 + s * 0.2, b[2] + math.sin(a) * r * b[4]) * CFrame.Angles(rnd:NextNumber(-0.3, 0.3), rnd:NextNumber(0, 6.28), rnd:NextNumber(-0.3, 0.3)), Color3.fromRGB(78, 84, 60), Enum.Material.Slate, F))
		end
		for i = 1, 5 do
			local a, r = rnd:NextNumber(0, 6.28), math.sqrt(rnd:NextNumber()) * 0.4
			ghost(part("BankGrass35", Vector3.new(0.16, rnd:NextNumber(4, 7), rnd:NextNumber(4, 7)), CFrame.new(b[1] + math.cos(a) * r * b[3], 6.4, b[2] + math.sin(a) * r * b[4]) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(70, 105, 45), SM, F, Enum.PartType.Cylinder))
		end
	end
	table.insert(report, string.format("canal hid %d sand %d", nc, nsd))
end
--ENDWEST35

-- ================================================================ item 5: SE rock as broken rocks with lit tops and red foliage; lighter patches.
--EAST35
do
	local F = Instance.new("Folder"); F.Name = "East35"; F.Parent = P35
	local E = under("Pass34.East34")
	local nr = 0
	if E then
		for _, d in ipairs(E:GetChildren()) do
			if d.Name == "Rock34" or d.Name == "RockTop34" then hide(d) end
			if d.Name == "Patch34" then recol(d, PATCH_COL) end
		end
	end
	local y0 = groundY(124, 70, 14) or 6
	ghost(part("RockBase35", Vector3.new(0.3, 29, 29), CFrame.new(124, y0 + 0.2, 70) * CFrame.Angles(0, 0, math.rad(90)), ROCK_COL, NE, F, Enum.PartType.Cylinder))
	for i = 1, 22 do
		local a, r = rnd:NextNumber(0, 6.28), math.sqrt(rnd:NextNumber()) * 14
		local x, z = 124 + math.cos(a) * r, 70 + math.sin(a) * r * 0.9
		local s = rnd:NextNumber(3, 6.5) * (1.2 - r / 28)
		local h = s * rnd:NextNumber(0.5, 1.0) * (1.3 - r / 20)
		local cf = CFrame.new(x, y0 + h * 0.35, z) * CFrame.Angles(rnd:NextNumber(-0.25, 0.25), rnd:NextNumber(0, 6.28), rnd:NextNumber(-0.25, 0.25))
		ghost(part("Rock35", Vector3.new(s, h, s * rnd:NextNumber(0.7, 1)), cf, ROCK_COL, NE, F))
		ghost(part("RockTop35", Vector3.new(s * 0.92, 0.25, s * 0.85), cf * CFrame.new(0, h / 2 + 0.05, 0), ROCK_TOP, NE, F))
		nr += 1
		if rnd:NextNumber() < 0.35 then
			ghost(part("RockFol35", Vector3.new(s * 0.9, 0.5, s * 0.8), cf * CFrame.new(rnd:NextNumber(-0.5, 0.5), h / 2 + 0.2, 0), Color3.fromRGB(102, 38, 33), NE, F))
		end
	end
	table.insert(report, "rocks " .. nr)
end
--ENDEAST35

-- ================================================================ item 9: bollards aged gold (no metal sheen), squatter dome, warmer slab.
--EXTRA35
do
	local nb = 0
	each(under("Pass32.Boll32"), function(d)
		if d.Material == Enum.Material.Metal and d.Transparency < 0.95 then
			recol(d, BOLL_GOLD, SM); nb += 1
			if d.Name == "BollDome32" then
				local s = d:GetAttribute("P35Size") or d.Size
				resize(d, Vector3.new(s.X, s.Y * DOME_K, s.Z))
				moveTo(d, function(cf) return cf - Vector3.new(0, s.Y * (1 - DOME_K) / 2, 0) end)
			end
		elseif d.Name:match("^BollSlab") or d.Name == "BollChamfer32" then
			recol(d, BOLL_SLAB); nb += 1
		end
	end)
	table.insert(report, "bollard parts " .. nb)
end
--ENDEXTRA35

return table.concat(report, " | ")
end
