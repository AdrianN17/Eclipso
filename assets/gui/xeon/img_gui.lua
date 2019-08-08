local img_gui={}

img_gui["img_corazon"] = love.graphics.newImage("assets/gui/xeon/corazon.png")

img_gui.corazon={}

img_gui.corazon["vivo"]=love.graphics.newQuad(0, 0, 201, 202, img_gui["img_corazon"]:getDimensions())
img_gui.corazon["muerto"]=love.graphics.newQuad(259, 1, 200, 200, img_gui["img_corazon"]:getDimensions())

img_gui.corazon.scale=0.4

img_gui.bala={}
img_gui.bala[1]="Espinas"

return img_gui