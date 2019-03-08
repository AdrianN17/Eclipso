local Gamestate = require "libs.hump.gamestate"
local Class = require "libs.hump.class"
local Escenario = require "gamestates.escenario"

local menu=Class{}

function menu:init()
	self.keys={"1","2","3","4","5","6"}
end

function menu:draw()

end

function menu:update(dt)

end

function menu:keypressed(key)
	for i,k in ipairs(self.keys) do 
		if key==k then
			 Gamestate.switch(Escenario(i))
		end
	end
end


return menu
