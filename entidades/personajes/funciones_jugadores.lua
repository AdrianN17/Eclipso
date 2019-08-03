local extra = require "entidades.funciones.extra"

local funciones_jugadores ={}

function funciones_jugadores:crear_cuerpo(obj,x,y,area)
	--cuerpo
  
  obj.collider=py.newBody(obj.entidades.world,x,y,"dynamic")
	obj.collider:setFixedRotation(true)

	obj.shape=py.newCircleShape(area)
	obj.fixture=py.newFixture(obj.collider,obj.shape)
	obj.fixture:setGroupIndex( -obj.creador )
	obj.fixture:setUserData( {data="personaje",obj=obj, pos=1} )
	obj.fixture:setDensity(0)
	obj.collider:setInertia( 0 )

	obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()
  
  	--escudo
  
  obj.shape_escudo=py.newCircleShape(area*2.5)
	obj.fixture_escudo=py.newFixture(obj.collider,obj.shape_escudo)
	obj.fixture_escudo:setSensor( true )
	obj.fixture_escudo:setGroupIndex( -obj.creador )
	obj.fixture_escudo:setUserData( {data="escudo",obj=obj, pos=2}  )
	obj.fixture_escudo:setDensity(0)
end

function funciones_jugadores:crear_brazos(obj,puntos_brazos)
	obj.points={}

	for _,p in ipairs(puntos_brazos) do
		local t={}

		t.shape=py.newCircleShape(p.x,p.y,4)
		t.fixture=py.newFixture(obj.collider,t.shape)
		t.fixture:setSensor( true )
		t.fixture:setGroupIndex( -obj.creador )
		t.fixture:setUserData( {data="brazos",obj=obj, pos=3}  )
		t.fixture:setDensity(0)

		table.insert(obj.points,t)
	end

end

function funciones_jugadores:crear_armas_melee(obj,puntos_melee)
    obj.melee_weapon={}
    obj.melee_weapon.shape=py.newRectangleShape(puntos_melee.x,puntos_melee.y,puntos_melee.w,puntos_melee.h)
    obj.melee_weapon.fixture=py.newFixture(obj.collider,obj.melee_weapon.shape)
    obj.melee_weapon.fixture:setSensor( true )
    obj.melee_weapon.fixture:setGroupIndex( -obj.creador )
    obj.melee_weapon.fixture:setUserData( {data="melee",obj=obj, pos=8}  )
    obj.melee_weapon.fixture:setDensity(0)
    obj.melee_weapon.brazo=puntos_melee.brazo
    
    obj.dano_melee=puntos_melee.dano
    
    --obj.time_melee=puntos_melee.tiempo
    --obj.time_melee_contador=0

end

function funciones_jugadores:masa_personaje(obj,mass)
	obj.collider:resetMassData()
	obj.collider:setMass(mass)
	obj.mass=obj.collider:getMass()


	obj.collider:setLinearDamping(mass/20)
end

function funciones_jugadores:get_radio(obj)
  return math.atan2( obj.ry-obj.oy, obj.rx -obj.ox)
end

function funciones_jugadores:angulo(obj)
	if not obj.estados.congelado then
    	obj.radio=self:get_radio(obj)
  	end
end

function funciones_jugadores:movimiento(obj,dt)
	  local x,y=0,0
  	obj.estados.moviendo=false
  
  	if obj.direccion.a then
    	x=-1
    	obj.estados.moviendo=true
  	end
  
  	if obj.direccion.d then
    	x=1
    	obj.estados.moviendo=true
  	end
  
  	if obj.direccion.w then
    	y=-1
    	obj.estados.moviendo=true
  	end
  
  	if obj.direccion.s then
    	y=1
    	obj.estados.moviendo=true
  	end

  	if obj.estados.moviendo and not obj.estados.atacado and not obj.estados.dash then
		local mx,my=x*obj.mass*obj.velocidad*dt,y*obj.mass*obj.velocidad*dt
		local vx,vy=obj.collider:getLinearVelocity()
    


		if vx<obj.velocidad or vy<obj.velocidad then
			obj.collider:applyLinearImpulse(mx,my)
		end
	end

end
  
function funciones_jugadores:coger_centro(obj)
	obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()

  obj.collider:setAngle(obj.radio)
end

--controles

function funciones_jugadores:presionar_botones_movimiento(obj,key)
	if key=="a" then
    	obj.direccion.a=true
  	elseif key=="d" then
    	obj.direccion.d=true
  	end
  
  	if key=="w" then
    	obj.direccion.w=true
  	elseif key=="s" then
    	obj.direccion.s=true
  	end
end

function funciones_jugadores:soltar_botones_movimiento(obj,key)
	if key=="a" then
    	obj.direccion.a=false
  	elseif key=="d" then
    	obj.direccion.d=false
  	end
  
  	if key=="w" then
    	obj.direccion.w=false
  	elseif key=="s" then
    	obj.direccion.s=false
  	end
end

function funciones_jugadores:cambio_armas(obj,key)
  for i=1,obj.armas_disponibles,1 do
    if tostring(i)==key then
      self:recarga_restaurar_tiempo(obj)
      obj.arma=i
    end
  end
end

function funciones_jugadores:presionar_botones_escudo(obj,key)
  if key=="e" then
    obj.estados.protegido=true
  end
end

function funciones_jugadores:soltar_botones_escudo(obj,key)
  if key=="e" then
    obj.estados.protegido=false
  end
end

function funciones_jugadores:recargar_balas(obj,key)
  if key=="r" and obj.balas[obj.arma].stock<obj.balas[obj.arma].balas_max then
    obj.estados.recargando=true
  end
end

function funciones_jugadores:soltar_arma_de_fuego(obj)
  obj.estados.atacando=false
end

--dibujo

function funciones_jugadores:dibujar_personaje(obj)
  local x,y,w,h = obj.spritesheet[obj.iterator][obj.iterator_2]:getViewport( )
    
    lg.draw(obj.spritesheet["image"],obj.spritesheet[obj.iterator][obj.iterator_2],obj.ox,obj.oy,obj.radio + math.pi/2,
      obj.spritesheet.scale,obj.spritesheet.scale,w/2,h/2)
end

function funciones_jugadores:dibujar_escudo(obj)
  if obj.estados.protegido then
    local x_s,y_s,w_s,h_s = obj.spritesheet_escudos[obj.tipo_escudo]:getViewport( )
    lg.draw(obj.spritesheet_escudos["image"],obj.spritesheet_escudos[obj.tipo_escudo],obj.ox,obj.oy,0,obj.spritesheet_escudos.scale,
      obj.spritesheet_escudos.scale,w_s/2,h_s/2)
  end
end

function funciones_jugadores:iterador_dibujo_ver1(obj,dt)
  if obj.estados.moviendo then
    
    if obj.estados.atacando then
      obj.iterator=2
    else
      obj.iterator=1
    end
    
    obj.timer_1=obj.timer_1+dt
    
    if obj.timer_1>0.3 then
      
      if obj.iterator_2<3 then
        obj.iterator_2=obj.iterator_2+1
      else
        obj.iterator_2=2 
      end
      
      obj.timer_1=0
    end
    
    
    
  else
    if obj.estados.atacando then
      obj.iterator=2
    else
      obj.iterator=1
    end
    
    obj.iterator_2=1
    obj.timer_1=0
  end
end

function funciones_jugadores:iterador_dibujo_ver2(obj,dt)
  if obj.estados.moviendo then
    
    if obj.estados.atacando then
      obj.iterator=2
    elseif obj.estados.atacando_melee then
      obj.iterator=3
    else
      obj.iterator=1
    end
    
    obj.timer_1=obj.timer_1+dt
    
    if obj.timer_1>0.3 then
      
      if obj.iterator_2<3 then
        obj.iterator_2=obj.iterator_2+1
      else
        obj.iterator_2=2 
      end
      
      obj.timer_1=0
    end
    
  else
    if obj.estados.atacando then
      obj.iterator=2
    elseif obj.estados.atacando_melee then
      obj.iterator=3
    else
      obj.iterator=1
    end
    
    obj.iterator_2=1
    obj.timer_1=0
  end
end

function funciones_jugadores:dibujar_melee(obj)
  if obj.estados.atacando_melee then
    local x,y,w,h = obj.spritesheet["melee"]:getViewport( )

    local shape= obj.melee_weapon.fixture:getShape()
    local x1,y1,x2,y2,x3,y3,x4,y4 = obj.collider:getWorldPoints(shape:getPoints())

    local ox,oy=(x1+x2+x3+x4)/4,(y1+y2+y3+y4)/4

    obj.melee_x,obj.melee_y=ox,oy

    
   lg.draw(obj.spritesheet["image"],obj.spritesheet["melee"],ox,oy,obj.radio + math.pi/2,
      obj.spritesheet.scale,obj.spritesheet.scale,w/2,h/2)
  end
end


--balas

function funciones_jugadores:nueva_bala(obj,bala,id_brazo)
  
    self:resetear_tiempo_escudo(obj)
    obj.estados.atacando=true

    local shape= obj.points[id_brazo].fixture:getShape()
    local px,py= obj.collider:getWorldPoints(shape:getPoint())
    local radio=math.atan2( obj.ry-py, obj.rx -px)

    bala(obj.entidades,px,py,radio,obj.creador,obj.ox,obj.oy)
end

function funciones_jugadores:nuevas_balas(obj,bala,id_brazo)
  
    self:resetear_tiempo_escudo(obj)
    obj.estados.atacando=true

    local shape= obj.points[id_brazo].fixture:getShape()
    local px,py= obj.collider:getWorldPoints(shape:getPoint())
    local radio=math.atan2( obj.ry-py, obj.rx -px)



    bala(obj.entidades,px,py,radio-math.rad(5),obj.creador,obj.ox,obj.oy)
    bala(obj.entidades,px,py,radio,obj.creador,obj.ox,obj.oy)
    bala(obj.entidades,px,py,radio+math.rad(5),obj.creador,obj.ox,obj.oy)

end

--escudo
function funciones_jugadores:limite_escudo(obj,dt)
  if obj.estados.protegido then
    obj.escudo_time=obj.escudo_time+dt
    if obj.escudo_time>obj.max_tiempo_escudo then
      self:resetear_tiempo_escudo(obj)
    end
  end
end

function funciones_jugadores:resetear_tiempo_escudo(obj)
  obj.estados.protegido=false
  obj.escudo_time=0
end

--recarga 

function funciones_jugadores:recargando(obj,dt)
  if obj.estados.recargando then
    obj.timer_recargando=obj.timer_recargando+dt
      
    if obj.timer_recargando>obj.recarga_timer then
      self:recarga_finalizada(obj)
      self:recarga_restaurar_tiempo(obj)
    end
  end
end


function funciones_jugadores:recarga_restaurar_tiempo(obj)
  obj.timer_recargando=0
  obj.estados.recargando=false
end

function funciones_jugadores:recarga_finalizada(obj)
  obj.balas[obj.arma].stock=obj.balas[obj.arma].balas_max
end

--vida 

function funciones_jugadores:muerte(obj)
  if not obj.estados.vivo then
    obj:remove()
  end
end

--ataque melee

function funciones_jugadores:activar_melee(obj)
  if not obj.estados.protegido then
    obj.estados.atacando_melee=true
  end
end

function funciones_jugadores:desactivar_melee(obj)
  obj.estados.atacando_melee=false
end

--empaquetado

function funciones_jugadores:empaquetado_1(obj)
    local pack = {}

    pack=extra:enviar_data_jugador(obj,"ox","oy","radio","hp","ira","tipo","tipo_escudo","iterator","iterator_2","nombre","estados")

    return pack
end

function funciones_jugadores:empaquetado_2(obj)
    local pack = {}

    pack=extra:enviar_data_jugador(obj,"ox","oy","radio","hp","ira","tipo","tipo_escudo","iterator","iterator_2","nombre","estados","melee_x","melee_y")

    return pack
end

function funciones_jugadores:regular_ira(obj,dt)
  if obj.ira>0 then
    
    obj.ira = obj.ira - dt*10

    if obj.ira <0.1 then
      obj.ira = 0
    end
  end
end

function funciones_jugadores:dash(obj,key)
  if key=="q" then
    if not obj.estados.dash then
      obj.estados.dash=true
      local ix,iy = math.cos(obj.radio),math.sin(obj.radio)

      obj.collider:applyLinearImpulse( 20000*ix,20000*iy )
    end
  end
end

function funciones_jugadores:contador_dash(obj,dt)
  obj.tiempo_dash=obj.tiempo_dash+dt

  if obj.tiempo_dash>obj.max_tiempo_dash then
    obj.tiempo_dash=0
    obj.estados.dash=false
  end
end




return funciones_jugadores