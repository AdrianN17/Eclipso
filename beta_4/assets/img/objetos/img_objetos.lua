local img_objetos={}

img_objetos["image"]=love.graphics.newImage("assets/img/objetos/cosas_marinas.png")
img_objetos[1]=love.graphics.newQuad(0, 1, 244, 228, img_objetos["image"]:getDimensions())
img_objetos[2]=love.graphics.newQuad(43, 406, 357, 309, img_objetos["image"]:getDimensions())
img_objetos[3]=love.graphics.newQuad(298, 86, 253, 270, img_objetos["image"]:getDimensions())
img_objetos[4]=love.graphics.newQuad(634, 50, 211, 186, img_objetos["image"]:getDimensions())
img_objetos[5]=love.graphics.newQuad(649, 370, 208, 198, img_objetos["image"]:getDimensions())
img_objetos[6]=love.graphics.newQuad(920,203,151,152, img_objetos["image"]:getDimensions())

img_objetos.scale=0.6

return img_objetos