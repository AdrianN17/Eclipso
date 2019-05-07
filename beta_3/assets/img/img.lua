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

spritesheet.escudos={}

spritesheet.escudos["image"]=love.graphics.newImage("assets/img/escudos.png")
spritesheet.escudos[1]=love.graphics.newQuad(0, 342, 285, 285, spritesheet.escudos["image"]:getDimensions())
spritesheet.escudos[2]=love.graphics.newQuad(0, 0, 285, 285, spritesheet.escudos["image"]:getDimensions())
spritesheet.escudos.scale=0.6

spritesheet.objetos={}

spritesheet.objetos["image"]=love.graphics.newImage("assets/img/cosas_marinas.png")
spritesheet.objetos[1]=love.graphics.newQuad(0, 1, 244, 228, spritesheet.objetos["image"]:getDimensions())
spritesheet.objetos[2]=love.graphics.newQuad(43, 406, 357, 309, spritesheet.objetos["image"]:getDimensions())
spritesheet.objetos[3]=love.graphics.newQuad(298, 86, 253, 270, spritesheet.objetos["image"]:getDimensions())
spritesheet.objetos[4]=love.graphics.newQuad(634, 50, 211, 186, spritesheet.objetos["image"]:getDimensions())
spritesheet.objetos[5]=love.graphics.newQuad(649, 370, 208, 198, spritesheet.objetos["image"]:getDimensions())

spritesheet.objetos.scale=0.6


return spritesheet