local Class= require "libs.hump.class"
local polybool = require "libs.polygon.polybool"
local delete = require "entidades.funciones.delete"
local funciones = require "entidades.destruible.funciones_destruible"

local arrecife = Class{
	__includes = {delete}
}

function arrecife:init(entidades,poligono)
	self.tipo="arrecife"
	self.entidades=entidades

	funciones:crear_destruible(self,poligono)

	self.texturas = self.entidades.img_texturas

	funciones:crear_mesh(self,poligono)

	self.entidades:add_obj("destruible",self)

	self.otro_poligono=nil

	delete.init(self,"destruible")
end

function arrecife:draw()
	funciones:dibujar_texturas(self)
end

function arrecife:update(dt)
	if self.otro_poligono then
    	self:recorte_figura(self.otro_poligono)
  	end
end

function arrecife:recorte_figura(poligono_enemigo)
  
  local nuevo_poligono = polybool(self.poligono, poligono_enemigo, "not")

 
  if #nuevo_poligono<6 then

	    for i=1, #nuevo_poligono ,1 do

	        arrecife(self.entidades,nuevo_poligono[i])
	      
	    end
  end
	    
	self:remove() 

end

function arrecife:poligono_recorte(x,y)
  local dis=2.5
  self.otro_poligono =  {-5*dis+x,-8.66*dis+y,
  5*dis+x,-8.66*dis+y,
  10*dis+x,0*dis+y,
  5*dis+x,8.66*dis+y,
  -5*dis+x,8.66*dis+y,
  -10*dis+x,0*dis+y}
end

return arrecife