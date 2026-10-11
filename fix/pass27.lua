-- pass27.lua (practice place only): freestyle pass 27 on top of the pass-26 build (notes/fix_brief27.md, verify24_plaza.md).
-- Run AFTER pass 26 (sh out/r26w/run.sh; then sh out/r27w/run.sh). Idempotent: new pieces live in Plaza.Pass27 (rebuilt each run);
-- every old piece pass 27 touches keeps its pre-pass-27 value in a P27* attribute and is restored first, so every run starts
-- from the pass-26 state. Attributes: P27Col/P27Mat (part colour/material), P27SA (SurfaceAppearance.Color), P27Map (ColorMap),
-- P27T/P27CC/P27CQ + P27Hidden (hidden parts), P27CF (moved parts/models).
-- Blocks: --LEAF27, --GOLD27, --TREE27, --COL27, --FALL27, --STAIR27 (needs kit r27), --WEST27.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r27 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r27")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale27_stone", true)
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
-- bbox centres of the r27 pieces in their authored frame (kit/own/ae_kit_r27_centres.json): placement = origin + centre
local C27 = {
	K_Stairs27_stone = { 0.0, 3.385, 0.0 }, K_Stairs27_edge = { 0.0, 3.279, 0.0 },
	K_Stairs27_riser = { 0.0, 2.85, 0.0 }, K_Stairs27_joint = { 0.0, 2.8, 0.0 },
}
local old = root:FindFirstChild("Pass27"); if old then old:Destroy() end
local P27 = Instance.new("Folder"); P27.Name = "Pass27"; P27.Parent = root
local P26, P25, P24, P22 = root.Pass26, root.Pass25, root.Pass24, root.Pass22

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P27Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P27T"); d.CanCollide = d:GetAttribute("P27CC"); d.CanQuery = d:GetAttribute("P27CQ") end
		for _, a in ipairs({ "P27Hidden", "P27T", "P27CC", "P27CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P27Col") ~= nil then d.Color = d:GetAttribute("P27Col"); d.Material = Enum.Material[d:GetAttribute("P27Mat")]; d:SetAttribute("P27Col", nil); d:SetAttribute("P27Mat", nil) end
	if d:GetAttribute("P27SA") ~= nil then d.Color = d:GetAttribute("P27SA"); d:SetAttribute("P27SA", nil) end
	if d:GetAttribute("P27Map") ~= nil then d.ColorMap = d:GetAttribute("P27Map"); d:SetAttribute("P27Map", nil) end
	if d:GetAttribute("P27CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P27CF")) else d.CFrame = d:GetAttribute("P27CF") end
		d:SetAttribute("P27CF", nil)
	end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P27T") == nil then d:SetAttribute("P27T", d.Transparency); d:SetAttribute("P27CC", d.CanCollide); d:SetAttribute("P27CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P27Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P27Col") == nil then p:SetAttribute("P27Col", p.Color); p:SetAttribute("P27Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function saCol(sa, col) if sa:GetAttribute("P27SA") == nil then sa:SetAttribute("P27SA", sa.Color) end sa.Color = col end
local function saMap(sa, map) if sa:GetAttribute("P27Map") == nil then sa:SetAttribute("P27Map", sa.ColorMap) end sa.ColorMap = map end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P27CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P27CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function desat(c, s, v) local h, S, V = c:ToHSV(); return Color3.fromHSV(h, S * s, math.min(1, V * v)) end
local report = {}

-- ================================================================ item 1: leaf saturation. c4 top-half saturation 115 vs 86 (ref), c1 112 vs 97.
-- Proof (out/r27w/tint_c4.png): the kit leaves carry NO vertex colours (ae_kit.blend: no color attributes on K_Soft13P/15K/15Y/15B);
-- their colour is the SurfaceAppearance ColorMap (own leaf14 spray maps) x SurfaceAppearance.Color. Tinting the NPalm22 SA magenta
-- turned the palms magenta. So the "re-export" is a re-export of our own colour maps: tex/make_ae_tex27.py (sat x0.75, value x1.10),
-- uploaded with upload_image, plus the same HSV step on the palm SA tints (grey sprig map).
--LEAF27
local LEAF = {
	-- step a (leaf27, sat x0.75 val x1.10; uploaded on the Shadow PC): blue 95726694565328, gold 84250913055520, purple 119461620416566
	-- step b (leaf27b, sat x0.62 val x1.12; uploaded on the main PC): used
	map = { ["rbxassetid://118173022878419"] = "rbxassetid://121845655626185",  -- blue   -> leaf27b_spray_blue
		["rbxassetid://94449468583229"] = "rbxassetid://81552654586566",          -- gold   -> leaf27b_spray_gold
		["rbxassetid://108341914835015"] = "rbxassetid://104105154617661" },      -- purple -> leaf27b_spray_purple
	palmS = 0.55, palmV = 1.10,   -- K_Soft13P blue palm tints (38,98,240)/(95,165,255)
	keepR = 45,
	zMax = 0, xMin = -50,   -- and not the far NW (x < -50): p8/p7 see it from above and were losing their W blue (p8 sat 87->78, ref 103)     -- only the N half (z < 0: what c4/c1/p1/p5/c3 look at). The S/W/E views (p2/p6/p4/p3/p8) were already under the ref
	              -- saturation; desaturating everywhere took p2 86->82 (ref 99), p6 92->88 (112), p8 87->78 (103).   -- the notch crowns by the hero (radius < 45) keep their maps: p2 trees were (54,106,191) vs ref (46,102,208), a 9
}
do
	local nm, np = 0, 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("SurfaceAppearance") and not d:IsDescendantOf(P27) then
			local new = LEAF.map and LEAF.map[tostring(d.ColorMap)]
			local pp = d.Parent:IsA("BasePart") and d.Parent.Position
			if pp and LEAF.keepR and Vector3.new(pp.X, 0, pp.Z).Magnitude < LEAF.keepR then new = nil end
			local north = not (pp and ((LEAF.zMax and pp.Z >= LEAF.zMax) or (LEAF.xMin and pp.X < LEAF.xMin)))
			if not north then new = nil end
			if new then saMap(d, new); nm += 1 end
			if north and LEAF.palmS and d.Parent.Name:find("^K_Soft13P_leaf") then
				local h = d.Color:ToHSV()
				if h > 0.5 and h < 0.75 then saCol(d, desat(d.Color, LEAF.palmS, LEAF.palmV)); np += 1 end
			end
		end
	end
	table.insert(report, string.format("leaf27 maps %d palms %d", nm, np))
end
--ENDLEAF27

-- ================================================================ c4 frame edges: the corner pavilions' gold (K_Hero_goldLan) makes the gold
-- excess in c4 (edge bands x 0-242 / 1210-1452: gold sat 72/62 vs ref 21/6). The reference pavilion struts are pale silver with a thin
-- gold trim; ours are solid saturated gold. One mesh, so one colour: a paler, less saturated gold.
--GOLD27
local GOLD = { lanS = 0.6, lanV = 1.05 }
do
	local g = root.K_Hero:FindFirstChild("K_Hero_goldLan")
	if g and GOLD.lanS then recol(g, desat(g.Color, GOLD.lanS, GOLD.lanV)) end
	table.insert(report, "gold27 " .. tostring(g ~= nil))
end
--ENDGOLD27

-- ================================================================ item 2: giant tree crown (p2/p6). The Crown25 shell is opaque and its lit top
-- matches (91,149,133) vs (98,154,145) p2 box 592-596/58-62, but it is one smooth pale mass: it reads as fog. Freestyle from the p2/p6
-- pictures: the reference crown is 6-8 rounded lobes, dark shadow undersides, lit tops. Built from our own K_Fluffy_leaf lump (21x15x24),
-- scaled to 12-20 studs: a ring of dark lobes hanging under/around the shell's rim, plus lit lobes breaking the top outline.
--TREE27
local function lump(name, src, parent, pos, size, rotY, col)
	local c = src:Clone(); c.Name = name; c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
	c.Size = size; c.CFrame = CFrame.new(pos) * CFrame.Angles(0, rotY, 0); c.Color = col; c.Material = Enum.Material.SmoothPlastic
	c.Transparency = 0; c.Parent = parent; return c
end
local CROWN = { dark = rgb(48, 92, 74), mid = rgb(78, 132, 108), lit = rgb(118, 186, 138), nDark = 8, r = 30, y = -9 }
do
	local cl = P25:FindFirstChild("Crown25_leaf"); local src = kit and kit:FindFirstChild("K_Fluffy_leaf")
	local n = 0
	if cl and src and CROWN.nDark then
		local F = Instance.new("Folder"); F.Name = "Crown27"; F.Parent = P27
		local c0 = cl.Position
		for i = 1, CROWN.nDark do   -- dark lobes around the underside rim (an ellipse matching the 71x58 shell)
			local a = (i - 0.5) / CROWN.nDark * math.pi * 2
			local s = 14 + (i * 7) % 6
			local p = c0 + Vector3.new(math.cos(a) * CROWN.r, CROWN.y + (i % 2) * 3, math.sin(a) * CROWN.r * 0.8)
			lump("Crown27_dark", src, F, p, Vector3.new(s * 1.2, s * 0.8, s * 1.1), a, CROWN.dark); n += 1
		end
		for i = 1, 4 do             -- mid lobes on the flanks, lit lobes on top: break the smooth outline
			local a = i / 4 * math.pi * 2 + 0.4
			lump("Crown27_mid", src, F, c0 + Vector3.new(math.cos(a) * 34, -1, math.sin(a) * 26), Vector3.new(17, 13, 16), a, CROWN.mid); n += 1
			-- lit lobes only on the +x side: a lit lobe on the -x side covered the p2 sky box (762,22): 43 -> 74 off
			if math.cos(a + 0.8) > 0 then
				lump("Crown27_lit", src, F, c0 + Vector3.new(math.cos(a + 0.8) * 18, 12, math.sin(a + 0.8) * 15), Vector3.new(20, 14, 19), a, CROWN.lit); n += 1
			end
		end
	end
	table.insert(report, "crown27 " .. n)
end
--ENDTREE27

-- ================================================================ items 7/8/10 (colour only, measured by ratio rendered/set on the picked part):
-- gate side panels Pass9.K_Trip10_teal (40,140,140) renders (41,150,152) p2 642,302 -> glazed pale cyan (92,170,186) p2 ref 658,300;
-- Story ring Pass23.Portal23_silver (205,212,225) renders (157,162,197) p4 685,347 -> (123,145,204) p4 ref 676,297;
-- Raid brick Pass11.Raid11 (88,47,56) renders (134,98,106) c3 1362,272 -> red rock (195,68,73) c3 ref 1350,280;
-- lime fern Fern26 (118,165,58) renders (142,198,55) c2 872,557 -> (110,160,52) c2 ref 930,590.
--COL27
local COL = { panel = rgb(90, 159, 171), ring = rgb(161, 190, 233), raid = rgb(165, 14, 18), fern = rgb(91, 133, 47) }
do
	local n = 0
	local t = root.Pass9:FindFirstChild("K_Trip10_teal", true); if t and COL.panel then recol(t, COL.panel); n += 1 end
	local r = root.Pass23:FindFirstChild("Portal23_silver", true); if r and COL.ring then recol(r, COL.ring); n += 1 end
	local raid = root.Pass11:FindFirstChild("Raid11")
	if raid and COL.raid then
		for _, d in ipairs(raid:GetDescendants()) do
			if d:IsA("BasePart") and d.Material == Enum.Material.Brick and math.abs(d.Color.R * 255 - 88) < 3 and math.abs(d.Color.G * 255 - 47) < 3 then recol(d, COL.raid); n += 1 end
		end
	end
	local f26 = P26:FindFirstChild("Fern26")
	if f26 and COL.fern then
		for _, d in ipairs(f26:GetChildren()) do
			if d:IsA("BasePart") and math.abs(d.Color.R * 255 - 118) < 2 and math.abs(d.Color.G * 255 - 165) < 2 then recol(d, COL.fern); n += 1 end
		end
	end
	table.insert(report, "col27 " .. n)
end
--ENDCOL27

-- ================================================================ item 3 (part): translucent waterfalls off the N island edges (c3/c4/p1 show
-- 2-3 thin falls under the N islands in the reference, 30-60 studs tall, ~0.5 translucent, pale blue). Own K_Fall8_fall ribbon, one per
-- edge point: a downward raycast march from the plaza side finds the island's S lip, the fall hangs from it.
--FALL27
local FALL = { col = rgb(205, 232, 246), t = 0.35, pts = { { -85, 0.9 }, { 34, 1.0 }, { 72, 0.75 } }, h = 50, w = 6 }
do
	local src = kit and kit:FindFirstChild("K_Fall8_fall"); local isl = root.Pass24:FindFirstChild("Sky24") and root.Pass24.Sky24:FindFirstChild("Isl24_4")
	local n = 0
	if src and isl and FALL.pts then
		local F = Instance.new("Folder"); F.Name = "Fall27"; F.Parent = P27
		local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Include; prm.FilterDescendantsInstances = { isl }
		local saved = {}
		for _, d in ipairs(isl:GetDescendants()) do if d:IsA("BasePart") then saved[d] = d.CanQuery; d.CanQuery = d.Transparency < 0.5 and not d.Name:find("[Ff]all") end end
		for _, p in ipairs(FALL.pts) do
			for z = -170, -300, -2 do
				local r = workspace:Raycast(Vector3.new(p[1], 320, z), Vector3.new(0, -300, 0), prm)
				if r then
					local h = FALL.h * p[2]
					local c = src:Clone(); c.Name = "Fall27"; c.Anchored = true; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
					c.Size = Vector3.new(FALL.w, h, src.Size.Z * FALL.w / src.Size.X)
					c.CFrame = CFrame.new(p[1], r.Position.Y - 1 - h / 2, z + 1.5)
					c.Color = FALL.col; c.Material = Enum.Material.SmoothPlastic; c.Transparency = FALL.t; c.Parent = F
					n += 1; break
				end
			end
		end
		for d, v in pairs(saved) do d.CanQuery = v end
	end
	table.insert(report, "fall27 " .. n)
end
--ENDFALL27

-- ================================================================ item 3 (part): rounded canopy lumps on the N island's S lip (c4/c3/p1 see a smooth
-- pale shell; the reference island tops are soft round green tree lumps). Own K_Fluffy_leaf, 10-15 studs, yellow-green, sat on the
-- lip found by the same raycast march as the falls.
--ISL27
local ISL = { col = rgb(104, 152, 72), xs = { -66, -30, 4, 46, 88 } }
do
	local src = kit and kit:FindFirstChild("K_Fluffy_leaf"); local isl = root.Pass24:FindFirstChild("Sky24") and root.Pass24.Sky24:FindFirstChild("Isl24_4")
	local n = 0
	if src and isl and ISL.xs then
		local F = Instance.new("Folder"); F.Name = "Isl27"; F.Parent = P27
		local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Include; prm.FilterDescendantsInstances = { isl }
		local saved = {}
		for _, d in ipairs(isl:GetDescendants()) do if d:IsA("BasePart") then saved[d] = d.CanQuery; d.CanQuery = d.Transparency < 0.5 and not d.Name:find("[Ff]all") end end
		for i, x in ipairs(ISL.xs) do
			for z = -170, -300, -2 do
				local r = workspace:Raycast(Vector3.new(x, 320, z), Vector3.new(0, -300, 0), prm)
				if r then
					local s = 10 + (i * 3) % 6
					lump("Isl27_lump", src, F, Vector3.new(x, r.Position.Y + s * 0.25, z - s * 0.4), Vector3.new(s * 1.3, s * 0.9, s * 1.2), i * 1.3, ISL.col)
					n += 1; break
				end
			end
		end
		for d, v in pairs(saved) do d.CanQuery = v end
	end
	table.insert(report, "isl27 " .. n)
end
--ENDISL27

-- ================================================================ item 10: floor litter. The c1 red flakes on the floor are Planting.K_Litter at
-- (25,0,-13) (pick c1 1250,760). Only floor-level (y < 1) red/blue litter is hidden: the lime litter on the c2 floor stays, because
-- the recaptured c2 reference frame shows lime leaves on its floor too (bottom left).
--FLOOR27
do
	local n = 0
	for _, m in ipairs(root.Planting:GetChildren()) do
		if m.Name == "K_Litter" and m:GetPivot().Y < 1 then
			local l = m:FindFirstChild("K_Litter_leaf")
			if l and l.Color.G < l.Color.R * 1.2 + 0.01 and not (l.Color.G > l.Color.R and l.Color.G > l.Color.B) then hide(m); n += 1 end
		end
	end
	table.insert(report, "floor27 hidden " .. n)
end
--ENDFLOOR27

-- ================================================================ item 5: W half. Picks inside the p7 W metric box (x 0-450, y 100-700) land on the
-- Pass16.West16 lagoon trees (K_Soft15B, 56 trees, our blue leaf map), a sand disc and grass patches. Pass 26 tinted those trees with
-- Color and nothing moved (Color multiplies the map); here the MAP is swapped: every 3rd tree keeps blue, the others take our gold and
-- purple spray maps, so the W reads as mixed blue/purple/gold trees. S lawn: GroundS LeafyGrass (42,57,0) renders a dark noisy
-- (92,115,88) at p7 900,620 against bright grass (93,122,53): Grass material, brighter yellow-green.
--WEST27
local WEST = { maps = { nil, "rbxassetid://94449468583229", nil }, lawn = rgb(30, 58, 0), lawnMat = Enum.Material.Grass }
do
	local w16 = root.Pass16:FindFirstChild("West16"); local n = 0
	if w16 and WEST.maps then
		local trees = {}
		for _, d in ipairs(w16:GetChildren()) do if d.Name == "K_Soft15B" then table.insert(trees, d) end end
		table.sort(trees, function(a, b) local pa, pb = a:GetPivot().Position, b:GetPivot().Position; return pa.X + pa.Z * 0.37 < pb.X + pb.Z * 0.37 end)
		for i, t in ipairs(trees) do
			local mp = WEST.maps[(i - 1) % 3 + 1]
			if mp then
				for _, d in ipairs(t:GetDescendants()) do if d:IsA("SurfaceAppearance") then saMap(d, mp); n += 1 end end
			end
		end
	end
	local gs = root:FindFirstChild("GroundS")
	if gs and WEST.lawn then recol(gs, WEST.lawn, WEST.lawnMat) end
	table.insert(report, "west27 maps " .. n)
end
--ENDWEST27

-- ================================================================ item 4: stair joints. PROOF (out/r27w/tint_c4.png, tint_c2.png): with Stairs25_stone
-- red, _riser green, _joint blue, every tread pixel in c4/c2 is red = Stairs25_stone, and the blue joints DO show between 4.5-stud
-- blocks when tinted. Untinted they vanish: the 0.2 gap is ~2 px at grazing angle, the joint top sits 0.1 under the tread and is lit,
-- and the 0.08 chamfer gives no shading. Kit r27 (tools/ae_kit.py build_stairs27): rounded pillow edges (bevel 0.3) in their own
-- mesh, 0.3 gaps, ~3.4-stud blocks, the joint slab recessed 0.4 and behind the block fronts so it can be near-black without
-- changing the risers (the block fronts are now the risers).
--STAIR27
local STAIR = { tread = rgb(118, 122, 120), edge = rgb(100, 104, 103), riser = rgb(78, 90, 95), joint = rgb(48, 58, 66) }  -- riser box = Stairs27_riser (tint proof tint3): (54,65,73) rendered (53,70,84)
do
	local done = false
	if kit and kit:FindFirstChild("K_Stairs27_stone") then
		local F = Instance.new("Folder"); F.Name = "Stairs27"; F.Parent = P27
		for key, col in pairs({ stone = STAIR.tread, edge = STAIR.edge, riser = STAIR.riser, joint = STAIR.joint }) do
			local nm = "K_Stairs27_" .. key; local src = kit:FindFirstChild(nm)
			if src then
				local c = src:Clone(); c.Name = "Stairs27_" .. key; c.Anchored = true
				c.CanCollide = key ~= "joint"; c.CanQuery = key ~= "joint"; c.CastShadow = true
				local cc = C27[nm]; c.CFrame = CFrame.new(cc[1], cc[2], cc[3]); c.Color = col; c.Material = Enum.Material.SmoothPlastic
				c.Parent = F
			end
		end
		for _, n in ipairs({ "Stairs25_stone", "Stairs25_riser", "Stairs25_joint" }) do local p = P25:FindFirstChild(n); if p then hide(p) end end
		done = true
	end
	table.insert(report, "stair27 " .. tostring(done))
end
--ENDSTAIR27

return table.concat(report, "; ")
end
