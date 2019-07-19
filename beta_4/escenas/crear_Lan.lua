local Class= require "libs.hump.class"
local suit=require "libs.suit"
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

	self.max_personajes=4
	self.max_mapas=1

	self.personajes=1
	self.mapas=1

	self.tabla_personajes={"aegis","solange","xeon","radian"}
	self.tabla_mapas={"acuaris"}
end

function crear_lan:draw()
	self.gui:draw()
end

function crear_lan:update(dt)
	self.gui:Label("Nickname : " ,{id=1}, self.center.x-50-150,self.center.y+45,100,30)
	self.gui:Input(self.input_nickname, self.center.x-50,self.center.y+45,200,30)

	self.gui:Label("Max Jugadores : " ,{id=2}, self.center.x-50-150,self.center.y+90,100,30)
	self.gui:Input(self.input_jugadores, self.center.x-50,self.center.y+90,50,30)

	self.gui:Label("Max Enemigos : " ,{id=3}, self.center.x-50-150,self.center.y+135,100,30)
	self.gui:Input(self.input_enemigos, self.center.x-50,self.center.y+135,50,30)

	self.gui:Label("Personajes", self.center.x-200,self.center.y-285,100,30)

	self.gui:Label("Mapas", self.center.x+150,self.center.y-285,100,30)

	--botones

	if self.gui:Button("Atras" ,{id=4}, self.center.x-300,self.center.y-50,100,30).hit then
		self.personajes=self.personajes-1

		if self.personajes < 1 then
			self.personajes=self.max_personajes
		end
	end

	if self.gui:Button("Adelante" ,{id=5}, self.center.x-100,self.center.y-50,100,30).hit then
		self.personajes=self.personajes+1

		if self.personajes > self.max_personajes then
			self.personajes=1
		end
	end


	if self.gui:Button("Adelante" ,{id=6}, self.center.x+250,self.center.y-50,100,30).hit then
		self.mapas=self.mapas+1

		if self.mapas > self.max_mapas then
			self.mapas=1
		end
	end

	if self.gui:Button("Atras" ,{id=7}, self.center.x+50,self.center.y-50,100,30).hit then
		self.mapas=self.mapas-1

		if self.mapas < 1 then
			self.mapas=self.max_mapas
		end
	end


	self.gui:Label(tostring(self.personajes), self.center.x-200,self.center.y-150,30,30)

	self.gui:Label(tostring(self.mapas), self.center.x+150,self.center.y-150,30,30)


	if self.gui:Button("Jugar" ,{id=8}, self.center.x-150/2,self.center.y+225,150,50).hit then
		if self.input_nickname.text=="" then
			self.input_nickname.text="player"
		end

		local nickname=self.input_nickname.text
		local max_jugadores=tonumber(self.input_jugadores.text)
		local max_enemigos=self.input_enemigos.text
		local personaje=self.tabla_personajes[self.personajes]
		local mapa = self.tabla_mapas[self.mapas]

		Gamestate.switch(Servidor,nickname,max_jugadores,max_enemigos,personaje,mapa)
	end

	if self.gui:Button("Volver" ,{id=9}, self.center.x-(100/2)+200,self.center.y+225,100,50).hit then
		Gamestate.switch(Menu)
	end
	
end

function crear_lan:textinput(t)
    self.gui:textinput(t)
end

function crear_lan:keypressed(key)
	self.gui:keypressed(key)
end

return crear_lan