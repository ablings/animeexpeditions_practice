-- pass17.lua (practice place only): freestyle pass 17 on top of the pass-16 build (notes/fix_brief17.md, verify14_plaza.md).
-- Run AFTER pass 16. Idempotent: new pieces live in Plaza.Pass17 (rebuilt each run); hidden old pieces get the attribute
-- P17Hidden (old transparency in P17T); recoloured old pieces keep their pre-pass-17 colour/material in P17Col / P17Mat;
-- light changes keep the old values in P17B (brightness), P17En (enabled).
-- Items: 1 Raid measured to the reference p3 rendered values (stone, rims, skull/tower, haze, palm),
-- 2 wing flanks, 3 Summon avenue, 4 E ground. Kit-dependent pieces (r17) are in the --KIT17 block.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r17 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r17")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale17_stone", true)
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
local old = root:FindFirstChild("Pass17"); if old then old:Destroy() end
local P17 = Instance.new("Folder"); P17.Name = "Pass17"; P17.Parent = root
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P17
	return p
end
local function ghost(p) p.Transparency = 1; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false; return p end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P17T") == nil then d:SetAttribute("P17T", d.Transparency) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P17Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P17Col") == nil then p:SetAttribute("P17Col", p.Color); p:SetAttribute("P17Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function lightSet(l, enabled, bright)
	if l:GetAttribute("P17En") == nil then l:SetAttribute("P17En", l.Enabled); l:SetAttribute("P17B", l.Brightness) end
	l.Enabled = enabled; if bright then l.Brightness = bright end
end
local function groundY(x, z, top)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P17 }
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -240, 0), rp)
	return r and r.Position.Y or 0
end
local report = {}

-- ================================================================ item 1: Raid by measurement (p3 5x5 boxes, see fix17_plaza.md)
--RAID
local R = root.Pass11.Raid11
local C = {
	STONE = rgb(88, 47, 56),    -- facade stone (K_Gothic, facade Parts, spires, side towers, arcades)
	TRIM = nil,                 -- buttresses/pinnacles/cap (nil = same as STONE)
	TOWER = rgb(119, 68, 59),   -- RaidGableTall + skull pillar (nil = leave)
	SKULL = rgb(82, 49, 43),    -- skull bone (nil = leave)
}
do
	local TRIM = C.TRIM or C.STONE
	local trimNames = { RaidButtress = true, RaidPinnacle = true, RaidGablePin = true, RaidFacadeCap = true }
	for _, x in ipairs(R:GetChildren()) do
		if x:IsA("BasePart") and (x.Name:sub(1, 9) == "RaidFacad" or x.Name:sub(1, 9) == "RaidGable" or trimNames[x.Name]) then
			if x.Name == "RaidGableRecess" then -- keep
			elseif x.Name == "RaidGableTall" then if C.TOWER then recol(x, C.TOWER) else recol(x, C.STONE) end
			elseif trimNames[x.Name] then recol(x, TRIM)
			else recol(x, C.STONE) end
		elseif x:IsA("Model") and (x.Name == "K_Gothic" or x.Name == "K_Spire" or x.Name == "K_RTower7" or x.Name == "K_Arcade7") then
			for _, d in ipairs(x:GetDescendants()) do
				if d:IsA("BasePart") then
					local tok = d.Name:match("_(%a+)$")
					if tok == "stone" then recol(d, C.STONE)
					elseif tok == "dome" then recol(d, TRIM) end
				end
			end
		end
	end
	local S15 = root:FindFirstChild("Pass15") and root.Pass15:FindFirstChild("K_Skull15")
	for _, d in ipairs(S15 and S15:GetChildren() or {}) do
		local tok = d.Name:match("_(%a+)$")
		if tok == "bone" and C.SKULL then recol(d, C.SKULL) elseif tok == "pillar" and C.TOWER then recol(d, C.TOWER) end
	end
	-- lights, one at a time (L table: name -> {enabled, brightness})
	local function L(inst, cls, en, b) local l = inst and inst:FindFirstChildOfClass(cls); if l then lightSet(l, en, b) end end
	L(R:FindFirstChild("RaidBeam11"), "PointLight", true) -- s5 off: no change at the tower box (it was not this light), so left on
	-- pass-16 uplights (x 138, 24 in front of the facade, aimed at y 58: they flood whole faces) -> grazing: at the facade foot,
	-- 3 in front of the face, aimed almost straight up so the light skims the pilasters and arch rims
	local UP = { z = { -22, -9, 9, 22 }, x = 147, aimX = 157, aimY = 32, angle = 35, range = 32, b = 9, col = Color3.fromRGB(255, 195, 150) } -- s9 b4: no visible change; s10 b12 (255,60,50): rim (212,24,36); s11 (255,120,100): (211,43,51) -- s8 x154 aim (159,40) b3: rim (43,17,30), grazing too flat to show
	local P16 = root:FindFirstChild("Pass16")
	local ups = {}
	for _, u in ipairs(P16 and P16:GetChildren() or {}) do if u.Name == "RaidUplight16" then table.insert(ups, u) end end
	table.sort(ups, function(a, b) return a.Position.Z < b.Position.Z end)
	for i, u in ipairs(ups) do
		local z = UP.z[i]; if not z then break end
		local base = Vector3.new(UP.x, groundY(UP.x, z, 30) + 0.8, z)
		u.CFrame = CFrame.lookAt(base, Vector3.new(UP.aimX, UP.aimY, z)) * CFrame.Angles(-math.pi / 2, 0, 0)
		local s = u:FindFirstChildOfClass("SpotLight")
		if s then lightSet(s, true, UP.b); s.Angle = UP.angle; s.Range = UP.range; if UP.col then s.Color = UP.col end end
	end
	local sm12 = root:FindFirstChild("Pass12") and root.Pass12:FindFirstChild("RaidSmoke12")
	local l12 = sm12 and sm12:FindFirstChildWhichIsA("PointLight", true)
	if l12 then lightSet(l12, true, 0.1) end -- the tower light (150,86,0) r30, was 0.6; s6 0.3 -> tower (141,76,71)
	-- fill on the shaded spire/wall faces either side of the door (stoneB box), so the shade side reads dark red, not black
	for _, z in ipairs({ -16, 16 }) do
		local f = ghost(part("RaidFill17", Vector3.new(0.5, 0.5, 0.5), CFrame.new(150, 22, z), rgb(0, 0, 0)))
		local pl = Instance.new("PointLight"); pl.Color = rgb(255, 210, 220); pl.Range = 14; pl.Brightness = 1.5; pl.Shadows = false; pl.Parent = f -- s13 (255,120,110): stoneB (85,16,25)
	end
	-- haze band (pass-16 RaidHaze16 emitter): colour solved from the target over the sky, C = (T - (1-a) S) / a
	local HZ = { col = rgb(200, 86, 72), rate = 34, emit = 200, box = { Vector3.new(24, 84, 124), CFrame.new(186, 54, 0) } } -- s20 box 24x52x104 at y68: a round blob over the tower; now down to the stair top (y 12) and wider -- s18 (205,95,80): (213,75,53)/(208,80,63); s16 (212,58,42) rate 10: L flickers to sky (153,125,158); s17 rate 20: (219,26,8) (post grading saturates) -- s15 (225,40,20): core (221,17,2), thin (206,72,75)
	local hz = P16 and P16:FindFirstChild("RaidHaze16")
	local band = hz and hz:FindFirstChild("Band")
	if hz and HZ.box then hz.Size = HZ.box[1]; hz.CFrame = HZ.box[2] end
	if band then
		band.Enabled = true; band.Color = ColorSequence.new(HZ.col)
		if HZ.t then band.Transparency = HZ.t end
		if HZ.rate then band.Rate = HZ.rate end
		if HZ.size then band.Size = HZ.size end
		band:Clear(); pcall(function() band:Emit(HZ.emit or 60) end)
	end
	-- the upright red palm (pass-16 RaidPalm16, 23 tall at (144,-20)): in the reference p3 its crown rises above the "Raid" sign,
	-- left of the door and in front of the facade: scale 1.7 (about 39 tall) and step it forward and left
	local palm = P16 and P16:FindFirstChild("RaidPalm16")
	if palm then
		if palm:GetAttribute("P17CF0") == nil then palm:SetAttribute("P17CF0", palm:GetPivot()); palm:SetAttribute("P17Sc0", palm:GetScale()) end
		local PALM = { x = 139, z = -27, k = 1.7 }
		palm:ScaleTo(palm:GetAttribute("P17Sc0") * PALM.k)
		local cf0 = palm:GetAttribute("P17CF0")
		palm:PivotTo(CFrame.new(PALM.x, cf0.Position.Y, PALM.z) * (cf0 - cf0.Position))
		local _, sz = palm:GetBoundingBox(); local cfb = palm:GetBoundingBox()
		local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P17, palm }
		local hit = workspace:Raycast(Vector3.new(PALM.x, 40, PALM.z), Vector3.new(0, -80, 0), rp)
		local gy = hit and hit.Position.Y or 8
		palm:PivotTo(palm:GetPivot() + Vector3.new(0, gy - (cfb.Position.Y - sz.Y / 2), 0))
	end
	-- 3 recessed arch bands round the door: the pass-16 pointed arch (legs z +-6.6 from y 8.6 to 18, arcs of radius 10.14 centred
	-- 3.54 past the axis) offset outward by d; alternate proud lit stone and dark recess so the uplights pick out the rims
	local BANDS = { { d = 1.3, x = 156.9, col = rgb(40, 16, 22), w = 0.9 }, { d = 2.4, x = 156.4, col = rgb(105, 52, 60), w = 0.8 },
		{ d = 3.5, x = 156.9, col = rgb(40, 16, 22), w = 0.9 }, { d = 4.6, x = 156.3, col = rgb(105, 52, 60), w = 0.8 } }
	for _, B in ipairs(BANDS) do
		local pts = {}
		local hz0 = 6.6 + B.d
		for i = 0, 3 do table.insert(pts, Vector3.new(B.x, 8.6 + i * 3.13, -hz0)) end
		local r = 10.14 + B.d
		-- arc centred at z = +3.54, from angle 180 (z = 3.54 - r = -hz0) up to the apex where z = 0
		local thEnd = math.deg(math.acos(-3.54 / r))
		for i = 1, 9 do
			local th = math.rad(180 - (180 - thEnd) * i / 9)
			table.insert(pts, Vector3.new(B.x, 18 + r * math.sin(th), 3.54 + r * math.cos(th)))
		end
		local n = #pts
		for i = n - 1, 1, -1 do local p = pts[i]; table.insert(pts, Vector3.new(p.X, p.Y, -p.Z)) end
		for i = 1, #pts - 1 do
			local a, b = pts[i], pts[i + 1]
			local dir = (b - a).Unit; local nrm = Vector3.xAxis:Cross(dir)
			local s = part("RaidArchBand17", Vector3.new(0.7, B.w, (b - a).Magnitude + 0.25), CFrame.fromMatrix((a + b) / 2, Vector3.xAxis, nrm), B.col, Enum.Material.Slate)
			s.CanCollide = false
		end
	end
	table.insert(report, "raid ok")
end
--ENDRAID

-- ================================================================ item 3: Summon avenue (clear the axis, colonnade facade, statue, bunting, pineapple)
--SUMMON
do
	-- (a) clear the clumps on the avenue axis (|x| < 20, z -55..-185): canopy/horizon clumps only; palms and cypresses stay
	local nh = 0
	for _, fld in ipairs({ root.Pass13:FindFirstChild("Trees13"), root.Pass14:FindFirstChild("HorizonRing14") }) do
		for _, m in ipairs(fld and fld:GetChildren() or {}) do
			if m:IsA("Model") and (m.Name == "K_Soft15K" or m.Name == "K_Soft15W") then
				local p = m:GetBoundingBox().Position
				if math.abs(p.X) < 20 and p.Z < -55 and p.Z > -185 then hide(m); nh += 1 end
			end
		end
	end
	-- (b) 5-arch colonnade facade in front of the Summon hall: 44 wide, 2 storeys (arcade 13, windows), cornice, attic, dome
	local CREAM, DARK, GOLD = rgb(235, 210, 150), rgb(70, 52, 45), rgb(215, 170, 55)
	local Z0, W = -177.5, 44
	local gy = groundY(0, Z0, 60)
	local F = Instance.new("Folder"); F.Name = "Colonnade17"; F.Parent = P17
	local function c(name, sz, cf, col, mat) return part(name, sz, cf, col, mat or SM, F) end
	c("Back", Vector3.new(W, 26, 2), CFrame.new(0, gy + 13, Z0 - 1.6), CREAM)
	c("Plinth", Vector3.new(W + 2, 1.2, 4), CFrame.new(0, gy + 0.6, Z0), CREAM)
	local bw = W / 5
	for i = 0, 4 do
		local x = -W / 2 + bw * (i + 0.5)
		c("Opening", Vector3.new(bw - 2.6, 8.5, 0.3), CFrame.new(x, gy + 1.2 + 4.25, Z0 - 0.5), DARK)
		local hd = c("OpeningHead", Vector3.new(0.3, bw - 2.6, bw - 2.6), CFrame.new(x, gy + 9.7, Z0 - 0.5) * CFrame.Angles(0, math.pi / 2, 0), DARK)
		hd.Shape = Enum.PartType.Cylinder
		c("Window", Vector3.new(2.6, 3.2, 0.3), CFrame.new(x, gy + 17.0, Z0 - 0.5), DARK)
		local wh = c("WindowHead", Vector3.new(0.3, 2.6, 2.6), CFrame.new(x, gy + 18.6, Z0 - 0.5) * CFrame.Angles(0, math.pi / 2, 0), DARK)
		wh.Shape = Enum.PartType.Cylinder
		c("Key", Vector3.new(0.9, 1.2, 0.5), CFrame.new(x, gy + 13.3, Z0 - 0.2), GOLD, Enum.Material.Metal)
	end
	for i = 0, 5 do
		local x = -W / 2 + bw * i
		c("Pier", Vector3.new(1.8, 13.4, 1.6), CFrame.new(x, gy + 1.2 + 6.7, Z0 - 0.1), CREAM)
		c("Capital", Vector3.new(2.3, 0.6, 2.0), CFrame.new(x, gy + 14.3, Z0 - 0.1), GOLD, Enum.Material.Metal)
		c("Pilaster", Vector3.new(1.2, 6.6, 1.0), CFrame.new(x, gy + 18.0, Z0 - 0.2), CREAM)
	end
	c("Cornice", Vector3.new(W + 1.6, 0.9, 2.6), CFrame.new(0, gy + 14.9, Z0 - 0.2), CREAM)
	c("CorniceGold", Vector3.new(W + 1.7, 0.3, 2.7), CFrame.new(0, gy + 15.4, Z0 - 0.2), GOLD, Enum.Material.Metal)
	c("Entablature", Vector3.new(W + 1.6, 1.4, 2.8), CFrame.new(0, gy + 21.9, Z0 - 0.3), CREAM)
	c("EntGold", Vector3.new(W + 1.7, 0.3, 2.9), CFrame.new(0, gy + 22.7, Z0 - 0.3), GOLD, Enum.Material.Metal)
	c("Attic", Vector3.new(14, 3.0, 2.6), CFrame.new(0, gy + 24.3, Z0 - 0.8), CREAM)
	local drum = c("Drum", Vector3.new(5, 10, 10), CFrame.new(0, gy + 27.5, Z0 - 4) * CFrame.Angles(0, 0, math.pi / 2), CREAM); drum.Shape = Enum.PartType.Cylinder
	local dome = c("Dome", Vector3.new(10, 10, 10), CFrame.new(0, gy + 30, Z0 - 4), CREAM); dome.Shape = Enum.PartType.Ball
	c("DomeBand", Vector3.new(0.4, 10.4, 10.4), CFrame.new(0, gy + 30, Z0 - 4) * CFrame.Angles(0, 0, math.pi / 2), GOLD, Enum.Material.Metal).Shape = Enum.PartType.Cylinder
	local fin = c("Finial", Vector3.new(1.2, 1.2, 1.2), CFrame.new(0, gy + 35.6, Z0 - 4), GOLD, Enum.Material.Metal); fin.Shape = Enum.PartType.Ball
	c("FinialSpike", Vector3.new(0.4, 2.2, 0.4), CFrame.new(0, gy + 37, Z0 - 4), GOLD, Enum.Material.Metal)
	-- gold statue in the middle arch (robed figure on a plinth, raised arm, staff)
	local sx, sz0 = 0, Z0 + 0.6
	c("StatuePlinth", Vector3.new(3, 1.4, 3), CFrame.new(sx, gy + 1.9, sz0), CREAM)
	local robe = c("StatueRobe", Vector3.new(4.6, 2.4, 2.4), CFrame.new(sx, gy + 4.9, sz0) * CFrame.Angles(0, 0, math.pi / 2), GOLD, Enum.Material.Metal); robe.Shape = Enum.PartType.Cylinder
	c("StatueBody", Vector3.new(1.8, 2.4, 1.2), CFrame.new(sx, gy + 8.0, sz0), GOLD, Enum.Material.Metal)
	local head = c("StatueHead", Vector3.new(1.3, 1.3, 1.3), CFrame.new(sx, gy + 9.9, sz0), GOLD, Enum.Material.Metal); head.Shape = Enum.PartType.Ball
	c("StatueArm", Vector3.new(0.5, 3.0, 0.5), CFrame.new(sx + 1.3, gy + 10.0, sz0) * CFrame.Angles(0, 0, math.rad(-25)), GOLD, Enum.Material.Metal)
	c("StatueStaff", Vector3.new(0.25, 5.5, 0.25), CFrame.new(sx - 1.2, gy + 8.0, sz0 + 0.3), GOLD, Enum.Material.Metal)
	for _, q in ipairs(F:GetDescendants()) do if q:IsA("BasePart") then q.CanCollide = false end end
	-- the sign: over the middle arch, in front of the upper storey
	local txt = root.Pass11.Summon11:FindFirstChild("K_TxtSummon9")
	if txt then
		if txt:GetAttribute("P17CF0") == nil then txt:SetAttribute("P17CF0", txt:GetPivot()); txt:SetAttribute("P17Sc0", txt:GetScale()) end
		local cf0 = txt:GetAttribute("P17CF0")
		txt:ScaleTo(txt:GetAttribute("P17Sc0") * 0.7)
		txt:PivotTo(CFrame.new(0, gy + 18.8, Z0 + 1.2) * (cf0 - cf0.Position))
	end
	-- (c) bunting: 3 lines of pennants across the avenue between the stall rows
	local PEN = { rgb(230, 70, 70), rgb(250, 250, 245), rgb(60, 110, 220), rgb(240, 200, 60) }
	for li, z in ipairs({ -72, -98, -124 }) do -- t1 -84/-112/-140: the far line crossed the sign in c4
		local y0 = groundY(0, z, 60) + 12
		local n = 22
		for i = 0, n - 1 do
			local t = (i + 0.5) / n
			local x = -15 + 30 * t
			local y = y0 - 1.6 * (1 - (2 * t - 1) ^ 2)
			local w = part("Pennant17", Vector3.new(0.1, 1.2, 1.1), CFrame.new(x, y - 0.6, z) * CFrame.Angles(0, math.pi / 2, math.pi), PEN[(i + li) % 4 + 1], SM)
			w.CanCollide = false
			local wd = Instance.new("SpecialMesh"); wd.MeshType = Enum.MeshType.Wedge; wd.Parent = w
		end
		local cord = part("Cord17", Vector3.new(30, 0.08, 0.08), CFrame.new(0, y0 - 0.8, z), rgb(90, 80, 70)); cord.CanCollide = false
	end
	-- (d) gold pineapple, about 8 tall, by the W pavilion at the N stair top (c4 left)
	do
		local px, pz = -24, -52
		local py = groundY(px, pz, 40)
		local body = part("Pineapple17", Vector3.new(4.6, 5.4, 4.6), CFrame.new(px, py + 2.8, pz), rgb(220, 170, 50), Enum.Material.Metal)
		local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = body
		for k = 1, 3 do
			local d = 4.7 - math.abs(k - 2) * 0.6
			local r = part("PineRing17", Vector3.new(0.25, d, d), CFrame.new(px, py + 1.4 + k * 1.15, pz) * CFrame.Angles(0, 0, math.pi / 2), rgb(165, 120, 30), Enum.Material.Metal)
			r.Shape = Enum.PartType.Cylinder
		end
		for k = 0, 6 do
			local a = k * math.pi * 2 / 7
			local lf = part("PineLeaf17", Vector3.new(0.3, 3.2, 0.9), CFrame.new(px, py + 5.6, pz) * CFrame.Angles(0, a, 0) * CFrame.new(0, 0, 0.5) * CFrame.Angles(math.rad(22), 0, 0) * CFrame.new(0, 1.4, 0), rgb(70, 150, 60), SM)
			lf.CanCollide = false
		end
	end
	table.insert(report, "summon ok (hid " .. nh .. ")")
end
--ENDSUMMON

-- ================================================================ item 4: E ground (gravel paths, red palms; leaf splats are kit r17)
--EAST
do
	local GRAV = rgb(110, 110, 105)
	local paths = { { Vector3.new(52, 0, -22), Vector3.new(128, 0, -42) }, { Vector3.new(52, 0, 22), Vector3.new(128, 0, 44) }, { Vector3.new(70, 0, -60), Vector3.new(120, 0, -18) } }
	for _, pth in ipairs(paths) do
		local a, b = pth[1], pth[2]
		local n = 10
		for i = 0, n - 1 do
			local p0 = a:Lerp(b, i / n); local p1 = a:Lerp(b, (i + 1) / n); local mid = (p0 + p1) / 2
			local wob = math.sin(i * 1.7) * 1.2
			local y = groundY(mid.X, mid.Z + wob, 40)
			local q = part("Gravel17", Vector3.new(4.2 + 0.6 * math.sin(i * 2.3), 0.14, (p1 - p0).Magnitude + 1.2), CFrame.lookAt(Vector3.new(mid.X, y + 0.08, mid.Z + wob), Vector3.new(p1.X, y + 0.08, p1.Z + wob)), GRAV, Enum.Material.Pebble)
			q.CanCollide = false
		end
	end
	local function palm(name, x, z, k, yaw)
		local lo = Vector3.new(math.huge, math.huge, math.huge)
		for _, kp in ipairs(kit:GetChildren()) do if kp.Name:sub(1, #name + 1) == name .. "_" then lo = lo:Min(kp.Position - kp.Size / 2) end end
		local cf = CFrame.new(x, groundY(x, z, 60) - lo.Y * k, z) * CFrame.Angles(0, yaw, 0)
		local m = Instance.new("Model"); m.Name = "RedPalm17"
		for _, kp in ipairs(kit:GetChildren()) do
			if kp.Name:sub(1, #name + 1) == name .. "_" then
				local cl = kp:Clone(); cl.Size = kp.Size * k; cl.CFrame = cf * CFrame.new(kp.Position * k) * (kp.CFrame - kp.CFrame.Position)
				cl.Anchored = true; cl.CanCollide = false; cl.Material = SM
				local tok = kp.Name:match("_(%a+)$")
				if tok == "wood" then cl.Color = rgb(70, 30, 30) elseif tok == "leafRim" then cl.Color = rgb(130, 30, 35) else cl.Color = rgb(110, 25, 30) end
				cl.Parent = m
			end
		end
		m.Parent = P17
	end
	if kit:FindFirstChild("K_Palm6A_wood") then
		palm("K_Palm6A", 92, -48, 1.2, 0.6); palm("K_Palm6B", 104, 30, 1.3, 2.1); palm("K_Palm6A", 76, 54, 1.1, 4.0); palm("K_Palm6B", 120, -60, 1.4, 5.2) -- (116,-8) stood in front of the Raid door in p3
	end
	table.insert(report, "east ok")
end
--ENDEAST

-- ================================================================ kit-dependent (r17): hero without the outward wings, scroll
-- flanks, E-ground leaf splats. Skipped until ae_kit_r17 has been imported and merged into Kit.
--KIT17
if kit and kit:FindFirstChild("K_Flank17_slate") then
	-- (a) hero: K_Hero_stone/gold -> K_Hero17_stone/gold (same mesh minus the 8 pale shoulder-wing ramps). Props copied.
	local H = root.K_Hero
	for _, tok in ipairs({ "stone", "gold" }) do
		local old = H:FindFirstChild("K_Hero_" .. tok)
		local k = kit:FindFirstChild("K_Hero17_" .. tok)
		if old and k then
			local cc = old:GetAttribute("P17CC"); if cc == nil then cc = old.CanCollide; old:SetAttribute("P17CC", cc) end
			local n = k:Clone(); n.Name = "K_Hero17_" .. tok; n.Anchored = true
			n.Color = old.Color; n.Material = old.Material; n.Reflectance = old.Reflectance; n.CastShadow = old.CastShadow
			n.CanCollide = cc
			for _, c in ipairs(old:GetChildren()) do c:Clone().Parent = n end
			n.Parent = P17
			hide(old)
		end
	end
	-- (b) scroll flanks continuing the arch legs down to the plaza: dark slate, recessed bands, gold top rim
	local FL = { slate = { rgb(50, 52, 54), Enum.Material.Slate } --[[ c1 t2 (40,46,48): side (41,54,57) ]], groove = { rgb(22, 26, 28), Enum.Material.Slate },
		gold = { rgb(116, 124, 128), SM } } -- c1 t3 (150,156,160): top (224,230,228), reference top (170,183,188); c1 t1: the gold top slab (2.7 wide) read as a gold ramp; the reference top is pale stone with gold edges
	for tok, st in pairs(FL) do
		local k = kit:FindFirstChild("K_Flank17_" .. tok)
		if k then
			local n = k:Clone(); n.Anchored = true; n.Color = st[1]; n.Material = st[2]; n.CanCollide = (tok == "slate"); n.Parent = P17
		end
	end
	-- gold edge lines along both top edges of every flank (the kit's top profile: y = 2 + 6 t^1.7, t = (w - 25) / 8.3)
	do
		local R2 = math.sqrt(2)
		local function Pq(u, y, w, mx, mz) return Vector3.new((w + u) / R2 * mx, y, (u - w) / R2 * mz) end
		local function top(w) local t = math.clamp((w - 25) / 8.3, 0, 1); return 2 + 6 * t ^ 1.7 end
		local GE = Instance.new("Folder"); GE.Name = "FlankGold17"; GE.Parent = P17
		for _, mx in ipairs({ 1, -1 }) do for _, mz in ipairs({ 1, -1 }) do for _, s in ipairs({ 1, -1 }) do
			for _, u in ipairs({ s * 7.45, s * 10.15 }) do
				for i = 0, 11 do
					local w0, w1 = 25 + 8.3 * i / 12, 25 + 8.3 * (i + 1) / 12
					local a, b = Pq(u, top(w0) + 0.3, w0, mx, mz), Pq(u, top(w1) + 0.3, w1, mx, mz)
					local q = part("FlankEdge17", Vector3.new(0.32, 0.32, (b - a).Magnitude + 0.1), CFrame.lookAt((a + b) / 2, b), rgb(215, 170, 55), Enum.Material.Metal, GE)
					q.CanCollide = false
				end
			end
		end end end
	end
	-- (c) E ground: the pass-12 red dot litter goes; ragged leaf splats (4.6 across, x0.8-1.3) on a 4-stud jittered grid,
	-- cover 30% by the plaza (x 50) rising to 60% by the Raid (x 135); holes stay green/grey
	local L12 = root.Pass12:FindFirstChild("Litter12")
	for _, f in ipairs(L12 and L12:GetChildren() or {}) do if f.Name == "Red" then hide(f) end end
	local SPL = Instance.new("Folder"); SPL.Name = "Splats17"; SPL.Parent = P17
	local core, rim = kit:FindFirstChild("K_Splat17_core"), kit:FindFirstChild("K_Splat17_rim")
	local rng = Random.new(1717)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P17 }
	local ns = 0
	if core and rim then
		for x = 50, 138, 4 do
			for z = -88, 88, 4 do
				local cover = 0.30 + 0.30 * math.clamp((x - 50) / 85, 0, 1)
				if rng:NextNumber() < cover then
					local px, pz = x + rng:NextNumber(-1.5, 1.5), z + rng:NextNumber(-1.5, 1.5)
					local r = workspace:Raycast(Vector3.new(px, 40, pz), Vector3.new(0, -80, 0), rp)
					local okHit = r and r.Normal.Y > 0.9 and r.Position.Y < 12 and r.Instance.Material ~= Enum.Material.Glass
						and not r.Instance:IsDescendantOf(root.K_Stairs) and not r.Instance:IsDescendantOf(root.K_Hero)
					if okHit then
						local s = rng:NextNumber(0.8, 1.3)
						local cf = CFrame.new(px, r.Position.Y + 0.04, pz) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0)
						for _, kp in ipairs({ core, rim }) do
							local c = kp:Clone(); c.Size = kp.Size * s; c.CFrame = cf * CFrame.new(0, (kp.Position.Y) * s, 0) * (kp.CFrame - kp.CFrame.Position)
							c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CanTouch = false; c.CastShadow = false
							c.Material = SM; c.Color = (kp == core) and rgb(187, 53, 54) or rgb(130, 30, 35)
							c.Parent = SPL
						end
						ns += 1
					end
				end
			end
		end
	end
	table.insert(report, "kit17 ok (splats " .. ns .. ")")
else
	table.insert(report, "kit17 skipped (no r17 kit)")
end
--ENDKIT17

return table.concat(report, "; ")
end
