local Class = require "libs.hump.class"
local sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"

require "libs.extra.extras"

local entidades=Class{}

local personajes={}

function entidades:init(cam,timer,signal,vector,eleccion)
	self.cam=cam
	self.timer=timer
	self.signal=signal
	self.vector=vector



	personajes={
		require "entidades.personajes.Aegis",
		require "entidades.personajes.Solange",
		require "entidades.personajes.Xeon",
		require "entidades.personajes.Radian",
		require "entidades.personajes.HS",
		require "entidades.personajes.Cromwell"
	}

	self.gameobject={}

	self.gameobject.players={}
	self.gameobject.balas={}
	self.gameobject.efectos={}
	self.gameobject.enemigos={}



	self.world = love.physics.newWorld(0, 0, false)

	
    self.world:setCallbacks(self:callbacks())


	self:add_obj("players",personajes[eleccion](self,100,100,1))


	self.pl=self.gameobject.players[1]

	self.ox,self.oy=self.pl.ox,self.pl.oy

	--self:init_servidor()

end

function entidades:enter()
	
end

function entidades:draw()
	self.cam:draw(function(l,t,w,h)
		for i, obj in pairs(self.gameobject) do
			for _, obj2 in ipairs(obj) do
				obj2:draw()
			end
		end

		for _, body in pairs(self.world:getBodies()) do
		    for _, fixture in pairs(body:getFixtures()) do
		        local shape = fixture:getShape()
		 
		        if shape:typeOf("CircleShape") then
		            local cx, cy = body:getWorldPoints(shape:getPoint())
		            love.graphics.circle("line", cx, cy, shape:getRadius())
		        elseif shape:typeOf("PolygonShape") then
		            love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
		        else
		            love.graphics.line(body:getWorldPoints(shape:getPoints()))
		        end
		    end
	    end


	end)
end

function entidades:update(dt)
	self.world:update(dt)

	for i, obj in pairs(self.gameobject) do
		for _, obj2 in pairs(obj) do
			obj2:update(dt)
		end
	end

	if self.pl then
		self.cam:setPosition(self.pl.ox,self.pl.oy)
		self.ox,self.oy=self.pl.ox,self.pl.oy
	else
		self.cam:setPosition(self.ox,self.oy)
	end

end

function entidades:keypressed(key)
	self.pl:keypressed(key)

	if key=="k" then
		self.gameobject.players[1].vivo=false
	end

end

function entidades:keyreleased(key)
	self.pl:keyreleased(key)
end

function entidades:mousepressed(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	self.pl:mousepressed(cx,cy,button)
end

function entidades:mousereleased(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	self.pl:mousereleased(cx,cy,button)
end

function entidades:touchpressed(id,x,y,dx,dy,pressure)
	
end

function entidades:touchreleased(id,x,y,dx,dy,pressure)
	
end

function entidades:wheelmoved(x,y)
	self.pl:wheelmoved(x,y)
end



function entidades:add_obj(name,obj)


	table.insert(self.gameobject[name],obj)
end

function entidades:remove_obj(name,obj)

	for i, e in ipairs(self.gameobject[name]) do
		if e==obj then
			table.remove(self.gameobject[name],i)
			return
		end
	end
end

function entidades:getXY()
	local cx,cy=self.cam:toWorld(love.mouse.getX(),love.mouse.getY())
	return cx,cy
end

function entidades:callbacks()
	local beginContact =  function(a, b, coll)
 		local obj1=a:getUserData()
 		local obj2=b:getUserData()
 		local x,y=coll:getNormal()

 		--print(obj1.data,obj2.data)

 		if obj1.data=="personaje" and obj2.data=="bala" then
 			if not obj1.obj.estados.protegido  then


	 			obj1.obj:attack(obj2.obj.daño)

	 			if obj2.obj.efecto then
					obj1.obj:efecto(obj2.obj.efecto)
				end

	 			obj2.obj:remove()
	 		end
 		elseif obj1.data=="escudo" and obj2.data=="bala"  then

 			if obj1.obj.estados.protegido  then

 				if obj1.obj.personaje=="Aegis" then

 					local r=math.atan2(y,x)
 					local ix,iy=math.cos(r),math.sin(r)

 					obj1.obj:reflejo(obj2.obj,-ix,-iy) 
 				else
 					obj2.obj:remove()
 				end
 					
 			end
 		elseif obj1.data=="personaje" and obj2.data=="campo_electrico" then
 			obj1.obj:efecto("paralisis",true)
 		elseif obj1.data=="personaje" and obj2.data=="barrera_de_fuego" then
 			obj1.obj:efecto("quemadura",true)
 		elseif obj1.data=="personaje" and obj2.data=="explosion_plasma" then
 			obj1.obj:efecto("plasma",true)
 		elseif obj1.data=="bala" and obj2.data=="cubo_de_hielo" then
 			if obj1.obj.name=="bala-hielo" then
		 		obj2.obj:resize()
		 		obj1.obj:remove()
	 		elseif obj1.obj.name=="bala-fuego" then
	 			obj2.obj:attack(obj1.obj.daño*2)
	 			obj1.obj:remove()
	 		end
	 	elseif obj1.data=="bala" and obj2.data=="barrera_de_fuego" then
	 		if obj1.obj.name=="bala-hielo" then
	 			obj1.obj:remove()
	 			obj2.obj:remove()
	 		end
 		elseif obj1.data=="melee" and obj2.data=="bala" then
 			if obj1.obj.estados.atacando then
 				obj2.obj:remove()
 			end
 		elseif obj1.data=="melee" and obj2.data=="cubo_de_hielo" then
 			if obj1.obj.estados.atacando then
 				obj2.obj:attack(obj1.obj.melee_attack)
 				obj1.obj.estados.atacando=false
 			end
 		elseif obj1.data=="melee" and obj2.data=="personaje" then
 			if obj1.obj.estados.atacando then
 				
 				local r=math.atan2(y,x)
 				local ix,iy=math.cos(r),math.sin(r)

 				obj2.obj.collider:applyLinearImpulse( 10000*-ix,10000*-iy )

 				obj2.obj:attack(obj1.obj.melee_attack)
 				obj1.obj.estados.atacando=false
 			end
 		elseif obj1.data=="melee" and obj2.data=="escudo" then
 			if obj1.obj.estados.atacando and obj1.obj.estados.protegido then
 				local r=math.atan2(y,x)
 				local ix,iy=math.cos(r),math.sin(r)

 				obj1.obj.collider:applyLinearImpulse( 10000*-ix,10000*-iy )
 				obj1.obj.estados.atacando=false
 			end
 		end
	end


	local endContact =  function(a, b, coll)
 		--local obj1=a:getUserData()
 		---local obj2=b:getUserData()
 		--local x,y=coll:getNormal()


	end

	local preSolve =  function(a, b, coll)

		--aqui no va colisiones con fixture
		local obj1=a:getUserData()
 		local obj2=b:getUserData()
 		local x,y=coll:getNormal()

 		
 		if obj1.data=="bala" and obj2.data=="bala" then
 			obj1.obj:collides_bala(obj2.obj)
 			obj2.obj:collides_bala(obj1.obj)
 		end
	end

	local postSolve =  function(a, b, coll, normalimpulse, tangentimpulse)
 		--local obj1=a:getUserData()
 		--local obj2=b:getUserData()

	end

	return beginContact,endContact,preSolve,postSolve
end

function entidades:init_servidor()
	self.server:on("connect", function(data, client)
		local index=client:getIndex()
        client:send("player_id", index+1)
        table.insert(self.players, Player[data](self,100,100,index+1))
    end)

    self.server:on("disconnect", function(data, client)
    	--[[local index =client:getIndex()

    	self.players[index]:remove_player()
    	table.remove(self.players,index)

    	self.server:sendToAll("desconexion_player", index)]]
    end)
end

return entidades

