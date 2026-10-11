local out = {}
local function scan(f)
	for _, m in ipairs(f:GetChildren()) do
		local cf, sz
		if m:IsA("Model") then cf, sz = m:GetBoundingBox() elseif m:IsA("BasePart") then cf, sz = m.CFrame, m.Size end
		if cf and (cf.Position.Magnitude > 120 or sz.Magnitude > 60) then
			table.insert(out, m:GetFullName():sub(16) .. string.format(" @%d,%d,%d s%d,%d,%d", cf.X, cf.Y, cf.Z, sz.X, sz.Y, sz.Z))
		end
	end
end
for _, n in ipairs({"Islands", "Landmarks", "Pass22", "Pass21", "Pass20", "Pass19", "Pass16"}) do scan(workspace.Plaza[n]) end
return table.concat(out, "\n")
