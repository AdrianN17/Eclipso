local img_personajes ={}

img_personajes.aegis={}

img_personajes.aegis["image"]=love.graphics.newImage("assets/img/personajes/Aegis.png")

img_personajes.aegis[1]={}
img_personajes.aegis[1][1]=love.graphics.newQuad(0, 14, 145, 118, img_personajes.aegis["image"]:getDimensions())
img_personajes.aegis[1][2]=love.graphics.newQuad(554, 1, 144, 131, img_personajes.aegis["image"]:getDimensions())
img_personajes.aegis[1][3]=love.graphics.newQuad(761, 1, 145, 131, img_personajes.aegis["image"]:getDimensions())

img_personajes.aegis[2]={}
img_personajes.aegis[2][1]=love.graphics.newQuad(234, 7, 144, 118, img_personajes.aegis["image"]:getDimensions())
img_personajes.aegis[2][2]=love.graphics.newQuad(1142, 1, 144, 131, img_personajes.aegis["image"]:getDimensions())
img_personajes.aegis[2][3]=love.graphics.newQuad(1349, 2, 145, 130, img_personajes.aegis["image"]:getDimensions())


img_personajes.aegis.scale=0.7

img_personajes.solange={}

img_personajes.solange["image"]=love.graphics.newImage("assets/img/personajes/Solange.png")

img_personajes.solange[1]={}
img_personajes.solange[1][1]=love.graphics.newQuad(0, 2, 176, 114, img_personajes.solange["image"]:getDimensions())
img_personajes.solange[1][2]=love.graphics.newQuad(497, 3, 175, 121, img_personajes.solange["image"]:getDimensions())
img_personajes.solange[1][3]=love.graphics.newQuad(773, 3, 175, 123, img_personajes.solange["image"]:getDimensions())


img_personajes.solange[2]={}
img_personajes.solange[2][1]=love.graphics.newQuad(237, 0, 176, 116, img_personajes.solange["image"]:getDimensions())
img_personajes.solange[2][2]=love.graphics.newQuad(1012, 9, 176, 118, img_personajes.solange["image"]:getDimensions())
img_personajes.solange[2][3]=love.graphics.newQuad(1289, 8, 175, 121, img_personajes.solange["image"]:getDimensions())


img_personajes.solange.scale=0.6

img_personajes.xeon={}

img_personajes.xeon["image"]=love.graphics.newImage("assets/img/personajes/Xeon.png")

img_personajes.xeon[1]={}
img_personajes.xeon[1][1]=love.graphics.newQuad(0,244,441,224, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[1][2]=love.graphics.newQuad(624,244,441,224, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[1][3]=love.graphics.newQuad(1161,233,441,229, img_personajes.xeon["image"]:getDimensions())

img_personajes.xeon[2]={}
img_personajes.xeon[2][1]=love.graphics.newQuad(1815,196,445,265, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[2][2]=love.graphics.newQuad(2473,194,445,264, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[2][3]=love.graphics.newQuad(3085,194,451,264, img_personajes.xeon["image"]:getDimensions())


img_personajes.xeon[3]={}
img_personajes.xeon[3][1]=love.graphics.newQuad(3735,175,445,281, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[3][2]=love.graphics.newQuad(4329,164,446,280, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[3][3]=love.graphics.newQuad(4939,164,452,280, img_personajes.xeon["image"]:getDimensions())

img_personajes.xeon["melee"]=love.graphics.newQuad(5722,0,55,439, img_personajes.xeon["image"]:getDimensions())


img_personajes.xeon.scale=0.25

img_personajes.radian={}

img_personajes.radian["image"]=love.graphics.newImage("assets/img/personajes/Radian.png")

img_personajes.radian[1]={}
img_personajes.radian[1][1]=love.graphics.newQuad(0,192,390,375, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[1][2]=love.graphics.newQuad(661,195,390,375, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[1][3]=love.graphics.newQuad(1258,195,390,375, img_personajes.radian["image"]:getDimensions())

img_personajes.radian[2]={}
img_personajes.radian[2][1]=love.graphics.newQuad(1902,163,391,376, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[2][2]=love.graphics.newQuad(2467,163,390,376, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[2][3]=love.graphics.newQuad(3041,163,390,376, img_personajes.radian["image"]:getDimensions())

img_personajes.radian[3]={}
img_personajes.radian[3][1]=love.graphics.newQuad(3726,138,390,376, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[3][2]=love.graphics.newQuad(4301,138,390,376, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[3][3]=love.graphics.newQuad(4904,138,390,376, img_personajes.radian["image"]:getDimensions())

img_personajes.radian["melee"]=love.graphics.newQuad(5588,1,89,336, img_personajes.radian["image"]:getDimensions())

img_personajes.radian.scale=0.3

return img_personajes