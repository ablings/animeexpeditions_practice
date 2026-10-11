local kit = game.ServerStorage.Kit
local t = {}
for _, k in ipairs(kit:GetChildren()) do if k.Name:find("^K_Isl77") or k.Name:find("^K_Soft14") or k.Name:find("^K_Spire") or k.Name:find("Fern") or k.Name:find("Ruin") or k.Name:find("Tower") then
 table.insert(t, string.format("%s pos(%.0f,%.0f,%.0f) size(%.0f,%.0f,%.0f) tris?", k.Name, k.Position.X, k.Position.Y, k.Position.Z, k.Size.X, k.Size.Y, k.Size.Z)) end end
local s = workspace.Plaza.Pass24.Sky24
for _, m in ipairs(s:GetChildren()) do if m:IsA("Model") then local cf, sz = m:GetBoundingBox(); table.insert(t, string.format("%s c(%.0f,%.0f,%.0f) s(%.0f,%.0f,%.0f)", m.Name, cf.X, cf.Y, cf.Z, sz.X, sz.Y, sz.Z)) end end
return table.concat(t, "\n")
