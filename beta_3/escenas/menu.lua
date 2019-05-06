local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"
local suit = require 'libs.suit'
local game = require "escenas.game"

local Menu= Class{}

local x,y=0,0

function Menu:init()
  x,y=lg.getDimensions( )

end

function Menu:draw()
  suit.draw()
end

function Menu:update(dt)
  if suit.Button("Iniciar", 100,100, 300,30).hit then
    Gamestate.switch(game)
  end
  
end

function Menu:mousepressed()
  
end

return Menu