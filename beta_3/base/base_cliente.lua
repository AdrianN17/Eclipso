local Class = require "libs.hump.class"
local gamera = require "libs.gamera.gamera"
local entidades = require "entidades.entidades_cliente"
local sti = require "libs.sti"

local base_cliente = Class{}

function base_cliente:init(game,map_name,eleccion,ip,puerto,nombre)
  local map= sti("assets/map/" .. map_name .. ".lua")
	--objetos principales
	local scale=1
	local x,y=lg.getDimensions( )

	map:resize(x*2,y*2)
	local cam = gamera.new(0,0,map.width*map.tilewidth, map.height*map.tileheight)
	cam:setWindow(0,0,x,y)

	cam:setScale(1)
  
  local signal=signal
	local vector=vector

	game.entidades=entidades(cam,vector,signal,eleccion,map,ip,puerto,nombre)
end

return base_cliente