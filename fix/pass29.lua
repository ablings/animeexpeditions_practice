-- pass29.lua (practice place only): freestyle pass 29 on top of the pass-28 build (notes/fix_brief29.md, verify26_plaza.md).
-- Run AFTER pass 28 (sh out/r28w/run.sh; then sh out/r29w/run.sh). Idempotent: new pieces live in Plaza.Pass29 (rebuilt each run);
-- every old piece pass 29 touches keeps its pre-pass-29 value in a P29* attribute and is restored first.
-- Attributes: P29Col/P29Mat, P29T/P29CC/P29CQ + P29Hidden, P29CF, P29Size.
-- Blocks: --JET29, --NOTCH29, --ORB29, --SKY29, --STORY29, --SUMMON29, --KIT29 (needs kit r29).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r29 kit merge (same as the IMPORTS loop of build_plaza.lua), so this file also runs alone right after the import.
-- Pass 28 learned that several parts can share a name: every same-named old kit piece is removed, not just the first.
do
	local src = workspace:FindFirstChild("ae_kit_r29")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale29_stone", true)
		local sc = ref and ref.Size.X / 10.0 or 1
		for _, d in ipairs(src:GetDescendants()) do
			if d:IsA("MeshPart") then
				d.Size = d.Size / sc
				d.CFrame = CFrame.new(d.Position / sc) * (d.CFrame - d.CFrame.Position)
				d.Anchored = true
				for _, o in ipairs(kit:GetChildren()) do if o.Name == d.Name then o:Destroy() end end
				if d.Name:sub(1, 7) == "K_Scale" then d:Destroy() else d.Parent = kit end
			end
		end
		src:Destroy()
	end
end
local old = root:FindFirstChild("Pass29"); if old then old:Destroy() end
local P29 = Instance.new("Folder"); P29.Name = "Pass29"; P29.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P29Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P29T"); d.CanCollide = d:GetAttribute("P29CC"); d.CanQuery = d:GetAttribute("P29CQ") end
		for _, a in ipairs({ "P29Hidden", "P29T", "P29CC", "P29CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P29Col") ~= nil then d.Color = d:GetAttribute("P29Col"); d.Material = Enum.Material[d:GetAttribute("P29Mat")]; d:SetAttribute("P29Col", nil); d:SetAttribute("P29Mat", nil) end
	if d:GetAttribute("P29Size") ~= nil then d.Size = d:GetAttribute("P29Size"); d:SetAttribute("P29Size", nil) end
	if d:GetAttribute("P29CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P29CF")) else d.CFrame = d:GetAttribute("P29CF") end
		d:SetAttribute("P29CF", nil)
	end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P29T") == nil then d:SetAttribute("P29T", d.Transparency); d:SetAttribute("P29CC", d.CanCollide); d:SetAttribute("P29CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P29Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P29Col") == nil then p:SetAttribute("P29Col", p.Color); p:SetAttribute("P29Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P29Size") == nil then p:SetAttribute("P29Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P29CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P29CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P29; return p
end
-- clone a kit MeshPart, scaled about the kit origin, at cf (kit space -> cf); SurfaceAppearance removed so Color shows
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P29; return c
end
local report = {}

-- ================================================================ item 1: fountain jets. The pass-20 K_Splash20_water mushroom (120,205,235)
-- T 0.15 reads opaque pale blue (136,216,233) at c1 640,350; the reference is a translucent dark-teal glowing stream (66,121,140).
-- A 1.1-stud column at T 0.45 (110,190,220), a 0.3 Neon core (200,245,255), a soft spray emitter and a PointLight (range 8).
--JET29
local JET = { w = 1.3, h = 2.2, col = rgb(80, 150, 180), t = 0.45, core = rgb(200, 245, 255), coreT = 0.8, cap = 2.6, light = rgb(120, 210, 240) }
do
	local n = 0
	local F = Instance.new("Folder"); F.Name = "Jet29"; F.Parent = P29
	for _, d in ipairs(root.Pass20:GetChildren()) do
		if d.Name == "K_Splash20_water" and d:IsA("BasePart") then
			hide(d)
			local x, z = math.sign(d.Position.X) * 23.41, math.sign(d.Position.Z) * 23.41
			-- pedestal top under the jet: march down from just under the notch (y 8.6), ignoring water and hidden parts
			local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { d, P29 }
			local r = workspace:Raycast(Vector3.new(x, 8.6, z), Vector3.new(0, -12, 0), prm)
			local y0 = r and r.Position.Y or 4.6
			local cf = CFrame.new(x, y0 + JET.h / 2, z) * CFrame.Angles(0, 0, math.rad(90))
			local s = part("Jet29", Vector3.new(JET.h, JET.w, JET.w), cf, JET.col, SM, F, Enum.PartType.Cylinder)
			s.Transparency = JET.t; s.CanCollide = false; s.CanQuery = false; s.CastShadow = false
			local c = part("JetCore29", Vector3.new(JET.h - 0.4, 0.3, 0.3), cf * CFrame.new(-0.2, 0, 0), JET.core, Enum.Material.Neon, F, Enum.PartType.Cylinder)
			c.Transparency = JET.coreT; c.CanCollide = false; c.CanQuery = false; c.CastShadow = false
			local cap = part("JetCap29", Vector3.new(JET.cap, JET.cap * 0.6, JET.cap), CFrame.new(x, y0 + JET.h + 0.1, z), JET.col, SM, F, Enum.PartType.Ball)
			cap.Transparency = 0.7; cap.CanCollide = false; cap.CanQuery = false; cap.CastShadow = false
			cap.Color = rgb(170, 225, 240)
			local froth = part("JetFroth29", Vector3.new(1.8, 1.3, 1.8), CFrame.new(x, y0 + JET.h + 0.6, z), rgb(225, 247, 255), SM, F, Enum.PartType.Ball)
			froth.Transparency = 0.6; froth.CanCollide = false; froth.CanQuery = false; froth.CastShadow = false
			local a = Instance.new("Attachment"); a.Position = Vector3.new(0, 0.3, 0); a.Parent = cap
			local pe = Instance.new("ParticleEmitter")
			pe.Color = ColorSequence.new(rgb(215, 245, 255), rgb(150, 215, 240))
			pe.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) })
			pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 0.9) })
			pe.Lifetime = NumberRange.new(0.6, 1.0); pe.Rate = 30; pe.Speed = NumberRange.new(3, 5); pe.SpreadAngle = Vector2.new(25, 25)
			pe.Acceleration = Vector3.new(0, -14, 0); pe.LightEmission = 0.4; pe.EmissionDirection = Enum.NormalId.Top; pe.Parent = a
			local l = Instance.new("PointLight"); l.Color = JET.light; l.Range = 8; l.Brightness = 0.5; l.Shadows = false; l.Parent = s
			n += 1
		end
	end
	table.insert(report, "jet29 " .. n)
end
--ENDJET29

-- ================================================================ item 1b: arch notch. Three dark NotchPod22 balls and a stick trunk + plank; the reference has a
-- small twisted tree with green and blue leaf clumps rising out of the notch. Trunk: 7 tapering cylinder segments on a helix
-- (r 0.35, 75 deg per segment) leaning out of the notch; 3 clumps of our own K_FluffyS_leaf, 2 green (90,150,60), 1 blue (40,90,220).
--NOTCH29
local NT = { segs = 7, segL = 0.95, r = 0.35, w0 = 0.65, w1 = 0.3, bark = rgb(96, 72, 52), green = rgb(90, 150, 60), blue = rgb(40, 90, 220), leafK = 0.32 }
do
	local n = 0
	local A = root.Pass22:FindFirstChild("Arch22")
	local F = Instance.new("Folder"); F.Name = "Notch29"; F.Parent = P29
	if A then
		for _, d in ipairs(A:GetChildren()) do
			if d.Name == "NotchPod22" or d.Name == "NotchTrunk22" or d.Name == "NotchBranch22" or d.Name == "NotchCrown22" then hide(d) end
		end
		for _, fl in ipairs(A:GetChildren()) do
			if fl.Name == "NotchFloor22" then
				local sx, sz = math.sign(fl.Position.X), math.sign(fl.Position.Z)
				local out = Vector3.new(sx, 0, sz).Unit
				local p = fl.Position + Vector3.new(0, fl.Size.Y / 2, 0) + out * 0.2
				local ang0 = math.atan2(sz, sx)
				local prev = p
				for i = 1, NT.segs do
					local u = i / NT.segs
					local a = ang0 + i * math.rad(75)
					local nxt = p + Vector3.new(math.cos(a) * NT.r, i * NT.segL, math.sin(a) * NT.r) + out * (u * u * 1.6)
					local mid, len = (prev + nxt) / 2, (nxt - prev).Magnitude
					local w = NT.w0 + (NT.w1 - NT.w0) * u
					local s = part("Trunk29", Vector3.new(len + w * 0.5, w, w), CFrame.lookAt(mid, nxt) * CFrame.Angles(0, math.rad(90), 0), NT.bark, Enum.Material.Wood, F, Enum.PartType.Cylinder)
					s.CanCollide = false
					prev = nxt
				end
				local top = prev
				local side = Vector3.new(-sz, 0, sx).Unit
				for j, o in ipairs({ { side * 1.4 + Vector3.new(0, -0.6, 0), NT.green, 1.0 }, { -side * 1.5 + Vector3.new(0, -0.2, 0), NT.blue, 0.9 }, { out * 0.6 + Vector3.new(0, 0.8, 0), NT.green, 1.15 } }) do
					local c = kp("K_FluffyS_leaf", CFrame.new(top + o[1] - Vector3.new(0, 2.6 * NT.leafK * o[3], 0)) * CFrame.Angles(0, j * 2.1 + ang0, 0), NT.leafK * o[3], o[2], SM, F, "Leaf29")
					if c then c.CanCollide = false; c.CastShadow = false end
				end
				n += 1
			end
		end
	end
	table.insert(report, "notch29 " .. n)
end
--ENDNOTCH29

-- ================================================================ item 3: Expeditions orb. p2: the orb (0,47,90) sits in front of the crown trunk
-- (Tree24_bark at x 15). Move the crown tree 25 studs E (+x = screen left in p2), thicken the 8 crescents x1.4 on a 1.25x radius,
-- retint (130,138,155).
--ORB29
local ORB = { ringCol = rgb(185, 190, 202), bandDrop = 50, dx = 40, orbMove = Vector3.new(-8, 4, 0), cresK = 1.4, cresR = 1.25, cres = rgb(130, 138, 155), centre = Vector3.new(0, 46.5, 90) }
do
	local n, m = 0, 0
	local mv = {}
	local s24 = root.Pass24:FindFirstChild("Sky24")
	for _, nm in ipairs({ "Tree24_bark", "Tree24_crown", "Tree24_crownRim" }) do local p = s24 and s24:FindFirstChild(nm); if p then table.insert(mv, p) end end
	for _, nm in ipairs({ "Crown25_leaf", "Crown25_rim" }) do local p = root.Pass25:FindFirstChild(nm); if p then table.insert(mv, p) end end
	local c27 = root.Pass27:FindFirstChild("Crown27")
	for _, p in ipairs(c27 and c27:GetChildren() or {}) do if p:IsA("BasePart") then table.insert(mv, p) end end
	for _, p in ipairs(mv) do moveTo(p, function(b) return b + Vector3.new(ORB.dx, 0, 0) end); n += 1 end
	local ring = root.Landmarks:FindFirstChild("K_ExpRing8")
	if ring then moveTo(ring, function(b) return b + ORB.orbMove end) end
	local cr = root.Pass28:FindFirstChild("Cres28")
	for _, p in ipairs(cr and cr:GetChildren() or {}) do
		if p:IsA("BasePart") then
			resize(p, (p:GetAttribute("P29Size") or p.Size) * ORB.cresK)
			moveTo(p, function(b) return CFrame.new(ORB.centre + ORB.orbMove + (b.Position - ORB.centre) * ORB.cresR) * (b - b.Position) end)
			recol(p, ORB.cres); m += 1
		end
	end
	-- the outer K_ExpRing8 crescents render dark purple (101,110,137) in Slate: lighter smooth stone toward (130,138,155) rendered
	for _, d in ipairs(ring and ring:GetDescendants() or {}) do
		if d:IsA("BasePart") and d.Name == "K_ExpRing8_stone" then recol(d, ORB.ringCol, SM) end
	end
	-- the pale island band behind the orb (p2 y 60-230): Sky24 Isl24_3, the south K_Isl92 and the Sky25 south fringe/ruins down 50
	local band = {}
	if s24 and s24:FindFirstChild("Isl24_3") then table.insert(band, s24.Isl24_3) end
	for _, m in ipairs(root.Islands:GetChildren()) do if m.Name == "K_Isl92" and m:IsA("Model") and m:GetPivot().Position.Z > 200 then table.insert(band, m) end end
	local s25 = root.Pass25:FindFirstChild("Sky25")
	for _, m in ipairs(s25 and s25:GetChildren() or {}) do if m:IsA("Model") and m:GetPivot().Position.Z > 300 then table.insert(band, m) end end
	-- ruins standing on a lowered island go down with it
	local riders = {}
	local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Include; prm.FilterDescendantsInstances = band
	local k21 = root.Pass21:FindFirstChild("Kit21")
	local cand = {}
	for _, m in ipairs(k21 and k21:GetChildren() or {}) do if m:IsA("Model") then table.insert(cand, m) end end
	for _, m in ipairs(root.Islands:GetChildren()) do if m:IsA("Model") and (m.Name == "K_Rot9" or m.Name == "K_Ruin8") then table.insert(cand, m) end end
	for _, m in ipairs(cand) do
		local cf, sz = m:GetBoundingBox()
		local foot = Vector3.new(cf.X, cf.Y - sz.Y / 2, cf.Z)
		if m:GetAttribute("P29CF") == nil then
			local cqs = {}
			for _, b in ipairs(band) do for _, d in ipairs(b:GetDescendants()) do if d:IsA("BasePart") then cqs[d] = d.CanQuery; d.CanQuery = true end end end
			local hit = workspace:Raycast(foot + Vector3.new(0, 3, 0), Vector3.new(0, -9, 0), prm)
			for d, v in pairs(cqs) do d.CanQuery = v end
			if hit then table.insert(riders, m) end
		end
	end
	for _, m in ipairs(riders) do table.insert(band, m) end
	for _, m in ipairs(band) do moveTo(m, function(b) return b - Vector3.new(0, ORB.bandDrop, 0) end) end
	table.insert(report, string.format("orb29 tree %d cres %d band %d", n, m, #band))
end
--ENDORB29

-- ================================================================ item 2: sky frame. Floating ruins (Pass21.Kit21 Arcade21/Palace21, Islands K_Rot9/K_Ruin8)
-- hang in empty sky in p2-p5. Each one without ground under its foot gets our own K_Island rock cone (120,125,130), 1.5x its width,
-- about 0.8x its height, a grass cap (110,170,70) and 4 leafy lumps. Island shells / pads (195,220,150) -> (172,193,130).
--SKY29
local SKY = { rock = rgb(120, 125, 130), grass = rgb(110, 170, 70), lump = rgb(96, 150, 70), wK = 1.5, hK = 0.8, pad = rgb(150, 178, 110) }
do
	local n, g = 0, 0
	local F = Instance.new("Folder"); F.Name = "Sky29"; F.Parent = P29
	local list = {}
	local k21 = root.Pass21:FindFirstChild("Kit21")
	for _, m in ipairs(k21 and k21:GetChildren() or {}) do if m.Name == "Arcade21" or m.Name == "Palace21" then table.insert(list, m) end end
	for _, nm in ipairs({ "K_Rot9", "K_Ruin8" }) do for _, m in ipairs(root.Islands:GetChildren()) do if m.Name == nm then table.insert(list, m) end end end
	local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude
	for _, m in ipairs(list) do
		local cf, s = m:GetBoundingBox()
		local foot = Vector3.new(cf.X, cf.Y - s.Y / 2, cf.Z)
		prm.FilterDescendantsInstances = { m, P29 }
		local hit = workspace:Raycast(foot + Vector3.new(0, 3, 0), Vector3.new(0, -9, 0), prm)
		if hit and hit.Instance.Transparency < 0.9 then
			g += 1
		elseif foot.Y > 40 then
			local W = math.max(s.X, s.Z) * SKY.wK
			local H = math.max(s.Y * SKY.hK, W * 0.35)
			local top = foot + Vector3.new(0, 0.6, 0)
			local ry = math.rad((n * 47) % 360)
			kp("K_Island_rock", CFrame.new(top - Vector3.new(0, 1.2, 0)) * CFrame.Angles(0, ry, 0), Vector3.new(W / 74, H / 32, W / 74), SKY.rock, Enum.Material.Slate, F, "IslRock29")
			kp("K_Island_grass", CFrame.new(top - Vector3.new(0, 1.2, 0)) * CFrame.Angles(0, ry, 0), Vector3.new(W / 73, 1, W / 73), SKY.grass, Enum.Material.Grass, F, "IslCap29")
			for j = 1, 4 do
				local a = ry + j * math.rad(90) + 0.4
				local rr = W * 0.42
				local lk = W / 14 * 0.28
				kp("K_FluffyS_leaf", CFrame.new(top + Vector3.new(math.cos(a) * rr, -1.2 - lk * 2, math.sin(a) * rr)) * CFrame.Angles(0, a, 0), lk, SKY.lump, SM, F, "IslLump29")
			end
			n += 1
		end
	end
	-- pale island pads/shells
	local p = 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and (d.Name == "K_Soft14C_leafPad") and not d:IsDescendantOf(P29) then recol(d, SKY.pad); p += 1 end
	end
	table.insert(report, string.format("sky29 islands %d grounded %d pads %d", n, g, p))
end
--ENDSKY29

-- ================================================================ item 4: Story portal (p4, p6). Ring Pass23.Portal23 at x -87, opening StoryOpening14.
-- Horseshoe crest on top (silver horseshoe with a dark inner disc and a blue gem), a darker inner band (40,60,120), 5 blue ivy drips.
--STORY29
local ST = { band = rgb(40, 60, 120), ivy = rgb(40, 90, 220), silver = rgb(170, 190, 225), gem = rgb(70, 170, 255) }
do
	local ok = 0
	local op = root.Pass14:FindFirstChild("StoryOpening14")
	local ring = root.Pass23:FindFirstChild("Portal23")
	if op and ring then
		local F = Instance.new("Folder"); F.Name = "Story29"; F.Parent = P29
		local lo, hi = Vector3.new(1e9, 1e9, 1e9), Vector3.new(-1e9, -1e9, -1e9)
		for _, d in ipairs(ring:GetDescendants()) do if d:IsA("BasePart") and d.Transparency < 1 then
			local e = d.Size / 2; lo = lo:Min(d.Position - e); hi = hi:Max(d.Position + e) end end
		local rcf, rs = CFrame.new((lo + hi) / 2), hi - lo
		local c = op.Position
		local R = math.max(rs.Y, rs.Z) / 2        -- outer radius of the ring
		local face = Vector3.new(1, 0, 0)          -- ring faces the plaza (+x)
		local rin = math.min(op.Size.Y, op.Size.Z) / 2
		-- inner band: a disc just larger than the opening, behind the silver ring, in front of the opening
		local b = part("StoryBand29", Vector3.new(0.2, rin * 2 + 2.0, rin * 2 + 2.0), CFrame.new(c + face * 0.05), ST.band, SM, F, Enum.PartType.Cylinder)
		b.CanCollide = false
		op.Position = op.Position -- (opening kept)
		-- crest: horseshoe on top of the ring, 6 studs wide
		local top = Vector3.new(c.X, rcf.Y + rs.Y / 2, c.Z) + face * 0.3
		local h = part("Crest29", Vector3.new(0.6, 6, 6), CFrame.new(top + Vector3.new(0, 1.6, 0)), ST.silver, Enum.Material.Metal, F, Enum.PartType.Cylinder)
		h.CanCollide = false
		local hi = part("CrestIn29", Vector3.new(0.7, 3.6, 3.6), CFrame.new(top + Vector3.new(0, 1.9, 0)), ST.band, SM, F, Enum.PartType.Cylinder); hi.CanCollide = false
		local cut = part("CrestCut29", Vector3.new(0.8, 2.2, 1.6), CFrame.new(top + Vector3.new(0, 0.3, 0)), ST.band, SM, F); cut.CanCollide = false
		local gm = part("CrestGem29", Vector3.new(1.4, 1.4, 1.4), CFrame.new(top + Vector3.new(0, 2.2, 0) + face * 0.5), ST.gem, Enum.Material.Neon, F, Enum.PartType.Ball); gm.CanCollide = false
		-- ivy drips off the upper rim
		for i, a in ipairs({ 25, 45, 70, 110, 135, 155 }) do
			local ang = math.rad(a)
			local L = ({ 5, 6.5, 3.5, 4, 6, 5 })[i]
			local p0 = c + Vector3.new(0, math.sin(ang) * (R + 0.3), math.cos(ang) * (R + 0.3)) + face * 0.7
			local iv = part("Ivy29", Vector3.new(0.35, L, 0.35), CFrame.new(p0 - Vector3.new(0, L / 2, 0)), ST.ivy, Enum.Material.Grass, F); iv.CanCollide = false
			for k = 1, 3 do
				local lf = part("IvyLeaf29", Vector3.new(0.6, 0.9, 0.9), CFrame.new(p0 - Vector3.new(0, L * k / 3.4, 0) + face * 0.15) * CFrame.Angles(k, 0, 0.5), ST.ivy, Enum.Material.Grass, F, Enum.PartType.Ball)
				lf.CanCollide = false
			end
		end
		ok = 1
	end
	table.insert(report, string.format("story29 %d R %.1f", ok, op and ring and 0 or 0))
end
--ENDSTORY29

-- ================================================================ item 5: Summon facade (p1, c4, c3, p5). The cream K_Summon9 box (205,178,108) and the
-- Colonnade17 face -> white-gold: warm white body, gold capitals and caps, the 5 upper windows enlarged into tall blue arches (60,100,200)
-- in gold frames, a gold medallion with a blue centre over the door.
--SUMMON29
local SU = { white = rgb(240, 228, 192), gold = rgb(200, 165, 60), blue = rgb(60, 100, 200), z = -177.0 }
do
	local nw, nc = 0, 0
	local S = root.Pass11:FindFirstChild("Summon11")
	local C = root.Pass17:FindFirstChild("Colonnade17")
	local F = Instance.new("Folder"); F.Name = "Summon29"; F.Parent = P29
	for _, d in ipairs(S and S:GetDescendants() or {}) do
		if d:IsA("BasePart") and d.Name:find("cream") then recol(d, SU.white); nc += 1 end
	end
	for _, d in ipairs(C and C:GetChildren() or {}) do
		if d:IsA("BasePart") then
			local h, s, v = d.Color:ToHSV()
			if d.Name == "Capital" or d.Name == "Cornice" then recol(d, SU.gold, Enum.Material.Metal); nc += 1
			elseif s < 0.45 and v > 0.7 and h > 0.05 and h < 0.2 then recol(d, SU.white); nc += 1 end
			if d.Name == "Pilaster" then
				local cp = part("PilCap29", Vector3.new(d.Size.X + 0.5, 0.45, d.Size.Z + 0.3), CFrame.new(d.Position + Vector3.new(0, d.Size.Y / 2 + 0.22, 0.1)), SU.gold, Enum.Material.Metal, F)
				cp.CanCollide = false
			end
		end
	end
	for _, d in ipairs(C and C:GetChildren() or {}) do
		if d.Name == "Window" then
			local x, z = d.Position.X, d.Position.Z + 0.25
			local w, hgt = 3.4, 4.2
			local y0 = 22.3
			local fr = part("WinFrame29", Vector3.new(w + 0.7, hgt + 0.35, 0.3), CFrame.new(x, y0 + (hgt + 0.35) / 2 - 0.2, z), SU.gold, Enum.Material.Metal, F); fr.CanCollide = false
			local fa = part("WinFrameArch29", Vector3.new(0.3, w + 0.7, w + 0.7), CFrame.new(x, y0 + hgt - 0.2, z) * CFrame.Angles(0, math.rad(90), 0), SU.gold, Enum.Material.Metal, F, Enum.PartType.Cylinder); fa.CanCollide = false
			local gl = part("WinGlass29", Vector3.new(w, hgt, 0.32), CFrame.new(x, y0 + hgt / 2, z + 0.05), SU.blue, SM, F); gl.CanCollide = false
			local ga = part("WinGlassArch29", Vector3.new(0.32, w, w), CFrame.new(x, y0 + hgt, z + 0.05) * CFrame.Angles(0, math.rad(90), 0), SU.blue, SM, F, Enum.PartType.Cylinder); ga.CanCollide = false
			local mu = part("WinMullion29", Vector3.new(0.2, hgt + w / 2 - 0.3, 0.36), CFrame.new(x, y0 + (hgt + w / 2) / 2, z + 0.08), SU.gold, Enum.Material.Metal, F); mu.CanCollide = false
			for _, k in ipairs({ "WindowHead" }) do end
			nw += 1
		elseif d.Name == "WindowHead" then hide(d)
		end
	end
	-- upper storey of K_Summon9: its 4 dark arched openings (raycast map: x -20/-10/10/20, wall face z -183, arch top y 35)
	-- get blue glass in gold frames
	for _, x in ipairs({ -20, -10, 10, 20 }) do
		local z, w, y0, y1 = -182.7, 3.4, 26.8, 33.2
		local fr = part("UpFrame29", Vector3.new(w + 0.8, y1 - y0 + 0.4, 0.3), CFrame.new(x, (y0 + y1) / 2 - 0.2, z - 0.15), SU.gold, Enum.Material.Metal, F); fr.CanCollide = false
		local fa = part("UpFrameArch29", Vector3.new(0.3, w + 0.8, w + 0.8), CFrame.new(x, y1, z - 0.15) * CFrame.Angles(0, math.rad(90), 0), SU.gold, Enum.Material.Metal, F, Enum.PartType.Cylinder); fa.CanCollide = false
		local gl = part("UpGlass29", Vector3.new(w, y1 - y0, 0.3), CFrame.new(x, (y0 + y1) / 2, z), SU.blue, SM, F); gl.CanCollide = false
		local ga = part("UpGlassArch29", Vector3.new(0.3, w, w), CFrame.new(x, y1, z) * CFrame.Angles(0, math.rad(90), 0), SU.blue, SM, F, Enum.PartType.Cylinder); ga.CanCollide = false
		local mu = part("UpMullion29", Vector3.new(0.22, y1 - y0 + w / 2 - 0.3, 0.34), CFrame.new(x, (y0 + y1 + w / 2) / 2, z + 0.05), SU.gold, Enum.Material.Metal, F); mu.CanCollide = false
		local tr = part("UpTransom29", Vector3.new(w, 0.22, 0.34), CFrame.new(x, y1 - 0.4, z + 0.05), SU.gold, Enum.Material.Metal, F); tr.CanCollide = false
		nw += 1
	end
	-- medallion over the door on the attic
	local at = C and C:FindFirstChild("Attic")
	if at then
		local mc = Vector3.new(at.Position.X, at.Position.Y, at.Position.Z + at.Size.Z / 2 + 0.1)
		local m1 = part("Medal29", Vector3.new(0.3, 3.6, 3.6), CFrame.new(mc) * CFrame.Angles(0, math.rad(90), 0), SU.gold, Enum.Material.Metal, F, Enum.PartType.Cylinder); m1.CanCollide = false
		local m2 = part("MedalIn29", Vector3.new(0.35, 2.2, 2.2), CFrame.new(mc + Vector3.new(0, 0, 0.05)) * CFrame.Angles(0, math.rad(90), 0), SU.blue, SM, F, Enum.PartType.Cylinder); m2.CanCollide = false
		local m3 = part("MedalStar29", Vector3.new(0.4, 0.9, 0.9), CFrame.new(mc + Vector3.new(0, 0, 0.1)) * CFrame.Angles(0, math.rad(90), 0), SU.gold, Enum.Material.Metal, F, Enum.PartType.Cylinder); m3.CanCollide = false
	end
	table.insert(report, string.format("summon29 win %d recol %d", nw, nc))
end
--ENDSUMMON29

-- ================================================================ item 6: Boss Rush (p5, c2, c3, p7). The Neon spiral disc (Raid11 BossPortal/Rim/Swirl,
-- facing -x at (140,20.4,-54)) -> a purple gothic shrine ~26 tall: our pass-28 gothic door (Goth28) cloned at 1.1x in (70,40,90),
-- a magenta Neon glow leaf with a light, two pillar spires with faceted finials (Boll28_head x3), a sign plate (200,60,90).
--BOSS29
local BO = { stone = rgb(70, 40, 90), glow = rgb(150, 40, 140), sign = rgb(200, 60, 90), k = 1.1, at = Vector3.new(140.4, 8.6, -54) }
do
	local ok = 0
	local R = root.Pass11:FindFirstChild("Raid11")
	local G = root.Pass28:FindFirstChild("Goth28")
	if R and G and R:FindFirstChild("BossPortal") then
		local F = Instance.new("Folder"); F.Name = "Boss29"; F.Parent = P29
		for _, d in ipairs(R:GetChildren()) do
			if d.Name == "BossPortal" or d.Name == "BossPortalRim" or d.Name == "BossSwirl" or d.Name == "BossFrameBlock" then hide(d) end
			if d.Name == "BossTower" then recol(d, BO.stone) end
		end
		local gs = G:FindFirstChild("Goth28_stone")
		local base = Vector3.new(gs.Position.X, gs.Position.Y - gs.Size.Y / 2, gs.Position.Z)   -- door foot of the Raid door
		for _, d in ipairs(G:GetChildren()) do
			if d:IsA("BasePart") and d.Name:sub(1, 6) == "Goth28" then
				local c = d:Clone(); c.Parent = F; c.Name = d.Name:gsub("28", "Boss29")
				c.Size = d.Size * BO.k
				c.CFrame = CFrame.new(BO.at + (d.Position - base) * BO.k) * (d.CFrame - d.CFrame.Position)
				if d.Name == "Goth28_stone" then c.Color = BO.stone
				elseif d.Name == "Goth28_dark" then c.Color = BO.glow; c.Transparency = 0.1
					local l = Instance.new("PointLight"); l.Color = rgb(230, 70, 210); l.Range = 18; l.Brightness = 2; l.Shadows = false; l.Parent = c
				else c.Color = rgb(225, 200, 230) end
				for _, a in ipairs({ "P28Col", "P28Mat" }) do c:SetAttribute(a, nil) end
			end
		end
		local hw = gs.Size.X * BO.k / 2 + 1.6   -- pillars just outside the arch (door spans z)
		local fin = root.Pass28:FindFirstChild("Boll28_head")
		for _, sz in ipairs({ -1, 1 }) do
			local pz = BO.at + Vector3.new(0, 0, sz * hw)
			local pl = part("BossSpire29", Vector3.new(2.2, 22, 2.2), CFrame.new(pz + Vector3.new(0, 11, 0)), BO.stone, Enum.Material.Slate, F)
			local cp = part("BossSpireCap29", Vector3.new(2.8, 0.6, 2.8), CFrame.new(pz + Vector3.new(0, 22.3, 0)), rgb(200, 60, 160), Enum.Material.Neon, F); cp.CanCollide = false
			if fin then
				local f = fin:Clone(); f.Name = "BossFinial29"; f.Parent = F
				local k = 3.2 / math.max(fin.Size.X, fin.Size.Z)
				f.Size = fin.Size * k; f.CFrame = CFrame.new(pz + Vector3.new(0, 22.6 + f.Size.Y / 2, 0)); f.Color = BO.stone; f.Material = Enum.Material.Slate
			end
		end
		-- sign plate over the arch
		local top = BO.at + Vector3.new(-0.9, gs.Size.Y * BO.k + 1.6, 0)
		local sp = part("BossSign29", Vector3.new(0.5, 2.6, 11), CFrame.new(top), rgb(40, 20, 50), Enum.Material.Slate, F)
		local sg = Instance.new("SurfaceGui"); sg.Face = Enum.NormalId.Left; sg.PixelsPerStud = 40; sg.Parent = sp
		local tl = Instance.new("TextLabel"); tl.Size = UDim2.fromScale(1, 1); tl.BackgroundTransparency = 1; tl.Text = "BOSS RUSH"
		tl.TextColor3 = BO.sign; tl.TextScaled = true; tl.Font = Enum.Font.Fantasy; tl.TextStrokeTransparency = 0.3; tl.TextStrokeColor3 = rgb(255, 170, 220); tl.Parent = sg
		ok = 1
	end
	table.insert(report, "boss29 " .. ok)
end
--ENDBOSS29

--KIT29
--ENDKIT29

return table.concat(report, " | ")
end
