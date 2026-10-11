-- build_plaza.lua (practice place only): freestyle spawn plaza, pass 8 (r7 kit + the r8 pieces merged into Kit).
-- The kit (ae_kit_r7, tools/ae_kit.py build_all7 + the pass-5/6 pieces) is authored in plaza coordinates: the hero piece
-- (4 mirrored corners), the stairs (4 rotated flights) and the floor/medallion import already in place, so they are
-- placed at the identity CFrame. Foliage, islands, patches, landmarks are authored at the origin and instanced.
-- Frame: lower plaza floor y=0, terrace y=6, -Z = north. Stair foot 28, stair top 48 studs from the centre.
-- Idempotent: rebuilds Workspace.Plaza.
local IMPORT_SCALE = 40.5585   -- Import 3D scale of the FBX (before any 2048-stud clamp)
local SS = game:GetService("ServerStorage")
local kit = SS:FindFirstChild("Kit")
-- Import 3D scales by 40.5585 but shrinks the WHOLE model further when any MeshPart would pass 2048 studs. So measure the
-- scale from a piece of known size. r7 was a full kit (replaces Kit; the dais is 40 across); from r8 on a kit holds only
-- the new pieces plus a 10-stud cube K_Scale8_stone, and is MERGED into Kit (same-named pieces replaced).
local IMPORTS = { { "ae_kit_r7", "K_Medal_pale", 40.0, false }, { "ae_kit_r8", "K_Scale8_stone", 10.0, true },
	{ "ae_kit_r8b", "K_Scale8_stone", 10.0, true }, -- r8b: fixed skull only, if the lead imports it
	{ "ae_kit_r9", "K_Scale9_stone", 10.0, true },
	{ "ae_kit_r10", "K_Scale10_stone", 10.0, true },
	{ "ae_kit_r11", "K_Scale11_stone", 10.0, true },
	{ "ae_kit_r12", "K_Scale12_stone", 10.0, true } } -- r12: none exported in pass 12 (all Parts); kept for a later pass -- r11: pass-11 pieces, only if a pass-11 kit is ever imported -- r10: pass-10 pieces (only if the lead imports one) -- r9: pass-9 pieces (islands, buildings, letters, spills, thin ring)
for _, imp in ipairs(IMPORTS) do
	local src = workspace:FindFirstChild(imp[1])
	if src then -- first run after an import: move the imported model into ServerStorage.Kit at true size
		if not imp[4] and kit then kit:Destroy(); kit = nil end
		if not kit then kit = Instance.new("Folder"); kit.Name = "Kit"; kit.Parent = SS end
		local ref = src:FindFirstChild(imp[2], true)
		if ref then IMPORT_SCALE = ref.Size.X / imp[3] end
		for _, d in ipairs(src:GetDescendants()) do
			if d:IsA("MeshPart") then
				d.Size = d.Size / IMPORT_SCALE
				d.CFrame = CFrame.new(d.Position / IMPORT_SCALE) * (d.CFrame - d.CFrame.Position)
				d.Anchored = true
				local old = kit:FindFirstChild(d.Name); if old then old:Destroy() end
				if d.Name:sub(1, 7) == "K_Scale" then d:Destroy() else d.Parent = kit end
			end
		end
		src:Destroy()
	end
end
assert(kit and kit:FindFirstChild("K_Skull8_bone"), "no r8 kit: import kit/own/ae_kit_r8.fbx first")
local rgb = Color3.fromRGB
local SM, GL, NE, GR = Enum.Material.SmoothPlastic, Enum.Material.Glass, Enum.Material.Neon, Enum.Material.Grass
-- Colour/material per name token (the material split made in Blender).
-- Pass 6 (round-3 review item 1): neutral, lighter stone with no blue tint; vault interior slate (60,68,85) instead of
-- near black; yellower gold; softer lantern glass with a hot core. With the reference's own ambient restored
-- (fix_lighting.lua) these no longer go navy in shade.
local LOOK = {
	stone = { rgb(102, 106, 114), SM }, rib = { rgb(78, 84, 96), SM }, darkStone = { rgb(76, 82, 96), SM },
	vault = { rgb(72, 82, 100), SM }, gold = { rgb(195, 150, 55), Enum.Material.Metal }, -- pass 10: Metal (195,150,55) renders (143,126,44) shade .. lit, was SM (211,183,68)
	 blue = { rgb(48, 78, 150), SM },
	glass = { rgb(85, 140, 185), GL, 0, 0.25 }, core = { rgb(190, 235, 255), NE, 0, 0.1 },
	water = { rgb(110, 175, 195), GL, 0, 0.3 }, sheet = { rgb(150, 205, 225), GL, 0, 0.35 }, foam = { rgb(200, 235, 245), NE, 0, 0.55 },
	turf = { rgb(78, 128, 58), GR }, pale = { rgb(132, 135, 138), SM }, slate = { rgb(60, 65, 75), SM },
	white = { rgb(185, 185, 190), SM }, navy = { rgb(28, 38, 95), SM }, riser = { rgb(95, 100, 110), SM },
	wood = { rgb(140, 102, 62), SM }, rock = { rgb(150, 150, 140), SM }, grass = { rgb(110, 170, 70), SM },
	silver = { rgb(150, 153, 162), SM, 0.15 }, vine = { rgb(78, 140, 60), SM }, teal = { rgb(40, 140, 140), SM },
	patch = { rgb(90, 140, 60), GR },
	-- pass 7 tokens
	bone = { rgb(125, 85, 72), SM }, eye = { rgb(255, 50, 50), NE }, dark = { rgb(45, 22, 24), SM }, dome = { rgb(110, 40, 48), SM },
	fall = { rgb(200, 230, 245), GL, 0, 0.3 }, cloud = { rgb(241, 242, 236), SM }, canopy = { rgb(230, 230, 230), SM },
}
local RUNNER_BLUE = rgb(40, 68, 140)
local function lighten(c, k) return c:Lerp(Color3.new(1, 1, 1), k) end
local HAS9 = kit:FindFirstChild("K_Isl91_rock") ~= nil -- pass-9 kit imported?
local HAS10 = kit:FindFirstChild("K_Trip10_teal") ~= nil -- pass-10 kit (hero with the smaller basin 3.5 further back, triptych) imported?
local BASIN_R = HAS10 and 33.1 or 29.6 -- basin centre along the diagonal
local function look(p, tint, rim)
	local grp, tok = p.Name:match("^K_([^_]+)_(%a+)")
	if tok and tok:sub(1, 4) == "leaf" and tint then
		p.Color = (tok == "leafRim") and (rim or lighten(tint, 0.3)) or tint; p.Material = SM
		p.CastShadow = not (grp == "Fern" or grp == "Grass" or grp == "Litter"); return
	end
	if tok and tok:sub(1, 4) == "gold" then tok = "gold" end
	local L = LOOK[tok] or LOOK.stone
	p.Color = L[1]; p.Material = L[2]; p.Reflectance = L[3] or 0; p.Transparency = L[4] or 0
	if tok == "patch" then p.Color = tint or L[1]; p.CastShadow = false end
	if tok == "blue" and (grp == "Stairs" or grp == "Medal") then p.Color = RUNNER_BLUE end
	if tok == "stone" and grp == "Stairs" then p.Color = rgb(125, 126, 126); p.Material = Enum.Material.Slate end -- pass 10: treads (155-165) -> target (175,180,180) -- pass 8: base (78,82,94) Slate RENDERS (112-119,123-128,140) in sun = the S-flight target
	if tok == "riser" and grp == "Stairs" then p.Color = rgb(78, 86, 96) end -- pass 11: risers render (34,50,73) near-black against (95,105,115): lifted -- pass 10: risers (60,70,85)
	if tok == "foam" and (grp == "Island" or grp == "Isl6") then p.Color = rgb(200, 225, 240); p.Material = SM; p.Transparency = 0.35 end
	if tok == "darkStone" and grp == "Medal" then p.Color = rgb(40, 45, 55) end
	if tok == "gold" and grp == "Medal" then p.Color = rgb(120, 107, 41); p.Material = SM end -- pass 11: rendered (222,193,58) against (180,165,62); (140,128,50) still (212,199,68): x1.5 -- pass 10: Metal rendered (141,122,28) on the flat medallion against (179,164,63); SM (150,128,48) ~ (186,159,60)
	if tok == "white" and grp == "Isl6" then p.Color = rgb(215, 215, 205) end
	if grp and grp:sub(1, 4) == "Isl7" then -- pass 7 slab islands: grey rock, lush cap, pale ruins
		if tok == "rock" then p.Color = rgb(175, 170, 155); p.Material = Enum.Material.Slate end -- pass 8: warm base so the far, hazed rock renders grey, not blue
		if tok == "grass" then p.Color = rgb(112, 165, 62); p.Material = GR end
		if tok == "white" then p.Color = rgb(222, 220, 210) end
	end
	if tok == "cloud" or tok == "fall" or tok == "eye" then p.CastShadow = false end
	if tok == "glass" and grp == "Crystal" then p.Color = tint or rgb(60, 110, 230); p.Material = GL; p.Transparency = 0.15 end
	if tok == "wood" and tint and (grp == "DeadTree") then p.Color = tint end
	if tok == "glass" or tok == "water" or tok == "foam" or tok == "sheet" or tok == "core" or tok == "vine" then p.CastShadow = false end
end
local old = workspace:FindFirstChild("Plaza"); if old then old:Destroy() end
local root = Instance.new("Folder"); root.Name = "Plaza"; root.Parent = workspace
local function place(prefix, cf, scale, tint, parent, rim)
	scale = scale or 1
	local m = Instance.new("Model"); m.Name = prefix
	for _, k in ipairs(kit:GetChildren()) do
		if k.Name:sub(1, #prefix + 1) == prefix .. "_" then
			local c = k:Clone(); c.Size = k.Size * scale
			c.CFrame = cf * CFrame.new(k.Position * scale) * (k.CFrame - k.CFrame.Position)
			look(c, tint, rim); c.Parent = m
		end
	end
	m.Parent = parent or root
	return m
end
local function part(name, size, cf, color, mat, shape, parent)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf
	p.Color = color; p.Material = mat or SM; if shape then p.Shape = shape end
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or root; return p
end
local function blob(name, size, pos, color, mat, parent) -- non-uniform sphere for skull, glows
	local p = part(name, size, CFrame.new(pos), color, mat or SM, Enum.PartType.Ball, parent)
	local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = p
	return p
end
local function tex(p, id, stud)
	local t = Instance.new("Texture"); t.Texture = id; t.Face = Enum.NormalId.Top; t.StudsPerTileU = stud; t.StudsPerTileV = stud
	t.Color3 = rgb(128, 131, 134); t.Parent = p -- a Texture covers the part colour with its own (white by default): tint it
end
local FLOOR_TEX = "rbxassetid://82579788770020"   -- own pale slab texture (tex/make_ae_tex4.py), 12 studs = 2x2 slabs
local PALE, GOLD, SLATE = LOOK.pale[1], rgb(150, 128, 48), LOOK.slate[1] -- pass 10: SmoothPlastic gold parts (150,128,48) render about (186,159,60) against the (180,160,65) target
local rng = Random.new(11)
local function rot() return CFrame.Angles(0, rng:NextNumber(0, 6.28), 0) end
local R2 = math.sqrt(2)

-- 1. hero pieces (kit is in plaza coordinates)
for _, pre in ipairs({ "K_Hero", "K_Stairs", "K_Medal" }) do
	local m = place(pre, CFrame.new())
	for _, p in ipairs(m:GetChildren()) do pcall(function() p.CollisionFidelity = Enum.CollisionFidelity.PreciseConvexDecomposition end) end
end
-- pass 9 (round-6 item 4): arch cheeks, banners and parapets to slate (base darker than the (65,72,85) target: the sky
-- ambient adds blue), vault interior near-black grey; the egg dome (Neon foam inside the glass sheet) is hidden
do
	local h = root:FindFirstChild("K_Hero")
	-- pass 10 (round-7 item 2): two-tone. stone = crest, horns, cheeks, outer band, wings: (101,107,111) renders (124-129,132-137,134-138)
	-- against the (130,135,135) target; rib/darkStone = the recessed inner bands render (64,70,74) against (55,62,72)
	h.K_Hero_stone.Color = rgb(101, 107, 111); h.K_Hero_vault.Color = rgb(40, 46, 54)
	h.K_Hero_rib.Color = rgb(68, 78, 90); h.K_Hero_darkStone.Color = rgb(62, 68, 76)
	h.K_Hero_foam.Transparency = 1; h.K_Hero_sheet.Transparency = 1
	h.K_Hero_foam.CanCollide = false; h.K_Hero_sheet.CanCollide = false
end
-- vault lights and fountain mist (round-3 item 1/8): a small cyan PointLight in each vault, mist at the sheet's foot
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	local function at(u, y, w) return Vector3.new(qx * (w + u) / R2, y, qz * (w - u) / R2) end
	local a = part("VaultLight", Vector3.new(0.2, 0.2, 0.2), CFrame.new(at(0, 6.2, 37.5)), rgb(0, 0, 0)); a.Transparency = 1; a.CanCollide = false
	local L = Instance.new("PointLight"); L.Color = rgb(150, 200, 220); L.Range = 14; L.Brightness = 0.5; L.Shadows = false; L.Parent = a -- pass 9: 3 -> 0.5, it tinted the vault navy (pass 10: the comment had swallowed L.Parent, so this light never existed in r9)
	local m = part("Mist", Vector3.new(2.4, 0.2, 2.4), CFrame.new(at(0, 4.4, BASIN_R + 1.0)), rgb(0, 0, 0)); m.Transparency = 1; m.CanCollide = false
	local e = Instance.new("ParticleEmitter"); e.Color = ColorSequence.new(rgb(220, 245, 255)); e.LightEmission = 0.4
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1.8) })
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(1, 1) })
	e.Lifetime = NumberRange.new(0.8, 1.4); e.Rate = 18; e.Speed = NumberRange.new(1.5, 3); e.SpreadAngle = Vector2.new(35, 35)
	e.Acceleration = Vector3.new(0, -2, 0); e.Parent = m
end end
task.wait()

-- 2. ground: sunken plaza floor (y 0) inside the terrace (y 6), one neutral grass terrace, organic zone patches on top
tex(part("PlazaFloor", Vector3.new(96, 2, 96), CFrame.new(0, -1, 0), PALE), FLOOR_TEX, 12)
local ZBASE = rgb(116, 150, 56) -- pass 7: warm yellow-green (was 78,128,56, rendered teal)
part("GroundN", Vector3.new(1700, 6, 800), CFrame.new(0, 3, -48 - 400), ZBASE, GR)
part("GroundS", Vector3.new(1700, 6, 800), CFrame.new(0, 3, 48 + 400), ZBASE, GR)
part("GroundE", Vector3.new(800, 6, 96), CFrame.new(48 + 400, 3, 0), ZBASE, GR)
part("GroundW", Vector3.new(800, 6, 96), CFrame.new(-48 - 400, 3, 0), ZBASE, GR)
part("WaterEdge", Vector3.new(4000, 1, 4000), CFrame.new(0, -2.6, 0), rgb(70, 130, 160), GL).Transparency = 0.2
local G = Instance.new("Folder"); G.Name = "Zoning"; G.Parent = root
local GRAVEL, REDL, WATERC, SAND, WHITEF, GREEN2 = rgb(62, 66, 64), rgb(190, 45, 40), rgb(90, 170, 200), rgb(176, 160, 118), rgb(225, 228, 235), rgb(132, 165, 60)
local function patch(kind, x, z, sc, col, layer, mat)
	local m = place("K_Patch" .. kind, CFrame.new(x, 6.0 + 0.05 * layer, z) * rot(), sc, col, G)
	if mat then for _, p in ipairs(m:GetChildren()) do p.Material = mat end end
	return m
end
local function zoneAt(x, z) -- which zone owns (x, z): wedges by angle, organic edges come from the patches themselves
	if math.abs(x) >= math.abs(z) then return x > 0 and "E" or "W" end
	return z > 0 and "S" or "N"
end
local function inPlaza(x, z, pad) -- keep patches off the plaza ring / arms: plaza square 62 + pad, arm strips
	pad = pad or 6
	if math.abs(x) < 62 + pad and math.abs(z) < 62 + pad then return true end
	if math.abs(x) < 20 + pad and z < 0 and z > -160 then return true end -- N avenue
	return false
end
local nPatch = 0
for i = 1, 260 do
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(70, 260)
	local x, z = r * math.cos(a), r * math.sin(a)
	if not inPlaza(x, z, 8) then
		local zn = zoneAt(x, z); local k = ({ "A", "B", "C" })[i % 3 + 1]
		if zn == "E" then
			patch(k, x, z, rng:NextNumber(1.0, 1.8), GRAVEL, 1, Enum.Material.Slate)
			if i % 3 ~= 0 then patch(({ "B", "C" })[i % 2 + 1], x + rng:NextNumber(-8, 8), z + rng:NextNumber(-8, 8), rng:NextNumber(0.5, 0.95), REDL, 2, SM) end
			if i % 7 == 0 then patch("C", x + 10, z - 6, 0.8, GREEN2, 3, GR) end
		elseif zn == "W" then
			if i % 4 == 0 and r < 150 then patch(k, x, z, rng:NextNumber(0.6, 1.1), WATERC, 2, GL) -- pass 7: no far water (read as dark holes)
			elseif i % 4 == 1 then patch("C", x, z, rng:NextNumber(0.5, 0.9), WHITEF, 2, SM)
			else patch(k, x, z, rng:NextNumber(0.9, 1.5), rgb(105, 140, 60), 1, GR) end
		else
			if i % 3 == 0 then patch(k, x, z, rng:NextNumber(0.6, 1.2), SAND, 1, Enum.Material.Sand)
			else patch(k, x, z, rng:NextNumber(0.9, 1.6), (i % 2 == 0) and GREEN2 or rgb(104, 138, 52), 1, GR) end
		end
		nPatch += 1
	end
	if i % 40 == 0 then task.wait() end
end

-- 3. arms on the terrace: N long avenue with a water channel to the Summon hall; E/W/S narrow arms ending about 82 out
local function arm(i, width, len, channel)
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a))
	local r = CFrame.lookAt(Vector3.zero, dir)
	local function at(d, y) return CFrame.new(dir * d + Vector3.new(0, y, 0)) * r end
	tex(part("Arm" .. i, Vector3.new(width, 1, len), at(48 + len / 2, 5.6), PALE), FLOOR_TEX, 12)
	for s = -1, 1, 2 do part("ArmEdge" .. i, Vector3.new(0.6, 0.12, len), at(48 + len / 2, 6.12) * CFrame.new(s * (width / 2 - 0.6), 0, 0), GOLD) end
	if channel then
		part("Channel" .. i, Vector3.new(6, 0.2, len - 4), at(48 + len / 2 + 2, 6.05), rgb(85, 170, 215), SM).Transparency = 0.05 -- pass 11: bright cyan (90,200,230), was dark glass
		for s = -1, 1, 2 do part("ChanSand" .. i, Vector3.new(3, 0.1, len - 6), at(48 + len / 2 + 2, 6.12) * CFrame.new(s * 5.4, 0, 0), rgb(205, 185, 135), Enum.Material.Sand) end -- pass 11: sand strips
		part("ChannelBed" .. i, Vector3.new(6, 0.2, len - 4), at(48 + len / 2 + 2, 5.3), rgb(50, 95, 125))
		for s = -1, 1, 2 do part("ChanKerb" .. i, Vector3.new(0.8, 0.5, len - 4), at(48 + len / 2 + 2, 6.15) * CFrame.new(s * 3.4, 0, 0), GOLD) end
		for s = -1, 1, 2 do part("Runner" .. i, Vector3.new(4, 0.08, len - 6), at(48 + len / 2 + 2, 6.13) * CFrame.new(s * 9, 0, 0), RUNNER_BLUE) end
	else
		part("Runner" .. i, Vector3.new(5, 0.08, len - 4), at(48 + len / 2, 6.13), RUNNER_BLUE)
		part("RunInset" .. i, Vector3.new(2.2, 0.1, len - 6), at(48 + len / 2, 6.14), LOOK.navy[1])
		for s = -1, 1, 2 do part("RunEdge" .. i, Vector3.new(0.4, 0.12, len - 4), at(48 + len / 2, 6.15) * CFrame.new(s * 2.7, 0, 0), GOLD) end
		local e = 48 + len
		local tip = part("ArmTip" .. i, Vector3.new(width * 0.95, 1, width * 0.95), at(e, 5.6) * CFrame.Angles(0, math.rad(45), 0), PALE); tex(tip, FLOOR_TEX, 12)
		part("ArmCross" .. i, Vector3.new(width * 2.0, 1, 7), at(e - 6, 5.62), PALE)
		part("TipDiamond" .. i, Vector3.new(4.5, 0.12, 4.5), at(e, 6.13) * CFrame.Angles(0, math.rad(45), 0), LOOK.navy[1])
		part("TipGem" .. i, Vector3.new(2.2, 0.16, 2.2), at(e, 6.15) * CFrame.Angles(0, math.rad(45), 0), rgb(85, 160, 210), NE).Transparency = 0.3
	end
end
arm(0, 37, 104, true); arm(1, 17, 22); arm(2, 17, 22); arm(3, 17, 22)
task.wait()

-- 4. bollards: 4 on the diagonals at the dais edge, facing the gates
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	place("K_Bollard", CFrame.new(qx * 9.6, 0.3, qz * 9.6) * CFrame.Angles(0, math.atan2(qx, qz), 0))
end end

-- 5. planting (round-3 item 3): few palms, big fluffy broadleaf trees in gold / purple / blue, bare red trees east.
local P = Instance.new("Folder"); P.Name = "Planting"; P.Parent = root
local BLUE, BLUER, PURPLE, GOLDT, RED = rgb(45, 95, 235), rgb(120, 170, 255), rgb(150, 110, 210), rgb(215, 170, 40), rgb(160, 34, 40)
local FB = rgb(55, 110, 235)
local PALMWOOD = rgb(150, 110, 60)
local function palm(name, x, z, sc, frond, lean, yaw, parent, y)
	-- palm bends toward +X in the kit; yaw turns the bend outward, lean tilts the whole trunk a little more
	-- the imported kit is yawed 180 deg against the authoring frame (x and z both flip), so add pi to point the bend outward
	local m = place(name, CFrame.new(x, y or 6, z) * CFrame.Angles(0, yaw + math.pi, 0) * CFrame.Angles(0, 0, -math.rad(lean)), sc, frond, parent or P, lighten(frond, 0.3))
	for _, p in ipairs(m:GetChildren()) do if p.Name:find("_wood") then p.Color = PALMWOOD end end
	return m
end
local function fluffy(name, x, y, z, sc, col, parent)
	local m = place(name, CFrame.new(x, y, z) * rot(), sc, col, parent or P, lighten(col, 0.35))
	for _, p in ipairs(m:GetChildren()) do if p.Name:find("_wood") then p.Color = rgb(130, 92, 60) end end
	return m
end
local FERN = { E = rgb(170, 50, 45), W = rgb(55, 110, 200), S = rgb(95, 150, 45), N = rgb(60, 105, 210) }
local TREEZ = { N = { GOLDT, PURPLE, BLUE }, W = { BLUE, BLUE, rgb(60, 160, 170) }, E = { RED, GOLDT, RED }, S = { rgb(95, 160, 60), GOLDT, BLUE } }
-- behind each gate, on the pool rock: a fluffy blue tree with 2 floating crystals (between the lanterns)
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	fluffy("K_FluffyS", qx * 38.9, 9.4, qz * 38.9, 1.25, BLUE)
	for s = -1, 1, 2 do
		local u, w = s * 5.5, 50
		local x, z = qx * math.abs((w + u) / R2), qz * math.abs((u - w) / R2)
		place("K_Crystal", CFrame.new(x, 16 + 2 * s, z) * rot() * CFrame.Angles(0.3, 0, 0.2), 1.1, rgb(70, 130, 240), P)
	end
end end
-- N avenue: 2 palms per side (about 22 tall), leaning consistently outward; gold tree left, purple wisteria right
for k = 0, 1 do
	for s = -1, 1, 2 do
		palm(k == 0 and "K_Palm6A" or "K_Palm6B", s * 23, -64 - 26 * k, 1.0 + 0.05 * k, FB, 6, s > 0 and 0 or math.pi)
	end
end
fluffy("K_Fluffy", -24, 6, -100, 1.15, GOLDT)
fluffy("K_Fluffy", -34, 6, -128, 0.9, GOLDT)
fluffy("K_Wisteria", 22, 6, -88, 1.0, PURPLE)
fluffy("K_Wisteria", 30, 6, -106, 0.85, PURPLE)
fluffy("K_FluffyS", 26, 6, -128, 1.1, rgb(60, 170, 175))
-- per quadrant behind the pools: 1 palm, 2 fluffy trees (zone colours)
local corner = { { 1, -1 }, { -1, -1 }, { 1, 1 }, { -1, 1 } }
for ci, q in ipairs(corner) do
	local qx, qz = q[1], q[2]
	local x, z = qx * 74, qz * 56
	local zn = zoneAt(x, z)
	palm(ci % 2 == 0 and "K_Palm6A" or "K_Palm6B", x, z, 1.0, zn == "E" and RED or (zn == "S" and rgb(80, 150, 55) or FB), 5, math.atan2(-qz, qx))
	fluffy("K_Fluffy", qx * 96, 6, qz * 84, 0.95, TREEZ[zoneAt(qx * 96, qz * 60)][ci % 3 + 1])
	fluffy("K_FluffyS", qx * 66, 6, qz * 96, 1.3, TREEZ[zoneAt(qx * 40, qz * 96)][(ci + 1) % 3 + 1])
end
-- outer ring: 16 trees and palms, 105-200 out
for i = 1, 16 do
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(110, 200)
	local x, z = r * math.cos(a), r * math.sin(a)
	if not inPlaza(x, z, 20) then
		local zn = zoneAt(x, z)
		if i % 4 == 0 then palm("K_Palm6A", x, z, rng:NextNumber(1.0, 1.2), zn == "E" and RED or FB, 6, rng:NextNumber(0, 6.28))
		elseif zn == "E" and i % 2 == 0 then place("K_DeadTree", CFrame.new(x, 6, z) * rot(), rng:NextNumber(1.0, 1.4), rgb(95, 30, 32), P)
		else fluffy(i % 3 == 0 and "K_FluffyS" or "K_Fluffy", x, 6, z, rng:NextNumber(0.9, 1.3), TREEZ[zn][i % 3 + 1]) end
	end
end
task.wait()
-- stairs and floor dressing (round-3 item 9): grass/litter spilling over the step edges, 8 per flight, plus floor patches
local function stepY(d) return math.clamp(math.floor((d - 28) / 2.5) + 1, 0, 8) * 0.75 end
local FLIGHT = { [0] = rgb(70, 115, 230), [1] = rgb(180, 45, 40), [2] = rgb(95, 160, 50), [3] = rgb(95, 160, 50) } -- N blue, E red, S/W green
local nf = 0
local GRASSY, REDB, BLUEB = rgb(150, 178, 75), rgb(190, 45, 40), rgb(40, 90, 230)
local CLUMP = { [0] = { "K_ClumpB", BLUEB }, [1] = { "K_ClumpB", REDB }, [2] = { "K_ClumpG", GRASSY }, [3] = { "K_ClumpG", GRASSY } }
for i = 0, 3 do
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a)); local side = Vector3.new(math.cos(a), 0, math.sin(a))
	for k = 1, 2 do -- pass 11: 3 -> 2 tread spills per flight
		local d = rng:NextNumber(28.5, 47); local lat = (k % 2 == 0 and 1 or -1) * rng:NextNumber(6.5, 16)
		local p = dir * d + side * lat
		place("K_Litter", CFrame.new(p.X, stepY(d), p.Z) * rot(), rng:NextNumber(0.9, 1.3), FLIGHT[i], P); nf += 1
	end
	-- pass 7 (round-4 item 3): 8 mounded clumps per flight, 3.2-5 across, grass S/W, red bushes E, blue bushes N
	local CL = CLUMP[i]
	for k = 1, 8 do
		local d = 29 + (k - 1) * 2.4 + rng:NextNumber(-0.6, 0.6); local lat = (k % 2 == 0 and 1 or -1) * rng:NextNumber(6.5, 15.5)
		local p = dir * d + side * lat
		place(CL[1], CFrame.new(p.X, stepY(d) - 0.05, p.Z) * rot(), rng:NextNumber(0.8, 1.25), CL[2]:Lerp(rgb(20, 25, 20), 0.35), P, CL[2]); nf += 1 -- dark mound, bright tips
	end
	-- pale nosing on every step edge (item 4): 8 steps x 2 sides
	for st = 0, 7 do
		for s = -1, 1, 2 do
			local p = dir * (28 + 2.5 * st + 0.18) + side * (s * 11.0)
			part("Nosing", Vector3.new(0.3, 0.1, 13.2), CFrame.lookAt(Vector3.new(p.X, 0.75 * (st + 1) + 0.03, p.Z), Vector3.new(p.X, 0.75 * (st + 1) + 0.03, p.Z) + side), rgb(150, 152, 150), SM, nil, P)
		end
	end
	for k = 1, 1 do -- pass 11: 3 -> 1; floor patches 3-6 wide at the stair feet
		local d = rng:NextNumber(20, 26); local lat = (k % 2 == 0 and 1 or -1) * rng:NextNumber(8, 15)
		local p = dir * d + side * lat
		place("K_Litter", CFrame.new(p.X, 0, p.Z) * rot(), rng:NextNumber(0.6, 0.85), FLIGHT[i]:Lerp(rgb(60, 70, 60), 0.2), P); nf += 1
	end
end
-- pass 7: grass lawns at the top of the S and W flights (between the arm and the corner blocks) with clumps on them,
-- and grass spilling onto the floor at their feet
for _, i in ipairs({ 2, 3 }) do
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a)); local side = Vector3.new(math.cos(a), 0, math.sin(a))
	for s = -1, 1, 2 do
		local c = dir * 56 + side * (s * 13)
		part("Lawn", Vector3.new(8.6, 0.3, 16.5), CFrame.lookAt(Vector3.new(c.X, 6.0, c.Z), Vector3.new(c.X, 6.0, c.Z) + dir), GRASSY, GR, nil, P).CastShadow = false
		for k = 1, 4 do
			local p = dir * rng:NextNumber(49.5, 62) + side * (s * rng:NextNumber(10, 16))
			place("K_ClumpG", CFrame.new(p.X, 6.1, p.Z) * rot(), rng:NextNumber(1.0, 1.4), GRASSY:Lerp(rgb(20, 25, 20), 0.35), P, GRASSY); nf += 1
		end
		for k = 1, 2 do
			local p = dir * rng:NextNumber(23, 27) + side * (s * rng:NextNumber(7, 15))
			place("K_ClumpG", CFrame.new(p.X, 0.05, p.Z) * rot(), rng:NextNumber(0.9, 1.3), GRASSY:Lerp(rgb(20, 25, 20), 0.35), P, GRASSY); nf += 1
		end
	end
end
for s = -1, 1, 2 do -- pass 8 (round-5 item 3): lawn strip right across the top of the S flight (runner left clear)
	local c = Vector3.new(s * 9.6, 6.02, 50.6)
	part("LawnTop", Vector3.new(12.8, 0.3, 5.2), CFrame.new(c), GRASSY, GR, nil, P).CastShadow = false
	for k = 1, 3 do place("K_ClumpG", CFrame.new(s * rng:NextNumber(5, 15), 6.1, rng:NextNumber(49, 52.5)) * rot(), rng:NextNumber(1.0, 1.3), GRASSY:Lerp(rgb(20, 25, 20), 0.35), P, GRASSY); nf += 1 end
end
for i = 0, 1 do -- red / blue bush clumps at the N and E stair feet
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a)); local side = Vector3.new(math.cos(a), 0, math.sin(a))
	for k = 1, 4 do
		local p = dir * rng:NextNumber(23, 27) + side * ((k % 2 == 0 and 1 or -1) * rng:NextNumber(7, 15))
		place("K_ClumpB", CFrame.new(p.X, 0.05, p.Z) * rot(), rng:NextNumber(0.9, 1.3), CLUMP[i][2]:Lerp(rgb(20, 25, 20), 0.35), P, CLUMP[i][2]); nf += 1
	end
end
for qx = -1, 1, 2 do for qz = -1, 1, 2 do -- basin feet: ferns either side of each basin
	for k = 1, 4 do
		local u = (k <= 2 and -1 or 1) * rng:NextNumber(6.5, 8.5); local w = rng:NextNumber(26, 31)
		local x, z = qx * math.abs((w + u) / R2), qz * math.abs((u - w) / R2)
		place("K_Fern", CFrame.new(x, 0, z) * rot(), rng:NextNumber(1.0, 1.35), FERN[zoneAt(x * (k <= 2 and 2 or 0.5), z * (k <= 2 and 0.5 or 2))], P); nf += 1
	end
end end
for i = 1, 60 do -- terrace carpet: ferns and litter in zone colours
	local a = rng:NextNumber(0, 2 * math.pi); local r = rng:NextNumber(52, 130)
	local x, z = r * math.cos(a), r * math.sin(a)
	if math.abs(x) < 20 or math.abs(z) < 20 then continue end
	if math.abs(x) < 62 and math.abs(z) < 62 then continue end
	local zn = zoneAt(x, z)
	place(i % 2 == 0 and "K_Litter" or "K_Fern", CFrame.new(x, 6.3, z) * rot(), rng:NextNumber(1.2, 1.8), FERN[zn], P); nf += 1
end
-- pass 8 (round-5 item 5): cover the east (Raid) quadrant: dense red broadleaf trees, big red bush mounds, dead trees,
-- red litter on the E stair treads and the floor below them
local REDS = { rgb(150, 40, 40), rgb(175, 55, 50), rgb(190, 70, 60), rgb(160, 45, 70) }
local nE = 0
for i = 1, 140 do
	local x, z = rng:NextNumber(66, 230), rng:NextNumber(-200, 200)
	if math.abs(z) > x * 1.05 or (x < 130 and math.abs(z) < 60) then continue end -- east wedge, keep the Raid forecourt open
	local c = REDS[i % 4 + 1]
	if i % 3 == 0 then fluffy(i % 2 == 0 and "K_Fluffy" or "K_FluffyS", x, 6, z, rng:NextNumber(0.8, 1.3), c, P)
	elseif i % 7 == 1 then place("K_DeadTree", CFrame.new(x, 6, z) * rot(), rng:NextNumber(0.8, 1.1), rgb(40, 30, 35), P)
	else place("K_ClumpB", CFrame.new(x, 6.05, z) * rot(), rng:NextNumber(2.4, 3.6), c:Lerp(rgb(20, 10, 10), 0.35), P, c) end
	nE += 1
	if i % 30 == 0 then task.wait() end
end
do
	local dir, side = Vector3.new(1, 0, 0), Vector3.new(0, 0, 1)
	for k = 1, 4 do -- pass 11: 14 -> 4 (thin spills)
		local d = rng:NextNumber(28.3, 47.5); local lat = (k % 2 == 0 and 1 or -1) * rng:NextNumber(3.5, 16)
		local p = dir * d + side * lat
		place("K_Litter", CFrame.new(p.X, stepY(d) + 0.02, p.Z) * rot(), rng:NextNumber(0.8, 1.2), rgb(185, 45, 40), P); nf += 1
	end
	for k = 1, 0 do -- pass 11: no red spill on the floor
		local p = dir * rng:NextNumber(12, 27) + side * rng:NextNumber(-16, 16)
		place("K_Litter", CFrame.new(p.X, 0.02, p.Z) * rot(), rng:NextNumber(0.7, 1.1), rgb(180, 45, 40), P); nf += 1
	end
end
task.wait()

-- 6. landmarks at each arm end (round-3 item 7)
local LM = Instance.new("Folder"); LM.Name = "Landmarks"; LM.Parent = root
-- signs: a plate with an own SurfaceGui text (generic words, own font choice)
local function sign(name, text, size, cf, plate, txtc, face, parent)
	local p = part(name, size, cf, plate, SM, nil, parent)
	local g = Instance.new("SurfaceGui"); g.Face = face; g.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; g.PixelsPerStud = 40
	g.LightInfluence = 0.2; g.Parent = p
	local t = Instance.new("TextLabel"); t.Size = UDim2.fromScale(1, 1); t.BackgroundTransparency = 1; t.Text = text; t.TextScaled = true
	t.Font = Enum.Font.Bangers; t.TextColor3 = txtc; t.TextStrokeTransparency = 0.2; t.TextStrokeColor3 = rgb(30, 20, 20); t.Parent = g
	return p
end
-- N: Summon hall (pass 7, round-4 item 5): moved back 15, an ornate cream facade 40 wide x 30 tall from the own arcade kit
-- piece at 2x (4 pointed bays), gold bands, 2 domed corner towers, a dome behind, a "Summon" sign plate
local CREAM, CREAMD = rgb(215, 195, 140), rgb(150, 140, 115)
local HZ = -185
local sa = place("K_Arcade7", CFrame.new(0, 6, HZ) * CFrame.Angles(0, math.pi / 2 + math.pi, 0), 2.0, nil, LM) -- faces +Z (kit yawed 180)
for _, p in ipairs(sa:GetChildren()) do p.Color = p.Name:find("_darkStone") and rgb(70, 58, 50) or CREAM end
part("SummonBody", Vector3.new(40, 26, 18), CFrame.new(0, 19, HZ - 12), CREAMD, SM, nil, LM)
part("SummonBand", Vector3.new(41.5, 0.7, 6.2), CFrame.new(0, 6 + 20.3, HZ), GOLD, SM, nil, LM)
part("SummonBand2", Vector3.new(41.5, 0.5, 6.2), CFrame.new(0, 6 + 1.0, HZ), GOLD, SM, nil, LM)
blob("SummonDome", Vector3.new(20, 18, 20), Vector3.new(0, 34, HZ - 12), rgb(200, 165, 60), SM, LM)
part("SummonFinial", Vector3.new(1, 6, 1), CFrame.new(0, 45, HZ - 12), GOLD, SM, nil, LM)
sign("SummonSign", "Summon", Vector3.new(15, 3.4, 0.6), CFrame.new(0, 6 + 17.9, HZ + 3.3), rgb(200, 172, 60), rgb(45, 60, 140), Enum.NormalId.Back, LM)
for s = -1, 1, 2 do
	local t = place("K_RTower7", CFrame.new(s * 23.5, 6, HZ) * rot(), 1.15, nil, LM)
	for _, p in ipairs(t:GetChildren()) do
		if p.Name:find("_stone") then p.Color = CREAM elseif p.Name:find("_dome") then p.Color = rgb(200, 165, 60) elseif p.Name:find("_darkStone") then p.Color = rgb(70, 58, 50) end
	end
end
-- avenue clutter: market umbrellas with tables, and blue cypress cones
local UMB = { rgb(225, 70, 70), rgb(60, 120, 230), rgb(240, 200, 60), rgb(240, 240, 240), rgb(80, 190, 120), rgb(230, 120, 200) }
for k = 1, 6 do
	local s = (k % 2 == 0) and 1 or -1
	local u = place("K_Umbrella7", CFrame.new(s * rng:NextNumber(13, 15.5), 6, -62 - 14 * k) * rot(), rng:NextNumber(0.9, 1.1), nil, LM)
	for _, p in ipairs(u:GetChildren()) do if p.Name:find("_canopy") then p.Color = UMB[k] end; if p.Name:find("_white") then p.Color = rgb(235, 235, 235) end end
	part("Stall", Vector3.new(4, 2.6, 2.4), CFrame.new(s * 16.8, 7.3, -69 - 14 * k), rgb(150, 105, 65), SM, nil, LM)
end
for k = 1, 3 do
	for s = -1, 1, 2 do place("K_Cypress", CFrame.new(s * 17.5, 6, -95 - 22 * k), 1.2, rgb(55, 100, 230), LM, rgb(110, 160, 255)) end
end
-- pass 8 (round-5 item 6): the gold-tree mass framing Summon in r1: 4 big gold broadleaf trees (25-30 tall) behind and
-- beside the hall
for _, t in ipairs({ { -38, HZ - 6, 2.3 }, { 40, HZ - 4, 2.1 }, { -18, HZ - 30, 2.6 }, { 22, HZ - 28, 2.4 } }) do -- pass 9: 35-40 tall
	fluffy("K_Fluffy", t[1], 6, t[2], t[3], rgb(220, 175, 50), LM)
end
-- S: Expeditions (pass 8, round-5 item 3): own ornate gate 1.5x (teal frame, gold trims, teal stained glass with gold
-- mullions and a rose ring, pale columns with teal domes), an own 14x3 "Expeditions" sign, 2 crystal braziers, and a halo
-- of 8 curved crescent shards (r 12) round a 5x8 white Neon oval, centred about 10 above the gate.
local EZ = 88
local ex = place("K_ExpGate8", CFrame.new(0, 6, EZ) * CFrame.Angles(0, math.pi, 0), 1.0, nil, LM) -- kit arrives yawed 180
for _, p in ipairs(ex:GetChildren()) do
	if p.Name:find("_teal") then p.Color = rgb(40, 140, 140); p.Material = SM end
	if p.Name:find("_gold") then p.Color = rgb(200, 172, 60); p.Material = SM; p.Reflectance = 0.05 end
	if p.Name:find("_pale") then p.Color = rgb(205, 228, 222) end
	if p.Name:find("_glass") then p.Color = rgb(60, 170, 170); p.Material = GL; p.Transparency = 0.35; p.CanCollide = false end
end
part("ExpStep", Vector3.new(38, 1, 9), CFrame.new(0, 6.5, EZ), rgb(160, 165, 168), SM, nil, LM)
sign("ExpSign", "Expeditions", Vector3.new(14, 3, 0.6), CFrame.new(0, 6 + 27.6, EZ - 2.6), rgb(30, 70, 80), rgb(150, 255, 235), Enum.NormalId.Front, LM)
for s = -1, 1, 2 do
	part("BrazierBase", Vector3.new(3, 5, 3), CFrame.new(s * 21, 8.5, EZ - 3), rgb(150, 200, 195), SM, nil, LM)
	place("K_Crystal", CFrame.new(s * 21, 11.2, EZ - 3), 0.9, rgb(50, 190, 190), LM)
end
local rgc = CFrame.new(0, 6 + 25.5 + 26, EZ + 3) * CFrame.Angles(0, math.pi, 0)
local ring = place("K_ExpRing8", rgc, 1.5, nil, LM) -- pass 10: 1.3x larger, 10 higher, island behind it moved aside
for _, p in ipairs(ring:GetChildren()) do
	if p.Name:find("_stone") then p.Color = rgb(175, 180, 192); p.Material = SM end
	if p.Name:find("_core") then p.Color = rgb(240, 250, 255); p.Material = NE; p.Transparency = 0.05; p.CastShadow = false end
end
-- E: Raid (pass 7, round-4 item 2): own gothic gate in darker weathered red (150,65,65) with (92,40,48) trim; behind it a
-- tower block carrying the own carved skull kit piece (1.5x: about 14 wide) on its tapered pedestal, glowing red eyes and a
-- red neon beam running down to an own "Raid" sign; 2 domed side towers and 2 arcade wings make the complex about 90 wide;
-- red light and a red haze emitter.
-- pass 8 (round-5 item 2): weathered and darker: walls (130,55,58) Slate, trim (92,40,48), towers/spires near-black red
-- (60,25,30), the own pass-8 skull (deeper relief) in grey-red (125,85,72) Slate, 8 dead red trees and a denser haze.
local WR, WR2, DK, TW = rgb(175, 100, 100), rgb(175, 100, 100), rgb(85, 38, 42), rgb(62, 30, 36) -- pass 10: lit (200,80,88) / trim (95,35,45) / spires (70,30,40) targets -- pass 9: lit red (170,70,75) / trim (90,35,45) -- base darker than the (130,55,58) target: Slate in sun + red light renders ~+40
local SL = Enum.Material.Slate
local RX = 90
local rg = place("K_Gothic", CFrame.new(RX, 6, 0) * CFrame.Angles(0, math.pi, 0), 1.0, nil, LM) -- kit arrives yawed 180
for _, p in ipairs(rg:GetChildren()) do if p.Name:find("_stone") then p.Color = WR2; p.Material = SL end; if p.Name:find("_gold") then p.Color = DK end; if p.Name:find("_darkStone") then p.Color = rgb(14, 8, 12) end end
part("RaidTower", Vector3.new(16, 30, 16), CFrame.new(RX + 14, 21, 0), rgb(110, 48, 52), SL, nil, LM)
part("RaidTowerCap", Vector3.new(17, 1.2, 17), CFrame.new(RX + 14, 36.4, 0), DK, SM, nil, LM)
local sk = place("K_Skull8", CFrame.new(RX + 14, 66, 0) * CFrame.Angles(0, math.pi, 0), 1.5, nil, LM)
for _, p in ipairs(sk:GetChildren()) do
	if p.Name:find("_bone") then p.Color = rgb(125, 85, 72); p.Material = SL end
	if p.Name:find("_dark") then p.Color = rgb(30, 12, 14) end
end
part("RaidBeam", Vector3.new(0.6, 22, 1.6), CFrame.new(RX + 5.6, 45, 0), rgb(255, 45, 45), NE, nil, LM).CastShadow = false
sign("RaidSign", "Raid", Vector3.new(0.6, 3.6, 11), CFrame.new(RX - 2.2, 36.2, 0), DK, rgb(255, 225, 200), Enum.NormalId.Left, LM)
local rl = part("RaidLight", Vector3.new(0.2, 0.2, 0.2), CFrame.new(RX - 4, 16, 0), rgb(0, 0, 0), SM, nil, LM); rl.Transparency = 1; rl.CanCollide = false
local pl = Instance.new("PointLight"); pl.Color = rgb(255, 60, 50); pl.Range = 30; pl.Brightness = 0.9; pl.Parent = rl
local el = part("SkullLight", Vector3.new(0.2, 0.2, 0.2), CFrame.new(RX + 4, 66, 0), rgb(0, 0, 0), SM, nil, LM); el.Transparency = 1; el.CanCollide = false
local pe = Instance.new("PointLight"); pe.Color = rgb(255, 40, 40); pe.Range = 12; pe.Brightness = 1.2; pe.Parent = el
local hz = part("RaidHaze", Vector3.new(30, 1, 80), CFrame.new(RX + 6, 10, 0), rgb(0, 0, 0), SM, nil, LM); hz.Transparency = 1; hz.CanCollide = false
local he = Instance.new("ParticleEmitter"); he.Color = ColorSequence.new(rgb(220, 50, 45)); he.LightEmission = 0.1
he.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 10), NumberSequenceKeypoint.new(1, 22) })
he.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.8), NumberSequenceKeypoint.new(1, 1) })
he.Lifetime = NumberRange.new(6, 9); he.Rate = 6; he.Speed = NumberRange.new(0.5, 1.5); he.SpreadAngle = Vector2.new(60, 60)
he.Acceleration = Vector3.new(0, 0.6, 0); he.Parent = hz
for s = -1, 1, 2 do
	local sp = place("K_Spire", CFrame.new(RX + 2, 6, s * 13), 1.0, nil, LM)
	for _, p in ipairs(sp:GetChildren()) do p.Color = p.Name:find("_stone") and TW or DK; p.Material = SL end
	local t = place("K_RTower7", CFrame.new(RX + 4, 6, s * 22) * rot(), 1.2, nil, LM)
	for _, p in ipairs(t:GetChildren()) do
		if p.Name:find("_stone") then p.Color = TW; p.Material = SL elseif p.Name:find("_dome") then p.Color = rgb(70, 28, 34) elseif p.Name:find("_darkStone") then p.Color = rgb(30, 12, 15) end
	end
	local w = place("K_Arcade7", CFrame.new(RX + 3, 6, s * 37) * CFrame.Angles(0, math.pi, 0), 1.0, nil, LM)
	for _, p in ipairs(w:GetChildren()) do p.Color = p.Name:find("_darkStone") and rgb(30, 12, 15) or WR; p.Material = SL end
	for k = 1, 4 do -- 8 dead red trees 10-15 tall round the base
		place("K_DeadTree", CFrame.new(RX - 10 + rng:NextNumber(-4, 12), 6, s * (16 + 8 * k + rng:NextNumber(-2, 2))) * rot(), rng:NextNumber(0.75, 1.05), rgb(40, 30, 35), LM)
	end
	palm("K_Palm6B", RX - 6, s * 46, 1.0, RED, 5, s > 0 and math.pi / 2 or -math.pi / 2, LM)
end
-- W: Story (pass 7, round-4 item 7): ring 1.3x with a black void (0,9,16), an own gold crown and "Story" sign above it, a
-- tan plinth; behind it the own thick-trunked tree (trunk r 6.5, 5 twisting branches, canopy about 80 across); 4 more palms
local SX = -88
part("StoryBase", Vector3.new(7, 1.5, 18), CFrame.new(SX, 6.75, 0), rgb(120, 100, 82), SM, nil, LM)
place("K_Ring", CFrame.new(SX, 6, 0), 1.3, nil, LM)
part("StoryVoid", Vector3.new(0.4, 13.2, 13.2), CFrame.new(SX, 6 + 7.5 * 1.3, 0), rgb(0, 9, 16), SM, Enum.PartType.Cylinder, LM)
local glow = part("StoryGlow", Vector3.new(0.3, 13.8, 13.8), CFrame.new(SX + 0.12, 6 + 7.5 * 1.3, 0), rgb(70, 40, 120), NE, Enum.PartType.Cylinder, LM); glow.Transparency = 0.92
sign("StorySign", "Story", Vector3.new(0.6, 3.4, 11), CFrame.new(SX + 1.8, 28.8, 0), rgb(40, 50, 110), rgb(255, 230, 130), Enum.NormalId.Right, LM)
place("K_Crown7", CFrame.new(SX + 1.8, 30.6, 0), 1.0, nil, LM)
-- pass 8 (round-5 item 7): the own pass-8 tree: trunk r 10.5 splitting low into 7 thick branches, warm tan wood
-- (150,110,75), tan plinth (88,74,62); interior puffs in the kit replace the 2 filler crowns; 2 blue crystal pods
-- (40,110,230 Glass) beside the ring; 2 more blue palms.
local gt = place("K_BigTree8", CFrame.new(SX - 30, 6, 0) * CFrame.Angles(0, 0.4, 0), 1.0, rgb(60, 120, 240), LM, rgb(130, 185, 255))
-- pass 10 (round-7 item 5): footprint 0.72x in plan only (p8), full height kept (p4 shows a tall tree); lighter canopy
do
	local pv = gt:GetPivot().Position
	for _, p in ipairs(gt:GetChildren()) do
		local o = p.Position - pv
		p.Size = Vector3.new(p.Size.X * 0.72, p.Size.Y, p.Size.Z * 0.72) -- uniform in X/Z, so the yaw does not matter
		p.Position = pv + Vector3.new(o.X * 0.72, o.Y, o.Z * 0.72)
	end
end
for _, p in ipairs(gt:GetChildren()) do if p.Name:find("_wood") then p.Color = rgb(150, 110, 75) end end
LM:FindFirstChild("StoryBase").Color = rgb(88, 74, 62)
for s = -1, 1, 2 do
	local pod = place("K_Pod8", CFrame.new(SX + 1, 6, s * 13.5) * CFrame.Angles(0, s * 0.3, s * 0.12), 1.15, nil, LM)
	for _, p in ipairs(pod:GetChildren()) do
		if p.Name:find("_glass") then p.Color = rgb(40, 110, 230); p.Material = GL; p.Transparency = 0.1 end
		if p.Name:find("_gold") then p.Color = rgb(200, 172, 60) end
	end
	palm("K_Palm6B", SX - 18, s * 52, 1.0, FB, 6, s > 0 and math.pi / 2 or -math.pi / 2, LM)
end
for s = -1, 1, 2 do
	palm("K_Palm6A", SX + 4, s * 22, 1.05, FB, 6, s > 0 and math.pi / 2 or -math.pi / 2, LM)
	palm("K_Palm6B", SX + 2, s * 32, 1.0, FB, 7, s > 0 and math.pi / 2 or -math.pi / 2, LM)
	palm("K_Palm6A", SX - 8, s * 42, 0.95, FB, 5, s > 0 and math.pi / 2 or -math.pi / 2, LM)
end
task.wait()

-- 7. skyline (pass 7, round-4 item 1): own SLAB islands (120-150 across, ~30 thick, grey rock 137,148,145, jagged underside,
-- clustered vine curtains, ruined 8x8x40 towers with arches, 3.5-wide waterfalls) set farther and higher, long side to the
-- plaza; big cumulus cloud cards behind them.
local ISL = Instance.new("Folder"); ISL.Name = "Islands"; ISL.Parent = root
-- pass 8 (round-5 item 1): every island 1.5x farther, 30 higher and 1.15x bigger; the thin pass-7 falls are dropped and
-- each island gets 2-3 own waterfall CURTAINS (4.5-6.5 wide, foam lip, mist at the foot) on its plaza-facing rim, found
-- by a raycast onto the rock; an own 8x8x40 arched ruin tower and a domed round tower on top; 2 extra islands and 4
-- extra clouds fill the empty c3 sky (NE / E).
local isl = { { "K_Isl771", -115, 215, -400, 1.35 }, { "K_Isl772", 125, 235, -420, 1.35 }, { "K_Isl773", 5, 275, -570, 1.6 },
	{ "K_Isl771", 310, 190, -300, 1.2 }, { "K_Isl773", 430, 175, 60, 1.2 }, { "K_Isl772", -210, 170, 390, 1.2 },
	{ "K_Isl771", 200, 185, 410, 1.3 }, { "K_Isl773", -430, 180, -90, 1.2 } }
for _, s in ipairs(isl) do s[2] *= 1.5; s[4] *= 1.5; s[3] += 30; s[5] *= 1.15 end
table.insert(isl, { "K_Isl772", 660, 235, -260, 1.5 }); table.insert(isl, { "K_Isl771", 600, 300, -40, 1.4 })
local KR = { K_Isl771 = 60, K_Isl772 = 60, K_Isl773 = 48 }
local nFall = 0
for i, s in ipairs(isl) do
	local pos = Vector3.new(s[2], s[3], s[4]); local sc = s[5]
	local cf = CFrame.lookAt(pos, Vector3.new(0, s[3], 0)) * CFrame.Angles(0, rng:NextNumber(-0.3, 0.3), 0)
	local m = place(s[1], cf, sc, nil, ISL)
	local rock
	for _, p in ipairs(m:GetChildren()) do
		if p.Name:find("_fall") then p:Destroy() elseif p.Name:find("_rock") then rock = p end
	end
	local c = ({ rgb(90, 160, 60), GOLDT, rgb(90, 160, 60), PURPLE })[i % 4 + 1]
	local p1 = (cf * CFrame.new(-34 * sc, 2.6 * sc, -4 * sc)).Position
	local p2 = (cf * CFrame.new(32 * sc, 2.6 * sc, 6 * sc)).Position
	local p3 = (cf * CFrame.new(2 * sc, 2.6 * sc, 12 * sc)).Position
	fluffy("K_Fluffy", p1.X, p1.Y, p1.Z, 1.2 * sc, c, ISL)
	fluffy("K_FluffyS", p2.X, p2.Y, p2.Z, 1.5 * sc, rgb(80, 150, 55), ISL)
	if i % 2 == 0 then palm("K_Palm6A", p3.X, p3.Z, 1.1 * sc, rgb(70, 150, 60), 4, 0, ISL, p3.Y) end
	local R = KR[s[1]] * sc
	local t = place("K_Ruin8", cf * CFrame.new(-0.55 * R, 2.2 * sc, 0.1 * R) * CFrame.Angles(0, rng:NextNumber(0, 1.5), 0), sc * 1.05, nil, ISL)
	for _, p in ipairs(t:GetChildren()) do p.Color = rgb(222, 220, 210) end
	local d = place("K_Dome8", cf * CFrame.new(0.5 * R, 2.2 * sc, 0.05 * R), sc * 0.95, nil, ISL)
	for _, p in ipairs(d:GetChildren()) do p.Color = p.Name:find("_dark") and rgb(70, 76, 88) or rgb(225, 222, 212) end
	-- waterfall curtains: raycast from the plaza side onto the rock to find the rim
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Include; rp.FilterDescendantsInstances = { rock }
	local nf8 = (i % 3 == 0) and 3 or 2
	for k = 1, nf8 do
		local lx = ((k - 0.5) / nf8 - 0.5) * 1.1 * R + rng:NextNumber(-4, 4) * sc
		local o = (cf * CFrame.new(lx, -2.5 * sc, -3 * R)).Position
		local tgt = (cf * CFrame.new(lx, -2.5 * sc, 0)).Position
		local hit = rock and workspace:Raycast(o, tgt - o, rp)
		local hp = hit and hit.Position or (cf * CFrame.new(lx, -2.5 * sc, -0.45 * R)).Position
		local local_ = cf:PointToObjectSpace(hp)
		local fcf = cf * CFrame.new(local_.X, 1.5 * sc, local_.Z - 1.2 * sc) * CFrame.Angles(0, math.pi, 0)
		local f = place("K_Fall8", fcf, sc * rng:NextNumber(0.85, 1.0), nil, ISL)
		for _, p in ipairs(f:GetChildren()) do
			p.CastShadow = false; p.CanCollide = false
			if p.Name:find("_fall") then p.Color = rgb(200, 230, 245); p.Material = GL; p.Transparency = 0.3
			else p.Color = rgb(235, 245, 250); p.Material = SM; p.Transparency = 0.25 end
		end
		nFall += 1
	end
	if i % 3 == 0 then task.wait() end
end
local clouds = { { -300, 110, -640, 2.6 }, { 260, 150, -680, 2.8 }, { 560, 120, -300, 2.4 }, { 600, 140, 180, 2.5 }, { -620, 120, -160, 2.4 },
	{ -420, 150, 520, 2.6 }, { 280, 105, 620, 2.3 }, { 0, 190, -820, 3.2 }, { 470, 200, -520, 2.2 },
	{ 760, 190, -420, 2.6 }, { 820, 250, -120, 2.4 }, { 450, 320, -720, 2.5 }, { 700, 150, 60, 2.3 } }
for i, c in ipairs(clouds) do
	local pos = Vector3.new(c[1], c[2], c[3])
	place(i % 2 == 0 and "K_Cloud7" or "K_Cloud7B", CFrame.lookAt(pos, Vector3.new(0, c[2], 0)) * CFrame.Angles(0, rng:NextNumber(-0.4, 0.4), 0), c[4], nil, ISL)
end

local nS = 0
do
-- ================================================================ pass 9 (verify6_plaza.md, round 6 against the live reference)
local P9 = Instance.new("Folder"); P9.Name = "Pass9"; P9.Parent = root
local function face(pos, dir) -- kit pieces authored facing -Z arrive yawed 180: turn them to face `dir`
	return CFrame.lookAt(pos, pos + Vector3.new(dir.X, 0, dir.Z)) * CFrame.Angles(0, math.pi, 0)
end
local function paint(m, map) -- recolour a placed model by name token: map[token] = { colour, material?, transparency? }
	for _, p in ipairs(m:GetChildren()) do
		local tok = p.Name:match("_(%a+)$")
		local v = map[tok]
		if v then p.Color = v[1]; if v[2] then p.Material = v[2] end; if v[3] then p.Transparency = v[3] end end
	end
	return m
end
local function kill(parent, name) for _, c in ipairs(parent:GetChildren()) do if c.Name == name then c:Destroy() end end end

-- item 5: fountain core. Dark slatted drum (50,60,70) with a gold band over the old pale drum and rods, a water disc, a
-- ledge from the back of the vault and a 4-wide water sheet (120,210,235) T 0.3 falling into the drum, spray.
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	local c = Vector3.new(qx, 0, qz) * (BASIN_R / R2); local d = Vector3.new(qx, 0, qz).Unit; local lat = Vector3.new(-qz, 0, qx).Unit
	local up = CFrame.Angles(0, 0, math.pi / 2)
	-- pass 10 (round-7 item 4): drum 6.6 x 2.7 -> 4 across x 1.8 tall on a dark stem, 12 slats, a gold lip on top (the small
	-- upper bowl), water disc inside the lip; sheet 4 -> 3 wide
	part("DrumStem", Vector3.new(1.4, 2.2, 2.2), CFrame.new(c + Vector3.new(0, 1.6, 0)) * up, rgb(50, 60, 70), SM, Enum.PartType.Cylinder, P9)
	part("Drum", Vector3.new(1.8, 4.0, 4.0), CFrame.new(c + Vector3.new(0, 3.0, 0)) * up, rgb(50, 60, 70), SM, Enum.PartType.Cylinder, P9)
	for k = 0, 11 do
		local a = 2 * math.pi * k / 12; local o = Vector3.new(math.cos(a), 0, math.sin(a))
		local q = c + o * 2.02 + Vector3.new(0, 2.95, 0)
		part("DrumSlat", Vector3.new(0.35, 1.5, 0.2), CFrame.lookAt(q, q + o), rgb(78, 88, 100), SM, nil, P9)
	end
	part("DrumBand", Vector3.new(0.35, 4.6, 4.6), CFrame.new(c + Vector3.new(0, 3.95, 0)) * up, GOLD, SM, Enum.PartType.Cylinder, P9)
	part("DrumBand2", Vector3.new(0.2, 4.2, 4.2), CFrame.new(c + Vector3.new(0, 2.15, 0)) * up, GOLD, SM, Enum.PartType.Cylinder, P9)
	local w = part("DrumWater", Vector3.new(0.12, 4.0, 4.0), CFrame.new(c + Vector3.new(0, 4.1, 0)) * up, rgb(120, 210, 235), SM, Enum.PartType.Cylinder, P9); w.Transparency = 0.15
	local lc = c + d * (HAS10 and 2.1 or 5.6) + Vector3.new(0, 8.7, 0) -- ledge stays at w 35.2 in the arch mouth
	part("Ledge", Vector3.new(5.4, 0.7, 7), CFrame.lookAt(lc, lc + d), rgb(60, 66, 76), SM, nil, P9)
	part("LedgeLip", Vector3.new(5.6, 0.25, 0.4), CFrame.lookAt(lc - d * 3.5 + Vector3.new(0, 0.3, 0), lc + d), GOLD, SM, nil, P9)
	local sc = c + d * 1.2 + Vector3.new(0, 6.4, 0)
	local sh = part("WaterSheet", Vector3.new(3, 4.6, 0.15), CFrame.lookAt(sc, sc + d), rgb(120, 210, 235), SM, nil, P9)
	sh.Transparency = 0.3; sh.CanCollide = false; sh.CastShadow = false -- SmoothPlastic: Glass at 0.3 vanished against the dark vault
	local sp = part("Spray", Vector3.new(3, 0.2, 1), CFrame.lookAt(c + d * 1.2 + Vector3.new(0, 4.2, 0), c + d * 2), rgb(0, 0, 0), SM, nil, P9)
	sp.Transparency = 1; sp.CanCollide = false
	local e = Instance.new("ParticleEmitter"); e.Color = ColorSequence.new(rgb(225, 245, 255)); e.LightEmission = 0.5
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1.4) })
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) })
	e.Lifetime = NumberRange.new(0.5, 1.0); e.Rate = 30; e.Speed = NumberRange.new(2, 4); e.SpreadAngle = Vector2.new(50, 50)
	e.Acceleration = Vector3.new(0, -6, 0); e.Parent = sp
end end

-- item 10 (cheap parts): 8 gold studs round the medallion, short white bollards, blue crystal pods beside each kiosk
for k = 0, 7 do
	local a = 2 * math.pi * k / 8 + math.pi / 8
	blob("MedalStud", Vector3.new(1.3, 0.6, 1.3), Vector3.new(11 * math.cos(a), 0.45, 11 * math.sin(a)), rgb(180, 160, 60), Enum.Material.Metal, P9)
end
for _, b in ipairs(root:GetChildren()) do
	if b.Name == "K_Bollard" then
		for _, p in ipairs(b:GetChildren()) do if not p.Name:find("gold") then p.Color = rgb(235, 237, 230) end end
	end
end
if kit:FindFirstChild("K_Pod8_glass") then
	for qx = -1, 1, 2 do for qz = -1, 1, 2 do
		for _, xz in ipairs({ { 22, 51 }, { 51, 22 } }) do
			local pod = place("K_Pod8", CFrame.new(qx * xz[1], 6, qz * xz[2]) * CFrame.Angles(0, rng:NextNumber(0, 6), 0.12), 0.95, nil, P9)
			paint(pod, { glass = { rgb(40, 110, 230), GL, 0.1 }, gold = { rgb(200, 172, 60) } })
		end
	end end
end

-- item 3: Raid as a glowing red set piece. The brick tower block becomes a gothic facade 44 wide x 30 tall carrying the
-- skull 2.3x (about 25 wide) in (200,85,88) with neon eyes; the beam runs from the mouth down to own 3D "Raid" letters;
-- a small skull keystone over the gate; three red PointLights (range 50, brightness 3) and a low red fog; a Boss Rush tower
-- with a purple neon portal on the left.
kill(LM, "RaidTower"); kill(LM, "RaidTowerCap"); kill(LM, "RaidBeam"); kill(LM, "RaidLight"); kill(LM, "SkullLight")
for _, m in ipairs(LM:GetChildren()) do if m.Name == "K_Skull8" then m:Destroy() end end
part("RaidFacade", Vector3.new(10, 30, 44), CFrame.new(RX + 10, 21, 0), WR, SL, nil, P9)
part("RaidFacadeCap", Vector3.new(11, 1.4, 45), CFrame.new(RX + 10, 36.6, 0), DK, SL, nil, P9)
for s = -1, 1, 2 do
	for k = 1, 2 do part("RaidButtress", Vector3.new(2.4, 30, 2.4), CFrame.new(RX + 4.8, 21, s * (8 + 7 * k)), DK, SL, nil, P9) end
	part("RaidWin", Vector3.new(0.4, 9, 3.2), CFrame.new(RX + 4.8, 26, s * 11.5), rgb(255, 70, 60), NE, nil, P9).Transparency = 0.2
end
-- pass 10 (round-7 item 3): no plinth. The skull is lowered 10 so its pedestal is buried and it becomes the head of a
-- central gothic gable 22 wide rising from the facade top (36) to the jaw; chin about 42-43, 15 above the doorway (27).
local SKC = Vector3.new(RX + 10, 50, 0)
local sk9 = place("K_Skull8", CFrame.new(SKC) * CFrame.Angles(0, math.pi, 0), 2.0, nil, P9)
paint(sk9, { bone = { rgb(165, 70, 75), SL }, dark = { rgb(40, 8, 12) }, eye = { rgb(255, 40, 40), NE } })
part("RaidGable", Vector3.new(9, 9, 16), CFrame.new(RX + 10, 40.5, 0), WR, SL, nil, P9)
for s = -1, 1, 2 do -- sloped shoulders from the 22-wide gable foot up to the jaw
	local wp = Instance.new("WedgePart"); wp.Name = "RaidGableShoulder"; wp.Anchored = true; wp.Material = SL; wp.Color = WR
	wp.Size = Vector3.new(9, 8, 5); wp.CFrame = CFrame.new(RX + 10, 41, s * 10.5) * CFrame.Angles(0, s > 0 and math.pi or 0, 0); wp.Parent = P9 -- a wedge is tall at +Z: turn it so the tall side meets the gable
	part("RaidPinnacle", Vector3.new(1.6, 9, 1.6), CFrame.new(RX + 5.4, 41, s * 13.5), TW, SL, nil, P9)
end
local beam = part("RaidBeam9", Vector3.new(1.0, 10, 1.6), CFrame.new(RX + 4.6, 39.4, 0), rgb(255, 45, 45), NE, nil, P9); beam.CastShadow = false
local ks = place("K_Skull8", CFrame.new(RX - 1.6, 6 + 21.5, 0) * CFrame.Angles(0, math.pi, 0), 0.28, nil, P9)
paint(ks, { bone = { rgb(225, 200, 195), SM }, dark = { rgb(30, 10, 12) }, eye = { rgb(255, 40, 40), NE } })
if kit:FindFirstChild("K_TxtRaid9_letters") then
	kill(LM, "RaidSign")
	local t = place("K_TxtRaid9", face(Vector3.new(RX - 4.6, 32, 0), Vector3.new(-1, 0, 0)), 1.0, nil, P9) -- pass 10: on the gate gable, just above the keystone skull
	paint(t, { letters = { rgb(255, 215, 205), NE } }) -- pass 10: pale glowing letters (red on the red facade was lost)
end
for k = -1, 1 do
	local a = part("RaidLight9", Vector3.new(0.2, 0.2, 0.2), CFrame.new(RX - 8, 16, k * 16), rgb(0, 0, 0), SM, nil, P9); a.Transparency = 1; a.CanCollide = false
	local L = Instance.new("PointLight"); L.Color = rgb(255, 60, 60); L.Range = 32; L.Brightness = 0.45; L.Shadows = false; L.Parent = a -- brief: 50/3; 3 burnt every face to pure (255,0,0) (pass 10: L.Parent had been commented out)
end
do
	local hz9 = LM:FindFirstChild("RaidHaze")
	if hz9 then
		hz9.CFrame = CFrame.new(RX - 4, 7, 0); hz9.Size = Vector3.new(40, 1, 90)
		local e = hz9:FindFirstChildOfClass("ParticleEmitter"); e.Color = ColorSequence.new(rgb(235, 60, 55)); e.LightEmission = 0.2 -- pass 10: Rate 14 -> 6, emission 0.35 -> 0.2 (the fog had pushed the facade to (196,30,49))
		e.Rate = 6; e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 8), NumberSequenceKeypoint.new(1, 16) })
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.65), NumberSequenceKeypoint.new(1, 1) })
		e.Acceleration = Vector3.new(0, 0.2, 0)
	end
end
-- Boss Rush tower (left of Raid from the spawn): dark gothic block 15x15x40, a spire, a purple neon portal and own letters
do
	local BX, BZ = RX - 4, -30 -- pass 10: 15 north of Raid and in front of its line, so the portal shows left of Raid from p3
	part("BossTower", Vector3.new(12, 24, 12), CFrame.new(BX, 6 + 12, BZ), rgb(55, 42, 55), SL, nil, P9)
	part("BossCap", Vector3.new(13.5, 1.4, 13.5), CFrame.new(BX, 6 + 24.6, BZ), rgb(90, 35, 45), SL, nil, P9)
	local sp = place("K_Spire", CFrame.new(BX, 6 + 25, BZ), 1.1, nil, P9)
	for _, p in ipairs(sp:GetChildren()) do p.Color = rgb(60, 30, 45); p.Material = SL end
	local po = part("BossPortal", Vector3.new(0.4, 11, 11), CFrame.new(BX - 6.1, 6 + 8, BZ), rgb(200, 80, 255), NE, Enum.PartType.Cylinder, P9); po.Transparency = 0.1
	part("BossPortalRim", Vector3.new(0.6, 13, 13), CFrame.new(BX - 5.95, 6 + 8, BZ), rgb(45, 30, 50), SL, Enum.PartType.Cylinder, P9)
	local pl9 = Instance.new("PointLight"); pl9.Color = rgb(200, 80, 255); pl9.Range = 24; pl9.Brightness = 2; pl9.Parent = po
	if kit:FindFirstChild("K_TxtBoss9_letters") then
		paint(place("K_TxtBoss9", face(Vector3.new(BX - 6.7, 6 + 17, BZ), Vector3.new(-1, 0, 0)), 1.0, nil, P9), { letters = { rgb(205, 110, 255), NE } })
	end
end

-- item 6: Summon two-storey facade (own K_Summon9, 50 x 35) with own gold 3D "Summon" letters; corner towers moved out
if kit:FindFirstChild("K_Summon9_cream") then
	for _, n in ipairs({ "SummonBody", "SummonBand", "SummonBand2", "SummonSign", "K_Arcade7" }) do
		for _, c in ipairs(LM:GetChildren()) do if c.Name == n and (n ~= "K_Arcade7" or math.abs(c:GetPivot().Position.Z - HZ) < 10 and math.abs(c:GetPivot().Position.X) < 10) then c:Destroy() end end
	end
	for _, c in ipairs(LM:GetChildren()) do
		if c.Name == "SummonDome" then c.Position = Vector3.new(0, 44, HZ - 12) elseif c.Name == "SummonFinial" then c.Position = Vector3.new(0, 55, HZ - 12) end
		if c.Name == "K_RTower7" and math.abs(c:GetPivot().Position.Z - HZ) < 3 then c:PivotTo(c:GetPivot() + Vector3.new(c:GetPivot().Position.X > 0 and 6 or -6, 0, 0)) end
	end
	paint(place("K_Summon9", face(Vector3.new(0, 6, HZ), Vector3.new(0, 0, 1)), 1.0, nil, P9),
		{ cream = { rgb(225, 210, 170) }, gold = { rgb(200, 170, 60) }, dark = { rgb(70, 60, 55) }, blue = { rgb(50, 90, 180) } })
	paint(place("K_TxtSummon9", face(Vector3.new(0, 6 + 20.5, HZ + 2.4), Vector3.new(0, 0, 1)), 1.0, nil, P9), { letters = { rgb(235, 195, 70), SM } })
end

-- item 8: thin Story ring (own K_Ring9, 2.4 deep) in silver-blue with gems and a crest, black void, own blue letters
if kit:FindFirstChild("K_Ring9_silver") then
	for _, n in ipairs({ "K_Ring", "StoryVoid", "StorySign", "K_Crown7" }) do kill(LM, n) end
	paint(place("K_Ring9", face(Vector3.new(SX, 6, 0), Vector3.new(1, 0, 0)), 1.0, nil, P9),
		{ silver = { rgb(150, 170, 205) }, gold = { rgb(200, 172, 60) }, gem = { rgb(40, 110, 230), GL, 0.05 }, void = { rgb(2, 4, 10) } })
	local g = LM:FindFirstChild("StoryGlow"); if g then g.Size = Vector3.new(0.3, 14.6, 14.6); g.Position = Vector3.new(SX + 0.4, 16, 0); g.Color = rgb(40, 90, 200); g.Transparency = 0.96 end
	-- pass 10 (round-7 item 5): pale blue letters 2 above the ring crest (top about 30.4), with a navy outline: a 1.08x
	-- copy 0.5 behind
	paint(place("K_TxtStory9", face(Vector3.new(SX + 0.8, 35.2, 0), Vector3.new(1, 0, 0)), 1.0, nil, P9), { letters = { rgb(170, 210, 255), SM } })
	paint(place("K_TxtStory9", face(Vector3.new(SX + 0.2, 35.0, 0), Vector3.new(1, 0, 0)), 1.08, nil, P9), { letters = { rgb(20, 30, 70), SM } })
	for _, m in ipairs(LM:GetChildren()) do if m.Name == "K_BigTree8" then for _, p in ipairs(m:GetChildren()) do if p.Name:find("_wood") then p.Color = rgb(150, 115, 80) end end end end
end

-- item 9 (partial): own teal 3D "Expeditions" letters, grey-stone shards, ring lowered 5 toward the sign
if kit:FindFirstChild("K_TxtExp9_letters") then
	kill(LM, "ExpSign")
	paint(place("K_TxtExp9", face(Vector3.new(0, 6 + (HAS10 and 26.6 or 27.8), EZ - 2.6), Vector3.new(0, 0, -1)), 1.0, nil, P9), { letters = { rgb(100, 230, 200), SM } })
end
-- pass 10 (round-7 item 7): own triptych gate (K_Trip10: centre arch 12 x 20 with a dark-teal swirl portal and a pale
-- statue, two 8 x 14 side arches, gold trims and crest, pale columns with urns) replaces the greenhouse window
if HAS10 then
	kill(LM, "K_ExpGate8")
	paint(place("K_Trip10", face(Vector3.new(0, 6.5, EZ), Vector3.new(0, 0, -1)), 1.0, nil, P9),
		{ teal = { rgb(40, 140, 140), SM }, gold = { GOLD, SM }, pale = { rgb(205, 228, 222), SM }, portal = { rgb(20, 110, 110), SM },
			swirl = { rgb(90, 220, 205), NE, 0.15 }, glass = { rgb(60, 170, 170), GL, 0.35 } })
end
for _, m in ipairs(LM:GetChildren()) do
	if m.Name == "K_ExpRing8" then
		m:PivotTo(m:GetPivot() - Vector3.new(0, 5, 0))
		for _, p in ipairs(m:GetChildren()) do if p.Name:find("_stone") then p.Color = rgb(110, 125, 145) end end
	end
end
task.wait()

-- item 2: mid-distance architecture 90-130 out in the gaps between the landmarks
if HAS9 then
	local toC = function(x, z) return Vector3.new(-x, 0, -z) end
	local gp = Vector3.new(-104, 6, -104)
	paint(place("K_Guild9", face(gp, Vector3.new(0, 6, -20) - gp), 1.0, nil, P9),
		{ cream = { rgb(225, 215, 185) }, gold = { rgb(200, 170, 60) }, dark = { rgb(60, 62, 75) }, blue = { rgb(40, 80, 170) } })
	local tp = gp + ((Vector3.new(0, 6, -20) - gp) * Vector3.new(1, 0, 1)).Unit * 1.5 + Vector3.new(0, 37, 0)
	paint(place("K_TxtGuild9", face(tp, Vector3.new(0, 6, -20) - gp), 1.0, nil, P9), { letters = { rgb(70, 200, 90), SM } })
	for _, xz in ipairs({ { 112, 112 }, { -112, 112 } }) do
		paint(place("K_Palace9", face(Vector3.new(xz[1], 6, xz[2]), toC(xz[1], xz[2])), 1.0, nil, P9),
			{ cream = { rgb(225, 215, 190) }, gold = { rgb(200, 170, 60) }, dark = { rgb(60, 62, 75) }, blue = { rgb(40, 80, 170) } })
	end
	for _, xz in ipairs({ { -62, -140 }, { 88, -128 }, { -140, 62 } }) do
		paint(place("K_Tower9", face(Vector3.new(xz[1], 6, xz[2]), toC(xz[1], xz[2])), 1.0, nil, P9),
			{ stone = { rgb(150, 155, 160) }, dark = { rgb(55, 60, 70) }, roof = { rgb(80, 95, 125) } })
	end
end
task.wait()

-- item 1: big, close, lush islands (own K_Isl91/92: 110-140 long slabs, thick drooping grass cap, dense vines) 110-170 out,
-- undersides 55-80 up; per island a 10x10x50 ruin tower, a rotunda or a domed tower, an aqueduct on every other one, 4-6
-- green trees and 2 wide falls (own K_Fall9) found by a raycast onto the rock from the plaza side; 3 cumulus banks behind.
if HAS9 then
	for _, m in ipairs(ISL:GetChildren()) do if not m.Name:find("Cloud") then m:Destroy() end end
	-- pass 11: the E island moved out to 255 and up to 150, clear of the moved Raid skull
		-- pass 10 (round-7 item 1): the four islands nearest the spawn axes (N pair, E, S, W) lifted 22, the N pair pushed
	-- apart and the far N one lifted 30 to open sky gaps; rock squashed to 0.6 height (spikes halved, top kept); grey-green
	-- rock lit from below by soft fill lights (the undersides otherwise see only the purple Ambient); round puff trees;
	-- grey ruin towers; falls are stacked part segments fading out over the lower third, with mist, no cloud discs.
	-- Placed by elevation angle (fix9 lesson 2): undersides at about 25 degrees above the spawn eye (6 + 0.47 x distance,
	-- 0.55 for the NE one that must fill the top of c3), so they read as floating bodies in p1 yet still crown c3/c4; the
	-- N pair 74 apart with the far N island higher in the gap. A first try 1.3x farther opened p1 nicely but emptied c3.
	local I9 = { { 91, -85, -165, 114, 1.0 }, { 92, 95, -185, 125, 1.0 }, { 92, 0, -280, 142, 1.15 }, { 91, 110, -110, 112, 1.1 },
		{ 92, 255, 40, 150, 1.0 }, { 91, 125, 140, 115, 0.95 }, { 92, -85, 185, 113, 1.0 }, { 91, -145, 118, 115, 0.95 },
		{ 92, -180, -38, 114, 1.0 }, { 91, -135, -130, 115, 0.95 } }
	local KR9 = { [91] = 50, [92] = 56 }
	local nF9 = 0
	local ROCK10, FILL10 = rgb(210, 216, 195), rgb(210, 225, 200)
	local function puff(pos, d, col) -- round tree: trunk + 4 overlapping balls
		part("IslTrunk", Vector3.new(1.4, d * 0.45, 1.4), CFrame.new(pos + Vector3.new(0, d * 0.2, 0)), rgb(120, 92, 62), SM, nil, ISL)
		for k = 0, 3 do
			local a = k * 2.1 + rng:NextNumber(0, 0.6)
			local o = k == 0 and Vector3.new(0, d * 0.6, 0) or Vector3.new(math.cos(a) * d * 0.25, d * 0.45, math.sin(a) * d * 0.25)
			local sz = d * (k == 0 and 0.75 or 0.55)
			blob("IslPuff", Vector3.new(sz, sz * 0.85, sz), pos + o, col:Lerp(rgb(255, 255, 255), k == 0 and 0.08 or 0), SM, ISL).CastShadow = false
		end
	end
	for i, s in ipairs(I9) do
		local pos = Vector3.new(s[2], s[4], s[3]); local sc = s[5]
		local cf = CFrame.lookAt(pos, Vector3.new(0, s[4], 0)) * CFrame.Angles(0, rng:NextNumber(-0.25, 0.25), 0)
		local m = place("K_Isl" .. s[1], cf, sc, nil, ISL)
		local rock
		for _, p in ipairs(m:GetChildren()) do
			if p.Name:find("_rock") then
				rock = p; p.Color = ROCK10; p.Material = Enum.Material.Slate
				local top = p.Position.Y + p.Size.Y / 2
				p.Size = Vector3.new(p.Size.X, p.Size.Y * 0.6, p.Size.Z); p.Position = Vector3.new(p.Position.X, top - p.Size.Y / 2, p.Position.Z)
			elseif p.Name:find("_grass") then p.Color = rgb(110, 170, 70); p.Material = GR
			elseif p.Name:find("_vine") then p.Color = rgb(70, 140, 60); p.Material = SM; p.CastShadow = false end
		end
		local R = KR9[s[1]] * sc; local top = 3.0 * sc
		local function on(lx, lz) return cf * CFrame.new(lx * R, top - 0.6, lz * R * 0.5) end
		for k = -1, 1 do -- soft fills under the rock
			local lp = (cf * CFrame.new(k * 0.55 * R, -24 * sc, 0)).Position
			local a = part("IslFill", Vector3.new(0.2, 0.2, 0.2), CFrame.new(lp), rgb(0, 0, 0), SM, nil, ISL); a.Transparency = 1; a.CanCollide = false; a.CanQuery = false
			local L = Instance.new("PointLight"); L.Color = FILL10; L.Range = 50; L.Brightness = 1.0; L.Shadows = false; L.Parent = a
		end
		local t = place("K_Ruin8", on(-0.55, 0.1) * CFrame.Angles(0, rng:NextNumber(0, 1.5), 0), 1.25, nil, ISL)
		for _, p in ipairs(t:GetChildren()) do p.Color = rgb(150, 156, 150); p.Material = Enum.Material.Slate end
		if i % 2 == 0 then
			local r = place("K_Rot9", on(0.45, 0.15), 1.0, nil, ISL); for _, p in ipairs(r:GetChildren()) do p.Color = rgb(165, 170, 165) end
		else
			local d = place("K_Dome8", on(0.5, 0.1), 1.05, nil, ISL)
			for _, p in ipairs(d:GetChildren()) do p.Color = p.Name:find("_dark") and rgb(70, 76, 88) or rgb(165, 170, 165) end
		end
		if i % 2 == 1 then
			local a = place("K_Aque9", on(0.05, 0.35) * CFrame.Angles(0, rng:NextNumber(-0.3, 0.3), 0), 1.0, nil, ISL)
			for _, p in ipairs(a:GetChildren()) do p.Color = rgb(160, 166, 160) end
		end
		for k = 1, 5 do
			local q = on(rng:NextNumber(-0.75, 0.75), rng:NextNumber(-0.6, 0.7)).Position
			puff(q, rng:NextNumber(15, 20), ({ rgb(90, 160, 60), rgb(100, 170, 65), rgb(80, 150, 55) })[k % 3 + 1])
		end
		local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Include; rp.FilterDescendantsInstances = { rock }
		for k = 1, 2 do
			local lx = (k == 1 and -0.3 or 0.3) * R + rng:NextNumber(-5, 5)
			local o = (cf * CFrame.new(lx, -3 * sc, -3 * R)).Position
			local tgt = (cf * CFrame.new(lx, -3 * sc, 0)).Position
			local hit = rock and workspace:Raycast(o, tgt - o, rp)
			local hp = hit and hit.Position or (cf * CFrame.new(lx, -3 * sc, -0.5 * R)).Position
			local l = cf:PointToObjectSpace(hp)
			local fcf = cf * CFrame.new(l.X, 1.0 * sc, l.Z - 1.5) -- top centre of the fall, facing out of the island (-Z of cf is toward the plaza)
			local len, wid = 50 * sc * rng:NextNumber(0.9, 1.1), 8 * sc
			for _, seg in ipairs({ { 0, 0.62, 0.3 }, { 0.62, 0.8, 0.55 }, { 0.8, 0.92, 0.75 }, { 0.92, 1.0, 0.9 } }) do
				local h = (seg[2] - seg[1]) * len
				local sp = part("Fall10", Vector3.new(wid * (1 + 0.15 * seg[1]), h, 0.4), fcf * CFrame.new(0, -(seg[1] * len + h / 2), 0), rgb(195, 228, 245), SM, nil, ISL)
				sp.Transparency = seg[3]; sp.CastShadow = false; sp.CanCollide = false
			end
			part("FallLip10", Vector3.new(wid * 0.9, 1.0, 1.2), fcf * CFrame.new(0, 0, -0.3), rgb(235, 245, 252), SM, nil, ISL).CastShadow = false
			local mp = part("FallMist10", Vector3.new(wid, 0.2, 2), fcf * CFrame.new(0, -0.7 * len, -1), rgb(0, 0, 0), SM, nil, ISL)
			mp.Transparency = 1; mp.CanCollide = false
			local e = Instance.new("ParticleEmitter"); e.Color = ColorSequence.new(rgb(235, 245, 255)); e.LightEmission = 0.3
			e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 3), NumberSequenceKeypoint.new(1, 9) })
			e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1) })
			e.Lifetime = NumberRange.new(2, 3.5); e.Rate = 6; e.Speed = NumberRange.new(1, 3); e.SpreadAngle = Vector2.new(40, 40)
			e.Acceleration = Vector3.new(0, -1, 0); e.Parent = mp
			nF9 += 1
		end
		task.wait()
	end
	for _, c in ipairs({ { -170, 55, -330, 4.2 }, { 240, 65, -260, 4.5 }, { -280, 75, 230, 4.2 } }) do
		local pos = Vector3.new(c[1], c[2], c[3])
		local m = place("K_Cloud7", CFrame.lookAt(pos, Vector3.new(0, c[2], 0)), c[4], nil, ISL)
		for _, p in ipairs(m:GetChildren()) do p.Color = rgb(245, 245, 240) end
	end
end
task.wait()

-- item 7: far field. W blue lagoon with a sand beach, S white courtyard with arcades. (E gravel is recoloured above.)
part("LagoonBeach", Vector3.new(0.3, 150, 150), CFrame.new(-230, 6.02, 0) * CFrame.Angles(0, 0, math.pi / 2), rgb(225, 205, 150), Enum.Material.Sand, Enum.PartType.Cylinder, P9)
part("Lagoon", Vector3.new(0.3, 126, 126), CFrame.new(-236, 6.1, 0) * CFrame.Angles(0, 0, math.pi / 2), rgb(60, 170, 220), SM, Enum.PartType.Cylinder, P9)
part("Courtyard", Vector3.new(90, 0.3, 64), CFrame.new(0, 6.03, 142), rgb(230, 232, 236), SM, nil, P9)
for _, w in ipairs({ { 0, 176, 0 }, { -47, 142, math.pi / 2 }, { 47, 142, -math.pi / 2 } }) do
	for k = -1, 1 do
		local off = (w[3] == 0) and Vector3.new(k * 28, 0, 0) or Vector3.new(0, 0, k * 22)
		local a = place("K_Arcade7", CFrame.new(Vector3.new(w[1], 6, w[2]) + off) * CFrame.Angles(0, w[3] + math.pi / 2, 0), 1.3, nil, P9)
		for _, p in ipairs(a:GetChildren()) do p.Color = p.Name:find("_darkStone") and rgb(150, 155, 165) or rgb(235, 236, 238) end
	end
end
task.wait()

-- item 7 + lead's correction: lawns and coloured beds are TERRAIN (Grass with Decoration blades), not mesh clumps. The
-- mesh clumps on the stairs and floor become own flat leaf spills (K_Spill9, 0.3 high); the far-field red bush mounds go.
local T = workspace.Terrain
T:Clear()
local decoOK = pcall(function() T.Decoration = true end)
pcall(function() T.GrassLength = 0.55 end) -- pass 10: lower blades; GrassLength is NOT scriptable from the MCP context (like Decoration): set Terrain > GrassLength 0.55 by hand -- not scriptable from the MCP context: tick Terrain > Decoration by hand if false
T:SetMaterialColor(Enum.Material.Grass, rgb(110, 170, 70))
local MS = game:GetService("MaterialService")
local function variant(name, base, col)
	local v = MS:FindFirstChild(name) or Instance.new("MaterialVariant"); v.Name = name; v.BaseMaterial = base; v.Parent = MS
	pcall(function() MS:SetBaseMaterialOverride(base, name) end)
	T:SetMaterialColor(base, col)
	return v
end
variant("AE_RedBed", Enum.Material.Glacier, rgb(125, 60, 42)) -- pass 11: was (200,60,55), read flat pink from above
local function lawn(cf, size, mat) T:FillBlock(cf, size, mat or Enum.Material.Grass) end
-- terrain top must sit just above the terrace parts (y 6): fill a 4-stud slab centred at 4.6 (top about 6.6 after smoothing)
for _, i in ipairs({ 2, 3 }) do
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a)); local side = Vector3.new(math.cos(a), 0, math.sin(a))
	for s = -1, 1, 2 do
		local c = dir * 56 + side * (s * 13)
		-- pass 11: white paving replaces this lawn (see the pass-11 block)
	end
end
-- pass 11: S flight-top lawn strip removed (white paving)
for k = 2, 5 do for s = -1, 1, 2 do lawn(CFrame.new(s * 21.5, 4.6, -60 - 20 * k), Vector3.new(6, 4, 16)) end end -- N avenue verges (pass 10: the first two, the tall-grass wall at the top of the N flight in c4, removed)
for ci, q in ipairs(corner) do if not (q[1] < 0 and q[2] < 0) then lawn(CFrame.new(q[1] * 80, 4.6, q[2] * 70), Vector3.new(36, 4, 30), (q[1] > 0 and q[2] < 0) and Enum.Material.Glacier or nil) end end -- pass 11: E beds red -- pass 11: NW bed is the lagoon now -- planting beds behind the pools
lawn(CFrame.new(-120, 4.6, 0), Vector3.new(44, 4, 70)) -- Story lawn round the tree
for s = -1, 1, 2 do lawn(CFrame.new(185, 4.6, s * 70), Vector3.new(30, 4, 22), Enum.Material.Glacier) end -- pass 11: moved out with Raid -- red beds (own variant) flanking the Raid forecourt
for _, c in ipairs(P:GetChildren()) do if c.Name == "Lawn" or c.Name == "LawnTop" then c:Destroy() end end
if kit:FindFirstChild("K_Spill9_leaf") then
	local SPC = { [rgb(40, 90, 230):ToHex()] = rgb(60, 130, 230), [rgb(190, 45, 40):ToHex()] = rgb(220, 70, 70), [rgb(150, 178, 75):ToHex()] = rgb(120, 190, 60) }
	local nSk = 0
	for _, m in ipairs(P:GetChildren()) do
		if m.Name == "K_ClumpB" or m.Name == "K_ClumpG" then
			local piv = m:GetPivot(); local rimc
			for _, p in ipairs(m:GetChildren()) do if p.Name:find("leafRim") then rimc = p.Color end end
			local big = m:GetExtentsSize().X > 8
			nSk += 1
			if big or nSk % 5 ~= 1 then m:Destroy() -- pass 11: a fifth; -- far-field red mounds: replaced by the terrain bed and the trees; pass 10 (round-7 item 9): spill cover cut to a third
			else
				local col = (rimc and SPC[rimc:ToHex()]) or rimc or rgb(120, 190, 60)
				local sp = place("K_Spill9", CFrame.new(piv.Position.X, piv.Position.Y + 0.02, piv.Position.Z) * rot(), rng:NextNumber(0.9, 1.4), col:Lerp(rgb(20, 25, 20), 0.2), P, lighten(col, 0.2))
				m:Destroy(); nS += 1
			end
		end
	end
end
end

do
-- ================================================================ pass 11 (verify8_plaza.md, round 8 against the live reference)
local P11 = Instance.new("Folder"); P11.Name = "Pass11"; P11.Parent = root
local P9f = root:FindFirstChild("Pass9")
local function paint11(m, map)
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") then
			local tok = p.Name:match("_(%a+)$"); local v = map[tok]
			if v then p.Color = v[1]; if v[2] then p.Material = v[2] end; if v[3] then p.Transparency = v[3] end end
		end
	end
	return m
end
local function pivotOf(c) if c:IsA("BasePart") then return c.Position elseif c:IsA("Model") then return c:GetPivot().Position end end

-- item 1a: Raid moved out and enlarged. p3 measured: the reference gate base sits at the stair-top line, its letters 140 px
-- above the base and the skull mouth another 135 px above the letters; p8: the carved Raid forecourt starts about 145 out
-- and Boss Rush glows at about (155, -58). Everything Raid (gate, facade, gable, skull, towers, wings, palms, dead trees,
-- lights, haze, Boss Rush) is scaled RS about the gate foot (RX - 10) and moved RDX east.
local RS, RDX = 1.8, 60
local PV = Vector3.new(RX - 10, 6, 0)
local raid = {}
for _, f in ipairs({ LM, P9f }) do
	for _, c in ipairs(f:GetChildren()) do
		local q = pivotOf(c)
		if q and q.X > 60 and math.abs(q.Z) < 62 then table.insert(raid, c) end
	end
end
local function xf(p)
	local r = p.CFrame - p.Position
	p.Size = p.Size * RS
	p.CFrame = CFrame.new(PV + (p.Position - PV) * RS + Vector3.new(RDX, 0, 0)) * r
	for _, l in ipairs(p:GetChildren()) do if l:IsA("Light") then l.Range = math.min(60, l.Range * RS) end end
end
local RAIDF = Instance.new("Model"); RAIDF.Name = "Raid11"; RAIDF.Parent = P11
for _, c in ipairs(raid) do
	if c:IsA("BasePart") then xf(c) else for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then xf(p) end end end
	c.Parent = RAIDF
end
local function S(v) return PV + (v - PV) * RS + Vector3.new(RDX, 0, 0) end -- old-frame point -> new
-- the skull and its gable rise LIFT more so the beam is about as long as letters-to-base (p3 proportions); skull at 0.8
local bigSkull
for _, c in ipairs(RAIDF:GetChildren()) do
	if c.Name == "K_Skull8" and c:GetPivot().Position.Y > 60 then bigSkull = c end
end
local LIFT = 26
if bigSkull then
	local pv = bigSkull:GetPivot().Position
	for _, p in ipairs(bigSkull:GetChildren()) do
		p.Size = p.Size * 0.8; p.Position = pv + (p.Position - pv) * 0.8 + Vector3.new(0, LIFT, 0)
	end
	-- round-8 item 2: shaded skull (140,60,65) with darker sockets; Slate base darker for the red light
	paint11(bigSkull, { bone = { rgb(118, 52, 56), Enum.Material.Slate }, dark = { rgb(22, 4, 6) }, eye = { rgb(255, 40, 40), NE } })
end
local gTop = S(Vector3.new(RX + 10, 45, 0)).Y
local gx = S(Vector3.new(RX + 10, 0, 0)).X
part("RaidGableTall", Vector3.new(9 * RS, LIFT + 4, 14 * RS), CFrame.new(gx, gTop + LIFT / 2 - 2, 0), rgb(160, 74, 76), Enum.Material.Slate, nil, RAIDF)
for s = -1, 1, 2 do -- stepped flanks either side of the tall gable, recessed dark panels, dark pinnacles
	part("RaidGableFlank", Vector3.new(8 * RS, LIFT * 0.6, 4), CFrame.new(gx, gTop + LIFT * 0.3 - 2, s * (7 * RS + 2)), rgb(160, 74, 76), Enum.Material.Slate, nil, RAIDF)
	part("RaidGableRecess", Vector3.new(0.6, LIFT * 0.8, 3), CFrame.new(gx - 4.5 * RS - 0.2, gTop + LIFT / 2 - 2, s * 4.2 * RS), rgb(70, 10, 14), SM, nil, RAIDF)
	part("RaidGablePin", Vector3.new(2.6, LIFT + 14, 2.6), CFrame.new(gx - 2 * RS, gTop + LIFT / 2 + 4, s * (7 * RS + 4)), rgb(48, 16, 24), Enum.Material.Slate, nil, RAIDF)
end
-- colours (round-8 item 2): facade (195,40,45) lit / recesses (100,10,15) / spires (60,20,30). Base values fitted from the
-- r8 sample (175,100,100) -> (219,64,74): R x1.25, G x0.64, B x0.74 under the red light
local HEX = { [WR:ToHex()] = rgb(160, 74, 76), [DK:ToHex()] = rgb(72, 14, 18), [TW:ToHex()] = rgb(48, 16, 24), [rgb(165, 70, 75):ToHex()] = rgb(118, 52, 56) }
for _, p in ipairs(RAIDF:GetDescendants()) do
	if p:IsA("BasePart") then local n = HEX[p.Color:ToHex()]; if n then p.Color = n end end
end
for _, c in ipairs(RAIDF:GetChildren()) do
	if c.Name:find("Palm6") then for _, p in ipairs(c:GetChildren()) do if p.Name:find("leaf") then p.Color = rgb(120, 30, 40) end end end
	if c.Name == "K_TxtRaid9" then paint11(c, { letters = { rgb(235, 70, 80), NE } }) end
	if c.Name == "RaidBeam9" then c:Destroy() end
	if c.Name == "RaidLight9" then local L = c:FindFirstChildOfClass("PointLight"); if L then L.Brightness = 0.25 end end
end
-- the beam: Neon (255,40,40), from the skull's mouth down to the letters
local mouthY = gTop + LIFT - 6 * RS * 0.8
local letY = S(Vector3.new(0, 32, 0)).Y + 3.5
local bx = S(Vector3.new(RX + 4.6, 0, 0)).X - 4.5
local bm = part("RaidBeam11", Vector3.new(1.5, math.max(4, mouthY - letY), 3.0), CFrame.new(bx, (mouthY + letY) / 2, 0), rgb(255, 40, 40), NE, nil, RAIDF)
bm.CastShadow = false; bm.CanCollide = false
local bl = Instance.new("PointLight"); bl.Color = rgb(255, 50, 50); bl.Range = 26; bl.Brightness = 1.2; bl.Shadows = false; bl.Parent = bm
-- doorway: three red lights (range 45; brightness backed off until the facade shading survives)
for k = -1, 1 do
	local a = part("RaidLight11", Vector3.new(0.2, 0.2, 0.2), CFrame.new(PV.X + RDX - 10, 14, k * 22), rgb(0, 0, 0), SM, nil, RAIDF); a.Transparency = 1; a.CanCollide = false
	local L = Instance.new("PointLight"); L.Color = rgb(255, 50, 50); L.Range = 45; L.Brightness = 0.3; L.Shadows = false; L.Parent = a -- 0.8 burnt the facade to (189,34,51) vs (182,62,67)
end
-- Boss Rush: purple swirl portal in a dark carved frame (own spiral from the triptych kit piece, Neon)
for _, c in ipairs(RAIDF:GetChildren()) do
	if c.Name == "BossPortal" then
		c.Color = rgb(95, 35, 160); c.Material = NE; c.Transparency = 0
		local sw = kit:FindFirstChild("K_Trip10_swirl")
		if sw then
			local w = sw:Clone(); w.Name = "BossSwirl"; local k = (c.Size.Y * 0.85) / sw.Size.X
			w.Size = sw.Size * k; w.CFrame = CFrame.new(c.Position - Vector3.new(0.5, 0, 0)) * CFrame.Angles(0, math.pi / 2, 0)
			w.Color = rgb(200, 120, 255); w.Material = NE; w.CastShadow = false; w.Parent = RAIDF
		end
		for k = 0, 7 do -- carved frame: 8 dark blocks round the rim
			local a = 2 * math.pi * k / 8; local r = c.Size.Y * 0.56
			part("BossFrameBlock", Vector3.new(1.6, 3.2, 3.2), CFrame.new(c.Position + Vector3.new(0.3, r * math.sin(a), r * math.cos(a))) * CFrame.Angles(a, 0, 0), rgb(40, 26, 46), Enum.Material.Slate, nil, RAIDF)
		end
	end
end
task.wait()

-- item 1b: the gap between the E arm and Raid: a grey gravel road with red litter and black dead trees (each about 20 tall)
for _, c in ipairs(P:GetChildren()) do
	local q = pivotOf(c)
	if q and q.X > 58 and math.abs(q.Z) < 80 and q.Y > 5 then c:Destroy() end
end
part("GravelRoad", Vector3.new(84, 0.2, 64), CFrame.new(66 + 42, 6.0, 0), rgb(62, 66, 64), Enum.Material.Slate, nil, P11)
for k = 1, 14 do
	local x, z = rng:NextNumber(72, 150), rng:NextNumber(-30, 30)
	local m = place("K_Patch" .. ({ "A", "B", "C" })[k % 3 + 1], CFrame.new(x, 6.12, z) * rot(), rng:NextNumber(0.35, 0.7), rgb(175, 40, 38), P11)
	for _, p in ipairs(m:GetChildren()) do p.Material = SM end
end
for k = 1, 40 do -- red foliage carpets flanking the road (p8: red on both sides of the gravel)
	local s = (k % 2 == 0) and 1 or -1
	local m = place("K_Patch" .. ({ "A", "B", "C" })[k % 3 + 1], CFrame.new(rng:NextNumber(66, 160), 6.14, s > 0 and rng:NextNumber(26, 48) or -rng:NextNumber(26, 90)) * rot(), rng:NextNumber(1.0, 1.6), ({ rgb(118, 42, 34), rgb(100, 34, 30), rgb(132, 52, 38) })[k % 3 + 1], P11) -- p8 ref red carpet samples (142-174,73-79,50-59); base (148,37,35) rendered (220,38,52); (110,70,40) read orange-brown
	for _, p in ipairs(m:GetChildren()) do p.Material = SM end
end
for k = 1, 7 do
	local s = (k % 2 == 0) and 1 or -1
	place("K_DeadTree", CFrame.new(rng:NextNumber(78, 140), 6, s * rng:NextNumber(26, 44)) * rot(), rng:NextNumber(1.5, 1.9), rgb(40, 30, 35), P11)
end

-- item 1c: W lagoon (60,170,220) with a sand beach (225,205,150), palms and pool rings, NW between the W arm and Story
local function disc(name, d, pos, col, mat)
	return part(name, Vector3.new(0.3, d, d), CFrame.new(pos) * CFrame.Angles(0, 0, math.pi / 2), col, mat or SM, Enum.PartType.Cylinder, P11)
end
local LAG = { { -104, -78, 44 }, { -128, -56, 34 }, { -84, -104, 30 } }
for _, L in ipairs(LAG) do disc("Beach", L[3] + 10, Vector3.new(L[1], 6.06, L[2]), rgb(205, 185, 135), Enum.Material.Sand) end
for _, L in ipairs(LAG) do disc("Lagoon11", L[3], Vector3.new(L[1], 6.12, L[2]), rgb(55, 160, 210), SM).Transparency = 0.05 end
for _, r in ipairs({ { -100, -74, rgb(240, 120, 190) }, { -116, -64, rgb(255, 255, 255) }, { -90, -96, rgb(250, 200, 60) } }) do
	disc("PoolRing", 3.2, Vector3.new(r[1], 6.35, r[2]), r[3], SM)
	disc("PoolRingHole", 1.4, Vector3.new(r[1], 6.4, r[2]), rgb(55, 160, 210), SM)
end
for _, c in ipairs(P:GetChildren()) do -- trees standing in the water go
	local q = pivotOf(c)
	if q and q.X < -66 and q.X > -150 and q.Z < -40 and q.Z > -125 then c:Destroy() end
end
for _, p in ipairs({ { -72, -64 }, { -138, -86 }, { -116, -104 }, { -68, -118 } }) do palm("K_Palm6A", p[1], p[2], 1.1, rgb(80, 160, 60), 7, rng:NextNumber(0, 6.28), P11) end

-- item 1d: E/S/W flight tops: white paving (230,230,225) in place of the grass blocks; 2 crystal pedestals on S and W
for _, i in ipairs({ 1, 2, 3 }) do
	local a = math.rad(90 * i); local dir = Vector3.new(math.sin(a), 0, -math.cos(a)); local side = Vector3.new(math.cos(a), 0, math.sin(a))
	local c = dir * 60
	part("WhitePave", Vector3.new(44, 0.3, 26), CFrame.lookAt(Vector3.new(c.X, 5.9, c.Z), Vector3.new(c.X, 5.9, c.Z) + side), rgb(200, 200, 196), SM, nil, P11)
	if i ~= 1 then
		for s = -1, 1, 2 do
			local q = dir * 68 + side * (s * 38) -- p7: the reference pedestals stand wide (about 44 out, 66 back), at the frame corners
			part("Pedestal", Vector3.new(6, 5, 6), CFrame.new(q.X, 8.5, q.Z), rgb(210, 212, 214), SM, nil, P11)
			part("PedestalCap", Vector3.new(7, 0.8, 7), CFrame.new(q.X, 11.4, q.Z), rgb(225, 226, 228), SM, nil, P11)
			local cr = place("K_Crystal", CFrame.new(q.X, 14, q.Z) * rot(), 1.0, rgb(60, 150, 240), P11)
			local L = Instance.new("PointLight"); L.Color = rgb(80, 170, 255); L.Range = 10; L.Brightness = 1; L.Shadows = false
			L.Parent = cr:FindFirstChildWhichIsA("BasePart")
		end
	end
end
for _, c in ipairs(P:GetChildren()) do -- spills left on the old flight-top lawns go with them
	local q = pivotOf(c)
	if q and q.Y > 5.5 and c.Name == "K_Spill9" and ((math.abs(q.X) < 24 and q.Z > 46 and q.Z < 74) or (math.abs(q.Z) < 24 and q.X < -46 and q.X > -74)) then c:Destroy() end
end
-- N: sand beaches either side of the avenue's far half (p8 reference)
for s = -1, 1, 2 do part("NSand", Vector3.new(16, 0.3, 34), CFrame.new(s * 30, 6.75, -96), rgb(205, 185, 135), Enum.Material.Sand, nil, P11) end
-- lawn: ground parts darker and greener (r8 sample (159,189,86) against (115,170,47))
for _, n in ipairs({ "GroundN", "GroundS", "GroundE", "GroundW" }) do local g = root:FindFirstChild(n); if g then g.Color = rgb(74, 124, 28) end end
workspace.Terrain:SetMaterialColor(Enum.Material.Grass, rgb(74, 130, 28)) -- (84,140,44) rendered (116-143,175-187,62-79) against (92-115,166-170,39-47)
task.wait()

-- item 3: emissive sources. Glow inside the crystal pavilions (80,170,255), range 12, and a light in each crystal pod
for qx = -1, 1, 2 do for qz = -1, 1, 2 do
	for _, xz in ipairs({ { 30, 49 }, { 49, 30 } }) do
		local a = part("PavGlow", Vector3.new(0.2, 0.2, 0.2), CFrame.new(qx * xz[1], 14, qz * xz[2]), rgb(0, 0, 0), SM, nil, P11); a.Transparency = 1; a.CanCollide = false; a.CanQuery = false
		local L = Instance.new("PointLight"); L.Color = rgb(80, 170, 255); L.Range = 12; L.Brightness = 1.5; L.Shadows = false; L.Parent = a
	end
end end
for _, c in ipairs(P9f:GetChildren()) do
	if c.Name == "K_Pod8" then
		local g = c:FindFirstChild("K_Pod8_glass")
		if g then
			g.Material = NE; g.Color = rgb(40, 100, 220); g.Transparency = 0.25
			local L = Instance.new("PointLight"); L.Color = rgb(60, 140, 255); L.Range = 10; L.Brightness = 1; L.Shadows = false; L.Parent = g
		end
	end
end

-- item 5: Story tree rebuilt as parts: tan trunk 12 thick, 5 thick branches + a leader, 7 wispy clumps (30,90,220) with gaps,
-- 14 vines; footprint about 30% smaller; ring silver-blue around a Neon swirl portal (40,110,255)
for _, m in ipairs(LM:GetChildren()) do if m.Name == "K_BigTree8" then m:Destroy() end end
local ST = Instance.new("Model"); ST.Name = "StoryTree11"; ST.Parent = P11
local TB = Vector3.new(SX - 34, 6, 0)
local WOOD = rgb(150, 115, 80)
local function limb(a, b, d, col)
	local len = (b - a).Magnitude
	local up = math.abs((b - a).Unit.Y) > 0.9 and Vector3.xAxis or Vector3.yAxis -- lookAt is degenerate along its up vector
	return part("Limb", Vector3.new(len, d, d), CFrame.lookAt((a + b) / 2, b, up) * CFrame.Angles(0, math.pi / 2, 0), col or WOOD, SM, Enum.PartType.Cylinder, ST)
end
limb(TB + Vector3.new(0, -1, 0), TB + Vector3.new(0, 40, 0), 14)
limb(TB + Vector3.new(0, -1, 0), TB + Vector3.new(0, 8, 0), 20)
for k = 0, 3 do local a = k * math.pi / 2 + 0.4; limb(TB + Vector3.new(0, 6, 0), TB + Vector3.new(math.cos(a) * 9, -0.5, math.sin(a) * 9), 4.5) end -- roots
local tips = {}
for k = 0, 4 do
	local a = k * 2 * math.pi / 5 + 0.3; local r = 22 + (k % 2) * 5
	local b0 = TB + Vector3.new(0, 30 + k * 2, 0)
	local mid = TB + Vector3.new(math.cos(a) * r * 0.5, 56 + (k % 2) * 4, math.sin(a) * r * 0.5)
	local tip = TB + Vector3.new(math.cos(a) * r, 70 + (k % 3) * 5, math.sin(a) * r)
	limb(b0, mid, 7); limb(mid, tip, 4.2); table.insert(tips, tip)
end
limb(TB + Vector3.new(0, 42, 0), TB + Vector3.new(2, 80, -3), 5); table.insert(tips, TB + Vector3.new(2, 82, -3))
table.insert(tips, TB + Vector3.new(-6, 74, 12))
local CL = { rgb(30, 90, 220), rgb(45, 110, 235), rgb(25, 75, 200) }
for i, t in ipairs(tips) do
	for k = 1, 7 do -- wispy: many smaller flattened puffs per clump, a lumpy outline with sky between clumps
		local o = Vector3.new(rng:NextNumber(-9, 9), rng:NextNumber(-3, 5), rng:NextNumber(-9, 9))
		local sz = rng:NextNumber(8, 13)
		local b = blob("Clump11", Vector3.new(sz, sz * 0.55, sz), t + o, CL[(i + k) % 3 + 1], Enum.Material.LeafyGrass, ST); b.CastShadow = k == 1 -- LeafyGrass: leaf texture breaks the smooth ball
	end
	for k = 1, 2 do
		local v = t + Vector3.new(rng:NextNumber(-6, 6), -3, rng:NextNumber(-6, 6)); local len = rng:NextNumber(10, 20)
		part("Vine11", Vector3.new(0.5, len, 0.5), CFrame.new(v - Vector3.new(0, len / 2, 0)), rgb(40, 100, 220), SM, nil, ST).CastShadow = false
	end
end
for _, c in ipairs(P9f:GetChildren()) do
	if c.Name == "K_Ring9" then
		paint11(c, { void = { rgb(12, 30, 90), NE } })
		local v = c:FindFirstChild("K_Ring9_void")
		local sw = kit:FindFirstChild("K_Trip10_swirl")
		if sw and v then
			local w = sw:Clone(); w.Name = "StorySwirl"; local k = 1.55
			w.Size = sw.Size * k; w.CFrame = CFrame.new(Vector3.new(v.Position.X + 0.9, v.Position.Y, v.Position.Z)) * CFrame.Angles(0, math.pi / 2, 0)
			w.Color = rgb(120, 190, 255); w.Material = NE; w.CastShadow = false; w.Parent = P11
			local L = Instance.new("PointLight"); L.Color = rgb(40, 110, 255); L.Range = 18; L.Brightness = 1.5; L.Shadows = false; L.Parent = w
		end
	end
end
local sg = LM:FindFirstChild("StoryGlow"); if sg then sg.Transparency = 1 end

-- item 4: Summon. p1 measured: the reference facade is about 1.5x wider in frame (150-160 px against 100) and its top
-- sits 146 px above the horizon (about 56 studs at 195 out), with no dome on top. The whole hall group (facade, letters,
-- corner towers, gold-tree mass) is scaled 1.5x about its foot; the dome and finial go; gold/cream (215,190,120) with the
-- blue band kept.
do
	local SP = Vector3.new(0, 6, HZ)
	local grp = {}
	for _, f in ipairs({ LM, P9f }) do
		for _, c in ipairs(f:GetChildren()) do
			local q = pivotOf(c)
			if q and q.Z < HZ + 12 and math.abs(q.X) < 60 then
				if c.Name == "SummonDome" or c.Name == "SummonFinial" then c:Destroy()
				elseif c.Name == "K_Fluffy" then -- gold-tree mass: not scaled (1.5x walled the avenue in brown), lit gold instead
					for _, p in ipairs(c:GetChildren()) do
						if p.Name:find("leafRim") then p.Color = rgb(255, 225, 110) elseif p.Name:find("leaf") then p.Color = rgb(235, 190, 60) end
					end
				else table.insert(grp, c) end
			end
		end
	end
	local SUMF = Instance.new("Model"); SUMF.Name = "Summon11"; SUMF.Parent = P11
	for _, c in ipairs(grp) do
		local parts = c:IsA("BasePart") and { c } or c:GetDescendants()
		for _, p in ipairs(parts) do
			if p:IsA("BasePart") then
				local r = p.CFrame - p.Position; p.Size = p.Size * 1.5; p.CFrame = CFrame.new(SP + (p.Position - SP) * 1.5) * r
			end
		end
		c.Parent = SUMF
		if c.Name == "K_Summon9" then paint11(c, { cream = { rgb(205, 178, 108) }, gold = { rgb(170, 140, 50) } }) end
	end
end

-- item 8: bollards 35% lower (squashed about their foot)
for _, b in ipairs(root:GetChildren()) do
	if b.Name == "K_Bollard" then
		local foot = 0.3
		for _, p in ipairs(b:GetChildren()) do
			p.Size = Vector3.new(p.Size.X, p.Size.Y * 0.65, p.Size.Z)
			p.Position = Vector3.new(p.Position.X, foot + (p.Position.Y - foot) * 0.65, p.Position.Z)
		end
	end
end
end

-- ================================================================ pass 12 (verify9_plaza.md; same code as fix/pass12.lua)
do
local root = workspace.Plaza
local rgb = Color3.fromRGB
local SM, SL, NE = Enum.Material.SmoothPlastic, Enum.Material.Slate, Enum.Material.Neon
local old = root:FindFirstChild("Pass12"); if old then old:Destroy() end
local P12 = Instance.new("Folder"); P12.Name = "Pass12"; P12.Parent = root
local function part(name, size, cf, col, mat, parent)
	local p = Instance.new("Part"); p.Name = name; p.Size = size; p.CFrame = cf; p.Color = col; p.Material = mat or SM
	p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = parent or P12
	return p
end
local function each(m, f) if m:IsA("BasePart") then f(m) end for _, d in ipairs(m:GetDescendants()) do if d:IsA("BasePart") then f(d) end end end

-- ================================================================ item 2: Raid light/dark swap
local R = root:FindFirstChild("Pass11") and root.Pass11:FindFirstChild("Raid11")
if R then
	local FAC, REC, SPI = rgb(70, 22, 34), rgb(22, 5, 9), rgb(48, 16, 24)
	for _, x in ipairs(R:GetChildren()) do
		local n = x.Name
		if n == "RaidFacade" or n == "RaidGable" or n == "RaidGableTall" or n == "RaidGableFlank" or n == "RaidGableShoulder" then
			x.Color = FAC
		elseif n == "RaidButtress" or n == "RaidFacadeCap" then x.Color = rgb(52, 14, 22)
		elseif n == "RaidGableRecess" then x.Color = REC
		elseif n == "K_Arcade7" or n == "K_Gothic" then
			each(x, function(p) if p.Name:find("_stone") then p.Color = FAC elseif p.Name:find("darkStone") then p.Color = REC end end)
		elseif n == "K_Skull8" then
			local big = (x:GetExtentsSize().Y > 30)
			each(x, function(p)
				if p.Name:find("_bone") then
					if big then p.Color = rgb(175, 95, 95); p.Material = SM end -- (205,125,125) rendered (225,91,96)+ in the haze vs (180,93,86) -- dusty rose, the lightest thing on the temple
				elseif p.Name:find("_dark") then p.Color = rgb(55, 16, 20) end
			end)
		elseif n == "K_TxtRaid9" then each(x, function(p) p.Color = rgb(190, 80, 85) end) -- Neon (225,105,110) rendered (254,155,173) vs (187-235,114-121,113-122)
		end
	end
	-- red smoke at the skull and the door, a soft rose light on the skull face
	local hz = part("RaidSmoke12", Vector3.new(1, 1, 1), CFrame.new(0, 0, 0), rgb(0, 0, 0), SM, R); hz.Transparency = 1; hz.CanCollide = false
	hz.Name = "RaidSmoke12"; hz.Parent = P12
	for _, at in ipairs({ { Vector3.new(166, 80, 0), 26, 4 }, { Vector3.new(150, 14, 0), 22, 5 }, { Vector3.new(160, 45, 0), 30, 3 } }) do
		local a = Instance.new("Attachment"); a.WorldPosition = at[1]; a.Parent = hz
		local e = Instance.new("ParticleEmitter"); e.Texture = "rbxasset://textures/particles/smoke_main.dds"
		e.Color = ColorSequence.new(rgb(215, 95, 95), rgb(170, 70, 75)); e.LightEmission = 0 -- (255,70,70) with LightEmission 0.4 burnt the facade to (169,24,36): pinkish haze instead
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.8), NumberSequenceKeypoint.new(1, 1) })
		e.Size = NumberSequence.new(at[2] * 0.6, at[2]); e.Rate = at[3]; e.Lifetime = NumberRange.new(6, 9)
		e.Speed = NumberRange.new(0.5, 1.5); e.SpreadAngle = Vector2.new(180, 180); e.Rotation = NumberRange.new(0, 360)
		e.RotSpeed = NumberRange.new(-10, 10); e.Parent = a
	end
	local sk = Instance.new("Attachment"); sk.WorldPosition = Vector3.new(150, 86, 0); sk.Parent = hz
	local pl = Instance.new("PointLight"); pl.Color = rgb(255, 150, 150); pl.Range = 30; pl.Brightness = 0.6; pl.Parent = sk
	-- the beam light (1.2, range 26) lit the gable above the letters bright red: the skull must stay the lightest thing
	local bm = R:FindFirstChild("RaidBeam11"); local bl = bm and bm:FindFirstChildOfClass("PointLight"); if bl then bl.Brightness = 0.35; bl.Range = 16 end
	-- the 2 dark red palms move from the forecourt corners to either side of the door
	for _, x in ipairs(R:GetChildren()) do
		if x.Name == "K_Palm6B" then
			local s = (x:GetPivot().Position.Z > 0) and 1 or -1
			local cf, sz = x:GetBoundingBox(); local foot = cf.Position.Y - sz.Y / 2
			x:PivotTo(x:GetPivot() + (Vector3.new(146, x:GetPivot().Position.Y - foot + 6, s * 30) - x:GetPivot().Position))
			each(x, function(p) if p.Name:find("leaf") then p.Color = rgb(110, 22, 32) end end)
		end
	end
end

-- ================================================================ item 3: red litter as fine speckle over grey gravel
-- The pass-11 red zone was 54 big flat K_Patch cards plus red terrain beds: from above it read as solid red islands.
-- The reference reads as many small red leaves over grey gravel with green tufts and white flower dots.
do
	local P11 = root:FindFirstChild("Pass11")
	if P11 then
		for _, x in ipairs(P11:GetChildren()) do if x.Name:match("^K_Patch") then x:Destroy() end end
		local road = P11:FindFirstChild("GravelRoad"); if road then road.Color = rgb(72, 76, 74) end -- (62,66,64) rendered (89,99,99) vs (103,108,105)
	end
	local T = workspace.Terrain
	-- red terrain beds (NE corner bed, the two Raid flank beds) and the three tall-grass blocks go
	for _, b in ipairs({ { 80, -70, 40, 34 }, { 80, 70, 40, 34 }, { -80, 70, 40, 34 }, { -120, 0, 48, 74 }, { 185, -70, 34, 26 }, { 185, 70, 34, 26 } }) do
		T:FillBlock(CFrame.new(b[1], 5, b[2]), Vector3.new(b[3], 8, b[4]), Enum.Material.Air)
	end
	local L = Instance.new("Folder"); L.Name = "Litter12"; L.Parent = P12
	local gv = part("Gravel12", Vector3.new(127, 0.2, 200), CFrame.new(111.5, 5.96, -5), rgb(72, 76, 74), Enum.Material.Slate, L)
	local rng = Random.new(1212)
	local REDS = { rgb(112, 32, 33), rgb(120, 36, 36), rgb(128, 42, 40), rgb(118, 30, 38) } -- base; pass-11 (100-132,34-52) rendered (168-173,43-54)
	local function inZone(x, z) return x > 50 and x < 172 and z > -102 and z < 92 and math.abs(z) > 15 end
	local nC = 0
	local function card(x, z, w, d, col, parent)
		-- 2 in 3 leaves are flat discs (a lying cylinder): rectangles alone read as red bricks at the p7 angle.
		-- y 6.34: above the Zoning gravel patches (tops up to 6.32), which hid leaves at 6.13
		local p = Instance.new("Part"); p.Name = "Leaf"; p.Color = col; p.Material = SM
		local yaw = CFrame.Angles(0, rng:NextNumber(0, math.pi), 0)
		if rng:NextNumber() < 0.67 then
			p.Shape = Enum.PartType.Cylinder; p.Size = Vector3.new(0.06, d * 1.3, d * 1.3)
			p.CFrame = CFrame.new(x, 6.34 + rng:NextNumber(0, 0.04), z) * yaw * CFrame.Angles(0, 0, math.pi / 2)
		else
			p.Size = Vector3.new(w * 0.8, 0.06, d * 0.5)
			p.CFrame = CFrame.new(x, 6.34 + rng:NextNumber(0, 0.04), z) * yaw
		end
		p.Anchored = true; p.CanCollide = false; p.CastShadow = false; p.Parent = parent; nC += 1
	end
	-- clustered red leaves: 100 clusters, dense centres and ragged edges, gravel showing between
	local chunk = Instance.new("Folder"); chunk.Name = "Red"
	for c = 1, 100 do -- 70 clusters covered about 25% in p8; the reference is about 50%
		local cx, cz
		repeat cx, cz = rng:NextNumber(50, 172), rng:NextNumber(-102, 92) until inZone(cx, cz)
		local r = rng:NextNumber(6, 12)
		for k = 1, 30 do
			local a, d = rng:NextNumber(0, 2 * math.pi), r * math.sqrt(rng:NextNumber())
			local x, z = cx + math.cos(a) * d, cz + math.sin(a) * d
			if inZone(x, z) then card(x, z, rng:NextNumber(2, 4), rng:NextNumber(1, 2.2), REDS[rng:NextInteger(1, #REDS)], chunk) end
		end
		if c % 10 == 0 then chunk.Parent = L; chunk = Instance.new("Folder"); chunk.Name = "Red"; task.wait() end
	end
	chunk.Parent = L
	-- green tufts: 12 small clumps of short green cards
	local gch = Instance.new("Folder"); gch.Name = "Green"
	for c = 1, 12 do
		local cx, cz
		repeat cx, cz = rng:NextNumber(50, 172), rng:NextNumber(-102, 92) until inZone(cx, cz)
		for k = 1, 14 do
			local a, d = rng:NextNumber(0, 2 * math.pi), 5 * math.sqrt(rng:NextNumber())
			card(cx + math.cos(a) * d, cz + math.sin(a) * d, rng:NextNumber(1.5, 3), rng:NextNumber(0.8, 1.6), rgb(70, 120, 32), gch)
		end
	end
	gch.Parent = L
	-- white flower dots scattered over the red and green
	local fch = Instance.new("Folder"); fch.Name = "Flowers"
	for k = 1, 160 do
		local x, z
		repeat x, z = rng:NextNumber(50, 172), rng:NextNumber(-102, 92) until inZone(x, z)
		local p = Instance.new("Part"); p.Name = "Flower"; p.Shape = Enum.PartType.Ball; p.Size = Vector3.new(0.7, 0.7, 0.7)
		p.Color = rgb(235, 235, 230); p.Material = SM; p.CFrame = CFrame.new(x, 6.42, z); p.Anchored = true; p.CanCollide = false
		p.CastShadow = false; p.Parent = fch
	end
	fch.Parent = L
	print("litter cards", nC)
end

-- ================================================================ item 4: islands (grey-green rock, lifted, towers and round trees)
do
	local I = root:FindFirstChild("Islands")
	if I then
		local isl = {}
		for _, x in ipairs(I:GetChildren()) do if x.Name == "K_Isl91" or x.Name == "K_Isl92" then table.insert(isl, x) end end
		-- the 3 big low cloud blobs read as snowy mountains behind Summon in c3/c4; the new skybox carries the clouds now
		for _, x in ipairs(I:GetChildren()) do
			if x.Name == "K_Cloud7" and x:GetExtentsSize().X > 250 then x:Destroy() end
		end
		-- assign every island dressing (trees, ruins, domes, aqueducts, falls, fills) to its nearest island by XZ
		local groups = {}
		for _, x in ipairs(I:GetChildren()) do
			if not x.Name:match("^K_Cloud") and x.Name ~= "K_Isl91" and x.Name ~= "K_Isl92" then
				local pos = x:IsA("BasePart") and x.Position or (x:IsA("Model") and x:GetPivot().Position)
				if pos then
					local best, bd
					for _, m in ipairs(isl) do
						local d = (Vector2.new(pos.X, pos.Z) - Vector2.new(m:GetPivot().X, m:GetPivot().Z)).Magnitude
						if not bd or d < bd then best, bd = m, d end
					end
					if best and bd < 110 then groups[best] = groups[best] or {}; table.insert(groups[best], x) end
				end
			end
		end
		local TW = Instance.new("Folder"); TW.Name = "IslDress12"; TW.Parent = P12
		local rng = Random.new(412)
		for _, m in ipairs(isl) do
			local pv = m:GetPivot().Position
			-- lift N, W and E islands (stored once as an attribute so re-runs do not keep lifting)
			local lift = (pv.Z < -100 or pv.X < -150 or pv.X > 200) and 18 or 0
			local done = m:GetAttribute("Lift12") or 0
			local dy = lift - done
			if dy ~= 0 then
				m:PivotTo(m:GetPivot() + Vector3.new(0, dy, 0))
				for _, x in ipairs(groups[m] or {}) do
					if x:IsA("BasePart") then x.CFrame = x.CFrame + Vector3.new(0, dy, 0) else x:PivotTo(x:GetPivot() + Vector3.new(0, dy, 0)) end
				end
				m:SetAttribute("Lift12", lift)
			end
			-- grey-green rock with darker crevices: rock tone down, fills/crevices darker
			for _, p in ipairs(m:GetChildren()) do
				if p.Name:find("_rock") then p.Color = rgb(150, 162, 148) end
			end
			for _, x in ipairs(groups[m] or {}) do if x.Name == "IslFill" and x:IsA("BasePart") then x.Color = rgb(92, 102, 96) end end
			-- one tall grey tower and 4 round trees on the top
			local cf, sz = m:GetBoundingBox(); local top = cf.Position.Y + sz.Y / 2 - 2.5
			local ax = (sz.X > sz.Z) and Vector3.new(1, 0, 0) or Vector3.new(0, 0, 1)
			local L = math.max(sz.X, sz.Z)
			local tpos = Vector3.new(cf.X, top, cf.Z) + ax * (L * 0.28)
			local stone, dark = rgb(165, 170, 165), rgb(55, 60, 70)
			part("IslTower", Vector3.new(10, 50, 10), CFrame.new(tpos + Vector3.new(0, 25, 0)), stone, SL, TW)
			part("IslTowerBand", Vector3.new(11, 1.2, 11), CFrame.new(tpos + Vector3.new(0, 34, 0)), rgb(140, 145, 140), SL, TW)
			part("IslTowerTop", Vector3.new(12.5, 3, 12.5), CFrame.new(tpos + Vector3.new(0, 51.5, 0)), stone, SL, TW)
			for k = 0, 3 do
				local a = k * math.pi / 2; local o = Vector3.new(math.sin(a), 0, math.cos(a))
				for h = 0, 1 do
					part("IslTowerWin", Vector3.new(2.2, 6, 0.4), CFrame.lookAt(tpos + Vector3.new(0, 30 + h * 12, 0) + o * 5.05, tpos + Vector3.new(0, 30 + h * 12, 0) + o * 10), dark, SM, TW)
				end
			end
			for k = 1, 4 do
				local t = (k - 2.5) / 2.2
				local pos = Vector3.new(cf.X, top, cf.Z) + ax * (t * L * 0.22 - L * 0.08) + ax:Cross(Vector3.yAxis) * rng:NextNumber(-12, 12)
				local h = rng:NextNumber(7, 10)
				local tr = part("IslTreeTrunk", Vector3.new(1.6, h, 1.6), CFrame.new(pos + Vector3.new(0, h / 2, 0)), rgb(110, 85, 60), SM, TW)
				local g = rgb(85 + rng:NextInteger(0, 20), 150 + rng:NextInteger(0, 20), 55)
				for j = 1, 3 do
					local b = part("IslTreeBall", Vector3.one * rng:NextNumber(7, 10), CFrame.new(pos + Vector3.new(rng:NextNumber(-3, 3), h + rng:NextNumber(1, 5), rng:NextNumber(-3, 3))), g, Enum.Material.LeafyGrass, TW)
					b.Shape = Enum.PartType.Ball
				end
			end
		end
	end
end

-- ================================================================ item 5: horizon masses and the N avenue
do
	local H = Instance.new("Folder"); H.Name = "Horizon12"; H.Parent = P12
	local rng = Random.new(512)
	local CREAM, ROOF = rgb(228, 220, 198), rgb(120, 140, 175)
	local TREES = { rgb(45, 95, 215), rgb(95, 160, 60), rgb(225, 180, 60), rgb(150, 110, 215), rgb(60, 150, 200) }
	local function ball(name, d, pos, col, parent)
		local b = part(name, Vector3.one * d, CFrame.new(pos), col, Enum.Material.LeafyGrass, parent); b.Shape = Enum.PartType.Ball; return b
	end
	-- second, farther ring of tree masses (r 340-430) closes the green gaps to the horizon in p7
	for k = 0, 16 do
		local a = math.rad(-120 + k * 11 + rng:NextNumber(-3, 3)); local r = rng:NextNumber(340, 430)
		local c = Vector3.new(r * math.sin(a), 6, -r * math.cos(a)); local col = TREES[rng:NextInteger(1, #TREES)]
		for j = 1, 6 do
			local p = c + Vector3.new(rng:NextNumber(-26, 26), 0, rng:NextNumber(-16, 16)); local h = rng:NextNumber(22, 40)
			part("HzTrunk", Vector3.new(3.5, h, 3.5), CFrame.new(p + Vector3.new(0, h / 2, 0)), rgb(110, 85, 60), SM, H)
			ball("HzCrown", rng:NextNumber(20, 30), p + Vector3.new(0, h + 5, 0), col:Lerp(rgb(255, 255, 255), rng:NextNumber(0.05, 0.2)), H)
		end
	end
	local angles = { -105, -88, -72, -58, -44, -30, -17, -6, 6, 17, 30, 44, 58, -120, -135 }
	for i, a in ipairs(angles) do
		local r = rng:NextNumber(230, 300); local ar = math.rad(a)
		local c = Vector3.new(r * math.sin(ar), 6, -r * math.cos(ar))
		local face = CFrame.lookAt(c, Vector3.new(0, 6, 0))
		if i % 2 == 1 then -- building mass: block, cornice, dome or pitched roof, arch slots
			local h = rng:NextNumber(30, 55); local w, d = rng:NextNumber(30, 45), rng:NextNumber(20, 30)
			part("HzBlock", Vector3.new(w, h, d), face * CFrame.new(0, h / 2, 0), CREAM, SL, H)
			part("HzCornice", Vector3.new(w + 2, 1.5, d + 2), face * CFrame.new(0, h, 0), rgb(205, 195, 170), SL, H)
			for k = -1, 1 do
				part("HzArch", Vector3.new(4, h * 0.35, 0.6), face * CFrame.new(k * w * 0.28, h * 0.3, -d / 2 - 0.2), rgb(70, 80, 105), SM, H)
			end
			if i % 4 == 1 then
				local dm = part("HzDome", Vector3.one * (w * 0.55), face * CFrame.new(0, h + 1, 0), ROOF, SM, H); dm.Shape = Enum.PartType.Ball
			else
				local w1 = Instance.new("WedgePart"); w1.Name = "HzRoof"; w1.Size = Vector3.new(w, 9, d / 2); w1.CFrame = face * CFrame.new(0, h + 5.2, -d / 4) * CFrame.Angles(0, math.pi, 0)
				w1.Color = ROOF; w1.Material = SM; w1.Anchored = true; w1.Parent = H
				local w2 = w1:Clone(); w2.CFrame = face * CFrame.new(0, h + 5.2, d / 4); w2.Parent = H
			end
		else -- tree mass: 5-7 round crowns on trunks, one colour family
			local col = TREES[rng:NextInteger(1, #TREES)]
			for k = 1, rng:NextInteger(5, 7) do
				local p = c + Vector3.new(rng:NextNumber(-22, 22), 0, rng:NextNumber(-14, 14))
				local h = rng:NextNumber(18, 34)
				part("HzTrunk", Vector3.new(3, h, 3), CFrame.new(p + Vector3.new(0, h / 2, 0)), rgb(110, 85, 60), SM, H)
				ball("HzCrown", rng:NextNumber(16, 24), p + Vector3.new(0, h + 4, 0), col:Lerp(rgb(255, 255, 255), rng:NextNumber(0, 0.15)), H)
			end
		end
	end
	-- N avenue: 6 blue cypress cones (ellipsoids 4 x 14) and 4 striped stalls
	local AV = Instance.new("Folder"); AV.Name = "Avenue12"; AV.Parent = P12
	for _, z in ipairs({ -98, -126, -154 }) do
		for sx = -1, 1, 2 do
			local p0 = Vector3.new(sx * 17, 6, z)
			part("CypTrunk", Vector3.new(1, 2, 1), CFrame.new(p0 + Vector3.new(0, 1, 0)), rgb(100, 75, 50), SM, AV)
			local cy = part("Cypress", Vector3.new(4, 14, 4), CFrame.new(p0 + Vector3.new(0, 8.5, 0)), rgb(40, 90, 220), SM, AV)
			local m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Sphere; m.Parent = cy
		end
	end
	local AWN = { rgb(220, 60, 60), rgb(60, 120, 220), rgb(230, 170, 40), rgb(60, 170, 90) }
	for i, q in ipairs({ { -28, -112 }, { 28, -112 }, { -28, -142 }, { 28, -142 } }) do
		local face = CFrame.lookAt(Vector3.new(q[1], 6, q[2]), Vector3.new(0, 6, q[2]))
		part("StallCounter", Vector3.new(7, 3, 3.5), face * CFrame.new(0, 1.5, 0), rgb(150, 105, 65), SM, AV)
		for sx = -1, 1, 2 do part("StallPost", Vector3.new(0.4, 6.5, 0.4), face * CFrame.new(sx * 3.3, 3.25, -1.6), rgb(120, 85, 55), SM, AV) end
		for k = 0, 5 do
			local col = (k % 2 == 0) and AWN[i] or rgb(245, 245, 240)
			local st = part("StallAwning", Vector3.new(7.6 / 6, 0.25, 4.4), face * CFrame.new(-3.8 + (k + 0.5) * 7.6 / 6, 6.9, -0.6) * CFrame.Angles(math.rad(-14), 0, 0), col, SM, AV)
		end
		part("StallGoods", Vector3.new(5, 0.8, 2), face * CFrame.new(0, 3.4, 0), AWN[(i % 4) + 1], SM, AV)
	end
end

-- ================================================================ item 7: E/W arm-end terraces and carved pedestals
do
	local TR = Instance.new("Folder"); TR.Name = "Terraces12"; TR.Parent = P12
	local WH, RIM, SOCK = rgb(230, 230, 225), rgb(195, 198, 195), rgb(40, 50, 60)
	for sx = -1, 1, 2 do
		local c = Vector3.new(sx * 94, 6, 0)
		part("Terrace", Vector3.new(20, 1.2, 30), CFrame.new(c + Vector3.new(0, 0.6, 0)), WH, SM, TR)
		part("TerraceStep", Vector3.new(2.5, 0.6, 26), CFrame.new(c + Vector3.new(-sx * 11.2, 0.3, 0)), RIM, SM, TR)
		for sz = -1, 1, 2 do
			part("TerraceRail", Vector3.new(20, 1.4, 1), CFrame.new(c + Vector3.new(0, 1.9, sz * 14.5)), RIM, SM, TR)
			for k = -2, 2 do part("TerraceBaluster", Vector3.new(1.4, 2.4, 1.4), CFrame.new(c + Vector3.new(k * 4.5, 2.4, sz * 14.5)), WH, SM, TR) end
			-- carved plinth with a dark socket holding a crystal
			local pp = c + Vector3.new(sx * 6, 1.2, sz * 9)
			part("PlinthBase", Vector3.new(5, 0.8, 5), CFrame.new(pp + Vector3.new(0, 0.4, 0)), RIM, SM, TR)
			part("Plinth", Vector3.new(4, 4, 4), CFrame.new(pp + Vector3.new(0, 2.8, 0)), WH, SM, TR)
			part("PlinthCap", Vector3.new(4.8, 0.6, 4.8), CFrame.new(pp + Vector3.new(0, 5.1, 0)), RIM, SM, TR)
			part("PlinthSocket", Vector3.new(2.8, 0.3, 2.8), CFrame.new(pp + Vector3.new(0, 5.45, 0)), SOCK, SM, TR)
			local kit = game:GetService("ServerStorage"):FindFirstChild("Kit")
			local cr = kit and kit:FindFirstChild("K_Crystal")
			if cr then
				local m = cr:Clone(); m.Parent = TR
				if m:IsA("Model") then m:PivotTo(CFrame.new(pp + Vector3.new(0, 7.2, 0))) else m.CFrame = CFrame.new(pp + Vector3.new(0, 7.2, 0)) end
			end
		end
	end
	-- existing pass-11 pedestals: a dark socket on the cap and a stepped foot
	local P11 = root:FindFirstChild("Pass11")
	if P11 then
		for _, x in ipairs(P11:GetChildren()) do
			if x.Name == "PedestalCap" then
				part("PedSocket", Vector3.new(4, 0.3, 4), x.CFrame * CFrame.new(0, x.Size.Y / 2 + 0.15, 0), SOCK, SM, TR)
			elseif x.Name == "Pedestal" then
				part("PedFoot", Vector3.new(7.5, 0.8, 7.5), CFrame.new(x.Position.X, x.Position.Y - x.Size.Y / 2 + 0.4, x.Position.Z), rgb(195, 198, 195), SM, TR)
			end
		end
	end
end
end

local n = 0; for _, d in ipairs(root:GetDescendants()) do if d:IsA("BasePart") then n += 1 end end
local sp = workspace:FindFirstChild("SpawnLocation"); if sp then sp.CFrame = CFrame.new(0, 0.6, 30); sp.Transparency = 1; sp.CanCollide = false; local dc = sp:FindFirstChildOfClass("Decal"); if dc then dc:Destroy() end end
local bp = workspace:FindFirstChild("Baseplate"); if bp then bp:Destroy() end
return "plaza parts " .. n .. ", falls " .. nFall .. ", east " .. nE .. ", dressing " .. nf .. ", patches " .. nPatch .. ", spills " .. nS .. ", import scale " .. IMPORT_SCALE
