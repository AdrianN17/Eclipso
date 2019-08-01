 local funciones_balas={}

 function funciones_balas:crear_cuerpo(obj,x,y,area,ix,iy)
  	obj.collider=py.newBody(obj.entidades.world,x,y,"dynamic")
	obj.shape=py.newCircleShape(area)
	obj.fixture=py.newFixture(obj.collider,obj.shape)
	obj.fixture:setUserData( {data="bala",obj=obj, pos=4} )
	
	obj.fixture:setGroupIndex( -obj.creador )

	obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()


	if ix and iy then
		obj.inicial_x,obj.inicial_y=ix,iy
	end
end

function funciones_balas:masa_bala(obj,mass)
	obj.collider:resetMassData()
	obj.collider:setMass(mass)
	obj.mass=obj.collider:getMass()

	obj.collider:setLinearDamping(mass/20)
end

function funciones_balas:movimiento(obj,dt)
	local v = dt*obj.velocidad
  	local x,y=obj.mass*math.cos(obj.radio)*v ,obj.mass*math.sin(obj.radio)*v
  
  	local vx,vy=obj.collider:getLinearVelocity()
  
  	if vx<obj.velocidad or vy<obj.velocidad then
    	obj.collider:applyLinearImpulse(x,y)
  	end
end

function funciones_balas:centro_bala(obj)
	obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()
end


--dibujo

function funciones_balas:dibujar_bala(obj)
	local x,y,w,h = obj.spritesheet[obj.tipo]:getViewport( )
  
  	lg.draw(obj.spritesheet.image,obj.spritesheet[obj.tipo],obj.ox,obj.oy,0,obj.spritesheet.scale,obj.spritesheet.scale,w/2,h/2)
end

return funciones_balas