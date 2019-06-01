local Class = require "libs.hump.class"

local modelo_enemigo = Class{}

function modelo_enemigo:init(entidades,x,y,creador,hp,velocidad,ira,polygon,mass,puntos_arma,puntos_melee,puntos_rango)
  self.entidades=entidades
  
  self.entidades:add_obj("enemigos",self)
  
  
  self.estados={libre=true,moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false}
  
  self.creador=creador
  
  --estadisticas
  
  self.hp=hp
  self.velocidad=velocidad
  self.max_ira=ira
  self.ira=0
  self.radio=0
  
  
  --cuerpo
  
  self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setFixedRotation(true)

	self.shape=py.newPolygonShape(polygon)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setGroupIndex( -self.creador )
	self.fixture:setUserData( {data="enemigos",obj=self, pos=6} )
	self.fixture:setDensity(0)
	self.collider:setInertia( 0 )

	self.ox,self.oy=self.collider:getX(),self.collider:getY()
  
  self.collider:setAngle(self.radio)
  
  --armas
  
  self.points={}

	for _,p in ipairs(puntos_arma) do
		local t={}

		t.shape=py.newCircleShape(p.x,p.y,4)
		t.fixture=py.newFixture(self.collider,t.shape)
		t.fixture:setSensor( true )
		t.fixture:setGroupIndex( -self.creador )
		t.fixture:setUserData( {data="brazos_enemigo",obj=self, pos=8}  )
		t.fixture:setDensity(0)

		table.insert(self.points,t)
	end
  
  self.shape_vision=py.newCircleShape(puntos_rango.x,puntos_rango.y,puntos_rango.r)
	self.fixture_vision=py.newFixture(self.collider,self.shape_vision)
	self.fixture_vision:setSensor( true )
	self.fixture_vision:setGroupIndex( -self.creador )
	self.fixture_vision:setUserData( {data="vision_enemigo",obj=self, pos=7}  )
	self.fixture_vision:setDensity(0)
  
  self:reset_mass(mass)
  
  self.max_acercamiento=puntos_rango.max_acercamiento
  self.presas={}
  
  --
  
  self.d_x,self.d_y=0,0
  
  
  
end

function modelo_enemigo:reset_mass(mass)
	self.collider:resetMassData()
	self.collider:setMass(mass)
	self.mass=self.collider:getMass()


	self.collider:setLinearDamping(mass/20)
end


function modelo_enemigo:update(dt)
  
  
  if not self.estados.libre then
    --si hace algo
    
    if #self.presas>0 then
      local el,ex,ey = self:caza() --busqueda al mas cercano
        --acercarse
        if el> self.max_acercamiento then
          local radio_seguir=math.atan2(self.oy-ey, self.ox-ex)
          self:perseguir(radio_seguir,dt)
          
        end
      
    elseif #self.presas==0 and self.d_x~=0 and self.d_y~=0 then
      
      
      self:perseguir_hasta(dt)
       
    end
    
    
  else
    --si no hace algo
    
  end
  
  
  self.collider:setAngle(self.radio)
  self.ox,self.oy=self.collider:getX(),self.collider:getY()
end

function modelo_enemigo:caza()
  local longitud_buscada= 999999
  local x_buscado, y_buscado= 0,0
  for i, presa in ipairs(self.presas) do
    local dx,dy=presa.ox,presa.oy
    
    local rx,ry = dx-self.ox,dy-self.oy
    
    local longitud = math.sqrt(rx*rx,ry*ry)
    
    if longitud < longitud_buscada then
      longitud_buscada = longitud
      x_buscado, y_buscado= dx,dy
    end
  end
  
  return longitud_buscada,x_buscado,y_buscado
end

function modelo_enemigo:perseguir_hasta(dt)
  local distancia = (self.d_x - self.ox)^2 + (self.d_y - self.oy)^2
  
  if distancia <self.max_acercamiento then
    self.d_x,self.d_y = 0,0
    self.estados.libre=true
  else
  
    local radio_seguir_hasta = math.atan2(self.oy-self.d_y,self.ox-self.d_x)
    self:perseguir(radio_seguir_hasta,dt)

  end
end

function modelo_enemigo:perseguir(radio,dt)
  local x,y= math.cos(radio),math.sin(radio)
  
  local mx,my=x*self.mass*self.velocidad*dt,y*self.mass*self.velocidad*dt
  local vx,vy=self.collider:getLinearVelocity()
    
  self.radio=radio-math.pi/2

  if vx<self.velocidad or vy<self.velocidad then
    self.collider:applyLinearImpulse(-mx,-my)
  end
end

function modelo_enemigo:dar_posicion(bala)
  self.d_x,self.d_y=bala.inicial_x,bala.inicial_y
  self.estados.libre=false
end



function modelo_enemigo:rastrear()
  
end

function modelo_enemigo:giro()
  
end

function modelo_enemigo:mover()
  
end

function modelo_enemigo:nueva_presa(obj)
  if #self.presas==0 then
    table.insert(self.presas,obj)
    print("ingresado de 0")
    self.estados.libre=false
  else
    for _, presa in ipairs(self.presas) do
      if presa~= obj then
        table.insert(self.presas,obj)
        print("ingresado")
      end
    end
  end
end

function modelo_enemigo:eliminar_presa(obj)
  for i, presa in ipairs(self.presas) do
    if presa== obj then
      table.remove(self.presas,i)
      print("removido")
    end
  end
  
  if #self.presas==0 then
    self.estados.libre=true
  end
end

return modelo_enemigo

--[[
haciendo algo
	si es por daño a distancia
		seguir punto inicial por cierto tiempo 
		sino volver a (sin hacer nada)

	si es por vision
		seguir al enemigo hasta que salga del rango (hasta unos segundos despues)
		
		si choca una roca buscar una manera de sortearla, sino volver a sin hacer nada
	

sin hacer nada

	buscar enemigos
		Caminar en forma aleatoria sin chocar con los objetos
		si encuentra algo( hace hago)

]]