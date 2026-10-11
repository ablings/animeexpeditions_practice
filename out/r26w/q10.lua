local o = {}
local function info(m) for _, d in ipairs(m:GetDescendants()) do if d:IsA("MeshPart") then table.insert(o, string.format("%s tex=%s col=%s", d:GetFullName():sub(17), d.TextureID, tostring(d.Color))) end end end
info(workspace.Plaza.Pass16.StoryCanopy16)
local n = 0 for _, m in ipairs(workspace.Plaza.Pass16.West16:GetChildren()) do n += 1 end
table.insert(o, "West16 children " .. n)
local cnt = {} for _, m in ipairs(workspace.Plaza.Pass16.West16:GetChildren()) do cnt[m.Name] = (cnt[m.Name] or 0) + 1 end
for k, v in pairs(cnt) do table.insert(o, "  " .. k .. " x" .. v) end
local cnt2 = {} for _, m in ipairs(workspace.Plaza.Pass13.Trees13:GetChildren()) do cnt2[m.Name] = (cnt2[m.Name] or 0) + 1 end
for k, v in pairs(cnt2) do table.insert(o, "  T13 " .. k .. " x" .. v) end
return table.concat(o, "\n")
