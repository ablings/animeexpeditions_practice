-- pass30.lua (practice place only): freestyle pass 30 on top of the pass-29 build (notes/fix_brief30.md, verify27_plaza.md).
-- Run AFTER pass 29 (sh out/r29w/run.sh; then sh out/r30w/run.sh). Idempotent: new pieces live in Plaza.Pass30 (rebuilt each run);
-- every old piece pass 30 touches keeps its pre-pass-30 value in a P30* attribute and is restored first.
-- Attributes: P30Col/P30Mat, P30T/P30CC/P30CQ + P30Hidden, P30CF, P30Size, P30En (emitters/lights), P30SA (SurfaceAppearance tint).
-- Blocks: --JET30, --SUMMON30, --WEST30, --ISL30, --STORY30. No kit this pass (Parts, SpecialMesh ellipsoids and own kit clones).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r30 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import.
-- Pass 28 learned that several parts can share a name: every same-named old kit piece is removed, not just the first.
do
	local src = workspace:FindFirstChild("ae_kit_r30")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale30_stone", true)
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
local old = root:FindFirstChild("Pass30"); if old then old:Destroy() end
local P30 = Instance.new("Folder"); P30.Name = "Pass30"; P30.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P30Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P30T"); d.CanCollide = d:GetAttribute("P30CC"); d.CanQuery = d:GetAttribute("P30CQ") end
		for _, a in ipairs({ "P30Hidden", "P30T", "P30CC", "P30CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P30Col") ~= nil then d.Color = d:GetAttribute("P30Col"); d.Material = Enum.Material[d:GetAttribute("P30Mat")]; d:SetAttribute("P30Col", nil); d:SetAttribute("P30Mat", nil) end
	if d:GetAttribute("P30Size") ~= nil then d.Size = d:GetAttribute("P30Size"); d:SetAttribute("P30Size", nil) end
	if d:GetAttribute("P30CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P30CF")) else d.CFrame = d:GetAttribute("P30CF") end
		d:SetAttribute("P30CF", nil)
	end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P30T") == nil then d:SetAttribute("P30T", d.Transparency); d:SetAttribute("P30CC", d.CanCollide); d:SetAttribute("P30CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P30Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P30Col") == nil then p:SetAttribute("P30Col", p.Color); p:SetAttribute("P30Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P30Size") == nil then p:SetAttribute("P30Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P30CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P30CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P30; return p
end
-- clone a kit MeshPart, scaled about the kit origin, at cf (kit space -> cf); SurfaceAppearance removed so Color shows
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P30; return c
end
-- extra restore: emitters/lights disabled by pass 30 (P30En), SurfaceAppearance tints (P30SA)
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P30En") ~= nil then d.Enabled = d:GetAttribute("P30En"); d:SetAttribute("P30En", nil) end
	if d:GetAttribute("P30SA") ~= nil then d.Color = d:GetAttribute("P30SA"); d:SetAttribute("P30SA", nil) end
	if d:GetAttribute("P30Tx") ~= nil then d.Transparency = d:GetAttribute("P30Tx"); d:SetAttribute("P30Tx", nil) end
end
local function setT(p, t) if p:GetAttribute("P30Tx") == nil then p:SetAttribute("P30Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P30En") == nil then d:SetAttribute("P30En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function satint(sa, col) if sa:GetAttribute("P30SA") == nil then sa:SetAttribute("P30SA", sa.Color) end sa.Color = col end
-- ellipsoid part (Ball parts are always spheres; a SpecialMesh Sphere follows Size)
local function ell(name, size, cf, col, mat, parent)
	local p = part(name, size, cf, col, mat, parent)
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	p.CanCollide = false; p.CanQuery = false; p.CastShadow = false
	return p
end
local function ghost(p) p.CanCollide = false; p.CanQuery = false; p.CastShadow = false; return p end
local report = {}

-- ================================================================ item 1: fountain jets -> frothy white burst. The pass-29 column + glossy cap ball read as a
-- glass lamp. Hide the whole Jet29 set; build a 0.8 x 2.5 column (200,240,250) T 0.35, a Neon core (235,255,255), a crown of
-- 4 upward + 4 outward curved sheets (ellipsoids, about 3 studs across, (215,245,250) T 0.3), a flat froth dome, and twice the spray.
--JET30
local JT = { colW = 0.8, colH = 2.5, col = rgb(200, 240, 250), colT = 0.35, core = rgb(235, 255, 255), coreT = 0.6, sheet = rgb(160, 228, 248), sheetT = 0.3 }
do
	local n = 0
	local J29 = root:FindFirstChild("Pass29") and root.Pass29:FindFirstChild("Jet29")
	local F = Instance.new("Folder"); F.Name = "Jet30"; F.Parent = P30
	if J29 then
		hide(J29); disable(J29)
		for _, c in ipairs(J29:GetChildren()) do
			if c.Name == "Jet29" then
				local x, z = c.Position.X, c.Position.Z
				-- base = the drum water surface right under the jet (the pass-29 column started on the higher back ledge and floated)
				local y0 = 4.2
				for _, w in ipairs(root.Pass9:GetChildren()) do
					if w.Name == "DrumWater" and (Vector3.new(w.Position.X - x, 0, w.Position.Z - z)).Magnitude < 3 then y0 = w.Position.Y + w.Size.X / 2 end
				end
				local up = CFrame.new(x, y0 + JT.colH / 2, z) * CFrame.Angles(0, 0, math.rad(90))
				local col = ghost(part("Jet30", Vector3.new(JT.colH, JT.colW, JT.colW), up, JT.col, SM, F, Enum.PartType.Cylinder)); col.Transparency = JT.colT
				local core = ghost(part("JetCore30", Vector3.new(JT.colH * 0.8, 0.3, 0.3), up * CFrame.new(-0.2, 0, 0), JT.core, Enum.Material.Neon, F, Enum.PartType.Cylinder)); core.Transparency = JT.coreT
				local top = Vector3.new(x, y0 + JT.colH, z)
				-- crown: 6 near-vertical curved sheets flaring out (tilt 25 deg), about 3 across at the top
				for i = 0, 5 do
					local a = math.rad(i * 60 + 15)
					local cf = CFrame.new(top + Vector3.new(math.cos(a) * 0.9, -0.5, math.sin(a) * 0.9)) * CFrame.Angles(0, -a, 0) * CFrame.Angles(0, 0, -math.rad(25))
					local s = ell("JetSheet30", Vector3.new(0.2, 2.4, 1.6), cf, JT.sheet, SM, F); s.Transparency = JT.sheetT + 0.15
				end
				-- froth: overlapping puffs round the column from the drum up to the crown (the white burst mass)
				local rp = Random.new(math.floor(x * 7 + z))
				for i = 1, 9 do
					local a = rp:NextNumber(0, 6.28); local h = rp:NextNumber(0.3, JT.colH + 0.4); local r = 0.4 + 0.5 * (h / JT.colH)
					local k = rp:NextNumber(1.1, 1.7)
					local pf = ell("JetPuff30", Vector3.new(k, k * 0.85, k), CFrame.new(x + math.cos(a) * r, y0 + h, z + math.sin(a) * r), rgb(135, 218, 245), SM, F)
					pf.Transparency = 0.45
				end
				local dome = ell("JetDome30", Vector3.new(2.6, 1.1, 2.6), CFrame.new(top + Vector3.new(0, 0.2, 0)), rgb(190, 240, 252), SM, F); dome.Transparency = 0.35
				local foam = ell("JetFoam30", Vector3.new(3.6, 0.4, 3.6), CFrame.new(x, y0 + 0.1, z), rgb(225, 248, 255), SM, F); foam.Transparency = 0.35
				local a = Instance.new("Attachment"); a.Position = Vector3.new(0, 0.4, 0); a.Parent = dome
				local pe = Instance.new("ParticleEmitter")
				pe.Color = ColorSequence.new(rgb(240, 252, 255), rgb(200, 238, 250))
				pe.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 1) })
				pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1.7) })
				pe.Lifetime = NumberRange.new(0.6, 1.0); pe.Rate = 60; pe.Speed = NumberRange.new(4, 6); pe.SpreadAngle = Vector2.new(35, 35)
				pe.Acceleration = Vector3.new(0, -16, 0); pe.LightEmission = 0.6; pe.EmissionDirection = Enum.NormalId.Top; pe.Parent = a
				local l = Instance.new("PointLight"); l.Color = rgb(170, 230, 250); l.Range = 9; l.Brightness = 0.6; l.Shadows = false; l.Parent = dome
				n += 1
			end
		end
	end
	table.insert(report, "jet30 " .. n)
end
--ENDJET30

-- ================================================================ item 2: Summon facade. Face (215,195,130); pilasters, capitals, cornice and K_Summon9 gold
-- (200,160,70); bigger blue (60,100,200) windows in gold frames 1 stud wide; medallion 5 studs; bunting cut to the one cord at z -72.
--SUMMON30
local SU = { face = rgb(215, 195, 130), gold = rgb(200, 160, 70), blue = rgb(60, 100, 200), fw = 1.0 }
do
	local nc, nw, nb = 0, 0, 0
	local S = root.Pass11:FindFirstChild("Summon11")
	local C = root.Pass17:FindFirstChild("Colonnade17")
	local F = Instance.new("Folder"); F.Name = "Summon30"; F.Parent = P30
	local function isCream(d)
		local h, s, v = d.Color:ToHSV()
		return s < 0.3 and v > 0.85 and h > 0.05 and h < 0.2
	end
	for _, d in ipairs(S and S:GetDescendants() or {}) do
		if d:IsA("BasePart") then
			if d.Name == "K_Summon9_cream" then recol(d, SU.face); nc += 1
			elseif d.Name == "K_Summon9_gold" then recol(d, SU.gold); nc += 1 end
		end
	end
	for _, d in ipairs(C and C:GetChildren() or {}) do
		if d:IsA("BasePart") then
			if d.Name == "Pilaster" or d.Name == "Capital" or d.Name == "Cornice" or d.Name == "CorniceGold" or d.Name == "EntGold" or d.Name == "Key" or d.Name == "DomeBand" then
				recol(d, SU.gold, Enum.Material.Metal); nc += 1
			elseif isCream(d) then recol(d, SU.face); nc += 1 end
		end
	end
	local S29 = root.Pass29:FindFirstChild("Summon29")
	for _, d in ipairs(S29 and S29:GetChildren() or {}) do
		if d.Name:sub(1, 3) == "Win" or d.Name:sub(1, 2) == "Up" then hide(d)
		elseif d.Name == "PilCap29" then recol(d, SU.gold) end
	end
	local function win(x, z, w, y0, h, fw)
		-- glass rectangle + arch, a gold frame fw wide all round, a mullion and a transom
		local fr = ghost(part("WinFrame30", Vector3.new(w + 2 * fw, h + fw, 0.3), CFrame.new(x, y0 + h / 2 - fw / 2, z - 0.1), SU.gold, Enum.Material.Metal, F))
		local fa = ghost(part("WinFrameArch30", Vector3.new(0.3, w + 2 * fw, w + 2 * fw), CFrame.new(x, y0 + h, z - 0.1) * CFrame.Angles(0, math.rad(90), 0), SU.gold, Enum.Material.Metal, F, Enum.PartType.Cylinder))
		local gl = ghost(part("WinGlass30", Vector3.new(w, h, 0.32), CFrame.new(x, y0 + h / 2, z), SU.blue, SM, F))
		local ga = ghost(part("WinGlassArch30", Vector3.new(0.32, w, w), CFrame.new(x, y0 + h, z) * CFrame.Angles(0, math.rad(90), 0), SU.blue, SM, F, Enum.PartType.Cylinder))
		local mu = ghost(part("WinMullion30", Vector3.new(0.35, h + w / 2 - 0.3, 0.36), CFrame.new(x, y0 + (h + w / 2) / 2, z + 0.06), SU.gold, Enum.Material.Metal, F))
		local tr = ghost(part("WinTransom30", Vector3.new(w, 0.35, 0.36), CFrame.new(x, y0 + h - 0.3, z + 0.06), SU.gold, Enum.Material.Metal, F))
		nw += 1
	end
	for _, d in ipairs(C and C:GetChildren() or {}) do
		if d.Name == "Window" then win(d.Position.X, d.Position.Z + 0.3, 4.4, 22.0, 3.9, SU.fw) end
	end
	-- upper storey: 6 tall windows above the colonnade (the pass-29 ones sat behind the entablature)
	for _, x in ipairs({ -26, -18, -10, 10, 18, 26 }) do win(x, -182.6, 4.2, 31.4, 5.6, SU.fw) end
	-- medallion 5 studs on the attic top
	for _, nm in ipairs({ "Medal29", "MedalIn29", "MedalStar29" }) do local m = S29 and S29:FindFirstChild(nm); if m then hide(m) end end
	local at = C and C:FindFirstChild("Attic")
	if at then
		local mc = Vector3.new(at.Position.X, at.Position.Y + 1.3, at.Position.Z + at.Size.Z / 2 + 0.15)
		ghost(part("Medal30", Vector3.new(0.35, 5.0, 5.0), CFrame.new(mc) * CFrame.Angles(0, math.rad(90), 0), SU.gold, Enum.Material.Metal, F, Enum.PartType.Cylinder))
		ghost(part("MedalIn30", Vector3.new(0.4, 3.3, 3.3), CFrame.new(mc + Vector3.new(0, 0, 0.05)) * CFrame.Angles(0, math.rad(90), 0), SU.blue, SM, F, Enum.PartType.Cylinder))
		ghost(part("MedalStar30", Vector3.new(0.45, 1.4, 1.4), CFrame.new(mc + Vector3.new(0, 0, 0.1)) * CFrame.Angles(0, math.rad(90), 0), SU.gold, Enum.Material.Metal, F, Enum.PartType.Cylinder))
	end
	-- bunting: keep the cord at z -72 (it projects above the facade in c4); hide the other two cords and their pennants
	for _, d in ipairs(root.Pass17:GetChildren()) do
		if (d.Name == "Cord17" or d.Name == "Pennant17") and d:IsA("BasePart") and d.Position.Z < -85 then hide(d); nb += 1 end
	end
	table.insert(report, string.format("summon30 recol %d win %d bunting hidden %d", nc, nw, nb))
end
--ENDSUMMON30

-- ================================================================ item 3: W lagoon and lawn. Lagoon (40,95,170) with a (90,170,220) rim, stretched to about
-- 80 x 50 by 3 overlapping lobes (irregular shore); dense blue canopy (40,90,220) over the open W lawn; near palm darker green.
--WEST30
local WE = { water = rgb(22, 58, 118), deep = rgb(15, 42, 95), rim = rgb(55, 125, 185), canopy = { rgb(40, 90, 220), rgb(32, 76, 200), rgb(55, 105, 225), rgb(45, 85, 190) },
	palmLeaf = Color3.fromRGB(80, 135, 45), palmRim = Color3.fromRGB(110, 165, 60) }
do
	local nl, nc = 0, 0
	local F = Instance.new("Folder"); F.Name = "West30"; F.Parent = P30
	local W16 = root.Pass16:FindFirstChild("West16")
	local lag = W16 and W16:FindFirstChild("Lagoon16")
	local deep = W16 and W16:FindFirstChild("LagoonDeep16")
	local sand = W16 and W16:FindFirstChild("LagoonSand16")
	local L9 = root.Pass9:FindFirstChild("Lagoon"); if L9 then recol(L9, WE.water) end
	if lag then
		recol(lag, WE.water); setT(lag, 0)
		if deep then recol(deep, WE.deep); setT(deep, 0) end
		local rot = lag.CFrame - lag.CFrame.Position
		local c0 = lag.Position
		-- lobes: {dx, dz, sizeAlongX, sizeAlongZ}; lagoon axis: the cylinder's X is world up, Y/Z are the plan axes
		local ax = lag.CFrame:VectorToWorldSpace(Vector3.new(0, 1, 0))
		local function disc(name, pos, wx, wz, col, dy, parent)
			-- world-X extent wx, world-Z extent wz
			local sy, sz = wx, wz
			if math.abs(ax.Z) > math.abs(ax.X) then sy, sz = wz, wx end
			local p = part(name, Vector3.new(lag.Size.X, sy, sz), CFrame.new(pos + Vector3.new(0, dy, 0)) * rot, col, SM, parent or F, Enum.PartType.Cylinder)
			p.CanCollide = false; p.CastShadow = false
			return p
		end
		local lobes = { { 0, 0, 60, 40 }, { -20, -12, 44, 30 }, { 14, -10, 36, 26 }, { -12, 12, 34, 22 } }
		for i, l in ipairs(lobes) do
			local pos = c0 + Vector3.new(l[1], 0, l[2])
			disc("LagRim30", pos, l[3] + 6, l[4] + 6, WE.rim, -0.03)
			if sand then disc("LagSand30", pos, l[3] + 16, l[4] + 14, sand.Color, -0.06) end
			if i > 1 then disc("LagWater30", pos, l[3], l[4], WE.water, -0.012) end
			nl += 1
		end
	end
	-- blue canopy: own K_FluffyS_leaf clumps on a jittered grid over the open W lawn
	local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P30 }
	local rnd = Random.new(30)
	for gx = -52, -170, -11 do
		for gz = -104, 104, 11 do
			local x, z = gx + rnd:NextNumber(-4, 4), gz + rnd:NextNumber(-4, 4)
			local inLag = ((x + 95) / 46) ^ 2 + ((z + 38) / 32) ^ 2 < 1
			local inStory = math.abs(z) < 17 and x > -128
			if not inLag and not inStory then
				local hit = workspace:Raycast(Vector3.new(x, 80, z), Vector3.new(0, -90, 0), prm)
				if hit and hit.Position.Y < 9.5 and hit.Instance.Transparency < 0.5 then
					local k = rnd:NextNumber(0.55, 0.95)
					local c = kp("K_FluffyS_leaf", CFrame.new(hit.Position - Vector3.new(0, 1.5 + k, 0)) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0), Vector3.new(k, k * rnd:NextNumber(0.7, 1.0), k),
						WE.canopy[rnd:NextInteger(1, #WE.canopy)], SM, F, "Canopy30")
					if c then c.CanCollide = false; nc += 1 end
				end
			end
		end
	end
	-- near palm (p7): darker green SurfaceAppearance tints
	local gp = root.Pass28:FindFirstChild("GreenPalm28")
	for _, d in ipairs(gp and gp:GetDescendants() or {}) do
		if d:IsA("SurfaceAppearance") then
			if d.Parent.Name == "K_Soft13P_leaf" then satint(d, WE.palmLeaf) elseif d.Parent.Name == "K_Soft13P_leafRim" then satint(d, WE.palmRim) end
		end
	end
	table.insert(report, string.format("west30 lobes %d canopy %d", nl, nc))
end
--ENDWEST30

-- ================================================================ item 4: left and N islands. Pale pads -> leafy green; island grass greener; every fall bright
-- (235,245,250) Neon T 0.3 and at least 4 wide, plus 2 new long falls off the Isl24_4 lip and 2 off NorthIsl22.
--ISL30
local IS = { pad = rgb(205, 232, 95), lump = rgb(150, 198, 78), grass = rgb(140, 195, 75), fringe = rgb(160, 205, 95), fall = rgb(215, 238, 250), fallT = 0.5 }
do
	local np, nf, nn = 0, 0, 0
	local F = Instance.new("Folder"); F.Name = "Isl30"; F.Parent = P30
	local s24 = root.Pass24:FindFirstChild("Sky24")
	local i4 = s24 and s24:FindFirstChild("Isl24_4")
	local ni = root.Pass22:FindFirstChild("Sky22") and root.Pass22.Sky22:FindFirstChild("NorthIsl22")
	for _, m in ipairs({ i4, ni }) do
		for _, d in ipairs(m and m:GetDescendants() or {}) do
			if d:IsA("BasePart") and d.Transparency < 0.9 then
				if d.Name == "K_Soft14C_leafPad" then recol(d, IS.pad); np += 1
				elseif d.Name:find("_grass") then recol(d, IS.grass); np += 1 end
			end
		end
	end
	local i27 = root.Pass27:FindFirstChild("Isl27")
	for _, d in ipairs(i27 and i27:GetChildren() or {}) do if d:IsA("BasePart") and d.Name == "Isl27_lump" then recol(d, IS.lump); np += 1 end end
	local fr = root.Pass25:FindFirstChild("Sky25") and root.Pass25.Sky25:FindFirstChild("IslFringe25")
	for _, d in ipairs(fr and fr:GetDescendants() or {}) do if d:IsA("BasePart") and d.Name:find("leaf") then recol(d, IS.fringe); np += 1 end end
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and (d.Name == "Fall27" or d.Name == "Fall28" or d.Name == "IslFall24") and not d:IsDescendantOf(P30) and d.Transparency < 0.95 then
			recol(d, IS.fall, Enum.Material.Neon); setT(d, IS.fallT)
			if d.Size.X < 4 then resize(d, Vector3.new(4.5, d.Size.Y, d.Size.Z)) end
			nf += 1
		end
	end
	-- new falls: march from the island centre toward the plaza (+z) along x until the last hit; the fall hangs from that lip
	local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Include
	local function lipFall(m, x, len, w)
		if not m then return end
		local cf, s = m:GetBoundingBox()
		prm.FilterDescendantsInstances = { m }
		local cqs = {}
		for _, d in ipairs(m:GetDescendants()) do if d:IsA("BasePart") then cqs[d] = d.CanQuery; d.CanQuery = d.Transparency < 0.9 end end
		local last
		for z = cf.Z - s.Z / 2, cf.Z + s.Z / 2 + 2, 1 do
			local h = workspace:Raycast(Vector3.new(x, cf.Y + s.Y / 2 + 5, z), Vector3.new(0, -s.Y - 10, 0), prm)
			if h and h.Instance.Transparency < 0.9 then last = h.Position end
		end
		for d, v in pairs(cqs) do d.CanQuery = v end
		if not last then return end
		local top = last + Vector3.new(0, -0.4, 0.6)
		local f = part("Fall30", Vector3.new(w, len, 0.6), CFrame.new(top - Vector3.new(0, len / 2, 0)), IS.fall, Enum.Material.Neon, F)
		ghost(f); f.Transparency = IS.fallT
		local lip = part("FallLip30", Vector3.new(w + 0.8, 0.8, 2.2), CFrame.new(top + Vector3.new(0, 0.1, -0.6)), rgb(225, 245, 255), SM, F); ghost(lip)
		local foam = ell("FallFoam30", Vector3.new(w * 1.6, 1.6, 3), CFrame.new(top - Vector3.new(0, len, 0)), rgb(240, 250, 255), SM, F); foam.Transparency = 0.45
		nn += 1
	end
	if i4 then local cf = i4:GetBoundingBox(); lipFall(i4, cf.X - 52, 50, 4.5); lipFall(i4, cf.X + 60, 42, 4) end
	if ni then local cf = ni:GetBoundingBox(); lipFall(ni, cf.X - 30, 46, 4.5); lipFall(ni, cf.X + 28, 36, 3.5) end
	table.insert(report, string.format("isl30 pads %d falls %d new %d", np, nf, nn))
end
--ENDISL30

-- ================================================================ item 5: Story portal. Rim (50,75,120); the pass-29 disc crest replaced by a horseshoe about 6 wide:
-- a gold (200,170,60) arc of 15 blocks (open at the bottom) with a blue (40,70,160) inset arc; inner band (30,45,90); opening darker.
--STORY30
local SR = { rim = rgb(50, 75, 120), gold = rgb(200, 170, 60), inset = rgb(40, 70, 160), band = rgb(30, 45, 90), hole = rgb(6, 12, 28) }
do
	local ok = 0
	local ring = root.Pass23:FindFirstChild("Portal23")
	local S29 = root.Pass29:FindFirstChild("Story29")
	local op = root.Pass14:FindFirstChild("StoryOpening14")
	if ring and S29 and op then
		local F = Instance.new("Folder"); F.Name = "Story30"; F.Parent = P30
		local sil = ring:FindFirstChild("Portal23_silver"); if sil then recol(sil, SR.rim) end
		recol(op, SR.hole)
		local band = S29:FindFirstChild("StoryBand29"); if band then recol(band, SR.band) end
		local top
		for _, nm in ipairs({ "Crest29", "CrestIn29", "CrestCut29", "CrestGem29" }) do
			local p = S29:FindFirstChild(nm)
			if p then if nm == "Crest29" then top = p.Position end; hide(p) end
		end
		if top then
			local c = top + Vector3.new(0.3, 0.1, 0)   -- horseshoe centre: heels sit on the ring top
			local R, n = 2.5, 15
			local a0, a1 = math.rad(-35), math.rad(215)
			local seg = (a1 - a0) / n
			for i = 0, n - 1 do
				local a = a0 + (i + 0.5) * seg
				local p = c + Vector3.new(0, math.sin(a) * R, math.cos(a) * R)
				local t = Vector3.new(0, math.cos(a), -math.sin(a))
				local L = R * seg * 1.15
				ghost(part("Shoe30", Vector3.new(0.7, 1.3, L), CFrame.lookAt(p, p + t, Vector3.xAxis), SR.gold, Enum.Material.Metal, F))
				local pi = c + Vector3.new(0.25, math.sin(a) * R, math.cos(a) * R)
				ghost(part("ShoeInset30", Vector3.new(0.4, 0.55, L * 0.95), CFrame.lookAt(pi, pi + t, Vector3.xAxis), SR.inset, SM, F))
			end
			-- heel caps at both ends and a blue gem in the middle
			for _, a in ipairs({ a0, a1 }) do
				local p = c + Vector3.new(0, math.sin(a) * R, math.cos(a) * R)
				ghost(part("ShoeHeel30", Vector3.new(0.8, 0.8, 1.7), CFrame.new(p - Vector3.new(0, 0.3, 0)), SR.gold, Enum.Material.Metal, F))
			end
			ghost(part("ShoeGem30", Vector3.new(0.5, 1.6, 1.6), CFrame.new(c + Vector3.new(0.2, 0, 0)), SR.inset, Enum.Material.Neon, F, Enum.PartType.Cylinder))
			ok = 1
		end
	end
	table.insert(report, "story30 " .. ok)
end
--ENDSTORY30

-- ================================================================ items 6-8 (small): Expeditions gate glow, bollard base and gold trim, c1 red clump cooler.
--EXTRA30
do
	local F = Instance.new("Folder"); F.Name = "Extra30"; F.Parent = P30
	local g = root.Pass23:FindFirstChild("Gate23") and root.Pass23.Gate23:FindFirstChild("Gate23_swirl")
	if g then recol(g, rgb(4, 92, 102), Enum.Material.Neon); setT(g, 0.3) end
	local nb = 0
	local B = root.Pass20:FindFirstChild("Bollard20")
	for _, d in ipairs(B and B:GetDescendants() or {}) do
		if d:IsA("BasePart") and d.Name == "K_Boll20_base" then
			recol(d, rgb(222, 223, 215))
			local top = d.Position.Y + d.Size.Y / 2
			ghost(part("BollTrim30", Vector3.new(d.Size.X + 0.12, 0.22, d.Size.Z + 0.12), CFrame.new(d.Position.X, top - 0.16, d.Position.Z) * (d.CFrame - d.CFrame.Position), rgb(200, 175, 60), Enum.Material.Metal, F))
			ghost(part("BollTrim30", Vector3.new(d.Size.X + 0.12, 0.22, d.Size.Z + 0.12), CFrame.new(d.Position.X, d.Position.Y - d.Size.Y / 2 + 0.35, d.Position.Z) * (d.CFrame - d.CFrame.Position), rgb(200, 175, 60), Enum.Material.Metal, F))
			nb += 1
		end
	end
	local f26 = root.Pass26:FindFirstChild("Fern26")
	for _, d in ipairs(f26 and f26:GetDescendants() or {}) do if d:IsA("BasePart") and d.Name == "Fern26" then recol(d, rgb(160, 58, 54)) end end
	table.insert(report, "extra30 boll " .. nb)
end
--ENDEXTRA30

return table.concat(report, " | ")
end
