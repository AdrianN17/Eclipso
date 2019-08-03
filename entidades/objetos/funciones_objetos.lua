local funciones_objetos={}

function funciones_objetos:crear_objeto_poligono(obj,poligono,x,y)
	obj.radio=math.rad(lm.random(36)*10)

	obj.collider=py.newBody(obj.entidades.world,x,y,"kinematic")
	obj.shape=py.newChainShape(true,poligono)
	obj.fixture=py.newFixture(obj.collider,obj.shape)

	obj.fixture:setUserData( {data="objeto",obj=obj, pos=5} )

	obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()

	obj.collider:setAngle(obj.radio)
end

return funciones_objetos