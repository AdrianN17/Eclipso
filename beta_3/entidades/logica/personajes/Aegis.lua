local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_player"
local animacion = require "entidades.animacion.personajes.Aegis_anima"


local bala_fuego = require "entidades.logica.balas.bala_fuego"
local bala_hielo = require "entidades.logica.balas.bala_hielo"

local Aegis = Class{
  __includes = {modelo,animacion}
}

function Aegis:init(entidades,x,y,creador,nombre)
  self.tipo_indice="aegis"
  self.nombre=nombre
  self.tipo_escudo=1
  --entidades,x,y,creador,area,hp,velocidad,ira,tiempo_escudo,puntos_arma,puntos_melee,mass,disparo_max_timer,recarga_timer,balas_data_1,balas_data_2
  local area=35
  local hp=1000
  local velocidad=750
  local ira=200
  local tiempo_escudo=0.5
  local puntos_arma={{x=30, y=42},{x=30, y=-42}}
  local puntos_melee=nil
  local mass=30
  local disparo_max_timer=0.35
  local recarga_timer= 1
  local balas_data_1={bala=bala_hielo , balas_max=5 }
  local balas_data_2={bala=bala_fuego , balas_max=8}
  
  modelo.init(self,entidades,x,y,creador,area,hp,velocidad,ira,tiempo_escudo,puntos_arma,puntos_melee,mass,disparo_max_timer,recarga_timer,balas_data_1,balas_data_2)
  animacion.init(self,img.aegis,img.escudos)
end



return Aegis