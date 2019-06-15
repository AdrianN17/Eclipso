local Class = require "libs.hump.class"
local gamera = require "libs.gamera.gamera"
local signal = require "libs.hump.signal"
--local timer = require "libs.hump.timer"
local vector = require "libs.hump.vector"
local entidades = require "entidades.entidades_servidor"
local sti = require "libs.sti"

local base = Class{}

function base:init(game,map_name,eleccion,ip,puerto,cantidad,nombre)
	local map= sti("assets/map/" .. map_name .. ".lua")
	--objetos principales
	local scale=1
	local x,y=lg.getDimensions( )

	map:resize(x*2,y*2)
	local cam = gamera.new(0,0,map.width*map.tilewidth, map.height*map.tileheight)
	cam:setWindow(0,0,x,y)

	cam:setScale(1)

	--librerias auxiliares
	local signal=signal
	local vector=vector

	game.entidades=entidades(cam,vector,signal,eleccion,map,ip,puerto,cantidad,nombre,map_name)

end

return base