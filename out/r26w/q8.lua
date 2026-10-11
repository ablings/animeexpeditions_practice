local o = {}
for _, d in ipairs(workspace.Plaza.Pass19:GetDescendants()) do
  if d:IsA("BasePart") and d.Name:find("Splat") then table.insert(o, string.format("%s.%s (%d,%d,%d) pos(%.0f,%.1f,%.0f) size(%.0f,%.1f,%.0f) T%.1f", d.Parent.Name, d.Name, d.Color.R*255+.5, d.Color.G*255+.5, d.Color.B*255+.5, d.Position.X, d.Position.Y, d.Position.Z, d.Size.X, d.Size.Y, d.Size.Z, d.Transparency)) end
end
return #o .. "\n" .. table.concat(o, "\n")
