local img_gui={}

img_gui["img_corazon"] = love.graphics.newImage("assets/gui/aegis/corazon.png")

img_gui.corazon={}

img_gui.corazon["vivo"]=love.graphics.newQuad(0, 0, 168, 140, img_gui["img_corazon"]:getDimensions())
img_gui.corazon["muerto"]=love.graphics.newQuad(227, 7, 168, 140, img_gui["img_corazon"]:getDimensions())

img_gui.corazon.scale=0.5

img_gui.bala={}
img_gui.bala[1]="Hielo"
img_gui.bala[2]="Fuego"

return img_gui
