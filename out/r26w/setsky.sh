#!/bin/sh
# setsky.sh Up Dn Ft Bk Lf Rt : set Sky ids in the practice studio
cd /c/Users/Shadow/Documents/animeexp_practice
cat > out/r26w/setsky.lua <<L
local s = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
local SKY = { Up = $1, Dn = $2, Ft = $3, Bk = $4, Lf = $5, Rt = $6 }
for k, id in pairs(SKY) do s["Skybox" .. k] = "rbxassetid://" .. id end
return "sky set"
L
sh out/r26w/lrun.sh out/r26w/setsky.lua 2
