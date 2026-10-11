-- temporary proof tint (restore with untint.lua); originals in T27o attributes
local P25=workspace.Plaza.Pass25
local function t(p,c) if p:GetAttribute("T27o")==nil then p:SetAttribute("T27o",p.Color) end p.Color=c end
t(P25.Stairs25_stone,Color3.new(1,0,0)) t(P25.Stairs25_riser,Color3.new(0,1,0)) t(P25.Stairs25_joint,Color3.new(0,0,1))
local n=0
for _,d in ipairs(workspace.Plaza:GetDescendants()) do
 if d:IsA("SurfaceAppearance") and d.Parent.Transparency<0.95 then
  local tgt=nil
  if d.Parent.Name:find("^K_Soft13P_leaf") and d.Parent.Parent.Name=="NPalm22" then tgt=Color3.new(1,0,1)
  elseif tostring(d.ColorMap)=="rbxassetid://118173022878419" then tgt=Color3.new(1,1,0) end
  if tgt then if d:GetAttribute("T27o")==nil then d:SetAttribute("T27o",d.Color) end d.Color=tgt n+=1 end
 end end
return "tinted SA "..n
