local mesh_destruible = {}

function mesh_destruible:generar_mesh(objs,texturas)
	local lista = {}

	for _,destruible in ipairs(objs) do
		local t = {}

		local ok, res = pcall(function () 
			t.mesh = self:poly2mesh(destruible.poligono)
  			t.mesh:setTexture(texturas[destruible.tipo])
  			table.insert(lista,t)
  		end)

  		if not ok then
  			print("error con triangulacion mesh-cliente")
  		end
	end

	return lista
end

function mesh_destruible:poly2mesh(points)
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

return mesh_destruible