local I=workspace.Plaza.Islands local o={}
local f=I:FindFirstChild('IslFill') table.insert(o,'IslFill '..f.ClassName..' '..f.Shape.Name..' '..tostring(f.Size)..' '..tostring(f.Color)..' '..f.Material.Name..' T'..f.Transparency..' child '..f:GetChildren()[1].ClassName..' pos '..tostring(f.Position))
local t=I:FindFirstChild('IslTrunk') table.insert(o,'IslTrunk '..tostring(t.Size)..' '..tostring(t.Position)..' T'..t.Transparency)
local fa=I:FindFirstChild('Fall10') table.insert(o,'Fall10 '..tostring(fa.Size)..' T'..fa.Transparency..' '..fa.Material.Name)
for _,n in ipairs({'IslDress12','Horizon12'}) do local d=workspace.Plaza.Pass12[n] local cnt={} for _,c in d:GetDescendants() do if c:IsA('BasePart') then cnt[c.Name]=(cnt[c.Name] or 0)+1 end end local s={} for k,v in cnt do table.insert(s,k..'x'..v) end table.insert(o,n..': '..table.concat(s,' ')) end
for _,n in ipairs({'Trees13'}) do local d=workspace.Plaza.Pass13[n] local cnt={} for _,c in d:GetDescendants() do if c:IsA('BasePart') then cnt[c.Name]=(cnt[c.Name] or 0)+1 end end local s={} for k,v in cnt do table.insert(s,k..'x'..v) end table.insert(o,n..': '..table.concat(s,' ')) end
local d=workspace.Plaza.Pass16.IslSkirt16 local cnt={} for _,c in d:GetDescendants() do if c:IsA('BasePart') then cnt[c.Name]=(cnt[c.Name] or 0)+1 end end local s={} for k,v in cnt do table.insert(s,k..'x'..v) end table.insert(o,'IslSkirt16: '..table.concat(s,' '))
local n=0 for _,c in I:GetChildren() do if c.Name=='IslFill' and c.Transparency<1 then n+=1 end end table.insert(o,'visible IslFill '..n)
return table.concat(o,'\n')
