"""pair.py <ref> <rep> <out> [crop x0,y0,x1,y1]: ref on top, rep below (half scale unless cropped)"""
import sys
from PIL import Image
a=Image.open(sys.argv[1]).convert("RGB"); b=Image.open(sys.argv[2]).convert("RGB")
if len(sys.argv)>4:
    c=tuple(map(int,sys.argv[4].split(","))); a=a.crop(c); b=b.crop(c)
else:
    a=a.resize((a.width//2,a.height//2)); b=b.resize((b.width//2,b.height//2))
o=Image.new("RGB",(a.width,a.height*2+4),(255,0,255)); o.paste(a,(0,0)); o.paste(b,(0,a.height+4)); o.save(sys.argv[3])
