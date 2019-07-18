local img_escudos={}

img_escudos["image"]=love.graphics.newImage("assets/img/escudos/escudos.png")
img_escudos["magnetico"]=love.graphics.newQuad(0, 342, 285, 285, img_escudos["image"]:getDimensions())
img_escudos["plasma"]=love.graphics.newQuad(0, 0, 285, 285, img_escudos["image"]:getDimensions())
img_escudos["solar"]=love.graphics.newQuad(621, 342, 285, 285, img_escudos["image"]:getDimensions())
img_escudos["espinas"]=love.graphics.newQuad(621, 0, 285, 285, img_escudos["image"]:getDimensions())
img_escudos.scale=0.6


return img_escudos