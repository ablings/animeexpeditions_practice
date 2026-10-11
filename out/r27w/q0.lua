local t={} for _,c in ipairs(workspace:GetChildren()) do table.insert(t,c.Name) end
local p=workspace.Plaza
local f={} for _,c in ipairs(p:GetChildren()) do table.insert(f,c.Name) end
return #p:GetDescendants().." | "..table.concat(t,",").." | "..table.concat(f,",").." | P26 "..tostring(p:FindFirstChild("Pass26")~=nil)
