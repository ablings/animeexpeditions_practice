local out = {}
local function row(d) local c = d.Color
	return string.format("%s %s %s (%d,%d,%d) T%.1f @%d,%d,%d s%d,%d,%d", d:GetFullName():sub(16), d.Name, d.Material.Name, c.R*255, c.G*255, c.B*255, d.Transparency, d.Position.X, d.Position.Y, d.Position.Z, d.Size.X, d.Size.Y, d.Size.Z) end
local cnt = {}
for _, d in ipairs(workspace.Plaza.Zoning:GetDescendants()) do
	if d:IsA("BasePart") then local k = d.Name .. " " .. d.Material.Name .. string.format(" (%d,%d,%d)", d.Color.R*255, d.Color.G*255, d.Color.B*255); cnt[k] = (cnt[k] or 0) + 1 end
end
for k, v in pairs(cnt) do table.insert(out, "Zoning " .. k .. " x" .. v) end
for _, n in ipairs({"GroundN","GroundS","GroundE","GroundW"}) do table.insert(out, row(workspace.Plaza[n])) end
-- lime-ish things on E (X>40) low
local lc = {}
for _, d in ipairs(workspace.Plaza:GetDescendants()) do
	if d:IsA("BasePart") and d.Transparency < 1 and d.Position.X > 40 and d.Position.Y < 12 then
		local c = d.Color
		if c.G > c.R and c.G > c.B and c.G > 0.45 then local k = d.Parent.Name .. "/" .. d.Name .. string.format(" (%d,%d,%d) %s", c.R*255, c.G*255, c.B*255, d.Material.Name); lc[k] = (lc[k] or 0) + 1 end
	end
end
for k, v in pairs(lc) do table.insert(out, "E-green " .. k .. " x" .. v) end
return table.concat(out, "\n")
