local img_personajes_cliente = {}

function img_personajes_cliente:dibujar_personaje(obj_data,spritesheet)
  local x,y,w,h = spritesheet[obj_data.iterator][obj_data.iterator_2]:getViewport( )
    
    lg.draw(spritesheet["image"],spritesheet[obj_data.iterator][obj_data.iterator_2],obj_data.ox,obj_data.oy,obj_data.radio + math.pi/2,
      spritesheet.scale,spritesheet.scale,w/2,h/2)
end

function img_personajes_cliente:dibujar_escudo(obj_data,spritesheet_escudos)
  if obj_data.estados.protegido then
    local x_s,y_s,w_s,h_s = spritesheet_escudos[obj_data.tipo_escudo]:getViewport( )
    lg.draw(spritesheet_escudos["image"],spritesheet_escudos[obj_data.tipo_escudo],obj_data.ox,obj_data.oy,0,spritesheet_escudos.scale,
      spritesheet_escudos.scale,w_s/2,h_s/2)
  end
end

function img_personajes_cliente:dibujar_melee(obj_data,spritesheet)
  if obj_data.estados.atacando_melee then
    local x,y,w,h = spritesheet["melee"]:getViewport( )

   lg.draw(spritesheet["image"],spritesheet["melee"],obj_data.melee_x,obj_data.melee_y,obj_data.radio + math.pi/2,
      spritesheet.scale,spritesheet.scale,w/2,h/2)
  end
end

function img_personajes_cliente:aegis(obj_data,spritesheet,spritesheet_escudo)
	local x,y,w,h = spritesheet[obj_data.iterator][obj_data.iterator_2]:getViewport( )
    
    	lg.draw(spritesheet["image"],spritesheet[obj_data.iterator][obj_data.iterator_2],obj_data.ox,obj_data.oy,obj_data.radio + math.pi/2,
      	spritesheet.scale,spritesheet.scale,w/2,h/2)

    if obj_data.estados.protegido then
	    local x_s,y_s,w_s,h_s = spritesheet_escudos[obj_data.tipo_escudo]:getViewport( )
	    lg.draw(spritesheet_escudos["image"],spritesheet_escudos[obj_data.tipo_escudo],obj_data.ox,obj_data.oy,0,spritesheet_escudos.scale,
	      spritesheet_escudos.scale,w_s/2,h_s/2)
	end

	--self:dibujar_personaje(obj_data,spritesheet)
	--self:dibujar_escudo(obj_data,spritesheet,spritesheet_escudo)
end

function img_personajes_cliente:solange(obj_data,spritesheet,spritesheet_escudo)
	local x,y,w,h = spritesheet[obj_data.iterator][obj_data.iterator_2]:getViewport( )
    
    	lg.draw(spritesheet["image"],spritesheet[obj_data.iterator][obj_data.iterator_2],obj_data.ox,obj_data.oy,obj_data.radio + math.pi/2,
      	spritesheet.scale,spritesheet.scale,w/2,h/2)

    if obj_data.estados.protegido then
	    local x_s,y_s,w_s,h_s = spritesheet_escudos[obj_data.tipo_escudo]:getViewport( )
	    lg.draw(spritesheet_escudos["image"],spritesheet_escudos[obj_data.tipo_escudo],obj_data.ox,obj_data.oy,0,spritesheet_escudos.scale,
	      spritesheet_escudos.scale,w_s/2,h_s/2)
	end

	--self:dibujar_personaje(obj_data,spritesheet)
	--self:dibujar_escudo(obj_data,spritesheet,spritesheet_escudo)
end

function img_personajes_cliente:xeon(obj_data,spritesheet,spritesheet_escudo)

	local x,y,w,h = spritesheet[obj_data.iterator][obj_data.iterator_2]:getViewport( )
    
    	lg.draw(spritesheet["image"],spritesheet[obj_data.iterator][obj_data.iterator_2],obj_data.ox,obj_data.oy,obj_data.radio + math.pi/2,
      	spritesheet.scale,spritesheet.scale,w/2,h/2)

    if obj_data.estados.atacando_melee then
	    local x,y,w,h = spritesheet["melee"]:getViewport( )

	   lg.draw(spritesheet["image"],spritesheet["melee"],obj_data.melee_x,obj_data.melee_y,obj_data.radio + math.pi/2,
	      spritesheet.scale,spritesheet.scale,w/2,h/2)
	  end

    if obj_data.estados.protegido then
	    local x_s,y_s,w_s,h_s = spritesheet_escudos[obj_data.tipo_escudo]:getViewport( )
	    lg.draw(spritesheet_escudos["image"],spritesheet_escudos[obj_data.tipo_escudo],obj_data.ox,obj_data.oy,0,spritesheet_escudos.scale,
	      spritesheet_escudos.scale,w_s/2,h_s/2)
	end

	--self:dibujar_personaje(obj_data,spritesheet)
	--self:dibujar_melee(obj_data,spritesheet)
	--self:dibujar_escudo(obj_data,spritesheet,spritesheet_escudo)
end

function img_personajes_cliente:radian(obj_data,spritesheet,spritesheet_escudo)
	if obj_data.estados.atacando_melee then
	    local x,y,w,h = spritesheet["melee"]:getViewport( )

	   lg.draw(spritesheet["image"],spritesheet["melee"],obj_data.melee_x,obj_data.melee_y,obj_data.radio + math.pi/2,
	      spritesheet.scale,spritesheet.scale,w/2,h/2)
	  end

	local x,y,w,h = spritesheet[obj_data.iterator][obj_data.iterator_2]:getViewport( )
    
    	lg.draw(spritesheet["image"],spritesheet[obj_data.iterator][obj_data.iterator_2],obj_data.ox,obj_data.oy,obj_data.radio + math.pi/2,
      	spritesheet.scale,spritesheet.scale,w/2,h/2)

    if obj_data.estados.protegido then
	    local x_s,y_s,w_s,h_s = spritesheet_escudos[obj_data.tipo_escudo]:getViewport( )
	    lg.draw(spritesheet_escudos["image"],spritesheet_escudos[obj_data.tipo_escudo],obj_data.ox,obj_data.oy,0,spritesheet_escudos.scale,
	      spritesheet_escudos.scale,w_s/2,h_s/2)
	end

	--self:dibujar_melee(obj_data,spritesheet)
	--self:dibujar_personaje(obj_data,spritesheet)
	--self:dibujar_escudo(obj_data,spritesheet,spritesheet_escudo)
end


return img_personajes_cliente