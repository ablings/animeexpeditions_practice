local cnt={} local ex={}
for _,d in workspace.Plaza:GetDescendants() do if d:IsA('MeshPart') and d.Name:find('leaf') and not d.Name:find('Rim') then local side = d.Position.X<-25 and 'W' or (d.Position.X>25 and 'E' or 'C') local key=side..' '..d.Parent.Parent.Name..'/'..d.Name..' '..string.format('(%d,%d,%d)',d.Color.R*255,d.Color.G*255,d.Color.B*255)..' T'..d.Transparency cnt[key]=(cnt[key] or 0)+1 end end
local s={} for k,v in cnt do table.insert(s,k..' x'..v) end table.sort(s) return table.concat(s,'\n')
