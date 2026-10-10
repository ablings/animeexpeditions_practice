-- READ-ONLY: spawn, area centres (floor height under them), lighting summary
local o = {}
local sp = workspace.Lobby:FindFirstChild("SpawnLocation")
if sp then table.insert(o, "spawn " .. tostring(sp.Position)) end
local p = RaycastParams.new()
for _, a in ipairs(workspace.Lobby.Areas:GetChildren()) do
	local ok, cf, sz = pcall(function() local m = Instance.new("Model"); return nil end)
	local mn, mx = Vector3.new(1e9,1e9,1e9), Vector3.new(-1e9,-1e9,-1e9); local n = 0
	for _, d in ipairs(a:GetDescendants()) do if d:IsA("BasePart") then n += 1; mn = mn:Min(d.Position); mx = mx:Max(d.Position) end end
	if n > 0 then
		local c = (mn + mx) / 2
		local r = workspace:Raycast(Vector3.new(c.X, 400, c.Z), Vector3.new(0, -800, 0), p)
		table.insert(o, string.format("%-26s centre %.0f,%.0f  floor %s", a.Name, c.X, c.Z, r and string.format("%.1f (%s)", r.Position.Y, r.Instance.Name) or "none"))
	end
end
local L = game.Lighting
table.insert(o, string.format("Lighting style %s bright %.2f clock %.2f ambient %s outdoor %s exposure %.2f", tostring(L.LightingStyle), L.Brightness, L.ClockTime, tostring(L.Ambient), tostring(L.OutdoorAmbient), L.ExposureCompensation))
for _, c in ipairs(L:GetChildren()) do table.insert(o, "  child " .. c.ClassName .. " " .. c.Name) end
return table.concat(o, "\n")
