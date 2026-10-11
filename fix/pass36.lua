-- pass36.lua (practice place only): freestyle pass 36 on top of the pass-35 build (notes/fix_brief36.md, verify33_plaza.md).
-- Run AFTER pass 35 (sh out/r35w/run.sh; then sh out/r36w/run.sh). Idempotent: new pieces live in Plaza.Pass36 (rebuilt each run);
-- every old piece pass 36 touches keeps its pre-pass-36 value in a P36* attribute and is restored first.
-- Attributes: P36Col/P36Mat, P36T/P36CC/P36CQ + P36Hidden, P36CF, P36Size, P36En, P36SA, P36Tx.
-- Blocks: --ARCH36, --TREE36, --ORB36, --RAID36, --FALLS36 (see body). Kit: ae_kit_r36 if one is ever imported (merged below).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local NE = Enum.Material.Neon
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r36 kit merge (same as the IMPORTS loop of build_plaza.lua), in case a pass-36 kit is ever imported.
do
	local src = workspace:FindFirstChild("ae_kit_r36")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale36_stone", true)
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
local old = root:FindFirstChild("Pass36"); if old then old:Destroy() end
local P36 = Instance.new("Folder"); P36.Name = "Pass36"; P36.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P36Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P36T"); d.CanCollide = d:GetAttribute("P36CC"); d.CanQuery = d:GetAttribute("P36CQ") end
		for _, a in ipairs({ "P36Hidden", "P36T", "P36CC", "P36CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P36Col") ~= nil then d.Color = d:GetAttribute("P36Col"); d.Material = Enum.Material[d:GetAttribute("P36Mat")]; d:SetAttribute("P36Col", nil); d:SetAttribute("P36Mat", nil) end
	if d:GetAttribute("P36Size") ~= nil then d.Size = d:GetAttribute("P36Size"); d:SetAttribute("P36Size", nil) end
	if d:GetAttribute("P36CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P36CF")) else d.CFrame = d:GetAttribute("P36CF") end
		d:SetAttribute("P36CF", nil)
	end
	if d:GetAttribute("P36En") ~= nil then d.Enabled = d:GetAttribute("P36En"); d:SetAttribute("P36En", nil) end
	if d:GetAttribute("P36SA") ~= nil then d.Color = d:GetAttribute("P36SA"); d:SetAttribute("P36SA", nil) end
	if d:GetAttribute("P36Tx") ~= nil then d.Transparency = d:GetAttribute("P36Tx"); d:SetAttribute("P36Tx", nil) end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P36T") == nil then d:SetAttribute("P36T", d.Transparency); d:SetAttribute("P36CC", d.CanCollide); d:SetAttribute("P36CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P36Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P36Col") == nil then p:SetAttribute("P36Col", p.Color); p:SetAttribute("P36Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P36Size") == nil then p:SetAttribute("P36Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P36CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P36CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function setT(p, t) if p:GetAttribute("P36Tx") == nil then p:SetAttribute("P36Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:IsA("Light") and { inst } or inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P36En") == nil then d:SetAttribute("P36En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P36; return p
end
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P36; return c
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
local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P36 }
local function groundY(x, z, maxY, pred)
	-- first hit below maxY on a down-ray (skips canopy above it)
	local o = Vector3.new(x, 80, z)
	local ex = { P36 }
	for i = 1, 8 do
		prm.FilterDescendantsInstances = ex
		local r = workspace:Raycast(o, Vector3.new(0, -120, 0), prm)
		if not r then break end
		if r.Position.Y < maxY and r.Instance.Transparency < 0.5 and (not pred or pred(r.Instance)) then prm.FilterDescendantsInstances = { P36 }; return r.Position.Y, r.Instance end
		table.insert(ex, r.Instance)
	end
	prm.FilterDescendantsInstances = { P36 }
	return nil
end
local report = {}
local function under(path) local r = root for s in path:gmatch("[^%.]+") do r = r and r:FindFirstChild(s) end return r end
local function each(inst, f) if not inst then return 0 end local n = 0 for _, d in ipairs(inst:GetDescendants()) do if d:IsA("BasePart") then f(d); n += 1 end end return n end
local function scaleCol(c, k) return Color3.new(c.R * k, c.G * k, c.B * k) end
local rnd = Random.new(36)
-- tuning (pass 36)
local SLATE_COL, SLATE_MAT = Color3.fromRGB(112, 116, 122), Enum.Material.SmoothPlastic -- item 1: band between the gold pipes (was Slate (30,37,43))
local STONE_COL, STONE_MAT = nil, nil -- Neon stone (80,82,85) tested: fixed the backlit boxes (c2 40->82, p1 56->83) but read as a flat unshaded cut-out; kept at pass 34/35
local TRUNK_TOP = 23.5 -- item 2: notch-tree trunk tops cut to here (inside the crown), the rest are branch arms + clusters
local CLUS_COL, CLUS_COL2, CLUS_W = Color3.fromRGB(36, 78, 195), Color3.fromRGB(60, 108, 210), 3.8
local ORB_SHIFT = Vector3.new(-3, -5, 0) -- item 3: the ref core sits lower-right of ours in p2 ((708,167) vs our (685,125)); the brief's "raise 8" would move it away
local ORB_COL, ORB_T, ORB_MAT = Color3.fromRGB(235, 245, 250), 0.1, Enum.Material.Neon
local PILLAR_COL, PILLAR_T, PILLAR_MAT = Color3.fromRGB(70, 82, 90), 0.2, Enum.Material.SmoothPlastic
local PORTAL_K = 0.85 -- portal and swirl colours scaled (p6 (60,300) (12,128,149) -> (1,81,93))
local FRINGE_HIDE = false -- tested and off: hiding it exposed a flat grey island underside across p2/p6. Was: the low S island fringe (Sky25 IslFringe25, y < 95, z > 200) that fills p2 (720,200) where the ref shows sky
local BEAM_CORE, BEAM_HALO = Color3.fromRGB(205, 105, 102), Color3.fromRGB(200, 45, 45) -- item 4: Raid beam pink core + red halo (ref (243,138,135))
local RECESS_COL = Color3.fromRGB(40, 12, 16) -- item 4: 3 carved arch recesses left of the door (c3)
local FALL_CORE, FALL_MID, FALL_W = Color3.fromRGB(170, 215, 235), Color3.fromRGB(140, 200, 225), 1.5 -- item 5: falls less white, sheets wider
local MIST_COL, MIST_T, MIST_W = Color3.fromRGB(200, 230, 235), 0.5, 8

-- ================================================================ item 1: arch outer band. K_Arch20_slate (the band between the gold pipes,
-- proved with a red tint in c1, c2, p1, p3, p5) goes from navy Slate to a mid stone grey.
--ARCH36
do
	local S = under("Pass20.K_Arch20_slate")
	if S then recol(S, SLATE_COL, SLATE_MAT) end
	local A = under("Pass20.K_Arch20_stone")
	if A and STONE_COL then recol(A, STONE_COL, STONE_MAT) end
	table.insert(report, "arch slate " .. (S and 1 or 0))
end
--ENDARCH36

-- ================================================================ item 2: bare notch-tree poles. Each Trunk34 is cut to TRUNK_TOP inside its
-- crown; 3 angled branch arms (0.6) rise from mid-height into the crown and each ends in a ~3.8 clump; 2 more clumps hug the trunk.
--TREE36
do
	local F = Instance.new("Folder"); F.Name = "Tree36"; F.Parent = P36
	local T = under("Pass34.Tree34")
	local k = kit and kit:FindFirstChild("K_FluffyS_leaf")
	local n, nb = 0, 0
	local function clump(c, w, col)
		if not k then return end
		local sc = w / k.Size.X
		local cl = kp("K_FluffyS_leaf", CFrame.new(c - k.Position * sc) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0), sc, col, SM, F, "Clus36")
		if cl then ghost(cl); n += 1 end
	end
	if T then
		for _, d in ipairs(T:GetChildren()) do
			if d.Name == "Trunk34" then
				local cf = d.CFrame; local L = d.Size.X
				local bot = cf.Position.Y - L / 2
				local top = math.min(cf.Position.Y + L / 2, TRUNK_TOP)
				local nl = top - bot
				resize(d, Vector3.new(nl, d.Size.Y, d.Size.Z))
				moveTo(d, function(c0) return c0 - Vector3.new(0, (L - nl) / 2, 0) end)
				local base = Vector3.new(cf.Position.X, 0, cf.Position.Z)
				local out = (base * Vector3.new(1, 0, 1)).Unit
				local mid = bot + nl * 0.55
				for i = 0, 2 do
					local a = i * 2.1 + rnd:NextNumber(-0.3, 0.3)
					local dir = Vector3.new(math.cos(a), 0, math.sin(a))
					local p0 = base + Vector3.new(0, mid + i * 1.2, 0)
					local p1 = p0 + dir * 2.6 + Vector3.new(0, 4.2, 0)
					local pe = p1 - (p1 - p0).Unit * 1.2 -- stop inside the clump
					local br = part("Branch36", Vector3.new(0.5, 0.5, (pe - p0).Magnitude), CFrame.lookAt((p0 + pe) / 2, pe), d.Color, d.Material, F)
					ghost(br); nb += 1
					clump(p1 + Vector3.new(0, 0.6, 0), CLUS_W + rnd:NextNumber(-0.3, 0.4), i % 2 == 0 and CLUS_COL or CLUS_COL2)
				end
				clump(base + Vector3.new(0, top - 0.5, 0), CLUS_W + 0.4, CLUS_COL)
				clump(base + out * 0.8 + Vector3.new(0, mid + 1, 0), CLUS_W - 0.4, CLUS_COL2)
				-- the plaza-facing side (all spawn cameras look outward from the centre): cover the trunk at 3 heights
				for j, h in ipairs({ mid + 0.5, (mid + top) / 2 + 0.5, top - 1.2, top + 1.4 }) do
					clump(base - out * 1.0 + Vector3.new(0, h, 0), CLUS_W - 0.2 + j * 0.2, j % 2 == 1 and CLUS_COL or CLUS_COL2)
				end
			end
		end
	end
	table.insert(report, string.format("tree clumps %d branches %d", n, nb))
end
--ENDTREE36

-- ================================================================ item 3: Expeditions orb raised and dimmed, cyan pillars to stone-glass, portal darker.
--ORB36
do
	local R = under("Landmarks.K_ExpRing8")
	if R then
		moveTo(R, function(cf) return cf + ORB_SHIFT end)
		local c = R:FindFirstChild("K_ExpRing8_core"); if c then recol(c, ORB_COL, ORB_MAT); setT(c, ORB_T) end
	end
	local g = under("Pass9.K_Trip10.K_Trip10_glass"); if g then recol(g, PILLAR_COL, PILLAR_MAT); setT(g, PILLAR_T) end
	local n = 0
	for _, path in ipairs({ "Pass32.Gate32", "Pass31.Gate31" }) do
		each(under(path), function(d)
			if d.Name:match("^Swirl") or d.Name == "Portal31" or d.Name == "PortalArch31" then recol(d, scaleCol(d:GetAttribute("P36Col") or d.Color, PORTAL_K)); n += 1 end
		end)
	end
	local nf = 0
	if FRINGE_HIDE then
		for _, m in ipairs(under("Pass25.Sky25"):GetChildren()) do
			local p = m:GetPivot().Position
			if m.Name == "IslFringe25" and p.Y < 95 and p.Z > 200 then hide(m); nf += 1 end
		end
	end
	table.insert(report, "portal parts " .. n .. " fringes hidden " .. nf)
end
--ENDORB36

-- ================================================================ item 4: Raid beam (pink core in a translucent red halo) and 3 dark arch
-- recesses on the facade left (-z) of the door, found by a ray from the plaza side. The door colour is haze, not paint (pass 34).
--RAID36
do
	local F = Instance.new("Folder"); F.Name = "Raid36"; F.Parent = P36
	local b = under("Pass11.Raid11.RaidBeam11")
	if b then
		recol(b, BEAM_CORE)
		local s = b:GetAttribute("P36Size") or b.Size
		resize(b, Vector3.new(s.X * 0.7, s.Y, s.Z * 0.6))
		local h = part("BeamHalo36", Vector3.new(s.X * 1.6, s.Y + 1, s.Z * 1.7), b.CFrame, BEAM_HALO, NE, F); ghost(h); h.Transparency = 0.55
	end
	local nr = 0
	for _, z in ipairs({ -9.5, -13.5, -17.5 }) do
		local ex, r = { P36 }, nil
		for i = 1, 6 do -- skip trees and glow sheets in front of the facade
			prm.FilterDescendantsInstances = ex
			r = workspace:Raycast(Vector3.new(110, 16, z), Vector3.new(80, 0, 0), prm)
			if not r or (r.Instance.Name:match("Gothic") or r.Instance.Name:match("Raid")) and r.Instance.Transparency < 0.5 then break end
			table.insert(ex, r.Instance)
		end
		prm.FilterDescendantsInstances = { P36 }
		if r and r.Position.X > 130 then
			local fx = r.Position.X
			local body = part("Recess36", Vector3.new(0.4, 5.5, 3), CFrame.new(fx - 0.15, 14.75, z), RECESS_COL, SM, F)
			local top = part("RecessTop36", Vector3.new(0.4, 3, 3), CFrame.new(fx - 0.15, 17.5, z), RECESS_COL, SM, F, Enum.PartType.Cylinder)
			ghost(body); ghost(top); nr += 1
			table.insert(report, string.format("recess z %.1f face x %.1f %s", z, fx, r.Instance.Name))
		end
	end
	table.insert(report, "recesses " .. nr)
end
--ENDRAID36

-- ================================================================ item 5: falls. Neon core/mid toned down, the sheet and veil 1.5x wide,
-- and one soft mist ellipsoid at the foot of each fall (falls grouped by their x,z).
--FALLS36
do
	local F = Instance.new("Folder"); F.Name = "Falls36"; F.Parent = P36
	local foot = {}
	local n = each(under("Pass32.Falls32"), function(d)
		if d.Name == "FallCore32" then recol(d, FALL_CORE)
		elseif d.Name == "FallMid32" then recol(d, FALL_MID)
		elseif d.Name == "Fall32" or d.Name == "FallVeil32" then
			local s = d:GetAttribute("P36Size") or d.Size
			resize(d, Vector3.new(s.X * FALL_W, s.Y, s.Z))
		end
		local p = d:GetAttribute("P36CF") and d:GetAttribute("P36CF").Position or d.Position
		local key = math.floor(p.X / 6 + 0.5) .. "," .. math.floor(p.Z / 6 + 0.5)
		local by = p.Y - d.Size.Y / 2
		if not foot[key] or by < foot[key].Y then foot[key] = Vector3.new(p.X, by, p.Z) end
	end)
	local nm = 0
	for _, v in pairs(foot) do
		local m = ell("Mist36", Vector3.new(MIST_W, 3, MIST_W * 0.6), CFrame.new(v + Vector3.new(0, 0.8, 0)), MIST_COL, SM, F)
		m.Transparency = MIST_T; nm += 1
	end
	table.insert(report, string.format("fall parts %d mists %d", n, nm))
end
--ENDFALLS36

return table.concat(report, " | ")
end
