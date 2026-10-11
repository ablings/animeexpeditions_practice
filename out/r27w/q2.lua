local out={} local seen={}
for _,d in ipairs(workspace.Plaza:GetDescendants()) do
 if d:IsA("SurfaceAppearance") and d.Parent:IsA("MeshPart") and d.Parent.Transparency<0.95 then
  local p=d.Parent local c=p.Color
  local sc="" pcall(function() local x=d.Color sc=string.format(" saCol(%d,%d,%d)",x.R*255+.5,x.G*255+.5,x.B*255+.5) end)
  local k=p.Name..string.format(" (%d,%d,%d)",c.R*255+.5,c.G*255+.5,c.B*255+.5).." CM="..tostring(d.ColorMap).." AM="..d.AlphaMode.Name..sc.." in "..p.Parent.Name.."/"..p.Parent.Parent.Name
  seen[k]=(seen[k] or 0)+1
 end end
for k,v in pairs(seen) do table.insert(out,v.."x "..k) end table.sort(out)
return table.concat(out,"\n")
