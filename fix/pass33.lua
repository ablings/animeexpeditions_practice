-- pass33.lua (practice place only): freestyle pass 33 on top of the pass-32 build (notes/fix_brief33.md, verify30_plaza.md).
-- Run AFTER pass 32 (sh out/r32w/run.sh; then sh out/r33w/run.sh). Idempotent: new pieces live in Plaza.Pass33 (rebuilt each run);
-- every old piece pass 33 touches keeps its pre-pass-33 value in a P33* attribute and is restored first.
-- Attributes: P33Col/P33Mat, P33T/P33CC/P33CQ + P33Hidden, P33CF, P33Size, P33En, P33SA, P33Tx.
-- Blocks: --P3SKY33, --EAST33, --ARCH33, --WATER33, --JET33, --EXTRA33. No kit (Parts, WedgeParts, own kit clones).
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM = Enum.Material.SmoothPlastic
local NE = Enum.Material.Neon
local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
-- r33 kit merge (same as the IMPORTS loop of build_plaza.lua), in case a pass-33 kit is ever imported.
do
	local src = workspace:FindFirstChild("ae_kit_r33")
	if src and kit then
		local ref = src:FindFirstChild("K_Scale33_stone", true)
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
local old = root:FindFirstChild("Pass33"); if old then old:Destroy() end
local P33 = Instance.new("Folder"); P33.Name = "Pass33"; P33.Parent = root

-- ---------------------------------------------------------------- restore
for _, d in ipairs(root:GetDescendants()) do
	if d:GetAttribute("P33Hidden") then
		if d:IsA("BasePart") then d.Transparency = d:GetAttribute("P33T"); d.CanCollide = d:GetAttribute("P33CC"); d.CanQuery = d:GetAttribute("P33CQ") end
		for _, a in ipairs({ "P33Hidden", "P33T", "P33CC", "P33CQ" }) do d:SetAttribute(a, nil) end
	end
	if d:GetAttribute("P33Col") ~= nil then d.Color = d:GetAttribute("P33Col"); d.Material = Enum.Material[d:GetAttribute("P33Mat")]; d:SetAttribute("P33Col", nil); d:SetAttribute("P33Mat", nil) end
	if d:GetAttribute("P33Size") ~= nil then d.Size = d:GetAttribute("P33Size"); d:SetAttribute("P33Size", nil) end
	if d:GetAttribute("P33CF") ~= nil then
		if d:IsA("Model") then d:PivotTo(d:GetAttribute("P33CF")) else d.CFrame = d:GetAttribute("P33CF") end
		d:SetAttribute("P33CF", nil)
	end
	if d:GetAttribute("P33En") ~= nil then d.Enabled = d:GetAttribute("P33En"); d:SetAttribute("P33En", nil) end
	if d:GetAttribute("P33SA") ~= nil then d.Color = d:GetAttribute("P33SA"); d:SetAttribute("P33SA", nil) end
	if d:GetAttribute("P33Tx") ~= nil then d.Transparency = d:GetAttribute("P33Tx"); d:SetAttribute("P33Tx", nil) end
end
local function hide(inst)
	for _, d in ipairs(inst:IsA("BasePart") and { inst } or inst:GetDescendants()) do
		if d:IsA("BasePart") then
			if d:GetAttribute("P33T") == nil then d:SetAttribute("P33T", d.Transparency); d:SetAttribute("P33CC", d.CanCollide); d:SetAttribute("P33CQ", d.CanQuery) end
			d.Transparency = 1; d.CanCollide = false; d.CanQuery = false; d:SetAttribute("P33Hidden", true)
		end
	end
end
local function recol(p, col, mat)
	if p:GetAttribute("P33Col") == nil then p:SetAttribute("P33Col", p.Color); p:SetAttribute("P33Mat", p.Material.Name) end
	p.Color = col; if mat then p.Material = mat end
end
local function resize(p, s) if p:GetAttribute("P33Size") == nil then p:SetAttribute("P33Size", p.Size) end p.Size = s end
local function moveTo(inst, f)
	local base = inst:GetAttribute("P33CF")
	if base == nil then base = inst:IsA("Model") and inst:GetPivot() or inst.CFrame; inst:SetAttribute("P33CF", base) end
	local cf = f(base)
	if inst:IsA("Model") then inst:PivotTo(cf) else inst.CFrame = cf end
end
local function setT(p, t) if p:GetAttribute("P33Tx") == nil then p:SetAttribute("P33Tx", p.Transparency) end p.Transparency = t end
local function disable(inst)
	for _, d in ipairs(inst:IsA("Light") and { inst } or inst:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Light") then
			if d:GetAttribute("P33En") == nil then d:SetAttribute("P33En", d.Enabled) end
			d.Enabled = false
		end
	end
end
local function part(name, size, cf, col, mat, parent, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or SM; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent or P33; return p
end
local function kp(n, cf, scale, col, mat, parent, name)
	local k = kit and kit:FindFirstChild(n); if not k then return nil end
	local c = k:Clone(); c.Anchored = true
	for _, s in ipairs(c:GetChildren()) do if s:IsA("SurfaceAppearance") then s:Destroy() end end
	local sv = typeof(scale) == "Vector3" and scale or Vector3.new(scale, scale, scale)
	c.Size = k.Size * sv
	c.CFrame = cf * CFrame.new(k.Position * sv) * (k.CFrame - k.CFrame.Position)
	if col then c.Color = col end; c.Material = mat or SM
	c.Name = name or n; c.Parent = parent or P33; return c
end
local function ell(name, size, cf, col, mat, parent)
	local p = part(name, size, cf, col, mat, parent)
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	p.CanCollide = false; p.CanQuery = false; p.CastShadow = false
	return p
end
local function ghost(p) p.CanCollide = false; p.CanQuery = false; p.CastShadow = false; return p end
-- clone an existing model, strip every pass attribute (so older restores never touch the clone)
local function cloneClean(m)
	local c = m:Clone()
	for _, d in ipairs(c:GetDescendants()) do for k in pairs(d:GetAttributes()) do d:SetAttribute(k, nil) end end
	for k in pairs(c:GetAttributes()) do c:SetAttribute(k, nil) end
	return c
end
local prm = RaycastParams.new(); prm.FilterType = Enum.RaycastFilterType.Exclude; prm.FilterDescendantsInstances = { P33 }
local function groundY(x, z, maxY, pred)
	-- first hit below maxY on a down-ray (skips canopy above it)
	local o = Vector3.new(x, 80, z)
	local ex = { P33 }
	for i = 1, 8 do
		prm.FilterDescendantsInstances = ex
		local r = workspace:Raycast(o, Vector3.new(0, -120, 0), prm)
		if not r then break end
		if r.Position.Y < maxY and r.Instance.Transparency < 0.5 and (not pred or pred(r.Instance)) then prm.FilterDescendantsInstances = { P33 }; return r.Position.Y, r.Instance end
		table.insert(ex, r.Instance)
	end
	prm.FilterDescendantsInstances = { P33 }
	return nil
end
local report = {}
local report = {}
local function under(path) local r = root for s in path:gmatch("[^%.]+") do r = r and r:FindFirstChild(s) end return r end
local function each(inst, f) if not inst then return 0 end local n = 0 for _, d in ipairs(inst:GetDescendants()) do if d:IsA("BasePart") then f(d); n += 1 end end return n end
local function scaleCol(c, k) return Color3.new(c.R * k, c.G * k, c.B * k) end
local rnd = Random.new(33)

-- ================================================================ item 1: p3 upper-left. The ref shows dark gothic towers and spires
-- (the Boss Rush block) filling p3 x 120-330, y 30-280, where we show sky and a light island. Tall dark own towers at x 92-112,
-- z -56..-92 (p3 bearing 30-40 deg left of the axis, 100-120 studs out). Raid doorway: near-black door plane with an arched top in
-- front of the Raid arch bands; Boss Rush block and the pass-32 dark trees darkened.
--P3SKY33
do
	local F = Instance.new("Folder"); F.Name = "P3Sky33"; F.Parent = P33
	local DK = rgb(34, 27, 36)
	local SL = Enum.Material.Slate
	local function g(x, z) return groundY(x, z, 14) or 6 end
	local function face(x, z) return CFrame.new(x, g(x, z), z) * CFrame.Angles(0, math.rad(-90 + rnd:NextNumber(-12, 12)), 0) end
	-- (x, z, kit, scale)
	local T = {
		{ 104, -70, "Tower9", 1.05 }, { 112, -90, "Tower9", 0.95 }, { 98, -56, "Spire", 2.1 }, { 100, -82, "Spire", 2.4 },
		{ 92, -66, "Gothic", 1.5 }, { 96, -88, "Gothic", 1.4 },
	}
	for _, t in ipairs(T) do
		local cf = face(t[1], t[2])
		if t[3] == "Tower9" then
			kp("K_Tower9_stone", cf, t[4], DK, SL, F, "BossTower33"); kp("K_Tower9_dark", cf, t[4], rgb(20, 16, 22), SL, F, "BossTower33")
			kp("K_Tower9_roof", cf, t[4], rgb(48, 30, 52), SL, F, "BossTower33")
		elseif t[3] == "Spire" then
			kp("K_Spire_stone", cf, t[4], DK, SL, F, "BossSpire33"); kp("K_Spire_darkStone", cf, t[4], rgb(20, 16, 22), SL, F, "BossSpire33")
		else
			kp("K_Gothic_stone", cf, t[4], DK, SL, F, "BossBlock33"); kp("K_Gothic_darkStone", cf, t[4], rgb(18, 14, 20), SL, F, "BossBlock33")
		end
	end
	-- Raid doorway
	-- Neon: RaidDoorLight16 sits 0.2 studs behind the plane and lit a SmoothPlastic black plane red (137,60,71); Neon ignores light
	local door = part("RaidDoor33", Vector3.new(0.1, 23, 11), CFrame.new(155.8, 18.5, 0), rgb(3, 8, 10), NE, F)
	local top = part("RaidDoorTop33", Vector3.new(0.1, 11, 11), CFrame.new(155.8, 30, 0), rgb(3, 8, 10), NE, F, Enum.PartType.Cylinder)
	ghost(door); ghost(top)
	-- Boss Rush block and the pass-32 dark mass
	local nb = 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("BasePart") and (d.Name == "BossTower") then recol(d, rgb(24, 17, 30)); nb += 1 end
	end
	local B = under("Pass29.Boss29")
	if B then
		local st = B:FindFirstChild("GothBoss29_stone"); if st then recol(st, rgb(30, 20, 34), SM) end
		local bo = B:FindFirstChild("GothBoss29_bone"); if bo then recol(bo, rgb(60, 42, 66)) end
	end
	each(under("Pass32.Sky32"), function(d) if d.Name == "DarkTree32" then recol(d, rgb(30, 23, 27)) end end)
	table.insert(report, "p3 " .. #F:GetChildren() .. " boss " .. nb)
end
--ENDP3SKY33

-- ================================================================ item 2: E ground. Red set darker (sunlit red renders ~1.5x lighter),
-- a 25-stud grey rubble band east from the E stair, a dark rock mound in the SE corner, green flower patches, a third of the E trees hidden.
--EAST33
do
	local F = Instance.new("Folder"); F.Name = "East33"; F.Parent = P33
	local nred = 0
	-- blue and green cut harder than red: the ambient adds blue, so the pass-32 red rendered pink (200,90,91) vs ref (164,67,59)
	local function redden(d, k) local c = d.Color; recol(d, Color3.new(c.R * k, c.G * k * 0.8, c.B * k * 0.45)); nred += 1 end
	each(under("Pass17.Splats17"), function(d) redden(d, 0.62) end)
	each(under("Pass18.East18"), function(d) if d.Name:find("Splat") then redden(d, 0.62) end end)
	each(under("Pass31.Ground31"), function(d) if d.Name == "Carpet" or d.Name == "Carpet31" then redden(d, 0.68) end end)
	each(under("Pass32.Ground32"), function(d) if d.Name == "Carpet32" then redden(d, 0.62) end end)
	each(under("Pass24.Ground24"), function(d) if d.Name:find("Carpet") then redden(d, 0.72) end end)
	local Z = under("Zoning")
	for _, m in ipairs(Z and Z:GetChildren() or {}) do
		if m.Name == "K_PatchA" or m.Name == "K_PatchB" or m.Name == "K_PatchC" then
			each(m, function(d) if d.Color.R > d.Color.G * 1.8 then redden(d, 0.72) end end)
		end
	end
	-- rubble band: hide red pieces inside it, then lay grey slate slabs and stones
	local function inBand(p) return p.X > 58 and p.X < 178 and p.Z > -9.5 and p.Z < 12.5 end
	local function inRock(p) return (p.X - 124) ^ 2 / 18 ^ 2 + (p.Z - 70) ^ 2 / 17 ^ 2 < 1 end
	local nh = 0
	for _, grp in ipairs({ under("Pass17.Splats17"), under("Pass31.Ground31"), under("Pass32.Ground32") }) do
		each(grp, function(d)
			if (d.Name:find("Splat") or d.Name:find("Carpet")) and (inBand(d.Position) or inRock(d.Position)) then hide(d); nh += 1 end
		end)
	end
	local nb = 0
	for x = 60, 176, 5 do
		for z = -8, 11, 4.75 do
			local px, pz = x + rnd:NextNumber(-2, 2), z + rnd:NextNumber(-2, 2)
			local y = groundY(px, pz, 12)
			if y then
				local s = rnd:NextNumber(4.5, 7.5)
				local v = rnd:NextNumber(-10, 10)
				local p = part("Rubble33", Vector3.new(s, rnd:NextNumber(0.3, 0.7), s * rnd:NextNumber(0.7, 1.1)),
					CFrame.new(px, y + 0.15, pz) * CFrame.Angles(rnd:NextNumber(-0.06, 0.06), rnd:NextNumber(0, 6.28), rnd:NextNumber(-0.06, 0.06)),
					rgb(34 + v * 0.5, 37 + v * 0.5, 37 + v * 0.5), Enum.Material.Slate, F)
				p.CanCollide = false; nb += 1
				if rnd:NextNumber() < 0.35 then
					local r = rnd:NextNumber(0.8, 1.8)
					part("Stone33", Vector3.new(r * 1.3, r, r), CFrame.new(px + rnd:NextNumber(-2, 2), y + r * 0.35, pz + rnd:NextNumber(-2, 2)) * CFrame.Angles(rnd:NextNumber(0, 1), rnd:NextNumber(0, 6), rnd:NextNumber(0, 1)),
						rgb(56 + v * 0.6, 60 + v * 0.6, 59 + v * 0.6), Enum.Material.Slate, F).CanCollide = false
				end
			end
		end
	end
	-- SE dark rock mound
	local nr = 0
	for i = 1, 26 do
		local a, rr = rnd:NextNumber(0, 6.28), math.sqrt(rnd:NextNumber())
		local px, pz = 124 + math.cos(a) * 16 * rr, 70 + math.sin(a) * 15 * rr
		local y = groundY(px, pz, 14) or 6
		local h = (1 - rr) * 9 + rnd:NextNumber(2, 4)
		local w = rnd:NextNumber(5, 9)
		local v = rnd:NextNumber(-8, 8)
		local cls = (i % 3 == 0) and "WedgePart" or "Part"
		local p = Instance.new(cls); p.Name = "Rock33"; p.Anchored = true; p.Size = Vector3.new(w, h, w * rnd:NextNumber(0.7, 1.2))
		p.CFrame = CFrame.new(px, y + h * 0.4, pz) * CFrame.Angles(rnd:NextNumber(-0.2, 0.2), rnd:NextNumber(0, 6.28), rnd:NextNumber(-0.2, 0.2))
		-- SmoothPlastic even at (12,12,10) rendered (69,81,87): ambient floor. Neon ignores light and renders ~2x, so (24,26,25) -> ~(50,53,51);
		-- wedges stay SmoothPlastic for some shading
		if cls == "WedgePart" then p.Color = rgb(12, 12, 10); p.Material = SM else p.Color = rgb(24 + v * 0.3, 26 + v * 0.3, 25 + v * 0.3); p.Material = NE end; p.Parent = F; nr += 1
	end
	-- green flower patches inside the red
	local PT = { { 78, -40 }, { 96, -30 }, { 70, 30 }, { 112, 38 }, { 140, -20 }, { 88, 62 } }
	local ng = 0
	for _, c in ipairs(PT) do
		for i = 1, 7 do
			local px, pz = c[1] + rnd:NextNumber(-3, 3), c[2] + rnd:NextNumber(-3, 3)
			local y = groundY(px, pz, 12)
			if y then
				local k = kp("K_ClumpG_leaf", CFrame.new(px, y, pz) * CFrame.Angles(0, rnd:NextNumber(0, 6.28), 0), rnd:NextNumber(1.2, 1.7), rgb(70, 130, 20), SM, F, "Flower33")
				if k then ghost(k); ng += 1 end
				if i <= 4 then ghost(ell("FlowerW33", Vector3.new(0.7, 0.5, 0.7), CFrame.new(px + 0.6, y + 1.3, pz), rgb(235, 235, 225), SM, F)) end
			end
		end
	end
	-- thin the E trees by about a third
	local HIDE = { { "Pass11", "K_DeadTree", 74, 37 }, { "Pass11", "K_DeadTree", 109, 37 }, { "Pass22.Fol22", "RedTree22", 88, 20 },
		{ "Pass22.Fol22", "RedTree22", 96, -22 }, { "Pass11.Raid11", "K_DeadTree", 136, 66 }, { "Pass11.Raid11", "K_DeadTree", 154, 82 } }
	local nt = 0
	for _, h in ipairs(HIDE) do
		local P = under(h[1])
		for _, m in ipairs(P and P:GetChildren() or {}) do
			if m.Name == h[2] and m:IsA("Model") then
				local p = m:GetBoundingBox().Position
				if math.abs(p.X - h[3]) < 3 and math.abs(p.Z - h[4]) < 3 then hide(m); nt += 1 end
			end
		end
	end
	table.insert(report, string.format("east red %d hid %d band %d rock %d flowers %d trees %d", nred, nh, nb, nr, ng, nt))
end
--ENDEAST33

-- ================================================================ item 3: arch face darker slate.
--ARCH33
do
	local a = root:FindFirstChild("Pass20") and root.Pass20:FindFirstChild("K_Arch20_stone")
	if a then recol(a, rgb(62, 66, 67)) end
	-- light chamfered inner band round each niche opening. The opening was probed with rays (out/r33w/q_arch.lua): face at 33 studs
	-- out along each diagonal, opening a half-ellipse 5.3 wide x 3.6 tall above y 2. Band 0.7 wide, offset 0.4 outward, tilted 30 deg.
	local F = Instance.new("Folder"); F.Name = "Arch33"; F.Parent = P33
	local nb = 0
	for _, sg in ipairs({ { 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 } }) do
		local n = Vector3.new(sg[1], 0, sg[2]).Unit
		local t = Vector3.new(-n.Z, 0, n.X)
		local A, Bh, R0 = 5.3 + 0.4, 3.6 + 0.4, 32.92
		local N = 14
		for i = 0, N - 1 do
			local a0, a1 = math.pi * i / N, math.pi * (i + 1) / N
			local p0 = n * R0 + t * (A * math.cos(a0)) + Vector3.new(0, 2 + Bh * math.sin(a0), 0)
			local p1 = n * R0 + t * (A * math.cos(a1)) + Vector3.new(0, 2 + Bh * math.sin(a1), 0)
			local mid = (p0 + p1) / 2
			local cf = CFrame.lookAt(mid, p1, n) -- look along the arc, up = outward normal
			local seg = part("ArchBand33", Vector3.new(0.7, 0.12, (p1 - p0).Magnitude + 0.08), cf * CFrame.new(0, 0, 0) , rgb(124, 129, 131), SM, F)
			-- the band lies in the face plane: rotate so its thin axis is the face normal, then tilt 30 deg into a chamfer
			local tang = (p1 - p0).Unit
			local out = Vector3.new(0, Bh * math.sin((a0 + a1) / 2), 0) + t * (A * math.cos((a0 + a1) / 2)); out = (out - n * out:Dot(n)).Unit
			seg.CFrame = CFrame.fromMatrix(mid - n * 0.04, out, -n, tang) * CFrame.Angles(0, 0, math.rad(-30))
			seg.Size = Vector3.new(0.7, 0.12, (p1 - p0).Magnitude + 0.08)
			ghost(seg); nb += 1
		end
	end
	table.insert(report, "arch " .. tostring(a ~= nil) .. " band " .. nb)
end
--ENDARCH33

-- ================================================================ items 4/5: water tints, jet core, back-niche water sheet.
--WATER33
do
	local F = Instance.new("Folder"); F.Name = "Water33"; F.Parent = P33
	local nl = 0
	for _, grp in ipairs({ under("Pass16.West16"), under("Pass30.West30") }) do
		each(grp, function(d)
			local c = d.Color
			-- tried (0,30,44): p8 W went (62,89,132) -> (63,90,111), further from the ref (109,129,145); the p7 "lagoon" box is a blue
			-- tree in our frame. Lagoon left at the pass-32 colour (counted only).
			if c.B > 0.15 and c.B < 0.3 and c.R < 0.03 then nl += 1 end
		end)
	end
	local nj = 0
	for _, grp in ipairs({ under("Pass30.Jet30"), under("Pass31.Jet31") }) do
		each(grp, function(d)
			if d.Transparency < 0.95 and (d.Color.B > 0.85 and d.Color.G > 0.8) then
				recol(d, rgb(150, 200, 215), d.Material == NE and SM or nil); setT(d, math.max(d.Transparency, 0.4)); nj += 1
			end
		end)
	end
	local ns = 0
	each(under("Pass20"), function(d)
		if d.Name == "TunnelBack20" then
			local pos = d.Position
			local n = ((Vector3.new(0, pos.Y, 0) - pos) * Vector3.new(1, 0, 1)).Unit
			local sheet = part("NicheSheet33", Vector3.new(4, 5.4, 0.08), CFrame.lookAt(pos + n * 0.3 + Vector3.new(0, -0.2, 0), pos + n * 5 + Vector3.new(0, -0.2, 0)), rgb(120, 160, 176), SM, F)
			sheet.Transparency = 0.3; ghost(sheet)
			local lip = part("NicheLip33", Vector3.new(4.4, 0.3, 0.5), CFrame.lookAt(pos + n * 0.45 + Vector3.new(0, 2.6, 0), pos + n * 5 + Vector3.new(0, 2.6, 0)), rgb(175, 215, 228), SM, F)
			lip.Transparency = 0.2; ghost(lip); ns += 1
		end
	end)
	table.insert(report, string.format("water lagoon %d jet %d sheets %d", nl, nj, ns))
end
--ENDWATER33

-- ================================================================ items 7-10: portal, Story ring, bollard slab (Boss facade is in P3SKY33).
--EXTRA33
do
	local ne = 0
	local function near(c, r, g, b) return math.abs(c.R * 255 - r) + math.abs(c.G * 255 - g) + math.abs(c.B * 255 - b) < 4 end
	-- bollard slab: (226,226,218) and (196,196,188) both clipped to white in sun; (160,160,153) keeps a shade
	each(under("Pass32.Boll32"), function(d) if near(d.Color, 226, 226, 218) then recol(d, rgb(150, 150, 143)); ne += 1 end end)
	-- Story ring interior: SmoothPlastic (0,1,3) still rendered (29,41,51) from ambient; Neon black ignores it
	local so = root:FindFirstChild("Pass14") and root.Pass14:FindFirstChild("StoryOpening14"); if so then recol(so, rgb(0, 2, 5), NE) end
	-- Expeditions portal about 20 % darker (p2 (10,161,174) -> ref (4,131,142)): plane, swirl arms and core
	each(under("Pass31.Gate31"), function(d) if d.Name == "Portal31" or near(d.Color, 10, 108, 122) then recol(d, rgb(9, 102, 116)); ne += 1 end end)
	each(under("Pass32.Gate32"), function(d)
		if d.Name == "SwirlCore32" or d.Name == "Swirl32" then recol(d, scaleCol(d.Color, 0.94)); ne += 1 end
	end)
	table.insert(report, "extra " .. ne)
end
--ENDEXTRA33

return table.concat(report, " | ")
end
