local img_balas={}

img_balas["image"]=love.graphics.newImage("assets/img/balas/balas.png")
--jugadores
img_balas["fuego"]=love.graphics.newQuad(0, 1, 54, 54, img_balas["image"]:getDimensions())
img_balas["hielo"]=love.graphics.newQuad(64, 0, 54, 54, img_balas["image"]:getDimensions())
img_balas["electricidad"]=love.graphics.newQuad(122, 0, 54, 54, img_balas["image"]:getDimensions())
img_balas["plasma"]=love.graphics.newQuad(182, 0, 54, 54, img_balas["image"]:getDimensions())
img_balas["ectoplasma"]=love.graphics.newQuad(239, 0, 53, 53, img_balas["image"]:getDimensions())
img_balas["espinas"]=love.graphics.newQuad(64, 62, 51, 51, img_balas["image"]:getDimensions())

--enemigos
img_balas["pulso"]=love.graphics.newQuad(4, 68, 53, 52, img_balas["image"]:getDimensions())

img_balas.scale=0.25

return img_balas