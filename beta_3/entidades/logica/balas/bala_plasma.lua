local Class = require "libs.hump.class"
local molde_bala = require "entidades.logica.modelos.modelo_balas"
local animacion = require "entidades.animacion.balas.molde_balas"

local bala_plasma = Class{
  __includes = {molde_bala,animacion}
}

function bala_plasma:init(x,y,entidades,radio,creador)
  self.tipo_indice=5
  molde_bala.init(self,x,y,entidades,1100,radio,creador,75)
  animacion.init(self,img.balas,5)
end

return bala_plasma