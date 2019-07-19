local Class= require "libs.hump.class"
local personajes = {}

personajes.aegis = require "entidades.personajes.aegis"
personajes.solange = require "entidades.personajes.solange"
personajes.xeon = require "entidades.personajes.xeon"
personajes.radian = require "entidades.personajes.radian"

local entidad_servidor = Class{}



function entidad_servidor:init(personaje)

	self.img_personajes=require "assets.img.personajes.img_personajes"
	self.img_balas=require "assets.img.balas.img_balas"
	self.img_escudos=require "assets.img.escudos.img_escudos"

	self.world = love.physics.newWorld(0, 0, false)
  	self.world:setCallbacks(self:callbacks())

	self.gameobject={}

	self.gameobject.players={}


	self.gameobject.players[0]=personajes[personaje](self,100,100,1)
	self.gameobject.balas={}
	self.gameobject.efectos={}
  	self.gameobject.destruible={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}
  	self.gameobject.arboles={}


  	self:custom_layers()
end

function entidad_servidor:draw_entidad()

end

function entidad_servidor:update_entidad(dt)
	local player = self.gameobject.players[0]
    
    --camara-muerte del usuario
    if  player then
		self.cam:setPosition(player.ox,player.oy)
    
      	player.rx,player.ry=self:getXY()
	end
end

function entidad_servidor:callbacks()
	local beginContact =  function(a, b, coll)

		local obj1=nil
 		local obj2=nil

		local o1,o2=a:getUserData(),b:getUserData()

		if o1.pos<o2.pos then
			obj1=o1
			obj2=o2
		else
			obj1=o2
			obj2=o1
		end

 		local x,y=coll:getNormal()
    	
  	end
  
  	local endContact =  function(a, b, coll)
 		local obj1=nil
 		local obj2=nil

		local o1,o2=a:getUserData(),b:getUserData()
    
    	if o1.pos<o2.pos then
			obj1=o1
			obj2=o2
		else
			obj1=o2
			obj2=o1
		end
    
    	local x,y=coll:getNormal()
    
  	end
  
  	local preSolve =  function(a, b, coll)
	    
  	end
  
  	local postSolve =  function(a, b, coll, normalimpulse, tangentimpulse)

	end

	return beginContact,endContact,preSolve,postSolve
end

function entidad_servidor:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())
	return cx,cy
end

function entidad_servidor:custom_layers()
  
  local Balas_layers = self.map.layers["Balas"]
  
  local Enemigos_layers = self.map.layers["Enemigos"] 
  
  local Personajes_layers = self.map.layers["Personajes"]
  
  local Destruible_layers = self.map.layers["Destruible"]
  
  local Objetos_layers = self.map.layers["Objetos"]
  
  local Arboles_layers = self.map.layers["Arboles"]
  

  Balas_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.balas) do
      obj_data:draw()
    end
  end
  
  Balas_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.balas) do
      obj_data:update(dt)
    end
  end
  
  
  
  Enemigos_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.enemigos) do
      obj_data:draw()
    end
  end
  
  Enemigos_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.enemigos) do
      obj_data:update(dt)
    end
  end
  
  Personajes_layers.draw = function(obj)
  	for i=0,#self.gameobject.players,1  do
  		local obj_data=self.gameobject.players[i]
 		if obj_data then
        	obj_data:draw()
      	end
	end
  end
  
  Personajes_layers.update = function(obj,dt)
    for i=0,#self.gameobject.players,1  do
  		local obj_data=self.gameobject.players[i]
 		if obj_data then
        	obj_data:update(dt)
      	end
	end
  end
  
  Destruible_layers.draw = function(obj)
    for _, obj_data in pairs(self.gameobject.destruible) do
      if obj_data then
        obj_data:draw()
      end
    end
  end
  
  Destruible_layers.update = function(obj,dt)
    for _, obj_data in pairs(self.gameobject.destruible) do
      if obj_data then
        obj_data:update(dt)
      end
    end
  end
  
  Objetos_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.objetos) do
      obj_data:draw()
    end
  end
  
  Objetos_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.objetos) do
      obj_data:update(dt)
    end
  end
  
  Arboles_layers.draw = function(obj)
    for _, obj_data in ipairs(self.gameobject.arboles) do
      obj_data:draw()
    end
  end
  
  Arboles_layers.update = function(obj,dt)
    for _, obj_data in ipairs(self.gameobject.arboles) do
      obj_data:update(dt)
    end
  end
  
end

function entidad_servidor:keypressed(key)
	if self.gameobject.players[0] then
		self.gameobject.players[0]:keypressed(key)
	end
end

function entidad_servidor:keyreleased(key)
	if self.gameobject.players[0] then
		self.gameobject.players[0]:keyreleased(key)
	end
end

function entidad_servidor:mousepressed(x,y,button)
	if self.gameobject.players[0] then
		local cx,cy=self.cam:toWorld(x,y)
		self.gameobject.players[0]:mousepressed(cx,cy,button)
	end
end

function entidad_servidor:mousereleased(x,y,button)
	if self.gameobject.players[0] then
		local cx,cy=self.cam:toWorld(x,y)
		self.gameobject.players[0]:mousereleased(cx,cy,button)
	end
end

function entidad_servidor:add_obj(name,obj)
	table.insert(self.gameobject[name],obj)
end

function entidad_servidor:remove_obj(name,obj)
	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end



return entidad_servidor

--el primer jugador, el usado por el dueño del servidor sera 0