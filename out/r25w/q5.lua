local t = {} for _, c in ipairs(workspace:GetChildren()) do table.insert(t, c.Name) end
game:GetService("Selection"):Set({})
return #workspace.Plaza:GetDescendants() .. " | " .. table.concat(t, ", ")
