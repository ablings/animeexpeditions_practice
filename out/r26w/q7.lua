local o = {}
local function bb(m) local cf, s = m:GetBoundingBox(); return string.format("c=(%d,%d,%d) s=(%d,%d,%d)", cf.X, cf.Y, cf.Z, s.X, s.Y, s.Z) end
for _, f in ipairs({workspace.Plaza.Pass24:FindFirstChild("Sky24"), workspace.Plaza.Pass25:FindFirstChild("Sky25"), workspace.Plaza:FindFirstChild("Islands")}) do
  if f then
    table.insert(o, "== " .. f:GetFullName() .. " #" .. #f:GetChildren())
    local cnt = {}
    for _, m in ipairs(f:GetChildren()) do
      if m:IsA("Model") and (m.Name:find("Isl") ) then
        local parts = {}
        for _, d in ipairs(m:GetChildren()) do if d:IsA("BasePart") then table.insert(parts, d.Name .. string.format("(%d,%d,%d T%.1f)", d.Color.R*255, d.Color.G*255, d.Color.B*255, d.Transparency)) end end
        table.insert(o, m.Name .. " " .. bb(m) .. " " .. table.concat(parts, " "))
      else cnt[m.Name] = (cnt[m.Name] or 0) + 1 end
    end
    for k, n in pairs(cnt) do table.insert(o, "  " .. k .. " x" .. n) end
  end
end
for _, nm in ipairs({"Crown25_leaf", "Crown25_rim"}) do local p = workspace.Plaza.Pass25:FindFirstChild(nm); if p then table.insert(o, nm .. string.format(" T%.2f %s mat %s", p.Transparency, tostring(p.Color), p.Material.Name)) end end
local s24 = workspace.Plaza.Pass24:FindFirstChild("Sky24"); if s24 then local b = s24:FindFirstChild("Tree24_bark"); if b then table.insert(o, "bark " .. tostring(b.Position)) end end
return table.concat(o, "\n")
