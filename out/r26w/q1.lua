local agg = {}
for _, d in ipairs(workspace.Plaza:GetDescendants()) do
  if d:IsA("BasePart") and d.Transparency < 0.9 then
    local h, s, v = d.Color:ToHSV()
    if s > 0.45 and v > 0.3 then
      local hb = (h < 0.04 or h > 0.92) and "red" or (h < 0.17 and "gold") or (h < 0.45 and "green") or (h < 0.55 and "cyan") or (h < 0.70 and "blue") or "purple"
      local key = hb .. " " .. d.Name .. " " .. d.Material.Name .. " " .. string.format("%d,%d,%d", d.Color.R*255, d.Color.G*255, d.Color.B*255)
      local a = agg[key] or {0, 0}; a[1] += 1; a[2] += d.Size.X * d.Size.Y + d.Size.Y*d.Size.Z + d.Size.X*d.Size.Z; agg[key] = a
    end
  end
end
local t = {} for k, a in pairs(agg) do table.insert(t, {k, a[1], a[2]}) end
table.sort(t, function(a, b) return a[3] > b[3] end)
local o = {} for i = 1, math.min(60, #t) do local x = t[i]; if x[1]:match("^blue") or x[1]:match("^purple") or x[1]:match("^gold") then table.insert(o, string.format("%s n=%d A=%d", x[1], x[2], x[3])) end end
return table.concat(o, "\n")
