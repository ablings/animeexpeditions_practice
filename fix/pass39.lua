-- pass39.lua (practice place only): freestyle pass 39 on top of the pass-38 build (notes/fix_brief39.md, verify36_plaza.md).
-- Run AFTER pass 38 (sh out/r38w/run.sh; then sh out/r39w/run.sh). Idempotent: new pieces live in Plaza.Pass39 (rebuilt each run);
-- every old piece pass 39 touches keeps its pre-pass-39 value in a P39* attribute and is restored first.
-- Attributes: P39Col/P39Mat, P39T/P39CC/P39CQ + P39Hidden, P39CF, P39Size, P39En, P39SA, P39Tx.
-- Blocks: --JET39, --ARCH39 (see body). Kit: ae_kit_r39 if imported (merged below).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local NE = Enum.Material.Neon
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r36 kit merge (same as the IMPORTS loop of build_plaza.lua), in case a pass-39 kit is ever imported.
do
	local src = workspace:FindFirstChild("ae_kit_r39")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale39_stone", true)
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
local old = root:FindFirstChild("Pass39"); if old then old:Destroy() end
local P39 = Instance.new("Folder"); P39.Name = "Pass39"; P39.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P39Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P39T"); d.CanCollide = d:GetAttribute("P39CC"); d.CanQuery = d:GetAttribute("P39CQ") end
		for _, a in ipairs({ "P39Hidden", "P39T", "P39CC", "P39CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P39Col") ~= nil then d.Color = d:GetAttribute("P39Col"); d.Material = Enum.Material[d:GetAttribute("P39Mat")]; d:SetAttribute("P39Col", nil); d:SetAttribute("P39Mat", nil) end
	if d:GetAttribute("P39Size") ~= nil then d.Size = d:GetAttribute("P39Size"); d:SetAttribute("P39Size", nil) end
	if d:GetAttribute("P39CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P39CF")) else d.CFrame = d:GetAttribute("P39CF") end
		d:SetAttribute("P39CF", nil)
	end
	if d:GetAttribute("P39En") ~= nil then d.Enabled = d:GetAttribute("P39En"); d:SetAttribute("P39En", nil) end
	if d:GetAttribute("P39SA") ~= nil then d.Color = d:GetAttribute("P39SA"); d:SetAttribute("P39SA", nil) end
	if d:GetAttribute("P39Tx") ~= nil then d.Transparency = d:GetAttribute("P39Tx"); d:SetAttribute("P39Tx", nil) end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P39T") == nil then d:SetAttribute("P39T", d.Transparency); d:SetAttribute("P39CC", d.CanCollide); d:SetAttribute("P39CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P39Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P39Col") == nil then p:SetAttribute("P39Col", p.Color); p:SetAttribute("P39Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P39Size") == nil then p:SetAttribute("P39Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P39CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P39CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function setT(p, t) if p:GetAttribute("P39Tx") == nil then p:SetAttribute("P39Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:IsA("Light") and { inst } or inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P39En") == nil then d:SetAttribute("P39En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P39; return p
end
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P39; return c
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
local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P39 }
local function groundY(x, z, maxY, pred)
	-- first hit below maxY on a down-ray (skips canopy above it)
	local o = Vector3.new(x, 80, z)
	local ex = { P39 }
	for i = 1, 8 do
		prm.FilterDescendantsInstances = ex
		local r = workspace:Raycast(o, Vector3.new(0, -120, 0), prm)
		if not r then break end
		if r.Position.Y < maxY and r.Instance.Transparency < 0.5 and (not pred or pred(r.Instance)) then prm.FilterDescendantsInstances = { P39 }; return r.Position.Y, r.Instance end
		table.insert(ex, r.Instance)
	end
	prm.FilterDescendantsInstances = { P39 }
	return nil
end
local report = {}
local function under(path) local r = root for s in path:gmatch("[^%.]+") do r = r and r:FindFirstChild(s) end return r end
local function each(inst, f) if not inst then return 0 end local n = 0 for _, d in ipairs(inst:GetDescendants()) do if d:IsA("BasePart") then f(d); n += 1 end end return n end
local function scaleCol(c, k) return Color3.new(c.R * k, c.G * k, c.B * k) end
local rnd = Random.new(39)
-- tuning (pass 39)
-- item 1: jet = a wide blue waterfall from the spout lip curling down onto the drum (ref: blue translucent fall with white edges,
-- ~60 % of the niche, a pale froth ring where it lands, a small blue-white mist at the lip). Replaces the pass-38 sheet/crown/plume.
local FALL_W, FALL_COL, FALL_MAT, FALL_T = 3.2, Color3.fromRGB(150, 215, 235), Enum.Material.SmoothPlastic, 0.15 -- Neon (55,120,150) rendered pure cyan (1,199,253)
local FALL_TAPER = 0.7 -- width at the lip as a fraction of the width at the landing
local EDGE_COL, EDGE_W, EDGE_T = Color3.fromRGB(225, 248, 252), 0.2, 0.1
local FROTH_COL, FROTH_T = Color3.fromRGB(200, 235, 245), 0.3
local MIST_RATE, MIST_LE = 12, 0
-- item 2: arch shoulders. Ref order outside -> in: light outer rim, a WIDE dark slatted band (ridged), gold line, light U face.
-- Ours had light-ish slate bands and the U face starting right at the gold line, so the dark band now sits ON the pale face.
local RIM_SLATE, RIM_GROOVE = Color3.fromRGB(130, 135, 140), Color3.fromRGB(100, 105, 110) -- outer slate bands become the light rim
local BAND_F, BAND_COL, RIDGE_COL = 0.55, Color3.fromRGB(45, 49, 48), Color3.fromRGB(88, 94, 96) -- dark band = outer 55 % of the pale face
local RIDGES = { 0.2, 0.4 }
local BAND_GOLD = Color3.fromRGB(175, 135, 48)
-- item 3: Raid arcade. Rendered = k*col + haze at ~150 studs (fit from (50,16,20)->(69,60,73) and (96,88,84)->(111,104,108):
-- R 0.91x+24, G 0.61x+50, B 0.55x+62), so G/B cannot go below the haze; push R up, G/B to ~0 for the reddest maroon.
local ARC_STONE39, ARC_TRIM39 = Color3.fromRGB(50, 7, 10), Color3.fromRGB(40, 6, 9) -- (80,4,4) overshot: p3 (600,320) R 167 (red lights)

local P37 = root:FindFirstChild("Pass37")
local P38f = root:FindFirstChild("Pass38")
local up = Vector3.new(0, 1, 0)
-- ================================================================ item 1: jet waterfall
--JET39
do
	local F = Instance.new("Folder"); F.Name = "Jet39"; F.Parent = P39
	local J = P38f and P38f:FindFirstChild("Jet38")
	local nh = 0
	if J then
		for _, d in ipairs(J:GetChildren()) do
			if d.Name == "Sheet38" or d.Name == "LipFroth38" or d.Name == "Crown38" then hide(d); nh += 1 end
			if d.Name == "PlumeSrc38" then disable(d) end
		end
	end
	for _, c in ipairs({ { 1, -1 }, { 1, 1 }, { -1, 1 }, { -1, -1 } }) do
		local dd = Vector3.new(c[1], 0, c[2]).Unit
		local u = Vector3.new(-c[2], 0, c[1]).Unit
		local function W(w, y, uu) return dd * w + up * y + u * (uu or 0) end
		local function fu(pos, yax) return CFrame.fromMatrix(pos, u, yax or up) end
		-- path in the (w, y) plane: flat run off the lip, quarter curl (R 1.2), drop onto the drum top (y 4.1)
		local path = { { 36.6, 6.08 }, { 35.7, 6.06 } }
		local cw, cy, R, n = 35.7, 4.86, 1.2, 8
		for k = 1, n do local a = math.rad(90 + 90 * k / n); table.insert(path, { cw + R * math.cos(a), cy + R * math.sin(a) }) end
		table.insert(path, { cw - R - 0.05, 4.15 })
		for i = 1, #path - 1 do
			local q0, q1 = W(path[i][1], path[i][2]), W(path[i + 1][1], path[i + 1][2])
			local t = (q1 - q0).Unit
			local nrm = t:Cross(u).Unit
			if nrm:Dot(-dd + up) < 0 then nrm = -nrm end -- face the plaza / sky
			local L = (q1 - q0).Magnitude + 0.06
			local cf = CFrame.fromMatrix((q0 + q1) / 2, u, nrm)
			local fw = FALL_W * (FALL_TAPER + (1 - FALL_TAPER) * (i - 0.5) / (#path - 1)) -- fans out as it falls
			local s = ghost(part("Fall39", Vector3.new(fw, 0.1, L), cf, FALL_COL, FALL_MAT, F)); s.Transparency = FALL_T
			for _, e in ipairs({ -1, 1 }) do
				local ed = ghost(part("FallEdge39", Vector3.new(EDGE_W, 0.12, L), cf * CFrame.new(e * (fw / 2 - EDGE_W / 2), 0.01, 0), EDGE_COL, SM, F)); ed.Transparency = EDGE_T
			end
		end
		-- froth ring where it lands (flat, pale blue-white, not a white dome)
		local fr = ghost(part("Froth39", Vector3.new(0.12, FALL_W + 0.4, 1.4), CFrame.new(W(34.25, 4.2)) * CFrame.Angles(0, 0, math.rad(90)), FROTH_COL, SM, F, Enum.PartType.Cylinder))
		fr.Transparency = FROTH_T
		-- a few white flecks on the face of the fall
		for k = 1, 5 do
			local a = math.rad(90 + 90 * (k / 6)); local pw, py = cw + (R + 0.07) * math.cos(a), cy + (R + 0.07) * math.sin(a)
			ghost(part("Fleck39", Vector3.new(0.15 + rnd:NextNumber() * 0.2, 0.06, 0.1), fu(W(pw, py, rnd:NextNumber(-1.2, 1.2)), (dd * math.cos(a) + up * math.sin(a)).Unit), EDGE_COL, SM, F))
		end
		-- small mist at the lip
		local src = ghost(part("MistSrc39", Vector3.new(FALL_W, 0.2, 0.6), fu(W(35.8, 6.2)), EDGE_COL, SM, F)); src.Transparency = 1
		local pe = Instance.new("ParticleEmitter"); pe.Name = "Mist39"
		pe.Texture = "rbxasset://textures/particles/smoke_main.dds"; pe.Rate = MIST_RATE; pe.Lifetime = NumberRange.new(0.6, 1.0)
		pe.Speed = NumberRange.new(0.4, 0.8); pe.SpreadAngle = Vector2.new(15, 15); pe.EmissionDirection = Enum.NormalId.Top
		pe.LightEmission = MIST_LE; pe.LightInfluence = 1
		pe.Color = ColorSequence.new(Color3.fromRGB(210, 240, 250), Color3.fromRGB(127, 186, 203))
		pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1.2) })
		pe.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.6, 0.75), NumberSequenceKeypoint.new(1, 1) })
		pe.Rotation = NumberRange.new(0, 360); pe.RotSpeed = NumberRange.new(-30, 30)
		pe.Parent = src
	end
	table.insert(report, "jet38 hidden " .. nh)
end
--ENDJET39

-- ================================================================ item 2: arch shoulders (light outer rim, wide dark ridged band on the pale face)
--ARCH39
do
	local F = Instance.new("Folder"); F.Name = "Arch39"; F.Parent = P39
	local sl = under("Pass20.K_Arch20_slate"); if sl then recol(sl, RIM_SLATE) end
	local gr = P37 and P37:FindFirstChild("Arch37") and P37.Arch37:FindFirstChild("K_Groove37_dark"); if gr then recol(gr, RIM_GROOVE) end
	-- arch curves (same maths as tools/ae_kit.py A19/A20: _arc19(a_p, b_p) = pale band outer edge, _intrados19 = opening)
	local cu, cy, a_p, b_p, nA, nL = 3.9, 4.4, 4.4, 5.3, 14, 3
	local hw, hs, ry = 7.6, 1.1, 5.4
	local W0 = 33.0
	local function po(s)
		local t = {}
		for k = 0, nA do t[#t + 1] = { s * (cu + a_p * math.sin(math.pi / 2 * k / nA)), cy + b_p * math.cos(math.pi / 2 * k / nA) } end
		for k = 1, nL do t[#t + 1] = { s * (cu + a_p), cy * (1 - k / nL) } end
		return t
	end
	local function pin(s)
		local t = {}; local t0 = math.asin(cu / hw)
		for k = 0, nA do local a = t0 + (math.pi / 2 - t0) * k / nA; t[#t + 1] = { s * hw * math.sin(a), hs + ry * math.cos(a) } end
		for k = 1, nL do t[#t + 1] = { s * hw, hs * (1 - k / nL) } end
		return t
	end
	local R2 = math.sqrt(2)
	local function world(uu, y, w, mx, mz) return Vector3.new((w + uu) / R2 * mx, y, (uu - w) / R2 * mz) end
	local nseg = 0
	local function strip(name, A, B, w, col, mat, thick, mx, mz)
		-- A, B: lists of (u, y) along the two edges; one box per segment in the w = const plane
		local wn = (world(0, 0, 1, mx, mz) - world(0, 0, 0, mx, mz)).Unit -- depth axis
		for k = 1, #A - 1 do
			local a0 = world(A[k][1], A[k][2], w, mx, mz); local a1 = world(A[k + 1][1], A[k + 1][2], w, mx, mz)
			local b0 = world(B[k][1], B[k][2], w, mx, mz); local b1 = world(B[k + 1][1], B[k + 1][2], w, mx, mz)
			local m0, m1 = (a0 + b0) / 2, (a1 + b1) / 2
			local L = (m1 - m0).Magnitude
			if L > 1e-3 then
				local t = (m1 - m0).Unit
				local across = wn:Cross(t).Unit
				local wid = ((a0 - b0).Magnitude + (a1 - b1).Magnitude) / 2
				ghost(part(name, Vector3.new(L + 0.08, wid, thick), CFrame.fromMatrix((m0 + m1) / 2, t, across), col, mat or SM, F))
				nseg += 1
			end
		end
	end
	local function lerpL(A, B, f) local t = {} for k = 1, #A do t[k] = { A[k][1] + (B[k][1] - A[k][1]) * f, A[k][2] + (B[k][2] - A[k][2]) * f } end return t end
	for _, m in ipairs({ { 1, 1 }, { -1, 1 }, { 1, -1 }, { -1, -1 } }) do
		for _, s in ipairs({ 1, -1 }) do
			local O, I = po(s), pin(s)
			strip("Band39", lerpL(O, I, 0.02), lerpL(O, I, BAND_F), W0 - 0.04, BAND_COL, SM, 0.06, m[1], m[2])
			for _, f in ipairs(RIDGES) do strip("Ridge39", lerpL(O, I, f * BAND_F - 0.025), lerpL(O, I, f * BAND_F + 0.025), W0 - 0.08, RIDGE_COL, SM, 0.06, m[1], m[2]) end
			strip("BandGold39", lerpL(O, I, BAND_F - 0.03), lerpL(O, I, BAND_F + 0.01), W0 - 0.1, BAND_GOLD, Enum.Material.Metal, 0.12, m[1], m[2])
		end
	end
	table.insert(report, "arch39 segs " .. nseg)
end
--ENDARCH39

-- ================================================================ item 3: Raid arcade maroon (redder)
--RAID39
do
	local R = P37 and P37:FindFirstChild("Raid37")
	local n = 0
	if R then
		for _, p in ipairs(R:GetChildren()) do
			if p.Name == "ArcWall37" then recol(p, ARC_STONE39); n += 1
			elseif p.Name == "ArcCornice37" or p.Name == "ArcPlinth37" or p.Name == "ArcPilaster37" or p.Name == "ArcTrim37" or p.Name == "ArcTrimTop37" then recol(p, ARC_TRIM39); n += 1 end
		end
	end
	table.insert(report, "arcade recoloured " .. n)
end
--ENDRAID39

table.insert(report, "Plaza " .. #root:GetDescendants())
return table.concat(report, " | ")
end
