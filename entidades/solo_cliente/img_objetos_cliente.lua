local img_objetos_cliente = {}

function img_objetos_cliente:dibujar_objetos(obj,spritesheet)
	local x,y,w,h = spritesheet[obj.tipo]:getViewport( )
  
  	lg.draw(spritesheet.image,spritesheet[obj.tipo],obj.ox,obj.oy,obj.radio,spritesheet.scale,spritesheet.scale,w/2,h/2)
end

return img_objetos_cliente