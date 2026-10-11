local agg = {}
for _, d in ipairs(workspace.Plaza:GetDescendants()) do
  if d:IsA("BasePart") and d.Transparency < 0.9 then
    local n = d.Name:lower()
    if n:find("leaf") or n:find("frond") or n:find("crown") or n:find("canopy") or n:find("pad") or n:find("blossom") then
      local h, s, v = d.Color:ToHSV()
      local key = d.Name .. " " .. string.format("%d,%d,%d s%.2f", d.Color.R*255+.5, d.Color.G*255+.5, d.Color.B*255+.5, s)
      agg[key] = (agg[key] or 0) + 1
    end
  end
end
local t = {} for k, n in pairs(agg) do table.insert(t, k .. " n=" .. n) end
table.sort(t) return table.concat(t, "\n")
