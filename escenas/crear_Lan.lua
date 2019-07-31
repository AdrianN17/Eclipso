local Class= require "libs.hump.class"
local suit=require "libs.suit"
local socket = require "socket"

local Servidor=require "entidades.servidor"

local crear_lan= Class{}

function crear_lan:init()
	
end

function crear_lan:enter()
	self.gui = suit.new()

	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2

	self.input_nickname={text = ""}
	self.input_jugadores={text = "8"}
	self.input_enemigos={text = "25"}

	self.personajes=1
	self.mapas=1

	self.tabla_personajes={"aegis","solange","xeon","radian"}
	self.tabla_mapas={"acuaris"}

	self.max_personajes=#self.tabla_personajes
	self.max_mapas=#self.tabla_mapas
end

function crear_lan:draw()
	self.gui:draw()
end

function crear_lan:update(dt)


	self.gui.layout:reset(self.center.x-200,self.center.y-285)
	self.gui.layout:padding(250,20)

	self.gui:Label("Personajes", self.gui.layout:col(100,30))
	self.gui:Label("Mapas", self.gui.layout:col(100,30))


	self.gui.layout:reset(self.center.x-300,self.center.y-50)
    self.gui.layout:padding(75,20)

	if self.gui:Button("Atras" ,{id=1},  self.gui.layout:col(100,30)).hit then
		self.personajes=self.personajes-1

		if self.personajes < 1 then
			self.personajes=self.max_personajes
		end
	end

	if self.gui:Button("Adelante" ,{id=2},  self.gui.layout:col()).hit then
		self.personajes=self.personajes+1

		if self.personajes > self.max_personajes then
			self.personajes=1
		end
	end

	if self.gui:Button("Adelante" ,{id=3}, self.gui.layout:col()).hit then
		self.mapas=self.mapas+1

		if self.mapas > self.max_mapas then
			self.mapas=1
		end
	end

	if self.gui:Button("Atras" ,{id=4}, self.gui.layout:col()).hit then
		self.mapas=self.mapas-1

		if self.mapas < 1 then
			self.mapas=self.max_mapas
		end
	end


	self.gui.layout:reset(self.center.x-250,self.center.y+45)
    self.gui.layout:padding(25,25)


    self.gui:Label("Nickname : ", {align="left"} , self.gui.layout:row(100,30))
    self.gui:Label("Max Jugadores : ", {align="left"} , self.gui.layout:row())
    self.gui:Label("Max Enemigos : ", {align="left"} , self.gui.layout:row())


    self.gui.layout:reset(self.center.x-120,self.center.y+45)
    self.gui.layout:padding(25,25)


	self.gui:Input(self.input_nickname, self.gui.layout:row(175,30))
	self.gui:Input(self.input_jugadores, self.gui.layout:row(50,30))
	self.gui:Input(self.input_enemigos, self.gui.layout:row())


	

	self.gui.layout:reset(self.center.x-200,self.center.y+225)
    self.gui.layout:padding(150,25)


	if self.gui:Button("Jugar" ,{id=5}, self.gui.layout:col(150,50)).hit then
		if self.input_nickname.text=="" then
			self.input_nickname.text="player"
		end

		local nickname=self.input_nickname.text
		local max_jugadores=tonumber(self.input_jugadores.text)
		local max_enemigos=tonumber(self.input_enemigos.text)
		local personaje=self.tabla_personajes[self.personajes]
		local mapa = self.tabla_mapas[self.mapas]


		if max_jugadores~= nil and max_enemigos~= nil then
			if max_jugadores<9 and max_enemigos<51 then
				
				local ip = self:getIP()
				local ok = self:validar_puerto(ip)

				if ok then
					Gamestate.switch(Servidor,nickname,max_jugadores,max_enemigos,personaje,mapa,ip)
				end
			end
		end
		
	end

	if self.gui:Button("Volver" ,{id=6}, self.gui.layout:col()).hit then
		Gamestate.switch(Menu)
	end
	
end

function crear_lan:textinput(t)
    self.gui:textinput(t)
end

function crear_lan:keypressed(key)
	self.gui:keypressed(key)
end

function crear_lan:getIP()
  local s = socket.udp()
  s:setpeername("74.125.115.104",80)
  local ip, _ = s:getsockname()
  s:close()

  return ip
end

function crear_lan:validar_puerto(ip)
	local udp = socket.udp()
	udp:setsockname(ip, 22122)
	local ok = udp:getsockname()
	udp:close()

	return ok
end

return crear_lan