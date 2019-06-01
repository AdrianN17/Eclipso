local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_enemigo"
local animacion = require "entidades.animacion.enemigos.muymuy_anima"

local Muymuy = Class {
  __includes = {modelo , animacion}
}

function Muymuy:init(entidades,x,y)
  local polygon={-1 , -68,
31 , -38,
26 , 15,
-1 , 34,
-28 , 13,
-32 , -38}
  
  modelo.init(self,entidades,x,y,10,200,380,100,polygon,50,{{x=0,y=-75}},nil,{x=0,y=-100,r=100,max_acercamiento=80})
  animacion.init(self,img.enemigos_marinos,"muymuy")
end

return Muymuy