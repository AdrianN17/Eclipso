local extra = require "entidades.funciones.extra"

local funciones_enemigos = {}

function funciones_enemigos:crear_cuerpo(obj,x,y,poligono)

	obj.index = obj.entidades:get_enemigo_id()

	obj.collider=py.newBody(obj.entidades.world,x,y,"dynamic")
	obj.collider:setFixedRotation(true)

	obj.shape=py.newPolygonShape(poligono)
	obj.fixture=py.newFixture(obj.collider,obj.shape)
	obj.fixture:setGroupIndex( -obj.creador )
	obj.fixture:setUserData( {data="enemigos",obj=obj, pos=6} )
	obj.fixture:setDensity(0)
	obj.collider:setInertia( 0 )

	obj.radio= 0
	obj.collider:setAngle(0)

	obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()
end

function funciones_enemigos:crear_brazos(obj,puntos_brazos)
	obj.points={}

    for _,p in ipairs(puntos_brazos) do
      local t={}

      t.shape=py.newCircleShape(p.x,p.y,4)
      t.fixture=py.newFixture(obj.collider,t.shape)
      t.fixture:setSensor( true )
      t.fixture:setGroupIndex( -obj.creador )
      t.fixture:setUserData( {data="brazos_enemigo",obj=obj, pos=8}  )
      t.fixture:setDensity(0)

      table.insert(obj.points,t)
    end

end

function funciones_enemigos:crear_melee(obj,puntos_melee)
	obj.melee={}

    for _,p in ipairs(puntos_melee) do
      local t={}
      t.shape=py.newCircleShape(p.x,p.y,p.r)
      t.fixture=py.newFixture(obj.collider,t.shape)
      t.fixture:setSensor( true )
      t.fixture:setGroupIndex( -obj.creador )
      t.fixture:setUserData( {data="melee_enemigo",obj=obj, pos=8}  )
      t.fixture:setDensity(0)

      table.insert(obj.melee,t)
    end
end

function funciones_enemigos:crear_vision(obj,puntos_rango)
	obj.shape_vision=py.newCircleShape(puntos_rango.x,puntos_rango.y,puntos_rango.r)
	obj.fixture_vision=py.newFixture(obj.collider,obj.shape_vision)
	obj.fixture_vision:setSensor( true )
	obj.fixture_vision:setGroupIndex( -obj.creador )
	obj.fixture_vision:setUserData( {data="vision_enemigo",obj=obj, pos=7}  )
	obj.fixture_vision:setDensity(0)
end

function funciones_enemigos:crear_raycast(obj,max_acercamiento,radio)


	obj.shape_raycast = py.newEdgeShape(0,0,0,-max_acercamiento)
	obj.fixture_raycast=py.newFixture(obj.collider,obj.shape_raycast)
	obj.fixture_raycast:setSensor( true )
	obj.fixture_raycast:setGroupIndex( -obj.creador )
	obj.fixture_raycast:setUserData( {data="raycast_enemigo",obj=obj, pos=11}  )
	obj.fixture_raycast:setDensity(0)

	obj.time_raycast=0
	obj.max_acercamiento=max_acercamiento


	obj.funcion_raycast = function(fixture, x, y, xn, yn, fraction)

    	local tipo_obj=fixture:getUserData().data
    
	    if tipo_obj == "objeto" or  tipo_obj =="destruible" then
	    	local r = lm.random(1,2)
	    	if r == 1 then
	       		obj.radio=obj.radio + math.pi/2
	       	elseif r == 2 then
	       		obj.radio=obj.radio - math.pi/2
	       	end

	       	self:limpiar_puntos_semi_presa(obj)
	       	self:limpiar_puntos_presa(obj)

	       	obj.fsm:rastreando()
	    end
	    
	    return 1
  	end

end

function funciones_enemigos:masa_personaje(obj,mass)
	obj.collider:resetMassData()
	obj.collider:setMass(mass)
	obj.mass=obj.collider:getMass()


	obj.collider:setLinearDamping(mass/20)
end

function funciones_enemigos:coger_centro(obj)
	obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()

  obj.collider:setAngle(obj.radio)
end

--dibujado

function funciones_enemigos:dibujar_enemigo(obj)
	local x,y,w,h = obj.spritesheet[obj.tipo][obj.iterator]:getViewport( )
    
    lg.draw(obj.spritesheet["image"],obj.spritesheet[obj.tipo][obj.iterator],obj.ox,obj.oy,obj.radio,obj.spritesheet[obj.tipo].scale,obj.spritesheet[obj.tipo].scale,w/2,h/2)
    
    --[[lg.print(obj.fsm.current .. " ,  " .. tostring(obj.semi_presa.x) .. " , " .. tostring(obj.semi_presa.y),obj.ox,obj.oy-100)

    if obj.semi_presa.x then
    	love.graphics.circle("fill", obj.semi_presa.x, obj.semi_presa.y, 15)
    end]]
    
    
end

--animacion

function funciones_enemigos:animacion_enemigo(obj,dt)
	obj.timer_1=obj.timer_1+dt
  
  	if obj.timer_1>0.5 then
	    obj.iterator=obj.iterator+1
	    
	    if obj.iterator>obj.max_iterator then
	      obj.iterator=1
	    end
	    
	    obj.timer_1=0
  	end
end

function funciones_enemigos:realizar_disparo(obj,dt)
  obj.tiempo_balas=obj.tiempo_balas+dt

  local objeto_balas = obj.balas[obj.brazo_actual]
      
  if obj.tiempo_balas>objeto_balas.tiempo then
    self:crear_balas(obj,objeto_balas)
    
    obj.tiempo_balas=0
  end
end

function funciones_enemigos:crear_balas(obj,bala)
  local s= obj.points[obj.brazo_actual].fixture:getShape()
  local px,py=obj.collider:getWorldPoints(s:getPoint())
  
  
  if bala.stock>0 then
    bala.bala(obj.entidades,px, py,obj.radio-math.pi/2,obj.creador)
    bala.stock=bala.stock-1

    if bala.stock==0 then
    	obj.estados.recargando=true
    end
  end

end

function funciones_enemigos:recargar(obj,dt)
  obj.tiempo_recarga=obj.tiempo_recarga+dt

  local bala = obj.balas[obj.brazo_actual]
  
  if obj.tiempo_recarga>bala.tiempo_recarga then
    bala.stock=bala.max_stock
    obj.tiempo_recarga=0

    obj.estados.recargando=false
  end
end

function funciones_enemigos:muerte(obj)
  if not obj.estados.vivo then
    obj:remove()
  end
end

--presas

function funciones_enemigos:nueva_presa(obj,objeto)
	self:limpiar_puntos_semi_presa(obj)

	if #obj.presas == 0 then
		table.insert(obj.presas,objeto)
		obj.fsm:atacando() 
	else
		for _, presa in ipairs(obj.presas) do
	      if presa~= obj then
	        table.insert(obj.presas,obj)
	      end
	    end
	end
end

function funciones_enemigos:eliminar_presa(obj,objeto)
  for i, presa in ipairs(obj.presas) do
    if presa== objeto then
      table.remove(obj.presas,i)
    end
  end
  
  if #obj.presas==0 then
    obj.fsm:rastreando() 
  end
end

--semipresa
function funciones_enemigos:nueva_semipresa(obj,x,y)
	if obj.semi_presa.x and obj.semi_presa.y then
		local d1,d2 = math.pow(obj.ox-obj.semi_presa.x,2),math.pow(obj.oy-obj.semi_presa.y,2)
		local distance1 = math.sqrt(d1+d2)

		local d3,d4 = math.pow(obj.ox-x,2),math.pow(obj.oy-y,2)
		local distance2 = math.sqrt(d3+d4)

		if distance1 < distance2 then
			obj.semi_presa.x=x 
			obj.semi_presa.y=y
		end
	else
		obj.semi_presa.x=x 
		obj.semi_presa.y=y
	end

	self:nuevo_radio_elegido_puntos(obj,obj.semi_presa.x,obj.semi_presa.y)
end

function funciones_enemigos:modulo_disparo(obj,dt)
	if not obj.estados.recargando then
		self:realizar_disparo(obj,dt)
	else
		self:recargar(obj,dt)
	end
end

--seguimiento
function funciones_enemigos:funcion_realizar_busqueda(obj,dt,tipo)
	if tipo=="ataca" then
		if self:limite_caceria_presas(obj) then
			self:moverse(obj,dt)
		end
	elseif tipo=="alerta" then
		if self:limite_caceria_puntos(obj) then
			self:moverse(obj,dt)
		else
			self:limpiar_puntos_semi_presa(obj)
			obj.fsm:rastreando()
		end
	elseif tipo == "rastreo" then
		self:moverse(obj,dt)
	end
end

function funciones_enemigos:moverse(obj,dt)
	local x,y= math.cos(obj.radio+math.pi/2),math.sin(obj.radio+math.pi/2)
  
	local mx,my=x*obj.mass*obj.velocidad*dt,y*obj.mass*obj.velocidad*dt
	local vx,vy=obj.collider:getLinearVelocity()
    
  

	if vx<obj.velocidad or vy<obj.velocidad then
		obj.collider:applyLinearImpulse(-mx,-my)
	end
end

function funciones_enemigos:realizar_rastreo(obj,dt)
	obj.tiempo_rastreo = obj.tiempo_rastreo +dt

	if obj.tiempo_rastreo>obj.max_tiempo_rastreo then
		obj.estas_rastreando= not obj.estas_rastreando
		obj.tiempo_rastreo=0

		if obj.estas_rastreando then
			self:nuevo_radio_random(obj)
		end
	end

	if obj.estas_rastreando then
		self:funcion_realizar_busqueda(obj,dt,"rastreo")
	end
end

function funciones_enemigos:nuevo_radio_random(obj)
	obj.radio = math.rad(lm.random(0,18)*20)
end

function funciones_enemigos:nuevo_radio_elegido(obj,x,y)
	obj.radio = math.atan2(obj.oy-y, obj.ox-x)
end

function funciones_enemigos:nuevo_radio_elegido_puntos(obj,x,y)
	obj.radio = math.atan2(obj.oy-y, obj.ox-x) -math.pi/2
end

function funciones_enemigos:actualizar_raycast(obj,dt)
	obj.time_raycast=obj.time_raycast+dt

	if obj.time_raycast>0.1 then

		obj.estados.colision=false

		
		local raycast = obj.fixture_raycast:getShape( )
		local x,y,w,h = obj.collider:getWorldPoints(raycast:getPoints())


		obj.entidades.world:rayCast(x,y,w,h, obj.funcion_raycast)

		obj.time_raycast=0
	end
end

function funciones_enemigos:cazar_puntos(obj)
	local x ,y  = obj.semi_presa.x, obj.semi_presa.y

	local d1,d2 = math.pow(obj.ox-x,2),math.pow(obj.oy-y,2)
	local distance = math.sqrt(d1+d2)

	return distance
end

function funciones_enemigos:cazar_jugadores(obj)
	local x_min,y_min = 99999,99999
	local distance_min  = 99999

	for i, presa in ipairs(obj.presas) do
		local px,py=presa.ox,presa.oy

		local d1,d2 = math.pow(obj.ox-px,2),math.pow(obj.oy-py,2)
		local distance = math.sqrt(d1+d2)

		if distance < distance_min then
			x_min,y_min = px,py
			distance_min = distance
		end
	end



	return x_min,y_min,distance_min
end

function funciones_enemigos:limite_caceria_puntos(obj)
	local distance = self:cazar_puntos(obj)

	if math.abs(distance) > obj.max_acercamiento_real then
		return true
	else
		return false
	end
end

function funciones_enemigos:limite_caceria_presas(obj)
	local x,y,distance  = self:cazar_jugadores(obj)

	self:nuevo_radio_elegido_puntos(obj,x,y)

	if math.abs(distance) > obj.max_acercamiento_real then
		return true
	else
		return false
	end
end

function funciones_enemigos:limpiar_puntos_semi_presa(obj)
	obj.semi_presa={x=nil,y=nil}
end

function funciones_enemigos:limpiar_puntos_presa(obj)
	obj.presas={}
end

function funciones_enemigos:validacion_de_accion_bala(obj,bala)
	if obj.fsm.current == "ataca" then

	else
		self:nueva_semipresa(obj,bala.inicial_x,bala.inicial_y)
		obj.fsm:alertado()
	end
end

function funciones_enemigos:empaquetado_1(obj)
    local pack = {}

    pack=extra:enviar_data_jugador(obj,"ox","oy","radio","hp","ira","tipo","clase","iterator","estados")

    return pack
end


return funciones_enemigos