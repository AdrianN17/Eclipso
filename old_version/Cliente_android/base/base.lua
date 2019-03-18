local Class = require "libs.hump.class"
local sti = require "libs.sti"
local gamera = require "libs.gamera.gamera"
local signal = require "libs.hump.signal"
local entidad = require "entidades.entidad"

local base = Class{}

function base:init(escenario,nombre_mapa,eleccion)
	--objetos principales

	local scale=1
	
	local cam = gamera.new(0,0,2000,2000)
	--cam:setWindow(0,0,800,600)

	cam:setScale(2.0)

	--[[local map=sti(nombre_mapa)
	map:resize(lg.getWidth(),lg.getHeight())]]
	map=nil

	--librerias auxiliares
	local timer=timer
	local signal=signal

	escenario.entidades=entidad(cam,map,timer,signal,eleccion)

end

return base