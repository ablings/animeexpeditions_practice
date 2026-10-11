local m = workspace.Plaza.Pass24.Sky24.Isl24_4
local o = {}
for _, d in ipairs(m:GetDescendants()) do
  if d:IsA("MeshPart") then table.insert(o, string.format("%s tex=%s sa=%s col=%s T=%.2f", d:GetFullName():sub(30), d.TextureID, tostring(d:FindFirstChildOfClass("SurfaceAppearance") ~= nil), tostring(d.Color), d.Transparency)) end
end
return table.concat(o, "\n")
