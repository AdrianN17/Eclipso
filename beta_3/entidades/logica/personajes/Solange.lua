local Class = require "libs.hump.class"
local modelo = require "entidades.logica.modelos.modelo_player"

local animacion = require "entidades.animacion.personajes.Solange_anima"
local bala_electrica = require "entidades.logica.balas.bala_electrica"

local Solange = Class{
  __includes = {modelo,animacion}
}

function Solange:init(entidades,x,y,creador)
  self.tipo_indice="solange"
  
  modelo.init(self,entidades,x,y,creador,35,1000,700,120,0.7,{{x=30, y=-40}},nil,30,0.2 , 1.5, {bala=bala_electrica,balas_max=10} )
  animacion.init(self,img.solange,img.escudos)
end



return Solange