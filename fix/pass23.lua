-- pass23.lua (practice place only): freestyle pass 23 on top of the pass-22 build (notes/fix_brief23.md, verify20_plaza.md).
-- Run AFTER pass 22. Idempotent: new pieces live in Plaza.Pass23 (rebuilt each run); hidden old pieces get P23Hidden (old
-- transparency / CanCollide / CanQuery in P23T / P23CC / P23CQ); recoloured old pieces keep their pre-pass-23 colour/material in
-- P23Col / P23Mat; moved models keep P23CF / P23Sc.
-- Blocks: --FALL23, --GATE23, --PORTAL23, --RAID23, --STAIR23, --RUN23. Kit pieces (ae_kit_r23) are optional: every block has a
-- Studio-only fallback so the file also runs before the import.
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, NE, ME = Enum.Material.SmoothPlastic, Enum.Material.Neon, Enum.Material.Metal
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r23 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import
do
	local src = workspace:FindFirstChild("ae_kit_r23")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale23_stone", true)
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
-- bbox centres of the r23 pieces in their authored frame (kit/own/ae_kit_r23_centres.json): placement = origin + centre
local C23 = {
	K_Gate23_basin = { 0, 4.675, 0.5 }, K_Gate23_dark = { 0, 2.8, -3 }, K_Gate23_glass = { 0, 7.05, -3 }, K_Gate23_gold = { 0, 14.6, -1.621 },
	K_Gate23_pale = { 0, 10.4, -0.475 }, K_Gate23_swirl = { 0.529, 9.24, 3.95 }, K_Gate23_water = { 0, 5, 0.5 },
	K_Portal23_gem = { 0.9, 3.464, 0 }, K_Portal23_silver = { 0, 0.4, 0 }, K_Ribbon23_water = { 0.156, -20, -1.725 },
	K_Runner23_blue = { 0, 3.305, 0 }, K_Runner23_gem = { 0, 0.814, 0 }, K_Runner23_gold = { 0, 3.373, 0 }, K_Runner23_silver = { 0, 3.059, 0 },
	K_Stairs23_riser = { 0, 3, 0 }, K_Stairs23_stone = { 0, 3, 0 },
}
local old = root:FindFirstChild("Pass23"); if old then old:Destroy() end
local P23 = Instance.new("Folder"); P23.Name = "Pass23"; P23.Parent = root
local P22, P20, P16, P15, P14, P11, P9 = root.Pass22, root.Pass20, root.Pass16, root.Pass15, root.Pass14, root.Pass11, root.Pass9
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P23
	return p
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P23T") == nil then d:SetAttribute("P23T", d.Transparency); d:SetAttribute("P23CC", d.CanCollide); d:SetAttribute("P23CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P23Hidden", true)
		end
		if d:IsA("Decal") or d:IsA("Texture") then
			if d:GetAttribute("P23T") == nil then d:SetAttribute("P23T", d.Transparency) end
			d.Transparency = 1; d:SetAttribute("P23Hidden", true)
		end
		if d:IsA("ParticleEmitter") or d:IsA("PointLight") or d:IsA("SpotLight") then
			if d:GetAttribute("P23En") == nil then d:SetAttribute("P23En", d.Enabled) end
			d.Enabled = false; d:SetAttribute("P23Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P23Col") == nil then p:SetAttribute("P23Col", p.Color); p:SetAttribute("P23Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
	local sa = p:FindFirstChildOfClass("SurfaceAppearance")
	if sa then
		if p:GetAttribute("P23SACol") == nil then p:SetAttribute("P23SACol", sa.Color) end
		pcall(function() sa.Color = col end)
	end
end
-- restore everything pass 23 touched, so every run starts from the pass-22 state
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P23Hidden") then
		if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then d.Transparency = d:GetAttribute("P23T") end
		if d:IsA("BasePart") and d:GetAttribute("P23CC") ~= nil then d.CanCollide = d:GetAttribute("P23CC"); d.CanQuery = d:GetAttribute("P23CQ") end
		if d:GetAttribute("P23En") ~= nil then d.Enabled = d:GetAttribute("P23En") end
		d:SetAttribute("P23Hidden", nil)
	end
	if d:GetAttribute("P23Col") ~= nil then d.Color = d:GetAttribute("P23Col"); d.Material = Enum.Material[d:GetAttribute("P23Mat")] end
	if d:GetAttribute("P23SACol") ~= nil then local sa = d:FindFirstChildOfClass("SurfaceAppearance"); if sa then pcall(function() sa.Color = d:GetAttribute("P23SACol") end) end end
	if d:GetAttribute("P23TrOld") ~= nil then d.Transparency = d:GetAttribute("P23TrOld") end
	if d:GetAttribute("P23Em") then d.Color = d:GetAttribute("P23EmCol") end
	if d:GetAttribute("P23LCol") ~= nil then d.Color = d:GetAttribute("P23LCol"); d.Brightness = d:GetAttribute("P23LB"); d.Range = d:GetAttribute("P23LR") end
	if d:IsA("Model") and d:GetAttribute("P23Sc") ~= nil then d:ScaleTo(d:GetAttribute("P23Sc")); d:PivotTo(d:GetAttribute("P23CF")) end
end
local function settr(p, t) if p:GetAttribute("P23TrOld") == nil then p:SetAttribute("P23TrOld", p.Transparency) end; p.Transparency = t end
-- place a kit piece: origin CFrame o (position + yaw), centre from C23 rotated with it
local function kp(name, o, col, mat, parent, newName)
	local src = kit and kit:FindFirstChild(name); if not src then return nil end
	local c = src:Clone(); c.Name = newName or name:gsub("^K_", ""); c.Anchored = true; c.CanCollide = false; c.CanQuery = false
	local cc = C23[name]; c.CFrame = o * CFrame.new(cc[1], cc[2], cc[3])
	c.Color = col; c.Material = mat or SM; c.Parent = parent or P23
	return c
end
local function light(parent, pos, col, b, r)
	local a = part("Light23", Vector3.new(0.3, 0.3, 0.3), CFrame.new(pos), rgb(255, 255, 255), SM, parent)
	a.Transparency = 1; a.CanCollide = false; a.CanQuery = false
	local l = Instance.new("PointLight"); l.Color = col; l.Brightness = b; l.Range = r; l.Shadows = false; l.Parent = a
	return a, l
end
local report = {}

-- ================================================================ item 1: falls. The white fall sheets (Fall22 x 2, Fall16) read as
-- opaque columns, (220,228,232) p1 rep (735-739, 113-117). Target: a translucent curved ribbon (200,235,243) p1 ref (751-755, 138-142),
-- 5-6 wide, transparency ~0.4, with a mist puff at its foot. Kit r23: K_Ribbon23_water (6 x 40, cupped, lip curling over).
--FALL23
local FALL = { col = rgb(190, 250, 255), tr = 0.15, w = 6.0, mist = rgb(235, 245, 248), mistT = 0.55 }
do
	local F = Instance.new("Folder"); F.Name = "Fall23"; F.Parent = P23
	local srcs = {}
	for _, f in ipairs(P22.Sky22:GetChildren()) do if f.Name == "Fall22" then table.insert(srcs, f) end end
	local f16 = P16.IslSkirt16:FindFirstChild("Fall16"); if f16 then table.insert(srcs, f16) end
	local n = 0
	for _, f in ipairs(srcs) do
		local top = f.Position.Y + f.Size.Y / 2; local bot = f.Position.Y - f.Size.Y / 2; local H = f.Size.Y
		local x, z = f.Position.X, f.Position.Z
		if kit and kit:FindFirstChild("K_Ribbon23_water") then
			hide(f)
			local r = kp("K_Ribbon23_water", CFrame.new(x, top, z), FALL.col, SM, F, "Ribbon23")
			local cc = C23.K_Ribbon23_water
			r.Size = Vector3.new(r.Size.X * FALL.w / 6, H, r.Size.Z)
			r.CFrame = CFrame.new(x + cc[1], top - H / 2, z + cc[3])
			r.Transparency = FALL.tr; r.CastShadow = false
		else
			if f.Material ~= NE then recol(f, FALL.col, SM) else recol(f, FALL.col) end
			settr(f, FALL.tr)
		end
		-- mist puff at the foot: three soft balls
		for j, o in ipairs({ { 0, 0, 1.0 }, { -2.6, 1.2, 0.75 }, { 2.4, 0.6, 0.8 } }) do
			local s = (FALL.w * 1.6) * o[3]
			local b = part("Mist23", Vector3.new(s, s * 0.7, s), CFrame.new(x + o[1], bot + s * 0.25 + o[2], z + 1.5), FALL.mist, SM, F)
			b.Shape = Enum.PartType.Ball; b.Transparency = FALL.mistT + 0.1 * (j - 1); b.CanCollide = false; b.CanQuery = false; b.CastShadow = false
		end
		n += 1
	end
	table.insert(report, "fall23: " .. n .. (kit and kit:FindFirstChild("K_Ribbon23_water") and " ribbons" or " recoloured"))
end
--ENDFALL23

-- ================================================================ item 2a: Expeditions gate. Door (25,163,183) p6 rep (108-112, 298-302)
-- against a dark cloud-swirl door (3,121,134) p6 ref (128-132, 318-322). The pass-20 cloud stack in the door reads as a white
-- statue: hidden. Kit r23 (origin (0, 7, 84.5), front plane z 84.5): pale pilasters + archivolt, gold capitals / arch trim /
-- filigree crest, a lighter door swirl, two 8-stud lamp posts, crystal basins on the brazier tops.
--GATE23
local GATE = { door = rgb(0, 140, 150), doorMat = SM, pale = rgb(214, 232, 226), gold = rgb(205, 165, 70), swirl = rgb(30, 150, 160), swirlDz = -2.75, panel = true,
	dark = rgb(45, 52, 62), lamp = rgb(255, 225, 160), basin = rgb(200, 222, 218), water = rgb(90, 205, 230) }
do
	local F = Instance.new("Folder"); F.Name = "Gate23"; F.Parent = P23
	for _, d in ipairs(P20:GetChildren()) do
		if d.Name == "K_Cloud7_cloud" and math.abs(d.Position.X) < 3 and math.abs(d.Position.Z - 89) < 2 then hide(d) end
	end
	local t = P9.K_Trip10
	recol(t.K_Trip10_portal, GATE.door, GATE.doorMat)
	local o = CFrame.new(0, 7.0, 84.5); local np = 0
	for nm, spec in pairs({ pale = { GATE.pale, SM }, gold = { GATE.gold, ME }, swirl = { GATE.swirl, SM }, dark = { GATE.dark, ME },
		glass = { GATE.lamp, NE }, basin = { GATE.basin, SM }, water = { GATE.water, Enum.Material.Glass } }) do
		local p = kp("K_Gate23_" .. nm, o, spec[1], spec[2], F)
		if p then np += 1; if nm == "water" then p.Transparency = 0.2 end; if nm == "swirl" then p.CFrame = p.CFrame + Vector3.new(0, 0, GATE.swirlDz) end end
	end
	-- the statue is part of the K_Trip10_pale mesh: cover it with a door panel (block + round top) in front of it, z 86.0
	if GATE.panel then
		part("DoorPanel23", Vector3.new(10.8, 13.4, 0.3), CFrame.new(0, 6.5 + 13.4 / 2, 86.0), GATE.door, SM, F)
		local c = part("DoorTop23", Vector3.new(0.3, 10.8, 10.8), CFrame.new(0, 19.7, 86.0) * CFrame.Angles(0, math.pi / 2, 0), GATE.door, SM, F)
		c.Shape = Enum.PartType.Cylinder
	end
	if np > 0 then
		for _, x in ipairs({ -12.5, 12.5 }) do light(F, Vector3.new(x, 7.0 - 0.8 + 7.9, 84.5 - 3.0), GATE.lamp, 1.5, 10) end
	end
	table.insert(report, "gate23: kit pieces " .. np)
end
--ENDGATE23

-- ================================================================ item 2b: Story portal: the block ring (StoryFrame14 + StoryFrameRing14 +
-- K_Ring9) -> a smooth silver horseshoe with 7 blue gems (kit K_Portal23, origin = opening centre (-86.6, 16, 0), facing +X).
--PORTAL23
local PORT = { silver = rgb(205, 212, 225), gem = rgb(55, 120, 255) }
do
	local F = Instance.new("Folder"); F.Name = "Portal23"; F.Parent = P23
	if kit and kit:FindFirstChild("K_Portal23_silver") then
		for _, d in ipairs(P14:GetChildren()) do if d.Name == "StoryFrame14" or d.Name == "StoryFrameRing14" or d.Name == "StoryJamb14" then hide(d) end end
		local r9 = P9:FindFirstChild("K_Ring9"); if r9 then hide(r9) end
		local o = CFrame.new(-86.6, 16.0, 0)
		kp("K_Portal23_silver", o, PORT.silver, SM, F)
		kp("K_Portal23_gem", o, PORT.gem, NE, F)
		table.insert(report, "portal23 kit")
	end
end
--ENDPORTAL23

-- ================================================================ item 3: Raid red (targets re-baselined on the v20 frames).
-- skull p3 (720-724, 38-42) (218,118,98); haze p3 ref (598-602, 218-222) (206,118,105) measured at rep (618-622, 178-182);
-- tower c3 (1348-1352, 278-282) (225,86,89) on RaidGable; a red facade light; the "Raid" sign onto the gable over the door.
--RAID23
local RAID = { bone = rgb(215, 145, 105), light = { col = rgb(255, 90, 80), b = 5, r = 24 }, haze = rgb(215, 135, 120),
	gable = rgb(255, 40, 45), gableMat = SM, facade = { col = rgb(255, 60, 55), b = 3, r = 34 }, sign = { 153.0, 47.0, 0.2, 0.62 } }
do
	local F = Instance.new("Folder"); F.Name = "Raid23"; F.Parent = P23
	local sk = P15:FindFirstChild("K_Skull15")
	local bone = sk and sk:FindFirstChild("K_Skull15_bone")
	if bone and RAID.bone then recol(bone, RAID.bone) end
	local l22 = P22:FindFirstChild("SkullLight22"); local pl = l22 and l22:FindFirstChildOfClass("PointLight")
	if pl and RAID.light then
		if pl:GetAttribute("P23LCol") == nil then pl:SetAttribute("P23LCol", pl.Color); pl:SetAttribute("P23LB", pl.Brightness); pl:SetAttribute("P23LR", pl.Range) end
		pl.Color = RAID.light.col; pl.Brightness = RAID.light.b; pl.Range = RAID.light.r
	end
	local hz = P16:FindFirstChild("RaidHaze16"); local band = hz and hz:FindFirstChild("Band")
	if band and RAID.haze then
		if band:GetAttribute("P23Em") == nil then band:SetAttribute("P23Em", true); band:SetAttribute("P23EmCol", band.Color) end
		band.Color = ColorSequence.new(RAID.haze)
	end
	local r11 = P11:FindFirstChild("Raid11")
	if r11 then
		for _, d in ipairs(r11:GetChildren()) do if d:IsA("BasePart") and d.Name == "RaidGable" then recol(d, RAID.gable, RAID.gableMat) end end
		if RAID.facade then light(F, Vector3.new(140, 30, 0), RAID.facade.col, RAID.facade.b, RAID.facade.r) end
		local sg = r11:FindFirstChild("K_TxtRaid9")
		if sg and RAID.sign then
			if sg:GetAttribute("P23Sc") == nil then sg:SetAttribute("P23Sc", sg:GetScale()); sg:SetAttribute("P23CF", sg:GetPivot()) end
			sg:ScaleTo(sg:GetAttribute("P23Sc") * RAID.sign[4])
			local bcf = sg:GetBoundingBox()
			sg:PivotTo(sg:GetPivot() + (Vector3.new(RAID.sign[1], RAID.sign[2], RAID.sign[3]) - bcf.Position))
		end
	end
	table.insert(report, "raid23 ok")
end
--ENDRAID23

-- ================================================================ item 4: stairs. 7 risers (projection of v20_c4_ref, see fix23_plaza.md) of
-- long slabs with a 0.15 chamfer (kit K_Stairs23); tread (186,191,185) c4 ref (398-402, 688-692).
--STAIR23
local STAIR = { tread = rgb(130, 133, 128), mat = Enum.Material.Slate }
do
	local s22, r22 = P22:FindFirstChild("Stairs22_stone"), P22:FindFirstChild("Stairs22_riser")
	if kit and kit:FindFirstChild("K_Stairs23_stone") and s22 then
		local a = kp("K_Stairs23_stone", CFrame.new(), STAIR.tread or s22.Color, STAIR.mat or s22.Material, P23, "Stairs23_stone"); a.CanCollide = true; a.CanQuery = true
		local r = kp("K_Stairs23_riser", CFrame.new(), r22.Color, r22.Material, P23, "Stairs23_riser")
		hide(s22); hide(r22)
		table.insert(report, "stair23 kit")
	elseif s22 and STAIR.tread then recol(s22, STAIR.tread); table.insert(report, "stair23 recolour") end
end
--ENDSTAIR23

-- ================================================================ item 5: runners. Rims (246,245,243) p5 rep (283-287, 478-482) against gold
-- (156,141,39) p5 ref (260-264, 498-502). Kit r23: one ramp per flight (rounded foot, gold rim, big low Y, one gem) replaces the
-- Runner22 slab and the K_Stairs runner (blue, navy, gold, white, glass).
--RUN23
local RUN = { silver = rgb(170, 172, 178), gold = rgb(94, 79, 5), goldMat = SM, face = rgb(58, 82, 160), gem = rgb(90, 220, 240), rimOld = rgb(94, 79, 5) }
do
	local ks = root.K_Stairs
	if kit and kit:FindFirstChild("K_Runner23_silver") then
		for _, nm in ipairs({ "K_Stairs_blue", "K_Stairs_navy", "K_Stairs_gold", "K_Stairs_white", "K_Stairs_glass" }) do hide(ks[nm]) end
		for _, nm in ipairs({ "silver", "gold", "blue", "gem" }) do local p = P22:FindFirstChild("Runner22_" .. nm); if p then hide(p) end end
		local s = kp("K_Runner23_silver", CFrame.new(), RUN.silver, SM, P23, "Runner23_silver"); s.CanCollide = true; s.CanQuery = true
		kp("K_Runner23_gold", CFrame.new(), RUN.gold, RUN.goldMat, P23, "Runner23_gold")
		kp("K_Runner23_blue", CFrame.new(), RUN.face, SM, P23, "Runner23_blue")
		local g = kp("K_Runner23_gem", CFrame.new(), RUN.gem, NE, P23, "Runner23_gem"); g.Transparency = 0.2
		table.insert(report, "run23 kit")
	elseif RUN.rimOld then recol(ks.K_Stairs_white, RUN.rimOld, RUN.goldMat); table.insert(report, "run23 rims") end
end
--ENDRUN23

-- ================================================================ item 8: tunnel. The pass-22 TunnelFill22 light (150,235,185) b 2.2 turned the
-- K_Arch20_stone tunnel wall teal (95,160,147) c1 rep (898-902, 428-432); target slate (44,54,62) c1 ref (878-882, 468-472).
--ARCH23
local ARCH = { col = rgb(150, 170, 140), b = 0.45, r = 9 }
do
	local n = 0
	local a22 = P22:FindFirstChild("Arch22")
	if a22 then for _, d in ipairs(a22:GetDescendants()) do
		if d:IsA("PointLight") and d.Parent.Name == "TunnelFill22" then
			if d:GetAttribute("P23LCol") == nil then d:SetAttribute("P23LCol", d.Color); d:SetAttribute("P23LB", d.Brightness); d:SetAttribute("P23LR", d.Range) end
			d.Color = ARCH.col; d.Brightness = ARCH.b; d.Range = ARCH.r; n += 1
		end
	end end
	table.insert(report, "arch23 lights " .. n)
end
--ENDARCH23

return table.concat(report, " | ") .. " | Plaza " .. #root:GetDescendants()
end
