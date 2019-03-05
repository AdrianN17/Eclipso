local Class = require "libs.hump.class"
local HC = require "libs.HC"
local sti = require "libs.sti"
local gamera = require "libs.gamera.gamera"
local signal = require "libs.hump.signal"
local timer = require "libs.hump.timer"
local vector = require "libs.hump.vector"
local entidad = require "entidades.entidad"

local base = Class{}

function base:init(escenario,nombre_mapa)
	--objetos principales
	local collider=HC.new()

	local scale=1
	
	local cam = gamera.new(0,0,2000,2000)
	--cam:setWindow(0,0,800,600)

	cam:setScale(2.0)

	local map=sti(nombre_mapa)
	map:resize(lg.getWidth(),lg.getHeight())

	--librerias auxiliares
	local timer=timer
	local signal=signal
	local vector=vector

	escenario.entidades=entidad(collider,cam,map,timer,signal,vector)

end

return base