local vector= require "libs.hump.vector"

local funciones_destruible={}

function funciones_destruible:crear_destruible(obj,poligono)

	obj.collider=py.newBody(obj.entidades.world,0,0,"kinematic")
  obj.shape=py.newChainShape( true,poligono  )
	obj.fixture=py.newFixture(obj.collider,obj.shape)

  obj.poligono=poligono
  
  obj.fixture:setUserData( {data="destruible",obj=obj, pos=10} )
  
  obj.ox,obj.oy=obj.collider:getX(),obj.collider:getY()
end

function funciones_destruible:crear_mesh(obj,poligono)
	  obj.mesh = self:poly2mesh(poligono)
  	obj.mesh:setTexture(obj.texturas[obj.tipo])
end

function funciones_destruible:poly2mesh(points)
  local polypts = lm.triangulate(points)
  local tlist

  local vnums = {}
  local vcoords = {}
  do
    local verthash = {}
    local n = 0
    local v
    -- use unique vertices by using a coordinate hash table
    for i = 1, #polypts do
      for j = 1, 3 do
        local px = polypts[i][j * 2 - 1]
        local py = polypts[i][j * 2]
        if not verthash[px] then
          verthash[px] = {}
        end
        if not verthash[px][py] then
          n = n + 1
          verthash[px][py] = n
          vcoords[n * 2 - 1] = px
          vcoords[n * 2] = py
          v = n
        else
          v = verthash[px][py]
        end
        vnums[(i - 1) * 3 + j] = v
      end
    end
  end



  local mesh = lg.newMesh(#vcoords, "triangles", "static")
  for i = 1, #vcoords / 2 do
    local x, y = vcoords[i * 2 - 1], vcoords[i * 2]

    -- Here's where the UVs are assigned
    mesh:setVertex(i, x, y, x / 50, y / 50)
  end
  mesh:setVertexMap(vnums)
  return mesh
end

function funciones_destruible:dibujar_texturas(obj)
  if obj.mesh then
	 lg.draw(obj.mesh)
  else
    love.graphics.polygon("fill", obj.collider:getWorldPoints(obj.shape:getPoints()))
  end
end

function funciones_destruible:get_area_poligono(poligono)
  local area = 0

  local x1=poligono[1]
  local y1=poligono[2]
    
  for i=3,#poligono,2 do

      x2,y2 = poligono[i],poligono[i+1]

      local d1 = math.pow(x2-x1,2)
      local d2 = math.pow(y2-y1,2)
      local distance = math.sqrt(d1+d2)
      area = area+distance
  end

  return area
end

function funciones_destruible:poligono_floor(poligono_decimal)
  local poligono = poligono_decimal
  for i=1,#poligono,1 do
    poligono[i] = math.floor(poligono[i])
  end

  return poligono
end


function funciones_destruible:validar_poligono_box2d(poligono)
  local poligono_final=self:poligono_floor(poligono)
  local lista_negra={}

  repeat 
    lista_negra = self:iterador_validador(poligono_final)
    poligono_final = self:descartar_puntos_muertos(poligono_final,lista_negra)
    poligono_final = self:validar_primeros(poligono_final)
    lista_negra = self:iterador_validador(poligono_final)
  until #lista_negra==0

  return poligono_final

end

function funciones_destruible:iterador_validador(poligono)
  local lista={}

  for i=3,#poligono,2 do
    local v1 =  vector.new(poligono[i-2],poligono[i-1])
    local v2 =  vector.new(poligono[i],poligono[i+1])

    local validar = self:distance_squared(v1, v2) 


    if validar > 0.01 then

    else

      table.insert(lista,i)
      table.insert(lista,i+1)
    end
  
  end

  return lista
end

function funciones_destruible:descartar_puntos_muertos(poligono,lista)
  local poligono_final=poligono

  for i=#lista,1,-1 do
    table.remove(poligono_final,lista[i])
  end


  return poligono_final


end

function funciones_destruible:validar_primeros(poligono)
  local mipoligono = poligono

  local v1 =  vector.new(mipoligono[1],mipoligono[2])
  local v2 =  vector.new(mipoligono[#mipoligono-1],mipoligono[#mipoligono])

  local validar = self:distance_squared(v1, v2) 

  if validar > 0.01 then

  else
    table.remove(mipoligono,2)
    table.remove(mipoligono,1)
    
  end 

  return mipoligono

end


function funciones_destruible:distance_squared(a,b)
  local c = a-b
  return self:dot(c,c)
end

function funciones_destruible:dot(a,b)
  return a.x * b.x + a.y * b.y
end

return funciones_destruible
