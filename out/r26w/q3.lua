local o = {}
for _, d in ipairs(workspace.Plaza:GetDescendants()) do
  if d:IsA("BasePart") and (d.Name:find("Stair") or d.Name:find("Riser") or d.Name:find("riser") or d.Name:find("Joint")) then
    table.insert(o, string.format("%s/%s %s %s col=%d,%d,%d T=%.2f fid=%s q=%s size=%s pos=%s", d.Parent.Name, d.Name, d.ClassName, d.Material.Name,
      d.Color.R*255+.5, d.Color.G*255+.5, d.Color.B*255+.5, d.Transparency, d:IsA("MeshPart") and d.CollisionFidelity.Name or "-", tostring(d.CanQuery),
      tostring(d.Size), tostring(d.Position)))
  end
end
return table.concat(o, "\n")
