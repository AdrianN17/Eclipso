local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_player"
local animacion = require "entidades.animacion.molde_animacion"

local Aegis = Class{
  __includes = {modelo,animacion}
}

function Aegis:init(entidades,x,y,creador)

  
  modelo.init(self,entidades,x,y,creador,35,1000,400,200,0.5,{{x=25, y=50},{x=25, y=-50}},nil,30 )
  animacion.init(self,img.aegis)
end



return Aegis