local Class = require "libs.hump.class"


local lib_entities= Class{}

function lib_entities:init()
  
end

function lib_entities:add_obj(name,obj)

	table.insert(self.gameobject[name],obj)
end

function lib_entities:remove_obj(name,obj)

	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function lib_entities:remove_to_nill(name,obj)
	for i, e in pairs(self.gameobject[name]) do
		if e and e==obj  then
			self.gameobject[name][i]=nil
			return
		end
	end
end

function lib_entities:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())
	return cx,cy
end

function lib_entities:map_read(objects_map)

  
  for _, layer in ipairs(self.map.layers) do
		if layer.type=="tilelayer" then
			--self:get_tile(layer)
		elseif layer.type=="objectgroup" then
			self:get_objects(layer,objects_map)
		end
	end
  
  self.map:removeLayer("Borrador")
  
end



function lib_entities:get_objects(objectlayer,objects_map)
  
		for _, obj in pairs(objectlayer.objects) do
      if obj.name  then
        if obj.properties.destruible then
          objects_map[obj.name](obj.polygon,self)
        else
          objects_map[obj.name](obj.x,obj.y,self)
        end
      end
		end
end

function lib_entities:callbacks()
  
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
    
    if obj1.data=="personaje" and obj2.data=="bala" then
      obj2.obj:danado(obj1.obj)
      obj2.obj:remove()
    elseif obj1.data=="bala" and obj2.data=="objeto" then
      obj1.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="vision_enemigo" then
      obj2.obj:nueva_presa(obj1.obj)
    elseif obj1.data=="bala" and obj2.data=="enemigos" then
      obj2.obj:dar_posicion(obj1.obj)
      obj1.obj:danado(obj2.obj)
      obj1.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="melee_enemigo" then
      obj2.obj:ataque_melee(obj1.obj)
      
      local r = obj2.obj.radio-math.pi/2
      local ix,iy=math.cos(r),math.sin(r)
    
      obj1.obj.collider:applyLinearImpulse( 10000*ix,10000*iy )
      
    elseif obj1.data=="personaje" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      obj2.obj:ataque_melee(obj1.obj)
      
      local r = obj2.obj.radio-math.pi/2
      local ix,iy=math.cos(r),math.sin(r)
      obj1.obj.collider:applyLinearImpulse( 10000*ix,10000*iy )
      
    elseif obj1.data=="enemigos" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      obj2.obj:ataque_melee(obj1.obj)
      
      local r = obj2.obj.radio-math.pi/2
      local ix,iy=math.cos(r),math.sin(r)
      obj1.obj.collider:applyLinearImpulse( 10000*ix,10000*iy )
      
    elseif obj1.data=="personaje" and obj2.data=="enemigos" then
      --hacer girar
    elseif obj1.data=="escudo" and obj2.data=="enemigos" then
      
    elseif obj1.data=="escudo" and obj2.data=="melee" then
      
    elseif obj1.data=="escudo" and obj2.data=="personaje" then
      
    elseif obj1.data=="escudo" and obj2.data=="bala" and obj1.obj.estados.protegido then
      obj2.obj:remove()
    elseif obj1.data=="bala" and obj2.data=="destruible" then
      local x1, y1, x2, y2 = coll:getPositions( )
      if x1 and y1 then
        local poly = obj2.obj:poligono_recorte(x1,y1)
      end
      
      obj1.obj:remove()
    end

     
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
    
    if obj1.data=="personaje" and obj2.data=="vision_enemigo" then
      obj2.obj:eliminar_presa(obj1.obj)
    end
    
  end
  
  local preSolve =  function(a, b, coll)
    
  end
  
  local postSolve =  function(a, b, coll, normalimpulse, tangentimpulse)

	end

	return beginContact,endContact,preSolve,postSolve
  
end

function lib_entities:custom_layers()
  
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
    for _, obj_data in pairs(self.gameobject.players) do
      if obj_data then
        obj_data:draw()
      end
    end
  end
  
  Personajes_layers.update = function(obj,dt)
    for _, obj_data in pairs(self.gameobject.players) do
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

function lib_entities:close_map()
  local w,h=self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight
  local fin_mapa={}
  fin_mapa.collider=py.newBody(self.world,0,0,"static")
	fin_mapa.shape=py.newChainShape(true,0,0,w,0,h,w,0,h)
	fin_mapa.fixture=py.newFixture(fin_mapa.collider,fin_mapa.shape)
  
  fin_mapa.fixture:setUserData( {data="objeto",obj=self, pos=5} )
  
  return fin_mapa
end

return lib_entities