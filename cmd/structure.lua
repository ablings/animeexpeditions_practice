-- READ-ONLY: top-level structure of Workspace (and 2 levels down for the biggest), with descendant counts and bounding boxes
local o = {}
local function info(inst, depth)
	local n, mp, p = 0, 0, 0
	for _, d in ipairs(inst:GetDescendants()) do n += 1; if d:IsA("MeshPart") then mp += 1 elseif d:IsA("BasePart") then p += 1 end end
	local bb = ""
	if inst:IsA("Model") or inst:IsA("Folder") or inst:IsA("WorldModel") then
		local ok, cf, sz = pcall(function() local m = inst; if inst:IsA("Folder") then m = Instance.new("Model"); return nil end; return m:GetBoundingBox() end)
		if ok and cf then bb = string.format(" c %.0f,%.0f,%.0f size %.0f,%.0f,%.0f", cf.X, cf.Y, cf.Z, sz.X, sz.Y, sz.Z) end
	end
	table.insert(o, string.rep("  ", depth) .. string.format("%s [%s] desc %d mesh %d part %d%s", inst.Name, inst.ClassName, n, mp, p, bb))
end
for _, c in ipairs(workspace:GetChildren()) do
	info(c, 0)
	if #c:GetDescendants() > 2000 then for _, g in ipairs(c:GetChildren()) do if #g:GetDescendants() > 200 then info(g, 1) end end end
end
return table.concat(o, "\n")
