local Class= require "libs.hump.class"
local suit=require "libs.suit"

--gamestates 
local configuracion= require "escenas.configuracion"
local crear_lan= require "escenas.crear_lan"
local entrar_lan= require "escenas.entrar_lan"
local entrar_online= require "escenas.entrar_online"

local menu = Class{}

function menu:init()
	--suit.theme.color.normal.fg = {255,255,255}
    --suit.theme.color.hovered = {bg = {200,230,255}, fg = {0,0,0}}
end

function menu:enter()
	self.gui = suit.new()

	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2
end

function menu:draw()
	self.gui:draw()
end

function menu:update(dt)

	if self.gui:Button("Crear Local multiplayer" , {id=1}, self.center.x-200,self.center.y-10
		, 190,60).hit then
		--crear a multiplayer local
		Gamestate.switch(crear_lan)
	end

	if self.gui:Button("Entrar Local multiplayer", {id=2}, self.center.x+10,self.center.y-10
		, 190,60).hit then
		--entrar a multiplayer local
		Gamestate.switch(entrar_lan)
	end


	if self.gui:Button("Online multiplayer", {id=3}, self.center.x-200,self.center.y+75
		, 400,50).hit then
		--mandar a multiplaer online
		Gamestate.switch(entrar_online)

	end


	if self.gui:Button("Configuracion", {id=4}, self.center.x-200,self.center.y+75*2
		, 400,50).hit then
		--mandar a configuracion
		Gamestate.switch(configuracion)

	end

end

return menu