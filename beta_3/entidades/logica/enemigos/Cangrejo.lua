local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_enemigo"
local animacion = require "entidades.animacion.enemigos.cangrejo_anima"

local Cangrejo = Class {
  __includes = {modelo , animacion}
}

function Cangrejo:init(entidades,x,y)
  self.tipo_indice="cangrejo"
  self.tipo_area="enemigos_marinos"
  
  local polygon={-65 , 12,
-25 , 56,
26 , 56,
66 , 15,
42 , -16,
-46 , -14}

self.rx_len,self.ry_len=0,0

  --entidades,x,y,creador,hp,velocidad,ira,polygon,mass,puntos_arma,puntos_melee,puntos_rango,objeto_balas,tiempo_max_recarga
  
  modelo.init(self,entidades,x,y,10,500,650,200,polygon,85,nil,{{x=-30,y=-50,r=30},{x=30,y=-50,r=30}},{x=0,y=-175,r=150,max_acercamiento=30},nil,0,150,50)
  animacion.init(self,img.enemigos_marinos,"cangrejo")
end

return Cangrejo