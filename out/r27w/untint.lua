local n=0
for _,d in ipairs(workspace.Plaza:GetDescendants()) do
 local o=d:GetAttribute("T27o") if o~=nil then d.Color=o d:SetAttribute("T27o",nil) n+=1 end end
return "restored "..n
