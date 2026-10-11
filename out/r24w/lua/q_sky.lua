local out = {}
for _, m in ipairs(workspace.Plaza.Pass24.Sky24:GetChildren()) do
	local cf, sz = m:GetBoundingBox(); table.insert(out, m.Name .. string.format(" c %d,%d,%d s %d,%d,%d", cf.X, cf.Y, cf.Z, sz.X, sz.Y, sz.Z))
	for _, p in ipairs(m:GetChildren()) do if p:IsA("BasePart") then table.insert(out, "  " .. p.Name .. string.format(" %d,%d,%d s %d,%d,%d", p.Position.X, p.Position.Y, p.Position.Z, p.Size.X, p.Size.Y, p.Size.Z)) end end
end
local k = game.ServerStorage.Kit
for _, n in ipairs({"K_Isl772_rock","K_Isl772_grass","K_Isl772_fall","K_Isl772_vine","K_Isl772_white"}) do local p = k[n]; table.insert(out, n .. string.format(" %d,%d,%d s %d,%d,%d", p.Position.X, p.Position.Y, p.Position.Z, p.Size.X, p.Size.Y, p.Size.Z)) end
return table.concat(out, "\n")
