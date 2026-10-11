local cnt={} 
for _,d in workspace.Plaza.Pass13.Trees13:GetDescendants() do if d.Name=='K_Soft15K_leaf' then local sa=d:FindFirstChildOfClass('SurfaceAppearance') local ok,col=pcall(function() return sa.Color end) local k=string.format('(%d,%d,%d) ',d.Color.R*255,d.Color.G*255,d.Color.B*255)..sa.ColorMap..' '..(ok and tostring(col) or '-') cnt[k]=(cnt[k] or 0)+1 end end
local s={} for k,v in cnt do table.insert(s,k..' x'..v) end table.sort(s) return table.concat(s,'\n')
