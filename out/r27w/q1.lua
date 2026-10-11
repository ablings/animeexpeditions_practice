local out={}
local seen={}
for _,d in ipairs(workspace.Plaza:GetDescendants()) do
 if d:IsA("MeshPart") and (d.Name:find("_leaf") ) and d.Transparency<0.95 then
  local c=d.Color local k=d.Name..string.format(" (%d,%d,%d)",c.R*255+.5,c.G*255+.5,c.B*255+.5)
  local sa=d:FindFirstChildOfClass("SurfaceAppearance")
  k=k.." tex="..(d.TextureID~="" and "Y" or "n").." sa="..(sa and "Y" or "n")
  seen[k]=(seen[k] or 0)+1
 end
end
for k,v in pairs(seen) do table.insert(out,v.."x "..k) end
table.sort(out)
return table.concat(out,"\n")
