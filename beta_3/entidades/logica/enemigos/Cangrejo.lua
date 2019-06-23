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

  local creador=10
  local hp=500
  local velocidad=650
  local ira=200
  local mass=85
  local puntos_arma=nil
  local puntos_melee={{x=-30,y=-50,r=30},{x=30,y=-50,r=30}}
  local puntos_rango={x=0,y=-175,r=150,max_acercamiento=30}
  local objeto_balas=nil
  local tiempo_max_recarga=0
  local rastreo_paredes=150
  local dano_melee=50

  --entidades,x,y,creador,hp,velocidad,ira,polygon,mass,puntos_arma,puntos_melee,puntos_rango,objeto_balas,tiempo_max_recarga
  
  modelo.init(self,entidades,x,y,creador,hp,velocidad,ira,polygon,mass,puntos_arma,puntos_melee,puntos_rango,objeto_balas,tiempo_max_recarga,rastreo_paredes,dano_melee)
  animacion.init(self,img.enemigos_marinos,"cangrejo")
end

return Cangrejo