-- pass16.lua (practice place only): freestyle pass 16 on top of the pass-15 build (notes/fix_brief16.md, verify13_plaza.md).
-- Run AFTER pass 15. Idempotent: new pieces live in Plaza.Pass16 (rebuilt each run); hidden old pieces get the attribute
-- P16Hidden; recoloured old pieces keep their original colour in P16Col; moved/scaled island pieces keep the applied move in
-- P16D / P16S (re-runs move by wanted - applied).
-- Items: 1 Raid red light (haze band, facade wash, uplights, door glow, keystone skull, upright red palm), 2 skyline (N islands
-- bigger and lower, trees, falls, aqueduct), 3 bollards + medallion, 4 W quarter (lagoon, arena, cover, Story limbs),
-- 5 grass on the S/W stairs.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r16 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r16")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale16_stone", true)
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
local old = root:FindFirstChild("Pass16"); if old then old:Destroy() end
local P16 = Instance.new("Folder"); P16.Name = "Pass16"; P16.Parent = root
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P16
	return p
end
local function ghost(p) p.Transparency = 1; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false; return p end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P16T") == nil then d:SetAttribute("P16T", d.Transparency) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P16Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P16Col") == nil then p:SetAttribute("P16Col", p.Color) end
	p.Color = col; if mat then p.Material = mat end
end
local function groundY(x, z, top)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P16 }
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -240, 0), rp)
	return r and r.Position.Y or 0
end
local function kitModel(prefix, cf, scale, parent, colf)
	-- clone every kit part K_<prefix>_<tok> into one model; cf = frame of the kit origin; colf(tok, part) styles it
	local m = Instance.new("Model"); m.Name = prefix
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
			local c = k:Clone(); c.Size = k.Size * scale; c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
			c.Anchored = true
			if colf then colf(k.Name:match("_(%a+)$"), c) end
			c.Parent = m
		end
	end
	m.Parent = parent or P16; return m
end
local function kitExt(prefix)
	local lo, hi = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then lo = lo:Min(k.Position - k.Size / 2); hi = hi:Max(k.Position + k.Size / 2) end
	end
	return lo, hi
end
local SPR = { blue = "rbxassetid://118173022878419", gold = "rbxassetid://94449468583229", purple = "rbxassetid://108341914835015", grey = "rbxassetid://92399071475046" }
local ROUGH, METAL = "rbxassetid://79618306495225", "rbxassetid://133069801476067"
local function soft(prefix, foot, scale, fam, tint, parent, yaw, woodCol)
	-- pass-15 soft(): foot = lowest point; tint = {core, rim} for the grey leaf texture
	local lo = kitExt(prefix)
	local cf = CFrame.new(foot - Vector3.new(0, lo.Y * scale, 0)) * CFrame.Angles(0, yaw or 0, 0)
	local m = Instance.new("Model"); m.Name = prefix
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
			local c = k:Clone(); c.Size = k.Size * scale; c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
			c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CanTouch = false; c.Material = SM
			local tok = k.Name:match("_(%a+)$")
			if tok == "wood" then c.Color = woodCol or rgb(105, 76, 52)
			else
				c.CastShadow = false
				for _, o in ipairs(c:GetChildren()) do if o:IsA("SurfaceAppearance") then o:Destroy() end end
				local sa = Instance.new("SurfaceAppearance"); sa.AlphaMode = Enum.AlphaMode.Transparency
				sa.ColorMap = SPR[fam] or SPR.grey; sa.RoughnessMap = ROUGH; sa.MetalnessMap = METAL
				local col = tint and ((tok == "leafRim") and tint[2] or tint[1]) or ((tok == "leafRim") and rgb(255, 255, 255) or rgb(225, 225, 225))
				sa.Color = col; c.Color = col; sa.Parent = c
			end
			c.Parent = m
		end
	end
	m.Parent = parent or P16; return m
end
_G.P16 = { part = part, ghost = ghost, hide = hide, recol = recol, groundY = groundY, kitModel = kitModel, kitExt = kitExt, soft = soft, P16 = P16 }
local report = {}

-- ================================================================ item 1: Raid lit red
--RAID
local R = root.Pass11.Raid11
do
	-- (a) facade wash: the facade faces west, into the sun (sun dir -0.27, 0.85, 0.45), so it reads as daylit brick whatever the
	-- lights do. The reference's red is in the stone's own lit colour: raise the brick from (95,40,45) toward red.
	local FAC, TRIM16, DEEP16 = rgb(128, 46, 48), rgb(160, 62, 60), rgb(60, 14, 18) -- t1 (168,64,60): the facade foot sampled (165,55,62) where the reference foot is dark (50,45,47)
	local trimNames = { RaidButtress = true, RaidPinnacle = true, RaidGablePin = true, RaidFacadeCap = true }
	for _, x in ipairs(R:GetChildren()) do
		if x:IsA("BasePart") and (x.Name:sub(1, 9) == "RaidFacad" or x.Name:sub(1, 9) == "RaidGable" or trimNames[x.Name]) then
			if x.Name == "RaidGableRecess" then recol(x, DEEP16)
			elseif trimNames[x.Name] then recol(x, TRIM16)
			else recol(x, FAC) end
		elseif x:IsA("Model") and (x.Name == "K_Gothic" or x.Name == "K_Spire" or x.Name == "K_RTower7" or x.Name == "K_Arcade7") then
			for _, d in ipairs(x:GetDescendants()) do
				if d:IsA("BasePart") then
					local tok = d.Name:match("_(%a+)$")
					if tok == "stone" then recol(d, (x.Name == "K_Gothic") and rgb(170, 84, 82) or FAC)
					elseif tok == "darkStone" then recol(d, (x.Name == "K_Gothic") and rgb(8, 4, 6) or DEEP16)
					elseif tok == "dome" then recol(d, TRIM16) end
				end
			end
		end
	end
	-- skull: lit brick-rose (reference lit (232,139,123); t1 sampled (183,52,58))
	local P15s = root:FindFirstChild("Pass15") and root.Pass15:FindFirstChild("K_Skull15")
	for _, d in ipairs(P15s and P15s:GetChildren() or {}) do
		local tok = d.Name:match("_(%a+)$")
		if tok == "bone" then recol(d, rgb(196, 112, 100)) elseif tok == "pillar" then recol(d, rgb(150, 62, 60)) end
	end
	-- (b) the round halo goes: pass-15 emitters off, pass-13 foot glows off
	local P15 = root:FindFirstChild("Pass15")
	local S15 = P15 and P15:FindFirstChild("RaidSmoke15")
	if S15 then for _, d in ipairs(S15:GetDescendants()) do if d:IsA("ParticleEmitter") then d.Enabled = false; d:Clear() end end end
	for _, u in ipairs(P15 and P15:GetChildren() or {}) do
		if u.Name == "RaidUplight15" then local s = u:FindFirstChildOfClass("SpotLight"); if s then s.Enabled = false end end
	end
	-- haze band: one box-volume emitter about 60 wide (z) by 40 tall, from the stair top (y ~12) to the spire tips (~y 75),
	-- set back behind the door plane (x 162-182) so it wraps the temple without veiling the facade foot
	-- t1 (box 16x44x64 at x 176, y 22-66) was hidden behind the facade: p3 still showed sky (65,199,241) round the skull tower where
	-- the reference reads haze (161,116,110). (200,70,60) at about 0.7 cover over that sky gives (160,109,114): the band sits
	-- above the facade cap, round the tower, up to the skull's eyes, behind the skull face (x 176-196).
	-- t2 (20x46x76 at y 80) read as a round glow behind the tower again: the band is made wider than tall (z 104, y 42-94)
	local hz = ghost(part("RaidHaze16", Vector3.new(24, 52, 104), CFrame.new(186, 68, 0), rgb(0, 0, 0)))
	local e = Instance.new("ParticleEmitter"); e.Name = "Band"; e.Shape = Enum.ParticleEmitterShape.Box
	e.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume; e.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
	e.Texture = "rbxasset://textures/particles/smoke_main.dds"
	-- t4 (200,70,60), emission 0.15, influence 0.4, T 0.4/0.5: p3 sampled (186,134,162)-(227,147,159), pinker and brighter than the
	-- reference (161,116,110)/(146,108,113): too thin (sky blue leaking through) and lit. Unlit, denser and duller: a colour C at
	-- cover a over the sky (60,195,240) gives the target when C = (target - (1-a) sky) / a, about (180,100,88) at a = 0.85.
	e.Color = ColorSequence.new(rgb(176, 92, 84)); e.LightEmission = 0; e.LightInfluence = 0
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.22), NumberSequenceKeypoint.new(0.7, 0.3), NumberSequenceKeypoint.new(1, 1) })
	e.Size = NumberSequence.new(16, 24); e.Rate = 10; e.Lifetime = NumberRange.new(8, 11)
	e.Speed = NumberRange.new(0.1, 0.4); e.SpreadAngle = Vector2.new(180, 180); e.Rotation = NumberRange.new(0, 360)
	e.RotSpeed = NumberRange.new(-4, 4); e.Parent = hz
	pcall(function() e:Emit(60) end)
	-- (c) red SpotLights from the stair foot aimed up the facade (4)
	for _, z in ipairs({ -30, -10, 10, 30 }) do
		local base = Vector3.new(138, groundY(138, z, 40) + 1, z)
		local aim = Vector3.new(170, 58, z * 0.7)
		local h = ghost(part("RaidUplight16", Vector3.new(0.6, 0.6, 0.6), CFrame.lookAt(base, aim) * CFrame.Angles(-math.pi / 2, 0, 0), rgb(0, 0, 0)))
		local s = Instance.new("SpotLight"); s.Face = Enum.NormalId.Top; s.Color = rgb(255, 60, 50); s.Range = 40; s.Angle = 50
		s.Brightness = 1.5; s.Shadows = false; s.Parent = h
	end
	-- (d) doorway glow: a PointLight inside the door and a red Neon strip following the pointed arch (legs z +-6.5 up to y 18,
	-- arcs to the apex at y 27, inset at x 157.6, measured by raycasts into K_Gothic)
	local dl = ghost(part("RaidDoorLight16", Vector3.new(0.5, 0.5, 0.5), CFrame.new(156, 12, 0), rgb(0, 0, 0)))
	local pl = Instance.new("PointLight"); pl.Color = rgb(255, 50, 40); pl.Range = 20; pl.Brightness = 2; pl.Shadows = false; pl.Parent = dl
	local pts = {}
	for i = 0, 4 do table.insert(pts, Vector3.new(157.6, 8.6 + i * 2.35, -6.6)) end
	-- pointed arch, span 13.2, apex 9.5 above the springing (y 18): each side is an arc of radius 10.14 centred 3.54 past the axis
	for i = 1, 8 do
		local th = math.rad(180 - (180 - 110.4) * i / 8)
		table.insert(pts, Vector3.new(157.6, 18 + 10.14 * math.sin(th), 3.54 + 10.14 * math.cos(th)))
	end
	local n = #pts
	for i = n - 1, 1, -1 do local p = pts[i]; table.insert(pts, Vector3.new(p.X, p.Y, -p.Z)) end
	for i = 1, #pts - 1 do
		local a, b = pts[i], pts[i + 1]
		local s = part("RaidDoorNeon16", Vector3.new(0.35, 0.35, (b - a).Magnitude + 0.2), CFrame.lookAt((a + b) / 2, b), rgb(255, 40, 35), NE)
		s.CanCollide = false; s.CastShadow = false
	end
	-- (e) keystone skull: the pink plinth-and-skull over the door goes; a 3-stud carved skull sits in the arch apex
	for _, x in ipairs(R:GetChildren()) do
		if x.Name == "K_Skull8" then local _, sz = x:GetBoundingBox(); if sz.Y < 20 then hide(x) end end
	end
	if kit:FindFirstChild("K_Skull7_bone") then
		local lo, hi = kitExt("K_Skull7"); local s = 3.2 / (hi.Y - lo.Y)
		local c = (lo + hi) / 2
		-- kit skull faces -Z (authored); turn it to face -X (the plaza)
		local cf = CFrame.new(157.2, 29.6, 0) * CFrame.Angles(0, -math.pi / 2, 0) * CFrame.new(-c * s)
		kitModel("K_Skull7", cf, s, P16, function(tok, p)
			p.Material = Enum.Material.Slate; p.CanCollide = false
			if tok == "bone" then p.Color = rgb(150, 80, 72) elseif tok == "dark" then p.Color = rgb(40, 10, 14)
			elseif tok == "eye" then p.Color = rgb(255, 50, 40); p.Material = NE end
		end).Name = "KeystoneSkull16"
		part("KeystoneBlock16", Vector3.new(1.4, 4.2, 3.4), CFrame.new(158.2, 29.4, 0), rgb(190, 96, 92), Enum.Material.Slate).CanCollide = false
	end
	-- (f) upright dark-red palm about 20 left of the door (-Z from p3), spread fronds: the drooping pass-13 palm there goes
	local TR = root.Pass13:FindFirstChild("Trees13")
	for _, x in ipairs(TR and TR:GetChildren() or {}) do
		if x.Name == "K_Soft13P" then local p = x:GetPivot().Position; if p.X > 140 and p.Z < 0 and p.Z > -40 then hide(x) end end
	end
	if kit:FindFirstChild("K_Palm6A_wood") then
		local lo = kitExt("K_Palm6A"); local s = 1.0
		local x, z = 146, -22
		local cf = CFrame.new(x, groundY(x, z, 60) - lo.Y * s, z) * CFrame.Angles(0, math.rad(35), 0)
		kitModel("K_Palm6A", cf, s, P16, function(tok, p)
			p.CanCollide = false; p.Material = SM
			if tok == "wood" then p.Color = rgb(70, 30, 30); p.CanCollide = true
			elseif tok == "leafRim" then p.Color = rgb(120, 30, 36) else p.Color = rgb(80, 20, 25) end
		end).Name = "RaidPalm16"
	end
	table.insert(report, "raid ok")
end
--ENDRAID


-- ================================================================ item 2: skyline (N islands 1.6x, 12 lower, green, trees, falls)
--SKY
do
	local K, DROP = 1.6, 12
	local Isl = root.Islands
	local N = {}
	for _, x in ipairs(Isl:GetChildren()) do
		if x.Name:sub(1, 6) == "K_Isl9" then
			if x:GetAttribute("P16C0") == nil then local cf = x:GetBoundingBox(); x:SetAttribute("P16C0", cf.Position) end
			local c0 = x:GetAttribute("P16C0")
			if c0.Z < -100 then
				local cf, sz = x:GetBoundingBox()
				local s0 = x:GetAttribute("P16S0") or (x:GetAttribute("P16S") and sz / x:GetAttribute("P16S")) or sz
				x:SetAttribute("P16S0", s0)
				table.insert(N, { m = x, c0 = c0, s0 = s0 })
			end
		end
	end
	local cands = {}
	local function add(F) if F then for _, x in ipairs(F:GetChildren()) do table.insert(cands, x) end end end
	add(Isl); add(root:FindFirstChild("Pass12") and root.Pass12:FindFirstChild("IslDress12"))
	local TR = root.Pass13:FindFirstChild("Trees13"); if TR then add(TR) end
	local P14 = root:FindFirstChild("Pass14")
	if P14 then for _, x in ipairs(P14:GetChildren()) do if x.Name:sub(1, 7) == "IslTowe" or x.Name:sub(1, 4) == "Aque" then table.insert(cands, x) end end end
	local function posOf(x)
		if x:GetAttribute("P16P0") then return x:GetAttribute("P16P0") end
		if x:IsA("BasePart") then return x.Position elseif x:IsA("Model") then return x:GetPivot().Position end
	end
	local scaled = 0
	for _, x in ipairs(cands) do
		local p = posOf(x)
		if p and p.Y > 40 and (x:IsA("BasePart") or x:IsA("Model")) then
			local best, bd
			for _, I in ipairs(N) do
				local d = Vector2.new(p.X - I.c0.X, p.Z - I.c0.Z).Magnitude
				if d < math.max(I.s0.X, I.s0.Z) * 0.5 + 25 and p.Y > I.c0.Y - 45 and (not bd or d < bd) then best, bd = I, d end
			end
			if best then
				local a0, a1 = best.c0, best.c0 - Vector3.new(0, DROP, 0)
				if x:IsA("BasePart") then
					if x:GetAttribute("P16CF0") == nil then x:SetAttribute("P16CF0", x.CFrame); x:SetAttribute("P16Sz0", x.Size); x:SetAttribute("P16P0", x.Position) end
					local cf0, sz0 = x:GetAttribute("P16CF0"), x:GetAttribute("P16Sz0")
					x.Size = sz0 * K; x.CFrame = CFrame.new(a1 + (cf0.Position - a0) * K) * (cf0 - cf0.Position)
				else
					if x:GetAttribute("P16CF0") == nil then x:SetAttribute("P16CF0", x:GetPivot()); x:SetAttribute("P16Sc0", x:GetScale()); x:SetAttribute("P16P0", x:GetPivot().Position) end
					local cf0 = x:GetAttribute("P16CF0")
					x:ScaleTo(x:GetAttribute("P16Sc0") * K)
					x:PivotTo(CFrame.new(a1 + (cf0.Position - a0) * K) * (cf0 - cf0.Position))
				end
				x:SetAttribute("P16Isl", true); scaled += 1
			end
		end
	end
	table.insert(report, "N island pieces scaled " .. scaled)
	-- green caps and lighter rock; falls glow
	for _, I in ipairs(N) do
		for _, d in ipairs(I.m:GetDescendants()) do
			if d:IsA("BasePart") then
				local tok = d.Name:match("_(%a+)$")
				if tok == "grass" then recol(d, rgb(105, 185, 70)) elseif tok == "vine" then recol(d, rgb(60, 140, 55)) end
			end
		end
	end
	for _, x in ipairs(Isl:GetChildren()) do
		if x:GetAttribute("P16Isl") and x:IsA("BasePart") then
			if x.Name == "Fall10" then x.Material = NE; x.Color = rgb(170, 220, 245); x.Transparency = 0.35 end
		end
	end
	-- the pass-15 spill clumps of the N islands go (they were laid on the old rim); pass 16 lays a new skirt below
	local SP15 = root:FindFirstChild("Pass15") and root.Pass15:FindFirstChild("IslSpill15")
	for _, m in ipairs(SP15 and SP15:GetChildren() or {}) do
		local p = m:GetPivot().Position
		for _, I in ipairs(N) do if Vector2.new(p.X - I.c0.X, p.Z - I.c0.Z).Magnitude < math.max(I.s0.X, I.s0.Z) * 0.6 + 10 and p.Y > I.c0.Y - 40 then hide(m) end end
	end
	-- grass skirt (16 flattened green clumps hung 2-8 below each rim) and 3 trees on top of each N island
	local SK = Instance.new("Folder"); SK.Name = "IslSkirt16"; SK.Parent = P16
	local rng = Random.new(1616); local GREEN, GREEN2 = { rgb(70, 150, 55), rgb(125, 200, 75) }, { rgb(55, 130, 50), rgb(105, 185, 65) }
	local nsk, ntr = 0, 0
	for _, I in ipairs(N) do
		local cf, sz = I.m:GetBoundingBox()
		local top = cf.Y + sz.Y * 0.32
		for i = 1, 16 do
			local a = i / 16 * math.pi * 2 + rng:NextNumber(-0.15, 0.15)
			local p = Vector3.new(cf.X + math.cos(a) * sz.X * 0.44, top - rng:NextNumber(2, 8), cf.Z + math.sin(a) * sz.Z * 0.44)
			local m = soft("K_Soft15K", p, rng:NextNumber(1.3, 1.9), "grey", GREEN, SK, rng:NextNumber(0, 6.28)); nsk += 1
		end
		for i = 1, 3 do
			local a = rng:NextNumber(0, 6.28); local r = rng:NextNumber(0.1, 0.3)
			local x, z = cf.X + math.cos(a) * sz.X * r, cf.Z + math.sin(a) * sz.Z * r
			local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Include; rp.FilterDescendantsInstances = { I.m }
			local hit = workspace:Raycast(Vector3.new(x, cf.Y + sz.Y, z), Vector3.new(0, -sz.Y * 2, 0), rp)
			local y = hit and hit.Position.Y or top
			soft(i == 2 and "K_Soft15U" or "K_Soft15R", Vector3.new(x, y - 0.5, z), rng:NextNumber(1.6, 2.1), "grey", GREEN2, SK, rng:NextNumber(0, 6.28)); ntr += 1
		end
	end
	-- one more glowing fall per N island on the rim facing the plaza (3.6 wide, 34 long, T 0.3) with a mist emitter at the foot
	for _, I in ipairs(N) do
		local cf, sz = I.m:GetBoundingBox()
		local h = Vector3.new(-cf.X, 0, -cf.Z).Unit; local side = Vector3.new(-h.Z, 0, h.X)
		local rimTop = cf.Y + sz.Y * 0.25
		local p0 = Vector3.new(cf.X, 0, cf.Z) + h * (math.min(sz.X, sz.Z) * 0.46) + side * 14 + Vector3.new(0, rimTop, 0)
		local L = 34
		local f = part("Fall16", Vector3.new(3.6, L, 0.4), CFrame.lookAt(p0 - Vector3.new(0, L / 2, 0), p0 - Vector3.new(0, L / 2, 0) + h), rgb(170, 220, 245), NE, SK)
		f.Transparency = 0.3; f.CanCollide = false; f.CastShadow = false
		local lip = part("FallLip16", Vector3.new(4.4, 1, 3), CFrame.lookAt(p0, p0 + h), rgb(225, 245, 255), SM, SK); lip.CanCollide = false
		local mist = ghost(part("FallMist16", Vector3.new(4, 1, 4), CFrame.new(p0 - Vector3.new(0, L, 0)), rgb(0, 0, 0), SM, SK))
		local e = Instance.new("ParticleEmitter"); e.Texture = "rbxasset://textures/particles/smoke_main.dds"
		e.Color = ColorSequence.new(rgb(235, 248, 255)); e.LightEmission = 0.2
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.5), NumberSequenceKeypoint.new(1, 1) })
		e.Size = NumberSequence.new(5, 10); e.Rate = 3; e.Lifetime = NumberRange.new(2.5, 4); e.Speed = NumberRange.new(0.5, 2)
		e.SpreadAngle = Vector2.new(60, 60); e.Parent = mist
	end
	table.insert(report, "skirt " .. nsk .. ", island trees " .. ntr)
	_G.P16_N = N
end
--ENDSKY

-- ================================================================ item 4: W quarter (lagoon, arena, cover) and item 5 (stair grass)
--WEST
do
	local WATER, SAND = rgb(60, 170, 220), rgb(225, 205, 150)
	local function ellipse(name, c, sx, sz, h, col, mat, parent)
		-- a Part with a Cylinder SpecialMesh stretches to an ellipse (a Cylinder-shaped Part would stay round)
		local p = part(name, Vector3.new(h, sx, sz), CFrame.new(c) * CFrame.Angles(0, 0, math.pi / 2), col, mat, parent)
		local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Cylinder; m.Parent = p
		p.CanCollide = false
		return p
	end
	-- (a) lagoon about 50 x 40 NW of the W arm, between the two W palm groups; sand lip, darker deep centre
	local LC = Vector3.new(-92, 0, -34); local LX, LZ = 50, 40
	local gy = groundY(LC.X, LC.Z, 40)
	local W = Instance.new("Folder"); W.Name = "West16"; W.Parent = P16
	ellipse("LagoonSand16", Vector3.new(LC.X, gy + 0.08, LC.Z), LX + 6, LZ + 6, 0.16, SAND, Enum.Material.Sand, W)
	ellipse("Lagoon16", Vector3.new(LC.X, gy + 0.2, LC.Z), LX, LZ, 0.16, WATER, SM, W).Transparency = 0.05
	ellipse("LagoonDeep16", Vector3.new(LC.X, gy + 0.24, LC.Z), LX * 0.55, LZ * 0.5, 0.12, rgb(35, 120, 200), SM, W).Transparency = 0.2
	local function inLagoon(x, z, pad) return ((x - LC.X) / (LX / 2 + pad)) ^ 2 + ((z - LC.Z) / (LZ / 2 + pad)) ^ 2 < 1 end
	-- palms standing in the water move out to the rim (original pivot kept in P16CF0)
	local TR = root.Pass13:FindFirstChild("Trees13")
	local pal = 0
	for _, m in ipairs(TR and TR:GetChildren() or {}) do
		if m.Name == "K_Soft13P" and m:IsA("Model") then
			if m:GetAttribute("P16CF0") == nil then m:SetAttribute("P16CF0", m:GetPivot()) end
			local cf0 = m:GetAttribute("P16CF0"); local p = cf0.Position
			if inLagoon(p.X, p.Z, 4) then
				local d = Vector3.new((p.X - LC.X) / (LX / 2), 0, (p.Z - LC.Z) / (LZ / 2)); if d.Magnitude < 0.05 then d = Vector3.new(0, 0, 1) end
				d = d.Unit; local q = Vector3.new(LC.X + d.X * (LX / 2 + 2), p.Y, LC.Z + d.Z * (LZ / 2 + 2))
				m:PivotTo(CFrame.new(q) * (cf0 - cf0.Position)); pal += 1
			else m:PivotTo(cf0) end
		end
	end
	-- ring: 16 blue bushes and 3 more blue palms (clones of a pass-13 blue palm)
	local rng = Random.new(1617)
	for i = 1, 16 do
		local a = i / 16 * math.pi * 2 + rng:NextNumber(-0.12, 0.12)
		local x, z = LC.X + math.cos(a) * (LX / 2 + 3.5), LC.Z + math.sin(a) * (LZ / 2 + 3.5)
		soft("K_Soft15B", Vector3.new(x, groundY(x, z, 40) - 0.3, z), rng:NextNumber(1.4, 2.0), "blue", nil, W, rng:NextNumber(0, 6.28))
	end
	local bluePalm
	for _, m in ipairs(TR and TR:GetChildren() or {}) do
		local l = m:FindFirstChild("K_Soft13P_leaf"); if l and l.Color.B > 0.8 then bluePalm = m; break end
	end
	if bluePalm then
		local cf0 = bluePalm:GetAttribute("P16CF0") or bluePalm:GetPivot()
		local g0 = groundY(cf0.X, cf0.Z, 40)
		for _, a in ipairs({ 0.4, 2.3, 4.2 }) do
			local x, z = LC.X + math.cos(a) * (LX / 2 + 4), LC.Z + math.sin(a) * (LZ / 2 + 4)
			local c = bluePalm:Clone(); c:SetAttribute("P16CF0", nil)
			c:PivotTo(CFrame.new(x, groundY(x, z, 40) + (cf0.Y - g0), z) * CFrame.Angles(0, a * 2, 0) * (cf0 - cf0.Position))
			c.Name = "LagoonPalm16"; c.Parent = W
		end
	end
	table.insert(report, "lagoon, palms moved " .. pal)
	-- (b) stepped white arena round the Story tree: three 0.9 steps (46 / 40 / 34 across) with gold rims and 24 gold studs
	local AC = Vector3.new(-122, 0, 0)
	local P14 = root:FindFirstChild("Pass14")
	for _, x in ipairs(P14 and P14:GetChildren() or {}) do
		if x.Name == "StoryArena14" or x.Name == "StoryArenaStud14" then hide(x) end
	end
	local ay = groundY(AC.X + 26, AC.Z, 40)
	for i, d in ipairs({ 46, 40, 34 }) do
		local h = 0.9 * i
		local t = part("Arena16", Vector3.new(h, d, d), CFrame.new(AC.X, ay + h / 2, AC.Z) * CFrame.Angles(0, 0, math.pi / 2), rgb(232, 232, 226), Enum.Material.Marble, W)
		t.Shape = Enum.PartType.Cylinder
		-- rim: a gold band 0.22 tall just under the step's top edge (t1 put it ON the top: the whole arena read as a gold disc)
		local r = part("ArenaRim16", Vector3.new(0.22, d + 0.4, d + 0.4), CFrame.new(AC.X, ay + h - 0.25, AC.Z) * CFrame.Angles(0, 0, math.pi / 2), rgb(215, 170, 60), SM, W)
		r.Shape = Enum.PartType.Cylinder; r.CanCollide = false
	end
	for k = 0, 23 do
		local a = k / 24 * math.pi * 2
		local s = part("ArenaStud16", Vector3.new(0.9, 0.9, 0.9), CFrame.new(AC + Vector3.new(math.cos(a) * 15.6, ay + 2.85, math.sin(a) * 15.6)), rgb(215, 170, 60), SM, W)
		s.Shape = Enum.PartType.Ball
	end
	-- (c) cover the open W lawn: blue bushes on about 60% of the open 8-stud cells (not on the arm, the arena, the lagoon),
		local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P16 }
	local nb = 0
	for z = -100, 64, 8 do -- t2 (x -120..-46, z -60..60) left the NW lawn and the far W open
		for x = -152, -42, 8 do
			local jx, jz = x + rng:NextNumber(-2.5, 2.5), z + rng:NextNumber(-2.5, 2.5)
			local hit = workspace:Raycast(Vector3.new(jx, 60, jz), Vector3.new(0, -80, 0), rp)
			local nm = hit and hit.Instance.Name or ""
			local open = hit and (nm == "GroundW" or nm == "GroundN" or nm == "GroundS" or nm:sub(1, 7) == "K_Patch") -- t1 without the lawn patches: 10 bushes
			local far = math.abs(jz) > 15 and not inLagoon(jx, jz, 5) and (Vector2.new(jx - AC.X, jz - AC.Z).Magnitude > 27)
			if open and far and rng:NextNumber() < 0.85 then -- t3 laid flat blue discs on the rest: they read as polka dots from p8
				soft("K_Soft15B", Vector3.new(jx, hit.Position.Y - 0.4, jz), rng:NextNumber(1.3, 1.9), "blue", nil, W, rng:NextNumber(0, 6.28)); nb += 1
			end
		end
	end
	table.insert(report, "W bushes " .. nb)
end
-- item 5: grass on the S and W stairs (treads and stair-top lips), K_Grass tufts tinted (110,200,60)
do
	local G = Instance.new("Folder"); G.Name = "StairGrass16"; G.Parent = P16
	local lo, hi = kitExt("K_Grass")
	local function tuft(p, h, yaw)
		local s = h / (hi.Y - lo.Y)
		return kitModel("K_Grass", CFrame.new(p - Vector3.new(0, lo.Y * s, 0)) * CFrame.Angles(0, yaw, 0), s, G, function(tok, c)
			c.Color = rgb(110, 200, 60); c.Material = SM; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
		end)
	end
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P16 }
	local rng = Random.new(1618); local nt, nl = 0, 0
	-- S = +Z, W = -X (outward along the arm); lat = across the flight
	for _, dir in ipairs({ { Vector3.new(0, 0, 1), Vector3.new(1, 0, 0) }, { Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1) } }) do
		local out, lat = dir[1], dir[2]
		local lips = {}
		for l = -17, 17, 1.5 do
			if math.abs(l) > 5 then
				local onStairs = false
				for d = 20, 60, 0.5 do
					local q = out * d + lat * l
					local h = workspace:Raycast(q + Vector3.new(0, 60, 0), Vector3.new(0, -80, 0), rp)
					local isS = h and h.Instance.Name:sub(1, 8) == "K_Stairs"
					if isS then onStairs = true
					elseif onStairs and h then
						table.insert(lips, { l, d })
						for k = 0, 1 do -- a strip of two rows across the lip, 1.3-1.7 tall
							local qq = out * (d + 0.4 + k * 0.9) + lat * (l + rng:NextNumber(-0.5, 0.5))
							local hh = workspace:Raycast(qq + Vector3.new(0, 60, 0), Vector3.new(0, -80, 0), rp)
							if hh then tuft(hh.Position - Vector3.new(0, 0.15, 0), rng:NextNumber(1.3, 1.7), rng:NextNumber(0, 6.28)); nl += 1 end
						end
						break
					end
				end
			end
		end
		-- 16 taller tufts (2-3) on the treads and just past the lip
		local n = 0
		for tries = 1, 300 do
			if n >= 16 then break end
			local l = rng:NextNumber(-16, 16)
			if math.abs(l) > 5.5 then
				local d = rng:NextNumber(18, 56)
				local q = out * d + lat * l
				local h = workspace:Raycast(q + Vector3.new(0, 60, 0), Vector3.new(0, -80, 0), rp)
				local nearLip = false
				for _, L in ipairs(lips) do if math.abs(L[1] - l) < 1 and d > L[2] and d < L[2] + 4 then nearLip = true end end
				if h and (h.Instance.Name:sub(1, 8) == "K_Stairs" or nearLip) then
					tuft(h.Position - Vector3.new(0, 0.1, 0), rng:NextNumber(2.0, 3.0), rng:NextNumber(0, 6.28)); n += 1; nt += 1
				end
			end
		end
	end
	table.insert(report, "stair grass tufts " .. nt .. ", lip tufts " .. nl)
end
--ENDWEST

-- ================================================================ kit-dependent (r16): bollards, medallion blades, Story trunk; Story canopy widened
--KIT16
do
	-- (a) Story canopy to about 75 across: 10 more clumps (clones of the pass-14 canopy clumps) on a ring of radius 28-33
	local SC = root:FindFirstChild("Pass14") and root.Pass14:FindFirstChild("StoryCanopy14")
	local src = {}
	for _, m in ipairs(SC and SC:GetChildren() or {}) do if m:IsA("Model") and m.Name == "K_Soft15K" then table.insert(src, m) end end
	if #src > 0 then
		local CW = Instance.new("Folder"); CW.Name = "StoryCanopy16"; CW.Parent = P16
		local rng = Random.new(1619)
		for i = 1, 10 do
			local a = i / 10 * math.pi * 2 + rng:NextNumber(-0.15, 0.15); local r = rng:NextNumber(28, 33)
			local c = src[(i % #src) + 1]:Clone()
			local p = c:GetPivot()
			c:PivotTo(CFrame.new(-122 + math.cos(a) * r, rng:NextNumber(62, 70), math.sin(a) * r) * (p - p.Position) * CFrame.Angles(0, a, 0))
			c.Parent = CW
		end
		table.insert(report, "story canopy +10")
	end
	-- (b) Story trunk: the straight pass-11 cylinder goes; K_Trunk16 (flared trunk, 5 gnarled limbs from 2/3 height into the canopy)
	if kit:FindFirstChild("K_Trunk16_wood") then
		local ST = root.Pass11:FindFirstChild("StoryTree11")
		for _, x in ipairs(ST and ST:GetChildren() or {}) do if x.Name == "Limb" and x:IsA("BasePart") and x.Size.Y >= 14 then hide(x) end end
		local lo, hi = kitExt("K_Trunk16")
		local gy = groundY(-122, 0, 40)
		local s = (66 - gy) / (hi.Y - 0) -- limb tips (authored y 52) to the canopy underside at about y 60-66
		kitModel("K_Trunk16", CFrame.new(-122, gy - 0.3, 0) * CFrame.Angles(0, math.rad(18), 0), s, P16, function(tok, c)
			c.Color = rgb(150, 110, 75); c.Material = Enum.Material.Wood
		end).Name = "StoryTrunk16"
		table.insert(report, string.format("story trunk scale %.2f", s))
	end
	-- (c) bollards: the white box + stepped gold cap + ball go; K_Bollard16 (grey squat body, faceted pointed gold cap)
	if kit:FindFirstChild("K_Bollard16_stone") then
		local P14 = root:FindFirstChild("Pass14")
		for _, x in ipairs(P14 and P14:GetChildren() or {}) do
			if x.Name == "BollardCap14" or x.Name == "BollardKnob14" or x.Name == "BollardTip14" then hide(x) end
		end
		local nb = 0
		for _, b in ipairs(root:GetChildren()) do
			if b.Name == "K_Bollard" and b:IsA("Model") then
				local cf, sz = b:GetBoundingBox(); hide(b)
				local base = cf.Y - sz.Y / 2
				local yaw = math.atan2(cf.X, cf.Z) -- a face toward the plaza centre
				kitModel("K_Bollard16", CFrame.new(cf.X, base, cf.Z) * CFrame.Angles(0, yaw + math.pi / 4, 0), 1.0, P16, function(tok, c)
					if tok == "stone" then c.Color = rgb(150, 155, 160); c.Material = Enum.Material.Slate
					else c.Color = rgb(215, 170, 55); c.Material = Enum.Material.Metal end
				end).Name = "Bollard16"
				nb += 1
			end
		end
		table.insert(report, "bollards " .. nb)
	end
	-- (d) medallion: the 8 long swirl blades go; K_Blade16 (8 short thick hooked blades on a dark ring) on the pale disc, and
	-- 8 gold studs on the disc near its rim
	if kit:FindFirstChild("K_Blade16_dark") then
		local M = root:FindFirstChild("K_Medal")
		local dk = M and M:FindFirstChild("K_Medal_darkStone")
		if dk then hide(dk) end
		local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Include; rp.FilterDescendantsInstances = { M:FindFirstChild("K_Medal_pale") }
		local h = workspace:Raycast(Vector3.new(5.5, 10, 0.3), Vector3.new(0, -20, 0), rp)
		local top = h and h.Position.Y or 0.4
		kitModel("K_Blade16", CFrame.new(0, top + 0.005, 0) * CFrame.Angles(0, math.rad(11), 0), 1.0, P16, function(tok, c)
			c.Color = rgb(32, 40, 48); c.Material = Enum.Material.Slate; c.CanCollide = false -- (45,55,65) Slate sampled (59,82,97) in p3: too blue-light
		end).Name = "MedalBlades16"
		for k = 0, 7 do
			local a = (k + 0.5) / 8 * math.pi * 2
			local st = part("MedalStud16", Vector3.new(0.3, 1.1, 1.1), CFrame.new(math.cos(a) * 6.9, top + 0.12, math.sin(a) * 6.9) * CFrame.Angles(0, 0, math.pi / 2), rgb(215, 170, 55), Enum.Material.Metal)
			st.Shape = Enum.PartType.Cylinder; st.CanCollide = false
		end
		table.insert(report, string.format("medallion blades at y %.2f", top))
	end
end
--ENDKIT16

_G.P16_REPORT = table.concat(report, "; ")
end
return "pass16 ok: " .. tostring(_G.P16_REPORT)
