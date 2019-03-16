local Gamestate = require "libs.hump.gamestate"
local Class = require "libs.hump.class"
local Escenario = require "gamestates.escenario"

local menu=Class{}

function menu:init()
	self.i=1

	self.x,self.y=0,0

	local x,y=love.graphics.getDimensions( )
	self.mandos={{mx=35,my=50,mw=35,mh=35},{mx=x-70,my=50,mw=35,mh=35},{mx=10,my=y-100,mw=(x-20),mh=35}}
end

function menu:draw()
	--lg.print(self.i .. " , " .. self.x .. " , " .. self.y,10,10)
	--local x,y=love.graphics.getDimensions( )
	--lg.print(x .. " , " .. y,10,40)

	for _, btn in pairs(self.mandos) do
   		love.graphics.rectangle("fill",btn.mx,btn.my,btn.mw,btn.mh)
    end


end

function menu:update(dt)

end

function menu:collides(table,x,y)
	if x> table.mx and x<table.mx+table.mw and y>table.my and y<table.my+table.mh then
		return true
	end
end


function menu:touchpressed(id, x, y, dx, dy, pressure )
	if self:collides(self.mandos[1],x,y) then
		self.i=self.i+1
		if self.i>6 then
			self.i=1
		end
	elseif self:collides(self.mandos[2],x,y) then
		self.i=self.i-1
		if self.i<1 then
			self.i=6
		end
	elseif self:collides(self.mandos[3],x,y) then
		Gamestate.switch(Escenario(self.i))
	end
end

return menu
