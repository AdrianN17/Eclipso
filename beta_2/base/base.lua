local Class = require "libs.hump.class"
local gamera = require "libs.gamera.gamera"
local signal = require "libs.hump.signal"
local timer = require "libs.hump.timer"
local vector = require "libs.hump.vector"
local entidades = require "entidades.entidades"
local sti = require "libs.sti"

local base = Class{}

function base:init(game,eleccion)
	--objetos principales

	local scale=1
	local x,y=lg.getDimensions( )
	local cam = gamera.new(0,0,2000,2000)
	cam:setWindow(0,0,x,y)

	cam:setScale(1)

	--librerias auxiliares
	local timer=timer
	local signal=signal
	local vector=vector

	local map= sti("assets/map/sinnombre.lua")


	game.entidades=entidades(cam,timer,signal,vector,eleccion,map)

end

return base
