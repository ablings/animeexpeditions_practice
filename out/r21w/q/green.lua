local cnt={} local col={}
for _,d in workspace.Plaza:GetDescendants() do if d:IsA('BasePart') and d.Transparency<1 and d.Position.Y>60 then local c=d.Color if c.G>c.R and c.G>c.B then local k=d:GetFullName():gsub('Workspace.Plaza.','') k=k:gsub('%d+$','') local key=d.Parent.Name..'/'..d.Name cnt[key]=(cnt[key] or 0)+1 col[key]=tostring(d.Color)..' '..d.ClassName..' '..string.format('%.0f',d.Size.Magnitude) end end end
local s={} for k,v in cnt do table.insert(s,k..' x'..v..' '..col[k]) end table.sort(s) return table.concat(s,'\n')
