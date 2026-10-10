-- nav_scan.lua : walkability flood-fill (raycasts only, safe to run in the read-only reference place)
-- Player rules: step 1.6, jump 7, headroom 5, fall 60. 2-stud grid from a start cell on the hub floor.
-- Output lines "x,z,y" with x,z = studio/2 and y = round(studioY*2), sorted; compare with nav_compare.py.
-- In the replica: POST the text to the Blender file server (toggle HttpService around the call).
-- In the reference (no HttpService allowed): return the RLE string instead and save it as nav_cN_ref.rle.
local STEP, JUMP, HEAD, FALL, G = 1.6, 7, 5, 60, 2
local START_X, START_Z, START_TOP = 220, -188, 0 -- Sniper Duels lobby spawn pad (floor y -9.98)
local MODE = "return" -- "return": hand the text back (reference, no HttpService); "post": save via the file server (practice place)
local OUT = "nav_v_mine.txt" -- post mode file name, rename per round
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.RespectCanCollide = true
local NAVGROUP = "__NAVGROUP__" -- cast as a player: reference "Players", practice place "Walker"
if NAVGROUP ~= "" and not NAVGROUP:find("__") then params.CollisionGroup = NAVGROUP end
local excl = {}
for _, c in ipairs(workspace:GetChildren()) do
	if c:IsA("SpawnLocation") or c.Name == "Camera" then table.insert(excl, c) end
end
params.FilterDescendantsInstances = excl
local function floorAt(x, z, yTop, len)
	local r = workspace:Raycast(Vector3.new(x, yTop, z), Vector3.new(0, -len, 0), params)
	return r and r.Position.Y or nil
end
local function clearUp(x, y, z, h) return workspace:Raycast(Vector3.new(x, y + 0.1, z), Vector3.new(0, h, 0), params) == nil end
local function clearTo(x1, y, z1, x2, z2)
	local a, b = Vector3.new(x1, y, z1), Vector3.new(x2, y, z2)
	return workspace:Raycast(a, b - a, params) == nil
end
local sy = floorAt(START_X, START_Z, START_TOP, 40)
if not sy then return "no start floor" end
local seen, queue = {}, { { START_X, START_Z, sy } }
local function key(x, z) return x .. "," .. z end
seen[key(START_X, START_Z)] = sy
local n = 0
while #queue > 0 do
	local c = table.remove(queue); local x, z, y = c[1], c[2], c[3]
	n += 1; if n % 800 == 0 then task.wait() end
	for _, d in ipairs({ { G, 0 }, { -G, 0 }, { 0, G }, { 0, -G } }) do
		local nx, nz = x + d[1], z + d[2]; local k = key(nx, nz)
		if seen[k] == nil then
			local ny = floorAt(nx, nz, y + JUMP + 0.2, JUMP + 0.2 + FALL)
			if ny then
				local dy, ok = ny - y, false
				if dy <= STEP and dy >= -FALL then
					ok = clearTo(x, y + 1.5, z, nx, nz) and clearTo(x, y + 4, z, nx, nz) and clearUp(nx, ny, nz, HEAD)
					if dy > 0 then ok = ok and clearTo(x, ny + 1.5, z, nx, nz) end
				elseif dy <= JUMP then
					ok = clearUp(x, y, z, dy + HEAD) and clearTo(x, ny + 1.5, z, nx, nz) and clearTo(x, ny + 4, z, nx, nz) and clearUp(nx, ny, nz, HEAD)
				end
				if ok then seen[k] = ny; table.insert(queue, { nx, nz, ny }) else seen[k] = false end
			else seen[k] = false end
		end
	end
end
local lines = {}
for k, v in pairs(seen) do
	if v then
		local x, z = k:match("^(-?%d+),(-?%d+)$")
		lines[#lines + 1] = string.format("%d,%d,%d", math.floor(tonumber(x) / 2), math.floor(tonumber(z) / 2), math.floor(v * 2 + 0.5))
	end
end
table.sort(lines)
local text = table.concat(lines, "\n")
if MODE == "return" then return text end
-- practice place: save through the file server
local hs = game:GetService("HttpService")
local was = hs.HttpEnabled; hs.HttpEnabled = true
local ok, err = pcall(function() return hs:PostAsync("http://127.0.0.1:8766/" .. OUT, text, Enum.HttpContentType.TextPlain) end)
hs.HttpEnabled = was
return "cells " .. #lines .. " post " .. tostring(ok) .. " " .. tostring(err):sub(1, 60)
