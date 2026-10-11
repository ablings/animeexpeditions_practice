"""pick.py <cam> x,y [x,y...]: which practice part is under each pixel (ray from the cams_practice camera)"""
import sys, json, subprocess
cam = sys.argv[1]; c = json.load(open("cams_practice.json"))[cam]
pts = "{" + ",".join("{%s}" % a for a in sys.argv[2:]) + "}"
code = """local cam=Vector3.new(CX) local cf=CFrame.lookAt(cam,Vector3.new(LX))
local f=396.5/math.tan(math.rad(35)) local out={}
for _,p in ipairs(PTSX) do local d=cf:VectorToWorldSpace(Vector3.new((p[1]-726)/f,-(p[2]-396.5)/f,-1)).Unit
 local r=workspace:Raycast(cam,d*1000)
 if r then table.insert(out,p[1]..","..p[2].." -> "..r.Instance:GetFullName().." "..r.Instance.Material.Name.." "..tostring(r.Instance.Color).." at "..string.format("%.1f,%.1f,%.1f",r.Position.X,r.Position.Y,r.Position.Z)) else table.insert(out,"miss") end end
return table.concat(out,"; ")"""
code = code.replace("CX", ",".join(map(str, c[0]))).replace("LX", ",".join(map(str, c[1]))).replace("PTSX", pts)
json.dump({"studio_id": "8ce7b1eb-e34e-4233-8e6f-5c0f3cdd6885", "datamodel_type": "Edit", "code": code}, open("cmd/pick20.json", "w"))
print(subprocess.run(["python", "mcpcli.py", "call", "execute_luau", "cmd/pick20.json"], capture_output=True, text=True, encoding="utf-8").stdout[-3000:].replace("; ", "\n"))
