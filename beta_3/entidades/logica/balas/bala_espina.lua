local Class = require "libs.hump.class"
local molde_bala = require "entidades.logica.modelos.modelo_balas"
local animacion = require "entidades.animacion.balas.molde_balas"

local bala_espina = Class{
  __includes = {molde_bala,animacion}
}

function bala_espina:init(x,y,entidades,radio,creador)
  self.tipo_indice=7
  molde_bala.init(self,x,y,entidades,2800,radio,creador,15)
  animacion.init(self,img.balas,7)
end

return bala_espina