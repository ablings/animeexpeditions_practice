local t = {}
for _, f in ipairs(workspace.Plaza.Pass25.Fern25:GetChildren()) do table.insert(t, string.format("(%.1f,%.1f,%.1f)", f.Position.X, f.Position.Y, f.Position.Z)) end
return table.concat(t, " ")
