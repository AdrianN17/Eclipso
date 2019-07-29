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

	local ok, res = pcall(function () funciones:crear_destruible(self,poligono) end)

	self.texturas = self.entidades.img_texturas

	funciones:crear_mesh(self,poligono)
	
	self.entidades:add_obj("destruible",self)

	self.otro_poligono=nil

	delete.init(self,"destruible")

	if not ok  then
		self:remove()
	end

	
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
  		local lista_poligono={}

	    for i=1, #nuevo_poligono ,1 do

	    	if funciones:get_area_poligono(nuevo_poligono[i]) >100 then
		    	local poligono_entero = funciones:poligono_floor(nuevo_poligono[i])
		    	local poligono_mejorado = funciones:validar_distancia_poligono(poligono_entero)

		    	if poligono_mejorado  then
		        	arrecife(self.entidades,poligono_mejorado)
		        end
		    end
	    end
  end
	    

  self:remove() 

end

function arrecife:poligono_recorte(x,y)
  local dis=3.5
  self.otro_poligono =  {-5*dis+x,-8.66*dis+y,
  5*dis+x,-8.66*dis+y,
  10*dis+x,0*dis+y,
  5*dis+x,8.66*dis+y,
  -5*dis+x,8.66*dis+y,
  -10*dis+x,0*dis+y}
end

return arrecife