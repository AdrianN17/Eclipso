local img_enemigos = {}

img_enemigos.enemigos_marinos={}
img_enemigos.enemigos_marinos["image"]=love.graphics.newImage("assets/img/enemigos/animales_marinos.png")
img_enemigos.enemigos_marinos.muymuy={}
img_enemigos.enemigos_marinos.muymuy[1]=love.graphics.newQuad(0, 0, 142, 313, img_enemigos.enemigos_marinos["image"]:getDimensions())

img_enemigos.enemigos_marinos.cangrejo={}
img_enemigos.enemigos_marinos.cangrejo[1]=love.graphics.newQuad(525, 26, 350, 286, img_enemigos.enemigos_marinos["image"]:getDimensions())
img_enemigos.enemigos_marinos.cangrejo[2]=love.graphics.newQuad(1079, 0, 349, 291, img_enemigos.enemigos_marinos["image"]:getDimensions())

img_enemigos.enemigos_marinos.cangrejo.scale=0.5

img_enemigos.enemigos_marinos.muymuy.scale=0.5

return img_enemigos