-- pass37.lua (practice place only): freestyle pass 37 on top of the pass-35 build (notes/fix_brief37.md, verify34_plaza.md).
-- Run AFTER pass 36 (sh out/r36w/run.sh; then sh out/r37w/run.sh). Idempotent: new pieces live in Plaza.Pass37 (rebuilt each run);
-- every old piece pass 37 touches keeps its pre-pass-37 value in a P37* attribute and is restored first.
-- Attributes: P37Col/P37Mat, P37T/P37CC/P37CQ + P37Hidden, P37CF, P37Size, P37En, P37SA, P37Tx.
-- Blocks: --SKY37, --RAID37, --JET37, --P2_37, --ARCH37 (see body). Kit: ae_kit_r37 if one is ever imported (merged below).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local NE = Enum.Material.Neon
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r36 kit merge (same as the IMPORTS loop of build_plaza.lua), in case a pass-37 kit is ever imported.
do
	local src = workspace:FindFirstChild("ae_kit_r37")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale37_stone", true)
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
local old = root:FindFirstChild("Pass37"); if old then old:Destroy() end
local P37 = Instance.new("Folder"); P37.Name = "Pass37"; P37.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P37Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P37T"); d.CanCollide = d:GetAttribute("P37CC"); d.CanQuery = d:GetAttribute("P37CQ") end
		for _, a in ipairs({ "P37Hidden", "P37T", "P37CC", "P37CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P37Col") ~= nil then d.Color = d:GetAttribute("P37Col"); d.Material = Enum.Material[d:GetAttribute("P37Mat")]; d:SetAttribute("P37Col", nil); d:SetAttribute("P37Mat", nil) end
	if d:GetAttribute("P37Size") ~= nil then d.Size = d:GetAttribute("P37Size"); d:SetAttribute("P37Size", nil) end
	if d:GetAttribute("P37CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P37CF")) else d.CFrame = d:GetAttribute("P37CF") end
		d:SetAttribute("P37CF", nil)
	end
	if d:GetAttribute("P37En") ~= nil then d.Enabled = d:GetAttribute("P37En"); d:SetAttribute("P37En", nil) end
	if d:GetAttribute("P37SA") ~= nil then d.Color = d:GetAttribute("P37SA"); d:SetAttribute("P37SA", nil) end
	if d:GetAttribute("P37Tx") ~= nil then d.Transparency = d:GetAttribute("P37Tx"); d:SetAttribute("P37Tx", nil) end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P37T") == nil then d:SetAttribute("P37T", d.Transparency); d:SetAttribute("P37CC", d.CanCollide); d:SetAttribute("P37CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P37Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P37Col") == nil then p:SetAttribute("P37Col", p.Color); p:SetAttribute("P37Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P37Size") == nil then p:SetAttribute("P37Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P37CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P37CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function setT(p, t) if p:GetAttribute("P37Tx") == nil then p:SetAttribute("P37Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:IsA("Light") and { inst } or inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P37En") == nil then d:SetAttribute("P37En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P37; return p
end
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P37; return c
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
local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P37 }
local function groundY(x, z, maxY, pred)
	-- first hit below maxY on a down-ray (skips canopy above it)
	local o = Vector3.new(x, 80, z)
	local ex = { P37 }
	for i = 1, 8 do
		prm.FilterDescendantsInstances = ex
		local r = workspace:Raycast(o, Vector3.new(0, -120, 0), prm)
		if not r then break end
		if r.Position.Y < maxY and r.Instance.Transparency < 0.5 and (not pred or pred(r.Instance)) then prm.FilterDescendantsInstances = { P37 }; return r.Position.Y, r.Instance end
		table.insert(ex, r.Instance)
	end
	prm.FilterDescendantsInstances = { P37 }
	return nil
end
local report = {}
local function under(path) local r = root for s in path:gmatch("[^%.]+") do r = r and r:FindFirstChild(s) end return r end
local function each(inst, f) if not inst then return 0 end local n = 0 for _, d in ipairs(inst:GetDescendants()) do if d:IsA("BasePart") then f(d); n += 1 end end return n end
local function scaleCol(c, k) return Color3.new(c.R * k, c.G * k, c.B * k) end
local rnd = Random.new(37)
-- tuning (pass 37)
local SKY_ORIENT = Vector3.new(0, 340, 0) -- item 1: skybox turned -20 deg: c3 (300,40) cloud (228,232,235) -> blue (68,165,243), cloud mass centred like the ref; 90 gave c3 sat 117 (ref 94); 15/30/55/90/180/270/330/345 tested (out/r37w/t_sky*.jpg)
-- item 1: Raid arcade (curved low wall, 3 dark arched bays a side), stone surround target (152,119,111) rendered
local ARC_STONE, ARC_BAY, ARC_TRIM = Color3.fromRGB(96, 88, 84), Color3.fromRGB(10, 4, 6), Color3.fromRGB(74, 68, 64) -- (150,128,124) rendered (245,150,165) under the red lights
local ARC_X0, ARC_Z0, ARC_Z1, ARC_BACK = 151.0, 8.5, 31.0, -4.0 -- front face x at the door side, z from the door frame to the tower, x setback at the far end
local ARC_Y0, ARC_H, BAY_W, BAY_H = 7.0, 23.0, 5.2, 15.0 -- wall base, wall height, bay width, bay rectangle height (+ half-disc on top)
-- item 4: niche spill (replaces the box jet)
local SHEET_COL, SHEET_T, FROTH_COL = Color3.fromRGB(150, 205, 225), 0.1, Color3.fromRGB(240, 248, 250)
local SPOUT_COL = Color3.fromRGB(28, 32, 40)
local DRUM_COL, DRUM_MAT = Color3.fromRGB(62, 100, 112), Enum.Material.Neon -- p5 jet base (201,233,210) -> (60,138,169); SmoothPlastic (60,140,175) still gave (168,223,202) (sun glare)
local NICHE_LIGHTS_OFF = true
-- item 5: p2
local RING_COL, RING_MAT = Color3.fromRGB(160, 166, 176), Enum.Material.SmoothPlastic -- ring segments (Pass28.Cres28, Slate (130,138,155) rendering (95,110,142)) to grey-blue (120,135,160)
local SIGN_K, SIGN_DY = 1.5, -6.0 -- Expeditions sign 1.5x, lowered onto the gate crest (ref centre ~50 px lower in p2)
local FRINGE_DY = -10 -- S island fringe band lowered (p2 (720,200) to sky)
-- item 3: arch gold pipe toned (p5 (500,330) (178,153,65) -> ~(150,125,45)); nil = unchanged
local GOLD_COL = Color3.fromRGB(175, 135, 48)
-- items 2-3 kit (ae_kit_r37): authored bbox centres (out/r37w/r37_info.json)
local ARCH_BB = Vector3.new(0, 6.25, 0)
local BB37 = {
	K_Arch37_NE_armF = Vector3.new(23.335, 10.55, -23.335),
	K_Arch37_NE_face = Vector3.new(23.335, 4.85, -23.335),
	K_Arch37_NE_side = Vector3.new(25.633, 6.25, -25.633),
	K_Arch37_NW_armF = Vector3.new(-23.335, 10.55, -23.335),
	K_Arch37_NW_face = Vector3.new(-23.335, 4.85, -23.335),
	K_Arch37_NW_side = Vector3.new(-25.633, 6.25, -25.633),
	K_Arch37_SE_armF = Vector3.new(23.335, 10.55, 23.335),
	K_Arch37_SE_face = Vector3.new(23.335, 4.85, 23.335),
	K_Arch37_SE_side = Vector3.new(25.633, 6.25, 25.633),
	K_Arch37_SW_armF = Vector3.new(-23.335, 10.55, 23.335),
	K_Arch37_SW_face = Vector3.new(-23.335, 4.85, 23.335),
	K_Arch37_SW_side = Vector3.new(-25.633, 6.25, 25.633),
	K_Groove37_dark = Vector3.new(0.0, 5.625, 0.0),
}
local STONE37 = { face = Color3.fromRGB(72, 78, 84), armF = Color3.fromRGB(72, 78, 84), side = Color3.fromRGB(72, 78, 84), NE = Color3.fromRGB(56, 61, 66), SE = Color3.fromRGB(110, 117, 128) } -- per corner ("NE"), per class ("side") or both ("NE_side"); tint showed the visible front U face is in "side" (normal test missed it), so colour by corner
local GROOVE_COL = Color3.fromRGB(70, 78, 88) -- target (45,53,62) rendered; (30,36,42) read as wide black stripes

-- ================================================================ item 1a: skybox orientation (global; checked on all sky cameras)
--SKY37
do
	local sky = game.Lighting:FindFirstChildOfClass("Sky")
	if sky then
		if sky:GetAttribute("P37SkyO") == nil then sky:SetAttribute("P37SkyO", sky.SkyboxOrientation) end
		sky.SkyboxOrientation = SKY_ORIENT or sky:GetAttribute("P37SkyO")
		table.insert(report, "sky " .. tostring(sky.SkyboxOrientation))
	end
end
--ENDSKY37

-- ================================================================ item 1b: Raid arcade. A low curved wall each side of the door, from the
-- door frame back to the tower, with 3 dark arched bays (Neon near-black rect + half disc) in a stone surround, pilasters and a cornice.
--RAID37
do
	local F = Instance.new("Folder"); F.Name = "Raid37"; F.Parent = P37
	local up = Vector3.new(0, 1, 0)
	local function P(t, s) return Vector3.new(ARC_X0 + ARC_BACK * t ^ 1.5, 0, s * (ARC_Z0 + (ARC_Z1 - ARC_Z0) * t)) end
	local nb = 0
	for _, s in ipairs({ -1, 1 }) do
		for i = 0, 2 do
			local p0, p1 = P(i / 3, s), P((i + 1) / 3, s)
			local T = (p1 - p0).Unit
			if T:Cross(up).X > 0 then T = -T end
			local front = T:Cross(up) -- points toward the plaza (-x)
			local L = (p1 - p0).Magnitude
			local mid = (p0 + p1) / 2
			local function at(f, y) return mid + front * f + up * y end
			local function fr(pos, axisFront) if axisFront then return CFrame.fromMatrix(pos, front, up) end return CFrame.fromMatrix(pos, T, up) end
			part("ArcWall37", Vector3.new(L + 0.2, ARC_H, 1.6), fr(at(-0.8, ARC_Y0 + ARC_H / 2)), ARC_STONE, SM, F)
			part("ArcCornice37", Vector3.new(L + 0.6, 0.9, 2.4), fr(at(-0.5, ARC_Y0 + ARC_H + 0.45)), ARC_TRIM, SM, F)
			part("ArcPlinth37", Vector3.new(L + 0.2, 0.6, 2.2), fr(at(-0.6, ARC_Y0 + 0.3)), ARC_TRIM, SM, F)
			local yb = ARC_Y0 + 0.6 + BAY_H / 2
			part("ArcTrim37", Vector3.new(BAY_W + 1.0, BAY_H, 0.2), fr(at(0.05, yb)), ARC_TRIM, SM, F)
			part("ArcTrimTop37", Vector3.new(0.2, BAY_W + 1.0, BAY_W + 1.0), fr(at(0.05, yb + BAY_H / 2), true), ARC_TRIM, SM, F, Enum.PartType.Cylinder)
			ghost(part("ArcBay37", Vector3.new(BAY_W, BAY_H, 0.2), fr(at(0.12, yb)), ARC_BAY, NE, F))
			ghost(part("ArcBayTop37", Vector3.new(0.2, BAY_W, BAY_W), fr(at(0.12, yb + BAY_H / 2), true), ARC_BAY, NE, F, Enum.PartType.Cylinder))
			for _, pe in ipairs({ p0, p1 }) do
				part("ArcPilaster37", Vector3.new(1.2, ARC_H, 2.2), CFrame.fromMatrix(pe + front * -0.5 + up * (ARC_Y0 + ARC_H / 2), T, up), ARC_TRIM, SM, F)
			end
			nb += 1
		end
	end
	table.insert(report, "arcade bays " .. nb)
end
--ENDRAID37

-- ================================================================ item 4: niche spill. The box jet, arcs, plume and the teal niche sheet are
-- hidden; per corner a dark spout block with a gold lip, a water sheet that runs over the lip and curls down onto the drum, froth at the
-- lip and the landing, a soft plume; the drum water darker; the niche lights off.
--JET37
do
	local F = Instance.new("Folder"); F.Name = "Jet37"; F.Parent = P37
	local nh = 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and not d:IsDescendantOf(P37) and (d.Name:match("^Jet") or d.Name == "NicheSheet33" or d.Name == "NicheLip33") and d.Transparency < 1 then hide(d); nh += 1 end
		if d:IsA("BasePart") and d.Name == "DrumWater" then recol(d, DRUM_COL, DRUM_MAT) end
		if NICHE_LIGHTS_OFF and d:IsA("BasePart") and (d.Name == "TunnelLight19" or d.Name == "TunnelFill22") then disable(d) end
	end
	local up = Vector3.new(0, 1, 0)
	local gold = under("Pass20.K_Arch20_gold")
	for _, c in ipairs({ { 1, -1 }, { 1, 1 }, { -1, 1 }, { -1, -1 } }) do
		local dd = Vector3.new(c[1], 0, c[2]).Unit
		local u = Vector3.new(-c[2], 0, c[1]).Unit
		local function W(w, y) return dd * w + up * y end
		local function fu(pos, yax) return CFrame.fromMatrix(pos, u, yax or up) end
		part("Spout37", Vector3.new(3.6, 1.4, 2.0), fu(W(36.9, 5.3)), SPOUT_COL, SM, F)
		ghost(part("SpoutLip37", Vector3.new(3.8, 0.18, 0.18), fu(W(35.9, 6.0)), Color3.fromRGB(175, 140, 55), Enum.Material.Metal, F))
		local sh = {}
		table.insert(sh, part("Sheet37", Vector3.new(3.0, 0.1, 1.3), fu(W(36.35, 6.06)), SHEET_COL, SM, F))
		local cw, cy, R, n = 35.7, 4.86, 1.2, 6
		for k = 0, n - 1 do
			local a0, a1 = math.rad(90 + 90 * k / n), math.rad(90 + 90 * (k + 1) / n)
			local q0 = W(cw + R * math.cos(a0), cy + R * math.sin(a0)); local q1 = W(cw + R * math.cos(a1), cy + R * math.sin(a1))
			local am = (a0 + a1) / 2
			local nrm = (dd * math.cos(am) + up * math.sin(am)).Unit
			table.insert(sh, part("Sheet37", Vector3.new(3.0, 0.1, (q1 - q0).Magnitude + 0.06), fu((q0 + q1) / 2, nrm), SHEET_COL, SM, F))
		end
		table.insert(sh, part("Sheet37", Vector3.new(3.0, 0.75, 0.1), fu(W(cw - R, 4.5)), SHEET_COL, SM, F))
		for _, p in ipairs(sh) do ghost(p); p.Transparency = SHEET_T end
		local f1 = ell("Froth37", Vector3.new(3.4, 0.45, 0.8), fu(W(35.55, 6.05)), FROTH_COL, SM, F); f1.Transparency = 0.15
		local f2 = ell("Froth37", Vector3.new(3.2, 0.45, 1.4), fu(W(34.3, 4.25)), FROTH_COL, SM, F); f2.Transparency = 0.3
		local f3 = ell("Plume37", Vector3.new(2.2, 1.5, 1.0), fu(W(35.7, 6.75)), FROTH_COL, SM, F); f3.Transparency = 0.55
	end
	table.insert(report, "jet parts hidden " .. nh)
end
--ENDJET37

-- ================================================================ item 5: p2 ring segments grey-blue, sign 1.5x lower, S fringe lowered
--P2_37
do
	local nr = each(under("Pass28.Cres28"), function(d) recol(d, RING_COL, RING_MAT) end)
	table.insert(report, "ring segments " .. nr)
	local sg = under("Pass9.K_TxtExp9.K_TxtExp9_letters")
	if sg then
		resize(sg, (sg:GetAttribute("P37Size") or sg.Size) * SIGN_K)
		moveTo(sg, function(cf) return cf + Vector3.new(0, SIGN_DY, 0) end)
	end
	local nf = 0
	if FRINGE_DY ~= 0 then
		for _, m in ipairs(under("Pass25.Sky25"):GetChildren()) do
			if m.Name == "IslFringe25" then
				local p = (m:GetAttribute("P37CF") or m:GetPivot()).Position
				if p.Y < 95 and p.Z > 200 then moveTo(m, function(cf) return cf + Vector3.new(0, FRINGE_DY, 0) end); nf += 1 end
			end
		end
	end
	table.insert(report, "fringes lowered " .. nf)
end
--ENDP2_37

-- ================================================================ item 3: arch gold tone
--ARCH37
-- items 2-3 (kit ae_kit_r37): K_Arch20_stone is replaced by its 12 split pieces (per corner: armF / face / side), each coloured on
-- its own; K_Groove37_dark adds two dark grooves in the light shoulder band. Placed at PIECE_BB + (K_Arch20_stone.Position - ARCH_BB).
do
	local g = under("Pass20.K_Arch20_gold"); if g and GOLD_COL then recol(g, GOLD_COL) end
	local F = Instance.new("Folder"); F.Name = "Arch37"; F.Parent = P37
	local A = under("Pass20.K_Arch20_stone")
	local n = 0
	if A and kit and kit:FindFirstChild("K_Arch37_NE_face") then
		for name, bb in pairs(BB37) do
			local k = kit:FindFirstChild(name)
			if k then
				local c = k:Clone(); c.Anchored = true
				for _, sa in ipairs(c:GetChildren()) do if sa:IsA("SurfaceAppearance") then sa:Destroy() end end
				c.CFrame = CFrame.new(bb + (A.Position - ARCH_BB))
				local corner, cls = name:match("K_Arch37_(%u%u)_(%a+)")
				local col = name == "K_Groove37_dark" and GROOVE_COL or (STONE37[corner .. "_" .. cls] or STONE37[corner] or STONE37[cls])
				c.Color = col; c.Material = SM; c.DoubleSided = true; c.Parent = F; n += 1 -- the split pieces render hollow single-sided (some arm faces culled)
				if name == "K_Groove37_dark" then ghost(c) else c.CanCollide = A.CanCollide end
			end
		end
		hide(A)
	end
	table.insert(report, "arch37 pieces " .. n)
end
--ENDARCH37

table.insert(report, "Plaza " .. #root:GetDescendants())
return table.concat(report, " | ")
end
