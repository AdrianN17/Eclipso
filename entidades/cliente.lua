local Class= require "libs.hump.class"
local Sock = require "libs.sock.sock"
local bitser = require "libs.bitser.bitser"
local gamera = require "libs.gamera.gamera"
local sti = require "libs.sti"
local extra = require "entidades.funciones.extra"
local slab = require "libs.slab"
local machine = require "libs.statemachine.statemachine"
local entidad_cliente = require "entidades.entidad_cliente"

local personajes = {}

personajes.aegis = require "entidades.personajes.aegis"
personajes.solange = require "entidades.personajes.solange"
personajes.xeon = require "entidades.personajes.xeon"
personajes.radian = require "entidades.personajes.radian"

local cliente = Class{
    __includes={entidad_cliente}
}

function cliente:init()
	
end

function cliente:enter(gamestate,nickname,personaje,ip)

	self.center={}
	self.center.x=lg.getWidth()/2
	self.center.y=lg.getHeight()/2

	self.contador_no_game=0
	self.id_player=nil

    self.escala = 0.7
	local x,y=lg.getDimensions( )

	self.tickRate = 1/60
	self.tick = 0

	self.max_enemigos=0
	self.cantidad_actual_enemigos=0


	self.client = Sock.newClient(ip, 22122)

	self.client:setSerialization(bitser.dumps, bitser.loads)


	self.client:enableCompression()

    self.estado_partida=machine.create({
    initial="espera",
    events = {
      {name = "empezando", from = "espera" , to = "inicio"},
      {name = "finalizando" , from = "inicio", to = "fin"}
  }
  })

	entidad_cliente.init(self)

	slab.Initialize()


	self.client:setSchema("player_init_data",
    {
        "id",
        "mapa",
        "actual_players",
        "max_enemigos",
        "radios_objetos",
        "radios_arboles"
    })

    self.client:setSchema("enviar_data_principal",{
        "data_player","data_enemigos","data_nacimientos_enemigos","data_muertes_enemigos"
    })

    self.client:setSchema("nuevo_player",
    {
        "index",
        "personaje",
        "nickname",
        "x",
        "y"
    })

    --servidor a cliente menos el anterior cliente
    self.client:setSchema("recibir_servidor_cliente_1_muchos",{
        "index","tipo","data"
    })

    --servidor envia inputs
    self.client:setSchema("recibir_servidor_cliente_1_1_muchos",{
        "tipo","data"
    })

    self.client:setSchema("recibir_mira_servidor_cliente_1_muchos",{
        "index","rx","ry"
    })

    self.client:setSchema("recibir_mira_servidor_cliente_1_1_muchos",{
        "rx","ry"
    })

    self.client:setSchema("revivir_usuarios",{
        "index",
        "personaje",
        "nickname",
        "creador",
        "ox",
        "oy"
    })

    self.client:on("connect" , function(data)
    	self.client:send("informacion_primaria", {personaje,nickname})
   	end)

    self.client:on("revivir_usuarios", function(data)

        local index = data.index
        local personaje=data.personaje
        local nickname=data.nickname
        local creador= data.creador
        local ox,oy=data.ox,data.oy

        local obj = self:verificar_existencia(index)

        if obj then
            obj.obj = personajes[personaje](self,creador,nickname,ox,oy)
        end
    end)

    self.client:on("enviar_data_principal" , function(data)
  
        if data.data_player then
            self:validar_pos_personajes(data.data_player)
        end

        if data.data_nacimientos_enemigos then
            self:crear_enemigos_nuevos(data.data_nacimientos_enemigos)
        end

        if data.data_enemigos then
            self:validar_pos_enemigos(data.data_enemigos)
        end

        if data.data_muertes_enemigos then
            self:eliminar_enemigos(data.data_muertes_enemigos)
        end
    end)

    self.client:on("recibir_mira_servidor_cliente_1_muchos", function(data) 
        local obj = self:verificar_existencia(data.index)
        if obj then
            obj.obj.rx,obj.obj.ry=data.rx,data.ry
        end
    end)

    self.client:on("recibir_mira_servidor_cliente_1_1_muchos", function(data)
        local obj= self:verificar_existencia(0)

        if obj and obj.obj then
            obj.obj.rx,obj.obj.ry=data.rx,data.ry
        end
    end)

    self.client:on("recibir_servidor_cliente_1_muchos", function(data)

        local obj = self:verificar_existencia(data.index)

        if obj and obj.obj then
            if data.tipo=="keypressed" then
              obj.obj:keypressed(data.data[1])
            elseif data.tipo=="keyreleased" then
              obj.obj:keyreleased(data.data[1])
            elseif data.tipo=="mousepressed" then
              obj.obj:mousepressed(data.data[1],data.data[2],data.data[3])
            elseif data.tipo=="mousereleased" then
              obj.obj:mousereleased(data.data[1],data.data[2],data.data[3])
            end
        end
    end)

    self.client:on("recibir_servidor_cliente_1_1_muchos" , function(data)
        local obj = self:verificar_existencia(0)

        if obj and obj.obj then
            if data.tipo=="keypressed" then
              obj.obj:keypressed(data.data[1])
            elseif data.tipo=="keyreleased" then
              obj.obj:keyreleased(data.data[1])
            elseif data.tipo=="mousepressed" then
              obj.obj:mousepressed(data.data[1],data.data[2],data.data[3])
            elseif data.tipo=="mousereleased" then
              obj.obj:mousereleased(data.data[1],data.data[2],data.data[3])
            end
        end

    end)


   self.client:on("player_init_data", function(data)
   		self.contador_no_game=0

        self.id_player=data.id

        self.max_enemigos=data.max_enemigos
      
        self:nuevo_mapa(data.mapa)


        for i, player in ipairs(data.actual_players) do
        	self:crear_personaje_principal(player.index,player.personaje,player.nickname,player.x,player.y)
        end

        local pl = self:verificar_existencia(self.id_player)
        self.cam:setPosition(pl.obj.ox,pl.obj.oy)

        self:acomodar_radio_objetos(data.radios_objetos)
        self:acomodar_radio_arboles(data.radios_arboles)

    end)

    self.client:on("nuevo_player", function(data)
        self:crear_personaje_principal(data.index,data.personaje,data.nickname,data.x,data.y)
    end)

    self.client:on("desconexion_player",function(index)

        local obj = self:verificar_existencia(index)
        if obj and obj.obj then
            obj.obj:remove_final()
        end
    end)

    self.client:on("remover_player",function(index)
        local obj = self:verificar_existencia(index)
        if obj and obj.obj then
            obj.obj:remove("soy cliente")
        end
    end)

    self.client:on("iniciar_juego",function(data)
        self.estado_partida:empezando()
    end)


    self.client:on("chat_total", function(chat)
        table.insert(self.chat,chat)
        self:control_chat()
    end)

    self.client:on("partida_finalizada", function(data)
        self.jugadores_ganadores=data
        self.estado_partida:finalizando()
    end)
   

  	self.client:connect()

    self.jugadores_ganadores={}

    self.jugadores_ganadores={}

    self.gui_principal_player=require ("assets/gui/" .. personaje .. "/img_gui")

end

function cliente:draw()

    self:draw_entidad()

    lg.print(self.client:getState(), 5, 70)
    lg.print("Ping : " .. self.client:getRoundTripTime(), 200,10)
    lg.print("Numero :" .. tostring(self.id_player) ,20,30)
    
    lg.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

    if self.id_player and  self.estado_partida.current ~= "fin"  then
        self:gui_usuario(self.id_player)
    end

    slab.Draw()


end

function cliente:update(dt)

    dt = math.min (dt, 1/30)

    slab.Update(dt)

    self.client:update()
    
    if not self.id_player then
  
        self.contador_no_game=self.contador_no_game+dt


        if self.contador_no_game > 3 and self.client:getRoundTripTime()> 400 then

          self:conexion_perdida()

        end
    elseif self.id_player and not self.client:isConnected() and self.client:getRoundTripTime()> 400 and self.estado_partida.current == "inicio" then
        self:conexion_perdida()
    elseif self.id_player and not self.client:isConnected() and self.client:getRoundTripTime()> 400 and self.estado_partida.current == "espera" then
        self:conexion_perdida()
    end

  
    if self.client:getState() == "connected" then
        self.tick = self.tick + dt
    end

    if self.tick >= self.tickRate then
        self.tick = 0


        self:update_entidad(dt)

        if #self.chat>0 then

            self.tiempo_chat=self.tiempo_chat+dt   

            if self.tiempo_chat>self.max_tiempo_chat then
              table.remove(self.chat,1)
              self.tiempo_chat=0
            end

        end

        

        if self.id_player and self.estado_partida.current == "inicio" then

            local pl = self:verificar_existencia(self.id_player)

            if pl then
            
                if pl.obj then
                    self.cam:setPosition(pl.obj.ox,pl.obj.oy)

                    pl.obj.rx,pl.obj.ry=self:getXY()

                    self.client:send("recibir_mira_cliente_servidor_1_1",{pl.obj.rx,pl.obj.ry})
                end
            end

            local cx,cy,cw,ch=self.cam:getVisible()
            
            self.client:send("enviar_vista",{cx,cy,cw,ch})

        end
    end

    if self.estado_partida.current == "fin" then
        self:pantalla_score()
    end
end



function cliente:conexion_perdida()
    slab.BeginWindow('Excepcion', {Title = "Conexion fallida",X=self.center.x-25,Y=self.center.y-25, AllowMove=false})
        if slab.Button("Ok") then
            self.client:disconnectNow()

            Gamestate.switch(Menu)
        end 
    slab.EndWindow()
end

function cliente:nuevo_mapa(mapa)
	self.mapa_files=require ("entidades.mapas." .. mapa)
	self.map=sti(self.mapa_files.mapa)



	local x,y=lg.getDimensions( )
    y=y-y/4
	self.map:resize(x/self.escala,y/self.escala)
	self.cam = gamera.new(0,0,self.mapa_files.x,self.mapa_files.y)
	self.cam:setWindow(0,0,x,y)
    self.cam:setScale(self.escala)

	self.img_personajes=require "assets.img.personajes.img_personajes"
	self.img_balas=require "assets.img.balas.img_balas"
	self.img_escudos=require "assets.img.escudos.img_escudos"
	self.img_objetos=self.mapa_files.objetos
	self.img_texturas=self.mapa_files.texturas
	self.img_enemigos=self.mapa_files.enemigos

	self.objetos_enemigos=self.mapa_files.objetos_enemigos

	self:close_map()

	self:map_read(self.map)
	self:custom_layers()
end

function cliente:verificar_existencia(index)
	local obj = nil

	for i,data in ipairs(self.gameobject.players) do
		if data.index==index then
			obj=data
			break
		end
	end

	return obj
end

function cliente:crear_personaje_principal(id,personaje,nickname,x,y)
	t={index=id, obj = personajes[personaje](self,self.id_creador,nickname,x,y)}
    self:add_obj("players",t)
    self:aumentar_id_creador()
end

function cliente:verificar_existencia(index)
	local obj = nil

	for i,data in ipairs(self.gameobject.players) do
		if data.index==index then
			obj=data
			break
		end
	end

	return obj
end

function cliente:validar_pos_personajes(data)
    for _,obj_data in ipairs(data) do
        local obj = self:verificar_existencia(obj_data.index)
        if obj and obj.obj then
            extra:ingresar_datos_personaje(obj.obj,obj_data)
        end
    end
end

function cliente:validar_pos_enemigos(data)
    for _,obj_data in ipairs(data) do
        local obj = self:verificar_existencia_enemigo(obj_data.index)
        if obj then
            extra:ingresar_datos_enemigos(obj,obj_data)
        end
    end
end

function cliente:verificar_existencia_enemigo(index)
    for _,ene in ipairs(self.gameobject.enemigos) do
        if ene.index==index then
            return ene
        end
    end 

    return nil
end

function cliente:acomodar_radio_objetos(data_obj)
    for _,data in ipairs(data_obj) do
        for _,obj in ipairs(self.gameobject.objetos) do
            if data.ox == obj.ox and data.oy == obj.oy then
                obj.collider:setAngle(data.radio)
                obj.radio=data.radio
                break
            end
        end
    end
end

function cliente:acomodar_radio_arboles(data_obj)
    for _,data in ipairs(data_obj) do
        for _,obj in ipairs(self.gameobject.arboles) do
            if data.ox == obj.ox and data.oy == obj.oy then
                obj.radio=data.radio
                break
            end
        end
    end
end

function cliente:crear_enemigos_nuevos(lista)
    for _,enemigo in ipairs(lista) do
        self.objetos_enemigos[enemigo.tipo](self,enemigo.ox,enemigo.oy)
    end
end

function cliente:eliminar_enemigos(lista)
    for _,data in ipairs(lista) do
        for _,obj in ipairs(self.gameobject.enemigos) do
            if obj.index == data.index then
                obj:remove()
                break
            end
        end
    end
end

function cliente:quit()
    self:clear()
    self.client:disconnectNow()
end

function cliente:clear()
  self.map=nil
  self.cam=nil
  self.world:destroy( )
  self.gameobject.players={}
  self.gameobject.balas={}
  self.gameobject.efectos={}
  self.gameobject.destruible={}
  self.gameobject.enemigos={}
  self.gameobject.objetos={}
  self.gameobject.arboles={}
  self.gameobject.inicios={}
end

function cliente:pantalla_score()
  slab.BeginWindow('Fin_juego', {Title = "Juego finalizado",X=self.center.x -250,Y=self.center.y-200 ,W = 500,H = 400, AutoSizeWindow = false, AllowMove=false,Columns = 4, AllowResize = false})

    slab.BeginColumn(1)
    slab.Text("Lista", {CenterX = true})
    slab.Separator()
    for i, player in ipairs(self.jugadores_ganadores) do
        slab.Text(i, {CenterX = true})
    end
    slab.EndColumn()

    slab.BeginColumn(2)
    slab.Text("Nickname", {CenterX = true})
    slab.Separator()
    for i, player in ipairs(self.jugadores_ganadores) do
        slab.Text(player.nickname , {CenterX = true})
    end
    slab.EndColumn()

    slab.BeginColumn(3)
    slab.Text("Kills personaje", {CenterX = true})
    slab.Separator()
    for i, player in ipairs(self.jugadores_ganadores) do
        slab.Text(player.kills_personajes , {CenterX = true})
    end
    slab.EndColumn()

    slab.BeginColumn(4)
    slab.Text("Kills enemigos", {CenterX = true})
    slab.Separator()
    for i, player in ipairs(self.jugadores_ganadores) do
        slab.Text(player.kills_enemigos , {CenterX = true})
    end
    slab.EndColumn()



  if slab.Button("Volver al menu",{ExpandW = true}) then
    self:volver_menu() 
  end 
  slab.EndWindow()
end

function cliente:gui_usuario(index)

  local gui = self.gui_principal_player

  local objeto_player = self:verificar_existencia(index)

  local estado_vida = "muerto"
  local hp = 0
  local bala1=0
  local bala2=0

  local bala1_max=0
  local bala2_max=0

  local recargando = false

  local efecto = "ninguno"

  if objeto_player then
    if objeto_player.obj then
      local obj = objeto_player.obj
      estado_vida="vivo"
      hp = math.floor((obj.hp/obj.max_hp)*100)

      if obj.balas[1] then
        bala1=obj.balas[1].stock
        bala1_max=obj.balas[1].balas_max
      end

      if obj.balas[2] then
        bala2=obj.balas[2].stock
        bala2_max=obj.balas[2].balas_max
      end

        efecto = obj.efecto_tenidos.current

        recargando=obj.estados.recargando

    end
  end

  lg.draw(gui.img_corazon,gui.corazon[estado_vida],self.center.x,self.center.y+180,0,gui.corazon.scale,gui.corazon.scale)
  lg.print(hp .. "%",self.center.x+25,self.center.y+200)

  if gui.bala[1] then
    lg.print(gui.bala[1] .. "  " .. bala1_max .. "/" .. bala1 ,self.center.x+25,self.center.y+260)
  end

  if gui.bala[2] then
    lg.print(gui.bala[2] .. "  " .. bala2_max .. "/" .. bala2 ,self.center.x+25,self.center.y+280)
  end

  lg.print("Estado : " .. efecto,self.center.x+120,self.center.y+200)

  if recargando then
    lg.print("recargando ...." , self.center.x,self.center.y)
  end

end

return cliente