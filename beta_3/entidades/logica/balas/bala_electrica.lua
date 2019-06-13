local Class = require "libs.hump.class"
local molde_bala = require "entidades.logica.modelos.modelo_balas"
local animacion = require "entidades.animacion.balas.molde_balas"

local bala_electrica = Class{
  __includes = {molde_bala,animacion}
}

function bala_electrica:init(x,y,entidades,radio,creador)
  self.tipo_indice=3
  molde_bala.init(self,x,y,entidades,2000,radio,creador,25)
  animacion.init(self,img.balas,3)
end

return bala_electrica