local Class= require "libs.hump.class"
local suit=require "libs.suit"
local Cliente=require "entidades.cliente"
local lista_servidores = require "api.lista_servidores"
local slab = require "libs.slab"
local lista_personajes = require "api.lista_personajes"
local lista_mapas = require "api.lista_mapas"
local lista_paises = require "api.lista_paises"

local entrar_online = Class{}

function entrar_online:init( )
end

function entrar_online:enter( )
	table.insert(lista_mapas,1,"All")
	table.insert(lista_paises,1,"All")

	self.gui = suit.new()

	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2

	self.input_nickname={text = ""}
	self.input_ip_server={text = ""}
	self.input_port_server={text = ""}

	self.slider_server={value=10,min=0,max=10}

	self.tabla_personajes=lista_personajes

	self.max_personajes=#self.tabla_personajes
	self.personajes=1

	self.lista_servidores = {}

	self.pais_buscado="All"
	self.mapa_buscado="All"

	slab.Initialize()
end

function entrar_online:draw( )
	--lg.print(self.personajes,self.center.x-200,self.center.y-150)

	self.gui:draw()
	slab:Draw()
end

function entrar_online:update(dt)

	slab.Update(dt)

	self.gui:Label(tostring(self.personajes),self.center.x-200,self.center.y-150,100,30)

	self.gui.layout:reset(self.center.x-250,self.center.y-285)
	self.gui.layout:padding(300,20)

	self.gui:Label("Personajes", self.gui.layout:col(120,30))

	self.gui.layout:reset(self.center.x-350,self.center.y-50)
	self.gui.layout:padding(100,20)

	if self.gui:Button("Atras" ,{id=1}, self.gui.layout:col(100,30)).hit then
		self.personajes=self.personajes-1

		if self.personajes < 1 then
			self.personajes=self.max_personajes
		end
	end

	if self.gui:Button("Adelante" ,{id=2}, self.gui.layout:col(100,30)).hit then
		self.personajes=self.personajes+1

		if self.personajes > self.max_personajes then
			self.personajes=1
		end
	end


	self.gui.layout:reset(self.center.x-350,self.center.y+60)
	self.gui.layout:padding(20,20)

	self.gui:Label("Nickname : " ,{align="left"}, self.gui.layout:row(140,30))
	self.gui:Label("IP Servidor LAN : " ,{align="left"}, self.gui.layout:row())
	self.gui:Label("Puerto (opcional) : " ,{align="left"}, self.gui.layout:row())


	self.gui.layout:reset(self.center.x-200,self.center.y+60)
	self.gui.layout:padding(20,20)

	self.gui:Input(self.input_nickname, self.gui.layout:row(175,30))
	self.gui:Input(self.input_ip_server, self.gui.layout:row())
	self.gui:Input(self.input_port_server, self.gui.layout:row())


	self.gui.layout:reset(self.center.x-300,self.center.y+240)
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
		local ip = self.input_ip_server.text
		local port = tonumber(self.input_port_server.text)
		
		Gamestate.switch(Cliente,nickname,personaje,ip,port)	
	end


	slab.BeginWindow('Lista_servidores', {Title = "Servidores",X=self.center.x+80,Y=self.center.y-250,W=320, H=400 , AutoSizeWindow = false, AllowMove=false,AllowResize = false})
		slab.Text("Busqueda de servidores: ")

		local pais_seleccionado = ""
		local mapa_seleccionado = ""
		slab.Text("Paises : ")

		slab.SameLine()

		if slab.BeginComboBox("combo_paises", {Selected = self.pais_buscado}) then
			for _, data in ipairs(lista_paises) do
				if slab.TextSelectable(data) then
					self.pais_buscado = data
				end
			end

			slab.EndComboBox()
		end


		slab.Text("Mapas : ")

		slab.SameLine()

		if slab.BeginComboBox("combo_mapas", {Selected = self.mapa_buscado}) then
			for _, data in ipairs(lista_mapas) do
				if slab.TextSelectable(data) then
					self.mapa_buscado = data
				end
			end

			slab.EndComboBox()
		end

		if slab.Button("busqueda_servidores") then
			self.lista_servidores= lista_servidores:listar(self.pais_buscado,self.mapa_buscado)
		end

		slab.Separator()

		slab.Text("Lista de servidores : ")

		slab.BeginListBox("lista_servers", {H=250})

		    for i, dato in ipairs(self.lista_servidores) do
		        slab.BeginListBoxItem('server' .. i, {Selected = Selected == i})

		        slab.Text(i .. " | Nombre : " .. dato.nombre .. " | Pais : " .. dato.pais .. " | Mapa : " .. dato.mapa .. " | Cantidad : " .. dato.max_jugadores .. "/" .. dato.can_jugadores)


		        if slab.IsListBoxItemClicked() then

		        	local nickname=self.input_nickname.text
					local personaje=self.tabla_personajes[self.personajes]

					Gamestate.switch(Cliente,nickname,personaje,dato.ip,tonumber(dato.puerto))
				end

		        slab.EndListBoxItem()
		    end
		slab.EndListBox()


	slab.EndWindow()



end

function entrar_online:textinput(t)
    self.gui:textinput(t)
end

function entrar_online:keypressed(key)
	self.gui:keypressed(key)
end

return entrar_online