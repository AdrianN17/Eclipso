local Class = require "libs.hump.class"
local gamera = require "libs.gamera.gamera"
local entidades = require "entidades.entidades_cliente"

local base_cliente = Class{}

function base_cliente:init(game,eleccion,ip,puerto,nombre)
	--objetos principales
	local scale=1
	local x,y=lg.getDimensions( )

	local cam = gamera.new(0,0,1000,1000)
	cam:setWindow(0,0,x,y)

	cam:setScale(1)
  
  local signal=signal
	local vector=vector

	game.entidades=entidades(cam,vector,signal,eleccion,ip,puerto,nombre)
end

return base_cliente