local Class= require "libs.hump.class"

local img_personajes_cliente = require "entidades.solo_cliente.img_personajes_cliente"

local molde_personaje= Class{}

function molde_personaje:init(entidades,x,y,personaje,escudo,nombre)
	self.entidades=entidades

	self.tipo=personaje
    self.tipo_escudo=escudo
    self.spritesheet=self.entidades.img_personajes[personaje]
    self.spritesheet_escudo=self.entidades.img_escudos

    local area=35

    self.collider=py.newBody(self.entidades.world,x,y,"dynamic")
	self.collider:setFixedRotation(true)

	self.shape=py.newCircleShape(area)
	self.fixture=py.newFixture(self.collider,self.shape)
	self.fixture:setDensity(0)
	self.collider:setInertia( 0 )

	self.ox_o,self.oy_o=self.collider:getX(),self.collider:getY()


    self.vx,self.vy=0,0
    self.ox,self.oy=self.ox_o,self.oy_o
    self.radio=0
    self.hp=100
    self.ira=ira
    self.iterator=1
    self.iterator_2=1
    self.nombre=nombre

    self.estados={}


end

function molde_personaje:update(dt)
	self.collider:setLinearVelocity(self.vx,self.vy)
end

function molde_personaje:draw()
	img_personajes_cliente:tipos(self.tipo,self,self.spritesheet,self.spritesheet_escudo)

end



return molde_personaje