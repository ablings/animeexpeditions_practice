-- READ-ONLY: walkable floor height at each area centre, skipping invisible/non-colliding parts
local o = {}
local function floorAt(x, z)
	local p = RaycastParams.new(); p.FilterType = Enum.RaycastFilterType.Exclude; local ex = {}
	local y = 400
	for i = 1, 12 do
		p.FilterDescendantsInstances = ex
		local r = workspace:Raycast(Vector3.new(x, y, z), Vector3.new(0, -900, 0), p)
		if not r then return nil end
		local d = r.Instance
		if d.Transparency < 0.9 and d.CanCollide then return r.Position.Y, d.Name end
		table.insert(ex, d)
	end
end
for _, a in ipairs(workspace.Lobby.Areas:GetChildren()) do
	local mn, mx = Vector3.new(1e9,1e9,1e9), Vector3.new(-1e9,-1e9,-1e9); local n = 0
	for _, d in ipairs(a:GetDescendants()) do if d:IsA("BasePart") then n += 1; mn = mn:Min(d.Position); mx = mx:Max(d.Position) end end
	if n > 0 then local c = (mn + mx) / 2; local y, nm = floorAt(c.X, c.Z)
		table.insert(o, string.format("%s|%.0f|%.0f|%s|%s", a.Name, c.X, c.Z, y and string.format("%.1f", y) or "none", nm or "")) end
end
local y, nm = floorAt(3000, 0); table.insert(o, string.format("SPAWN|3000|0|%.1f|%s", y or -999, nm or ""))
return table.concat(o, "\n")
