local img_enemigos_cliente = {}

function img_enemigos_cliente:dibujar_enemigo(obj_data,spritesheet)
	local sprite = spritesheet[obj_data.clase][obj_data.tipo]
	local x,y,w,h = sprite[obj_data.iterator]:getViewport( )

    lg.draw(spritesheet[obj_data.clase]["image"],sprite[obj_data.iterator],obj_data.ox,obj_data.oy,obj_data.radio,sprite.scale,sprite.scale,w/2,h/2)
end

return img_enemigos_cliente