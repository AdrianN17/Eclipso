local Class = require "libs.hump.class"
local molde_bala = require "entidades.logica.modelos.modelo_balas"
local animacion = require "entidades.animacion.balas.molde_balas"

local bala_fuego = Class{
  __includes = {molde_bala,animacion}
}

function bala_fuego:init(x,y,entidades,radio,creador)
  molde_bala.init(self,x,y,entidades,500,radio,creador)
  animacion.init(self,img.balas,1)
end

return bala_fuego