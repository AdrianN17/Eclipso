local Class = require "libs.hump.class"
local Gamestate = require "libs.hump.gamestate"

local cliente = require "gamestates.cliente"

local entidades_cliente = Class{
  __includes = {cliente}
}

function entidades_cliente:init(cam,vector,signal,eleccion,map,ip,puerto,nombre)
  self.id_player=nil
  
  cliente.init(self,ip,puerto,nombre,eleccion)
  
  self.cam=cam
	self.signal=signal
	self.vector=vector

	self.map=map
  
  
  
  self.players={}
  self.enemigos={}
  self.balas={}
  self.objetos={}
  self.arboles={}
  
  
  self:custom_layers()
end

function entidades_cliente:enter()
  
end

function entidades_cliente:draw()
  self:client_draw()
end

function entidades_cliente:update(dt)
  self.map:update(dt)
  self:client_update(dt)
end

function entidades_cliente:getXY()
    local cx,cy=self.cam:toWorld(love.mouse.getPosition())
    return cx,cy 
end

function entidades_cliente:custom_layers()
  local Balas_layers = self.map.layers["Balas"]
  
  local Enemigos_layers = self.map.layers["Enemigos"] 
  
  local Personajes_layers = self.map.layers["Personajes"]
  
  local Objetos_layers = self.map.layers["Objetos"]
  
  local Arboles_layers = self.map.layers["Arboles"]
  
  Balas_layers.draw = function(obj)
    if self.id_player then
      for _,bala in ipairs(self.balas) do
        local indice_balas = self.spritesheet.balas
        local x,y,w,h = indice_balas[bala.tipo_indice]:getViewport( )
              
        lg.draw(indice_balas["image"],indice_balas[bala.tipo_indice],bala.ox,bala.oy,0,indice_balas.scale,indice_balas.scale,w/2,h/2)
      end
    end
  end
  
  Enemigos_layers.draw = function(obj)
    if self.id_player then
      for _,enemigo in ipairs(self.enemigos) do
        local area = self.spritesheet[enemigo.tipo_area]
        local x,y,w,h = area[enemigo.tipo_indice][enemigo.iterator]:getViewport( )
        
        lg.draw(area["image"],area[enemigo.tipo_indice][enemigo.iterator],enemigo.ox,enemigo.oy,enemigo.radio,area[enemigo.tipo_indice].scale,area[enemigo.tipo_indice].scale,w/2,h/2)
      end
    end
  end
  
  Personajes_layers.draw = function(obj)
    if self.id_player then
      for _, player in pairs(self.players) do
        if player then
          local indice = self.spritesheet[player.tipo_indice]
          local x,y,w,h = indice[player.iterator]:getViewport( )
          
          lg.draw(indice["image"],indice[player.iterator],player.ox,player.oy,player.radio + math.pi/2,indice.scale,indice.scale,w/2,h/2)
        end
      end 
    end
  end
  
  Objetos_layers.draw = function(obj)
    if self.id_player then
      for _,objeto in ipairs(self.objetos) do
        local indice_objetos=self.spritesheet.objetos
        local x,y,w,h = indice_objetos[objeto.tipo_indice]:getViewport( )
  
        lg.draw(indice_objetos["image"],indice_objetos[objeto.tipo_indice],objeto.ox,objeto.oy,0,indice_objetos.scale,indice_objetos.scale,w/2,h/2)
      end
    end
  end
  
  Arboles_layers.draw = function(obj)
    if self.id_player then
      for _,arbol in ipairs(self.arboles) do
        local indice_arboles=self.spritesheet.objetos
        local x,y,w,h = indice_arboles[arbol.tipo_indice]:getViewport( )
  
        lg.draw(indice_arboles["image"],indice_arboles[arbol.tipo_indice],arbol.ox,arbol.oy,0,indice_arboles.scale,indice_arboles.scale,w/2,h/2)
      end
    end
  end
  
end

return entidades_cliente