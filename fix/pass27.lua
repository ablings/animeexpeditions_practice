-- pass27.lua (practice place only): freestyle pass 27 on top of the pass-26 build (notes/fix_brief27.md, verify24_plaza.md).
-- Run AFTER pass 26 (sh out/r26w/run.sh; then sh out/r27w/run.sh). Idempotent: new pieces live in Plaza.Pass27 (rebuilt each run);
-- every old piece pass 27 touches keeps its pre-pass-27 value in a P27* attribute and is restored first, so every run starts
-- from the pass-26 state. Attributes: P27Col/P27Mat (part colour/material), P27SA (SurfaceAppearance.Color), P27Map (ColorMap),
-- P27T/P27CC/P27CQ + P27Hidden (hidden parts), P27CF (moved parts/models).
-- Blocks: --LEAF27, --GOLD27, --STAIR27, --TREE27, --ISL27, --FALL27, --WEST27.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
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
	map = { ["rbxassetid://118173022878419"] = "rbxassetid://95726694565328",   -- blue   -> leaf27_spray_blue
		["rbxassetid://94449468583229"] = "rbxassetid://84250913055520",          -- gold   -> leaf27_spray_gold
		["rbxassetid://108341914835015"] = "rbxassetid://119461620416566" },      -- purple -> leaf27_spray_purple
	palmS = 0.75, palmV = 1.10,   -- K_Soft13P blue palm tints (38,98,240)/(95,165,255)
	keepR = 45,   -- the notch crowns by the hero (radius < 45) keep their maps: p2 trees were (54,106,191) vs ref (46,102,208), a 9
}
do
	local nm, np = 0, 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("SurfaceAppearance") and not d:IsDescendantOf(P27) then
			local new = LEAF.map and LEAF.map[tostring(d.ColorMap)]
			local pp = d.Parent:IsA("BasePart") and d.Parent.Position
			if pp and LEAF.keepR and Vector3.new(pp.X, 0, pp.Z).Magnitude < LEAF.keepR then new = nil end
			if new then saMap(d, new); nm += 1 end
			if LEAF.palmS and d.Parent.Name:find("^K_Soft13P_leaf") then
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

return table.concat(report, "; ")
end
