local Class = require "libs.hump.class"
local gamera = require "libs.gamera.gamera"
local signal = require "libs.hump.signal"
local timer = require "libs.hump.timer"
local vector = require "libs.hump.vector"
local entidades = require "entidades.entidades"
local sti = require "libs.sti"

local base = Class{}

function base:init(game,eleccion)
	local map= sti("assets/map/demo.lua")
	--objetos principales

	local scale=1
	local x,y=lg.getDimensions( )

	map:resize(x,y)
	local cam = gamera.new(0,0,map.width*map.tilewidth, map.height*map.tileheight)
	cam:setWindow(0,0,x,y)

	cam:setScale(1)

	--librerias auxiliares
	local timer=timer
	local signal=signal
	local vector=vector

	


	game.entidades=entidades(cam,timer,signal,vector,eleccion,map)

end

return base
