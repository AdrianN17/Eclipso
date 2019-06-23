local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_player"

local animacion = require "entidades.animacion.personajes.Xeon_anima"
--local bala_electrica = require "entidades.logica.balas.bala_electrica"

local Xeon = Class{
  __includes = {modelo,animacion}
}

function Xeon:init(entidades,x,y,creador,nombre)
  self.tipo_indice="xeon"
  self.nombre=nombre
  self.tipo_escudo=3
  
  local area=35
  local hp=1000
  local velocidad=600
  local ira=300
  local tiempo_escudo=0.4
  local puntos_arma={{x=30, y=-40}}
  local puntos_melee=nil
  local mass=30
  local disparo_max_timer=0.2
  local recarga_timer= 2
  local balas_data_1=nil
  local balas_data_2=nil
  
  modelo.init(self,entidades,x,y,creador,area,hp,velocidad,ira,tiempo_escudo,puntos_arma,puntos_melee,mass,disparo_max_timer,recarga_timer,balas_data_1,balas_data_2)
  
  animacion.init(self,img.xeon,img.escudos)
end

return Xeon