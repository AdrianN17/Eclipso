local funciones_enemigos = {}

function funciones_enemigos:crear_cuerpo(obj,x,y,poligono)

	obj.collider=py.newBody(obj.entidades.world,x,y,"dynamic")
	obj.collider:setFixedRotation(true)

	obj.shape=py.newPolygonShape(poligono)
	obj.fixture=py.newFixture(obj.collider,obj.shape)
	obj.fixture:setGroupIndex( -obj.creador )
	obj.fixture:setUserData( {data="enemigos",obj=obj, pos=6} )
	obj.fixture:setDensity(0)
	obj.collider:setInertia( 0 )

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
    
    --lg.print(obj.hp,obj.ox,obj.oy-100)
    
    --lg.line(obj.raycast.x,obj.raycast.y,obj.raycast.w,obj.raycast.h)
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
  obj.tiempo_recarga=self.tiempo_recarga+dt

  local bala = obj.balas[obj.brazo_actual]
  
  if obj.tiempo_recarga>bala.tiempo_recarga then
    obj.bala.stock=obj.bala.max_stock
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
	if then

	end
end


--seguimiento



return funciones_enemigos