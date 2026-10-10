-- EXPORT COPY ONLY (never the reference): keep Lobby geometry, drop everything else.
local keep = workspace.Lobby
for _, c in ipairs(workspace:GetChildren()) do
	if c ~= keep and not c:IsA("Terrain") and not c:IsA("Camera") then pcall(function() c:Destroy() end) end
end
for _, s in ipairs(game:GetChildren()) do
	if s ~= workspace then for _, c in ipairs(s:GetChildren()) do pcall(function() c:Destroy() end) end end
end
local drop = { "Invis", "NPCs", "Collider", "ZoneVFX", "SpawnLocation", "PartyViewBackground" }
for _, n in ipairs(drop) do for _, c in ipairs(keep:GetChildren()) do if c.Name == n then c:Destroy() end end end
for _, d in ipairs(keep:GetDescendants()) do
	if d:IsA("Folder") and (d.Name:find("VFX") or d.Name == "Expeditions") then pcall(function() d:Destroy() end) end
end
for _, d in ipairs(keep:GetDescendants()) do
	if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") or d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then pcall(function() d:Destroy() end) end
end
workspace.Terrain:Clear()
local mp, p = 0, 0
for _, d in ipairs(keep:GetDescendants()) do if d:IsA("MeshPart") then mp += 1 elseif d:IsA("BasePart") then p += 1 end end
return "kept meshes " .. mp .. " parts " .. p
