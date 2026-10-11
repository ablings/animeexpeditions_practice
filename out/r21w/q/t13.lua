local T=workspace.Plaza.Pass13.Trees13 local cnt={} for _,c in T:GetChildren() do cnt[c.Name..':'..c.ClassName]=(cnt[c.Name..':'..c.ClassName] or 0)+1 end
local s={} for k,v in cnt do table.insert(s,k..'x'..v) end
local m=T:FindFirstChildWhichIsA('Model') local s2={} for _,d in m:GetDescendants() do table.insert(s2,d.Name..':'..d.ClassName) end
local W=workspace.Plaza.Pass16.West16 local s3={} local c3={} for _,c in W:GetChildren() do c3[c.Name]=(c3[c.Name] or 0)+1 end for k,v in c3 do table.insert(s3,k..'x'..v) end
local leaf=nil for _,d in T:GetDescendants() do if d.Name=='K_Soft15K_leaf' and d.Color.R>0.8 then leaf=d break end end
return table.concat(s,' ')..'\nfirst model '..m.Name..': '..table.concat(s2,' ')..'\nWest16: '..table.concat(s3,' ')..'\nleaf tex '..leaf.TextureID..' parent '..leaf.Parent:GetFullName()..' '..tostring(leaf.Position)..' sz '..tostring(leaf.Size)
