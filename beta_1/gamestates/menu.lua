local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"

local Escenario = require "gamestates.escenarios"
local Conexion = require "gamestates.conexion"

local game = require "gamestates.juego_servidor"

require "libs.extra.extras"

local Menu= Class{}

function Menu:init()
	self.x,self.y=lg.getDimensions( )

	self.boton=lg.newImage("assets/gui/menu/boton.png")
	self.w,self.h=self.boton:getDimensions()

	self.colliders={
		{x=(self.x/2)-self.w,	y=(self.y/2)-100,	w=self.w, h=self.h, tipo= game},
		{x=(self.x/2)-self.w,	y=(self.y/2),		w=self.w, h=self.h, tipo= Conexion}
		--{x=(self.x/2)-self.w,	y=(self.y/2)+100,	w=self.w, h=self.h}
		--{x=(self.x/2)-self.w,	y=(self.y/2)+200,	w=self.w, h=self.h}
	}
end

function Menu:draw()
	lg.printf("Menu",100,50,50,"center")
	lg.draw(self.boton,(self.x/2)-self.w,(self.y/2)-100)
	lg.draw(self.boton,(self.x/2)-self.w,(self.y/2))
	--lg.draw(self.boton,(self.x/2)-self.w,(self.y/2)+100)
	--lg.draw(self.boton,(self.x/2)-self.w,(self.y/2)+200)
end

function Menu:update(dt)
	
end

function Menu:mousepressed(x,y,button)
	for _, botones in ipairs(self.colliders) do
		if collides(botones,x,y) then
			Gamestate.switch(botones.tipo)
		end
	end
end

function Menu:touchpressed(id, x, y, dx, dy, pressure)
	for _, botones in ipairs(self.colliders) do
		if collides(botones,x,y) then
			Gamestate.switch(botones.tipo)
		end
	end
end



return Menu