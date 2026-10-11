local o = {}
local P = {Vector3.new(-9.1, 4.3, -41.0), Vector3.new(-5.0, 2.4, -34.8)}
for _, p in ipairs(P) do
  for _, d in ipairs(workspace.Plaza:GetDescendants()) do
    if d:IsA("BasePart") and d.Transparency < 0.95 then
      local lp = d.CFrame:PointToObjectSpace(p); local h = d.Size / 2
      if math.abs(lp.X) <= h.X + 0.3 and math.abs(lp.Y) <= h.Y + 0.3 and math.abs(lp.Z) <= h.Z + 0.3 then
        table.insert(o, string.format("%s: %s %s %s col=%d,%d,%d T=%.2f", tostring(p), d:GetFullName(), d.ClassName, d.Material.Name, d.Color.R*255+.5, d.Color.G*255+.5, d.Color.B*255+.5, d.Transparency))
      end
    end
  end
end
return table.concat(o, "\n")
