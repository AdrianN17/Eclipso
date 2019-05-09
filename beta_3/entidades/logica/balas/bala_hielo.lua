local Class = require "libs.hump.class"
local molde_bala = require "entidades.logica.modelos.modelo_balas"
local animacion = require "entidades.animacion.balas.molde_balas"

local bala_hielo = Class{
  __includes = {molde_bala,animacion}
}

function bala_hielo:init(x,y,entidades,radio,creador)
  molde_bala.init(self,x,y,entidades,1500,radio,creador)
  animacion.init(self,img.balas,2)
end

return bala_hielo