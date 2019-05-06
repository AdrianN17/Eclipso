local spritesheet={}

spritesheet.aegis={}

spritesheet.aegis["image"]=love.graphics.newImage("assets/img/Aegis_diseño.png")
spritesheet.aegis[1]=love.graphics.newQuad(0, 0, 145, 118, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[2]=love.graphics.newQuad(394, 12,144, 132, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[3]=love.graphics.newQuad(601, 13, 145, 131, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[4]=love.graphics.newQuad(982, 57, 144, 132, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[5]=love.graphics.newQuad(1189, 58, 145, 131, spritesheet.aegis["image"]:getDimensions())

spritesheet.solange={}

return spritesheet