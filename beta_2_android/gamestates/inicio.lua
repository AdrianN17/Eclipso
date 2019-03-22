local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Menu = require "gamestates.menu"

local inicio= Class{}

function inicio:init()
	self.x,self.y=lg.getDimensions( )

	self.timer=0
	self.vista=true
end

function inicio:draw()
	lg.printf("Hypernova",self.x/2-100,self.y/2,100,"center")

	if self.vista then
		lg.printf("Jugar",self.x/2-100,self.y/2+100,100,"center")
	end
end

function inicio:update(dt)
	self.timer=self.timer+dt

	if self.timer>1 then
		self.vista=not self.vista
		self.timer=0
	end
end

function inicio:mousepressed(x,y,button)
	Gamestate.switch(Menu)
end

function inicio:touchpressed(id, x, y, dx, dy, pressure)
	Gamestate.switch(Menu)
end

return inicio