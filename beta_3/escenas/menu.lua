local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local suit = require 'libs.suit'
local game = require "escenas.game"

local Menu= Class{}

local x,y=0,0

function Menu:init()
  x,y=lg.getDimensions( )
  _G.personaje_elegido=1
end

function Menu:draw()
  suit.draw()
end

function Menu:update(dt)
  if suit.Button("Iniciar", 100,100, 300,30).hit then
    Gamestate.switch(game)
  end
  
  if suit.Button("Personajes", 100,300, 100,100).hit then
    if _G.personaje_elegido<2 then
      _G.personaje_elegido=_G.personaje_elegido+1
    else
      _G.personaje_elegido=1
    end
  end
  
  suit.Label("Personaje elegido : " .. _G.personaje_elegido, 100,400,200,100)
  
  
  
end

function Menu:mousepressed()
  
end

return Menu