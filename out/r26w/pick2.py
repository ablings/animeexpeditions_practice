"""pick2.py <cam> x,y [x,y...]: practice part under each pixel; temporarily makes every visible Plaza part queryable
(and hidden ones not) inside the same script, then restores CanQuery. Prints the hit part and its parent chain."""
import sys, json, subprocess
cam = sys.argv[1]; c = json.load(open("cams_practice.json"))[cam]
pts = "{" + ",".join("{%s}" % a for a in sys.argv[2:]) + "}"
code = """local cam=Vector3.new(CX) local cf=CFrame.lookAt(cam,Vector3.new(LX))
local f=396.5/math.tan(math.rad(35)) local out={} local saved={}
for _,d in ipairs(workspace.Plaza:GetDescendants()) do if d:IsA("BasePart") then saved[d]=d.CanQuery; d.CanQuery=(d.Transparency<0.95) end end
for _,p in ipairs(PTSX) do local d=cf:VectorToWorldSpace(Vector3.new((p[1]-726)/f,-(p[2]-396.5)/f,-1)).Unit
 local r=workspace:Raycast(cam,d*3000)
 if r then local i=r.Instance table.insert(out,p[1]..","..p[2].." -> "..i:GetFullName().." "..i.Material.Name..string.format(" (%d,%d,%d) T%.2f",i.Color.R*255+.5,i.Color.G*255+.5,i.Color.B*255+.5,i.Transparency).." at "..string.format("%.0f,%.0f,%.0f",r.Position.X,r.Position.Y,r.Position.Z)) else table.insert(out,p[1]..","..p[2].." miss") end end
for d,v in pairs(saved) do d.CanQuery=v end
return table.concat(out,"; ")"""
code = code.replace("CX", ",".join(map(str, c[0]))).replace("LX", ",".join(map(str, c[1]))).replace("PTSX", pts)
json.dump({"studio_id": "8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885", "datamodel_type": "Edit", "code": code}, open("cmd/pick26.json", "w"))
print(subprocess.run(["python", "mcpcli.py", "call", "execute_luau", "cmd/pick26.json"], capture_output=True, text=True, encoding="utf-8").stdout[-4000:].replace("; ", "\n"))
