local s={} for _,d in workspace.Plaza.K_Stairs:GetDescendants() do if d:IsA('BasePart') then table.insert(s,d.Name..' '..string.format('(%d,%d,%d)',d.Color.R*255,d.Color.G*255,d.Color.B*255)..' '..d.Material.Name..' T'..d.Transparency..' sz '..tostring(d.Size)) end end
local c={} for _,d in workspace.Plaza:GetDescendants() do if d:IsA('BasePart') and (d.Name:lower():find('wedge') or d.Name:find('Spacer') or d.Name:find('Nosing')) then c[d:GetFullName()]=(c[d:GetFullName()] or 0)+1 end end
for k,v in c do table.insert(s,k..' x'..v) end
return table.concat(s,'\n')
