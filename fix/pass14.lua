-- pass14.lua (practice place only): freestyle pass 14 on top of the pass-13 build (notes/fix_brief14.md, verify11_plaza.md).
-- Run AFTER pass 13 (it retunes pass-13 pieces). Idempotent: absolute values; new pieces live in Plaza.Pass14 (rebuilt
-- each run); moved island pieces carry the attribute P14Isl so they move once; bollard parts keep their original
-- size/CFrame in attributes and are reset before each run. Also pasted as the "pass 14" block at the end of build_plaza.lua.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r14 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	-- r14b = the same pieces re-exported with side-correct card normals (the r14 back twins went white from behind)
	local src = workspace:FindFirstChild("ae_kit_r14b") or workspace:FindFirstChild("ae_kit_r14")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale14_stone", true)
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
local HAS14 = kit and kit:FindFirstChild("K_Soft14K_leaf") ~= nil
local old = root:FindFirstChild("Pass14"); if old then old:Destroy() end
local P14 = Instance.new("Folder"); P14.Name = "Pass14"; P14.Parent = root
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P14
	return p
end
local function groundY(x, z, top)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P14 }
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -240, 0), rp)
	return r and r.Position.Y or 0
end
local report = {}

-- ================================================================ item 2a: the east terrace (the "white plinths" at the Raid door)
-- Rayed p3: the reviewer's two plinths are TerraceRail (84,8.2,-14.3) and TerraceBaluster (88.9,8.3,13.8) of the pass-12
-- EAST terrace. pass12.lua/build_plaza.lua now build only the west one; on a live place drop the east pieces here.
do
	local T12 = root:FindFirstChild("Pass12") and root.Pass12:FindFirstChild("Terraces12")
	local n = 0
	if T12 then
		for _, x in ipairs(T12:GetChildren()) do
			if x:IsA("BasePart") and x.Position.X > 70 and math.abs(x.Position.Z) < 20 and x.Name:sub(1, 7) == "Terrace" then x:Destroy(); n += 1 end
		end
	end
	table.insert(report, "east terrace pieces removed " .. n)
end

-- ================================================================ item 2b: Raid facade, skull focal point, red haze
do
	local R = root:FindFirstChild("Pass11") and root.Pass11:FindFirstChild("Raid11")
	if R then
		for _, x in ipairs(R:GetChildren()) do
			if x:IsA("BasePart") and (x.Name:sub(1, 9) == "RaidFacad" or x.Name:sub(1, 9) == "RaidGable" or x.Name == "RaidButtress" or x.Name == "RaidPinnacle") then
				-- dark maroon; the recesses stay near-black
				if x.Name ~= "RaidGableRecess" then x.Color = (x.Name == "RaidButtress" or x.Name == "RaidPinnacle" or x.Name == "RaidGablePin" or x.Name == "RaidFacadeCap") and rgb(70, 18, 24) or rgb(100, 25, 30) end
			end
			if x.Name == "K_Skull8" then
				local cf, sz = x:GetBoundingBox()
				if sz.Y > 40 then -- the big skull tower: dusty rose, the lightest thing on the temple, with its own small red light
					for _, d in ipairs(x:GetDescendants()) do if d:IsA("BasePart") and d.Name:find("_bone$") then d.Color = rgb(225, 100, 105) end end
					local a = Instance.new("Attachment"); a.Name = "SkullLight14"
					local holder = part("SkullLight14", Vector3.new(1, 1, 1), CFrame.new(cf.X - sz.X / 2 - 6, cf.Y + sz.Y * 0.15, 0), rgb(0, 0, 0))
					holder.Transparency = 1; holder.CanCollide = false; holder.CanQuery = false
					local l = Instance.new("PointLight"); l.Color = rgb(255, 90, 90); l.Range = 20; l.Brightness = 1.6; l.Shadows = false; l.Parent = holder
				end
			end
			-- the red flood lights at the facade foot made the whole facade read bright red; the red should come from the air
			if x.Name == "RaidLight9" or x.Name == "RaidLight11" then
				local l = x:FindFirstChildOfClass("PointLight"); if l then l.Brightness = 0.12; l.Range = 30 end
			end
			if x.Name == "RaidHaze" then local e = x:FindFirstChildOfClass("ParticleEmitter"); if e then e.Enabled = false; e:Clear() end end
		end
	end
	local S12 = root:FindFirstChild("Pass12") and root.Pass12:FindFirstChild("RaidSmoke12")
	if S12 then for _, d in ipairs(S12:GetDescendants()) do if d:IsA("ParticleEmitter") then d.Enabled = false; d:Clear() end end end
	local P13 = root:FindFirstChild("Pass13")
	local S13 = P13 and P13:FindFirstChild("RaidSmoke13")
	if S13 then
		-- the pass-13 foot lights at 0.9 lit the facade red: keep them as a faint spill on the steps
		for _, d in ipairs(S13:GetDescendants()) do
			if d:IsA("PointLight") then d.Brightness = 0.35 end
			if d:IsA("ParticleEmitter") then d.Enabled = false; d:Clear() end
		end
	end
	-- red haze v3: saturated red, glowing (LightEmission 0.6), BEHIND and AROUND the facade (beside the skull at z +-30,
	-- behind the facade top, low on both flanks), never in front of the skull face (skull spans z -17..17, front x ~161)
	local hz = part("RaidSmoke14", Vector3.new(1, 1, 1), CFrame.new(0, 0, 0), rgb(0, 0, 0)); hz.Transparency = 1; hz.CanCollide = false; hz.CanQuery = false
	for _, at in ipairs({ { Vector3.new(182, 100, -32), 28 }, { Vector3.new(182, 100, 32), 28 }, { Vector3.new(184, 72, -36), 30 }, { Vector3.new(184, 72, 36), 30 },
		{ Vector3.new(196, 112, 0), 30 }, { Vector3.new(194, 62, 0), 30 }, { Vector3.new(168, 38, -46), 26 }, { Vector3.new(168, 38, 46), 26 } }) do
		local a = Instance.new("Attachment"); a.WorldPosition = at[1]; a.Parent = hz
		local e = Instance.new("ParticleEmitter"); e.Texture = "rbxasset://textures/particles/smoke_main.dds"
		-- first try (230,40,40), LightEmission 0.6, T 0.55: pale pink blobs on the sky, sampled (254,156,195) beside the skull
		-- against the reference (148,102,95): emission adds to the sky behind. Darker red, little emission, denser.
		-- second try (205,35,40), LightEmission 0.08, T 0.42: opaque pure-red blobs (253,23,44). Third: dustier red, softer,
		-- larger so the puffs merge into air, more of them at lower opacity.
		-- (third try (175,62,64) T 0.6 rate 3: still a solid red wall, (234,53,59): ~240 overlapping puffs. Fourth: fewer, thinner.)
		-- (fourth (185,75,78) T 0.74: (186,130,166), the sky shows through. Fit from tries 3-4: about 3.5 puff layers, lit gain
		-- ~1.3, sky (100,190,240) -> colour (160,38,36) at T 0.63 for the target (185,75,80).)
		e.Color = ColorSequence.new(rgb(160, 38, 36), rgb(140, 32, 32)); e.LightEmission = 0.05; e.LightInfluence = 0.5
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.63), NumberSequenceKeypoint.new(0.75, 0.72), NumberSequenceKeypoint.new(1, 1) })
		e.Size = NumberSequence.new(at[2] * 1.1, at[2] * 1.45); e.Rate = 1.2; e.Lifetime = NumberRange.new(8, 11)
		e.Speed = NumberRange.new(0.2, 0.8); e.SpreadAngle = Vector2.new(180, 180); e.Rotation = NumberRange.new(0, 360)
		e.RotSpeed = NumberRange.new(-5, 5); e.Parent = a
		pcall(function() e:Emit(4) end)
	end
end

-- ================================================================ item 3: islands N/NE/NW higher and further out, towers, aqueduct, streams
do
	local ISL = {}
	for _, x in ipairs(root.Islands:GetChildren()) do
		if x.Name:sub(1, 6) == "K_Isl9" then local cf, sz = x:GetBoundingBox(); table.insert(ISL, { c = cf.Position, s = sz, north = cf.Position.Z < -100, moved = x:GetAttribute("P14Isl") == true }) end
	end
	local function delta(I)
		local h = Vector3.new(I.c.X, 0, I.c.Z).Unit
		return h * 30 + Vector3.new(0, 22, 0)
	end
	local function newC(I) return I.moved and I.c or I.c + delta(I) end -- centre after the move (re-runs: already moved)
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
		x:SetAttribute("P14Isl", true)
	end
	local cands = {}
	local P12 = root:FindFirstChild("Pass12")
	for _, F in ipairs({ root.Islands, P12 and P12:FindFirstChild("IslDress12") }) do
		if F then for _, x in ipairs(F:GetChildren()) do table.insert(cands, x) end end
	end
	local OLD = SS:FindFirstChild("Pass13Old") -- stashed island balls (pass 13 rebuilds its clumps from them)
	if OLD then
		for _, x in ipairs(OLD:GetChildren()) do
			local o = x:FindFirstChild("Orig13")
			if o and o.Value and (o.Value.Name == "IslDress12" or o.Value.Name == "Islands") then table.insert(cands, x) end
		end
	end
	local P13 = root:FindFirstChild("Pass13"); local TR = P13 and P13:FindFirstChild("Trees13")
	if TR then for _, x in ipairs(TR:GetChildren()) do local p = posOf(x); if p and p.Y > 60 then table.insert(cands, x) end end end
	local moved = 0
	for _, x in ipairs(cands) do
		if not x:GetAttribute("P14Isl") then
			local p = posOf(x)
			if p and p.Y > 40 then
				local I, d = nearest(p)
				if I and I.north and not I.moved and d < math.max(I.s.X, I.s.Z) * 0.5 + 25 then move(x, delta(I)); moved += 1 end
			end
		end
	end
	-- the island models themselves are in cands too (their own pivot is the island centre)
	table.insert(report, "island pieces moved " .. moved)
	-- streams: the falls were 9-wide translucent white slabs; 2.5-wide pale blue ribbons, T 0.3
	for _, x in ipairs(root.Islands:GetChildren()) do
		if x.Name == "Fall10" and x:IsA("BasePart") then
			if not x:GetAttribute("P14W") then x:SetAttribute("P14W", x.Size.X) end
			x.Size = Vector3.new(2.5, x.Size.Y, x.Size.Z); x.Color = rgb(200, 235, 255); x.Transparency = 0.3; x.Material = SM; x.CastShadow = false
		elseif x.Name == "FallLip10" and x:IsA("BasePart") then
			x.Size = Vector3.new(math.min(x.Size.X, 3.2), x.Size.Y, x.Size.Z); x.Color = rgb(220, 245, 255); x.Transparency = 0.2
		end
	end
	-- 2 extra towers per N island (35-50 tall, grey stone, a dark window band, a dome or a spire) and one aqueduct span
	local ST, DK, RF = rgb(165, 170, 165), rgb(60, 70, 75), rgb(120, 140, 150)
	local rng = Random.new(1414)
	local north = {}
	for _, I in ipairs(ISL) do if I.north then table.insert(north, I) end end
	for k, I in ipairs(north) do
		local c = newC(I); local top = c.Y + I.s.Y * 0.35
		for t = 1, 2 do
			local a = rng:NextNumber(0, 6.28); local r = math.min(I.s.X, I.s.Z) * 0.3
			local p = Vector3.new(c.X + math.cos(a) * r, top, c.Z + math.sin(a) * r)
			local H = rng:NextNumber(35, 50); local w = rng:NextNumber(7, 10)
			local tw = part("IslTower14", Vector3.new(w, H, w), CFrame.new(p + Vector3.new(0, H / 2, 0)), ST)
			part("IslTowerBand14", Vector3.new(w + 0.6, 2.2, w + 0.6), CFrame.new(p + Vector3.new(0, H * 0.72, 0)), DK)
			for f = 0, 3 do
				local ang = f * math.pi / 2
				part("IslTowerWin14", Vector3.new(0.4, 4.5, 1.6), CFrame.new(p + Vector3.new(0, H * 0.5, 0)) * CFrame.Angles(0, ang, 0) * CFrame.new(w / 2 + 0.1, 0, 0), DK)
			end
			if t == 1 then
				local d = part("IslTowerDome14", Vector3.new(w * 1.1, w * 1.1, w * 1.1), CFrame.new(p + Vector3.new(0, H, 0)), RF); d.Shape = Enum.PartType.Ball
			else
				local sp = part("IslTowerSpire14", Vector3.new(w * 0.7, w * 1.6, w * 0.7), CFrame.new(p + Vector3.new(0, H + w * 0.6, 0)), RF)
			end
		end
	end
	-- aqueduct: 4 arches on the far N island's rim, about 56 long, 18 tall
	table.sort(north, function(a, b) return a.c.Z < b.c.Z end)
	local I = north[1]
	if I then
		local c = newC(I); local y0 = c.Y + I.s.Y * 0.3
		local x0 = c.X - 28
		for k = 0, 4 do part("AquePier14", Vector3.new(3, 18, 4), CFrame.new(x0 + k * 14, y0 + 9, c.Z + 8), ST) end
		for k = 0, 3 do
			local arch = part("AqueArch14", Vector3.new(11, 11, 4), CFrame.new(x0 + 7 + k * 14, y0 + 12.5, c.Z + 8) * CFrame.Angles(0, 0, 0), ST)
			arch.Shape = Enum.PartType.Cylinder; arch.CFrame = CFrame.new(x0 + 7 + k * 14, y0 + 12.5, c.Z + 8) * CFrame.Angles(0, math.rad(90), 0)
			arch.Size = Vector3.new(4.2, 11, 11); arch.Color = DK -- dark arch opening read from the plaza
		end
		part("AqueDeck14", Vector3.new(60, 4, 5), CFrame.new(x0 + 28, y0 + 20, c.Z + 8), ST)
		part("AqueChannel14", Vector3.new(60, 0.6, 2.6), CFrame.new(x0 + 28, y0 + 22.2, c.Z + 8), rgb(120, 200, 235))
	end
end

-- ================================================================ item 4: horizon (palace domes S/E; foliage ring needs the kit, below)
do
	local GR, GD, DK = rgb(150, 155, 160), rgb(175, 180, 185), rgb(70, 78, 88)
	local function palace(x, z, w, d, h, yaw)
		local gy = groundY(x, z, 80)
		local cf = CFrame.new(x, gy, z) * CFrame.Angles(0, yaw, 0)
		part("Palace14", Vector3.new(w, h, d), cf * CFrame.new(0, h / 2, 0), GR)
		part("PalaceCornice14", Vector3.new(w + 1.5, 1.5, d + 1.5), cf * CFrame.new(0, h + 0.75, 0), GD)
		for k = -2, 2 do
			part("PalaceArch14", Vector3.new(w * 0.12, h * 0.45, 0.6), cf * CFrame.new(k * w * 0.19, h * 0.3, -d / 2 - 0.2), DK)
		end
		local drum = part("PalaceDrum14", Vector3.new(h * 0.4, w * 0.42, w * 0.42), cf * CFrame.new(0, h + 1.5 + h * 0.2, 0) * CFrame.Angles(0, 0, math.rad(90)), GR)
		drum.Shape = Enum.PartType.Cylinder
		local dome = part("PalaceDome14", Vector3.new(w * 0.5, w * 0.5, w * 0.5), cf * CFrame.new(0, h + 1.5 + h * 0.4, 0), GD); dome.Shape = Enum.PartType.Ball
		local lan = part("PalaceLantern14", Vector3.new(2, 5, 2), cf * CFrame.new(0, h + 1.5 + h * 0.4 + w * 0.25 + 2, 0), GD)
		for s = -1, 1, 2 do
			local sd = part("PalaceSideDome14", Vector3.new(w * 0.22, w * 0.22, w * 0.22), cf * CFrame.new(s * w * 0.38, h + 1.5, 0), GD); sd.Shape = Enum.PartType.Ball
		end
	end
	-- SE quadrant: right of c2, upper left of p2 (camera looking +Z: its left is +X)
	palace(150, 215, 46, 26, 26, math.rad(-35))
	palace(225, 150, 40, 24, 22, math.rad(-55))
	palace(80, 255, 36, 22, 20, math.rad(-15))
	palace(255, 60, 38, 22, 24, math.rad(-80))
end

-- ================================================================ item 5: Story portal frame and the stepped W arena
do
	local SW = root:FindFirstChild("Pass11") and root.Pass11:FindFirstChild("StorySwirl")
	local pc = Vector3.new(-87, 16, 0)
	if SW then
		pc = SW.Position; SW.Transparency = 1
		local l = SW:FindFirstChildOfClass("PointLight"); if l then l.Color = rgb(120, 150, 220); l.Brightness = 0.6 end
	end
	local G = root.Landmarks:FindFirstChild("StoryGlow"); if G then G.Transparency = 1 end
	-- dark opening (15,20,40) in a carved silver-blue frame (150,170,205): 16 voussoir blocks round a 7-radius ring,
	-- every 4th a bigger keystone, plus two jamb columns and a sill
	local FR, FD = rgb(150, 170, 205), rgb(105, 125, 165)
	local face = CFrame.new(pc) * CFrame.Angles(0, math.rad(90), 0) -- the portal faces +X (the plaza)
	local op = part("StoryOpening14", Vector3.new(0.6, 13, 13), CFrame.new(pc + Vector3.new(-0.3, 0, 0)), rgb(15, 20, 40)); op.Shape = Enum.PartType.Cylinder
	op.Material = SM
	for k = 0, 15 do
		local a = k / 16 * math.pi * 2; local key = (k % 4 == 0)
		local r = 7.4
		local blk = part("StoryFrame14", Vector3.new(key and 3.2 or 2.5, key and 2.6 or 2.0, key and 2.2 or 1.6),
			face * CFrame.new(math.cos(a) * r, math.sin(a) * r, 0) * CFrame.Angles(0, 0, a + math.pi / 2), key and FR or FD)
	end
	local ring = part("StoryFrameRing14", Vector3.new(1.2, 15.6, 15.6), CFrame.new(pc + Vector3.new(0.2, 0, 0)), FR); ring.Shape = Enum.PartType.Cylinder
	ring.Transparency = 0 ; ring.CanCollide = false
	-- the ring disc would cover the opening: keep it thin and behind, the opening disc sits in front of it
	ring.CFrame = CFrame.new(pc + Vector3.new(-0.9, 0, 0))
	op.CFrame = CFrame.new(pc + Vector3.new(0.05, 0, 0)); op.Size = Vector3.new(0.4, 12.6, 12.6)
	local gy = groundY(pc.X, pc.Z, 40)
	for s = -1, 1, 2 do
		part("StoryJamb14", Vector3.new(2.4, pc.Y - gy, 2.4), CFrame.new(pc.X, (pc.Y + gy) / 2, pc.Z + s * 7.4), FD)
	end
	part("StorySill14", Vector3.new(3.5, 1, 17), CFrame.new(pc.X, gy + 0.5, pc.Z), FR)
	-- stepped round arena about 40 across round the Story tree (trunk at x -122)
	local ac = Vector3.new(-122, groundY(-122, 24, 60), 0)
	for k, dd in ipairs({ { 42, 1.0, rgb(215, 215, 210) }, { 36, 2.0, rgb(232, 232, 228) }, { 30, 3.0, rgb(220, 222, 218) } }) do
		local c = part("StoryArena14", Vector3.new(dd[2], dd[1], dd[1]), CFrame.new(ac + Vector3.new(0, dd[2] / 2 - 0.4, 0)) * CFrame.Angles(0, 0, math.rad(90)), dd[3])
		c.Shape = Enum.PartType.Cylinder
	end
	for k = 0, 23 do -- gold rim studs on the top step edge
		local a = k / 24 * math.pi * 2
		local s = part("StoryArenaStud14", Vector3.new(0.9, 0.5, 0.9), CFrame.new(ac + Vector3.new(math.cos(a) * 14.6, 2.85, math.sin(a) * 14.6)), rgb(215, 170, 60))
		s.Shape = Enum.PartType.Ball
	end
end

-- ================================================================ item 6: bollards (in the foreground of every spawn camera)
do
	local n = 0
	for _, b in ipairs(root:GetChildren()) do
		if b.Name == "K_Bollard" and b:IsA("Model") then
			for _, p in ipairs(b:GetDescendants()) do -- reset to the original, then cut the height 35% about the base
				if p:IsA("BasePart") then
					if p:GetAttribute("P14Size") then p.Size = p:GetAttribute("P14Size"); p.CFrame = p:GetAttribute("P14CF"); p.Transparency = 0
					else p:SetAttribute("P14Size", p.Size); p:SetAttribute("P14CF", p.CFrame); p:SetAttribute("P14Col", p.Color) end
				end
			end
			local cf, sz = b:GetBoundingBox(); local base = cf.Y - sz.Y / 2
			local top = base
			for _, p in ipairs(b:GetDescendants()) do
				if p:IsA("BasePart") then
					local col = p:GetAttribute("P14Col")
					local h, s = col:ToHSV()
					local gold = s > 0.35 and h > 0.08 and h < 0.18
					if gold then p.Transparency = 1 -- the smooth dome cap goes; a stepped pointed cap replaces it
					else
						p.Size = Vector3.new(p.Size.X, p.Size.Y * 0.65, p.Size.Z)
						p.CFrame = CFrame.new(p.Position.X, base + (p.Position.Y - base) * 0.65, p.Position.Z) * (p.CFrame - p.CFrame.Position)
						p.Color = rgb(150, 155, 160)
						top = math.max(top, p.Position.Y + p.Size.Y / 2)
					end
				end
			end
			local w = math.min(sz.X, sz.Z)
			local GOLD = rgb(215, 170, 55)
			-- first try (steps 0.8/0.58/0.38 of the width) read as a big gold ziggurat; the reference cap is a small knob
			part("BollardCap14", Vector3.new(w * 0.5, 0.35, w * 0.5), CFrame.new(cf.X, top + 0.17, cf.Z), GOLD)
			part("BollardCap14", Vector3.new(w * 0.36, 0.35, w * 0.36), CFrame.new(cf.X, top + 0.52, cf.Z), GOLD)
			local knob = part("BollardKnob14", Vector3.new(w * 0.3, w * 0.3, w * 0.3), CFrame.new(cf.X, top + 0.7 + w * 0.12, cf.Z), GOLD); knob.Shape = Enum.PartType.Ball
			part("BollardTip14", Vector3.new(w * 0.1, w * 0.32, w * 0.1), CFrame.new(cf.X, top + 0.7 + w * 0.36, cf.Z) * CFrame.Angles(0, math.rad(45), 0), GOLD)
			n += 1
		end
	end
	table.insert(report, "bollards " .. n)
end

-- ================================================================ item 7: crystal pods beside the pavilions
do
	local P11 = root:FindFirstChild("Pass11"); local n = 0
	if P11 then
		for _, g in ipairs(P11:GetChildren()) do
			if g.Name == "PavGlow" and g:IsA("BasePart") then
				-- each pavilion sits by an arch at (+-38.5, +-39.5): put the pod on the side away from the arch axis
				local p = g.Position; local h = Vector3.new(p.X, 0, p.Z)
				local out = h.Magnitude > 0 and h.Unit or Vector3.new(1, 0, 0)
				local side = Vector3.new(-out.Z, 0, out.X)
				local q = p + out * 4.5
				local gy = groundY(q.X, q.Z, p.Y + 10)
				local pod = part("CrystalPod14", Vector3.new(3.2, 6, 3.2), CFrame.new(q.X, gy + 3.2, q.Z) * CFrame.Angles(0, math.rad(45), math.rad(8)), rgb(40, 110, 230), Enum.Material.Glass)
				pod.Transparency = 0.15; pod.CanCollide = false
				local core = part("CrystalPodCore14", Vector3.new(1.6, 4, 1.6), pod.CFrame, rgb(70, 150, 255), NE); core.CanCollide = false; core.CastShadow = false
				local cap = part("CrystalPodTip14", Vector3.new(2.2, 2.2, 2.2), pod.CFrame * CFrame.new(0, 3.4, 0) * CFrame.Angles(math.rad(45), 0, math.rad(45)), rgb(40, 110, 230), Enum.Material.Glass)
				cap.Transparency = 0.15; cap.CanCollide = false
				local l = Instance.new("PointLight"); l.Color = rgb(80, 160, 255); l.Range = 12; l.Brightness = 1.4; l.Shadows = false; l.Parent = core
				n += 1
			end
		end
	end
	table.insert(report, "pods " .. n)
end

-- ================================================================ kit-dependent: Story canopy and the horizon foliage ring (r14 clumps)
if HAS14 then
	local SPR = { blue = "rbxassetid://118173022878419", gold = "rbxassetid://94449468583229", purple = "rbxassetid://108341914835015", grey = "rbxassetid://92399071475046" }
	local PAD = { blue = "rbxassetid://128476770660093", gold = "rbxassetid://113808789273710", purple = "rbxassetid://125616853910581", grey = "rbxassetid://131174075081185" }
	local ROUGH, METAL = "rbxassetid://79618306495225", "rbxassetid://133069801476067"
	local SKY = rgb(170, 210, 235)
	-- pass 15: the r15 loose clump (no filler cards) replaces the r14 one when it is in Kit
	local KP = kit:FindFirstChild("K_Soft15K_leaf") and "K_Soft15K_" or "K_Soft14K_"
	local lo, hi = math.huge, -math.huge
	for _, k in ipairs(kit:GetChildren()) do if k.Name:sub(1, 10) == KP then lo = math.min(lo, k.Position.Y - k.Size.Y / 2); hi = math.max(hi, k.Position.Y + k.Size.Y / 2) end end
	local function clump(pos, scale, fam, tint, parent, yaw, haze)
		-- pos = clump centre; fam = baked texture family (blue/gold/purple) or grey + tint (dark, light)
		local m = Instance.new("Model"); m.Name = KP:sub(1, 9)
		local cf = CFrame.new(pos) * CFrame.Angles(0, yaw, 0)
		for _, k in ipairs(kit:GetChildren()) do
			if k.Name:sub(1, 10) == KP then
				local c = k:Clone(); c.Size = k.Size * scale; c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
				c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CanTouch = false; c.CastShadow = false; c.Material = SM
				local tok = k.Name:match("_(%a+)$")
				local sa = Instance.new("SurfaceAppearance"); sa.AlphaMode = Enum.AlphaMode.Transparency
				local tf = SPR[fam] and fam or "grey"
				sa.ColorMap = (tok == "leafPad") and PAD[tf] or SPR[tf]; sa.RoughnessMap = ROUGH; sa.MetalnessMap = METAL
				local col = tint and ((tok == "leafRim") and tint[2] or tint[1]) or ((tok == "leafRim") and rgb(255, 255, 255) or rgb(225, 225, 225))
				if haze then col = col:Lerp(SKY, haze) end
				sa.Color = col; c.Color = col; sa.Parent = c; c.Parent = m
			end
		end
		m.Parent = parent; return m
	end
	local rng = Random.new(1415)
	-- Story canopy: a dense dome about 60 across over the trunk (it covers the trunk from p8 so it no longer reads as a bar
	-- lying across the W half), clumps on a dome shell r 26-30 from (-122, 62, 0), plus hanging blue moss strands
	local SC = Instance.new("Folder"); SC.Name = "StoryCanopy14"; SC.Parent = P14
	local cc = Vector3.new(-122, 58, 0)
	local nC = 0
	for i = 1, 34 do
		local y = 1 - (i - 0.5) / 34 * 0.95; local r = math.sqrt(1 - y * y); local a = i * 2.39996
		local p = cc + Vector3.new(math.cos(a) * r * 28, y * 16 + 4, math.sin(a) * r * 28)
		clump(p, rng:NextNumber(1.5, 1.9), "blue", nil, SC, rng:NextNumber(0, 6.28)); nC += 1
	end
	for i = 1, 6 do clump(cc + Vector3.new(rng:NextNumber(-10, 10), 10, rng:NextNumber(-10, 10)), 1.9, "blue", nil, SC, rng:NextNumber(0, 6.28)) end
	for i = 1, 40 do -- hanging moss: thin blue strands from the canopy underside
		local a = rng:NextNumber(0, 6.28); local r = rng:NextNumber(8, 29)
		local L = rng:NextNumber(8, 16)
		local s = part("StoryMoss14", Vector3.new(0.5, L, 0.5), CFrame.new(cc.X + math.cos(a) * r, cc.Y - 2 - L / 2 + (29 - r) * 0.2, cc.Z + math.sin(a) * r), rgb(50, 110, 230), SM, SC)
		s.CanCollide = false; s.CastShadow = false
		local tipL = part("StoryMossTip14", Vector3.new(1.2, 2.5, 1.2), s.CFrame * CFrame.new(0, -L / 2, 0), rgb(80, 150, 255), SM, SC); tipL.CanCollide = false; tipL.Shape = Enum.PartType.Ball
	end
	-- old pass-13 Story clumps (small) stay; the old vines are hidden (the moss replaces them)
	local ST = root.Pass11:FindFirstChild("StoryTree11")
	if ST then for _, x in ipairs(ST:GetChildren()) do if x.Name == "Vine11" then x.Transparency = 1 end end end
	-- horizon ring: groups of 3-5 overlapping clumps, no trunks, ring 150-215 out on the N/NW/NE/W/E sides (covers the
	-- p7 top corners), hazed toward the sky with distance; the old horizon trunks are hidden
	local HZ = Instance.new("Folder"); HZ.Name = "HorizonRing14"; HZ.Parent = P14
	local fams = { { "blue" }, { "gold" }, { "grey", { rgb(70, 150, 60), rgb(120, 190, 70) } }, { "purple" }, { "grey", { rgb(40, 140, 150), rgb(90, 200, 200) } } }
	local nG = 0
	for i = 0, 27 do
		local a = math.rad(-178 + i * (176 / 27)) -- from the W round the N to the E (z < 0 half), a = angle in XZ
		local R = rng:NextNumber(150, 215)
		local gx, gz = math.cos(a) * R, math.sin(a) * R
		if not (gx > 110 and math.abs(gz) < 100) then -- leave the Raid backdrop alone
			local gy = groundY(gx, gz, 120)
			local f = fams[(i % #fams) + 1]
			local haze = math.clamp((R - 140) / 300, 0.08, 0.25)
			local k = rng:NextInteger(3, 5)
			for j = 1, k do
				local o = Vector3.new(rng:NextNumber(-9, 9), rng:NextNumber(0, 8), rng:NextNumber(-9, 9))
				clump(Vector3.new(gx, gy + 14, gz) + o, rng:NextNumber(2.0, 2.6), f[1], f[2], HZ, rng:NextNumber(0, 6.28), haze)
			end
			clump(Vector3.new(gx, gy + 6, gz), 2.4, f[1], f[2], HZ, rng:NextNumber(0, 6.28), haze) -- low clump hides the foot
			nG += 1
		end
	end
	local H12 = root:FindFirstChild("Pass12") and root.Pass12:FindFirstChild("Horizon12")
	if H12 then for _, x in ipairs(H12:GetChildren()) do if x.Name == "HzTrunk" then x.Transparency = 1 end end end
	table.insert(report, "story clumps " .. nC .. ", horizon groups " .. nG)
end
_G.P14_REPORT = table.concat(report, "; ")
end
return "pass14 ok: " .. tostring(_G.P14_REPORT)
