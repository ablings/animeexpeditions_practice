local t = {}
local S = workspace.Plaza.Pass24.Sky24
for _, n in ipairs({"Tree24_bark","Tree24_crown"}) do local p = S[n]; table.insert(t, string.format("%s (%.0f,%.0f,%.0f) T%.1f", n, p.Position.X, p.Position.Y, p.Position.Z, p.Transparency)) end
local c = workspace.Plaza.Pass25.Crown25_leaf; table.insert(t, string.format("crown25 (%.0f,%.0f,%.0f)", c.Position.X, c.Position.Y, c.Position.Z))
return table.concat(t, " | ")
