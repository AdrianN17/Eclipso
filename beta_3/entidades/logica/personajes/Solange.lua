local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_player"

local animacion = require "entidades.animacion.personajes.Solange_anima"
local bala_electrica = require "entidades.logica.balas.bala_electrica"

local Solange = Class{
  __includes = {modelo,animacion}
}

function Solange:init(entidades,x,y,creador,nombre)
  self.tipo_indice="solange"
  self.nombre=nombre
  self.tipo_escudo=2
  
  local area=35
  local hp=1000
  local velocidad=700
  local ira=120
  local tiempo_escudo=0.7
  local puntos_arma={{x=30, y=-40}}
  local puntos_melee=nil
  local mass=30
  local disparo_max_timer=0.2
  local recarga_timer= 1.5
  local balas_data_1={bala=bala_electrica,balas_max=10}
  local balas_data_2=nil
  
  modelo.init(self,entidades,x,y,creador,area,hp,velocidad,ira,tiempo_escudo,puntos_arma,puntos_melee,mass,disparo_max_timer,recarga_timer,balas_data_1,balas_data_2)
  
  animacion.init(self,img.solange,img.escudos)
end



return Solange