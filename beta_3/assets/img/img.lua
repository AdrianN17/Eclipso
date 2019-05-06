local spritesheet={}

spritesheet.aegis={}

spritesheet.aegis["image"]=love.graphics.newImage("assets/img/Aegis_diseño.png")
spritesheet.aegis[1]=love.graphics.newQuad(0, 14, 145, 118, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[2]=love.graphics.newQuad(234, 7, 144, 118, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[3]=love.graphics.newQuad(554, 1, 144, 131, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[4]=love.graphics.newQuad(761, 1, 145, 131, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[5]=love.graphics.newQuad(1142, 1, 144, 131, spritesheet.aegis["image"]:getDimensions())
spritesheet.aegis[6]=love.graphics.newQuad(1349, 2, 145, 130, spritesheet.aegis["image"]:getDimensions())

spritesheet.aegis.scale=0.7

spritesheet.solange={}


spritesheet.solange["image"]=love.graphics.newImage("assets/img/Solange_diseño.png")
spritesheet.solange[1]=love.graphics.newQuad(0, 2, 176, 114, spritesheet.solange["image"]:getDimensions())
spritesheet.solange[2]=love.graphics.newQuad(237, 0, 176, 116, spritesheet.solange["image"]:getDimensions())
spritesheet.solange[3]=love.graphics.newQuad(497, 3, 175, 121, spritesheet.solange["image"]:getDimensions())
spritesheet.solange[4]=love.graphics.newQuad(773, 3, 175, 123, spritesheet.solange["image"]:getDimensions())
spritesheet.solange[5]=love.graphics.newQuad(1012, 9, 176, 118, spritesheet.solange["image"]:getDimensions())
spritesheet.solange[6]=love.graphics.newQuad(1289, 8, 175, 121, spritesheet.solange["image"]:getDimensions())

spritesheet.solange.scale=0.6

return spritesheet