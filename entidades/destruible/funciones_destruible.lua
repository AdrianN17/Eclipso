local funciones_destruible={}

function funciones_destruible:crear_destruible(obj,poligono)

  local val_cierra = true

  local x1,y1=poligono[1],poligono[2]
  local x2,y2=poligono[#poligono-1],poligono[#poligono]

  if x1==x2 and y1==y2 then
    val_cierra = false
  end

	obj.collider=py.newBody(obj.entidades.world,0,0,"kinematic")
  obj.shape=py.newChainShape( val_cierra,poligono  )
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



  local mesh = love.graphics.newMesh(#vcoords, "triangles", "static")
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
  end
end


function funciones_destruible:validar_distancia_poligono(poligono_maestro)

  local poligono = poligono_maestro
  
  local x1=poligono[1]
  local y1=poligono[2]

  local destruibles_tabla={}


  for i=3,#poligono,2 do

    x2,y2 = poligono[i],poligono[i+1]
    
    local d1 = math.pow(x2-x1,2)
    local d2 = math.pow(y2-y1,2)
    local distance = math.sqrt(d1+d2)

    x1,y1=x2,y2
    
    if distance <= 10 then
      table.insert(destruibles_tabla,i)
      table.insert(destruibles_tabla,i+1)
    end
  end

  for i=#destruibles_tabla,1,-1 do
    table.remove(poligono,destruibles_tabla[i])
  end

  if #poligono >=6 then

    return poligono
  else 
    return nil
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

return funciones_destruible