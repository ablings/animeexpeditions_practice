local L = game:GetService("Lighting"); local s = L:FindFirstChildOfClass("Sky")
local t = {}
for _, k in ipairs({"Up","Dn","Ft","Bk","Lf","Rt"}) do table.insert(t, k .. "=" .. s["Skybox" .. k]) end
local w = {} for _, c in ipairs(workspace:GetChildren()) do table.insert(w, c.Name) end
local p = {} for _, c in ipairs(workspace.Plaza:GetChildren()) do table.insert(p, c.Name) end
local cc = L:FindFirstChildOfClass("ColorCorrectionEffect")
local at = L:FindFirstChildOfClass("Atmosphere")
return table.concat(t, " ") .. "\nWS: " .. table.concat(w, ",") .. "\nPlaza: " .. table.concat(p, ",") .. "\n#desc " .. #workspace.Plaza:GetDescendants()
 .. "\nCC sat " .. tostring(cc and cc.Saturation) .. " atm haze " .. tostring(at and at.Haze) .. " dens " .. tostring(at and at.Density)
 .. "\nclouds " .. tostring(workspace.Terrain:FindFirstChildOfClass("Clouds") ~= nil)
