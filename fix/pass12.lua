-- pass12.lua (practice place only): freestyle pass 12 on top of the pass-11 build (notes/fix_brief12.md, verify9_plaza.md).
-- Idempotent: absolute colours/positions, and everything new lives in Plaza.Pass12 (rebuilt each run).
-- Also pasted as the "pass 12" block at the end of fix/build_plaza.lua.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, SL, NE = Enum.Material.SmoothPlastic, Enum.Material.Slate, Enum.Material.Neon
local old = root:FindFirstChild("Pass12"); if old then old:Destroy() end
local P12 = Instance.new("Folder"); P12.Name = "Pass12"; P12.Parent = root
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P12
	return p
end
local function each(m, f) if m:IsA("BasePart") then f(m) end for _, d in ipairs(m:GetDescendants()) do if d:IsA("BasePart") then f(d) end end end

-- ================================================================ item 2: Raid light/dark swap
local R = root:FindFirstChild("Pass11") and root.Pass11:FindFirstChild("Raid11")
if R then
	local FAC, REC, SPI = rgb(70, 22, 34), rgb(22, 5, 9), rgb(48, 16, 24)
	for _, x in ipairs(R:GetChildren()) do
		local n = x.Name
		if n == "RaidFacade" or n == "RaidGable" or n == "RaidGableTall" or n == "RaidGableFlank" or n == "RaidGableShoulder" then
			x.Color = FAC
		elseif n == "RaidButtress" or n == "RaidFacadeCap" then x.Color = rgb(52, 14, 22)
		elseif n == "RaidGableRecess" then x.Color = REC
		elseif n == "K_Arcade7" or n == "K_Gothic" then
			each(x, function(p) if p.Name:find("_stone") then p.Color = FAC elseif p.Name:find("darkStone") then p.Color = REC end end)
		elseif n == "K_Skull8" then
			local big = (x:GetExtentsSize().Y > 30)
			each(x, function(p)
				if p.Name:find("_bone") then
					if big then p.Color = rgb(175, 95, 95); p.Material = SM end -- (205,125,125) rendered (225,91,96)+ in the haze vs (180,93,86) -- dusty rose, the lightest thing on the temple
				elseif p.Name:find("_dark") then p.Color = rgb(55, 16, 20) end
			end)
		elseif n == "K_TxtRaid9" then each(x, function(p) p.Color = rgb(190, 80, 85) end) -- Neon (225,105,110) rendered (254,155,173) vs (187-235,114-121,113-122)
		end
	end
	-- red smoke at the skull and the door, a soft rose light on the skull face
	local hz = part("RaidSmoke12", Vector3.new(1, 1, 1), CFrame.new(0, 0, 0), rgb(0, 0, 0), SM, R); hz.Transparency = 1; hz.CanCollide = false
	hz.Name = "RaidSmoke12"; hz.Parent = P12
	for _, at in ipairs({ { Vector3.new(166, 80, 0), 26, 4 }, { Vector3.new(150, 14, 0), 22, 5 }, { Vector3.new(160, 45, 0), 30, 3 } }) do
		local a = Instance.new("Attachment"); a.WorldPosition = at[1]; a.Parent = hz
		local e = Instance.new("ParticleEmitter"); e.Texture = "rbxasset://textures/particles/smoke_main.dds"
		e.Color = ColorSequence.new(rgb(215, 95, 95), rgb(170, 70, 75)); e.LightEmission = 0 -- (255,70,70) with LightEmission 0.4 burnt the facade to (169,24,36): pinkish haze instead
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.8), NumberSequenceKeypoint.new(1, 1) })
		e.Size = NumberSequence.new(at[2] * 0.6, at[2]); e.Rate = at[3]; e.Lifetime = NumberRange.new(6, 9)
		e.Speed = NumberRange.new(0.5, 1.5); e.SpreadAngle = Vector2.new(180, 180); e.Rotation = NumberRange.new(0, 360)
		e.RotSpeed = NumberRange.new(-10, 10); e.Parent = a
	end
	local sk = Instance.new("Attachment"); sk.WorldPosition = Vector3.new(150, 86, 0); sk.Parent = hz
	local pl = Instance.new("PointLight"); pl.Color = rgb(255, 150, 150); pl.Range = 30; pl.Brightness = 0.6; pl.Parent = sk
	-- the beam light (1.2, range 26) lit the gable above the letters bright red: the skull must stay the lightest thing
	local bm = R:FindFirstChild("RaidBeam11"); local bl = bm and bm:FindFirstChildOfClass("PointLight"); if bl then bl.Brightness = 0.35; bl.Range = 16 end
	-- the 2 dark red palms move from the forecourt corners to either side of the door
	for _, x in ipairs(R:GetChildren()) do
		if x.Name == "K_Palm6B" then
			local s = (x:GetPivot().Position.Z > 0) and 1 or -1
			local cf, sz = x:GetBoundingBox(); local foot = cf.Position.Y - sz.Y / 2
			x:PivotTo(x:GetPivot() + (Vector3.new(146, x:GetPivot().Position.Y - foot + 6, s * 30) - x:GetPivot().Position))
			each(x, function(p) if p.Name:find("leaf") then p.Color = rgb(110, 22, 32) end end)
		end
	end
end

-- ================================================================ item 3: red litter as fine speckle over grey gravel
-- The pass-11 red zone was 54 big flat K_Patch cards plus red terrain beds: from above it read as solid red islands.
-- The reference reads as many small red leaves over grey gravel with green tufts and white flower dots.
do
	local P11 = root:FindFirstChild("Pass11")
	if P11 then
		for _, x in ipairs(P11:GetChildren()) do if x.Name:match("^K_Patch") then x:Destroy() end end
		local road = P11:FindFirstChild("GravelRoad"); if road then road.Color = rgb(72, 76, 74) end -- (62,66,64) rendered (89,99,99) vs (103,108,105)
	end
	local T = workspace.Terrain
	-- red terrain beds (NE corner bed, the two Raid flank beds) and the three tall-grass blocks go
	for _, b in ipairs({ { 80, -70, 40, 34 }, { 80, 70, 40, 34 }, { -80, 70, 40, 34 }, { -120, 0, 48, 74 }, { 185, -70, 34, 26 }, { 185, 70, 34, 26 } }) do
		T:FillBlock(CFrame.new(b[1], 5, b[2]), Vector3.new(b[3], 8, b[4]), Enum.Material.Air)
	end
	local L = Instance.new("Folder"); L.Name = "Litter12"; L.Parent = P12
	local gv = part("Gravel12", Vector3.new(127, 0.2, 200), CFrame.new(111.5, 5.96, -5), rgb(72, 76, 74), Enum.Material.Slate, L)
	local rng = Random.new(1212)
	local REDS = { rgb(112, 32, 33), rgb(120, 36, 36), rgb(128, 42, 40), rgb(118, 30, 38) } -- base; pass-11 (100-132,34-52) rendered (168-173,43-54)
	local function inZone(x, z) return x > 50 and x < 172 and z > -102 and z < 92 and math.abs(z) > 15 end
	local nC = 0
	local function card(x, z, w, d, col, parent)
		-- 2 in 3 leaves are flat discs (a lying cylinder): rectangles alone read as red bricks at the p7 angle.
		-- y 6.34: above the Zoning gravel patches (tops up to 6.32), which hid leaves at 6.13
		local p = Instance.new("Part"); p.Name = "Leaf"; p.Color = col; p.Material = SM
		local yaw = CFrame.Angles(0, rng:NextNumber(0, math.pi), 0)
		if rng:NextNumber() < 0.67 then
			p.Shape = Enum.PartType.Cylinder; p.Size = Vector3.new(0.06, d * 1.3, d * 1.3)
			p.CFrame = CFrame.new(x, 6.34 + rng:NextNumber(0, 0.04), z) * yaw * CFrame.Angles(0, 0, math.pi / 2)
		else
			p.Size = Vector3.new(w * 0.8, 0.06, d * 0.5)
			p.CFrame = CFrame.new(x, 6.34 + rng:NextNumber(0, 0.04), z) * yaw
		end
		p.Anchored = true; p.CanCollide = false; p.CastShadow = false; p.Parent = parent; nC += 1
	end
	-- clustered red leaves: 100 clusters, dense centres and ragged edges, gravel showing between
	local chunk = Instance.new("Folder"); chunk.Name = "Red"
	for c = 1, 100 do -- 70 clusters covered about 25% in p8; the reference is about 50%
		local cx, cz
		repeat cx, cz = rng:NextNumber(50, 172), rng:NextNumber(-102, 92) until inZone(cx, cz)
		local r = rng:NextNumber(6, 12)
		for k = 1, 30 do
			local a, d = rng:NextNumber(0, 2 * math.pi), r * math.sqrt(rng:NextNumber())
			local x, z = cx + math.cos(a) * d, cz + math.sin(a) * d
			if inZone(x, z) then card(x, z, rng:NextNumber(2, 4), rng:NextNumber(1, 2.2), REDS[rng:NextInteger(1, #REDS)], chunk) end
		end
		if c % 10 == 0 then chunk.Parent = L; chunk = Instance.new("Folder"); chunk.Name = "Red"; task.wait() end
	end
	chunk.Parent = L
	-- green tufts: 12 small clumps of short green cards
	local gch = Instance.new("Folder"); gch.Name = "Green"
	for c = 1, 12 do
		local cx, cz
		repeat cx, cz = rng:NextNumber(50, 172), rng:NextNumber(-102, 92) until inZone(cx, cz)
		for k = 1, 14 do
			local a, d = rng:NextNumber(0, 2 * math.pi), 5 * math.sqrt(rng:NextNumber())
			card(cx + math.cos(a) * d, cz + math.sin(a) * d, rng:NextNumber(1.5, 3), rng:NextNumber(0.8, 1.6), rgb(70, 120, 32), gch)
		end
	end
	gch.Parent = L
	-- white flower dots scattered over the red and green
	local fch = Instance.new("Folder"); fch.Name = "Flowers"
	for k = 1, 160 do
		local x, z
		repeat x, z = rng:NextNumber(50, 172), rng:NextNumber(-102, 92) until inZone(x, z)
		local p = Instance.new("Part"); p.Name = "Flower"; p.Shape = Enum.PartType.Ball; p.Size = Vector3.new(0.7, 0.7, 0.7)
		p.Color = rgb(235, 235, 230); p.Material = SM; p.CFrame = CFrame.new(x, 6.42, z); p.Anchored = true; p.CanCollide = false
		p.CastShadow = false; p.Parent = fch
	end
	fch.Parent = L
	print("litter cards", nC)
end

-- ================================================================ item 4: islands (grey-green rock, lifted, towers and round trees)
do
	local I = root:FindFirstChild("Islands")
	if I then
		local isl = {}
		for _, x in ipairs(I:GetChildren()) do if x.Name == "K_Isl91" or x.Name == "K_Isl92" then table.insert(isl, x) end end
		-- the 3 big low cloud blobs read as snowy mountains behind Summon in c3/c4; the new skybox carries the clouds now
		for _, x in ipairs(I:GetChildren()) do
			if x.Name == "K_Cloud7" and x:GetExtentsSize().X > 250 then x:Destroy() end
		end
		-- assign every island dressing (trees, ruins, domes, aqueducts, falls, fills) to its nearest island by XZ
		local groups = {}
		for _, x in ipairs(I:GetChildren()) do
			if not x.Name:match("^K_Cloud") and x.Name ~= "K_Isl91" and x.Name ~= "K_Isl92" then
				local pos = x:IsA("BasePart") and x.Position or (x:IsA("Model") and x:GetPivot().Position)
				if pos then
					local best, bd
					for _, m in ipairs(isl) do
						local d = (Vector2.new(pos.X, pos.Z) - Vector2.new(m:GetPivot().X, m:GetPivot().Z)).Magnitude
						if not bd or d < bd then best, bd = m, d end
					end
					if best and bd < 110 then groups[best] = groups[best] or {}; table.insert(groups[best], x) end
				end
			end
		end
		local TW = Instance.new("Folder"); TW.Name = "IslDress12"; TW.Parent = P12
		local rng = Random.new(412)
		for _, m in ipairs(isl) do
			local pv = m:GetPivot().Position
			-- lift N, W and E islands (stored once as an attribute so re-runs do not keep lifting)
			local lift = (pv.Z < -100 or pv.X < -150 or pv.X > 200) and 18 or 0
			local done = m:GetAttribute("Lift12") or 0
			local dy = lift - done
			if dy ~= 0 then
				m:PivotTo(m:GetPivot() + Vector3.new(0, dy, 0))
				for _, x in ipairs(groups[m] or {}) do
					if x:IsA("BasePart") then x.CFrame = x.CFrame + Vector3.new(0, dy, 0) else x:PivotTo(x:GetPivot() + Vector3.new(0, dy, 0)) end
				end
				m:SetAttribute("Lift12", lift)
			end
			-- grey-green rock with darker crevices: rock tone down, fills/crevices darker
			for _, p in ipairs(m:GetChildren()) do
				if p.Name:find("_rock") then p.Color = rgb(150, 162, 148) end
			end
			for _, x in ipairs(groups[m] or {}) do if x.Name == "IslFill" and x:IsA("BasePart") then x.Color = rgb(92, 102, 96) end end
			-- one tall grey tower and 4 round trees on the top
			local cf, sz = m:GetBoundingBox(); local top = cf.Position.Y + sz.Y / 2 - 2.5
			local ax = (sz.X > sz.Z) and Vector3.new(1, 0, 0) or Vector3.new(0, 0, 1)
			local L = math.max(sz.X, sz.Z)
			local tpos = Vector3.new(cf.X, top, cf.Z) + ax * (L * 0.28)
			local stone, dark = rgb(165, 170, 165), rgb(55, 60, 70)
			part("IslTower", Vector3.new(10, 50, 10), CFrame.new(tpos + Vector3.new(0, 25, 0)), stone, SL, TW)
			part("IslTowerBand", Vector3.new(11, 1.2, 11), CFrame.new(tpos + Vector3.new(0, 34, 0)), rgb(140, 145, 140), SL, TW)
			part("IslTowerTop", Vector3.new(12.5, 3, 12.5), CFrame.new(tpos + Vector3.new(0, 51.5, 0)), stone, SL, TW)
			for k = 0, 3 do
				local a = k * math.pi / 2; local o = Vector3.new(math.sin(a), 0, math.cos(a))
				for h = 0, 1 do
					part("IslTowerWin", Vector3.new(2.2, 6, 0.4), CFrame.lookAt(tpos + Vector3.new(0, 30 + h * 12, 0) + o * 5.05, tpos + Vector3.new(0, 30 + h * 12, 0) + o * 10), dark, SM, TW)
				end
			end
			for k = 1, 4 do
				local t = (k - 2.5) / 2.2
				local pos = Vector3.new(cf.X, top, cf.Z) + ax * (t * L * 0.22 - L * 0.08) + ax:Cross(Vector3.yAxis) * rng:NextNumber(-12, 12)
				local h = rng:NextNumber(7, 10)
				local tr = part("IslTreeTrunk", Vector3.new(1.6, h, 1.6), CFrame.new(pos + Vector3.new(0, h / 2, 0)), rgb(110, 85, 60), SM, TW)
				local g = rgb(85 + rng:NextInteger(0, 20), 150 + rng:NextInteger(0, 20), 55)
				for j = 1, 3 do
					local b = part("IslTreeBall", Vector3.one * rng:NextNumber(7, 10), CFrame.new(pos + Vector3.new(rng:NextNumber(-3, 3), h + rng:NextNumber(1, 5), rng:NextNumber(-3, 3))), g, Enum.Material.LeafyGrass, TW)
					b.Shape = Enum.PartType.Ball
				end
			end
		end
	end
end

-- ================================================================ item 5: horizon masses and the N avenue
do
	local H = Instance.new("Folder"); H.Name = "Horizon12"; H.Parent = P12
	local rng = Random.new(512)
	local CREAM, ROOF = rgb(228, 220, 198), rgb(120, 140, 175)
	local TREES = { rgb(45, 95, 215), rgb(95, 160, 60), rgb(225, 180, 60), rgb(150, 110, 215), rgb(60, 150, 200) }
	local function ball(name, d, pos, col, parent)
		local b = part(name, Vector3.one * d, CFrame.new(pos), col, Enum.Material.LeafyGrass, parent); b.Shape = Enum.PartType.Ball; return b
	end
	-- second, farther ring of tree masses (r 340-430) closes the green gaps to the horizon in p7
	for k = 0, 16 do
		local a = math.rad(-120 + k * 11 + rng:NextNumber(-3, 3)); local r = rng:NextNumber(340, 430)
		local c = Vector3.new(r * math.sin(a), 6, -r * math.cos(a)); local col = TREES[rng:NextInteger(1, #TREES)]
		for j = 1, 6 do
			local p = c + Vector3.new(rng:NextNumber(-26, 26), 0, rng:NextNumber(-16, 16)); local h = rng:NextNumber(22, 40)
			part("HzTrunk", Vector3.new(3.5, h, 3.5), CFrame.new(p + Vector3.new(0, h / 2, 0)), rgb(110, 85, 60), SM, H)
			ball("HzCrown", rng:NextNumber(20, 30), p + Vector3.new(0, h + 5, 0), col:Lerp(rgb(255, 255, 255), rng:NextNumber(0.05, 0.2)), H)
		end
	end
	local angles = { -105, -88, -72, -58, -44, -30, -17, -6, 6, 17, 30, 44, 58, -120, -135 }
	for i, a in ipairs(angles) do
		local r = rng:NextNumber(230, 300); local ar = math.rad(a)
		local c = Vector3.new(r * math.sin(ar), 6, -r * math.cos(ar))
		local face = CFrame.lookAt(c, Vector3.new(0, 6, 0))
		if i % 2 == 1 then -- building mass: block, cornice, dome or pitched roof, arch slots
			local h = rng:NextNumber(30, 55); local w, d = rng:NextNumber(30, 45), rng:NextNumber(20, 30)
			part("HzBlock", Vector3.new(w, h, d), face * CFrame.new(0, h / 2, 0), CREAM, SL, H)
			part("HzCornice", Vector3.new(w + 2, 1.5, d + 2), face * CFrame.new(0, h, 0), rgb(205, 195, 170), SL, H)
			for k = -1, 1 do
				part("HzArch", Vector3.new(4, h * 0.35, 0.6), face * CFrame.new(k * w * 0.28, h * 0.3, -d / 2 - 0.2), rgb(70, 80, 105), SM, H)
			end
			if i % 4 == 1 then
				local dm = part("HzDome", Vector3.one * (w * 0.55), face * CFrame.new(0, h + 1, 0), ROOF, SM, H); dm.Shape = Enum.PartType.Ball
			else
				local w1 = Instance.new("WedgePart"); w1.Name = "HzRoof"; w1.Size = Vector3.new(w, 9, d / 2); w1.CFrame = face * CFrame.new(0, h + 5.2, -d / 4) * CFrame.Angles(0, math.pi, 0)
				w1.Color = ROOF; w1.Material = SM; w1.Anchored = true; w1.Parent = H
				local w2 = w1:Clone(); w2.CFrame = face * CFrame.new(0, h + 5.2, d / 4); w2.Parent = H
			end
		else -- tree mass: 5-7 round crowns on trunks, one colour family
			local col = TREES[rng:NextInteger(1, #TREES)]
			for k = 1, rng:NextInteger(5, 7) do
				local p = c + Vector3.new(rng:NextNumber(-22, 22), 0, rng:NextNumber(-14, 14))
				local h = rng:NextNumber(18, 34)
				part("HzTrunk", Vector3.new(3, h, 3), CFrame.new(p + Vector3.new(0, h / 2, 0)), rgb(110, 85, 60), SM, H)
				ball("HzCrown", rng:NextNumber(16, 24), p + Vector3.new(0, h + 4, 0), col:Lerp(rgb(255, 255, 255), rng:NextNumber(0, 0.15)), H)
			end
		end
	end
	-- N avenue: 6 blue cypress cones (ellipsoids 4 x 14) and 4 striped stalls
	local AV = Instance.new("Folder"); AV.Name = "Avenue12"; AV.Parent = P12
	for _, z in ipairs({ -98, -126, -154 }) do
		for sx = -1, 1, 2 do
			local p0 = Vector3.new(sx * 17, 6, z)
			part("CypTrunk", Vector3.new(1, 2, 1), CFrame.new(p0 + Vector3.new(0, 1, 0)), rgb(100, 75, 50), SM, AV)
			local cy = part("Cypress", Vector3.new(4, 14, 4), CFrame.new(p0 + Vector3.new(0, 8.5, 0)), rgb(40, 90, 220), SM, AV)
			local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = cy
		end
	end
	local AWN = { rgb(220, 60, 60), rgb(60, 120, 220), rgb(230, 170, 40), rgb(60, 170, 90) }
	for i, q in ipairs({ { -28, -112 }, { 28, -112 }, { -28, -142 }, { 28, -142 } }) do
		local face = CFrame.lookAt(Vector3.new(q[1], 6, q[2]), Vector3.new(0, 6, q[2]))
		part("StallCounter", Vector3.new(7, 3, 3.5), face * CFrame.new(0, 1.5, 0), rgb(150, 105, 65), SM, AV)
		for sx = -1, 1, 2 do part("StallPost", Vector3.new(0.4, 6.5, 0.4), face * CFrame.new(sx * 3.3, 3.25, -1.6), rgb(120, 85, 55), SM, AV) end
		for k = 0, 5 do
			local col = (k % 2 == 0) and AWN[i] or rgb(245, 245, 240)
			local st = part("StallAwning", Vector3.new(7.6 / 6, 0.25, 4.4), face * CFrame.new(-3.8 + (k + 0.5) * 7.6 / 6, 6.9, -0.6) * CFrame.Angles(math.rad(-14), 0, 0), col, SM, AV)
		end
		part("StallGoods", Vector3.new(5, 0.8, 2), face * CFrame.new(0, 3.4, 0), AWN[(i % 4) + 1], SM, AV)
	end
end

-- ================================================================ item 7: E/W arm-end terraces and carved pedestals
do
	local TR = Instance.new("Folder"); TR.Name = "Terraces12"; TR.Parent = P12
	local WH, RIM, SOCK = rgb(230, 230, 225), rgb(195, 198, 195), rgb(40, 50, 60)
	for sx = -1, 1, 2 do
		local c = Vector3.new(sx * 94, 6, 0)
		part("Terrace", Vector3.new(20, 1.2, 30), CFrame.new(c + Vector3.new(0, 0.6, 0)), WH, SM, TR)
		part("TerraceStep", Vector3.new(2.5, 0.6, 26), CFrame.new(c + Vector3.new(-sx * 11.2, 0.3, 0)), RIM, SM, TR)
		for sz = -1, 1, 2 do
			part("TerraceRail", Vector3.new(20, 1.4, 1), CFrame.new(c + Vector3.new(0, 1.9, sz * 14.5)), RIM, SM, TR)
			for k = -2, 2 do part("TerraceBaluster", Vector3.new(1.4, 2.4, 1.4), CFrame.new(c + Vector3.new(k * 4.5, 2.4, sz * 14.5)), WH, SM, TR) end
			-- carved plinth with a dark socket holding a crystal
			local pp = c + Vector3.new(sx * 6, 1.2, sz * 9)
			part("PlinthBase", Vector3.new(5, 0.8, 5), CFrame.new(pp + Vector3.new(0, 0.4, 0)), RIM, SM, TR)
			part("Plinth", Vector3.new(4, 4, 4), CFrame.new(pp + Vector3.new(0, 2.8, 0)), WH, SM, TR)
			part("PlinthCap", Vector3.new(4.8, 0.6, 4.8), CFrame.new(pp + Vector3.new(0, 5.1, 0)), RIM, SM, TR)
			part("PlinthSocket", Vector3.new(2.8, 0.3, 2.8), CFrame.new(pp + Vector3.new(0, 5.45, 0)), SOCK, SM, TR)
			local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
			local cr = kit and kit:FindFirstChild("K_Crystal")
			if cr then
				local m = cr:Clone(); m.Parent = TR
				if m:IsA("Model") then m:PivotTo(CFrame.new(pp + Vector3.new(0, 7.2, 0))) else m.CFrame = CFrame.new(pp + Vector3.new(0, 7.2, 0)) end
			end
		end
	end
	-- existing pass-11 pedestals: a dark socket on the cap and a stepped foot
	local P11 = root:FindFirstChild("Pass11")
	if P11 then
		for _, x in ipairs(P11:GetChildren()) do
			if x.Name == "PedestalCap" then
				part("PedSocket", Vector3.new(4, 0.3, 4), x.CFrame * CFrame.new(0, x.Size.Y / 2 + 0.15, 0), SOCK, SM, TR)
			elseif x.Name == "Pedestal" then
				part("PedFoot", Vector3.new(7.5, 0.8, 7.5), CFrame.new(x.Position.X, x.Position.Y - x.Size.Y / 2 + 0.4, x.Position.Z), rgb(195, 198, 195), SM, TR)
			end
		end
	end
end
end
return "pass12 ok"
