local Class= require "libs.hump.class"
local teclas = require "entidades.funciones.teclas"
local utf8 = require "utf8"
local extra = require "entidades.funciones.extra"

local entidad_servidor = Class{}

function entidad_servidor:init()

  self.id_player=1

  self.id_creador=1
  self.enemigos_id_creador=100

  self.objetos_enemigos=self.mapa_files.objetos_enemigos

	self.world = love.physics.newWorld(0, 0, false)
  self.world:setCallbacks(self:callbacks())

  --self:close_map()

	self.gameobject={}

	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
  self.gameobject.destruible={}
	self.gameobject.enemigos={}
	self.gameobject.objetos={}
  self.gameobject.arboles={}
  self.gameobject.inicios={}

  self:crear_objetos_mapa()

  --self:map_read(self.map)
  self:inicios_random()

  self.chat={}
  self.texto_escrito=""
  self.escribiendo=false

  self.tiempo_chat=0
  self.max_tiempo_chat=3

  self.envio_destruible=false

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


    if obj1.data=="bala" and obj2.data=="objeto" then
      obj1.obj:remove()
    elseif obj1.data=="bala" and obj2.data=="destruible" then

      local x1, y1, x2, y2 = coll:getPositions( )
      if x1 and y1 then
        local poly = obj2.obj:poligono_recorte(x1,y1)
      end
      
      obj1.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="bala" then
      extra:dano(obj1.obj,obj2.obj.dano)
      extra:efecto(obj1.obj,obj2.obj)
      obj2.obj:remove()
    elseif obj1.data=="escudo" and obj2.data=="bala" and obj1.obj.estados.protegido then
      obj2.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      extra:dano(obj1.obj,obj2.obj.dano_melee)
      
      extra:empujon(obj2.obj,obj1.obj,-1)

      obj2.obj.estados.atacando_melee=false
    elseif obj1.data=="bala" and obj2.data=="bala" then
      obj1.obj:remove()
      obj2.obj:remove()
    --callback de enemigos
    elseif obj1.data == "bala" and obj2.data == "enemigos" then
      obj2.obj:validar_estado_bala(obj1.obj)
      extra:dano(obj2.obj,obj1.obj.dano)
      extra:efecto(obj2.obj,obj1.obj)
      obj1.obj:remove()
    elseif obj1.data=="personaje" and obj2.data=="vision_enemigo" then
      obj2.obj:nueva_presas(obj1.obj)
    elseif obj1.data=="personaje" and obj2.data=="melee_enemigo" then
      extra:dano(obj1.obj,obj2.obj.dano_melee)
      
      extra:empujon(obj2.obj,obj1.obj,1)
    elseif obj1.data=="enemigos" and obj2.data=="melee" and obj2.obj.estados.atacando_melee then
      extra:dano(obj1.obj,obj2.obj.dano_melee)

      extra:empujon(obj2.obj,obj1.obj,1)

      obj1.obj.radio=-obj2.obj.radio

      obj2.obj.estados.atacando_melee=false

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
      obj2.obj:eliminar_presas(obj1.obj)
    end
    
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

function entidad_servidor:update_entidades(dt)

    for _, obj_data in ipairs(self.gameobject.balas) do
      obj_data:update(dt)
    end

  
    for _, obj_data in ipairs(self.gameobject.enemigos) do
      obj_data:update(dt)
    end

  
    for i=1,#self.gameobject.players,1 do
      local obj_data = self.gameobject.players[i]

      if obj_data then
        obj_data:update(dt)
      end
    end
  
    for _, obj_data in pairs(self.gameobject.destruible) do
      if obj_data then
        obj_data:update(dt)
      end
    end
  
    for _, obj_data in ipairs(self.gameobject.objetos) do
      obj_data:update(dt)
    end
  
    for _, obj_data in ipairs(self.gameobject.arboles) do
      obj_data:update(dt)
    end

    for _, obj_data in ipairs(self.gameobject.inicios) do
      obj_data:update(dt)
    end
end


function entidad_servidor:add_obj(name,obj)
	table.insert(self.gameobject[name],obj)
end

function entidad_servidor:add_players(obj)
    if #self.gameobject.players==0 and  self.gameobject.players[0] == nil then

      self.gameobject.players[0]=obj
    else
      self.gameobject.players[#self.gameobject.players+1]=obj
    end
end

function entidad_servidor:remove_obj(name,obj)
	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function entidad_servidor:identificador(obj)
  for i=0,#self.gameobject.players,1 do
    local obj_data = self.gameobject.players[i]

    if obj_data and obj == obj_data then
      return i
    end
  end
end

function entidad_servidor:remove_to_nill(obj)
  for i=0,#self.gameobject.players,1 do
    local obj_data = self.gameobject.players[i]

    if obj_data and obj == obj_data then
      self.gameobject.players[i]=nil

      return i
    end
  end
end

function entidad_servidor:remove_personaje(i)
  if self.gameobject.players[i] then
    self.gameobject.players[i]:remove_final()   
    self.gameobject.players[i]=nil
  end
end

--[[function entidad_servidor:map_read(objects_map)

  for _, layer in ipairs(self.map.layers) do
    if layer.type=="tilelayer" then
      --self:get_tile(layer)
    elseif layer.type=="objectgroup" then
      self:get_objects(layer,self.mapa_files.objetos_data)
    end
  end
  
  self.map:removeLayer("Borrador")
  
end]]

function entidad_servidor:crear_objetos_mapa()
  local objetos = self.mapa_files.objetos_data

  for _,data in ipairs(self.mapa_files.points) do
    if #data == 3 then
      objetos[data[1]](self,data[2],data[3])
    else
      objetos[data[1]](self,data[2])
    end
  end
end

--[[function entidad_servidor:get_objects(objectlayer,objects_map)
  
    for _, obj in pairs(objectlayer.objects) do
      if obj.name then
        if obj.properties.destruible then

          local polygon = {}

          print("{ " .. obj.name .. " , {")
          for _,data in ipairs(obj.polygon) do
        
            table.insert(polygon,data.x)
            table.insert(polygon,data.y)
            print("{" .. data.x .. " , " .. data.y .. "},")
          end
          print("} } ")

          objects_map[obj.name](self,polygon)
        else
          --print("{" .. obj.name .. "," .. obj.x .. "," .. obj.y .. "},")
          objects_map[obj.name](self,obj.x,obj.y)
        end
      end
    end
end]]

function entidad_servidor:control_chat()
  if #self.chat> 11 then
      table.remove(self.chat,1)
  end
end

function entidad_servidor:aumentar_id_creador()
  self.id_creador=self.id_creador+1
end

function entidad_servidor:close_map()
  local w,h=self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight
  local fin_mapa={}
  fin_mapa.collider=py.newBody(self.world,0,0,"static")
  fin_mapa.shape=py.newChainShape(true,0,0,w,0,h,w,0,h)
  fin_mapa.fixture=py.newFixture(fin_mapa.collider,fin_mapa.shape)
  
  fin_mapa.fixture:setUserData( {data="objeto",obj=self, pos=5} )
  
  return fin_mapa
end

function entidad_servidor:dar_xy_personaje()
  for i, ini in ipairs(self.gameobject.inicios) do
    if not ini.creacion_players and ini.tipo=="punto_inicio" then
      ini.creacion_players=true
      return ini.ox,ini.oy,i
    end
  end
end

function entidad_servidor:inicios_random()

    local tbl=self.gameobject.inicios
    local len, random = #tbl, lm.random ;
    for i = len, 2, -1 do
        local j = random( 1, i );
        tbl[i], tbl[j] = tbl[j], tbl[i];
    end
    return tbl;

end


function entidad_servidor:reiniciar_punto_resureccion(i)
    self.gameobject.inicios[i].creacion_players=false
end

function entidad_servidor:finalizar_busqueda()
  self.iniciar_partida=true
end

return entidad_servidor