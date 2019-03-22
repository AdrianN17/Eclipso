local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
require "libs.extra.extras"
local Juego_servidor = require "gamestates.juego_servidor"
local Juego_cliente = require "gamestates.juego_cliente"

local personajes=Class{}


function personajes:init()


	self.i=1

	self.x,self.y=lg.getDimensions( )

	self.boton=lg.newImage("assets/gui/menu/boton.png")
	self.w,self.h=self.boton:getDimensions()

	self.colliders={
		{x=(self.x/2)-self.w/2,	y=self.y-100,	w=self.w, h=self.h},
	}
end

function personajes:enter()
end

function personajes:draw( )
	lg.print(self.i,self.x/2,10)
	lg.print(_G.detalles.type,self.x/2,40)


	for _, botones in ipairs(self.colliders) do
		lg.draw(self.boton,botones.x,botones.y)
		lg.rectangle("line",botones.x,botones.y,botones.w,botones.h)
	end
end

function personajes:update(dt)

end

function personajes:mousepressed(x,y,button)
	for _, botones in ipairs(self.colliders) do
		if collides(botones,x,y) then

			self.i=self.i+1

			if self.i>6 then
				self.i=1
			end
		else
			if _G.detalles.type=="Servidor" then
				_G.detalles.personaje=self.i
				Gamestate.switch(Juego_servidor)
			elseif _G.detalles.type=="Cliente" then
				_G.detalles.personaje=self.i
				Gamestate.switch(Juego_cliente)
			end
		end
	end
end

function personajes:touchpressed(id, x, y, dx, dy, pressure)
	
		if collides(self.colliders[1],x,y) then

			self.i=self.i+1

			if self.i>6 then
				self.i=1
			end
		else
			if _G.detalles.type=="Servidor" then
				_G.detalles.personaje=self.i
				Gamestate.switch(Juego_servidor)
			elseif _G.detalles.type=="Cliente" then
				_G.detalles.personaje=self.i
				Gamestate.switch(Juego_cliente)
			end
		end

end




return personajes