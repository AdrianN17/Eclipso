local img_objetos={}

img_objetos["image"]=love.graphics.newImage("assets/img/objetos/cosas_marinas.png")
img_objetos["estrella"]=love.graphics.newQuad(0, 1, 244, 228, img_objetos["image"]:getDimensions())
img_objetos["arbol"]=love.graphics.newQuad(43, 406, 357, 309, img_objetos["image"]:getDimensions())
img_objetos["roca"]=love.graphics.newQuad(298, 86, 253, 270, img_objetos["image"]:getDimensions())
img_objetos["punto_enemigo"]=love.graphics.newQuad(634, 50, 211, 186, img_objetos["image"]:getDimensions())
img_objetos["punto_inicio"]=love.graphics.newQuad(649, 370, 208, 198, img_objetos["image"]:getDimensions())

img_objetos.scale=0.6

return img_objetos