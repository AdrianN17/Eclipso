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
img_personajes.xeon[1][1]=love.graphics.newQuad(0,130,441,224, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[1][2]=love.graphics.newQuad(624,130,441,224, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[1][3]=love.graphics.newQuad(1161,119,441,229, img_personajes.xeon["image"]:getDimensions())

img_personajes.xeon[2]={}
img_personajes.xeon[2][1]=love.graphics.newQuad(1815,0,445,347, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[2][2]=love.graphics.newQuad(2473,0,445,344, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[2][3]=love.graphics.newQuad(3084,0,452,344, img_personajes.xeon["image"]:getDimensions())


img_personajes.xeon[3]={}
img_personajes.xeon[3][1]=love.graphics.newQuad(3735,61,445,281, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[3][2]=love.graphics.newQuad(4329,50,446,280, img_personajes.xeon["image"]:getDimensions())
img_personajes.xeon[3][3]=love.graphics.newQuad(4939,50,452,280, img_personajes.xeon["image"]:getDimensions())


img_personajes.xeon.scale=0.25

img_personajes.radian={}

img_personajes.radian["image"]=love.graphics.newImage("assets/img/personajes/Radian.png")

img_personajes.radian[1]={}
img_personajes.radian[1][1]=love.graphics.newQuad(0,232,390,375, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[1][2]=love.graphics.newQuad(661,232,390,375, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[1][3]=love.graphics.newQuad(1258,232,390,375, img_personajes.radian["image"]:getDimensions())

img_personajes.radian[2]={}
img_personajes.radian[2][1]=love.graphics.newQuad(1902,200,391,376, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[2][2]=love.graphics.newQuad(2467,200,390,376, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[2][3]=love.graphics.newQuad(3041,200,390,376, img_personajes.radian["image"]:getDimensions())

img_personajes.radian[3]={}
img_personajes.radian[3][1]=love.graphics.newQuad(3726,0,390,551, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[3][2]=love.graphics.newQuad(4301,0,390,551, img_personajes.radian["image"]:getDimensions())
img_personajes.radian[3][3]=love.graphics.newQuad(4904,0,390,551, img_personajes.radian["image"]:getDimensions())

img_personajes.radian.scale=0.3

return img_personajes