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

  local creador=10
  local hp=200
  local velocidad=380
  local ira=100
  local mass=50
  local puntos_arma={{x=0,y=-75}}
  local puntos_melee=nil
  local puntos_rango={x=0,y=-175,r=150,max_acercamiento=60}
  local objeto_balas={bala=bala_agua,tiempo=0.5,max_stock=7,stock=7}
  local tiempo_max_recarga=1.5
  local rastreo_paredes=130
  local dano_melee=0

--entidades,x,y,creador,hp,velocidad,ira,polygon,mass,puntos_arma,puntos_melee,puntos_rango,objeto_balas,tiempo_max_recarga,rastreo_paredes,dano_melee
  
  modelo.init(self,entidades,x,y,creador,hp,velocidad,ira,polygon,mass,puntos_arma,puntos_melee,puntos_rango,objeto_balas,tiempo_max_recarga,rastreo_paredes,dano_melee)
  animacion.init(self,img.enemigos_marinos,"muymuy")
end

return Muymuy