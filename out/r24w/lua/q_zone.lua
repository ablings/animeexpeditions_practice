local out = {}
for _, d in ipairs(workspace.Plaza:GetDescendants()) do
	if d:IsA("BasePart") and d.Transparency < 1 and d.Position.Y < 9 then
		local c = d.Color
		local lime = c.G > 0.6 and c.R > 0.4 and c.B < 0.4
		local inZ = d.Parent.Parent and d.Parent.Parent.Name == "Zoning" or d.Parent.Name == "Zoning"
		if lime or inZ or d.Name:match("^Ground") then
			table.insert(out, string.format("%s %s %s (%d,%d,%d) @%d,%d,%d s%d,%d,%d", d:GetFullName():sub(16), d.ClassName, d.Material.Name, c.R*255, c.G*255, c.B*255, d.Position.X, d.Position.Y, d.Position.Z, d.Size.X, d.Size.Y, d.Size.Z))
		end
	end
end
return #out .. "\n" .. table.concat(out, "\n")
