-- pass18.lua (practice place only): freestyle pass 18 on top of the pass-17 build (notes/fix_brief18.md, verify15_plaza.md).
-- Run AFTER pass 17. Idempotent: new pieces live in Plaza.Pass18 (rebuilt each run); hidden old pieces get P18Hidden (old
-- transparency in P18T); recoloured old pieces keep their pre-pass-18 colour/material in P18Col / P18Mat; light changes keep the
-- old values in P18En / P18B; moved/scaled models keep P18CF0 / P18Sc0.
-- Blocks: --RAID (Raid by measurement against the reference p3 frame), --PALM, --EAST, --KIT18 (flanks, needs ae_kit_r18).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r18 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r18")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale18_stone", true)
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
local old = root:FindFirstChild("Pass18"); if old then old:Destroy() end
local P18 = Instance.new("Folder"); P18.Name = "Pass18"; P18.Parent = root
local P17, P16 = root:FindFirstChild("Pass17"), root:FindFirstChild("Pass16")
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P18
	return p
end
local function ghost(p) p.Transparency = 1; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false; return p end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P18T") == nil then d:SetAttribute("P18T", d.Transparency) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P18Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P18Col") == nil then p:SetAttribute("P18Col", p.Color); p:SetAttribute("P18Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function lightSet(l, enabled, bright)
	if l:GetAttribute("P18En") == nil then l:SetAttribute("P18En", l.Enabled); l:SetAttribute("P18B", l.Brightness) end
	l.Enabled = enabled; if bright then l.Brightness = bright end
end
local function groundY(x, z, top, excl)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = excl or { P18 }
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -240, 0), rp)
	return r and r.Position.Y or 0
end
local report = {}

-- ================================================================ item 2: Raid by measurement (p3 5x5 boxes; targets sampled
-- from out/verify15/v15_p3_spawn_e_ref.jpg, see fix18_plaza.md)
--RAID
do
	local R = root.Pass11.Raid11
	local C = {
		SKULL = rgb(165, 110, 90),   -- s1 (150,93,72): (210,129,106); skull bone (pass 17: (82,49,43))
		TOWER = rgb(136, 79, 61),    -- skull pillar (pass 17: (119,68,59)); nil = leave
		UPB = 3.5,                   -- pass-17 uplight brightness (9); s3 5: rim (180,64,67), lowL (164,70,88)
		UPCOL = nil,                 -- pass-17 uplight colour (255,195,150)
		HAZE = rgb(150, 100, 95),    -- haze colour (pass 17: (200,86,72) rendered (205,63,46))
		HAZERATE = 44,               -- s9 rate 34: hazeR (148,93,95) sky shows through
		FILLL = 0.9,                 -- pass-17 RaidFill17 at z -16 (left of the door), brightness 1.5; s5 0.6: lowL (114,39,54), rim (156,51,56)
		FILLR = nil,                 -- the z +16 one (lights the shadeR wall)
		BANDLIT = rgb(108, 74, 70),  -- pass-17 proud arch bands round the door (105,52,60): rim (158,52,58)
	}
	for _, b in ipairs(P17:GetChildren()) do
		if b.Name == "RaidArchBand17" and C.BANDLIT and b.Position.X < 156.6 then recol(b, C.BANDLIT) end
	end
	for _, f in ipairs(P17:GetChildren()) do
		if f.Name == "RaidFill17" then
			local pl = f:FindFirstChildOfClass("PointLight")
			local b = (f.Position.Z < 0) and C.FILLL or C.FILLR
			if pl and b then pl.Brightness = b end
		end
	end
	local S15 = root.Pass15:FindFirstChild("K_Skull15")
	for _, d in ipairs(S15 and S15:GetChildren() or {}) do
		local tok = d.Name:match("_(%a+)$")
		if tok == "bone" and C.SKULL then recol(d, C.SKULL) elseif tok == "pillar" and C.TOWER then recol(d, C.TOWER) end
	end
	for _, u in ipairs(P16:GetChildren()) do
		if u.Name == "RaidUplight16" then
			local s = u:FindFirstChildOfClass("SpotLight")
			if s and C.UPB then lightSet(s, true, C.UPB) end
			if s and C.UPCOL then s.Color = C.UPCOL end
		end
	end
	local hz = P16:FindFirstChild("RaidHaze16"); local band = hz and hz:FindFirstChild("Band")
	if band and (C.HAZE or C.HAZERATE) then
		if C.HAZE then band.Color = ColorSequence.new(C.HAZE) end
		if C.HAZERATE then band.Rate = C.HAZERATE end
		band:Clear(); pcall(function() band:Emit(200) end)
	end
	table.insert(report, "raid ok")
end
--ENDRAID

-- fire line along the facade base (red ember/flame particles ~1.5 tall) and side haze emitters wrapping the towers
--RAIDFX
do
	local FX = { fire = true, side = false, -- s8 side haze on: shadeR (102,28,33), lowL (142,47,45), tower (138,63,54): brown smog over the facade, so off
		 sideCol = rgb(170, 90, 80), sideRate = 6 }
	local gyF = groundY(149, 0, 30)
	if FX.fire then
		for z = -27, 27, 3 do
			local a = ghost(part("RaidFire18", Vector3.new(2.6, 0.4, 2.6), CFrame.new(149 + math.abs(z) * 0.05, gyF + 0.3, z), rgb(0, 0, 0)))
			local e = Instance.new("ParticleEmitter"); e.Name = "Fire"
			e.Texture = "rbxasset://textures/particles/fire_main.dds"
			e.Color = ColorSequence.new(rgb(255, 90, 50), rgb(200, 20, 20)); e.LightEmission = 0.8; e.LightInfluence = 0
			e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(1, 0.4) })
			e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) })
			e.Lifetime = NumberRange.new(0.5, 0.8); e.Speed = NumberRange.new(1.5, 2.5); e.Rate = 14
			e.SpreadAngle = Vector2.new(10, 10); e.EmissionDirection = Enum.NormalId.Top; e.Parent = a
		end
		local glow = ghost(part("RaidFireGlow18", Vector3.new(0.5, 0.5, 0.5), CFrame.new(146, gyF + 1.5, 0), rgb(0, 0, 0)))
		local pl = Instance.new("SurfaceLight") -- not used: a PointLight row below
		pl:Destroy()
		for _, z in ipairs({ -18, 0, 18 }) do
			local g = ghost(part("RaidFireLight18", Vector3.new(0.5, 0.5, 0.5), CFrame.new(147, gyF + 1.2, z), rgb(0, 0, 0)))
			local l = Instance.new("PointLight"); l.Color = rgb(255, 70, 50); l.Range = 9; l.Brightness = 1.2; l.Shadows = false; l.Parent = g
		end
		glow:Destroy()
	end
	if FX.side then
		for _, s in ipairs({ { 152, 30, -26, 10, 26, 10 }, { 152, 30, 26, 10, 26, 10 }, { 166, 88, 0, 10, 24, 34 } }) do
			local b = ghost(part("RaidHaze18", Vector3.new(s[4], s[5], s[6]), CFrame.new(s[1], s[2], s[3]), rgb(0, 0, 0)))
			local e = Instance.new("ParticleEmitter"); e.Name = "Band"
			e.Color = ColorSequence.new(FX.sideCol); e.LightEmission = 0; e.LightInfluence = 0
			e.Size = NumberSequence.new(10, 16)
			e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.55), NumberSequenceKeypoint.new(0.7, 0.6), NumberSequenceKeypoint.new(1, 1) })
			e.Lifetime = NumberRange.new(6, 9); e.Speed = NumberRange.new(0.3, 0.8); e.Rate = FX.sideRate; e.SpreadAngle = Vector2.new(180, 180)
			e.Shape = Enum.ParticleEmitterShape.Box; e.Parent = b
			pcall(function() e:Emit(40) end)
		end
	end
	table.insert(report, "raidfx ok")
end
--ENDRAIDFX

-- ================================================================ item 3: big red palm in front of the Raid. Position from the
-- frames: the reference palm stands at p3 x~530 and c3 x~980 (crown c3 y~270-300, p3 y~130); the practice camera rays through
-- those pixels cross at about (100, -41.5), crown y ~52-55 there
--PALM
do
	local palm = P16 and P16:FindFirstChild("RaidPalm16")
	if palm then
		if palm:GetAttribute("P17CF0") == nil then palm:SetAttribute("P17CF0", palm:GetPivot()); palm:SetAttribute("P17Sc0", palm:GetScale()) end
		local PALM = { x = 100, z = -41.5, k = 2.0 }
		palm:ScaleTo(palm:GetAttribute("P17Sc0") * PALM.k)
		local cf0 = palm:GetAttribute("P17CF0")
		palm:PivotTo(CFrame.new(PALM.x, cf0.Position.Y, PALM.z) * (cf0 - cf0.Position))
		local cfb, sz = palm:GetBoundingBox()
		local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P18, palm }
		local hit = workspace:Raycast(Vector3.new(PALM.x, 60, PALM.z), Vector3.new(0, -120, 0), rp)
		local gy = hit and hit.Position.Y or 8
		palm:PivotTo(palm:GetPivot() + Vector3.new(0, gy - (cfb.Position.Y - sz.Y / 2), 0))
		local cfb2, sz2 = palm:GetBoundingBox()
		table.insert(report, string.format("palm top %.1f ground %.1f", cfb2.Position.Y + sz2.Y / 2, gy))
	end
end
--ENDPALM

-- ================================================================ item 4: E ground. Pass-17 splats 1.5x (they now overlap: cover
-- ~60% by the Raid to ~30% by the plaza), cores (185,55,55), rims (130,30,35); 12 green grass holes; red splats on the E stair treads
--EAST
do
	local E = { k = 1.5, core = rgb(160, 62, 46), rim = rgb(112, 34, 29), holes = 14, stairP = 0.5, lane = 8 } -- t1 (185,55,55)/(130,30,35) rendered red mean (223,64,70) vs reference (191,73,59) on p8: scaled per channel
	local SPL = P17 and P17:FindFirstChild("Splats17")
	local n = 0
	for _, c in ipairs(SPL and SPL:GetChildren() or {}) do
		if c:IsA("BasePart") then
			if c:GetAttribute("P18Size0") == nil then c:SetAttribute("P18Size0", c.Size) end
			c.Size = c:GetAttribute("P18Size0") * E.k
			c.Color = c.Name:find("core") and E.core or E.rim
			-- the reference keeps a wide grey gravel lane on the E axis from the stairs to the Raid forecourt (p8)
			local p = c.Position
			if math.abs(p.Z) < E.lane + 3 * math.sin(p.X / 9) and p.X > 48 then
				if c:GetAttribute("P18T") == nil then c:SetAttribute("P18T", c.Transparency) end
				c.Transparency = 1; c:SetAttribute("P18Hidden", true)
			end
			n += 1
		end
	end
	local core, rim = kit:FindFirstChild("K_Splat17_core"), kit:FindFirstChild("K_Splat17_rim")
	local rng = Random.new(1818)
	local F = Instance.new("Folder"); F.Name = "East18"; F.Parent = P18
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P18, SPL }
	local function splat(px, py, pz, s)
		local cf = CFrame.new(px, py + 0.05, pz) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0)
		for _, kp in ipairs({ core, rim }) do
			local c = kp:Clone(); c.Size = kp.Size * s; c.CFrame = cf * CFrame.new(0, kp.Position.Y * s, 0) * (kp.CFrame - kp.CFrame.Position)
			c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CanTouch = false; c.CastShadow = false
			c.Material = SM; c.Color = (kp == core) and E.core or E.rim; c.Parent = F
		end
	end
	-- E stair treads (x 28..48, |z| < 17): about half covered
	local ns = 0
	if core and rim then
		for x = 28.5, 40, 1.5 do
			for z = -16, 16, 3 do
				if rng:NextNumber() < E.stairP then
					local px, pz = x + rng:NextNumber(-0.8, 0.8), z + rng:NextNumber(-1, 1)
					local r = workspace:Raycast(Vector3.new(px, 30, pz), Vector3.new(0, -60, 0), rp)
					if r and r.Normal.Y > 0.9 and r.Position.Y > 0.3 and r.Position.Y < 6.6 and r.Instance.Material ~= Enum.Material.Glass and not r.Instance.Name:find("glass") then splat(px, r.Position.Y, pz, rng:NextNumber(0.7, 1.0)); ns += 1 end
				end
			end
		end
	end
	-- green holes: soft grass discs over the red, 2-4 across
	for i = 1, E.holes do
		local px, pz = rng:NextNumber(58, 132), rng:NextNumber(-80, 80)
		local r = workspace:Raycast(Vector3.new(px, 40, pz), Vector3.new(0, -80, 0), rp)
		if r and r.Normal.Y > 0.9 and r.Position.Y < 12 and not r.Instance:IsDescendantOf(root.K_Stairs) then
			local d = rng:NextNumber(3, 6)
			for k = 0, 2 do
				local q = part("GrassHole18", Vector3.new(0.12, d * (1 - k * 0.22), d * (0.8 + 0.2 * rng:NextNumber())), CFrame.new(px + rng:NextNumber(-0.8, 0.8), r.Position.Y + 0.16 + k * 0.01, pz + rng:NextNumber(-0.8, 0.8)) * CFrame.Angles(0, rng:NextNumber(0, 6.28), math.pi / 2), k == 0 and rgb(105, 160, 70) or rgb(130, 185, 85), SM, F)
				q.Shape = Enum.PartType.Cylinder; q.CanCollide = false; q.CastShadow = false
			end
		end
	end
	table.insert(report, "east ok (scaled " .. n .. ", stair splats " .. ns .. ")")
end
--ENDEAST

-- ================================================================ item 1: wing flanks -> the arch's own outer sweep band (kit r18).
-- The pass-17 forward scroll flanks (and their gold edge Parts, whose dark front ends were the "black plinth blocks") are hidden.
--KIT18
if kit and kit:FindFirstChild("K_Sweep18_stone") then
	for _, d in ipairs(P17:GetChildren()) do
		if d.Name:sub(1, 10) == "K_Flank17_" or d.Name == "FlankGold17" then hide(d) end
	end
	local hs = P17:FindFirstChild("K_Hero17_stone") or root.K_Hero:FindFirstChild("K_Hero_stone")
	local hg = P17:FindFirstChild("K_Hero17_gold") or root.K_Hero:FindFirstChild("K_Hero_gold")
	local SW = { stone = { rgb(135, 137, 130), hs and hs.Material or SM }, -- t1 hero stone (101,107,111): c3 face (100,110,117) vs reference lit face (162,164,150)
		groove = { rgb(30, 36, 44), Enum.Material.Slate },
		gold = { hg and hg.Color or rgb(215, 170, 55), hg and hg.Material or Enum.Material.Metal } }
	for tok, st in pairs(SW) do
		local k = kit:FindFirstChild("K_Sweep18_" .. tok)
		if k then
			local n = k:Clone(); n.Anchored = true; n.Color = st[1]; n.Material = st[2]; n.CanCollide = (tok == "stone"); n.Parent = P18
			if hs and tok == "stone" then n.Reflectance = hs.Reflectance end
		end
	end
	table.insert(report, "kit18 ok")
else
	table.insert(report, "kit18 skipped (no r18 kit)")
end
--ENDKIT18

return table.concat(report, "; ")
end
