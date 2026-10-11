game.Selection:Set({}) local t={} for _,c in ipairs(workspace:GetChildren()) do table.insert(t,c.Name) end
return #workspace.Plaza:GetDescendants().." | "..table.concat(t,",").." | Pass22 "..#workspace.Plaza.Pass22:GetDescendants().." | kit r22 in SS: "..tostring(game.ServerStorage.Kit:FindFirstChild("K_Stairs22_stone")~=nil)
