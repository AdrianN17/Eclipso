local Class= require "libs.hump.class"
local suit=require "libs.suit"

--gamestates 
local configuracion= require "escenas.configuracion"
local seleccion= require "escenas.seleccion"

local menu = Class{}

function menu:init( )
	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2

	suit.theme.color.normal.fg = {255,255,255}
    suit.theme.color.hovered = {bg = {200,230,255}, fg = {0,0,0}}
end

function menu:draw()
	suit.draw()
end

function menu:update(dt)

	if suit.Button("Jugar local multiplayer", self.center.x-150,self.center.y
		, 300,50).hit then
		--mandar a multiplayer local
		Gamestate.switch(seleccion)


	end

	if suit.Button("Jugar online multiplayer", self.center.x-150,self.center.y+75
		, 300,50).hit then
		--mandar a multiplaer online

	end


	if suit.Button("Configuracion", self.center.x-150,self.center.y+75*2
		, 300,50).hit then
		--mandar a configuracion
		Gamestate.switch(configuracion)

	end
end

return menu