local s = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
local SKY = { Up = 86697674728745, Dn = 76842875409340, Ft = 94655773202113, Bk = 132148118311790, Lf = 97641134518184, Rt = 132849943400915 }
for k, id in pairs(SKY) do s["Skybox" .. k] = "rbxassetid://" .. id end
return "sky set"
