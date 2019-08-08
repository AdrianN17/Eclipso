local Class= require "libs.hump.class"
local suit=require "libs.suit"
local Cliente=require "entidades.cliente"
local cliente_alterno = require "entidades.cliente_alterno"

local slab = require "libs.slab"

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

	self.alerta_1=false
	self.alerta_2=false

	slab.Initialize()

end

function entrar_lan:draw( )
	self.gui:draw()
	slab.Draw()
end

function entrar_lan:update(dt)

	self:update_alterno(dt)
	slab.Update(dt)

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
		self.udp_cliente:close()
		Gamestate.switch(Menu)
	end

	if #self.registro_server>0 then


		slab.BeginWindow('Lista_servidores', {Title = "Lista de servidores",X=self.center.x+100,Y=self.center.y-200,W=300 , AutoSizeWindow = false, AllowMove=false,AllowResize = false})

		  slab.BeginListBox('lista_servers')
		    for i, dato in ipairs(self.registro_server) do
		        slab.BeginListBoxItem('server' .. i, {Selected = Selected == i})
		        slab.Text(i .. " Mapa : " .. dato.mapa .. " | Cantidad : " .. dato.max_jugadores .. "/" .. dato.can_jugadores)

		        if slab.IsListBoxItemClicked() then
					self:elegir_servidor(dato)
				end

		        slab.EndListBoxItem()
		    end
		  slab.EndListBox()

  		slab.EndWindow()

	else
		--logo cargando
		self.gui:Label("Cargando .... " , self.center.x+150,self.center.y,100,30)
	end


	if self.alerta_1 then
		slab.BeginWindow('Excepcion_1', {Title = "Servidor Lleno",X=self.center.x-25,Y=self.center.y-25, AllowMove=false})
			if slab.Button("Ok") then
				self.alerta_1=false	
			end	
	    slab.EndWindow()
	end

	if self.alerta_2 then
		slab.BeginWindow('Excepcion_2', {Title = "Juego Iniciado",X=self.center.x-25,Y=self.center.y-25, AllowMove=false})
			if slab.Button("Ok") then
				self.alerta_2=false	
			end	
	    slab.EndWindow()
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

function entrar_lan:elegir_servidor(dato)
	if self.input_nickname.text=="" then
		self.input_nickname.text="player"
	end

	local nickname=self.input_nickname.text
	local personaje=self.tabla_personajes[self.personajes]
	local ip=dato.ip

	local max_players = tonumber(dato.max_jugadores)
	local max_players_now = tonumber(dato.can_jugadores)

	local jugando = dato.jugando

	if max_players - max_players_now > 0 then

		if jugando =="espera" then

			self.udp_cliente:close()
			
			Gamestate.switch(Cliente,nickname,personaje,ip)

		else
			self.alerta_2=true
		end

	else
		self.alerta_1=true
	end
end

return entrar_lan