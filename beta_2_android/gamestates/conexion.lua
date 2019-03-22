local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local Personajes = require "gamestates.personajes"

local utf8 = require "utf8"

local conexion=Class{}

function conexion:init()
	_G.detalles.type="Cliente"
	self.x,self.y=lg.getDimensions( )

	self.boton=lg.newImage("assets/gui/menu/boton.png")
	self.w,self.h=self.boton:getDimensions()

	self.colliders={
		{x=(self.x/2)-self.w/2,	y=self.y-100,	w=self.w, h=self.h},
	}

	self.text=""

	self.cadena_admitida={"1","2","3","4","5","6","7","8","9","0","."}

	if _G.detalles.dispositivo=="Android" then
		love.keyboard.setTextInput( true, (self.x/2)-50, (self.y/2)-100, 100, 100 )
	end
end

function conexion:draw()
	lg.print("IP del servidor " , self.x/2,10)
	lg.printf(self.text, self.x/2, (self.y/2)-50, self.x)
	for _, botones in ipairs(self.colliders) do
		lg.draw(self.boton,botones.x,botones.y)
	end
end

function conexion:update(dt)

end

function conexion:mousepressed(x,y,button)
	for _, botones in ipairs(self.colliders) do
		if collides(botones,x,y) then
			_G.detalles.ip=self.text
			Gamestate.switch(Personajes)
		else
			local byteoffset = utf8.offset(self.text, -1)
	 
	        if byteoffset then
	            self.text = string.sub(self.text, 1, byteoffset - 1)
	        end
		end
	end
end

function conexion:touchpressed(id, x, y, dx, dy, pressure)
	for _, botones in ipairs(self.colliders) do
		if collides(botones,x,y) then
			_G.detalles.ip=self.text
			Gamestate.switch(Personajes)
		else
	        local byteoffset = utf8.offset(self.text, -1)
	 
	        if byteoffset then
	            self.text = string.sub(self.text, 1, byteoffset - 1)
	        end
		end
	end
end

function conexion:textinput(t)
	for _,cadena in ipairs(self.cadena_admitida) do
		if t==cadena then
	    	self.text = self.text .. t
	    end
	end
end


return conexion