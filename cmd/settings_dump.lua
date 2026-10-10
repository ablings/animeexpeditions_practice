-- READ-ONLY settings dump (safe in the reference): Lighting properties + children, Workspace/streaming, MaterialService.
local out = {}
local function add(k, v) table.insert(out, k .. " = " .. tostring(v)) end
local L = game:GetService("Lighting")
for _, p in ipairs({"Ambient","Brightness","ColorShift_Bottom","ColorShift_Top","EnvironmentDiffuseScale","EnvironmentSpecularScale",
	"ExposureCompensation","FogColor","FogEnd","FogStart","GeographicLatitude","GlobalShadows","OutdoorAmbient","ShadowSoftness",
	"ClockTime","LightingStyle","PrioritizeLightingQuality"}) do
	local ok, v = pcall(function() return L[p] end); add("Lighting." .. p, ok and v or "n/a")
end
local function props(inst, list) for _, p in ipairs(list) do local ok, v = pcall(function() return inst[p] end); if ok then add(inst.ClassName .. "(" .. inst.Name .. ")." .. p, v) end end end
for _, c in ipairs(L:GetChildren()) do
	add("Lighting child", c.ClassName .. " " .. c.Name)
	if c:IsA("Atmosphere") then props(c, {"Density","Offset","Color","Decay","Glare","Haze"})
	elseif c:IsA("BloomEffect") then props(c, {"Enabled","Intensity","Size","Threshold"})
	elseif c:IsA("ColorCorrectionEffect") then props(c, {"Enabled","Brightness","Contrast","Saturation","TintColor"})
	elseif c:IsA("SunRaysEffect") then props(c, {"Enabled","Intensity","Spread"})
	elseif c:IsA("DepthOfFieldEffect") then props(c, {"Enabled","FarIntensity","FocusDistance","InFocusRadius","NearIntensity"})
	elseif c:IsA("Sky") then props(c, {"CelestialBodiesShown","StarCount","SunAngularSize","MoonAngularSize"}); add("Sky.hasSkybox", c.SkyboxFt ~= "")
	elseif c:IsA("Clouds") then props(c, {"Enabled","Cover","Density","Color"}) end
end
local W = workspace
for _, p in ipairs({"StreamingEnabled","Gravity","FallenPartsDestroyHeight","GlobalWind","AirDensity"}) do
	local ok, v = pcall(function() return W[p] end); add("Workspace." .. p, ok and v or "n/a")
end
add("Camera.FieldOfView", W.CurrentCamera and W.CurrentCamera.FieldOfView)
local MS = game:GetService("MaterialService")
pcall(function() add("MaterialService.Use2022Materials", MS.Use2022Materials) end)
for _, m in ipairs(Enum.Material:GetEnumItems()) do local ok, v = pcall(function() return MS:GetBaseMaterialOverride(m) end); if ok and v ~= "" then add("BaseOverride." .. m.Name, v) end end
local nv = 0; for _, d in ipairs(MS:GetDescendants()) do if d:IsA("MaterialVariant") then nv += 1 end end; add("MaterialVariants", nv)
local T = W.Terrain; add("Terrain.WaterColor", T.WaterColor); pcall(function() add("Terrain.Decoration", T.Decoration) end)
return table.concat(out, "\n")
