-- pass32.lua (practice place only): freestyle pass 32 on top of the pass-31 build (notes/fix_brief32.md, verify29_plaza.md).
-- Run AFTER pass 31 (sh out/r31w/run.sh; then sh out/r32w/run.sh). Idempotent: new pieces live in Plaza.Pass32 (rebuilt each run);
-- every old piece pass 32 touches keeps its pre-pass-32 value in a P32* attribute and is restored first.
-- Attributes: P32Col/P32Mat, P32T/P32CC/P32CQ + P32Hidden, P32CF, P32Size, P32En, P32SA, P32Tx.
-- Blocks: --FALLS32, --SKY32, --GATE32, --BOLL32, --GROUND32, --NICHE32. No kit (Parts, SpecialMesh ellipsoids, own kit clones).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local NE = Enum.Material.Neon
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r32 kit merge (same as the IMPORTS loop of build_plaza.lua), in case a pass-32 kit is ever imported.
do
	local src = workspace:FindFirstChild("ae_kit_r32")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale32_stone", true)
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
local old = root:FindFirstChild("Pass32"); if old then old:Destroy() end
local P32 = Instance.new("Folder"); P32.Name = "Pass32"; P32.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P32Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P32T"); d.CanCollide = d:GetAttribute("P32CC"); d.CanQuery = d:GetAttribute("P32CQ") end
		for _, a in ipairs({ "P32Hidden", "P32T", "P32CC", "P32CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P32Col") ~= nil then d.Color = d:GetAttribute("P32Col"); d.Material = Enum.Material[d:GetAttribute("P32Mat")]; d:SetAttribute("P32Col", nil); d:SetAttribute("P32Mat", nil) end
	if d:GetAttribute("P32Size") ~= nil then d.Size = d:GetAttribute("P32Size"); d:SetAttribute("P32Size", nil) end
	if d:GetAttribute("P32CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P32CF")) else d.CFrame = d:GetAttribute("P32CF") end
		d:SetAttribute("P32CF", nil)
	end
	if d:GetAttribute("P32En") ~= nil then d.Enabled = d:GetAttribute("P32En"); d:SetAttribute("P32En", nil) end
	if d:GetAttribute("P32SA") ~= nil then d.Color = d:GetAttribute("P32SA"); d:SetAttribute("P32SA", nil) end
	if d:GetAttribute("P32Tx") ~= nil then d.Transparency = d:GetAttribute("P32Tx"); d:SetAttribute("P32Tx", nil) end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P32T") == nil then d:SetAttribute("P32T", d.Transparency); d:SetAttribute("P32CC", d.CanCollide); d:SetAttribute("P32CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P32Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P32Col") == nil then p:SetAttribute("P32Col", p.Color); p:SetAttribute("P32Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P32Size") == nil then p:SetAttribute("P32Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P32CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P32CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function setT(p, t) if p:GetAttribute("P32Tx") == nil then p:SetAttribute("P32Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:IsA("Light") and { inst } or inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P32En") == nil then d:SetAttribute("P32En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P32; return p
end
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P32; return c
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
local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P32 }
local function groundY(x, z, maxY, pred)
	-- first hit below maxY on a down-ray (skips canopy above it)
	local o = Vector3.new(x, 80, z)
	local ex = { P32 }
	for i = 1, 8 do
		prm.FilterDescendantsInstances = ex
		local r = workspace:Raycast(o, Vector3.new(0, -120, 0), prm)
		if not r then break end
		if r.Position.Y < maxY and r.Instance.Transparency < 0.5 and (not pred or pred(r.Instance)) then prm.FilterDescendantsInstances = { P32 }; return r.Position.Y, r.Instance end
		table.insert(ex, r.Instance)
	end
	prm.FilterDescendantsInstances = { P32 }
	return nil
end
local report = {}

-- ================================================================ item 1: falls. Pass-31 falls (10 Neon planes 2.6 wide, (175,232,250) T 0.3 -> 0.95) read as
-- short grey strips over the light rock. Rebuilt wider and longer, with a blue body and a white glowing core: per fall a 5-stud
-- body of 12 SmoothPlastic planes (130,205,245) T 0.25 -> 0.9, a 1.2-stud Neon core (225,250,255) T 0.4 -> 0.92 in front, and a
-- 7-stud faint outer veil; length up to 44 (foot never below y 62), mist foot kept from pass 31 (moved to the new foot).
--FALLS32
local FA = { body = rgb(120, 200, 245), mid = rgb(175, 230, 252), core = rgb(230, 250, 255), veil = rgb(170, 225, 250), w = 7, mw = 3.6, cw = 1.6, n = 12, floor = 62, maxLen = 44, T0 = 0.25, T1 = 0.9 }
do
	local F = Instance.new("Folder"); F.Name = "Falls32"; F.Parent = P32
	local src = root:FindFirstChild("Pass31") and root.Pass31:FindFirstChild("Falls31")
	local g, mists = {}, {}
	for _, p in ipairs(src and src:GetChildren() or {}) do
		if p.Name == "Fall31" then
			local k = string.format("%.0f,%.0f", p.Position.X, p.Position.Z)
			g[k] = g[k] or { x = p.Position.X, z = p.Position.Z, top = -1e9, bot = 1e9 }
			g[k].top = math.max(g[k].top, p.Position.Y + p.Size.Y / 2); g[k].bot = math.min(g[k].bot, p.Position.Y - p.Size.Y / 2)
			hide(p)
		elseif p.Name == "FallVeil31" then hide(p)
		elseif p.Name == "FallMist31" then table.insert(mists, p) end
	end
	local nf = 0
	for _, f in pairs(g) do
		local top = f.top
		local len = math.clamp(top - FA.floor, 20, FA.maxLen)
		local x, z = f.x, f.z
		local rot = CFrame.lookAt(Vector3.new(x, 0, z), Vector3.new(0, 0, 0)) - Vector3.new(x, 0, z)
		local h = len / FA.n
		for i = 0, FA.n - 1 do
			local u = i / (FA.n - 1)
			local s = ghost(part("Fall32", Vector3.new(FA.w * (1 - 0.15 * u), h + 0.05, 0.25), CFrame.new(x, top - h * (i + 0.5), z) * rot, FA.body, SM, F))
			s.Transparency = FA.T0 + (FA.T1 - FA.T0) * u ^ 0.8
			local c = ghost(part("FallCore32", Vector3.new(FA.cw, h + 0.05, 0.1), CFrame.new(x, top - h * (i + 0.5), z) * rot * CFrame.new(0, 0, -0.2), FA.core, NE, F))
			c.Transparency = 0.35 + 0.57 * u
			local m = ghost(part("FallMid32", Vector3.new(FA.mw, h + 0.05, 0.1), CFrame.new(x, top - h * (i + 0.5), z) * rot * CFrame.new(0, 0, -0.12), FA.mid, NE, F))
			m.Transparency = 0.55 + 0.4 * u
		end
		local v = ghost(part("FallVeil32", Vector3.new(FA.w * 1.5, len * 0.8, 0.15), CFrame.new(x, top - len * 0.4, z) * rot * CFrame.new(0, 0, 0.4), FA.veil, SM, F))
		v.Transparency = 0.82
		-- move the nearest pass-31 mist to the new foot
		for _, m in ipairs(mists) do
			if (Vector3.new(m.Position.X - x, 0, m.Position.Z - z)).Magnitude < 1 then
				moveTo(m, function(b) return CFrame.new(x, top - len + 1, z) * rot end)
			end
		end
		nf += 1
	end
	table.insert(report, "falls32 " .. nf)
end
--ENDFALLS32

-- ================================================================ item 2: sky gaps. p6: blue palms (own Trees13 palm model, scaled) and a blue canopy mass
-- SW of the plaza, left of the Story ring; p3: a dark brown gothic / dead-tree mass left of the Raid temple.
--SKY32
do
	local F = Instance.new("Folder"); F.Name = "Sky32"; F.Parent = P32
	local np, nd = 0, 0
	-- blue palms: own K_Palm6A pieces (no SurfaceAppearance, so the colour reads saturated from below; the cloned
	-- SA palm rendered pale against the sky in the first try)
	local PALMS = { { -58, 13, 1.1, 20 }, { -66, 28, 1.2, 140 }, { -74, 18, 1.0, 250 }, { -54, 34, 0.95, 80 } }
	for _, t in ipairs(PALMS) do
		local y = groundY(t[1], t[2], 12) or 6
		local cf = CFrame.new(t[1], y - 0.3, t[2]) * CFrame.Angles(0, math.rad(t[4]), 0)
		kp("K_Palm6A_wood", cf, t[3], rgb(105, 72, 48), SM, F, "Palm32_wood")
		local l = kp("K_Palm6A_leaf", cf, t[3], rgb(35, 85, 215), SM, F, "Palm32_leaf")
		local r = kp("K_Palm6A_leafRim", cf, t[3], rgb(60, 115, 230), SM, F, "Palm32_rim")
		if l then ghost(l); ghost(r); np += 1 end
	end
	-- blue canopy mass behind the palms (own fluffy clump, scaled)
	for i, t in ipairs({ { -84, 36, 30, 1.6 }, { -74, 44, 27, 1.4 }, { -92, 22, 33, 1.5 } }) do
		local c = kp("K_FluffyS_leaf", CFrame.new(t[1], t[3] - 9.1 * t[4], t[2]) * CFrame.Angles(0, i * 1.7, 0), t[4], rgb(40, 85, 200), SM, F, "Canopy32")
		if c then ghost(c); np += 1 end
	end
	-- p3: dark mass left of the Raid temple (gothic facades + dead tree, dark brown)
	local DK = rgb(78, 62, 52)
	for i, t in ipairs({ { 80, -66, 2.6, 60 }, { 88, -76, 2.9, 30 }, { 74, -74, 2.0, 100 } }) do
		local y = groundY(t[1], t[2], 30) or 6
		local c = kp("K_Goth28_dark", CFrame.new(t[1], y - 0.5, t[2]) * CFrame.Angles(0, math.rad(t[4]), 0), t[3], DK, Enum.Material.Slate, F, "DarkMass32")
		if c then nd += 1 end
	end
	for i, t in ipairs({ { 70, -60, 2.6, 20 }, { 84, -84, 2.8, 200 } }) do
		local y = groundY(t[1], t[2], 30) or 6
		local c = kp("K_DeadTree_wood", CFrame.new(t[1], y - 0.3, t[2]) * CFrame.Angles(0, math.rad(t[4]), 0), t[3], rgb(70, 52, 44), SM, F, "DarkTree32")
		if c then nd += 1 end
	end
	table.insert(report, string.format("sky32 palms+canopy %d dark %d", np, nd))
end
--ENDSKY32

-- ================================================================ item 3: Expeditions portal. Neon plane (9,100,110) rendered (0,174,200); now SmoothPlastic
-- dark teal (5,90,105) with an own Parts swirl (3 Neon spiral arms) and a light core; orb ring and crescents up.
--GATE32
local GA = { dark = rgb(10, 108, 122), swirl = rgb(24, 110, 114), core = rgb(32, 108, 108), orbUp = Vector3.new(0, 6, 0) }
do
	local F = Instance.new("Folder"); F.Name = "Gate32"; F.Parent = P32
	local G = root:FindFirstChild("Pass31") and root.Pass31:FindFirstChild("Gate31")
	local p1 = G and G:FindFirstChild("Portal31")
	local ok = 0
	if p1 then
		recol(p1, GA.dark, SM); setT(p1, 0)
		local a = G:FindFirstChild("PortalArch31"); if a then recol(a, GA.dark, SM); setT(a, 0) end
		local gl = G:FindFirstChild("PortalGlow31"); if gl then hide(gl) end
		local l = p1:FindFirstChildOfClass("PointLight"); if l then disable(l) end
		local c = p1.Position + Vector3.new(0, 1.5, -0.12)
		-- spiral arms in the portal plane (x, y), facing -z
		for arm = 0, 2 do
			local pts = {}
			for i = 0, 14 do
				local t = i / 14
				local ang = arm * 2.094 + t * 4.2
				local r = 0.4 + 4.4 * t
				pts[i] = c + Vector3.new(math.cos(ang) * r * 0.85, math.sin(ang) * r, 0)
			end
			for i = 0, 13 do
				local p, q = pts[i], pts[i + 1]
				local t = (i + 0.5) / 14
				local s = ghost(part("Swirl32", Vector3.new(0.8 - 0.4 * t, 0.05, (q - p).Magnitude + 0.05), CFrame.lookAt((p + q) / 2, q, Vector3.zAxis), GA.swirl, NE, F))
				s.Transparency = 0.25 + 0.5 * t
			end
		end
		local core = ell("SwirlCore32", Vector3.new(2.2, 3.0, 0.06), CFrame.new(c - Vector3.new(0, 0, 0.02)), GA.core, NE, F); core.Transparency = 0.35
		local pl = Instance.new("PointLight"); pl.Color = GA.core; pl.Range = 10; pl.Brightness = 0.6; pl.Shadows = false; pl.Parent = core
		ok = 1
	end
	local ring = root.Landmarks:FindFirstChild("K_ExpRing8")
	if ring then moveTo(ring, function(b) return b + GA.orbUp end) end
	local cr = root:FindFirstChild("Pass28") and root.Pass28:FindFirstChild("Cres28")
	for _, p in ipairs(cr and cr:GetChildren() or {}) do if p:IsA("BasePart") then moveTo(p, function(b) return b + GA.orbUp end) end end
	table.insert(report, "gate32 " .. ok)
end
--ENDGATE32

-- ================================================================ item 4: bollards. Zoom pair (p5) showed the reference bollard is a LOW WHITE slab, longer
-- radially than wide, with a gold tapered block and a big gold dome on it (the review's (165,163,124) sample was the shaded gold
-- block, not the slab). Pass-31 post (3 studs) and the pass-28 head hidden; new: slab 2 x 0.9 x 3 (226,226,218) with 0.3 chamfer
-- wedges, gold frustum (block + 4 wedges) 1.5 -> 1.0 wide, 0.7 tall, gold dome 1.7 x 1.4 and finial: about 2.6 tall in all.
local BO = { stone = rgb(226, 226, 218), gold = rgb(220, 180, 60) }
do
	local F = Instance.new("Folder"); F.Name = "Boll32"; F.Parent = P32
	local B = root:FindFirstChild("Pass31") and root.Pass31:FindFirstChild("Boll31")
	local nb = 0
	local GM = Enum.Material.Metal
	local function wedge(size, cf, col, mat, name)
		local w = Instance.new("WedgePart"); w.Anchored = true; w.Material = mat; w.Color = col; w.Size = size; w.CFrame = cf
		w.TopSurface = Enum.SurfaceType.Smooth; w.BottomSurface = Enum.SurfaceType.Smooth; w.Name = name; w.Parent = F; return w
	end
	for _, d in ipairs(B and B:GetChildren() or {}) do
		if d.Name == "BollPlinth31" then
			local base = d.Position - Vector3.new(0, d.Size.Y / 2, 0)
			local rot = CFrame.lookAt(Vector3.new(base.X, 0, base.Z), Vector3.new(0, 0, 0)) - Vector3.new(base.X, 0, base.Z)
			local B0 = CFrame.new(base) * rot
			-- slab: 2 wide (x), 3 long (z, radial), 0.6 body + 0.3 chamfer band
			part("BollSlab32", Vector3.new(2, 0.6, 3), B0 * CFrame.new(0, 0.3, 0), BO.stone, SM, F)
			part("BollSlabTop32", Vector3.new(1.4, 0.3, 2.4), B0 * CFrame.new(0, 0.75, 0), BO.stone, SM, F)
			for _, e in ipairs({ { 0, Vector3.new(0, 0.75, -1.35), 1.4 }, { 180, Vector3.new(0, 0.75, 1.35), 1.4 }, { 90, Vector3.new(-0.85, 0.75, 0), 2.4 }, { -90, Vector3.new(0.85, 0.75, 0), 2.4 } }) do
				wedge(Vector3.new(e[3], 0.3, 0.3), B0 * CFrame.new(e[2]) * CFrame.Angles(0, math.rad(e[1]), 0), BO.stone, SM, "BollChamfer32")
			end
			-- gold frustum on the slab: 1.0 core block + 4 wedges 0.25 out = 1.5 at the foot
			part("BollGoldCore32", Vector3.new(1.0, 1.0, 1.0), B0 * CFrame.new(0, 1.4, 0), BO.gold, GM, F)
			for _, e in ipairs({ { 0, Vector3.new(0, 1.4, -0.65) }, { 180, Vector3.new(0, 1.4, 0.65) }, { 90, Vector3.new(-0.65, 1.4, 0) }, { -90, Vector3.new(0.65, 1.4, 0) } }) do
				wedge(Vector3.new(1.0, 1.0, 0.3), B0 * CFrame.new(e[2]) * CFrame.Angles(0, math.rad(e[1]), 0), BO.gold, GM, "BollGoldSide32")
			end
			ell("BollDome32", Vector3.new(1.5, 1.2, 1.5), B0 * CFrame.new(0, 2.0, 0), BO.gold, GM, F)
			ell("BollFinial32", Vector3.new(0.3, 0.3, 0.3), B0 * CFrame.new(0, 2.65, 0), BO.gold, GM, F)
			nb += 1
		end
	end
	for _, d in ipairs(B and B:GetChildren() or {}) do if d:IsA("BasePart") then hide(d) end end
	for _, d in ipairs(root.Pass28:GetChildren()) do if d.Name == "Boll28_head" then hide(d) end end
	table.insert(report, "boll32 " .. nb)
end
--ENDBOLL32

-- ================================================================ item 5: ground. Darker E red palms (sunlit from above they rendered pink), second red/grey
-- rubble scatter over the remaining SE lawn gaps, deeper lagoon.
--GROUND32
do
	local F = Instance.new("Folder"); F.Name = "Ground32"; F.Parent = P32
	local nr, ng, np = 0, 0, 0
	for _, m in ipairs(root.Pass17:GetChildren()) do
		if m.Name == "RedPalm17" then
			for _, d in ipairs(m:GetDescendants()) do
				if d:IsA("BasePart") and (d.Name:find("_leaf")) then recol(d, d.Name:find("Rim") and rgb(92, 26, 26) or rgb(78, 20, 22)); np += 1 end
			end
		end
	end
	local reds = { rgb(178, 30, 36), rgb(160, 24, 32), rgb(196, 44, 42) }
	local rnd = Random.new(32)
	for gx = 40, 184, 7 do
		for gz = -20, 172, 7 do
			if rnd:NextNumber() < 0.85 then
				local x, z = gx + rnd:NextNumber(-3, 3), gz + rnd:NextNumber(-3, 3)
				local gy, g = groundY(x, z, 9.5, function(i) return i.Material == Enum.Material.Grass end)
				local hit = gy and { Position = Vector3.new(x, gy, z) }
				if g and g.Material == Enum.Material.Grass then
					local k = rnd:NextNumber(1.1, 1.7)
					local grey = rnd:NextNumber() < 0.3
					local p = kp(rnd:NextNumber() < 0.6 and "K_Litter_leaf" or "K_Spill9_leaf", CFrame.new(hit.Position + Vector3.new(0, 0.07 + rnd:NextNumber(0, 0.06), 0)) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0),
						Vector3.new(k, 1, k * rnd:NextNumber(0.8, 1.1)), grey and rgb(100, 106, 100) or reds[rnd:NextInteger(1, 3)], grey and Enum.Material.Slate or SM, F, grey and "Rubble32" or "Carpet32")
					if p then ghost(p); if grey then ng += 1 else nr += 1 end end
				end
			end
		end
	end
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and not d:IsDescendantOf(P32) and d.Transparency < 0.9 then
			if d.Name == "Lagoon16" or d.Name == "LagWater30" or (d.Name == "Lagoon" and d.Parent.Name == "Pass9") then recol(d, rgb(2, 30, 62))
			elseif d.Name == "LagoonDeep16" then recol(d, rgb(2, 20, 48)) end
		end
	end
	table.insert(report, string.format("ground32 redpalm %d carpet %d rubble %d", np, nr, ng))
end
--ENDGROUND32

-- ================================================================ item 6: fountain niche and jet core. Tunnel backs near-black navy; the pass-31 plume egg
-- smaller and more transparent.
--NICHE32
do
	local nt, nj = 0, 0
	for _, d in ipairs(root.Pass20:GetChildren()) do
		if d.Name == "TunnelBack20" then recol(d, rgb(10, 25, 40), SM); nt += 1 end
	end
	local J = root:FindFirstChild("Pass31") and root.Pass31:FindFirstChild("Jet31")
	for _, d in ipairs(J and J:GetChildren() or {}) do
		if d.Name == "JetPlume31" then resize(d, d.Size * 0.6); setT(d, 0.62); nj += 1 end
	end
	table.insert(report, string.format("niche32 tunnel %d plume %d", nt, nj))
end
--ENDNICHE32

-- ================================================================ items 7-8 (small): Summon bunting lifted above the cornice line (c4), Boss Rush facade
-- from lilac to dark purple (trims and light from pass 31 stay).
--EXTRA32
do
	local nb = 0
	for _, d in ipairs(root.Pass17:GetDescendants()) do
		if d:IsA("BasePart") and d.Transparency < 0.9 and math.abs(d.Position.Z + 72) < 4 and (d.Name == "Pennant17" or d.Name == "Cord17") then
			moveTo(d, function(b) return b + Vector3.new(0, 3.5, 0) end); nb += 1
		end
	end
	local B = root.Pass29:FindFirstChild("Boss29")
	if B then
		local st = B:FindFirstChild("GothBoss29_stone"); if st then recol(st, rgb(62, 38, 68), SM) end
		local bo = B:FindFirstChild("GothBoss29_bone"); if bo then recol(bo, rgb(100, 72, 108)) end
	end
	table.insert(report, "extra32 bunting " .. nb)
end
--ENDEXTRA32

return table.concat(report, " | ")
end
