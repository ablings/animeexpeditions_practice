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
-- pass 5: own cloudy day skybox v2 (tex/make_ae_tex5.py: one panorama across the 4 sides, no clouds on the up face,
-- which removes the pass-4 corner artefact), uploaded via the file server
local SKY = { Up = 71892846199507, Dn = 78820631398749, Ft = 126129044892365, Bk = 113669221037411, Lf = 106268068341369, Rt = 97088461169211 }
for k, id in pairs(SKY) do sky["Skybox" .. k] = "rbxassetid://" .. id end
sky.CelestialBodiesShown = true
workspace.StreamingEnabled = false
-- pass 5 (round-2 review item 10): more contrast between sun and shade sides, warm grade, haze for the far skyline
-- pass 6: the pass-5 Ambient/OutdoorAmbient (110,115,130) and Contrast 0.22 override is REMOVED: it was darker than the
-- reference's own values (Ambient 102,74,101 / OutdoorAmbient 169,165,184 / Contrast 0.12) and turned every shaded
-- gate face navy. The reference values set at the top now stand; only a warm tint is kept.
-- pass 11 (lead's note): the pass 6-8 drift (warm TintColor, Bloom 0.5/1.1, Atmosphere 0.26/Haze 0.5/Offset 0.1/greyer colour)
-- is REMOVED: Atmosphere, Bloom, ColorCorrection and SunRays stay exactly as notes/settings_ref.txt records (set above).
-- pass 5: the uploaded skybox clouds did not show in the captures, so add Roblox's own volumetric Terrain clouds too
local cl = workspace.Terrain:FindFirstChildOfClass("Clouds") or Instance.new("Clouds", workspace.Terrain)
cl.Cover = 0.55; cl.Density = 0.55; cl.Color = Color3.fromRGB(255, 255, 255)
return "lighting matched"
