local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_player"
local animacion = require "entidades.animacion.personajes.Solange_anima"

local Solange = Class{
  __includes = {modelo,animacion}
}

function Solange:init(entidades,x,y,creador)

  
  modelo.init(self,entidades,x,y,creador,35,1000,400,120,0.7,{{x=30, y=-40}},nil,30 )
  animacion.init(self,img.solange,img.escudos)
end



return Solange