-- pass20.lua (practice place only): freestyle pass 20 on top of the pass-19 build (notes/fix_brief20.md, verify17_plaza.md).
-- Run AFTER pass 19. Idempotent: new pieces live in Plaza.Pass20 (rebuilt each run); hidden old pieces get P20Hidden (old
-- transparency / CanCollide / CanQuery in P20T / P20CC / P20CQ); recoloured old pieces keep their pre-pass-20 colour/material in
-- P20Col / P20Mat; changed lights keep P20Light; moved/scaled models keep P20CF0 / P20Sc0; changed emitters keep P20Em.
-- Blocks: --RAID20, --TUNNEL20, --STAIR20, --BOLL20, --SOUTH20, --KIT20 (needs ae_kit_r20).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE = Enum.Material.SmoothPlastic, Enum.Material.Neon
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- r20 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r20")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale20_stone", true)
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
local old = root:FindFirstChild("Pass20"); if old then old:Destroy() end
local P20 = Instance.new("Folder"); P20.Name = "Pass20"; P20.Parent = root
local P19, P18, P17, P16, P11, P9 = root:FindFirstChild("Pass19"), root:FindFirstChild("Pass18"), root:FindFirstChild("Pass17"), root:FindFirstChild("Pass16"), root:FindFirstChild("Pass11"), root:FindFirstChild("Pass9")
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P20
	return p
end
local function ghost(p) p.Transparency = 1; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false; return p end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P20T") == nil then d:SetAttribute("P20T", d.Transparency); d:SetAttribute("P20CC", d.CanCollide); d:SetAttribute("P20CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P20Hidden", true)
		end
		if d:IsA("Decal") or d:IsA("Texture") then
			if d:GetAttribute("P20T") == nil then d:SetAttribute("P20T", d.Transparency) end
			d.Transparency = 1; d:SetAttribute("P20Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P20Col") == nil then p:SetAttribute("P20Col", p.Color); p:SetAttribute("P20Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function setLight(l, col, b, r)
	if l:GetAttribute("P20Light") == nil then l:SetAttribute("P20Light", string.format("%s|%g|%g", tostring(l.Color), l.Brightness, l.Range)) end
	if col then l.Color = col end; if b then l.Brightness = b end; if r then l.Range = r end
end
local function moveModel(m, cf, k)
	if m:GetAttribute("P20CF0") == nil then m:SetAttribute("P20CF0", m:GetPivot()); m:SetAttribute("P20Sc0", m:IsA("Model") and m:GetScale() or 1) end
	if m:IsA("Model") then m:ScaleTo(m:GetAttribute("P20Sc0") * (k or 1)) end
	m:PivotTo(cf or m:GetAttribute("P20CF0"))
end
local function groundY(x, z, top, excl)
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = excl or { P20 }
	local r = workspace:Raycast(Vector3.new(x, top or 120, z), Vector3.new(0, -240, 0), rp)
	return r and r.Position.Y or 0
end
-- restore everything pass 20 touched, so every run starts from the pass-19 state
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P20Hidden") then
		d.Transparency = d:GetAttribute("P20T"); d:SetAttribute("P20Hidden", nil)
		if d:IsA("BasePart") and d:GetAttribute("P20CC") ~= nil then d.CanCollide = d:GetAttribute("P20CC"); d.CanQuery = d:GetAttribute("P20CQ") end
	end
	if d:GetAttribute("P20Col") ~= nil then d.Color = d:GetAttribute("P20Col"); d.Material = Enum.Material[d:GetAttribute("P20Mat")] end
	if d:GetAttribute("P20Light") ~= nil then
		local a = string.split(d:GetAttribute("P20Light"), "|"); local c = string.split(a[1], ",")
		d.Color = Color3.new(tonumber(c[1]), tonumber(c[2]), tonumber(c[3])); d.Brightness = tonumber(a[2]); d.Range = tonumber(a[3])
	end
	if d:GetAttribute("P20CF0") ~= nil then
		if d:IsA("Model") then d:ScaleTo(d:GetAttribute("P20Sc0")) end
		d:PivotTo(d:GetAttribute("P20CF0"))
	end
	if d:GetAttribute("P20Em") then d.Color = d:GetAttribute("P20EmCol"); d.Size = d:GetAttribute("P20EmSize"); d.Rate = d:GetAttribute("P20EmRate") end
	if d:GetAttribute("P20Size0") ~= nil then d.Size = d:GetAttribute("P20Size0"); d.CFrame = d:GetAttribute("P20CFp0") end
end
local function resize(p, size, cf)
	if p:GetAttribute("P20Size0") == nil then p:SetAttribute("P20Size0", p.Size); p:SetAttribute("P20CFp0", p.CFrame) end
	p.Size = size; if cf then p.CFrame = cf end
end
local report = {}

-- ================================================================ item 1: Raid lit on the building, not in the sky.
-- Targets (p3, re-sampled by out/r20w/box20.py): door frame box (693-697, 298-302) (181,108,114); side tower (848-852, 168-172)
-- (124,39,59); haze (643-647, 173-177) (162,66,74). The eight pass-18 boxes (out/r18w/box.py) stay within 15.
--RAID20
do
	local R = {
		-- s1 18x60x60 at y50: haze 14, but hazeL/R (pass-18) showed sky (89/160 off). s2 84 wide y 20-70: hazeL/R still sky (150/162): those boxes sit at (z -36, y 85) by the camera ray. s3 y 20-90 col (162,66,74): hazeL/R (164,45,64)/(178,37,52) 31/43 off, tower box (169,51,65) 45. s4 col (150,80,76): hazeL (144,81,93) 26 (sky B shows through), hazeR 7, tower (143,102,114) 63. s5 rate 60. Haze emitter box was 24x84x124 at (186,54,0) to a narrow column hugging skull and towers; particles smaller
		hazeBox = { Vector3.new(18, 70, 84), Vector3.new(182, 55, 0) }, hazeSize = { 10, 16 }, hazeCol = rgb(152, 90, 76), hazeRate = 60, -- s10 col (152,90,76): s9 gave hazeL (141,91,85) 18, hazeR 5, tower 47. s9 col (145,98,88): after the kit, hazeL/R read (160,54,48)/(159,61,58) 22/19, G low. s5: haze 14, hazeL 18, hazeR 14 (particle frame noise ~10), tower (149,80,83) 41
		door = nil, -- s6 two pink lights (255,150,150) b2 r10 at (151,31,+-6): door box (81,27,35)->(104,34,43) only (G is the dark
		-- base, as in pass 19), pass-18 rim box 10->61 off: dropped. The rim box (700,315) on RaidArchBand17 already matches its target.
		ember = { h = 2, col = rgb(200, 40, 30), t = 0.65 }, -- s7 t 0.4: a hard solid red bar (235,16,11); s8 t 0.65, top band 0.88. Standing 2-stud glow band at the facade foot (was a flat 0.2 strip)
	}
	local hz = P16 and P16:FindFirstChild("RaidHaze16"); local band = hz and hz:FindFirstChild("Band")
	if hz and band and R.hazeBox then
		if band:GetAttribute("P20Em") == nil then
			band:SetAttribute("P20Em", true); band:SetAttribute("P20EmCol", band.Color); band:SetAttribute("P20EmSize", band.Size); band:SetAttribute("P20EmRate", band.Rate)
		end
		resize(hz, R.hazeBox[1], CFrame.new(R.hazeBox[2]))
		band.Color = ColorSequence.new(R.hazeCol); band.Rate = R.hazeRate
		band.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, R.hazeSize[1]), NumberSequenceKeypoint.new(1, R.hazeSize[2]) })
		band:Clear(); pcall(function() band:Emit(200) end)
	end
	-- door frame light: a pink light just in front of the frame above the door (p3 box 693-697/298-302 hits K_Gothic_stone at
	-- (156.7, 32.5, -9.1)); range kept under the 15 studs to the lowL/lowR boxes (K_Spire (157.7,23.8,-22.5), Gothic (156.2,20.7,10))
	if R.door then
		for _, z in ipairs(R.door.z) do
			local g = ghost(part("RaidDoorFrame20", Vector3.new(0.4, 0.4, 0.4), CFrame.new(R.door.x, R.door.y, z), rgb(0, 0, 0)))
			local l = Instance.new("PointLight"); l.Color = R.door.col; l.Brightness = R.door.b; l.Range = R.door.r; l.Shadows = false; l.Parent = g
		end
	end
	if R.ember then
		local gyF = groundY(149, 0, 30, { P20, P19 })
		local e = part("RaidEmberWall20", Vector3.new(0.3, R.ember.h, 58), CFrame.new(149.2, gyF + R.ember.h / 2, 0), R.ember.col, NE)
		e.Transparency = R.ember.t; e.CanCollide = false; e.CanQuery = false; e.CastShadow = false
		local gr = Instance.new("Texture") -- none: plain neon; a vertical gradient comes from a second, fainter band on top
		gr:Destroy()
		local e2 = part("RaidEmberWall20b", Vector3.new(0.3, R.ember.h, 58), CFrame.new(149.0, gyF + R.ember.h * 1.5, 0), R.ember.col, NE)
		e2.Transparency = 0.88; e2.CanCollide = false; e2.CanQuery = false; e2.CastShadow = false
	end
	table.insert(report, "raid20 ok")
end
--ENDRAID20

-- ================================================================ item 2 (Studio half): dark tunnel, only the water bright.
-- c1 targets: interior (878-882, 468-472) (44,54,61) measured at the practice tunnel wall (538-542, 438-442) = K_Hero19_stone at
-- (19,4.5,-26); (598-602, 398-402) (30,52,72); water (718-722, 428-432) (196,248,254) = K_Hero_sheet. The tunnel wall is the hero
-- stone itself, lit cyan by the pass-19 lights, so the lights come down first.
--TUNNEL20
do
	local T = { vb = 1, vr = 8, lowB = 0, -- s1: vault lights b2 r12 -> b1 r8, the pass-19 low tunnel lights off: interior (37,50,67) 7
		sheet = rgb(200, 250, 255), -- (splash box is mist-dominated: 119-207 R between frames; colour kept at the target)
		back = { w = 38.0, hw = 7.2, y0 = 2.6, y1 = 9, col = rgb(70, 90, 98) } } -- s4 (105,125,125): (46,73,92) 21 -> s5 (70,90,98). s3 col (38,50,62): box (10,20,36) 36, render ratio ~.26/.4/.58 -> s4 (105,125,125). s3: a dark panel over the niche back wall (c1 (600,400) and
		-- (650,385) hit hero stone at w 38.3 by ray; it read (109,121,116) in daylight against (30,52,72)) -- s2: K_Hero_sheet (150,205,225) Glass -> (200,250,255): splash box was (178,212,226) 36
	for _, v in ipairs(root:GetChildren()) do
		if v.Name == "VaultLight" then local l = v:FindFirstChildOfClass("PointLight"); if l then setLight(l, nil, T.vb, T.vr) end end
	end
	for _, v in ipairs(P19:GetChildren()) do
		if v.Name == "TunnelLight19" then local l = v:FindFirstChildOfClass("PointLight"); if l then setLight(l, nil, T.lowB) end end
	end
	local hs = root.K_Hero:FindFirstChild("K_Hero_sheet"); if hs and T.sheet then recol(hs, T.sheet) end
	if T.back then
		for _, sx in ipairs({ -1, 1 }) do for _, sz in ipairs({ -1, 1 }) do
			local d = Vector3.new(sx, 0, sz).Unit
			local pos = d * T.back.w + Vector3.new(0, (T.back.y0 + T.back.y1) / 2, 0)
			local b = part("TunnelBack20", Vector3.new(T.back.hw * 2, T.back.y1 - T.back.y0, 0.2), CFrame.lookAt(pos, pos - d), T.back.col, Enum.Material.Slate)
			b.CanCollide = false; b.CastShadow = false
		end end
	end
	table.insert(report, "tunnel20 ok")
end
--ENDTUNNEL20

-- ================================================================ item 4: stair tone. c4 treads (298-302, 558-562) (158,164,162),
-- risers (398-402, 518-522) (75,97,113). The practice treads K_Stairs_stone (125,126,126) Slate render at (201,203,198) (x1.6),
-- so the tread colour is scaled by target/measured; the risers go deep blue-slate.
--STAIR20
do
	local S = { tread = rgb(99, 102, 101), riser = rgb(48, 64, 80), nosing = rgb(120, 124, 122) } -- s1
	local ks = root.K_Stairs
	if S.tread then recol(ks.K_Stairs_stone, S.tread) end
	if S.riser then recol(ks.K_Stairs_riser, S.riser) end
	if S.nosing then for _, n in ipairs(root.Planting:GetChildren()) do if n.Name == "Nosing" then recol(n, S.nosing) end end end
	table.insert(report, "stair20 ok")
end
--ENDSTAIR20

-- ================================================================ item 3: bollards at ~60% height, white base, squat round gold head;
-- the 8 domed MedalStud beads on the medallion rim go (the flat discs stay). p5 targets: head (718-722, 543-547) (223,214,144),
-- base (718-722, 638-642) (240,239,230). Stand-in Parts; the kit bollard (K_Boll20, lathe) replaces them once r20 is imported.
--BOLL20
do
	local B = { base = rgb(240, 239, 230), head = rgb(175, 162, 98), -- kit head s2 (192,176,104): (245,235,152) 22; s3 again by ratio. kit head s1 (218,202,138): (254,247,194) 50 (smooth dome catches the sun); s2 x target/measured. Parts s1 base (225,224,214) head (226,206,120): base (222,221,216) 18, head (233,220,128) 16; s2 scaled by target/measured
		 gy = 0.25, bw = 3, bh = 1.5, hd = 1.6, headMat = SM } -- s1
	for _, d in ipairs(P9:GetChildren()) do if d.Name == "MedalStud" then hide(d) end end
	for _, d in ipairs(P16:GetChildren()) do if d.Name == "Bollard16" then hide(d) end end
	local F = Instance.new("Folder"); F.Name = "Bollard20"; F.Parent = P20
	local kb, kh = kit and kit:FindFirstChild("K_Boll20_base"), kit and kit:FindFirstChild("K_Boll20_head")
	for _, sx in ipairs({ -1, 1 }) do for _, sz in ipairs({ -1, 1 }) do
		local x, z = sx * 9.6, sz * 9.6
		if kb and kh then
			for _, k in ipairs({ kb, kh }) do
				local c = k:Clone(); c.Anchored = true; c.CFrame = CFrame.new(x, B.gy, z) * CFrame.new(k.Position) * (k.CFrame - k.CFrame.Position)
				c.Color = (k == kb) and B.base or B.head; c.Material = (k == kb) and SM or B.headMat; c.Parent = F
				c.CanCollide = (k == kb)
			end
		else
			part("BollBase20", Vector3.new(B.bw, B.bh, B.bw), CFrame.new(x, B.gy + B.bh / 2, z), B.base, SM, F)
			part("BollCap20", Vector3.new(B.bw - 0.5, 0.3, B.bw - 0.5), CFrame.new(x, B.gy + B.bh + 0.15, z), B.base, SM, F)
			local h = part("BollHead20", Vector3.new(B.hd, B.hd, B.hd), CFrame.new(x, B.gy + B.bh + 0.3 + B.hd * 0.3, z), B.head, B.headMat, F)
			h.Shape = Enum.PartType.Ball
		end
	end end
	table.insert(report, "boll20 ok" .. ((kb and kh) and " (kit)" or " (parts)"))
end
--ENDBOLL20

-- ================================================================ item 5: south side, measured from the frames (p2 crop 500-1100 x
-- 60-420): ref ring 170 px wide centred y 160, practice 235 px centred y 126 (100 studs away: 34 px = 6 studs), so the ring goes
-- 6 lower and 0.85x, grey rock. Gate: same width in p2, 1.27x taller in p6 -> 1.2x about its base. Green palm: p2 crown (950,90),
-- p6 crown (540,60), p7 trunk foot near the SW basin -> about (-32, 6, 62), crown top ~46. Sand beach SW of the S arm.
--SOUTH20
do
	local S = { ringDrop = 6, ringK = 0.85, ringCol = rgb(150, 155, 160), gateK = 1.2, door = rgb(70, 205, 200), cloud = rgb(185, 245, 240),
		-- s1 palm (-32,62) leaves (70,160,50): lime and too near the p7 camera; the p7 ref trunk foot (410,580) projects to (-39, 6, 49)
		-- (out/r20w/ground.py), ref leaf (380,360) (69,108,60), sand (450,640) (243,241,192) at (-30, 58); ref SE sand (1420,700) at (70, 63)
		-- s2: beach box (248,247,228) 13; palm crown still lime and centred (220,480) where the ref crown sits at (380,380) -> s3 30 tall,
		-- foot 6 further NE, leaves darker by the rendered/target ratio
		palm = Vector3.new(-35, 0, 47), palmH = 30, leaf = { rgb(42, 95, 32), rgb(70, 125, 42) }, wood = rgb(120, 85, 50),
		sand = rgb(240, 236, 200), beach = { { -38, 57, 30, 16 }, { -27, 61, 16, 12 }, { -49, 59, 16, 12 }, { -36, 65, 20, 10 }, { 70, 62, 20, 14 }, { 63, 56, 12, 10 } } } -- s2
	local L = root.Landmarks
	local ring = L:FindFirstChild("K_ExpRing8")
	if ring then
		local cf0 = ring:GetAttribute("P20CF0") or ring:GetPivot()
		moveModel(ring, cf0 - Vector3.new(0, S.ringDrop, 0), S.ringK)
		for _, d in ipairs(ring:GetDescendants()) do if d:IsA("BasePart") and d.Name:find("stone") then recol(d, S.ringCol, Enum.Material.Slate) end end
	end
	local gate = P9:FindFirstChild("K_Trip10")
	if gate then
		local cf0 = gate:GetAttribute("P20CF0") or gate:GetPivot()
		local bcf, bsz = gate:GetBoundingBox()
		local baseY = (gate:GetAttribute("P20Base") or (bcf.Y - bsz.Y / 2)); gate:SetAttribute("P20Base", baseY)
		-- scale about the base centre: pivot offset from the base point grows by k
		local base = Vector3.new(cf0.X, baseY, cf0.Z)
		moveModel(gate, CFrame.new(base + (cf0.Position - base) * S.gateK) * (cf0 - cf0.Position), S.gateK)
		local txt = P9:FindFirstChild("K_TxtExp9")
		if txt then local t0 = txt:GetAttribute("P20CF0") or txt:GetPivot(); moveModel(txt, t0 + Vector3.new(0, (t0.Y - baseY) * (S.gateK - 1), 0)) end
		local sw = gate:FindFirstChild("K_Trip10_swirl", true); if sw then hide(sw) end
		local po = gate:FindFirstChild("K_Trip10_portal", true)
		if po then
			recol(po, S.door, Enum.Material.Glass)
			-- cloud door: soft puffs inside the door opening (own K_Cloud7 mesh, small)
			local cl = kit and kit:FindFirstChild("K_Cloud7_cloud")
			local rng = Random.new(2020)
			if cl then
				for i = 1, 5 do
					local c = cl:Clone(); c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
					local w = po.Size.X * rng:NextNumber(0.5, 0.8)
					c.Size = Vector3.new(w, w * 0.5, 0.6) * Vector3.new(1, 1, 1)
					c.CFrame = po.CFrame * CFrame.new(rng:NextNumber(-1, 1), -po.Size.Y * 0.4 + (i - 1) * po.Size.Y * 0.2, -0.25)
					c.Color = S.cloud; c.Material = SM; c.Transparency = 0.25; c.Parent = P20
				end
			end
		end
	end
	-- green palm: a RaidPalm16 clone, green leaves
	local src = P16:FindFirstChild("RaidPalm16")
	if src and S.palm then
		local c = src:Clone(); c.Name = "GreenPalm20"
		for _, a in ipairs({ "P20CF0", "P20Sc0", "P19CF0", "P19Sc0" }) do c:SetAttribute(a, nil) end
		local _, sz = c:GetBoundingBox(); c:ScaleTo(c:GetScale() * S.palmH / sz.Y)
		local gy = groundY(S.palm.X, S.palm.Z, 60)
		local cf2, sz2 = c:GetBoundingBox()
		c:PivotTo(c:GetPivot() + (Vector3.new(S.palm.X, gy, S.palm.Z) - Vector3.new(cf2.X, cf2.Y - sz2.Y / 2, cf2.Z)))
		for _, d in ipairs(c:GetDescendants()) do
			if d:IsA("BasePart") then
				if d.Name:find("wood") then d.Color = S.wood elseif d.Name:find("Rim") then d.Color = S.leaf[2] else d.Color = S.leaf[1] end
			end
		end
		c.Parent = P20
	end
	-- sand beach: overlapping flat discs just above the ground
	local F = Instance.new("Folder"); F.Name = "Beach20"; F.Parent = P20
	for i, b in ipairs(S.beach) do
		local gy = groundY(b[1], b[2], 40)
		local q = part("Sand20", Vector3.new(0.2, b[3], b[4]), CFrame.new(b[1], gy + 0.08 + i * 0.01, b[2]) * CFrame.Angles(0, 0.3 * i, math.pi / 2), S.sand, Enum.Material.Sand, F)
		q.Shape = Enum.PartType.Cylinder; q.CanCollide = false; q.CastShadow = false
	end
	table.insert(report, "south20 ok")
end
--ENDSOUTH20

--KIT20
-- ================================================================ item 2 (mesh half): squat arch opening (intrados ellipse hw 7.6,
-- centre y 1.1, rise 5.4, measured by projecting the c1 reference inner-edge pixels onto the arch plane), sill 9.0, two stepped
-- slate bands fanning onto the stair rail with gold edges; sculpted splash on each drum in place of the water sheet; swim rings.
if kit and kit:FindFirstChild("K_Arch20_stone") then
	local K = { slate = { rgb(74, 81, 87), Enum.Material.Slate }, splash = rgb(120, 205, 235), splashT = 0.15, -- s1 (200,245,255) T .1: blown white (227,249,250) and reads as a cloud; s2 deeper cyan
		rings = { { -30, 60, 0.4 }, { -46, 63, 2.1 }, { 68, 64, 1.0 } }, ringCol = { rgb(225, 55, 55), rgb(245, 245, 240) } }
	for _, d in ipairs(P19:GetChildren()) do if d.Name:sub(1, 9) == "K_Arch19_" then hide(d) end end
	local hs, hg = P19:FindFirstChild("K_Hero19_stone"), P19:FindFirstChild("K_Hero19_gold")
	for _, tok in ipairs({ "stone", "slate", "gold" }) do
		local k = kit:FindFirstChild("K_Arch20_" .. tok)
		if k then
			local n = k:Clone(); n.Anchored = true; n.CanCollide = (tok ~= "gold"); n.CanQuery = (tok ~= "gold")
			if tok == "stone" then n.Color = hs.Color; n.Material = hs.Material; n.Reflectance = hs.Reflectance
			elseif tok == "gold" then n.Color = hg.Color; n.Material = hg.Material; n.Reflectance = hg.Reflectance
			else n.Color = K.slate[1]; n.Material = K.slate[2] end
			n.Parent = P20
		end
	end
	local sp = kit:FindFirstChild("K_Splash20_water")
	for _, d in ipairs(P9:GetChildren()) do
		if d.Name == "WaterSheet" then
			hide(d)
			if sp then
				local c = sp:Clone(); c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
				c.CFrame = CFrame.new(math.sign(d.Position.X) * 23.41, 4.1, math.sign(d.Position.Z) * 23.41) * CFrame.new(sp.Position) * CFrame.Angles(0, math.rad(40), 0)
				c.Color = K.splash; c.Material = SM; c.Transparency = K.splashT; c.Parent = P20
			end
		end
	end
	for _, r in ipairs(K.rings) do
		local gy = groundY(r[1], r[2], 40)
		for i, tok in ipairs({ "red", "white" }) do
			local k = kit:FindFirstChild("K_SwimRing20_" .. tok)
			if k then
				local c = k:Clone(); c.Anchored = true; c.CanCollide = false
				c.CFrame = CFrame.new(r[1], gy, r[2]) * CFrame.Angles(0, r[3], 0) * CFrame.new(k.Position) * (k.CFrame - k.CFrame.Position)
				c.Color = K.ringCol[i]; c.Material = SM; c.Parent = P20
			end
		end
	end
	table.insert(report, "kit20 ok")
else
	table.insert(report, "kit20 skipped (no r20 kit)")
end
--ENDKIT20

return table.concat(report, "; ")
end
