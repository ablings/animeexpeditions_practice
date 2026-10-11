-- pass13.lua (practice place only): freestyle pass 13 on top of the pass-12 build (notes/fix_brief13.md, verify10_plaza.md).
-- Idempotent: absolute values, and everything new lives in Plaza.Pass13 (rebuilt each run); swapped-out trees are
-- hidden into Plaza.Pass13Old (restored on each run before swapping again), so a re-run never swaps twice.
-- Also pasted as the "pass 13" block at the end of fix/build_plaza.lua.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
local old = root:FindFirstChild("Pass13"); if old then old:Destroy() end
local P13 = Instance.new("Folder"); P13.Name = "Pass13"; P13.Parent = root
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P13
	return p
end
local function groundY(x, z, top)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P13 }
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -240, 0), rp)
	return r and r.Position.Y or 0
end

-- ================================================================ item 2: local glow and haze
-- Raid: a second smoke holder with wide, denser puffs either side of the skull and across the facade top (the pass-12
-- puffs at T 0.8 never showed from the spawn), plus 3 small red lights at the facade foot.
do
	local hz = part("RaidSmoke13", Vector3.new(1, 1, 1), CFrame.new(0, 0, 0), rgb(0, 0, 0)); hz.Transparency = 1; hz.CanCollide = false; hz.CanQuery = false
	for _, at in ipairs({ { Vector3.new(170, 84, -26), 44, 2 }, { Vector3.new(170, 84, 26), 44, 2 }, { Vector3.new(165, 62, 0), 46, 2 },
		{ Vector3.new(160, 40, -30), 40, 2 }, { Vector3.new(160, 40, 30), 40, 2 } }) do
		local a = Instance.new("Attachment"); a.WorldPosition = at[1]; a.Parent = hz
		local e = Instance.new("ParticleEmitter"); e.Texture = "rbxasset://textures/particles/smoke_main.dds"
		e.Color = ColorSequence.new(rgb(215, 128, 100), rgb(170, 98, 85)); e.LightEmission = 0.1
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.62), NumberSequenceKeypoint.new(1, 1) })
		e.Size = NumberSequence.new(at[2] * 0.7, at[2]); e.Rate = at[3]; e.Lifetime = NumberRange.new(8, 11)
		e.Speed = NumberRange.new(0.3, 1.0); e.SpreadAngle = Vector2.new(180, 180); e.Rotation = NumberRange.new(0, 360)
		e.RotSpeed = NumberRange.new(-6, 6); e.Parent = a
		pcall(function() e:Emit(6) end)
	end
	for _, z in ipairs({ -26, 0, 26 }) do
		local a = Instance.new("Attachment"); a.WorldPosition = Vector3.new(150, 12, z); a.Parent = hz
		local l = Instance.new("PointLight"); l.Color = rgb(255, 60, 55); l.Range = 30; l.Brightness = 0.9; l.Shadows = false; l.Parent = a
	end
	-- red glow strip along the door threshold (the reference has red fire at the door foot)
	local gy = groundY(149, 0, 30)
	for k = 0, 2 do
		local s = part("RaidGlow13", Vector3.new(0.6, 0.25, 16 + 6 * k), CFrame.new(149 - 3 * k, gy + 0.1, 0), rgb(200, 40, 40), NE)
		s.CanCollide = false; s.CastShadow = false; s.Transparency = 0.15 * k
	end
end
-- crystal cores: a small Neon core inside every own K_Crystal and a soft blue light (range 12)
for _, d in ipairs(root:GetDescendants()) do
	if d:IsA("Model") and d.Name == "K_Crystal" and not d:IsDescendantOf(P13) then
		local cf, sz = d:GetBoundingBox()
		local c = part("CrystalCore13", Vector3.new(sz.X * 0.35, sz.Y * 0.5, sz.Z * 0.35), cf, rgb(60, 150, 255), NE)
		c.Shape = Enum.PartType.Ball; c.CanCollide = false; c.CastShadow = false
		local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = c
		local l = Instance.new("PointLight"); l.Color = rgb(80, 170, 255); l.Range = 12; l.Brightness = 1.2; l.Shadows = false; l.Parent = c
	end
end

-- ================================================================ item 6: the two white plinths at the Raid door foot
-- (the E terrace plinths of pass 12 line up with the door from the spawn): drop the E plinth sets and their crystals
do
	local T12 = root:FindFirstChild("Pass12") and root.Pass12:FindFirstChild("Terraces12")
	if T12 then
		for _, x in ipairs(T12:GetChildren()) do
			local p = x:IsA("BasePart") and x.Position or (x:IsA("Model") and x:GetPivot().Position)
			if p and p.X > 0 and (x.Name:sub(1, 6) == "Plinth" or x.Name == "K_Crystal") then x:Destroy() end
		end
	end
	for _, d in ipairs(P13:GetChildren()) do if d.Name == "CrystalCore13" and d.Position.X > 80 and math.abs(d.Position.Z) < 15 then d:Destroy() end end
end

-- ================================================================ item 7: lawn value
-- the big lawns are the Grass-material ground Parts (GroundN/S/E/W, base (74,124,28)), not Terrain: sunlit they render
-- (110,167,62) against the reference lawn (102,152,33); base x target/rendered = (68,112,16)
for _, n in ipairs({ "GroundN", "GroundS", "GroundE", "GroundW" }) do
	local g = root:FindFirstChild(n); if g then g.Color = rgb(68, 112, 16) end
end

-- ================================================================ item 1: soft foliage swap (needs the r13 kit)
local HAS13 = kit and kit:FindFirstChild("K_Soft13R_leaf") ~= nil
if HAS13 then
	-- Old trees are not destroyed: they move into ServerStorage.Pass13Old with an ObjectValue "Orig13" naming their parent,
	-- and every run first puts them back, so this block can be re-run alone. After a full build_plaza rebuild their old
	-- parents are gone, so stale entries are dropped.
	local OLD = SS:FindFirstChild("Pass13Old")
	if OLD then
		for _, x in ipairs(OLD:GetChildren()) do
			local o = x:FindFirstChild("Orig13")
			if o and o.Value and o.Value:IsDescendantOf(root) then x.Parent = o.Value; o:Destroy() else x:Destroy() end
		end
	else OLD = Instance.new("Folder"); OLD.Name = "Pass13Old"; OLD.Parent = SS end
	local function stash(x)
		local o = Instance.new("ObjectValue"); o.Name = "Orig13"; o.Value = x.Parent; o.Parent = x; x.Parent = OLD
	end
	local SPRIG, PAD = "rbxassetid://139984766645372", "rbxassetid://130347176621349" -- own leaf13_sprig / leaf13_pad (tex/make_ae_tex13.py)
	-- colour families: dark (inner cards, filler) / light (outer cards), from the round-10 review; red for the Raid side
	local FAM = {
		blue = { rgb(38, 98, 240), rgb(95, 165, 255) }, purple = { rgb(175, 135, 240), rgb(215, 180, 255) }, -- v13 test: (30,80,220)/(70,140,255) rendered (27-38,64-71,145-174) vs ref (16-44,61-103,196-226); purple (85-88,64-88,150-155) vs lavender
		gold = { rgb(220, 170, 40), rgb(250, 210, 90) }, green = { rgb(90, 160, 60), rgb(130, 190, 70) },
		teal = { rgb(40, 150, 160), rgb(90, 200, 200) }, red = { rgb(120, 25, 35), rgb(175, 55, 60) },
	}
	local function family(c)
		local h, sat = c:ToHSV(); h = h * 360
		if sat < 0.2 then return "green" end
		if h < 20 or h >= 340 then return "red" elseif h < 70 then return "gold" elseif h < 160 then return "green"
		elseif h < 195 then return "teal" elseif h < 255 then return "blue" else return "purple" end
	end
	local SKY = rgb(170, 210, 235)
	local EXT = {}
	local function ext(prefix) -- kit foot and height per prefix
		if EXT[prefix] then return EXT[prefix] end
		local lo, hi = math.huge, -math.huge
		for _, k in ipairs(kit:GetChildren()) do
			if k.Name:sub(1, #prefix + 1) == prefix .. "_" then lo = math.min(lo, k.Position.Y - k.Size.Y / 2); hi = math.max(hi, k.Position.Y + k.Size.Y / 2) end
		end
		EXT[prefix] = { lo, hi - lo }; return EXT[prefix]
	end
	local WOOD = rgb(105, 76, 52)
	local function soft(prefix, pos, scale, fam, parent, yaw, haze)
		-- pos = where the foot (lowest point) goes; leaves get the own leaf texture through a tinted cut-out SurfaceAppearance
		local f = FAM[fam] or FAM.green; local dark, light = f[1], f[2]
		if haze then dark = dark:Lerp(SKY, haze); light = light:Lerp(SKY, haze) end
		local e = ext(prefix)
		local cf = CFrame.new(pos - Vector3.new(0, e[1] * scale, 0)) * CFrame.Angles(0, yaw or 0, 0)
		local m = Instance.new("Model"); m.Name = prefix
		for _, k in ipairs(kit:GetChildren()) do
			if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
				local c = k:Clone(); c.Size = k.Size * scale
				c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
				c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CanTouch = false; c.Material = SM
				local tok = k.Name:match("_(%a+)$")
				if tok == "wood" then c.Color = WOOD; c.CanCollide = true; c.CanQuery = true
				else
					c.CastShadow = false
					local sa = Instance.new("SurfaceAppearance"); sa.AlphaMode = Enum.AlphaMode.Transparency
					sa.ColorMap = (tok == "leafPad") and PAD or SPRIG
					sa.Color = (tok == "leafRim") and light or dark; c.Color = sa.Color; sa.Parent = c
				end
				c.Parent = m
			end
		end
		m.Parent = parent or P13
		return m
	end
	local function oldInfo(m)
		local cf, sz = m:GetBoundingBox(); local col
		for _, p in ipairs(m:GetDescendants()) do if p:IsA("BasePart") and p.Name:find("_leaf$") then col = p.Color end end
		return Vector3.new(cf.X, cf.Y - sz.Y / 2, cf.Z), sz, col
	end
	local rng = Random.new(1313)
	local TREES = Instance.new("Folder"); TREES.Name = "Trees13"; TREES.Parent = P13
	local n = 0
	local function tick() n = n + 1; if n % 40 == 0 then task.wait() end end

	-- 1a. kit trees (crystal-shard Fluffy/FluffyS, wisteria, cypress, palms) -> soft trees of the same height
	local list = {}
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("Model") and not d:IsDescendantOf(P13) and (d.Name == "K_Fluffy" or d.Name == "K_FluffyS" or d.Name == "K_Wisteria"
			or d.Name == "K_Cypress" or d.Name == "K_Palm6A" or d.Name == "K_Palm6B") then table.insert(list, d) end
	end
	for _, m in ipairs(list) do
		local foot, sz, col = oldInfo(m); local fam = family(col or rgb(90, 160, 60)); local H = sz.Y
		-- round-10 item 10: the SE side shows blue trees only (the red tree at the left of p2)
		if fam == "red" and foot.Z > 0 and foot.X < 120 then fam = "blue" end
		local pre
		if m.Name == "K_Cypress" then pre = "K_Soft13Y"; H = math.max(H * 1.1, 16)
		elseif m.Name:sub(1, 7) == "K_Palm6" then pre = "K_Soft13P"
		elseif m.Name == "K_Wisteria" or fam == "purple" then pre = "K_Soft13W"
		elseif math.abs(math.abs(foot.X) - 38.5) < 3 and math.abs(math.abs(foot.Z) - 39.5) < 3 then pre = "K_Soft13C" -- the 4 arch trees behind the pools
		elseif fam == "gold" and H > 22 then pre = "K_Soft13U"
		else pre = (rng:NextNumber() < 0.35) and "K_Soft13C" or "K_Soft13R" end
		if pre == "K_Soft13C" and math.abs(math.abs(foot.X) - 38.5) < 3 then H = 28 end -- the reference arch tree is about 1.5x taller
		local sc = math.clamp(H / ext(pre)[2], 0.5, 4)
		soft(pre, foot, sc, fam, TREES, rng:NextNumber(0, 6.28))
		-- densify: loose clumps round the canopy shell (the kit tree alone reads sparse through the cut-out leaves)
		if pre ~= "K_Soft13Y" and pre ~= "K_Soft13P" then
			local wide = (pre == "K_Soft13U") and 0.5 or 0.32
			local k = (pre == "K_Soft13U") and 6 or 4
			local cc = foot + Vector3.new(0, H * ((pre == "K_Soft13U") and 0.82 or 0.7), 0)
			for i = 1, k do
				local a = (i / k) * 6.28 + rng:NextNumber(-0.4, 0.4)
				local p = cc + Vector3.new(math.cos(a) * H * wide, H * rng:NextNumber(-0.12, 0.1), math.sin(a) * H * wide)
				soft("K_Soft13K", p, H / 20, fam, TREES, rng:NextNumber(0, 6.28))
			end
		end
		stash(m); tick()
	end

	-- 1b. Parts trees of pass 12: avenue cypress cones -> soft cypress 5 x 17 (the pair flanking the avenue, item 3)
	local P12 = root:FindFirstChild("Pass12")
	local AV = P12 and P12:FindFirstChild("Avenue12")
	if AV then
		for _, x in ipairs(AV:GetChildren()) do
			if x.Name == "Cypress" then
				local foot = Vector3.new(x.Position.X, x.Position.Y - x.Size.Y / 2 - 2, x.Position.Z)
				soft("K_Soft13Y", foot, 17 / ext("K_Soft13Y")[2], "blue", TREES, rng:NextNumber(0, 6.28)); stash(x); tick()
			elseif x.Name == "CypTrunk" then stash(x) end
		end
	end
	-- 1c. horizon tree masses: each Ball crown -> one soft clump of the same size, far ring (r > 330) hazed 20% to the sky
	local HZ = P12 and P12:FindFirstChild("Horizon12")
	if HZ then
		for _, x in ipairs(HZ:GetChildren()) do
			if x.Name == "HzCrown" then
				local r = Vector2.new(x.Position.X, x.Position.Z).Magnitude
				local fam, hz = family(x.Color), (r > 330) and 0.2 or 0.08
				soft("K_Soft13K", x.Position - Vector3.new(0, x.Size.Y * 0.45, 0), x.Size.X / 7, fam, TREES, rng:NextNumber(0, 6.28), hz)
				local off = Vector3.new(rng:NextNumber(-1, 1), 0, rng:NextNumber(-1, 1)) * x.Size.X * 0.35
				soft("K_Soft13K", x.Position + off - Vector3.new(0, x.Size.Y * 0.6, 0), x.Size.X / 8, fam, TREES, rng:NextNumber(0, 6.28), hz)
				stash(x); tick()
			elseif x.Name == "HzTrunk" then x.Color = WOOD end
		end
	end
	-- 1d. island trees (LeafyGrass balls of pass 12, sphere puffs of pass 9) -> soft clumps
	for _, F in ipairs({ P12 and P12:FindFirstChild("IslDress12"), root:FindFirstChild("Islands") }) do
		if F then
			for _, x in ipairs(F:GetChildren()) do
				if x.Name == "IslTreeBall" or x.Name == "IslPuff" then
					soft("K_Soft13K", x.Position - Vector3.new(0, x.Size.Y * 0.4, 0), math.max(x.Size.X, x.Size.Z) / 7, "green", TREES, rng:NextNumber(0, 6.28), 0.05)
					stash(x); tick()
				end
			end
		end
	end
	-- 1e. Story tree canopy: every Parts clump -> a drooping blue soft clump of the same size (item 5)
	local ST = root:FindFirstChild("Pass11") and root.Pass11:FindFirstChild("StoryTree11")
	if ST then
		for _, x in ipairs(ST:GetChildren()) do
			if x.Name == "Clump11" then
				soft("K_Soft13K", x.Position - Vector3.new(0, x.Size.Y * 0.4, 0), math.max(x.Size.X, x.Size.Z) / 8.5, "blue", TREES, rng:NextNumber(0, 6.28))
				stash(x); tick()
			end
		end
	end
	-- ================================================================ item 3: avenue and flank density
	-- purple wisteria masses: right of Summon (reference about 40 x 25) and behind the NE arch; a gold mass left-behind of Summon
	local function mass(pre, pts, fam, H)
		for _, q in ipairs(pts) do
			local gy = groundY(q[1], q[2], 60)
			local h = H * rng:NextNumber(0.85, 1.15)
			soft(pre, Vector3.new(q[1], gy, q[2]), h / ext(pre)[2], fam, TREES, rng:NextNumber(0, 6.28))
			for i = 1, 3 do
				local a = rng:NextNumber(0, 6.28)
				soft("K_Soft13K", Vector3.new(q[1] + math.cos(a) * h * 0.35, gy + h * 0.55, q[2] + math.sin(a) * h * 0.35), h / 20, fam, TREES, a)
			end
			tick()
		end
	end
	mass("K_Soft13W", { { 46, -182 }, { 58, -196 }, { 50, -210 }, { 66, -178 } }, "purple", 22)
	mass("K_Soft13W", { { 66, -66 }, { 78, -58 }, { 60, -80 } }, "purple", 19)
	mass("K_Soft13U", { { -62, -205 }, { -76, -190 } }, "gold", 30)
end
end
return "pass13 ok"
