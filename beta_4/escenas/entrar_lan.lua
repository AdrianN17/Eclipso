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

	self.input_nickname={text = ""}
	--self.input_ip_server={text = ""}

	self.slider_server={value=10,min=0,max=10}

	self.max_personajes=4
	self.max_mapas=1

	self.personajes=1
	self.mapas=1

	self.ip="1234"
end

function entrar_lan:draw( )
	self.gui:draw()
end

function entrar_lan:update(dt)

	self.gui:Label("Nickname : " ,{id=1}, self.center.x-50-150-200,self.center.y+60,100,30)
	self.gui:Input(self.input_nickname, self.center.x-50-200,self.center.y+60,200,30)

	--self.gui:Label("IP Servidor LAN : " ,{id=2}, self.center.x-45-150-200,self.center.y+90,120,30)
	--self.gui:Input(self.input_ip_server, self.center.x-50-200,self.center.y+90,200,30)


	self.gui:Label("Personajes", self.center.x-200-50,self.center.y-285,100,30)

	if self.gui:Button("Atras" ,{id=3}, self.center.x-300-50,self.center.y-50,100,30).hit then
		self.personajes=self.personajes-1

		if self.personajes < 1 then
			self.personajes=self.max_personajes
		end
	end

	if self.gui:Button("Adelante" ,{id=4}, self.center.x-100-50,self.center.y-50,100,30).hit then
		self.personajes=self.personajes+1

		if self.personajes > self.max_personajes then
			self.personajes=1
		end
	end

	if self.gui:Button("Volver" ,{id=5}, self.center.x-(100/2)-350,self.center.y+180,100,50).hit then
		Gamestate.switch(Menu)
	end

	if self.gui:Button("Actualizar" ,{id=6}, self.center.x-(100/2)+250,self.center.y-300,100,50).hit then
		
	end

	if self.gui:Button("Unirse" ,{id=7}, self.center.x-(100/2)+250,self.center.y+200,100,50).hit then
		if self.input_nickname.text=="" then
			self.input_nickname.text="player"
		end
		
		Gamestate.switch(Cliente(self.input_nickname.text,self.personajes.text,self.ip))
	end

	--slider
	if self.gui:Slider(self.slider_server, {id=8,vertical = true}, self.center.x,self.center.y-200 ,30,500) then
		self.slider_server.value=math.floor(self.slider_server.value)
	end
    self.gui:Label(tostring(self.slider_server.value), {align = "left"}, 300,100, 200,30)
end

function entrar_lan:textinput(t)
    self.gui:textinput(t)
end

function entrar_lan:keypressed(key)
	self.gui:keypressed(key)
end

return entrar_lan