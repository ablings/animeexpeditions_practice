local o = {}
local m = Instance.new("Model")
local function bbox(f)
	local mn, mx = Vector3.new(1e9,1e9,1e9), Vector3.new(-1e9,-1e9,-1e9); local n = 0
	for _, d in ipairs(f:GetDescendants()) do if d:IsA("BasePart") then n += 1
		local p, s = d.Position, d.Size * 0.5
		mn = Vector3.new(math.min(mn.X, p.X - s.X), math.min(mn.Y, p.Y - s.Y), math.min(mn.Z, p.Z - s.Z))
		mx = Vector3.new(math.max(mx.X, p.X + s.X), math.max(mx.Y, p.Y + s.Y), math.max(mx.Z, p.Z + s.Z)) end end
	if n == 0 then return "" end
	return string.format("min %.0f,%.0f,%.0f max %.0f,%.0f,%.0f", mn.X, mn.Y, mn.Z, mx.X, mx.Y, mx.Z)
end
table.insert(o, "Lobby " .. bbox(workspace.Lobby))
for _, sec in ipairs(workspace.Lobby:GetChildren()) do
	table.insert(o, "== " .. sec.Name .. " " .. bbox(sec))
	for _, c in ipairs(sec:GetChildren()) do
		local n = #c:GetDescendants()
		if n > 40 then table.insert(o, string.format("   %-28s %s desc %d %s", c.Name, c.ClassName, n, bbox(c))) end
	end
end
local T = workspace.Terrain
local ok, r = pcall(function() local reg = T:CountCells(); return reg end)
table.insert(o, "terrain cells: " .. tostring(ok and r or "?"))
return table.concat(o, "\n")
