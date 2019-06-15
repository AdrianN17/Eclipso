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
  --entidades,x,y,creador,area,hp,velocidad,ira,tiempo_escudo,puntos_arma,puntos_melee,mass,disparo_max_timer,recarga_timer,balas_data_1,balas_data_2
  modelo.init(self,entidades,x,y,creador,35,1000,750,200,0.5,{{x=30, y=42},{x=30, y=-42}},nil,30 ,0.35, 1,{bala=bala_hielo , balas_max=5 },
    {bala=bala_fuego , balas_max=8} )
  animacion.init(self,img.aegis,img.escudos)
end



return Aegis