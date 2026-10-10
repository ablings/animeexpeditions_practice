-- EXPORT COPY ONLY. Park every chunk in ServerStorage.Parked; then bring ONE chunk (by name) into Workspace.
-- Chunks = children of Lobby.Main, Lobby.Areas, Lobby.Outer, plus Lobby.Summerprops. Arg: CHUNK = "__CHUNK__" ("" = list).
local SS = game:GetService("ServerStorage")
local park = SS:FindFirstChild("Parked") or Instance.new("Folder", SS); park.Name = "Parked"
local L = workspace:FindFirstChild("Lobby")
if L then
	for _, sec in ipairs({ "Main", "Areas", "Outer" }) do
		local f = L:FindFirstChild(sec)
		if f then for _, c in ipairs(f:GetChildren()) do c.Parent = park end end
	end
	local sp = L:FindFirstChild("Summerprops"); if sp then sp.Parent = park end
end
for _, c in ipairs(workspace:GetChildren()) do if c:GetAttribute("ExportChunk") then c.Parent = park end end
local want = "__CHUNK__"
local out = {}
for _, c in ipairs(park:GetChildren()) do
	local mp = 0; for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then mp += 1 end end
	table.insert(out, c.Name .. " parts " .. mp)
	if c.Name == want then c:SetAttribute("ExportChunk", true); c.Parent = workspace end
end
return table.concat(out, "\n")
