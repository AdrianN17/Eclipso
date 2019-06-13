local Class = require "libs.hump.class"
local molde_bala = require "entidades.logica.modelos.modelo_balas"
local animacion = require "entidades.animacion.balas.molde_balas"

local bala_agua = Class{
  __includes = {molde_bala,animacion}
}

function bala_agua:init(x,y,entidades,radio,creador)
  self.tipo_indice=6
  molde_bala.init(self,x,y,entidades,1200,radio,creador,25)
  animacion.init(self,img.balas,6)
end

return bala_agua