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

spritesheet.balas={}
spritesheet.balas["image"]=love.graphics.newImage("assets/img/balas.png")

--jugadores
spritesheet.balas[1]=love.graphics.newQuad(0, 1, 54, 54, spritesheet.balas["image"]:getDimensions())
spritesheet.balas[2]=love.graphics.newQuad(64, 0, 54, 54, spritesheet.balas["image"]:getDimensions())
spritesheet.balas[3]=love.graphics.newQuad(122, 0, 54, 54, spritesheet.balas["image"]:getDimensions())
spritesheet.balas[4]=love.graphics.newQuad(182, 0, 54, 54, spritesheet.balas["image"]:getDimensions())
spritesheet.balas[5]=love.graphics.newQuad(239, 0, 53, 53, spritesheet.balas["image"]:getDimensions())

--enemigos
spritesheet.balas[6]=love.graphics.newQuad(4, 68, 53, 52, spritesheet.balas["image"]:getDimensions())

spritesheet.balas.scale=0.25

spritesheet.enemigos_marinos={}
spritesheet.enemigos_marinos["image"]=love.graphics.newImage("assets/img/animales_marinos.png")
spritesheet.enemigos_marinos.muymuy={}
spritesheet.enemigos_marinos.muymuy[1]=love.graphics.newQuad(0, 0, 142, 313, spritesheet.enemigos_marinos["image"]:getDimensions())

spritesheet.enemigos_marinos.cangrejo={}
spritesheet.enemigos_marinos.cangrejo[1]=love.graphics.newQuad(525, 26, 350, 286, spritesheet.enemigos_marinos["image"]:getDimensions())
spritesheet.enemigos_marinos.cangrejo[2]=love.graphics.newQuad(1079, 0, 349, 291, spritesheet.enemigos_marinos["image"]:getDimensions())

spritesheet.enemigos_marinos.cangrejo.scale=0.5

spritesheet.enemigos_marinos.muymuy.scale=0.5



return spritesheet