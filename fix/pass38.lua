-- pass38.lua (practice place only): freestyle pass 38 on top of the pass-37 build (notes/fix_brief38.md, verify35_plaza.md).
-- Run AFTER pass 37 (sh out/r37w/run.sh; then sh out/r38w/run.sh). Idempotent: new pieces live in Plaza.Pass38 (rebuilt each run);
-- every old piece pass 38 touches keeps its pre-pass-38 value in a P38* attribute and is restored first.
-- Attributes: P38Col/P38Mat, P38T/P38CC/P38CQ + P38Hidden, P38CF, P38Size, P38En, P38SA, P38Tx.
-- Blocks: --JET38, --ARCH38, --RAID38, --NOTCH38, --ARM38 (see body). Kit: ae_kit_r38 if imported (merged below).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local NE = Enum.Material.Neon
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r36 kit merge (same as the IMPORTS loop of build_plaza.lua), in case a pass-38 kit is ever imported.
do
	local src = workspace:FindFirstChild("ae_kit_r38")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale38_stone", true)
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
local old = root:FindFirstChild("Pass38"); if old then old:Destroy() end
local P38 = Instance.new("Folder"); P38.Name = "Pass38"; P38.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P38Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P38T"); d.CanCollide = d:GetAttribute("P38CC"); d.CanQuery = d:GetAttribute("P38CQ") end
		for _, a in ipairs({ "P38Hidden", "P38T", "P38CC", "P38CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P38Col") ~= nil then d.Color = d:GetAttribute("P38Col"); d.Material = Enum.Material[d:GetAttribute("P38Mat")]; d:SetAttribute("P38Col", nil); d:SetAttribute("P38Mat", nil) end
	if d:GetAttribute("P38Size") ~= nil then d.Size = d:GetAttribute("P38Size"); d:SetAttribute("P38Size", nil) end
	if d:GetAttribute("P38CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P38CF")) else d.CFrame = d:GetAttribute("P38CF") end
		d:SetAttribute("P38CF", nil)
	end
	if d:GetAttribute("P38En") ~= nil then d.Enabled = d:GetAttribute("P38En"); d:SetAttribute("P38En", nil) end
	if d:GetAttribute("P38SA") ~= nil then d.Color = d:GetAttribute("P38SA"); d:SetAttribute("P38SA", nil) end
	if d:GetAttribute("P38Tx") ~= nil then d.Transparency = d:GetAttribute("P38Tx"); d:SetAttribute("P38Tx", nil) end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P38T") == nil then d:SetAttribute("P38T", d.Transparency); d:SetAttribute("P38CC", d.CanCollide); d:SetAttribute("P38CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P38Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P38Col") == nil then p:SetAttribute("P38Col", p.Color); p:SetAttribute("P38Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P38Size") == nil then p:SetAttribute("P38Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P38CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P38CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function setT(p, t) if p:GetAttribute("P38Tx") == nil then p:SetAttribute("P38Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:IsA("Light") and { inst } or inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P38En") == nil then d:SetAttribute("P38En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P38; return p
end
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P38; return c
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
local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P38 }
local function groundY(x, z, maxY, pred)
	-- first hit below maxY on a down-ray (skips canopy above it)
	local o = Vector3.new(x, 80, z)
	local ex = { P38 }
	for i = 1, 8 do
		prm.FilterDescendantsInstances = ex
		local r = workspace:Raycast(o, Vector3.new(0, -120, 0), prm)
		if not r then break end
		if r.Position.Y < maxY and r.Instance.Transparency < 0.5 and (not pred or pred(r.Instance)) then prm.FilterDescendantsInstances = { P38 }; return r.Position.Y, r.Instance end
		table.insert(ex, r.Instance)
	end
	prm.FilterDescendantsInstances = { P38 }
	return nil
end
local report = {}
local function under(path) local r = root for s in path:gmatch("[^%.]+") do r = r and r:FindFirstChild(s) end return r end
local function each(inst, f) if not inst then return 0 end local n = 0 for _, d in ipairs(inst:GetDescendants()) do if d:IsA("BasePart") then f(d); n += 1 end end return n end
local function scaleCol(c, k) return Color3.new(c.R * k, c.G * k, c.B * k) end
local rnd = Random.new(38)
-- tuning (pass 38)
-- item 1: jet. The pass-37 spill (3-wide pale sheet) read as a block from the front; narrower, more see-through sheet with a darker
-- body over the black niche, a bright froth crown where it lands, and a soft plume above the lip. Same curl as pass 37 (c2).
local SHEET_W, SHEET_T, SHEET_COL = 2.0, 0.55, Color3.fromRGB(110, 160, 180) -- c1 (640,400) target (84,118,133) over the niche
local CROWN_COL, CROWN_T, CROWN_SIZE = Color3.fromRGB(245, 252, 252), 0.1, Vector3.new(2.4, 0.6, 1.5) -- c1 (640,430) target (226,254,254)
local LIPFROTH_SIZE, LIPFROTH_T = Vector3.new(2.3, 0.4, 0.7), 0.2
local PLUME_W, PLUME_Y = 34.5, 4.5 -- misty plume: a smoke ParticleEmitter (engine texture) on the landing; an ellipsoid read as an orb
local PLUME_TEX = "rbxasset://textures/particles/smoke_main.dds"
local PLUME_RATE, PLUME_LIFE, PLUME_SPEED = 40, 1.3, 1.6
-- item 2: arch U face values per corner (ref: the sunlit NE U face is light grey (134,136,138) in c1, p1 and p3; the others darker)
-- pass 37 had NE dark (56,61,66) from a c1 box that in the ref lies on the dark shoulder, not on the U face.
local STONE38 = { NE = Color3.fromRGB(100, 102, 105), NW = Color3.fromRGB(96, 100, 105), SE_armF = Color3.fromRGB(150, 158, 168) }
-- item 3: Raid arcade maroon (under red light (96,88,84) rendered grey-pink (111,104,108))
local ARC_STONE38, ARC_TRIM38 = Color3.fromRGB(50, 16, 20), Color3.fromRGB(40, 14, 20)
-- item 4: notch recess: dark slab behind the gold sill hides the lit vault band (c3 (640,500) (159,177,187) -> (60,65,80))
local NOTCH_COL, NOTCH_DW, NOTCH_H, NOTCH_Y0 = Color3.fromRGB(34, 40, 52), 0.35, 1.1, 8.95
-- item 6: shoulder band (pass-36 light slate (112,116,122)) a step darker so the light U reads against it (p5 (520,300) (201,204,207) -> (160,162,128))
local SLATE38 = nil -- (92,96,102) tested: c1 (340,300) 148 -> 118 vs ref 143 and p5 (520,300) unchanged (not this piece): reverted
-- item 10: Expeditions sign teal (p2 (640,240) (65,174,173) -> (107,228,226)); was SmoothPlastic (100,230,200)
local SIGN_COL = Color3.fromRGB(150, 255, 255)

local P37 = root:FindFirstChild("Pass37")
-- ================================================================ item 1: jet plume (replaces the pass-37 sheet, froth and plume)
--JET38
do
	local F = Instance.new("Folder"); F.Name = "Jet38"; F.Parent = P38
	local J = P37 and P37:FindFirstChild("Jet37")
	local nh = 0
	if J then for _, d in ipairs(J:GetChildren()) do if d.Name == "Sheet37" or d.Name == "Froth37" or d.Name == "Plume37" then hide(d); nh += 1 end end end
	local up = Vector3.new(0, 1, 0)
	for _, c in ipairs({ { 1, -1 }, { 1, 1 }, { -1, 1 }, { -1, -1 } }) do
		local dd = Vector3.new(c[1], 0, c[2]).Unit
		local u = Vector3.new(-c[2], 0, c[1]).Unit
		local function W(w, y) return dd * w + up * y end
		local function fu(pos, yax) return CFrame.fromMatrix(pos, u, yax or up) end
		local sh = {}
		table.insert(sh, part("Sheet38", Vector3.new(SHEET_W, 0.1, 1.3), fu(W(36.35, 6.06)), SHEET_COL, SM, F))
		local cw, cy, R, n = 35.7, 4.86, 1.2, 6
		for k = 0, n - 1 do
			local a0, a1 = math.rad(90 + 90 * k / n), math.rad(90 + 90 * (k + 1) / n)
			local q0 = W(cw + R * math.cos(a0), cy + R * math.sin(a0)); local q1 = W(cw + R * math.cos(a1), cy + R * math.sin(a1))
			local am = (a0 + a1) / 2
			local nrm = (dd * math.cos(am) + up * math.sin(am)).Unit
			table.insert(sh, part("Sheet38", Vector3.new(SHEET_W, 0.1, (q1 - q0).Magnitude + 0.06), fu((q0 + q1) / 2, nrm), SHEET_COL, SM, F))
		end
		table.insert(sh, part("Sheet38", Vector3.new(SHEET_W, 0.75, 0.1), fu(W(cw - R, 4.5)), SHEET_COL, SM, F))
		for _, p in ipairs(sh) do ghost(p); p.Transparency = SHEET_T end
		local f1 = ell("LipFroth38", LIPFROTH_SIZE, fu(W(35.55, 6.05)), CROWN_COL, SM, F); f1.Transparency = LIPFROTH_T
		local f2 = ell("Crown38", CROWN_SIZE, fu(W(34.3, 4.35)), CROWN_COL, SM, F); f2.Transparency = CROWN_T
		local src = ghost(part("PlumeSrc38", Vector3.new(1.4, 0.2, 0.8), fu(W(PLUME_W, PLUME_Y)), CROWN_COL, SM, F)); src.Transparency = 1
		local pe = Instance.new("ParticleEmitter"); pe.Name = "Plume38"
		pe.Texture = PLUME_TEX; pe.Rate = PLUME_RATE; pe.Lifetime = NumberRange.new(PLUME_LIFE * 0.7, PLUME_LIFE)
		pe.Speed = NumberRange.new(PLUME_SPEED * 0.7, PLUME_SPEED); pe.SpreadAngle = Vector2.new(8, 8)
		pe.EmissionDirection = Enum.NormalId.Top; pe.LightEmission = 0.25; pe.LightInfluence = 0.8
		pe.Color = ColorSequence.new(Color3.fromRGB(215, 245, 252), Color3.fromRGB(110, 180, 215))
		pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.0), NumberSequenceKeypoint.new(1, 1.9) })
		pe.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.6, 0.6), NumberSequenceKeypoint.new(1, 1) })
		pe.Rotation = NumberRange.new(0, 360); pe.RotSpeed = NumberRange.new(-40, 40); pe.Acceleration = Vector3.new(0, -0.6, 0)
		pe.Parent = src
	end
	table.insert(report, "jet37 hidden " .. nh)
end
--ENDJET38

-- ================================================================ item 2 + 5: arch stone per corner / class (pass-37 split pieces)
--ARCH38
do
	local A = P37 and P37:FindFirstChild("Arch37")
	local n = 0
	if A then
		for _, p in ipairs(A:GetChildren()) do
			local corner, cls = p.Name:match("K_Arch37_(%u%u)_(%a+)")
			if corner then
				local col = STONE38[corner .. "_" .. cls] or STONE38[corner]
				if col then recol(p, col); n += 1 end
			end
		end
	end
	local sl = under("Pass20.K_Arch20_slate"); if sl and SLATE38 then recol(sl, SLATE38) end
	table.insert(report, "arch38 recoloured " .. n)
end
--ENDARCH38

-- ================================================================ item 3: Raid arcade maroon
--RAID38
do
	local R = P37 and P37:FindFirstChild("Raid37")
	local n = 0
	if R then
		for _, p in ipairs(R:GetChildren()) do
			if p.Name == "ArcWall37" then recol(p, ARC_STONE38); n += 1
			elseif p.Name == "ArcCornice37" or p.Name == "ArcPlinth37" or p.Name == "ArcPilaster37" or p.Name == "ArcTrim37" or p.Name == "ArcTrimTop37" then recol(p, ARC_TRIM38); n += 1 end
		end
	end
	table.insert(report, "arcade recoloured " .. n)
end
--ENDRAID38

-- ================================================================ item 4: notch recess (dark slab just behind each gold notch sill)
--NOTCH38
do
	local F = Instance.new("Folder"); F.Name = "Notch38"; F.Parent = P38
	local n = 0
	for _, s in ipairs(root:GetDescendants()) do
		if s:IsA("BasePart") and s.Name == "NotchSill21" and not s:IsDescendantOf(P38) then
			local flat = Vector3.new(s.Position.X, 0, s.Position.Z)
			local dd = flat.Unit
			local u = Vector3.new(-dd.Z, 0, dd.X)
			local pos = dd * (flat.Magnitude + NOTCH_DW) + Vector3.new(0, NOTCH_Y0 + NOTCH_H / 2, 0)
			ghost(part("NotchBack38", Vector3.new(s.Size.X - 0.1, NOTCH_H, 0.12), CFrame.fromMatrix(pos, u, Vector3.new(0, 1, 0)), NOTCH_COL, SM, F))
			n += 1
		end
	end
	table.insert(report, "notch backs " .. n)
end
--ENDNOTCH38

-- ================================================================ item 10: sign teal
--SIGN38
do local sg = under("Pass9.K_TxtExp9.K_TxtExp9_letters"); if sg and SIGN_COL then recol(sg, SIGN_COL) end end
--ENDSIGN38

table.insert(report, "Plaza " .. #root:GetDescendants())
return table.concat(report, " | ")
end
