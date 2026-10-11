-- pass26.lua (practice place only): freestyle pass 26 on top of the pass-25 build (notes/fix_brief26.md, verify23_plaza.md).
-- Run AFTER pass 25 (sh out/r24w/run.sh; sh out/r25w/run.sh; then sh out/r26w/run.sh). Idempotent: new pieces live in Plaza.Pass26
-- (rebuilt each run); hidden old pieces get P26Hidden (old transparency etc. in P26T / P26CC / P26CQ); recoloured old pieces keep their
-- pre-pass-26 colour/material in P26Col / P26Mat; moved pieces keep their pre-pass-26 CFrame/pivot in P26CF. Everything is restored
-- first, so every run starts from the pass-25 state.
-- Blocks: --SKY26, --STAIR26, --ISL26, --TREE26, --FERN26, --WEST26, --RUN26. Kit pieces: none new (the fern re-uses K_Fern25_leaf).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, SL = Enum.Material.SmoothPlastic, Enum.Material.Slate
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
local old = root:FindFirstChild("Pass26"); if old then old:Destroy() end
local P26 = Instance.new("Folder"); P26.Name = "Pass26"; P26.Parent = root
local P25, P24, P22, P19 = root.Pass25, root.Pass24, root.Pass22, root.Pass19
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P26T") == nil then d:SetAttribute("P26T", d.Transparency); d:SetAttribute("P26CC", d.CanCollide); d:SetAttribute("P26CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P26Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P26Col") == nil then p:SetAttribute("P26Col", p.Color); p:SetAttribute("P26Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P26CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P26CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P26Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P26T"); d.CanCollide = d:GetAttribute("P26CC"); d.CanQuery = d:GetAttribute("P26CQ") end
		d:SetAttribute("P26Hidden", nil); d:SetAttribute("P26T", nil); d:SetAttribute("P26CC", nil); d:SetAttribute("P26CQ", nil)
	end
	if d:GetAttribute("P26Col") ~= nil then d.Color = d:GetAttribute("P26Col"); d.Material = Enum.Material[d:GetAttribute("P26Mat")]; d:SetAttribute("P26Col", nil); d:SetAttribute("P26Mat", nil) end
	if d:GetAttribute("P26CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P26CF")) else d.CFrame = d:GetAttribute("P26CF") end
		d:SetAttribute("P26CF", nil)
	end
end
local report = {}

-- ================================================================ item 1: own skybox, paler and cloudier. p2 sky (60,196,240) rep ->
-- pale hazy blue with cloud (172,215,236) ref, box 760-764/20-24. tex/make_ae_tex26.py variant d (haze to ~10 deg, azure clear sky,
-- dense low cumulus), uploaded with upload_image. The pass-12 ids stay recorded in fix/fix_lighting.lua.
--SKY26
local SKY = { Up = 86697674728745, Dn = 76842875409340, Ft = 94655773202113, Bk = 132148118311790, Lf = 97641134518184, Rt = 132849943400915 }
do
	local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
	if sky and SKY then for k, id in pairs(SKY) do sky["Skybox" .. k] = "rbxassetid://" .. id end end
	table.insert(report, "sky26")
end
--ENDSKY26

-- ================================================================ item 4: stair stone. The visible riser faces in c4 are the FRONT faces of
-- Stairs25_joint (checked by tinting: joint red -> c4 riser box (400-404,505-509) read (255,43,45); Stairs25_riser red only showed thin
-- nose lines). So the riser colour is the joint colour: (70,85,95) rendered (109,137,149); target (85,103,115) c4 ref 428-432/646-650.
-- The Stairs25_riser mesh (chamfers / noses) becomes the tread-edge highlight.
--STAIR26
local STAIR = { joint = rgb(54, 65, 73), nose = rgb(168, 172, 166) }
do
	local j, r = P25:FindFirstChild("Stairs25_joint"), P25:FindFirstChild("Stairs25_riser")
	if j and STAIR.joint then recol(j, STAIR.joint) end
	if r and STAIR.nose then recol(r, STAIR.nose) end
	table.insert(report, "stair26 " .. tostring(j ~= nil) .. "/" .. tostring(r ~= nil))
end
--ENDSTAIR26

-- ================================================================ item 2: islands. Canopy (147,171,150) c3 rep 40-44/60-64 -> yellow-green
-- (152,192,134) c3 ref 150-154/100-104 (the rep box lands on Isl24_4's cap tree K_Soft14C_leaf); the mass above the Summon (189,200,199)
-- c4 rep 640-644/80-84 (Sky22 aqueduct K_Aque9_white) -> (152,162,159) c4 ref 700-704/60-64. Grey undersides in the frame corners of
-- p1/p2/p3 are the four old Islands.K_Isl91 at the diagonals: pushed out and down. Isl24_3 sits right behind the crown in p2: moved W.
--ISL26
local ISL = {
	cap = rgb(185, 255, 70), capRim = rgb(200, 238, 150), capPad = nil,        -- leaf only: the p1 band (618-622,28-32) sits on the
	-- same tree's leafPad and matched pale in round 23, so pads keep their pass-25 colour
	aque = rgb(108, 114, 110),                                                                -- Sky22 aqueduct above the Summon
	cornerOut = 60, cornerDown = 25,                                                          -- Islands.K_Isl91 at the diagonals
	isl3dx = -60,                                                                             -- Isl24_3 (behind the p2 crown)
}
do
	local n = 0
	local S24, S25 = P24:FindFirstChild("Sky24"), P25:FindFirstChild("Sky25")
	local function capCol(m)
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") then
				local tok = d.Name:match("_(%a+)$")
				if tok == "leaf" and ISL.cap then recol(d, ISL.cap); n += 1
				elseif tok == "leafPad" and ISL.capPad then recol(d, ISL.capPad)
				elseif tok == "leafRim" and ISL.capRim then recol(d, ISL.capRim) end
			end
		end
	end
	if S24 then for _, m in ipairs(S24:GetChildren()) do if m.Name:find("^Isl24_") then capCol(m) end end end
	if S25 then for _, m in ipairs(S25:GetChildren()) do if m.Name == "IslFringe25" then capCol(m) end end end
	local S22 = P22:FindFirstChild("Sky22"); local aq = S22 and S22:FindFirstChild("Aque22")
	if aq and ISL.aque then for _, d in ipairs(aq:GetDescendants()) do if d:IsA("BasePart") and d.Name:find("_white$") then recol(d, ISL.aque) end end end
	local nc = 0
	for _, m in ipairs(root.Islands:GetChildren()) do
		if m.Name == "K_Isl91" and ISL.cornerOut then
			local p = m:GetPivot().Position
			if math.abs(p.X) > 120 and math.abs(p.Z) > 120 then
				local dir = Vector3.new(p.X, 0, p.Z).Unit
				moveTo(m, function(cf) return cf + dir * ISL.cornerOut + Vector3.new(0, -ISL.cornerDown, 0) end); nc += 1
			end
		end
	end
	local i3 = S24 and S24:FindFirstChild("Isl24_3")
	if i3 and ISL.isl3dx then
		moveTo(i3, function(cf) return cf + Vector3.new(ISL.isl3dx, 0, 0) end)
		-- its Sky25 dressing (fringe + ruins) stands near it: move what lies within its footprint too
		local c3 = i3:GetAttribute("P26CF").Position
		if S25 then for _, m in ipairs(S25:GetChildren()) do
			if m:IsA("Model") then local q = m:GetPivot().Position
				if q.Z > 340 and math.abs(q.X - c3.X) < 120 then moveTo(m, function(cf) return cf + Vector3.new(ISL.isl3dx, 0, 0) end) end end
		end end
	end
	table.insert(report, string.format("isl26 caps %d corners %d", n, nc))
end
--ENDISL26

-- ================================================================ item 3: giant tree crown darker and more saturated than the islands behind
-- it: shadow sides (80,140,110), lit tops (100,156,146) p2 ref 592-596/58-62.
--TREE26
local TREE = { leaf = rgb(118, 186, 138), rim = rgb(148, 206, 166) }
do
	local l, r = P25:FindFirstChild("Crown25_leaf"), P25:FindFirstChild("Crown25_rim")
	if l and TREE.leaf then recol(l, TREE.leaf); l.Transparency = 0 end
	if r and TREE.rim then recol(r, TREE.rim); r.Transparency = 0 end
	table.insert(report, "tree26 " .. tostring(l ~= nil))
end
--ENDTREE26

-- ================================================================ item 5: ferns ~60 % size and flatter (a spray, not a cone), lighter
-- (63,132,18) c2 rep 900-904/500-504 -> (114,166,54) c2 ref 928-932/588-592; zone colours on the stair edges (blue W/N, red E); the flat
-- c1 floor splats (Pass19 K_Splat17) are hidden and replaced by a blue and a red clump on those stair feet.
--FERN26
local FERN = { lime = rgb(118, 165, 58), blue = rgb(60, 110, 215), red = rgb(200, 60, 52), h = 0.8, v = 0.5,
	centre = { 0.154, 0.968, -0.015 } }
do
	local F = Instance.new("Folder"); F.Name = "Fern26"; F.Parent = P26
	local f25 = P25:FindFirstChild("Fern25")
	local src = kit and kit:FindFirstChild("K_Fern25_leaf")
	local n = 0
	if f25 and src then
		hide(f25)
		local L = {}
		for _, fl in ipairs({ { 0, -1, "blue" }, { 1, 0, "red" }, { 0, 1, "lime" }, { -1, 0, "blue" } }) do
			local fx, fz = fl[1], fl[2]; local lx, lz = -fz, fx
			for _, sd in ipairs({ -1, 1 }) do
				table.insert(L, { fx * 28.6 + lx * sd * 7.6, fz * 28.6 + lz * sd * 7.6, "lime", 1.5 })
				table.insert(L, { fx * 32.0 + lx * sd * 16.5, fz * 32.0 + lz * sd * 16.5, fl[3], 1.2 })
			end
		end
		-- the c1 splat spots (NE corner): blue on the N flight's E foot, red on the E flight's N foot
		table.insert(L, { 14.5, -26.5, "blue", 1.3 }); table.insert(L, { 26.5, -14.5, "red", 1.3 })
		for i, f in ipairs(L) do
			local y = 6.2
			local ray = workspace:Raycast(Vector3.new(f[1], 40, f[2]), Vector3.new(0, -60, 0))
			if ray then y = ray.Position.Y end
			local s, cc = f[4], FERN.centre
			local c = src:Clone(); c.Name = "Fern26"; c.Anchored = true; c.CanCollide = false; c.CanQuery = false
			c.Size = Vector3.new(src.Size.X * s * FERN.h, src.Size.Y * s * FERN.v, src.Size.Z * s * FERN.h)
			c.CFrame = CFrame.new(f[1], y, f[2]) * CFrame.Angles(0, i * 2.1, 0) * CFrame.new(cc[1] * s * FERN.h, cc[2] * s * FERN.v, cc[3] * s * FERN.h)
			c.Color = FERN[f[3]]; c.Material = SM; c.Parent = F
			n += 1
		end
	end
	local ns = 0
	for _, d in ipairs(P19:GetChildren()) do if d:IsA("BasePart") and d.Name:find("^K_Splat17") then hide(d); ns += 1 end end
	table.insert(report, string.format("fern26 %d splats hidden %d", n, ns))
end
--ENDFERN26

-- ================================================================ item 7: W canopy reads as one blue mass (p7 W blue 25.5 % vs 15.1 ref,
-- p8 45.0 vs 43.0). The West16 lagoon trees (K_Soft15B, vertex-coloured blue; Color multiplies the vertex colour) get alternating
-- multipliers so the W becomes mixed: every 3rd stays blue, the others go dark green or gold-green.
--WEST26
-- TESTED and switched off: 188 leaf parts tinted, p7 W blue 25.5 -> 25.8 (no effect: the W box is filled by Trees13/StoryCanopy16,
-- not the lagoon trees). Set tints = { nil, rgb(170, 235, 120), rgb(255, 230, 110) } to re-test.
local WEST = { tints = nil }
do
	local W16 = root.Pass16:FindFirstChild("West16"); local n, k = 0, 0
	if W16 and WEST.tints then
		for _, m in ipairs(W16:GetChildren()) do
			if m.Name == "K_Soft15B" then
				k += 1
				local t = WEST.tints[(k % #WEST.tints) + 1]
				if t then for _, d in ipairs(m:GetChildren()) do
					if d:IsA("BasePart") and (d.Name:find("_leaf$") or d.Name:find("_leafRim$")) then recol(d, t); n += 1 end
				end end
			end
		end
	end
	table.insert(report, "west26 " .. n)
end
--ENDWEST26

-- ================================================================ item 6 (colour only): runner rim gold (162,140,40) c4 rep 560-564/564-568
-- -> (183,175,89) c4 ref 638-642/558-562.
--RUN26
local RUN = { rim = rgb(110, 104, 50) }   -- (118,108,40) read (197,182,70)
do
	local r = P24:FindFirstChild("Runner24_rim"); if r and RUN.rim then recol(r, RUN.rim) end
	table.insert(report, "run26 " .. tostring(r ~= nil))
end
--ENDRUN26

return table.concat(report, " | ") .. " | Plaza " .. #root:GetDescendants()
end
