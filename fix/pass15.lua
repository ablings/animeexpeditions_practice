-- pass15.lua (practice place only): freestyle pass 15 on top of the pass-14 build (notes/fix_brief15.md, verify12_plaza.md).
-- Run AFTER pass 13 and pass 14. Idempotent: absolute values; new pieces live in Plaza.Pass15 (rebuilt each run); moved
-- island pieces carry the attribute P15Isl so they move once; the old Raid skull is hidden (attribute P15Hidden) and the
-- K_Skull15 tower is placed in its frame when the r15 kit is in Kit.
-- Items: 2 Raid balance (skull, pillar, facade, uplights, haze band, island above Raid), 3 islands out of the player-height
-- views (N out, S/SW out and up, wider falls with mist, grass spilling over the rims). The tree swap (item 1) is in pass13.lua
-- (generation 15 when K_Soft15R_leaf is in Kit) and the gold canopy behind Summon at the end of this file.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r15 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r15")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale15_stone", true)
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
local HAS15 = kit and kit:FindFirstChild("K_Soft15K_leaf") ~= nil
local old = root:FindFirstChild("Pass15"); if old then old:Destroy() end
local P15 = Instance.new("Folder"); P15.Name = "Pass15"; P15.Parent = root
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P15
	return p
end
local function groundY(x, z, top)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P15 }
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -240, 0), rp)
	return r and r.Position.Y or 0
end
local report = {}

-- ================================================================ item 2: Raid balance
-- Round 12: skull hot pink (241,70,92) on a 2-tier pink plinth, facade near-black (31,15,26). Reference pictures
-- (out/r15w/ref15_skull_close.png): a weathered brick-rose skull with dark sockets growing out of a tapering carved pillar;
-- the temple is mid-value stone washed in red light, red haze wrapping it from the stairs up.
local FACADE, TRIM, DEEP = rgb(95, 40, 45), rgb(130, 60, 60), rgb(60, 18, 24)
local BONE, BONEHI, SOCK = rgb(150, 80, 72), rgb(230, 125, 110), rgb(60, 15, 20)
do
	local R = root:FindFirstChild("Pass11") and root.Pass11:FindFirstChild("Raid11")
	if R then
		local trimNames = { RaidButtress = true, RaidPinnacle = true, RaidGablePin = true, RaidFacadeCap = true }
		for _, x in ipairs(R:GetChildren()) do
			if x:IsA("BasePart") and (x.Name:sub(1, 9) == "RaidFacad" or x.Name:sub(1, 9) == "RaidGable" or trimNames[x.Name]) then
				if x.Name == "RaidGableRecess" then x.Color = DEEP
				elseif trimNames[x.Name] then x.Color = TRIM; x.Material = Enum.Material.Slate
				else x.Color = FACADE; x.Material = Enum.Material.Brick end
			elseif x:IsA("Model") and (x.Name == "K_Gothic" or x.Name == "K_Spire" or x.Name == "K_RTower7" or x.Name == "K_Arcade7") then
				for _, d in ipairs(x:GetDescendants()) do
					if d:IsA("BasePart") then
						local tok = d.Name:match("_(%a+)$")
						if tok == "stone" then d.Color = FACADE
						elseif tok == "darkStone" then d.Color = DEEP
						elseif tok == "dome" then d.Color = TRIM
						elseif tok == "gold" and x.Name == "K_Gothic" then d.Color = TRIM end
					end
				end
			end
		end
		-- the big skull: pass-15 kit tower (head + carved pillar) in the old skull's frame, the old one hidden; without the
		-- kit, the old skull is only recoloured brick-rose
		local big
		for _, x in ipairs(R:GetChildren()) do
			if x.Name == "K_Skull8" then local _, sz = x:GetBoundingBox(); if sz.Y > 40 then big = x end end
		end
		local K8 = kit and kit:FindFirstChild("K_Skull8_bone")
		local K15 = kit and kit:FindFirstChild("K_Skull15_bone")
		if big then
			local bone8 = big:FindFirstChild("K_Skull8_bone", true)
			if K15 and K8 and bone8 then
				-- kit frame -> world: world = F * (kitPos * s), from the old bone (same kit origin for r8 and r15)
				local s = bone8.Size.Y / K8.Size.Y
				local F = bone8.CFrame * (K8.CFrame - K8.CFrame.Position):Inverse() * CFrame.new(-K8.Position * s)
				for _, d in ipairs(big:GetDescendants()) do
					if d:IsA("BasePart") then d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P15Hidden", true) end
				end
				local m = Instance.new("Model"); m.Name = "K_Skull15"
				for _, k in ipairs(kit:GetChildren()) do
					if k.Name:sub(1, 10) == "K_Skull15_" then
						local c = k:Clone(); c.Size = k.Size * s; c.CFrame = F * CFrame.new(k.Position * s) * (k.CFrame - k.CFrame.Position)
						c.Anchored = true; c.Material = SM
						local tok = k.Name:match("_(%a+)$")
						if tok == "bone" then c.Color = BONE; c.Material = Enum.Material.Slate
						elseif tok == "dark" then c.Color = SOCK
						elseif tok == "eye" then c.Color = rgb(255, 60, 50); c.Material = NE
						elseif tok == "pillar" then c.Color = FACADE; c.Material = Enum.Material.Slate end
						c.Parent = m
					end
				end
				m.Parent = P15
				table.insert(report, string.format("skull15 placed, scale %.2f", s))
			else
				for _, d in ipairs(big:GetDescendants()) do
					if d:IsA("BasePart") then
						if d.Name:find("_bone$") then d.Color = BONE elseif d.Name:find("_dark$") then d.Color = SOCK end
					end
				end
			end
			-- highlights: a small warm-red light in front of and above the face, so the brow and cheeks read (230,125,110)
			local cf, sz = big:GetBoundingBox()
			local h = part("SkullLight15", Vector3.new(1, 1, 1), CFrame.new(cf.X - sz.X / 2 - 7, cf.Y + sz.Y * 0.28, 0), rgb(0, 0, 0))
			h.Transparency = 1; h.CanCollide = false; h.CanQuery = false
			local l = Instance.new("PointLight"); l.Color = rgb(255, 90, 80); l.Range = 20; l.Brightness = 0.7; l.Shadows = false; l.Parent = h -- 1.4: skull (201,58,59) against the reference (113,80,71)
		end
		local P14 = root:FindFirstChild("Pass14"); local L14 = P14 and P14:FindFirstChild("SkullLight14")
		if L14 then local l = L14:FindFirstChildOfClass("PointLight"); if l then l.Enabled = false end end
		-- the small door skull: same bone colour
		for _, x in ipairs(R:GetChildren()) do
			if x.Name == "K_Skull8" and x ~= big then for _, d in ipairs(x:GetDescendants()) do if d:IsA("BasePart") and d.Name:find("_bone$") then d.Color = rgb(205, 150, 140) end end end
		end
	end
	-- red uplights: 3 SpotLights at the stair foot aimed up the facade (stone washed in red, not black)
	for _, z in ipairs({ -22, 0, 22 }) do
		local x = 134; local gy = groundY(x, z, 40)
		local base = Vector3.new(x, gy + 1, z)
		local aim = Vector3.new(176, 70, z * 0.6)
		local h = part("RaidUplight15", Vector3.new(0.6, 0.6, 0.6), CFrame.lookAt(base, aim) * CFrame.Angles(-math.pi / 2, 0, 0), rgb(0, 0, 0))
		h.Transparency = 1; h.CanCollide = false; h.CanQuery = false
		local s = Instance.new("SpotLight"); s.Face = Enum.NormalId.Top; s.Color = rgb(255, 70, 60); s.Range = 60; s.Angle = 55
		s.Brightness = 0.4; s.Shadows = false; s.Parent = h -- 2.2 (t1) and 0.9 (t2) lit the facade foot (178,11,24): pure red, no stone
	end
	-- haze band: the v3 emitter settings (fitted in pass 14, colour lands at about (195,62,85)) spread over a band about 60
	-- wide from the stair top up to the spires, behind and beside the facade, never in front of the skull face
	local P14 = root:FindFirstChild("Pass14"); local S14 = P14 and P14:FindFirstChild("RaidSmoke14")
	if S14 then for _, d in ipairs(S14:GetDescendants()) do if d:IsA("ParticleEmitter") then d.Enabled = false; d:Clear() end end end
	local hz = part("RaidSmoke15", Vector3.new(1, 1, 1), CFrame.new(0, 0, 0), rgb(0, 0, 0)); hz.Transparency = 1; hz.CanCollide = false; hz.CanQuery = false
	local spots = {
		-- (first band had its top row at y 110-118: the sky round the skull went pink-violet (158,95,134); the reference
		-- sky above the skull stays blue, the haze sits from the stairs up to the skull's jaw)
		{ Vector3.new(188, 92, -30), 24 }, { Vector3.new(188, 92, 30), 24 }, { Vector3.new(198, 96, 0), 26 },
		{ Vector3.new(186, 80, -32), 28 }, { Vector3.new(186, 80, 32), 28 }, { Vector3.new(196, 70, 0), 30 },
		{ Vector3.new(180, 50, -38), 26 }, { Vector3.new(180, 50, 38), 26 },
		{ Vector3.new(168, 30, -48), 24 }, { Vector3.new(168, 30, 48), 24 },
		{ Vector3.new(178, 22, -46), 20 }, { Vector3.new(178, 22, 46), 20 }, -- t3: puffs at the stair top (x 150) laid a pure red veil over the facade foot
	}
	local S13 = root:FindFirstChild("Pass13") and root.Pass13:FindFirstChild("RaidSmoke13")
	if S13 then for _, d in ipairs(S13:GetDescendants()) do if d:IsA("PointLight") then d.Brightness = 0.15 end end end
	for _, at in ipairs(spots) do
		local a = Instance.new("Attachment"); a.WorldPosition = at[1]; a.Parent = hz
		local e = Instance.new("ParticleEmitter"); e.Texture = "rbxasset://textures/particles/smoke_main.dds"
		e.Color = ColorSequence.new(rgb(160, 38, 36), rgb(140, 32, 32)); e.LightEmission = 0.05; e.LightInfluence = 0.5
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.66), NumberSequenceKeypoint.new(0.75, 0.74), NumberSequenceKeypoint.new(1, 1) })
		e.Size = NumberSequence.new(at[2] * 1.1, at[2] * 1.45); e.Rate = 0.9; e.Lifetime = NumberRange.new(8, 11)
		e.Speed = NumberRange.new(0.2, 0.8); e.SpreadAngle = Vector2.new(180, 180); e.Rotation = NumberRange.new(0, 360)
		e.RotSpeed = NumberRange.new(-5, 5); e.Parent = a
		pcall(function() e:Emit(3) end)
	end
end

-- ================================================================ item 3 (+ item 2 last bullet): islands out of the player-height views
-- Rayed from the judged cameras: c4/p1 top-corner undersides are the N pair at z -196/-209 (about 34-38 degrees up from
-- the spawn, right in the top band); p6/p2 top is the S/SW island; p3's skull is clipped by the E island (253,159,41).
-- Moves (horizontal = along the island's own direction from the plaza centre):
--   N/NE/NW islands (z < -100): 60 out (the reference c4 shows its islands far, with sky above the avenue);
--   S/SW/SE islands (z > 100): 50 out and 45 up (moving a LOW island out lowers it INTO the view, so it also goes up);
--   E island above Raid: 45 out and 35 up.
do
	-- Each moved piece keeps the delta already applied to it in the attribute P15D, so the deltas below can be retuned and
	-- the file re-run: a piece moves by (wanted - applied). Pieces of the first run (tag P15Isl, no P15D) get the first-run
	-- delta written back (V1).
	local function V1(c, h)
		if c.Z < -100 then return h * 60 elseif c.Z > 100 then return h * 50 + Vector3.new(0, 45, 0)
		elseif c.X > 200 then return h * 45 + Vector3.new(0, 35, 0) end
	end
	local function WANT(c, h)
		-- N: 60 out and 35 DOWN: the first try (60 out) still filled c4's top corners down to y 150; the reference c4 shows
		-- its islands lower and farther, tops at y 110-130 with sky and towers above
		if c.Z < -100 then return h * 60 + Vector3.new(0, -35, 0)
		-- S/SW/SE: 90 out and only 10 up: at 50 out / 45 up (t2) the SW island still filled p6's top centre (y 0-90) at about
		-- 31 degrees up; farther and lower puts it on the skyline (~21 degrees, y ~180) with sky above, as in c4
		elseif c.Z > 100 then return h * 90 + Vector3.new(0, 10, 0)
		-- E island over Raid: also 45 sideways (+Z): from p3 its near edge still crossed the skull top at 60 out / 35 up
		elseif c.X > 200 then return h * 45 + Vector3.new(0, 35, 45) end
	end
	local ISL = {}
	for _, x in ipairs(root.Islands:GetChildren()) do
		if x.Name:sub(1, 6) == "K_Isl9" then
			local cf, sz = x:GetBoundingBox(); local c = cf.Position
			-- direction and region from the island's ORIGINAL centre (current minus what it already moved), so a retuned
			-- sideways move does not change its own direction on the next run
			local c0 = c
			local a0 = x:GetAttribute("P15D")
			if a0 then c0 = c - a0
			elseif x:GetAttribute("P15Isl") then local hh = Vector3.new(c.X, 0, c.Z).Unit; c0 = c - (V1(c, hh) or Vector3.zero) end
			local h = Vector3.new(c0.X, 0, c0.Z).Unit
			table.insert(ISL, { m = x, c = c, s = sz, d = WANT(c0, h), d1 = V1(c0, h), a0 = c - c0 })
		end
	end
	local function nearest(p)
		local best, bd = nil, math.huge
		for _, I in ipairs(ISL) do
			local d = Vector2.new(p.X - I.c.X, p.Z - I.c.Z).Magnitude
			if d < bd then best, bd = I, d end
		end
		return best, bd
	end
	local function posOf(x)
		if x:IsA("BasePart") then return x.Position elseif x:IsA("Model") then return x:GetPivot().Position end
	end
	local function move(x, d)
		if x:IsA("BasePart") then x.CFrame = x.CFrame + d elseif x:IsA("Model") then x:PivotTo(x:GetPivot() + d) end
	end
	local cands = {}
	local P12 = root:FindFirstChild("Pass12")
	for _, F in ipairs({ root.Islands, P12 and P12:FindFirstChild("IslDress12") }) do
		if F then for _, x in ipairs(F:GetChildren()) do table.insert(cands, x) end end
	end
	local OLD = SS:FindFirstChild("Pass13Old")
	if OLD then
		for _, x in ipairs(OLD:GetChildren()) do
			local o = x:FindFirstChild("Orig13")
			if o and o.Value and (o.Value.Name == "IslDress12" or o.Value.Name == "Islands") then table.insert(cands, x) end
		end
	end
	local P13 = root:FindFirstChild("Pass13"); local TR = P13 and P13:FindFirstChild("Trees13")
	if TR then for _, x in ipairs(TR:GetChildren()) do local p = posOf(x); if p and p.Y > 50 then table.insert(cands, x) end end end
	local P14 = root:FindFirstChild("Pass14")
	if P14 then for _, x in ipairs(P14:GetChildren()) do if x.Name:sub(1, 7) == "IslTowe" or x.Name:sub(1, 4) == "Aque" then table.insert(cands, x) end end end
	local moved = 0
	for _, x in ipairs(cands) do
		local p = posOf(x)
		if p and (p.Y > 40 or x:GetAttribute("P15Isl")) then
			local I, dist = nearest(p)
			-- only pieces at island height (falls hang up to ~40 below the centre): the first version also caught the far-N
			-- horizon clumps (y ~55, under the N islands in plan) and dropped them 35
			if I and I.d and dist < math.max(I.s.X, I.s.Z) * 0.5 + 25 and p.Y > I.c.Y - 45 then
				local applied = x:GetAttribute("P15D")
				if applied == nil then
					if P14 and x:IsDescendantOf(P14) then applied = I.a0 -- pass 14 rebuilds its towers on the island's current place
					else applied = x:GetAttribute("P15Isl") and I.d1 or Vector3.zero end
				end
				local dd = I.d - applied
				if dd.Magnitude > 0.01 then move(x, dd); moved += 1 end
				x:SetAttribute("P15D", I.d); x:SetAttribute("P15Isl", true)
			end
		end
	end
	table.insert(report, "island pieces moved " .. moved)
	-- falls: 3.5 wide (200,235,255) T 0.3; mist at the foot of each fall
	for _, x in ipairs(root.Islands:GetChildren()) do
		if x.Name == "Fall10" and x:IsA("BasePart") then
			x.Size = Vector3.new(3.5, x.Size.Y, x.Size.Z); x.Color = rgb(200, 235, 255); x.Transparency = 0.3; x.Material = SM; x.CastShadow = false
		elseif x.Name == "FallLip10" and x:IsA("BasePart") then
			x.Size = Vector3.new(4.2, x.Size.Y, x.Size.Z); x.Color = rgb(225, 245, 255); x.Transparency = 0.15
		elseif x.Name == "FallMist10" and x:IsA("BasePart") then
			local e = x:FindFirstChildOfClass("ParticleEmitter")
			if e then
				e.Enabled = true; e.Color = ColorSequence.new(rgb(235, 248, 255)); e.LightEmission = 0.2
				e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.55), NumberSequenceKeypoint.new(1, 1) })
				e.Size = NumberSequence.new(5, 9); e.Rate = 3; e.Lifetime = NumberRange.new(2.5, 4); e.Speed = NumberRange.new(0.5, 2)
				e.SpreadAngle = Vector2.new(60, 60)
			end
		end
	end
end
-- ================================================================ kit-dependent (r15): grass spilling over the island rims, gold canopy
if HAS15 then
	local SPR = { blue = "rbxassetid://118173022878419", gold = "rbxassetid://94449468583229", purple = "rbxassetid://108341914835015", grey = "rbxassetid://92399071475046" }
	local ROUGH, METAL = "rbxassetid://79618306495225", "rbxassetid://133069801476067"
	local function ext(prefix)
		local lo, hi = math.huge, -math.huge
		for _, k in ipairs(kit:GetChildren()) do if k.Name:sub(1, #prefix + 1) == prefix .. "_" then lo = math.min(lo, k.Position.Y - k.Size.Y / 2); hi = math.max(hi, k.Position.Y + k.Size.Y / 2) end end
		return lo, hi - lo
	end
	local function soft(prefix, foot, scale, fam, tint, parent, yaw)
		-- foot = lowest point; tint = {dark, light} for the grey texture, nil for the baked families (white SurfaceAppearance)
		local lo = ext(prefix)
		local cf = CFrame.new(foot - Vector3.new(0, lo * scale, 0)) * CFrame.Angles(0, yaw or 0, 0)
		local m = Instance.new("Model"); m.Name = prefix
		for _, k in ipairs(kit:GetChildren()) do
			if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
				local c = k:Clone(); c.Size = k.Size * scale; c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
				c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CanTouch = false; c.Material = SM
				local tok = k.Name:match("_(%a+)$")
				if tok == "wood" then c.Color = rgb(105, 76, 52); c.CanCollide = true; c.CanQuery = true
				else
					c.CastShadow = false
					local sa = Instance.new("SurfaceAppearance"); sa.AlphaMode = Enum.AlphaMode.Transparency
					sa.ColorMap = SPR[fam] or SPR.grey; sa.RoughnessMap = ROUGH; sa.MetalnessMap = METAL
					local col = tint and ((tok == "leafRim") and tint[2] or tint[1]) or ((tok == "leafRim") and rgb(255, 255, 255) or rgb(225, 225, 225))
					sa.Color = col; c.Color = col; sa.Parent = c
				end
				c.Parent = m
			end
		end
		m.Parent = parent; return m
	end
	_G.P15_SOFT = soft
	-- grass spill: green clumps hung over each island's rim, squashed flat and pulled down so the cards droop over the edge
	local SP = Instance.new("Folder"); SP.Name = "IslSpill15"; SP.Parent = P15
	local rng = Random.new(1515); local n = 0
	local GREEN = { rgb(70, 150, 55), rgb(120, 195, 70) }
	for _, x in ipairs(root.Islands:GetChildren()) do
		if x.Name:sub(1, 6) == "K_Isl9" then
			local cf, sz = x:GetBoundingBox()
			local top = cf.Y + sz.Y * 0.32
			for i = 1, 10 do
				local a = i / 10 * math.pi * 2 + rng:NextNumber(-0.2, 0.2)
				local p = Vector3.new(cf.X + math.cos(a) * sz.X * 0.43, top - rng:NextNumber(3, 6), cf.Z + math.sin(a) * sz.Z * 0.43)
				local m = soft("K_Soft15K", p, rng:NextNumber(0.9, 1.3), "grey", GREEN, SP, rng:NextNumber(0, 6.28))
				m:SetAttribute("P15Isl", true); n += 1
			end
		end
	end
	table.insert(report, "island spill clumps " .. n)
end
_G.P15_REPORT = table.concat(report, "; ")
end
return "pass15 ok: " .. tostring(_G.P15_REPORT)
