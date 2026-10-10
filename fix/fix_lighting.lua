-- fix_lighting.lua (practice place): the reference's lighting settings (read with cmd/settings_dump.lua; settings, not assets).
local L = game:GetService("Lighting"); local c = Color3.new
L.Ambient = c(0.4, 0.290196, 0.396078); L.Brightness = 3.5; L.ColorShift_Bottom = c(0, 0, 0); L.ColorShift_Top = c(1, 0.996078, 0.937255)
L.EnvironmentDiffuseScale = 0; L.EnvironmentSpecularScale = 1; L.ExposureCompensation = 0; L.GeographicLatitude = 50
L.GlobalShadows = true; L.OutdoorAmbient = c(0.662745, 0.647059, 0.721569); L.ShadowSoftness = 0.2; L.ClockTime = 13.1833
pcall(function() L.LightingStyle = Enum.LightingStyle.Realistic end)
for _, ch in ipairs(L:GetChildren()) do if not ch:IsA("Sky") then ch:Destroy() end end
local function new(cls, props) local o = Instance.new(cls); for k, v in pairs(props) do o[k] = v end; o.Parent = L end
new("Atmosphere", { Density = 0.2, Offset = 0.25, Color = c(0.780392, 0.780392, 0.780392), Decay = c(0.415686, 0.439216, 0.490196), Glare = 0, Haze = 0 })
new("BloomEffect", { Intensity = 1, Size = 56, Threshold = 2 })
new("ColorCorrectionEffect", { Brightness = 0.01, Contrast = 0.12, Saturation = 0.14 })
new("SunRaysEffect", { Intensity = 0.15, Spread = 0.7 })
local sky = L:FindFirstChildOfClass("Sky") or Instance.new("Sky", L); sky.SunAngularSize = 10
-- pass 4: own cloudy day skybox (tex/make_ae_tex4.py), uploaded via the file server
local SKY = { Up = 96646909420645, Dn = 92885134578521, Ft = 122596386826953, Bk = 137792395717714, Lf = 128311943510983, Rt = 138049081543674 }
for k, id in pairs(SKY) do sky["Skybox" .. k] = "rbxassetid://" .. id end
sky.CelestialBodiesShown = true
workspace.StreamingEnabled = false
return "lighting matched"
