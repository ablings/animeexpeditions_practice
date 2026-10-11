game:GetService("Selection"):Set({})
local w = {} for _, c in ipairs(workspace:GetChildren()) do table.insert(w, c.Name) end
return "#Plaza desc " .. #workspace.Plaza:GetDescendants() .. " | Workspace: " .. table.concat(w, ", ")
