local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_enemigo"
local animacion = require "entidades.animacion.enemigos.muymuy_anima"
local bala_agua= require "entidades.logica.balas.bala_agua"

local Muymuy = Class {
  __includes = {modelo , animacion}
}

function Muymuy:init(entidades,x,y)
  self.tipo_indice="muymuy"
  self.tipo_area="enemigos_marinos"
  
  local polygon={-1 , -68,
31 , -38,
26 , 15,
-1 , 34,
-28 , 13,
-32 , -38}

self.rx_len,self.ry_len=0,0
  
  modelo.init(self,entidades,x,y,10,200,380,100,polygon,50,{{x=0,y=-75}},nil,{x=0,y=-175,r=150,max_acercamiento=60},
    {bala=bala_agua,tiempo=0.5,max_stock=7,stock=7},1.5,130,0)
  animacion.init(self,img.enemigos_marinos,"muymuy")
end

return Muymuy