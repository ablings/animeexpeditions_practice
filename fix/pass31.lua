-- pass31.lua (practice place only): freestyle pass 31 on top of the pass-30 build (notes/fix_brief31.md, verify28_plaza.md).
-- Run AFTER pass 30 (sh out/r30w/run.sh; then sh out/r31w/run.sh). Idempotent: new pieces live in Plaza.Pass31 (rebuilt each run);
-- every old piece pass 31 touches keeps its pre-pass-31 value in a P31* attribute and is restored first.
-- Attributes: P31Col/P31Mat, P31T/P31CC/P31CQ + P31Hidden, P31CF, P31Size, P31En (emitters/lights), P31SA, P31Tx.
-- Blocks: --FALLS31, --JET31, --GROUND31, --GATE31, --BOLL31, --EXTRA31. No kit this pass (Parts, SpecialMesh ellipsoids, own kit clones).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r31 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import.
-- Pass 28 learned that several parts can share a name: every same-named old kit piece is removed, not just the first.
do
	local src = workspace:FindFirstChild("ae_kit_r31")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale31_stone", true)
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
local old = root:FindFirstChild("Pass31"); if old then old:Destroy() end
local P31 = Instance.new("Folder"); P31.Name = "Pass31"; P31.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P31Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P31T"); d.CanCollide = d:GetAttribute("P31CC"); d.CanQuery = d:GetAttribute("P31CQ") end
		for _, a in ipairs({ "P31Hidden", "P31T", "P31CC", "P31CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P31Col") ~= nil then d.Color = d:GetAttribute("P31Col"); d.Material = Enum.Material[d:GetAttribute("P31Mat")]; d:SetAttribute("P31Col", nil); d:SetAttribute("P31Mat", nil) end
	if d:GetAttribute("P31Size") ~= nil then d.Size = d:GetAttribute("P31Size"); d:SetAttribute("P31Size", nil) end
	if d:GetAttribute("P31CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P31CF")) else d.CFrame = d:GetAttribute("P31CF") end
		d:SetAttribute("P31CF", nil)
	end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P31T") == nil then d:SetAttribute("P31T", d.Transparency); d:SetAttribute("P31CC", d.CanCollide); d:SetAttribute("P31CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P31Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P31Col") == nil then p:SetAttribute("P31Col", p.Color); p:SetAttribute("P31Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P31Size") == nil then p:SetAttribute("P31Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P31CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P31CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P31; return p
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
	c.Name = name or n; c.Parent = parent or P31; return c
end
-- extra restore: emitters/lights disabled by pass 31 (P31En), SurfaceAppearance tints (P31SA)
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P31En") ~= nil then d.Enabled = d:GetAttribute("P31En"); d:SetAttribute("P31En", nil) end
	if d:GetAttribute("P31SA") ~= nil then d.Color = d:GetAttribute("P31SA"); d:SetAttribute("P31SA", nil) end
	if d:GetAttribute("P31Tx") ~= nil then d.Transparency = d:GetAttribute("P31Tx"); d:SetAttribute("P31Tx", nil) end
end
local function setT(p, t) if p:GetAttribute("P31Tx") == nil then p:SetAttribute("P31Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P31En") == nil then d:SetAttribute("P31En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function satint(sa, col) if sa:GetAttribute("P31SA") == nil then sa:SetAttribute("P31SA", sa.Color) end sa.Color = col end
-- ellipsoid part (Ball parts are always spheres; a SpecialMesh Sphere follows Size)
local function ell(name, size, cf, col, mat, parent)
	local p = part(name, size, cf, col, mat, parent)
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	p.CanCollide = false; p.CanQuery = false; p.CastShadow = false
	return p
end
local function ghost(p) p.CanCollide = false; p.CanQuery = false; p.CastShadow = false; return p end
local report = {}

-- ================================================================ item 1: falls. Every opaque white strip (Ribbon23 (190,250,255) T 0.15 ran from y 128 to the
-- ground and read as a column) is hidden and rebuilt as a fading fall: 6 stacked planes 3.5 wide, T 0.4 -> 0.92 toward the foot,
-- a faint wider back sheet, and a mist puff + emitter at the foot, which ends at y 55 (10-20 above the canopy), never on the ground.
--FALLS31
local FA = { col = rgb(175, 232, 250), mat = Enum.Material.Neon, T0 = 0.3, T1 = 0.95, n = 10, w = 2.6, floor = 60, maxLen = 32, gap = 18, rock = rgb(186, 178, 150), minLen = 14, mist = rgb(235, 248, 255) }
do
	local nf = 0
	local F = Instance.new("Folder"); F.Name = "Falls31"; F.Parent = P31
	local list = {}
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and not d:IsDescendantOf(P31) and d.Transparency < 0.95 then
			local n = d.Name
			if n == "Fall16" or n == "Ribbon23" or n == "IslFall24" or n == "Fall27" or n == "Fall28" or n == "Fall30" then table.insert(list, d)
			elseif n == "FallFoam30" then hide(d)
			elseif n == "FallLip16" or n == "FallLip30" then recol(d, FA.col); setT(d, 0.45) end
		end
	end
	-- fewer falls: keep one per 18 studs of plan distance, in priority order (newest first); the others are only hidden
	local prio = { Fall30 = 1, Fall27 = 2, Fall28 = 3, IslFall24 = 4, Fall16 = 5, Ribbon23 = 6 }
	table.sort(list, function(a, b) if prio[a.Name] ~= prio[b.Name] then return prio[a.Name] < prio[b.Name] end return a.Position.X < b.Position.X end)
	local kept = {}
	for _, d in ipairs(list) do
		local near = false
		for _, k in ipairs(kept) do if (Vector3.new(k.X - d.Position.X, 0, k.Z - d.Position.Z)).Magnitude < FA.gap then near = true end end
		if near then hide(d) else table.insert(kept, d.Position) end
	end
	local nh = #list - #kept
	-- island undersides: dark Slate rock (renders navy in shade) -> light warm stone, so the falls are not white bars on a dark wall
	local nrk = 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and not d:IsDescendantOf(P31) and d.Position.Y > 60 and d.Transparency < 0.9 and d.Material == Enum.Material.Slate and (d.Name:find("_rock") or d.Name:find("Rock")) then
			recol(d, FA.rock, SM); nrk += 1
		end
	end
	table.insert(report, string.format("falls hidden %d rock %d", nh, nrk))
	for _, d in ipairs(list) do
		if d.Transparency > 0.95 then continue end
		local top = d.Position.Y + d.Size.Y / 2
		local bot = math.max(d.Position.Y - d.Size.Y / 2, FA.floor)
		if top - bot < FA.minLen then bot = top - FA.minLen end
		if top - bot > FA.maxLen then bot = top - FA.maxLen end
		local len = top - bot
		local x, z = d.Position.X, d.Position.Z
		hide(d)
		-- face the plaza centre
		local rot = CFrame.lookAt(Vector3.new(x, 0, z), Vector3.new(0, 0, 0)) - Vector3.new(x, 0, z)
		local h = len / FA.n
		for i = 0, FA.n - 1 do
			local u = i / (FA.n - 1)
			local s = ghost(part("Fall31", Vector3.new(FA.w, h + 0.05, 0.3), CFrame.new(x, top - h * (i + 0.5), z) * rot, FA.col, FA.mat, F))
			s.Transparency = FA.T0 + (FA.T1 - FA.T0) * u
		end
		local back = ghost(part("FallVeil31", Vector3.new(FA.w * 1.9, len * 0.7, 0.2), CFrame.new(x, top - len * 0.35, z) * rot * CFrame.new(0, 0, 0.45), FA.col, FA.mat, F))
		back.Transparency = 0.85
		local foot = Vector3.new(x, bot + 1, z)
		local m = ell("FallMist31", Vector3.new(FA.w * 2.4, 4, 4), CFrame.new(foot) * rot, FA.mist, SM, F); m.Transparency = 0.8
		local a = Instance.new("Attachment"); a.Parent = m
		local pe = Instance.new("ParticleEmitter")
		pe.Color = ColorSequence.new(FA.mist)
		pe.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1) })
		pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 3), NumberSequenceKeypoint.new(1, 5) })
		pe.Lifetime = NumberRange.new(1.5, 2.5); pe.Rate = 6; pe.Speed = NumberRange.new(1, 2); pe.SpreadAngle = Vector2.new(180, 180)
		pe.Acceleration = Vector3.new(0, -0.5, 0); pe.LightEmission = 0.3; pe.Parent = a
		nf += 1
	end
	table.insert(report, "falls31 " .. nf)
end
--ENDFALLS31

-- ================================================================ item 2: jets. The pass-30 puffs, dome and ellipsoid sheets (a cloud) are hidden; the column,
-- core and foam disc stay. 6 thin curved sheets per jet (segmented arcs, 0.75 -> 0.4 wide, T 0.35 -> 0.6) rise from the column top
-- and fall outward over the drum to the water; a small rising plume; streak particles (speed 6-8, life 0.6, gravity -20).
--JET31
local JE = { sheet = rgb(165, 228, 248), plume = rgb(160, 225, 245), seg = 6 }
do
	local n = 0
	local J = root:FindFirstChild("Pass30") and root.Pass30:FindFirstChild("Jet30")
	local F = Instance.new("Folder"); F.Name = "Jet31"; F.Parent = P31
	for _, c in ipairs(J and J:GetChildren() or {}) do
		if c.Name == "JetPuff30" or c.Name == "JetSheet30" then hide(c)
		elseif c.Name == "JetDome30" then hide(c); disable(c) end
	end
	for _, c in ipairs(J and J:GetChildren() or {}) do
		if c.Name == "Jet30" then
			local y0 = c.Position.Y - c.Size.X / 2
			local top = Vector3.new(c.Position.X, y0 + c.Size.X, c.Position.Z)
			local rp = Random.new(math.floor(top.X * 13 + top.Z))
			for k = 0, 5 do
				local a = math.rad(k * 60 + rp:NextNumber(-12, 12))
				local dir = Vector3.new(math.cos(a), 0, math.sin(a))
				local reach = rp:NextNumber(1.5, 1.8)
				local pts = {}
				for i = 0, JE.seg do
					local t = i / JE.seg
					pts[i] = top + dir * (0.2 + reach * t) + Vector3.new(0, 2.0 * t - 4.2 * t * t, 0)
				end
				for i = 0, JE.seg - 1 do
					local p, q = pts[i], pts[i + 1]
					local t = (i + 0.5) / JE.seg
					local s = ghost(part("JetArc31", Vector3.new(0.75 - 0.35 * t, 0.12, (q - p).Magnitude + 0.06), CFrame.lookAt((p + q) / 2, q), JE.sheet, SM, F))
					s.Transparency = 0.35 + 0.25 * t
				end
			end
			local pl = ell("JetPlume31", Vector3.new(1.5, 2.2, 1.5), CFrame.new(top + Vector3.new(0, 0.5, 0)), JE.plume, SM, F); pl.Transparency = 0.5
			local at = Instance.new("Attachment"); at.Position = Vector3.new(0, 0.3, 0); at.Parent = pl
			local pe = Instance.new("ParticleEmitter")
			pe.Color = ColorSequence.new(rgb(240, 252, 255), rgb(190, 235, 250))
			pe.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) })
			pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1.0) })
			pe.Squash = NumberSequence.new(1.5)
			pe.Orientation = Enum.ParticleOrientation.VelocityParallel
			pe.Lifetime = NumberRange.new(0.6); pe.Rate = 60; pe.Speed = NumberRange.new(6, 8); pe.SpreadAngle = Vector2.new(25, 25)
			pe.Acceleration = Vector3.new(0, -20, 0); pe.LightEmission = 0.5; pe.EmissionDirection = Enum.NormalId.Top; pe.Parent = at
			local l = Instance.new("PointLight"); l.Color = rgb(170, 230, 250); l.Range = 9; l.Brightness = 0.5; l.Shadows = false; l.Parent = pl
			n += 1
		end
	end
	table.insert(report, "jet31 " .. n)
end
--ENDJET31

-- ================================================================ item 3: ground colour. Lawn Grass parts toward yellow-green (blue down, green down a step);
-- E red carpet of flat red discs over the E lawn (~70 %), red litter on the E stairs, deeper W lagoon, lime fern back at c2.
--GROUND31
local GR = { red = { rgb(220, 60, 60), rgb(200, 45, 50), rgb(232, 78, 70) }, carpet = { rgb(178, 30, 36), rgb(160, 24, 32), rgb(196, 44, 42) }, water = rgb(6, 32, 78), deep = rgb(4, 22, 60), fern = rgb(165, 215, 70) }
do
	local nl, nr, ns = 0, 0, 0
	local F = Instance.new("Folder"); F.Name = "Ground31"; F.Parent = P31
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and not d:IsDescendantOf(P31) and d.Material == Enum.Material.Grass and d.Transparency < 0.9 and d.Position.Y < 9 and d.Size.Y < 4 and d.Size.X * d.Size.Z > 60 then
			local h, s = d.Color:ToHSV()
			if h > 0.2 and h < 0.45 and s > 0.25 then
				local c = d.Color
				recol(d, rgb(math.min(255, c.R * 255 + 6), c.G * 255 - 10, c.B * 255 * 0.35)); nl += 1
			end
		end
	end
	-- S lawn: GroundS (one 1700 x 800 Grass part, (62,112,4)) renders (108,194,102): the sky ambient adds the blue, so only green
	-- and red can move; (72,108,0) Grass rendered about (130,175,90) in a test (SmoothPlastic went flat lime (128,215,55)).
	local gs = root:FindFirstChild("GroundS"); if gs then recol(gs, rgb(72, 108, 0)) end
	-- red carpet: jittered 8-stud grid over the E side, ground-only (Grass / Ground / patch) down-rays
	local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P31 }
	local rnd = Random.new(31)
	for gx = 44, 176, 8 do
		for gz = -164, 164, 8 do
			if rnd:NextNumber() < 0.8 then
				local x, z = gx + rnd:NextNumber(-3, 3), gz + rnd:NextNumber(-3, 3)
				local hit = workspace:Raycast(Vector3.new(x, 70, z), Vector3.new(0, -80, 0), prm)
				local g = hit and hit.Instance
				if g and hit.Position.Y < 9.5 and g.Transparency < 0.5 and (g.Material == Enum.Material.Grass or g.Name:find("Ground") or g.Name:find("patch") or g.Name:find("Lawn")) then
					local k = rnd:NextNumber(1.1, 1.6)
					local p = kp(rnd:NextNumber() < 0.6 and "K_Litter_leaf" or "K_Spill9_leaf", CFrame.new(hit.Position + Vector3.new(0, 0.05 + rnd:NextNumber(0, 0.08), 0)) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0),
						Vector3.new(k, 1, k * rnd:NextNumber(0.8, 1.1)), GR.carpet[rnd:NextInteger(1, 3)], SM, F, "Carpet31")
					if p then ghost(p); nr += 1 end
				end
			end
		end
	end
	-- red litter on the E stairs (p3)
	for i = 1, 14 do
		local x, z = rnd:NextNumber(29, 47), (rnd:NextNumber() < 0.5 and -1 or 1) * rnd:NextNumber(7, 17)
		local hit = workspace:Raycast(Vector3.new(x, 40, z), Vector3.new(0, -50, 0), prm)
		if hit and hit.Instance.Transparency < 0.5 then
			local k = rnd:NextNumber(0.35, 0.55)
			local c = kp("K_Litter_leaf", CFrame.new(hit.Position + Vector3.new(0, 0.05, 0)) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0), Vector3.new(k, 1, k), GR.red[rnd:NextInteger(1, 3)], SM, F, "StairRed31")
			if c then ghost(c); ns += 1 end
		end
	end
	-- deeper W lagoon (water renders about 2x brighter than set from above)
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and not d:IsDescendantOf(P31) and d.Transparency < 0.9 then
			if d.Name == "Lagoon16" or d.Name == "LagWater30" or (d.Name == "Lagoon" and d.Parent.Name == "Pass9") then recol(d, GR.water)
			elseif d.Name == "LagoonDeep16" then recol(d, GR.deep) end
		end
	end
	-- c2 fern: the Fern26 clump at the c2 stair foot back to lime
	local f26 = root.Pass26:FindFirstChild("Fern26")
	for _, d in ipairs(f26 and f26:GetDescendants() or {}) do
		if d:IsA("BasePart") and d.Name == "Fern26" and (Vector3.new(d.Position.X - 8, 0, d.Position.Z - 29)).Magnitude < 4 then recol(d, GR.fern) end
	end
	table.insert(report, string.format("ground31 lawn %d carpet %d stairRed %d", nl, nr, ns))
end
--ENDGROUND31

-- ================================================================ item 4: Expeditions gate. The painted swirl is hidden; a Neon portal plane (15,170,185) T 0.3
-- (rectangle + arch) with a lighter inner glow and a teal light fills the door; two crystal basins ~4 wide flank it; orb ring +10 up.
--GATE31
local GA = { portal = rgb(9, 100, 110), inner = rgb(30, 110, 115), orbMove = Vector3.new(0, -1, 8), stone = rgb(200, 222, 218), gold = rgb(205, 165, 70), cry = rgb(70, 150, 240), water = rgb(90, 205, 230) }
do
	local ok, nb = 0, 0
	local G = root.Pass23:FindFirstChild("Gate23")
	local F = Instance.new("Folder"); F.Name = "Gate31"; F.Parent = P31
	if G then
		local sw = G:FindFirstChild("Gate23_swirl"); if sw then hide(sw) end
		local pan = G:FindFirstChild("DoorPanel23"); local dt = G:FindFirstChild("DoorTop23")
		if pan then
			recol(pan, rgb(0, 115, 130)); if dt then recol(dt, rgb(0, 115, 130)) end
			local zf = pan.Position.Z - pan.Size.Z / 2 - 0.08
			local p1 = ghost(part("Portal31", Vector3.new(pan.Size.X - 0.4, pan.Size.Y - 0.2, 0.1), CFrame.new(pan.Position.X, pan.Position.Y, zf), GA.portal, Enum.Material.Neon, F)); p1.Transparency = 0.3
			if dt then
				local p2 = ghost(part("PortalArch31", Vector3.new(0.1, dt.Size.Y - 0.4, dt.Size.Z - 0.4), CFrame.new(dt.Position.X, dt.Position.Y, zf) * CFrame.Angles(0, math.rad(90), 0), GA.portal, Enum.Material.Neon, F, Enum.PartType.Cylinder)); p2.Transparency = 0.3
			end
			local gl = ell("PortalGlow31", Vector3.new(6, 10, 0.1), CFrame.new(pan.Position.X, pan.Position.Y + 2, zf - 0.06), GA.inner, Enum.Material.Neon, F); gl.Transparency = 0.6
			local l = Instance.new("PointLight"); l.Color = GA.portal; l.Range = 14; l.Brightness = 0.7; l.Shadows = false; l.Parent = p1
			ok = 1
			-- crystal basins either side of the gate, on the ground in front of the frame
			local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P31 }
			for _, sx in ipairs({ -1, 1 }) do
				local x, z = sx * 22, 80
				local hit = workspace:Raycast(Vector3.new(x, 40, z), Vector3.new(0, -50, 0), prm)
				local y = hit and hit.Position.Y or 6.3
				local up = CFrame.Angles(0, 0, math.rad(90))
				part("BasinPed31", Vector3.new(2.2, 2.6, 2.2), CFrame.new(x, y + 1.3, z), GA.stone, SM, F)
				y += 2.6
				part("Basin31", Vector3.new(1.3, 4, 4), CFrame.new(x, y + 0.65, z) * up, GA.stone, SM, F, Enum.PartType.Cylinder)
				ghost(part("BasinRim31", Vector3.new(0.3, 4.4, 4.4), CFrame.new(x, y + 1.35, z) * up, GA.gold, Enum.Material.Metal, F, Enum.PartType.Cylinder))
				ghost(part("BasinWater31", Vector3.new(0.1, 3.5, 3.5), CFrame.new(x, y + 1.42, z) * up, GA.water, Enum.Material.Neon, F, Enum.PartType.Cylinder)).Transparency = 0.3
				for j, k in ipairs({ 0.95, 0.6, 0.55 }) do
					local a = math.rad(j * 120)
					local c = kp("K_Crystal_glass", CFrame.new(x + math.cos(a) * 0.7 * (j > 1 and 1 or 0), y + 1.3, z + math.sin(a) * 0.7 * (j > 1 and 1 or 0)) * CFrame.Angles(math.rad(j > 1 and 18 or 0), a, 0), k, GA.cry, j == 1 and Enum.Material.Neon or SM, F, "BasinCrystal31")
					if c then ghost(c); if j == 1 then c.Color = rgb(40, 120, 220) end end
				end
				nb += 1
			end
		end
	end
	-- orb ring and crescents: 8 back and 1 down, to the reference's screen elevation (22 deg in p2; was 26)
	local ring = root.Landmarks:FindFirstChild("K_ExpRing8")
	if ring then moveTo(ring, function(b) return b + GA.orbMove end) end
	local cr = root.Pass28:FindFirstChild("Cres28")
	for _, p in ipairs(cr and cr:GetChildren() or {}) do if p:IsA("BasePart") then moveTo(p, function(b) return b + GA.orbMove end) end end
	table.insert(report, string.format("gate31 %d basins %d", ok, nb))
end
--ENDGATE31

-- ================================================================ item 5: bollards. The white 3x3 slab, its pass-30 trims and the pyramid head are hidden; a slim
-- grey post (200,205,210) 2 x 2.6 x 2 on a 2.6 plinth, a gold collar and a gold (220,180,60) dome 1.5 x 1.1 with a small finial.
--BOLL31
local BO = { post = rgb(200, 205, 210), plinth = rgb(182, 188, 195), gold = rgb(220, 180, 60) }
do
	local nb = 0
	local F = Instance.new("Folder"); F.Name = "Boll31"; F.Parent = P31
	local B = root.Pass20:FindFirstChild("Bollard20")
	local E30 = root:FindFirstChild("Pass30") and root.Pass30:FindFirstChild("Extra30")
	for _, d in ipairs(E30 and E30:GetChildren() or {}) do if d.Name == "BollTrim30" then hide(d) end end
	for _, d in ipairs(B and B:GetDescendants() or {}) do
		if d:IsA("BasePart") and d.Name == "K_Boll20_head" then hide(d) end
		if d:IsA("BasePart") and d.Name == "K_Boll20_base" then
			hide(d)
			local x, z, y = d.Position.X, d.Position.Z, d.Position.Y - d.Size.Y / 2
			local rot = d.CFrame - d.CFrame.Position
			part("BollPlinth31", Vector3.new(2.6, 0.4, 2.6), CFrame.new(x, y + 0.2, z) * rot, BO.plinth, SM, F)
			part("BollPost31", Vector3.new(2.1, 2.2, 2.1), CFrame.new(x, y + 1.5, z) * rot, BO.post, SM, F)
			ghost(part("BollCollar31", Vector3.new(2.3, 0.3, 2.3), CFrame.new(x, y + 2.65, z) * rot, BO.gold, Enum.Material.Metal, F))
			ell("BollDome31", Vector3.new(1.8, 1.4, 1.8), CFrame.new(x, y + 2.85, z), BO.gold, Enum.Material.Metal, F)
			ell("BollFinial31", Vector3.new(0.4, 0.4, 0.4), CFrame.new(x, y + 3.65, z), BO.gold, Enum.Material.Metal, F)
			nb += 1
		end
	end
	table.insert(report, "boll31 " .. nb)
end
--ENDBOLL31

-- ================================================================ items 6-8 (small): Boss Rush glow, more red litter on the E stairs, palm and gold-tree tints.
--EXTRA31
do
	local F = Instance.new("Folder"); F.Name = "Extra31"; F.Parent = P31
	local B = root.Pass29:FindFirstChild("Boss29")
	local st = B and B:FindFirstChild("GothBoss29_stone")
	local dk = B and B:FindFirstChild("GothBoss29_dark")
	if st and dk then
		recol(st, rgb(120, 55, 120), SM)
		local fx = dk.Position.X - 2.0
		local c = dk.Position
		ghost(part("BossTrim31", Vector3.new(0.4, 21, 0.6), CFrame.new(fx, c.Y - 1, c.Z - 5.6), rgb(220, 60, 160), Enum.Material.Neon, F))
		ghost(part("BossTrim31", Vector3.new(0.4, 21, 0.6), CFrame.new(fx, c.Y - 1, c.Z + 5.6), rgb(220, 60, 160), Enum.Material.Neon, F))
		ghost(part("BossTrim31", Vector3.new(0.4, 0.6, 11.8), CFrame.new(fx, c.Y + 9.8, c.Z), rgb(220, 60, 160), Enum.Material.Neon, F))
		local lp = ghost(part("BossLight31", Vector3.new(0.2, 0.2, 0.2), CFrame.new(fx - 4, c.Y - 2, c.Z), rgb(255, 255, 255), SM, F)); lp.Transparency = 1
		local l = Instance.new("PointLight"); l.Color = rgb(220, 60, 160); l.Range = 20; l.Brightness = 2; l.Shadows = false; l.Parent = lp
	end
	-- more red litter down the E stair flanks (p3)
	local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P31 }
	local rnd = Random.new(311); local ns = 0
	for i = 1, 26 do
		local x, z = rnd:NextNumber(28, 50), (rnd:NextNumber() < 0.5 and -1 or 1) * rnd:NextNumber(4, 18)
		local hit = workspace:Raycast(Vector3.new(x, 40, z), Vector3.new(0, -50, 0), prm)
		if hit and hit.Instance.Transparency < 0.5 then
			local k = rnd:NextNumber(0.3, 0.6)
			local c = kp("K_Litter_leaf", CFrame.new(hit.Position + Vector3.new(0, 0.05, 0)) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0), Vector3.new(k, 1, k), GR.red[rnd:NextInteger(1, 3)], SM, F, "StairRed31")
			if c then ghost(c); ns += 1 end
		end
	end
	-- palms (blue K_Soft13P in Trees13) darker; gold tree (K_Soft15K in Trees13) warmer: scale the SurfaceAppearance tints
	local function sascale(sa, kr, kg, kb)
		if sa:GetAttribute("P31SA") == nil then sa:SetAttribute("P31SA", sa.Color) end
		local c = sa:GetAttribute("P31SA")
		sa.Color = Color3.new(math.min(1, c.R * kr), math.min(1, c.G * kg), math.min(1, c.B * kb))
	end
	local np, ng = 0, 0
	for _, d in ipairs(root.Pass13.Trees13:GetDescendants()) do
		if d:IsA("SurfaceAppearance") then
			if d.Parent.Name:find("K_Soft13P_leaf") then sascale(d, 0.78, 0.78, 0.8); np += 1
			elseif d.Parent.Name:find("K_Soft15K_leaf") and (d.Parent.Position - Vector3.new(5, 70, -178)).Magnitude < 30 then sascale(d, 1.0, 0.95, 0.62); ng += 1 end
		end
	end
	table.insert(report, string.format("extra31 stairRed %d palms %d gold %d", ns, np, ng))
end
--ENDEXTRA31

return table.concat(report, " | ")
end
