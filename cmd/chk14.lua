local T = workspace.Plaza.Pass13.Trees13
local c = {}
for _, m in ipairs(T:GetChildren()) do c[m.Name] = (c[m.Name] or 0) + 1 end
local o = {} for k, v in pairs(c) do table.insert(o, k .. "=" .. v) end
local tri = 0
return table.concat(o, " ") .. " | desc " .. #workspace.Plaza:GetDescendants() .. " | kit14 " .. tostring(game.ServerStorage.Kit:FindFirstChild("K_Soft14R_leaf") ~= nil) .. " | r14 in ws " .. tostring(workspace:FindFirstChild("ae_kit_r14") ~= nil)
