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
  local polypts = love.math.triangulate(points)
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
	lg.draw(obj.mesh)
end

return funciones_destruible