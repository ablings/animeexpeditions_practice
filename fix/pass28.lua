-- pass28.lua (practice place only): freestyle pass 28 on top of the pass-27 build (notes/fix_brief28.md, verify25_plaza.md).
-- Run AFTER pass 27 (sh out/r27w/run.sh; then sh out/r28w/run.sh). Idempotent: new pieces live in Plaza.Pass28 (rebuilt each run);
-- every old piece pass 28 touches keeps its pre-pass-28 value in a P28* attribute and is restored first.
-- Attributes: P28Col/P28Mat, P28SA (SurfaceAppearance.Color), P28Map (ColorMap), P28T/P28CC/P28CQ + P28Hidden, P28CF, P28Size.
-- Blocks: --SKY28, --ACC28, --ISL28, --FALL28, --RUN28, --WEST28, --FLOOR28, --KIT28 (needs kit r28).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r28 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r28")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale28_stone", true)
		local sc = ref and ref.Size.X / 10.0 or 1
		for _, d in ipairs(src:GetDescendants()) do
			if d:IsA("MeshPart") then
				d.Size = d.Size / sc
				d.CFrame = CFrame.new(d.Position / sc) * (d.CFrame - d.CFrame.Position)
				d.Anchored = true
				local o = kit:FindFirstChild(d.Name); if o then o:Destroy() end
				if d.Name:sub(1, 7) == "K_Scale" then d:Destroy() else d.Parent = kit end
			end
		end
		src:Destroy()
	end
end
local old = root:FindFirstChild("Pass28"); if old then old:Destroy() end
local P28 = Instance.new("Folder"); P28.Name = "Pass28"; P28.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P28Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P28T"); d.CanCollide = d:GetAttribute("P28CC"); d.CanQuery = d:GetAttribute("P28CQ") end
		for _, a in ipairs({ "P28Hidden", "P28T", "P28CC", "P28CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P28Col") ~= nil then d.Color = d:GetAttribute("P28Col"); d.Material = Enum.Material[d:GetAttribute("P28Mat")]; d:SetAttribute("P28Col", nil); d:SetAttribute("P28Mat", nil) end
	if d:GetAttribute("P28SA") ~= nil then d.Color = d:GetAttribute("P28SA"); d:SetAttribute("P28SA", nil) end
	if d:GetAttribute("P28Map") ~= nil then d.ColorMap = d:GetAttribute("P28Map"); d:SetAttribute("P28Map", nil) end
	if d:GetAttribute("P28Size") ~= nil then d.Size = d:GetAttribute("P28Size"); d:SetAttribute("P28Size", nil) end
	if d:GetAttribute("P28CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P28CF")) else d.CFrame = d:GetAttribute("P28CF") end
		d:SetAttribute("P28CF", nil)
	end
	if d:GetAttribute("P28Shown") then   -- parts hidden by an older pass that pass 28 shows again
		d.Transparency = 1; d:SetAttribute("P28Shown", nil)
	end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P28T") == nil then d:SetAttribute("P28T", d.Transparency); d:SetAttribute("P28CC", d.CanCollide); d:SetAttribute("P28CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P28Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P28Col") == nil then p:SetAttribute("P28Col", p.Color); p:SetAttribute("P28Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function saCol(sa, col) if sa:GetAttribute("P28SA") == nil then sa:SetAttribute("P28SA", sa.Color) end sa.Color = col end
local function saMap(sa, map) if sa:GetAttribute("P28Map") == nil then sa:SetAttribute("P28Map", sa.ColorMap) end sa.ColorMap = map end
local function resize(p, s) if p:GetAttribute("P28Size") == nil then p:SetAttribute("P28Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P28CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P28CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local report = {}

-- ================================================================ item 2: sky. The clear sky already renders azure (61,161,244) at c3 900,60,
-- but the c3 box 650,60 (and much of the upper sky in c4/p2) is cloud (181,209,237) vs clear (69,192,243) in the reference. Own skybox
-- variant e (tex/make_ae_tex28.py): same haze to 10 deg, greener-azure MID/TOP, cloud threshold rising to 0.56 by 38 deg so the upper
-- sky clears. Dn face unchanged (pass 26).
--SKY28
local SKY = { Up = 102237175545025, Dn = 76842875409340, Ft = 137640852109570, Bk = 101440291556108, Lf = 74772741840033, Rt = 106007002640664 }  -- variant f (north = pass-26 d clouds); e was Up 110429086404038 Ft 124084810682797 Lf 130964529902383 Rt 120078918462623
do
	local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
	if sky and SKY then for k, id in pairs(SKY) do sky["Skybox" .. k] = "rbxassetid://" .. id end end
	table.insert(report, "sky28")
end
--ENDSKY28

-- ================================================================ item 2: accents. Pass 27 desaturated every N leaf; the reference keeps a few strong
-- accents: palms (73,106,180) c4 ref 315,211 (ours (140,173,211) at 870,95 = NPalm22 K_Soft13P SA tint), blue column trees (33,70,190)
-- c4 225,300 (ours (104,129,145) = Pass19.Cypress19 K_Soft15Y with the leaf27b map), gold tree (191,150,71)/(221,183,78) (ours
-- (242,229,168) = Pass13.Trees13 K_Soft15K cluster at (0,65,-185) with the leaf27b gold map).
--ACC28
local ACC = {
	palmRim = rgb(104, 138, 210), palmLeaf = rgb(78, 100, 165),           -- SA tints on the N K_Soft13P palms (pass-27 desaturated ones)
	cypSA = rgb(190, 200, 245),                                          -- Cypress19: original blue map back, SA tint
	goldSA = rgb(215, 190, 150), goldC = Vector3.new(0, 65, -185), goldR = 30,   -- the N gold tree: original gold map, SA tint
}
do
	local np, nc, ng = 0, 0, 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("SurfaceAppearance") and not d:IsDescendantOf(P28) then
			local nm = d.Parent.Name
			if ACC.palmRim and d:GetAttribute("P27SA") ~= nil and nm:find("^K_Soft13P_leaf") then
				saCol(d, nm == "K_Soft13P_leafRim" and ACC.palmRim or ACC.palmLeaf); np += 1
			end
		end
	end
	local cyp = root.Pass19:FindFirstChild("Cypress19")
	if cyp and ACC.cypSA then
		for _, d in ipairs(cyp:GetDescendants()) do
			if d:IsA("SurfaceAppearance") then
				local o = d:GetAttribute("P27Map"); if o then saMap(d, o) end
				saCol(d, ACC.cypSA); nc += 1
			end
		end
	end
	if ACC.goldSA then
		for _, m in ipairs(root.Pass13.Trees13:GetChildren()) do
			if (m:GetPivot().Position - ACC.goldC).Magnitude < ACC.goldR then
				for _, d in ipairs(m:GetDescendants()) do
					if d:IsA("SurfaceAppearance") and d:GetAttribute("P27Map") == "rbxassetid://94449468583229" then
						saMap(d, "rbxassetid://94449468583229"); saCol(d, ACC.goldSA); ng += 1
					end
				end
			end
		end
	end
	table.insert(report, string.format("acc28 palms %d cyp %d gold %d", np, nc, ng))
end
--ENDACC28

-- ================================================================ item 3: islands. c3 canopy box 30,175 = Pass25.Sky25.IslFringe25 K_Soft14U_leafPad
-- (185,210,155) rendering near-white (243,252,221) vs leafy (163,188,129) ref 152,102. Island rock undersides (Slate, (150,138,118) /
-- (185,200,205)) -> grey stone (120,125,130). The p3 top disc 750,20 / 700,50 = Islands.K_Isl92 near (290,190,50): hidden (lowered 35 it sat mid-frame).
--ISL28
local ISL = { pad = rgb(124, 157, 90), rim = rgb(150, 190, 110), rock = rgb(112, 117, 122), p3Drop = 35, lump = rgb(118, 150, 88) }
do
	local np, nr = 0, 0
	local sky25 = root.Pass25:FindFirstChild("Sky25")
	if sky25 and ISL.pad then
		for _, d in ipairs(sky25:GetDescendants()) do
			if d:IsA("BasePart") and d.Name == "K_Soft14U_leafPad" then recol(d, ISL.pad); np += 1 end
		end
	end
	local isl4 = root.Pass24:FindFirstChild("Sky24") and root.Pass24.Sky24:FindFirstChild("Isl24_4")
	if isl4 and ISL.rim then
		for _, d in ipairs(isl4:GetDescendants()) do if d:IsA("BasePart") and d.Name == "K_Soft14U_leafRim" then recol(d, ISL.rim); np += 1 end end
	end
	if ISL.rock then
		for _, f in ipairs({ root.Pass24:FindFirstChild("Sky24"), root.Pass22:FindFirstChild("Sky22"), root:FindFirstChild("Islands"), sky25 }) do
			for _, d in ipairs(f and f:GetDescendants() or {}) do
				if d:IsA("BasePart") and d.Material == Enum.Material.Slate and d.Name:find("rock") then recol(d, ISL.rock); nr += 1 end
			end
		end
	end
	local moved = 0
	if ISL.p3Drop then
		for _, m in ipairs(root.Islands:GetChildren()) do
			if m.Name == "K_Isl92" then
				local p = (m:GetAttribute("P28CF") or m:GetPivot()).Position
				if p.X > 200 and math.abs(p.Z - 60) < 60 then hide(m); moved += 1 end   -- lowering 35 made it a mid-frame grey island in p3: hidden
			end
		end
	end
	local i27 = root.Pass27:FindFirstChild("Isl27")
	if i27 and ISL.lump then for _, d in ipairs(i27:GetChildren()) do d.Color = ISL.lump end end
	table.insert(report, string.format("isl28 pads %d rocks %d p3moved %d", np, nr, moved))
end
--ENDISL28

-- ================================================================ item 3: falls. Pass-27 falls (205,232,246) T 0.35 are faint; reference falls are bright
-- white shafts. Retint/retransparent Pass27.Fall27, and add 2 more from the Isl24_4 lip where c3 sees the W islands (rep x 100-350:
-- world x -6..44 at z -215..-265).
--FALL28
local FALL = { col = rgb(235, 245, 250), t = 0.25, w = 5, pts = { { -18, 1.0 }, { 8, 0.8 } }, h = 50 }
do
	local n = 0
	local f27 = root.Pass27:FindFirstChild("Fall27")
	if f27 then for _, d in ipairs(f27:GetChildren()) do d.Color = FALL.col; d.Transparency = FALL.t; n += 1 end end
	local src = kit and kit:FindFirstChild("K_Fall8_fall"); local isl = root.Pass24:FindFirstChild("Sky24") and root.Pass24.Sky24:FindFirstChild("Isl24_4")
	if src and isl and FALL.pts then
		local F = Instance.new("Folder"); F.Name = "Fall28"; F.Parent = P28
		local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Include; prm.FilterDescendantsInstances = { isl }
		local saved = {}
		for _, d in ipairs(isl:GetDescendants()) do if d:IsA("BasePart") then saved[d] = d.CanQuery; d.CanQuery = d.Transparency < 0.5 and not d.Name:find("[Ff]all") end end
		for _, p in ipairs(FALL.pts) do
			for z = -170, -300, -2 do
				local r = workspace:Raycast(Vector3.new(p[1], 320, z), Vector3.new(0, -300, 0), prm)
				if r then
					local h = FALL.h * p[2]
					local c = src:Clone(); c.Name = "Fall28"; c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
					c.Size = Vector3.new(FALL.w, h, src.Size.Z * FALL.w / src.Size.X)
					c.CFrame = CFrame.new(p[1], r.Position.Y - 1 - h / 2, z + 1.5)
					c.Color = FALL.col; c.Material = Enum.Material.SmoothPlastic; c.Transparency = FALL.t; c.Parent = F
					n += 1; break
				end
			end
		end
		for d, v in pairs(saved) do d.CanQuery = v end
	end
	table.insert(report, "fall28 " .. n)
end
--ENDFALL28

-- ================================================================ item 4 (colour part; the wider rims/kerb are kit r28): panel Runner23_blue (58,82,160)
-- renders (82,137,239) c4 470,700 vs (64,107,219) ref 560,700, and p5 (105,155,242) vs (55,92,213). Y core RunY25_core (25,40,110)
-- -> (49,64,137) target. Stray flat blue K_Spill9 at (13,4,-40) on the c4 right treads (rep x 1040-1280, y 535-555): hidden.
--RUN28
local RUN = { blue = rgb(42, 66, 150), core = rgb(30, 42, 105) }
do
	local b = root.Pass23:FindFirstChild("Runner23_blue"); if b and RUN.blue then recol(b, RUN.blue) end
	local c = root.Pass25:FindFirstChild("RunY25_core"); if c and RUN.core then recol(c, RUN.core) end
	local n = 0
	for _, m in ipairs(root.Planting:GetChildren()) do
		if m.Name == "K_Spill9" and (m:GetPivot().Position - Vector3.new(13, 4, -40)).Magnitude < 3 then hide(m); n += 1 end
	end
	table.insert(report, "run28 spill " .. n)
end
--ENDRUN28

-- ================================================================ item 5: W half. A blue lagoon (the pass-16 Lagoon16 water, hidden by pass 24 for the
-- p8 W-blue metric) ~60 x 40 on its sand bank, with 5 blue palms (own NPalm22 clones) on its edge. S lawn GroundS (30,58,0) Grass
-- renders (80,136,104) at p7 900,620 vs (112,181,61). The faceted green palm at p7 near-left (Pass20.GreenPalm20, K_Palm6A) becomes a
-- long-frond palm (NPalm22 clone) in yellow-green.
--WEST28
local WEST = { lawn = rgb(62, 112, 4), water = rgb(60, 170, 230), deep = rgb(35, 120, 205), lag = Vector3.new(-92, 6.2, -34),
	lagSize = { 60, 40 }, sandPad = 7, palms = 5, palmBlue = { rgb(38, 98, 240), rgb(95, 165, 255) },
	green = { rgb(120, 172, 38), rgb(160, 205, 72) } }
do
	local w16 = root.Pass16:FindFirstChild("West16")
	local gs = root:FindFirstChild("GroundS"); if gs and WEST.lawn then recol(gs, WEST.lawn) end
	local n = 0
	local srcPalm = root.Pass22.Fol22:FindFirstChild("NPalm22")
	local function palm(name, pos, scale, rotY, cols)
		local c = srcPalm:Clone(); c.Name = name
		for _, d in ipairs(c:GetDescendants()) do
			if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CastShadow = true end
			if d:IsA("SurfaceAppearance") then
				for _, a in ipairs({ "P27SA", "P28SA", "P27Map", "P28Map" }) do d:SetAttribute(a, nil) end
				d.Color = d.Parent.Name == "K_Soft13P_leafRim" and cols[2] or cols[1]
			end
		end
		c:ScaleTo(scale)
		local bb, sz = c:GetBoundingBox(); local piv = c:GetPivot()
		local dy = pos.Y - (bb.Y - sz.Y / 2)
		c:PivotTo(CFrame.new(pos.X, piv.Y + dy, pos.Z) * CFrame.Angles(0, rotY, 0))
		c.Parent = P28; return c
	end
	if w16 and WEST.lagSize then
		local lag, deep, sand = w16:FindFirstChild("Lagoon16"), w16:FindFirstChild("LagoonDeep16"), w16:FindFirstChild("LagoonSand16")
		local L, D = WEST.lagSize[1], WEST.lagSize[2]
		if lag then
			-- P24 hid it; show it again (P28Shown re-hides it on restore)
			lag:SetAttribute("P28Shown", true); lag.Transparency = 0.05; recol(lag, WEST.water)
			resize(lag, Vector3.new(lag.Size.X, L, D))
		end
		if deep then deep:SetAttribute("P28Shown", true); deep.Transparency = 0.2; recol(deep, WEST.deep); resize(deep, Vector3.new(deep.Size.X, L * 0.55, D * 0.5)) end
		if sand then resize(sand, Vector3.new(sand.Size.X, L + WEST.sandPad * 2, D + WEST.sandPad * 2)) end
		if srcPalm and WEST.palms then
			local c0 = (lag and lag.Position) or WEST.lag
			for i = 1, WEST.palms do
				local a = (i - 0.3) / WEST.palms * math.pi * 2
				local p = c0 + Vector3.new(math.cos(a) * (L / 2 + 2), -6, math.sin(a) * (D / 2 + 2))
				palm("LagoonPalm28", Vector3.new(p.X, 5.5, p.Z), 1 + (i % 3) * 0.15, a + 1.3, WEST.palmBlue); n += 1
			end
		end
	end
	local gp = root.Pass20:FindFirstChild("GreenPalm20")
	if gp and srcPalm and WEST.green then
		local p = gp:GetPivot().Position
		hide(gp)
		palm("GreenPalm28", Vector3.new(p.X, 6.5, p.Z), 1.3, 0.6, WEST.green); n += 1
	end
	table.insert(report, "west28 palms " .. n)
end
--ENDWEST28

-- ================================================================ item 10 (cheap parts): c2 floor red "flower decals" at the runner (rep x 480-620,
-- y 500-600) = Planting.K_Fern with pink-red leaves at (13,1,25): hidden. c1 red clump Fern26 (200,60,52) renders (254,90,78) at
-- c1 1040,600 vs (227,92,90): cooler and darker.
--FLOOR28
local FLOOR = { fernC = Vector3.new(14, 1, 26), fernR = 10, red = rgb(178, 60, 62) }
do
	local n = 0
	for _, m in ipairs(root.Planting:GetChildren()) do
		if m.Name == "K_Fern" and (m:GetPivot().Position - FLOOR.fernC).Magnitude < FLOOR.fernR then
			local l = m:FindFirstChild("K_Fern_leafRim")
			if l and l.Color.R > l.Color.G * 1.3 then hide(m); n += 1 end
		end
	end
	local f26 = root.Pass26:FindFirstChild("Fern26")
	if f26 and FLOOR.red then
		for _, d in ipairs(f26:GetChildren()) do
			if d:IsA("BasePart") and math.abs(d.Color.R * 255 - 200) < 2 and math.abs(d.Color.G * 255 - 60) < 2 then recol(d, FLOOR.red); n += 1 end
		end
	end
	table.insert(report, "floor28 " .. n)
end
--ENDFLOOR28

-- ================================================================ kit r28 (tools/ae_kit.py pass-28 section; centres kit/own/ae_kit_r28_centres.json).
-- item 1 stairs: K_Stairs28 (3 long flat blocks per side per row, 0.1 joints, shallow 0.1 joint, no slot between rows) replaces
-- Pass27.Stairs27_*. item 4 runner: K_Runner28 kerb/gold/blue (1-stud grey kerb, 0.75 gold band, 5.1 blue face) + K_RunY28 replace
-- Runner23_silver/_blue, Runner24_rim, RunY25_*. item 9 bollards: faceted K_Boll28_head replaces K_Boll20_head. item 6: 8 K_Cres28
-- crescents round the Expeditions orb (Landmarks.K_ExpRing8 centre (0,46.5,91), ring in the XY plane). item 7: K_Goth28 gothic
-- door on the Raid front (old round neon door at x 157.6, z +-6.6, foot y 8.6), 4 K_Branch28 bare branches, RedTree22 parts in
-- front of the door moved 14 studs +z.
--KIT28
local C28 = {
	K_Stairs28_stone = { 0, 3.407, 0 }, K_Stairs28_edge = { 0, 3.354, 0 }, K_Stairs28_riser = { 0, 2.925, 0 }, K_Stairs28_joint = { 0, 2.95, 0 },
	K_Runner28_kerb = { 0, 3.059, 0 }, K_Runner28_gold = { 0, 3.331, 0 }, K_Runner28_blue = { 0, 3.319, 0 },
	K_RunY28_gold = { 0, 3.67, 0 }, K_RunY28_core = { 0, 2.53, 0 },
	K_Boll28_head = { 0, 2.175, 0 }, K_Cres28_stone = { 11.975, 0, 0 },
	K_Goth28_stone = { 0, 8.142, -0.3 }, K_Goth28_dark = { 0, 7.478, -0.71 }, K_Goth28_bone = { 0, 14.695, -1.075 },
	K_Branch28_wood = { -0.27, 5.686, 0.74 },
}
local K28 = {
	stair = { stone = rgb(118, 122, 120), edge = rgb(124, 128, 126), riser = rgb(78, 90, 95), joint = rgb(40, 48, 54) },
	run = { kerb = rgb(112, 114, 114), gold = rgb(138, 114, 36), blue = rgb(46, 66, 145), ygold = nil, ycore = rgb(30, 40, 88) },
	boll = rgb(135, 126, 50),
	cres = { col = rgb(178, 182, 192), c = Vector3.new(0, 46.5, 89.6), r = 9, n = 8 },   -- r 12 read too wide against the trunk in p2 (ref ring ~70 px)
	goth = { foot = Vector3.new(158.6, 8.6, 0), scale = 1.45, stone = rgb(120, 40, 45), dark = rgb(4, 2, 3), bone = rgb(225, 215, 190) },
	branch = { col = rgb(45, 32, 36), pts = { { 155, -11, 1.0, 0.4 }, { 155, -15.5, 1.3, -0.5 }, { 155, 11, 1.1, 2.6 }, { 155, 15.5, 1.25, 3.5 } } },
	redTree = { c = Vector3.new(117, 0, -3), r = 14, dz = 24 },   -- dz 14 still covered the right half of the door in p3
}
do
	local done = {}
	local function has(n) return kit and kit:FindFirstChild(n) and C28[n] end
	local function kp(n, cf, col, mat, parent, name, scale)
		local src = kit:FindFirstChild(n); local c = src:Clone(); c.Name = name or n; c.Anchored = true
		local s = scale or 1; local cc = C28[n]
		if s ~= 1 then c.Size = c.Size * s end
		c.CFrame = cf * CFrame.new(cc[1] * s, cc[2] * s, cc[3] * s)
		c.Color = col; c.Material = mat or Enum.Material.SmoothPlastic; c.CastShadow = true; c.Parent = parent; return c
	end
	if has("K_Stairs28_stone") then
		local F = Instance.new("Folder"); F.Name = "Stairs28"; F.Parent = P28
		for key, col in pairs(K28.stair) do
			local c = kp("K_Stairs28_" .. key, CFrame.new(), col, nil, F, "Stairs28_" .. key)
			c.CanCollide = key ~= "joint"; c.CanQuery = key ~= "joint"
		end
		local s27 = root.Pass27:FindFirstChild("Stairs27"); if s27 then hide(s27) end
		table.insert(done, "stairs")
	end
	if has("K_Runner28_kerb") then
		local F = Instance.new("Folder"); F.Name = "Runner28"; F.Parent = P28
		for _, k in ipairs({ "kerb", "gold", "blue" }) do kp("K_Runner28_" .. k, CFrame.new(), K28.run[k], nil, F, "Runner28_" .. k) end
		local yg = root.Pass25:FindFirstChild("RunY25_gold")
		kp("K_RunY28_gold", CFrame.new(), K28.run.ygold or (yg and (yg:GetAttribute("P28Col") or yg.Color)) or rgb(200, 170, 60), yg and yg.Material, F, "RunY28_gold")
		local core = kp("K_RunY28_core", CFrame.new(), K28.run.ycore, nil, F, "RunY28_core"); core.CanCollide = false
		for _, n in ipairs({ "Runner23_silver", "Runner23_blue" }) do local p = root.Pass23:FindFirstChild(n); if p then hide(p) end end
		local rim = root.Pass24:FindFirstChild("Runner24_rim"); if rim then hide(rim) end
		for _, n in ipairs({ "RunY25_gold", "RunY25_core" }) do local p = root.Pass25:FindFirstChild(n); if p then hide(p) end end
		table.insert(done, "runner")
	end
	if has("K_Boll28_head") then
		local n = 0
		for _, h in ipairs(root.Pass20:GetDescendants()) do
			if h.Name == "K_Boll20_head" and h:IsA("BasePart") then
				local bottom = h.Position.Y - h.Size.Y / 2
				kp("K_Boll28_head", CFrame.new(h.Position.X, bottom - 1.5, h.Position.Z), K28.boll, Enum.Material.Metal, P28, "Boll28_head")
				hide(h); n += 1
			end
		end
		table.insert(done, "boll " .. n)
	end
	if has("K_Cres28_stone") then
		local F = Instance.new("Folder"); F.Name = "Cres28"; F.Parent = P28
		for i = 1, K28.cres.n do
			local a = (i - 0.5) / K28.cres.n * math.pi * 2
			local cf = CFrame.new(K28.cres.c) * CFrame.Angles(math.pi / 2, 0, 0) * CFrame.Angles(0, a, 0) * CFrame.Angles(0.25 * ((i % 2) * 2 - 1), 0, 0)
			local c = kp("K_Cres28_stone", cf, K28.cres.col, Enum.Material.Slate, F, "Cres28", K28.cres.r / 12 * (0.9 + (i % 3) * 0.08))
			c.CanCollide = false
		end
		table.insert(done, "cres")
	end
	if has("K_Goth28_stone") then
		local F = Instance.new("Folder"); F.Name = "Goth28"; F.Parent = P28
		local cf = CFrame.new(K28.goth.foot) * CFrame.Angles(0, math.rad(90), 0)
		kp("K_Goth28_stone", cf, K28.goth.stone, Enum.Material.Slate, F, "Goth28_stone", K28.goth.scale)
		kp("K_Goth28_dark", cf, K28.goth.dark, Enum.Material.Neon, F, "Goth28_dark", K28.goth.scale)   -- SmoothPlastic (12,6,9) rendered pink under the Raid lights; Neon near-black stays dark
		kp("K_Goth28_bone", cf, K28.goth.bone, nil, F, "Goth28_bone", K28.goth.scale)
		for _, d in ipairs(root.Pass16:GetChildren()) do if d.Name == "RaidDoorNeon16" then hide(d) end end
		if has("K_Branch28_wood") then
			for _, p in ipairs(K28.branch.pts) do
				local c = kp("K_Branch28_wood", CFrame.new(p[1], K28.goth.foot.Y, p[2]) * CFrame.Angles(0, p[4], 0), K28.branch.col, Enum.Material.Wood, F, "Branch28", p[3])
				c.CanCollide = false
			end
		end
		local nm = 0   -- several models are named RedTree22: move the one(s) whose pivot stands in front of the door
		if K28.redTree then
			for _, m in ipairs(root.Pass22.Fol22:GetChildren()) do
				if m.Name == "RedTree22" then
					local p = (m:GetAttribute("P28CF") or m:GetPivot()).Position
					if Vector3.new(p.X - K28.redTree.c.X, 0, p.Z - K28.redTree.c.Z).Magnitude < K28.redTree.r then
						moveTo(m, function(b) return b + Vector3.new(0, 0, K28.redTree.dz) end); nm += 1
					end
				end
			end
		end
		table.insert(done, "goth redtree " .. nm)
	end
	table.insert(report, "kit28 " .. (#done > 0 and table.concat(done, ",") or "absent"))
end
--ENDKIT28

return table.concat(report, "; ")
end
