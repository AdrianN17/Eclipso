local Class= require "libs.hump.class"
local suit=require "libs.suit"
local Cliente=require "entidades.cliente"

local entrar_lan = Class{}

function entrar_lan:init()

end

function entrar_lan:enter( )
	self.gui = suit.new()

	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2

	self.tabla_personajes={"aegis","solange","xeon","radian"}

	self.input_nickname={text = ""}
	self.input_ip_server={text = ""}

	self.slider_server={value=10,min=0,max=10}

	self.max_personajes=#self.tabla_personajes
	self.personajes=1

end

function entrar_lan:draw( )
	self.gui:draw()
end

function entrar_lan:update(dt)

	self.gui.layout:reset(self.center.x-250,self.center.y-285)
	self.gui.layout:padding(300,20)

	self.gui:Label("Personajes", self.gui.layout:col(120,30))

	if self.gui:Button("Actualizar" ,{id=1}, self.gui.layout:col()).hit then
		
	end

	self.gui.layout:reset(self.center.x-350,self.center.y-50)
	self.gui.layout:padding(100,20)

	if self.gui:Button("Atras" ,{id=2}, self.gui.layout:col(100,30)).hit then
		self.personajes=self.personajes-1

		if self.personajes < 1 then
			self.personajes=self.max_personajes
		end
	end

	if self.gui:Button("Adelante" ,{id=3}, self.gui.layout:col(100,30)).hit then
		self.personajes=self.personajes+1

		if self.personajes > self.max_personajes then
			self.personajes=1
		end
	end


	self.gui.layout:reset(self.center.x-350,self.center.y+60)
	self.gui.layout:padding(20,20)

	self.gui:Label("Nickname : " ,{align="left"}, self.gui.layout:row(120,30))
	self.gui:Label("IP Servidor LAN : " ,{align="left"}, self.gui.layout:row())


	self.gui.layout:reset(self.center.x-200,self.center.y+60)
	self.gui.layout:padding(20,20)

	self.gui:Input(self.input_nickname, self.gui.layout:row(175,30))
	self.gui:Input(self.input_ip_server, self.gui.layout:row())

	self.gui.layout:reset(self.center.x-300,self.center.y+180)
	self.gui.layout:padding(350,20)


	if self.gui:Button("Volver" ,{id=4}, self.gui.layout:col(120,30)).hit then
		Gamestate.switch(Menu)
	end

	if self.gui:Button("Unirse" ,{id=5}, self.gui.layout:col()).hit then
		if self.input_nickname.text=="" then
			self.input_nickname.text="player"
		end

		local nickname=self.input_nickname.text
		local personaje=self.tabla_personajes[self.personajes]
		local ip=self.input_ip_server.text
		
		Gamestate.switch(Cliente,nickname,personaje,ip)
	end

	if self.gui:Slider(self.slider_server, {id=8,vertical = true}, self.center.x,self.center.y-200 ,30,500) then
		self.slider_server.value=math.floor(self.slider_server.value)
	end

end

function entrar_lan:textinput(t)
    self.gui:textinput(t)
end

function entrar_lan:keypressed(key)
	self.gui:keypressed(key)
end

return entrar_lan