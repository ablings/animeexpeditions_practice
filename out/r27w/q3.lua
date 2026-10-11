local out={}
for _,d in ipairs(workspace.Plaza:GetDescendants()) do
 if d:IsA("BasePart") and (d.Name:lower():find("stair") or d.Name:find("Tread") or d.Name:find("Step")) then
  local c=d.Color table.insert(out,d:GetFullName().." "..d.ClassName.." "..d.Material.Name..string.format(" (%d,%d,%d) T%.2f size %.1f,%.1f,%.1f",c.R*255+.5,c.G*255+.5,c.B*255+.5,d.Transparency,d.Size.X,d.Size.Y,d.Size.Z)..(d:IsA("MeshPart") and (" tex="..d.TextureID) or ""))
 end end
return table.concat(out,"\n")
