local Gamestate = require "libs.hump.gamestate"
local Inicio = require "gamestates.inicio"



function love.load()

	--inicio

	local font=love.graphics.newImageFont("assets/font/Imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")

	_G.lg=love.graphics
	_G.lm=love.math
	_G.font = font
	_G.py=love.physics
	_G.detalles={personaje=0,ip="*",port=22122,type=""}


	Gamestate.registerEvents()
    Gamestate.switch(Inicio)
end

--agregar deteccion de colisiones a los enemigos
--agregar daño a los objetos como roca y pared
--utilizar raycast para la deteccion de los enemigos, deteccion de colisones, utilizando una posicion inicial de balas.
--este lo seguira y si un objeto ingresa en la vision 

--last entropy