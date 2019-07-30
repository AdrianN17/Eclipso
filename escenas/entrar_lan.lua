local Class= require "libs.hump.class"
local suit=require "libs.suit"
local Cliente=require "entidades.cliente"
local cliente_alterno = require "entidades.cliente_alterno"

local entrar_lan = Class{
	__includes = {cliente_alterno}
}

function entrar_lan:init()

end

function entrar_lan:enter( )
	self.gui = suit.new()

	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2

	self.tabla_personajes={"aegis","solange","xeon","radian"}

	self.input_nickname={text = ""}

	self.max_personajes=#self.tabla_personajes
	self.personajes=1

	self.index=1

	cliente_alterno.init(self)

end

function entrar_lan:draw( )
	self.gui:draw()
end

function entrar_lan:update(dt)

	self:update_alterno(dt)

	self.gui.layout:reset(self.center.x-250,self.center.y-285)
	self.gui.layout:padding(300,20)

	self.gui:Label("Personajes", self.gui.layout:col(120,30))

	self.gui:Label("Servidores", self.gui.layout:col())

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


	self.gui.layout:reset(self.center.x-350,self.center.y+90)
	self.gui.layout:padding(20,20)

	self.gui:Label("Nickname : " ,{align="left"}, self.gui.layout:col(100,30))


	self.gui:Input(self.input_nickname,self.gui.layout:col(150,30))

	self.gui.layout:reset(self.center.x-300,self.center.y+180)
	self.gui.layout:padding(370,20)


	if self.gui:Button("Volver" ,{id=4}, self.gui.layout:col(120,30)).hit then
		Gamestate.switch(Menu)
	end

	if #self.registro_server>0 then
		if self.gui:Button("Unirse" ,{id=5}, self.gui.layout:col()).hit  then
			if self.input_nickname.text=="" then
				self.input_nickname.text="player"
			end

			local nickname=self.input_nickname.text
			local personaje=self.tabla_personajes[self.personajes]
			local ip=self.registro_server[self.index][4]

			local max_players = tonumber(self.registro_server[self.index][2])
			local max_players_now = tonumber(self.registro_server[self.index][3])

			if max_players - max_players_now > 0 then

				self.udp_cliente:close()
				
				Gamestate.switch(Cliente,nickname,personaje,ip)

			end
		end
	end

	self.gui.layout:reset(self.center.x+100,self.center.y+120)
	self.gui.layout:padding(100,20)


	if self.gui:Button("Atras" ,{id=6}, self.gui.layout:col(100,30)).hit then
		if #self.registro_server>0 then
			self.index=self.index-1

			if self.index < 1 then
				self.index=#self.registro_server
			end
		end
	end

	if self.gui:Button("Adelante" ,{id=7}, self.gui.layout:col(100,30)).hit then
		if #self.registro_server>0 then
			self.index=self.index+1

			if self.index > #self.registro_server then
				self.index=1
			end
		end
	end
end

function entrar_lan:textinput(t)
    self.gui:textinput(t)
end

function entrar_lan:keypressed(key)
	self.gui:keypressed(key)
end

function entrar_lan:quit()
	self.udp_cliente:close()
end

return entrar_lan