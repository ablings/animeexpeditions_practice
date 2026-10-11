-- pass25.lua (practice place only): freestyle pass 25 on top of the pass-24 build (notes/fix_brief25.md, verify22_plaza.md).
-- Run AFTER pass 24 (sh out/r24w/run.sh; then sh out/r25w/run.sh). Idempotent: new pieces live in Plaza.Pass25 (rebuilt each run);
-- hidden old pieces get P25Hidden (old transparency etc. in P25T / P25CC / P25CQ / P25En); recoloured old pieces keep their
-- pre-pass-25 colour/material in P25Col / P25Mat; moved Pass24 pieces keep their pass-24 CFrame/pivot in P25CF.
-- Blocks: --SKY25, --TREE25, --GROUND25, --RAID25, --STAIR25, --RUN25, --FERN25. Kit pieces (ae_kit_r25) are optional: every
-- block runs without them (RUN25 / FERN25 / the lobed crown then do nothing).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE, SL, GR = Enum.Material.SmoothPlastic, Enum.Material.Neon, Enum.Material.Slate, Enum.Material.Grass
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r25 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r25")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale25_stone", true)
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
-- bbox centres of the r25 pieces in their authored frame (kit/own/ae_kit_r25_centres.json): placement = origin + centre
local C25 = {
--C25
	K_Crown25_leaf = { 8.063, 85.503, -6.352 },
	K_Crown25_rim = { 8.67, 88.138, -6.301 },
	K_Fern25_leaf = { 0.154, 0.968, -0.015 },
	K_RunY25_core = { 0.0, 2.518, 0.0 },
	K_RunY25_gold = { 0.0, 3.671, 0.0 },
	K_Stairs25_joint = { 0.0, 2.95, 0.0 },
	K_Stairs25_riser = { 0.0, 2.96, 0.0 },
	K_Stairs25_stone = { 0.0, 3.389, 0.0 },
}
local old = root:FindFirstChild("Pass25"); if old then old:Destroy() end
local P25 = Instance.new("Folder"); P25.Name = "Pass25"; P25.Parent = root
local P24, P23, P15, P11 = root.Pass24, root.Pass23, root.Pass15, root.Pass11
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P25
	return p
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P25T") == nil then d:SetAttribute("P25T", d.Transparency); d:SetAttribute("P25CC", d.CanCollide); d:SetAttribute("P25CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P25Hidden", true)
		end
		if d:IsA("Decal") or d:IsA("Texture") then
			if d:GetAttribute("P25T") == nil then d:SetAttribute("P25T", d.Transparency) end
			d.Transparency = 1; d:SetAttribute("P25Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P25Col") == nil then p:SetAttribute("P25Col", p.Color); p:SetAttribute("P25Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
-- move a BasePart / Model relative to its pass-24 CFrame (stored once in P25CF)
local function moveTo(inst, f)
	local base = inst:GetAttribute("P25CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P25CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
-- restore everything pass 25 touched, so every run starts from the pass-24 state
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P25Hidden") then
		if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then d.Transparency = d:GetAttribute("P25T") end
		if d:IsA("BasePart") and d:GetAttribute("P25CC") ~= nil then d.CanCollide = d:GetAttribute("P25CC"); d.CanQuery = d:GetAttribute("P25CQ") end
		d:SetAttribute("P25Hidden", nil)
	end
	if d:GetAttribute("P25Col") ~= nil then d.Color = d:GetAttribute("P25Col"); d.Material = Enum.Material[d:GetAttribute("P25Mat")] end
	if d:GetAttribute("P25CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P25CF")) else d.CFrame = d:GetAttribute("P25CF") end
	end
end
local function has(name) return kit and kit:FindFirstChild(name) ~= nil end
local function kp(name, o, col, mat, parent, newName, s)
	local src = kit and kit:FindFirstChild(name); if not src or not C25[name] then return nil end
	s = s or 1
	local c = src:Clone(); c.Name = newName or name:gsub("^K_", ""); c.Anchored = true; c.CanCollide = false; c.CanQuery = false
	c.Size = src.Size * s
	local cc = C25[name]; c.CFrame = o * CFrame.new(cc[1] * s, cc[2] * s, cc[3] * s)
	c.Color = col; c.Material = mat or SM; c.Parent = parent or P25
	return c
end
local function kitModel(prefix, cf, scale, parent, colf)
	local m = Instance.new("Model"); m.Name = prefix
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
			local c = k:Clone(); c.Size = k.Size * scale; c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
			c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
			local keep = true
			if colf then keep = colf(k.Name:match("_(%a+)$"), c) ~= false end
			if keep then c.Parent = m else c:Destroy() end
		end
	end
	m.Parent = parent or P25; return m
end
local function kitExt(prefix)
	local lo, hi = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then lo = lo:Min(k.Position - k.Size / 2); hi = hi:Max(k.Position + k.Size / 2) end
	end
	return lo, hi
end
local report = {}

-- ================================================================ item 1: background islands read as islands, not a grey ceiling.
-- p1 band (136,165,144) rep (618-622, 28-32) = N island underside -> (188,209,167) ref same box (green island tops); c4 sky
-- (166,170,171) rep (700-704, 60-64) vs (152,163,157) ref. Pale vine fringe off; rock warmer (150,140,125); a green canopy fringe
-- round the near rim so the rim reads green from below; pale ruin towers standing on the caps; N islands pushed out and down.
--SKY25
local SKY = {
	rock = rgb(150, 138, 118), rockMat = SL, hideVines = true,
	nMove = { dz = -60, dy = -30 },          -- N islands (z < 0): further out (more negative z) and lower
	sMove = { dz = 60, dy = -30 },          -- S islands (z > 0): further out and lower
	fringe = { leaf = rgb(205, 228, 170), rim = rgb(225, 240, 190), pad = rgb(185, 210, 155), n = 5, s = 1.3, drop = 5 },
	ruin = rgb(226, 222, 205), capTree = rgb(195, 220, 150), capTreeRim = rgb(220, 236, 185),
}
do
	local F = Instance.new("Folder"); F.Name = "Sky25"; F.Parent = P25
	local S24 = P24:FindFirstChild("Sky24")
	local ni = 0
	for _, m in ipairs(S24 and S24:GetChildren() or {}) do
		if m:IsA("Model") and m.Name:find("^Isl24_") then
			local rock = m:FindFirstChild("K_Isl771_rock") or m:FindFirstChild("K_Isl772_rock") or m:FindFirstChild("K_Isl773_rock")
			local north = rock and rock.Position.Z < 0
			local mv = north and SKY.nMove or SKY.sMove
			moveTo(m, function(cf) return cf + Vector3.new(0, mv.dy, mv.dz) end)
			for _, d in ipairs(m:GetDescendants()) do
				if d:IsA("BasePart") then
					local tok = d.Name:match("_(%a+)$")
					if tok == "rock" and SKY.rock then d.Color = SKY.rock; d.Material = SKY.rockMat end
					if tok == "vine" and SKY.hideVines then d.Transparency = 1 end
					-- pass-24 cap trees: pale hazy green like the reference's distant island tops (188,209,167)
					if SKY.capTree and (tok == "leaf" or tok == "leafPad") then d.Color = SKY.capTree end
					if SKY.capTreeRim and tok == "leafRim" then d.Color = SKY.capTreeRim end
				end
			end
			-- canopy fringe along the near rim (the plaza side), hanging a little below the grass so it shows from below
			local grass = m:FindFirstChild("K_Isl771_grass") or m:FindFirstChild("K_Isl772_grass") or m:FindFirstChild("K_Isl773_grass")
			if grass and SKY.fringe and kit:FindFirstChild("K_Soft14U_leaf") then
				local gcf, gs = grass.CFrame, grass.Size
				local zs = ((gcf * CFrame.new(0, 0, gs.Z / 2)).Position.Magnitude < (gcf * CFrame.new(0, 0, -gs.Z / 2)).Position.Magnitude) and 1 or -1
				local fr = SKY.fringe
				for k = 1, fr.n do
					local u = (k - 0.5) / fr.n - 0.5
					local p = (gcf * CFrame.new(u * gs.X * 0.92, gs.Y / 2 - fr.drop, zs * gs.Z * 0.42)).Position
					local lo = kitExt("K_Soft14U")
					local s = fr.s * (1 + 0.25 * math.sin(k * 2.3 + ni))
					kitModel("K_Soft14U", CFrame.new(p) * CFrame.Angles(0, k * 1.7 + ni, 0) * CFrame.new(0, -28 * s, 0), s, F, function(tok, c)
						if tok == "wood" then return false end
						c.Color = (tok == "leafRim") and fr.rim or (tok == "leafPad" and fr.pad or fr.leaf); c.Material = SM
					end).Name = "IslFringe25"
				end
				-- pale ruin towers on the cap (two per island), standing above the grass
				for j, o in ipairs({ { -0.3, 0.1, "K_Tower9", 1.1 }, { 0.32, -0.15, "K_Ruin8", 1.3 } }) do
					if kit:FindFirstChild(o[3] .. "_stone") or kit:FindFirstChild(o[3] .. "_white") then
						local p = (gcf * CFrame.new(o[1] * gs.X, gs.Y / 2, o[2] * gs.Z)).Position
						kitModel(o[3], CFrame.new(p) * CFrame.Angles(0, j + ni, 0), o[4], F, function(tok, c)
							c.Color = (tok == "roof") and rgb(120, 150, 190) or SKY.ruin; c.Material = SM
						end).Name = "IslRuin25"
					end
				end
			end
			ni += 1
		end
	end
	table.insert(report, "sky25 islands " .. ni)
end
--ENDSKY25

-- ================================================================ item 5: giant tree crown green (46,119,133) p2 rep (900-904, 46-50) ->
-- (98,156,145) p2 ref (592-596, 58-62), 3-4 lobes; the trunk stands left of the gate in p2 ref (toward +x), not centred above it.
--TREE25
local TREE = { dx = 34, dz = 30, crown = rgb(135, 190, 150), rim = rgb(170, 215, 180), kitCrown = true }
do
	local S24 = P24:FindFirstChild("Sky24")
	local n = 0
	if S24 then
		for _, nm in ipairs({ "Tree24_bark", "Tree24_crown", "Tree24_crownRim" }) do
			local p = S24:FindFirstChild(nm)
			if p then
				moveTo(p, function(cf) return cf + Vector3.new(TREE.dx, 0, TREE.dz) end); n += 1
				if nm == "Tree24_crown" then p.Color = TREE.crown elseif nm == "Tree24_crownRim" then p.Color = TREE.rim end
			end
		end
		-- lobed kit crown (r25) replaces the lumpy r24 crown when imported; origin = trunk foot, same yaw as pass 24
		if TREE.kitCrown and has("K_Crown25_leaf") and C25.K_Crown25_leaf then
			local o = CFrame.new(-24 + TREE.dx, 4, 118 + TREE.dz) * CFrame.Angles(0, 0.3, 0)
			kp("K_Crown25_leaf", o, TREE.crown, SM, P25, "Crown25_leaf").CastShadow = false
			kp("K_Crown25_rim", o, TREE.rim, SM, P25, "Crown25_rim").CastShadow = false
			for _, nm in ipairs({ "Tree24_crown", "Tree24_crownRim" }) do local p = S24:FindFirstChild(nm); if p then hide(p) end end
			table.insert(report, "crown25 kit")
		end
	end
	table.insert(report, "tree25 parts " .. n)
end
--ENDTREE25

-- ================================================================ item 4: E ground balance. Red (232,103,83) p8 rep (1100-1104, 560-564) ->
-- (197,89,76) p8 ref (1160-1164, 526-530); p7 E green 6.6 % -> ~25 % (a lawn wedge along the SE plaza edge); the flat grey slab
-- (Path24) replaced by narrow grey paving paths; E red p7 28.5 % -> ~20 %.
--GROUND25
local GROUND = { carpet = rgb(132, 47, 30), hidePath = true, path = rgb(120, 118, 112), pathW = 7,
	lawn = rgb(88, 138, 52), lawnMat = GR, z0 = 4, slope = 0.45 }  -- lawn south of z = z0 + (x - 55) * slope
do
	local F = Instance.new("Folder"); F.Name = "Ground25"; F.Parent = P25
	local G24 = P24:FindFirstChild("Ground24")
	if G24 then
		for _, nm in ipairs({ "Carpet24", "Carpet24n" }) do local c = G24:FindFirstChild(nm); if c and GROUND.carpet then c.Color = GROUND.carpet end end
		local p = G24:FindFirstChild("Path24"); if p and GROUND.hidePath then hide(p) end
	end
	local function south(x, z) return z > GROUND.z0 + (x - 55) * GROUND.slope end
	local nr, ng = 0, 0
	for _, d in ipairs(root.Zoning:GetDescendants()) do
		if d:IsA("BasePart") and d.Position.X > 52 and d.Position.X < 140 and d.Position.Y < 7 and d.Size.Y < 1 then
			local isRed = d.Color.R > 0.5 and d.Color.G < 0.3
			if south(d.Position.X, d.Position.Z) and (isRed or d.Material == GR) and GROUND.lawn then recol(d, GROUND.lawn, GROUND.lawnMat); ng += 1
			elseif isRed and d:GetAttribute("P24Col") ~= nil and GROUND.carpet then recol(d, GROUND.carpet); nr += 1 end
		end
	end
	-- lawn wedge above the carpet: north edge along the boundary line from x 56 to 135
	if GROUND.lawn then
		local a = math.atan(GROUND.slope); local L = 85; local Wd = 40
		local mx = 56 + L / 2 * math.cos(a); local mz = GROUND.z0 + (56 - 55) * GROUND.slope + L / 2 * math.sin(a)
		local c = Vector3.new(mx - Wd / 2 * math.sin(a), 6.12, mz + Wd / 2 * math.cos(a))
		part("Lawn25", Vector3.new(L, 0.2, Wd), CFrame.new(c) * CFrame.Angles(0, -a, 0), GROUND.lawn, GROUND.lawnMat, F).CanQuery = false
	end
	-- narrow grey paving paths through the red (the reference's paths are ~6-8 wide)
	if GROUND.path then
		for _, s in ipairs({ { 78, -3, 150, -3 }, { 100, -3, 150, -70 }, { 70, -40, 120, -95 } }) do
			local a, b = Vector3.new(s[1], 6.3, s[2]), Vector3.new(s[3], 6.3, s[4])
			part("Path25", Vector3.new(GROUND.pathW, 0.2, (b - a).Magnitude), CFrame.lookAt((a + b) / 2, b), GROUND.path, SL, F).CanQuery = false
		end
	end
	table.insert(report, string.format("ground25 red %d lawn %d", nr, ng))
end
--ENDGROUND25

-- ================================================================ item 2: Raid glow as soft cards hugging the facade (no bubble domes);
-- glow (207,118,106) p3 rep/ref box (598-602, 218-222) -> (233,119,117); 3-4 more rock spires; skull pillars (147,90,89) c3 rep
-- (1250-1254, 300-304) -> red rock (149,54,58) c3 ref (1348-1352, 278-282).
--RAID25
local RAID = { hideBlobs = true, tex = "rbxassetid://105673126145689", glow = rgb(255, 165, 155), glowT = 0.6, bone = rgb(150, 62, 48),
	pillar = rgb(140, 42, 40), dome = rgb(225, 105, 100), spire = rgb(150, 44, 34) }
do
	local F = Instance.new("Folder"); F.Name = "Raid25"; F.Parent = P25
	local R24 = P24:FindFirstChild("Raid24"); local nb = 0
	if R24 and RAID.hideBlobs then for _, d in ipairs(R24:GetChildren()) do if d.Name == "RaidGlow24" then hide(d); nb += 1 end end end
	-- cards: x (depth), y, z, width, height; camera-facing toward -x (the plaza); two layers for a ragged soft edge
	if RAID.tex then
		for i, g in ipairs({ { 150, 20, -26, 34, 30 }, { 150, 20, 26, 34, 30 }, { 154, 44, -34, 30, 36 }, { 154, 44, 34, 30, 36 },
			{ 158, 30, -16, 22, 30 }, { 158, 30, 16, 22, 30 } }) do
			local c = part("RaidCard25", Vector3.new(g[4], g[5], 0.05), CFrame.lookAt(Vector3.new(g[1], g[2], g[3]), Vector3.new(g[1] - 10, g[2], g[3])), RAID.glow, SM, F)
			c.Transparency = 1; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
			local dc = Instance.new("Decal"); dc.Texture = RAID.tex; dc.Face = Enum.NormalId.Front; dc.Color3 = RAID.glow; dc.Transparency = RAID.glowT; dc.Parent = c
		end
	end
	local sk = P15:FindFirstChild("K_Skull15"); local pil = sk and sk:FindFirstChild("K_Skull15_pillar")
	if pil and RAID.pillar then recol(pil, RAID.pillar, SL) end
	-- tower domes catch the glow: the p3 glow box (598-602, 218-222) lands on the left K_RTower7 dome behind the cards
	local r11 = P11:FindFirstChild("Raid11")
	if r11 and RAID.dome then for _, m in ipairs(r11:GetChildren()) do
		if m.Name == "K_RTower7" then for _, d in ipairs(m:GetChildren()) do if d:IsA("BasePart") and d.Name:find("_dome") then recol(d, RAID.dome, SM) end end end
	end end
	local bone = sk and sk:FindFirstChild("K_Skull15_bone")
	if bone and RAID.bone then recol(bone, RAID.bone) end
	if RAID.spire and kit:FindFirstChild("K_Spire_stone") then
		local lo = kitExt("K_Spire")
		for i, s in ipairs({ { 166, -46, 1.5, 0.1 }, { 168, 46, 1.7, -0.12 }, { 186, -38, 1.4, 0.06 }, { 190, 34, 1.6, -0.05 } }) do
			kitModel("K_Spire", CFrame.new(s[1], 6, s[2]) * CFrame.Angles(s[4], i * 1.3, s[4] * 0.7) * CFrame.new(0, -lo.Y * s[3], 0), s[3], F, function(tok, c)
				c.Color = RAID.spire; c.Material = SL; c.CastShadow = true
			end).Name = "RaidSpire25"
		end
	end
	table.insert(report, "raid25 blobs hidden " .. nb)
end
--ENDRAID25

-- ================================================================ item 8 (part): risers (107,126,140) c4 rep (428-432, 626-630) -> (85,103,115)
-- c4 ref (428-432, 646-650).
--STAIR25
local STAIR = { tread = rgb(126, 129, 125), riser = rgb(100, 106, 103), joint = rgb(70, 85, 95) }
do
	local s24, r24, j24 = P24:FindFirstChild("Stairs24_stone"), P24:FindFirstChild("Stairs24_riser"), P24:FindFirstChild("Stairs24_joint")
	if has("K_Stairs25_stone") and s24 then
		-- r25 blocks: smaller chamfer, every steep face in the riser mesh (darker), dark joint line in the gaps
		local a = kp("K_Stairs25_stone", CFrame.new(), STAIR.tread, SM, P25, "Stairs25_stone"); a.CanCollide = true; a.CanQuery = true
		local r = kp("K_Stairs25_riser", CFrame.new(), STAIR.riser, SM, P25, "Stairs25_riser"); r.CanCollide = true; r.CanQuery = true
		kp("K_Stairs25_joint", CFrame.new(), STAIR.joint, SM, P25, "Stairs25_joint")
		hide(s24); if r24 then hide(r24) end; if j24 then hide(j24) end
		table.insert(report, "stair25 kit")
	elseif r24 and STAIR.riser then recol(r24, STAIR.riser) end
end
--ENDSTAIR25

-- ================================================================ item 3: runner Y smaller (kit r25): 0.16 gold outline round a 0.5 core,
-- arms reaching x +-2.05 (~60 % of the face), fork ~40 % down the slab, long stem down to the gem, plus the two long inner gold lines
-- the arms run into. Gold (159,154,74) c4 rep (614-618, 618-622) -> (183,175,89) c4 ref (638-642, 558-562).
--RUN25
local RUN = { gold = rgb(124, 117, 54), goldMat = SM, core = rgb(25, 40, 110) }
do
	if has("K_RunY25_gold") and C25.K_RunY25_gold then
		kp("K_RunY25_gold", CFrame.new(), RUN.gold, RUN.goldMat, P25, "RunY25_gold")
		kp("K_RunY25_core", CFrame.new(), RUN.core, SM, P25, "RunY25_core")
		for _, nm in ipairs({ "RunY24_gold", "RunY24_core" }) do local p = P24:FindFirstChild(nm); if p then hide(p) end end
		local g = P24:FindFirstChild("Gem24_gold"); if g then recol(g, RUN.gold) end
		table.insert(report, "run25 kit")
	else
		for _, nm in ipairs({ "RunY24_gold", "Gem24_gold" }) do local p = P24:FindFirstChild(nm); if p then recol(p, RUN.gold) end end
	end
end
--ENDRUN25

-- ================================================================ item 7: standing fern clumps instead of flat floor splats: lime (114,166,54)
-- c2 ref (928-932, 588-592) at each fountain base / lower stair edge, blue on the W stair edges, red on the E (kit r25 K_Fern25).
--FERN25
local FERN = { lime = rgb(95, 150, 35), blue = rgb(40, 90, 210), red = rgb(190, 45, 40), s = 1.0 }
do
	local F = Instance.new("Folder"); F.Name = "Fern25"; F.Parent = P25
	local n = 0
	if has("K_Fern25_leaf") and C25.K_Fern25_leaf then
		-- (x, z, colour key, scale, yaw): fountain bases at the 4 diagonal fountains + stair-foot edges either side of each flight
		-- per flight (forward = away from the plaza centre): lime by the fountain side of the first tread (c2 ref box 928-932,
		-- 588-592 lands on the S flight's first tread at lateral ~8, d ~30); zone colour at the outer edge of the second tread
		local L = {}
		for _, fl in ipairs({ { 0, -1, "blue" }, { 1, 0, "red" }, { 0, 1, "lime" }, { -1, 0, "blue" } }) do
			local fx, fz = fl[1], fl[2]; local lx, lz = -fz, fx
			for _, sd in ipairs({ -1, 1 }) do
				table.insert(L, { fx * 28.6 + lx * sd * 7.6, fz * 28.6 + lz * sd * 7.6, "lime", 1.5 })
				table.insert(L, { fx * 32.0 + lx * sd * 16.5, fz * 32.0 + lz * sd * 16.5, fl[3], 1.2 })
			end
		end
		for i, f in ipairs(L) do
			local y = 6.2
			local ray = workspace:Raycast(Vector3.new(f[1], 40, f[2]), Vector3.new(0, -60, 0))
			if ray then y = ray.Position.Y end
			kp("K_Fern25_leaf", CFrame.new(f[1], y, f[2]) * CFrame.Angles(0, i * 2.1, 0), FERN[f[3]], SM, F, "Fern25", f[4] * FERN.s)
			n += 1
		end
	end
	table.insert(report, "fern25 " .. n)
end
--ENDFERN25

return table.concat(report, " | ") .. " | Plaza " .. #root:GetDescendants()
end
