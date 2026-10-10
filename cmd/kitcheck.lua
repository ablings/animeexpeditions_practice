local m = workspace:FindFirstChild("ae_kit_r1"); if not m then return "none" end
local o, n = {}, 0
for _, d in ipairs(m:GetDescendants()) do
	if d:IsA("MeshPart") then n += 1
		if d.Name == "K_Hood_stone" or d.Name == "K_Medal_stone" or d.Name == "K_Pav_blueDome" or d.Name == "K_Step_stone" or d.Name == "K_Pav_goldCol1" then
			table.insert(o, d.Name .. " size " .. tostring(d.Size) .. " pos " .. tostring(d.Position)) end end end
return n .. " meshparts\n" .. table.concat(o, "\n")
