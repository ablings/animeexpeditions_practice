local t = {} for _, c in ipairs(workspace:GetChildren()) do table.insert(t, c.Name) end
local k = {} for _, c in ipairs(game.ServerStorage.Kit:GetChildren()) do if c.Name:find("24_") then table.insert(k, c.Name) end end
return #workspace.Plaza:GetDescendants() .. " | " .. table.concat(t, ", ") .. " | kit24: " .. table.concat(k, ",")
