local img_balas_cliente = {}

function img_balas_cliente:dibujar_bala(obj,spritesheet)
	local x,y,w,h = spritesheet[obj.tipo]:getViewport( )
  
  	lg.draw(spritesheet.image,spritesheet[obj.tipo],obj.ox,obj.oy,0,spritesheet.scale,spritesheet.scale,w/2,h/2)
end

return img_balas_cliente