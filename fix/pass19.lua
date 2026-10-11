-- pass19.lua (practice place only): freestyle pass 19 on top of the pass-18 build (notes/fix_brief19.md, verify16_plaza.md).
-- Run AFTER pass 18. Idempotent: new pieces live in Plaza.Pass19 (rebuilt each run); hidden old pieces get P19Hidden (old
-- transparency in P19T); recoloured old pieces keep their pre-pass-19 colour/material in P19Col / P19Mat; changed lights keep
-- P19Light (colour/brightness/range as a string); scaled models keep P19CF0 / P19Sc0.
-- Blocks: --TUNNEL, --RAID19, --EAST19, --TREES19, --SPLAT19, --KIT19 (arch, needs ae_kit_r19).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r19 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r19")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale19_stone", true)
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
local old = root:FindFirstChild("Pass19"); if old then old:Destroy() end
local P19 = Instance.new("Folder"); P19.Name = "Pass19"; P19.Parent = root
local P18, P17, P16, P9 = root:FindFirstChild("Pass18"), root:FindFirstChild("Pass17"), root:FindFirstChild("Pass16"), root:FindFirstChild("Pass9")
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P19
	return p
end
local function ghost(p) p.Transparency = 1; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false; return p end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P19T") == nil then d:SetAttribute("P19T", d.Transparency); d:SetAttribute("P19CC", d.CanCollide); d:SetAttribute("P19CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P19Hidden", true)
		end
	end
end
local function unhideAll()
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and d:GetAttribute("P19Hidden") then
			d.Transparency = d:GetAttribute("P19T"); d:SetAttribute("P19Hidden", nil)
			if d:GetAttribute("P19CC") ~= nil then d.CanCollide = d:GetAttribute("P19CC"); d.CanQuery = d:GetAttribute("P19CQ") end
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P19Col") == nil then p:SetAttribute("P19Col", p.Color); p:SetAttribute("P19Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function scaleModel(m, k, pivot)
	if m:GetAttribute("P19CF0") == nil then m:SetAttribute("P19CF0", m:GetPivot()); m:SetAttribute("P19Sc0", m:GetScale()) end
	m:ScaleTo(m:GetAttribute("P19Sc0")); m:PivotTo(m:GetAttribute("P19CF0"))
	if k == 1 then return end
	-- scale about 'pivot' (world point): position offset from pivot shrinks with the model
	local cf0 = m:GetPivot()
	m:ScaleTo(m:GetAttribute("P19Sc0") * k)
	local off = cf0.Position - pivot
	m:PivotTo(CFrame.new(pivot + off * k) * (cf0 - cf0.Position))
end
local function groundY(x, z, top, excl)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = excl or { P19 }
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -240, 0), rp)
	return r and r.Position.Y or 0
end
unhideAll()
local report = {}

-- ================================================================ item 2: lit arch interiors (target p5 (718-722, 398-402)
-- (169,232,244), p1 (318-322, 438-442) (115,173,192)). The vault mesh (niche back ~4 behind the fountain, crest window, shelf
-- back) goes light grey; the vault PointLights go cyan; the water sheet glows.
--TUNNEL
do
	local T = { vault = rgb(120, 130, 140), lcol = rgb(120, 220, 255), lb = 2, lr = 12, low = true, lowB = 1.5, --[[ s2 2.5 did not move these boxes (reverted); s1 1.5: p1 (198-202,428-432) (49,65,99), p5 (648-652,418-422) (52,69,104) ]]
		sheet = rgb(150, 225, 240), sheetMat = SM, sheetT = 0.15 } -- s1 sheet Neon: p5 interior box (252,255,255) blown out
	local hv = root.K_Hero:FindFirstChild("K_Hero_vault")
	if hv and T.vault then recol(hv, T.vault, SM) end
	for _, v in ipairs(root:GetChildren()) do
		if v.Name == "VaultLight" then
			local l = v:FindFirstChildOfClass("PointLight")
			if l then
				if l:GetAttribute("P19Light") == nil then l:SetAttribute("P19Light", string.format("%s|%g|%g", tostring(l.Color), l.Brightness, l.Range)) end
				l.Color = T.lcol; l.Brightness = T.lb; l.Range = T.lr
			end
			if T.low then
				-- a second, lower cyan light just in front of the niche back (P(0, 3, 38.5)), so the lower tunnel walls are lit too
				local p = v.Position; local dir = Vector3.new(p.X, 0, p.Z).Unit
				local g = ghost(part("TunnelLight19", Vector3.new(0.4, 0.4, 0.4), CFrame.new(dir * 38.5 + Vector3.new(0, 3, 0)), rgb(0, 0, 0)))
				local l2 = Instance.new("PointLight"); l2.Color = T.lcol; l2.Brightness = T.lowB; l2.Range = 10; l2.Shadows = false; l2.Parent = g
			end
		end
	end
	for _, s in ipairs(P9 and P9:GetChildren() or {}) do
		if s.Name == "WaterSheet" and T.sheet then recol(s, T.sheet, T.sheetMat); s.Transparency = T.sheetT end
	end
	table.insert(report, "tunnel ok")
end
--ENDTUNNEL

-- ================================================================ item 3: Raid haze as red glow (p3 (643-647,173-177) (178,77,76);
-- c3 (1348-1352,278-282) (153,52,57)); red PointLights at door height; a 2-stud ember band along the facade foot.
-- The eight pass-18 boxes (out/r18w/box.py p3, targets from v15) must stay within 15.
--RAID19
do
	-- t1 haze (190,70,65) T 0.15/0.25 + 4 lights b3 r20 at door height (x150, y+9): hazeL/R (196,36,32)/(203,38,32) (target ~(150,78,70)),
	-- lowL (650,330) 234 red (target 125): the lower facade was already at the target, so the door-height lights are dropped and the
	-- haze is back at the pass-18 values; the red goes onto the upper towers instead (p3 box 643-647,173-177 is RaidPinnacle at
	-- (166,73,-25), c3 box 1348-1352,278-282 is RaidGable at (168,66,13), picked by ray)
	local R = { haze = rgb(150, 100, 95), -- s5 (165,85,82): c3 unchanged (147,80,76), p3 hazeL/R off by 25: reverted; pass-18 (150,100,95) gave c3 (147,80,77): haze particles sit in front of the gable
		 hazeT = { 0.22, 0.3 }, hazeRate = 44, lights = true, lb = { 3, 0 }, gable = rgb(95, 25, 35), -- s4 (one RaidGable): c3 (147,80,77); s3 right red b1.5: c3 (198,88,84): G is daylight on the (88,47,56) gable, not the light; light off, gable deeper
		 lr = 22, lcol = rgb(255, 130, 115), lcolR = rgb(255, 60, 50), -- s2 (255,130,115) right b1.5: p3 haze (174,62,74) ok, c3 haze (199,99,93)
		 -- s1 (255,60,50) b3 both: p3 haze (175,51,65), haze2 (157,45,58); c3 haze (229,90,85)
		
		lpos = { Vector3.new(156, 62, -24), Vector3.new(156, 62, 24) }, embers = true, emberCol = rgb(255, 80, 40) }
	local hz = P16 and P16:FindFirstChild("RaidHaze16"); local band = hz and hz:FindFirstChild("Band")
	if band and R.haze then
		band.Color = ColorSequence.new(R.haze); band.Rate = R.hazeRate
		band.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, R.hazeT[1]), NumberSequenceKeypoint.new(0.7, R.hazeT[2]), NumberSequenceKeypoint.new(1, 1) })
		band:Clear(); pcall(function() band:Emit(200) end)
	end
	local gyF = groundY(149, 0, 30)
	local ng = 0
	for _, gb in ipairs(root.Pass11.Raid11:GetChildren()) do
		if gb.Name == "RaidGable" and R.gable and gb:IsA("BasePart") then recol(gb, R.gable); ng += 1 end
	end
	table.insert(report, "gables " .. ng)
	if R.lights then
		for i, lp in ipairs(R.lpos) do
			local g = ghost(part("RaidRed19", Vector3.new(0.4, 0.4, 0.4), CFrame.new(lp), rgb(0, 0, 0)))
			local l = Instance.new("PointLight"); l.Color = (i == 2 and R.lcolR) or R.lcol; l.Brightness = R.lb[i]; l.Range = R.lr; l.Shadows = false; l.Parent = g
		end
	end
	if R.embers then
		-- ember/glow band: a wide low emitter strip (2 studs of glowing particles) along the whole facade foot
		local e0 = ghost(part("RaidEmbers19", Vector3.new(3, 0.4, 60), CFrame.new(148.5, gyF + 0.4, 0), rgb(0, 0, 0)))
		local e = Instance.new("ParticleEmitter"); e.Name = "Embers"; e.Shape = Enum.ParticleEmitterShape.Box
		e.Color = ColorSequence.new(R.emberCol, rgb(180, 20, 20)); e.LightEmission = 1; e.LightInfluence = 0
		e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 0.2) })
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
		e.Lifetime = NumberRange.new(0.8, 1.4); e.Speed = NumberRange.new(0.8, 1.6); e.Rate = 120
		e.EmissionDirection = Enum.NormalId.Top; e.SpreadAngle = Vector2.new(20, 20); e.Parent = e0
		local glow = part("RaidEmberGlow19", Vector3.new(1.6, 0.2, 58), CFrame.new(148.6, gyF + 0.12, 0), rgb(200, 45, 30), NE)
		glow.Transparency = 0.35; glow.CanCollide = false; glow.CanQuery = false; glow.CastShadow = false
	end
	table.insert(report, "raid19 ok")
end
--ENDRAID19

-- ================================================================ item 4: E ground (p8 region x 930-1300, y 150-650: practice red
-- 55% / green 1% by out/r19w/box19.py, reference 40% / 10%). Hide splat cards, most near the plaza; 18 grass holes 4-8 across
-- (118,167,50) with white flower dots.
--EAST19
do
	-- s1 pNear .55 / pFar .15, 18 holes 4-8, (105,160,45)/(125,178,58): red 48% green 3%, holes small lime dots
	local E = { pNear = 0.7, pFar = 0.3, xNear = 60, xFar = 120, holes = 24, dmin = 6, dmax = 11, spread = 2.2, hole = rgb(80, 125, 32), hole2 = rgb(95, 140, 38), flower = rgb(245, 245, 235) }
	local SPL = P17 and P17:FindFirstChild("Splats17")
	local rng = Random.new(1919)
	local n, h = 0, 0
	for _, c in ipairs(SPL and SPL:GetChildren() or {}) do
		if c:IsA("BasePart") and c.Name:find("core") and c.Transparency < 1 then
			n += 1
			local t = math.clamp((c.Position.X - E.xNear) / (E.xFar - E.xNear), 0, 1)
			if rng:NextNumber() < E.pNear + (E.pFar - E.pNear) * t then
				hide(c); h += 1
				-- its rim card is the nearest rim
				local best, bd = nil, 2
				for _, r in ipairs(SPL:GetChildren()) do
					if r:IsA("BasePart") and r.Name:find("rim") and (r.Position - c.Position).Magnitude < bd then best, bd = r, (r.Position - c.Position).Magnitude end
				end
				if best then hide(best) end
			end
		end
	end
	local F = Instance.new("Folder"); F.Name = "East19"; F.Parent = P19
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { P19, SPL, P18 }
	local nh = 0
	for i = 1, 60 do
		if nh >= E.holes then break end
		local px, pz = rng:NextNumber(55, 135), rng:NextNumber(-85, 85)
		local r = workspace:Raycast(Vector3.new(px, 40, pz), Vector3.new(0, -80, 0), rp)
		if r and r.Normal.Y > 0.9 and r.Position.Y < 12 and not r.Instance:IsDescendantOf(root.K_Stairs) and math.abs(pz) > 9 then
			nh += 1
			local d = rng:NextNumber(E.dmin, E.dmax)
			for k = 0, 2 do
				local q = part("GrassHole19", Vector3.new(0.12, d * (1 - k * 0.2), d * (0.8 + 0.2 * rng:NextNumber())), CFrame.new(px + rng:NextNumber(-E.spread, E.spread), r.Position.Y + 0.2 + k * 0.01, pz + rng:NextNumber(-E.spread, E.spread)) * CFrame.Angles(0, rng:NextNumber(0, 6.28), math.pi / 2), k == 0 and E.hole or E.hole2, SM, F)
				q.Shape = Enum.PartType.Cylinder; q.CanCollide = false; q.CanQuery = false; q.CastShadow = false
			end
			for f = 1, math.floor(d * 1.2) do
				local a, rr = rng:NextNumber(0, 6.28), rng:NextNumber(0, d * 0.4)
				local q = part("Flower19", Vector3.new(0.1, 0.45, 0.45), CFrame.new(px + rr * math.cos(a), r.Position.Y + 0.27, pz + rr * math.sin(a)) * CFrame.Angles(0, 0, math.pi / 2), E.flower, SM, F)
				q.Shape = Enum.PartType.Cylinder; q.CanCollide = false; q.CanQuery = false; q.CastShadow = false
			end
		end
	end
	table.insert(report, string.format("east19 ok (cores %d, hidden %d, holes %d)", n, h, nh))
end
--ENDEAST19

-- ================================================================ item 5: blue trees at about half size. The four corner basin trees
-- (K_Soft15C at (+-39, +-40)) and the W cluster (x < -55, |z| < 110) with their K_Soft15K leaf clumps (each clump follows the tree
-- listed before it in Trees13), scaled about the trunk foot. Two slim blue cypresses (~14) framing the N stair top.
--TREES19
do
	local TR = { corner = 0.5, west = 0.6, cyp = true, cypH = 14, cypCol = rgb(40, 75, 200), cypX = 19, cypZ = -50 }
	local T13 = root.Pass13.Trees13
	local cur, curK, foot = nil, 1, nil
	local ns = 0
	for _, m in ipairs(T13:GetChildren()) do
		if m:IsA("Model") then
			if m.Name ~= "K_Soft15K" then
				local cf, sz = m:GetBoundingBox(); local p = m:GetAttribute("P19CF0") and m:GetAttribute("P19CF0").Position or cf.Position
				local k = 1
				if math.abs(math.abs(p.X) - 39) < 3 and math.abs(math.abs(p.Z) - 40) < 3 and m.Name == "K_Soft15C" then k = TR.corner
				elseif p.X < -55 and p.X > -120 and math.abs(p.Z) < 110 then k = TR.west end
				cur = m; curK = k
				if m:GetAttribute("P19Foot") == nil then m:SetAttribute("P19Foot", Vector3.new(cf.X, cf.Y - sz.Y / 2, cf.Z)) end
				foot = m:GetAttribute("P19Foot")
				scaleModel(m, k, foot); if k ~= 1 then ns += 1 end
			elseif cur then
				scaleModel(m, curK, foot)
			end
		end
	end
	if TR.cyp then
		local src
		for _, m in ipairs(T13:GetChildren()) do if m.Name == "K_Soft15Y" then src = m; break end end
		if src then
			for _, s in ipairs({ -1, 1 }) do
				local c = src:Clone(); c.Name = "Cypress19"
				for _, a in ipairs({ "P19CF0", "P19Sc0", "P19Foot" }) do c:SetAttribute(a, nil) end
				local _, sz = c:GetBoundingBox(); c:ScaleTo(c:GetScale() * TR.cypH / sz.Y)
				local x, z = s * TR.cypX, TR.cypZ
				local gy = groundY(x, z, 40)
				local cf2, sz2 = c:GetBoundingBox()
				c:PivotTo(c:GetPivot() + (Vector3.new(x, gy, z) - Vector3.new(cf2.X, cf2.Y - sz2.Y / 2, cf2.Z)))
				for _, d in ipairs(c:GetDescendants()) do
					if d:IsA("BasePart") and (d.Name:find("out") or d.Name:find("in") or d.Name:find("leaf")) and not d.Name:find("wood") then d.Color = TR.cypCol end
				end
				c.Parent = P19
			end
		end
	end
	-- the big blue crystal pods at the N stair top (K_Pod8 at (+-22, -51)): practice-camera rays through the c4 reference pixels
	-- (255,365) / (230,330) hit them, and the reference has a low blue bush there; rays through the c1 reference pod pixels
	-- (610,150) / (895,215) do not hit any pod, so only these two go
	local np = 0
	for _, m in ipairs(P9:GetChildren()) do
		if m.Name == "K_Pod8" then
			local p = m:GetPivot().Position
			if p.Z < -45 and math.abs(math.abs(p.X) - 22) < 3 then hide(m); np += 1 end
		end
	end
	table.insert(report, "trees19 ok (scaled " .. ns .. ", pods hidden " .. np .. ")")
end
--ENDTREES19

-- ================================================================ item 7: c1 splat pair swapped and soft. The two star ferns in
-- the NE quadrant are hidden; soft K_Splat17 clumps (~4.5 across) take their place: blue on the N side (13,-24), red on the
-- E side (25,-13) (c1 ref (338-342, 668-672) (80,162,246) and (1118-1122, 628-632) (227,96,93)).
--SPLAT19
do
	local S = { blue = { rgb(70, 150, 240), rgb(120, 185, 250) }, red = { rgb(225, 90, 85), rgb(240, 135, 125) }, k = 1.0 }
	local core, rim = kit and kit:FindFirstChild("K_Splat17_core"), kit and kit:FindFirstChild("K_Splat17_rim")
	local spots = {}
	for _, f in ipairs(root.Planting:GetChildren()) do
		if f.Name == "K_Fern" then
			local p = f:GetPivot().Position
			if p.X > 0 and p.Z < 0 and p.X < 30 and p.Z > -30 and p.Y < 2 then
				hide(f); table.insert(spots, { p, (math.abs(p.X) < math.abs(p.Z)) and S.blue or S.red })
			end
		end
	end
	local rng = Random.new(1917)
	if core and rim then
		for _, sp in ipairs(spots) do
			local p, cols = sp[1], sp[2]
			local cf = CFrame.new(p.X, groundY(p.X, p.Z, 5) + 0.05, p.Z) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0)
			for i, kp in ipairs({ core, rim }) do
				local c = kp:Clone(); c.Size = kp.Size * S.k; c.CFrame = cf * CFrame.new(0, kp.Position.Y * S.k, 0) * (kp.CFrame - kp.CFrame.Position)
				c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CanTouch = false; c.CastShadow = false
				c.Material = SM; c.Color = cols[i]; c.Parent = P19
			end
		end
	end
	table.insert(report, "splat19 ok (" .. #spots .. ")")
end
--ENDSPLAT19

--KIT19
-- ================================================================ item 1: narrower, darker arch (kit r19). K_Hero17_stone/gold ->
-- K_Hero19 (same minus the old arch band, crest and their gold ribbons); the pass-18 sweep band is hidden; K_Arch19: pale front band
-- with the U-handle, dark-slate outer band (74,81,87) with one groove (25,39,51), thin gold rims.
if kit and kit:FindFirstChild("K_Arch19_stone") then
	local AR = { stone = nil --[[ nil = the hero stone colour ]], slate = { rgb(74, 81, 87), Enum.Material.Slate }, groove = { rgb(14, 20, 26), Enum.Material.Slate } } -- s1 (25,39,51): c1 leg groove (49,99,128), the cyan tunnel lights reach it
	for _, tok in ipairs({ "stone", "gold" }) do
		local old = P17:FindFirstChild("K_Hero17_" .. tok)
		local k = kit:FindFirstChild("K_Hero19_" .. tok)
		if old and k then
			local n = k:Clone(); n.Name = "K_Hero19_" .. tok; n.Anchored = true; n.CanQuery = (tok == "stone")
			n.Color = old.Color; n.Material = old.Material; n.Reflectance = old.Reflectance; n.CastShadow = old.CastShadow
			n.CanCollide = (tok == "stone")
			for _, c in ipairs(old:GetChildren()) do c:Clone().Parent = n end
			n.Parent = P19
			hide(old)
		end
	end
	for _, d in ipairs(P18:GetChildren()) do if d.Name:sub(1, 10) == "K_Sweep18_" then hide(d) end end
	local hs, hg = P17:FindFirstChild("K_Hero17_stone"), P17:FindFirstChild("K_Hero17_gold")
	for _, tok in ipairs({ "stone", "slate", "groove", "gold" }) do
		local k = kit:FindFirstChild("K_Arch19_" .. tok)
		if k then
			local n = k:Clone(); n.Anchored = true; n.CanCollide = (tok ~= "gold"); n.CanQuery = (tok ~= "gold") -- the gold tube hull blocks ray picks
			if tok == "stone" then n.Color = AR.stone or hs.Color; n.Material = hs.Material; n.Reflectance = hs.Reflectance
			elseif tok == "gold" then n.Color = hg.Color; n.Material = hg.Material; n.Reflectance = hg.Reflectance
			else n.Color = AR[tok][1]; n.Material = AR[tok][2] end
			n.Parent = P19
		end
	end
	table.insert(report, "kit19 ok")
else
	table.insert(report, "kit19 skipped (no r19 kit)")
end
--ENDKIT19

return table.concat(report, "; ")
end
