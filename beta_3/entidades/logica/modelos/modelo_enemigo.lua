local Class = require "libs.hump.class"
local modelo_destruccion_otros  = require "entidades.logica.modelos.modelo_destruccion_otros"

local modelo_enemigo = Class{
  __includes = {modelo_destruccion_otros}
}

function modelo_enemigo:init(entidades,x,y,creador,hp,velocidad,ira,polygon,mass,puntos_arma,puntos_melee,puntos_rango,objeto_balas,tiempo_max_recarga,rastreo_paredes,dano_melee)
  self.entidades=entidades
  
  self.entidades:add_obj("enemigos",self)
  
  
  self.estados={libre=true,moviendo=false,congelado=false,quemadura=false,paralisis=false,protegido=false,atacando=false,atacado=false,dash=false,vivo=true,recargando=false,colision=false}
  
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

  if puntos_arma then
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
  end
  
  self.melee={}
  
  if puntos_melee then
    for _,p in ipairs(puntos_melee) do
      local t={}
      t.shape=py.newCircleShape(p.x,p.y,p.r)
      t.fixture=py.newFixture(self.collider,t.shape)
      t.fixture:setSensor( true )
      t.fixture:setGroupIndex( -self.creador )
      t.fixture:setUserData( {data="melee",obj=self, pos=8}  )
      t.fixture:setDensity(0)

      table.insert(self.melee,t)
    end
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
  
  self.tiempo_nohacer=0
  
  self.raycast={
    x=self.ox,
    y=self.oy,
    w=self.ox+math.cos(self.radio-math.pi/2)*self.max_acercamiento*2,
    h=self.oy+math.sin(self.radio-math.pi/2)*self.max_acercamiento*2
  }
  
  self.time_raycast=0
    
  self.funcion_raycast = function(fixture, x, y, xn, yn, fraction)
    
    local tipo_obj=fixture:getUserData().data
    
    if tipo_obj == "objeto" then
      
        self.estados.colision=true
        
        self.estados.libre=true
        
    end
    
    return 1
    
  end
  
  self.tiempo_busqueda=0
  
  self.objeto_balas=objeto_balas
  self.tiempo_balas=100
  
  self.tiempo_max_recarga=tiempo_max_recarga
  self.tiempo_recarga=0
  
  self.distancia_permitida=self.max_acercamiento*2.5
  
  self.rastreo_paredes=rastreo_paredes
  
  self.dano_melee=dano_melee
  
  modelo_destruccion_otros.init(self,"enemigos")
  
end

function modelo_enemigo:reset_mass(mass)
	self.collider:resetMassData()
	self.collider:setMass(mass)
	self.mass=self.collider:getMass()


	self.collider:setLinearDamping(mass/20)
end


function modelo_enemigo:update(dt)

  
  self.time_raycast=self.time_raycast+dt
  
  if self.time_raycast>0.1 then
    
    self.estados.colision=false
    
    self:cambiar_raycast()
    
    
    self.entidades.world:rayCast(self.raycast.x, self.raycast.y, self.raycast.w, self.raycast.h, self.funcion_raycast)
    
    self.time_raycast=0
  end
  
  if not self.estados.libre and not self.estados.colision then
    --si hace algo
    
    if #self.presas>0 then
      self.estados.atacando=true
      
      if self.objeto_balas then
        self:realizar_disparo(dt)
      end
      
      local erx,ery,ex,ey = self:caza() --busqueda al mas cercano
      
      local radio_seguir=math.atan2(self.oy-ey, self.ox-ex)
      
      self.rx_len,self.ry_len=erx,ery
        --acercarse
        if erx > self.distancia_permitida or ery > self.distancia_permitida then
          
          
          self:perseguir(radio_seguir,dt)
          
        end
        
      self.radio=radio_seguir-math.pi/2
      
    elseif #self.presas==0 and self.d_x~=0 and self.d_y~=0 then
      
      
      self:perseguir_hasta(dt)
       
    end
    
    
  elseif self.estados.libre then 
    --si no hace algo
    
    self.tiempo_nohacer=self.tiempo_nohacer+dt
    
    if self.tiempo_nohacer>1.5 then
      
      self.radio=math.rad(lm.random( 0, 36 )*10)
      
      self.tiempo_nohacer=0
    end
    
    if not self.estados.colision then
      
      
      self.tiempo_busqueda=self.tiempo_busqueda+dt
      
      if self.tiempo_busqueda > 2 and self.tiempo_busqueda < 5 then
        self:mover_hasta_punto(dt)
      elseif self.tiempo_busqueda > 5 then
        self.tiempo_busqueda=0
      end
        
    end
  end
  
  self.collider:setAngle(self.radio)
  self.ox,self.oy=self.collider:getX(),self.collider:getY()
  
  --recargar
  
  if self.objeto_balas then
    if self.objeto_balas.stock < 1 then
      self:recargar(dt)
    end
  end
  
  self:update_animation(dt)
  
  --eliminar
  
  if self.hp<1 then
    self:remove()
  end
  
end

function modelo_enemigo:caza()
  local rx_len,ry_len=9000,9000
  local x_buscado, y_buscado= 0,0
  for i, presa in ipairs(self.presas) do
    local dx,dy=presa.ox,presa.oy
    
    local rx,ry = dx-self.ox,dy-self.oy
    
    rx,ry=math.abs(rx),math.abs(ry)
    
    
    if rx < rx_len or ry < ry_len then
      rx_len,ry_len=rx,ry
      x_buscado, y_buscado= dx,dy
    end
  end
  
  return rx_len,ry_len,x_buscado,y_buscado
end

function modelo_enemigo:perseguir_hasta(dt)
  local distancia = (self.d_x - self.ox)^2 + (self.d_y - self.oy)^2
  
  if distancia <self.max_acercamiento then
    self.d_x,self.d_y = 0,0
    self.estados.libre=true
  else
  
    local radio_seguir_hasta = math.atan2(self.oy-self.d_y,self.ox-self.d_x)
    
    self.radio=radio_seguir_hasta-math.pi/2
    
    self:perseguir(radio_seguir_hasta,dt)

  end
end

function modelo_enemigo:perseguir(radio,dt)
  local x,y= math.cos(radio),math.sin(radio)
  
  local mx,my=x*self.mass*self.velocidad*dt,y*self.mass*self.velocidad*dt
  local vx,vy=self.collider:getLinearVelocity()
    
  

  if vx<self.velocidad or vy<self.velocidad then
    self.collider:applyLinearImpulse(-mx,-my)
  end
end

function modelo_enemigo:dar_posicion(bala)
  self.d_x,self.d_y=bala.inicial_x,bala.inicial_y
  self.estados.libre=false
end

function modelo_enemigo:nueva_presa(obj)
  if #self.presas==0 then
    table.insert(self.presas,obj)
    
    self.estados.libre=false
    self.tiempo_nohacer=0
    self.tiempo_busqueda=0
  else
    for _, presa in ipairs(self.presas) do
      if presa~= obj then
        table.insert(self.presas,obj)
        
      end
    end
  end
end

function modelo_enemigo:eliminar_presa(obj)
  for i, presa in ipairs(self.presas) do
    if presa== obj then
      table.remove(self.presas,i)
      
    end
  end
  
  if #self.presas==0 then
    self.estados.libre=true
    self.estados.atacando=false
    self.tiempo_balas=0
    
  end
end

function modelo_enemigo:cambiar_raycast()
  self.raycast.x=self.ox
  self.raycast.y=self.oy
  self.raycast.w=self.ox+math.cos(self.radio-math.pi/2)*self.rastreo_paredes
  self.raycast.h=self.oy+math.sin(self.radio-math.pi/2)*self.rastreo_paredes
end



function modelo_enemigo:mover_hasta_punto(dt)
    
    
  self:perseguir(self.radio+math.pi/2,dt)

  
end

function modelo_enemigo:realizar_disparo(dt)
  self.tiempo_balas=self.tiempo_balas+dt
      
  if self.tiempo_balas>self.objeto_balas.tiempo then
    self:crear_balas(self.objeto_balas)
    
    self.tiempo_balas=0
  end
end

function modelo_enemigo:crear_balas(data)
  local s= self.points[1].fixture:getShape()
  local px,py=self.collider:getWorldPoints(s:getPoint())
  
  
  if data.stock>0 then
    data.bala(px, py, self.entidades, self.radio-math.pi/2,self.creador)
    data.stock=data.stock-1
  end

end

function modelo_enemigo:recargar(dt)
  self.tiempo_recarga=self.tiempo_recarga+dt
  
  if self.tiempo_recarga>self.tiempo_max_recarga then
    self.objeto_balas.stock=self.objeto_balas.max_stock
    self.tiempo_recarga=0
  end
end

function modelo_enemigo:ataque_melee(objeto)
  objeto.hp=objeto.hp-self.dano_melee
end

return modelo_enemigo

--[[
haciendo algo
	si es por dano a distancia
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

--si es posible pasar a una maquina de estado finito 
--mejorar distancia, en vez de math.sqrt hacer una resta de x y y, que el mayor de cualquiera de los 2 decida