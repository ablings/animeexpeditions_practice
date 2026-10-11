local r = workspace.Plaza.Pass25.Stairs25_joint; local s = workspace.Plaza.Pass19.K_Hero19_stone
if not r:GetAttribute("Q4") then r:SetAttribute("Q4", r.Color); s:SetAttribute("Q4", s.Color) r.Color = Color3.new(1,0,0); s.Color = Color3.new(0,1,0); return "tinted" end
r.Color = r:GetAttribute("Q4"); s.Color = s:GetAttribute("Q4"); r:SetAttribute("Q4", nil); s:SetAttribute("Q4", nil); return "restored"
