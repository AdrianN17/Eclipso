local Class = require "libs.hump.class"
local molde_objetos = require "entidades.animacion.objetos.molde_objetos"
local polybool = require "libs.polygon.polybool"
local modelo_destruccion_otros  = require "entidades.logica.modelos.modelo_destruccion_otros"

local arrecife = Class{
  __includes = {modelo_destruccion_otros} 
}

function arrecife:init(polygon,entidades)
  self.tipo_indice=6
  
  self.entidades=entidades
  
  self.poligono ={}
  local vertices = {}
  
  
  
  if type(polygon[1]) == "table" then
    for _,data in ipairs(polygon) do
      --polygon
      table.insert(self.poligono,data.x)
      table.insert(self.poligono,data.y)
    end
  else
    self.poligono = polygon
  end
  
  
	self.entidades:add_obj("destruible",self)
  
  self.collider=py.newBody(self.entidades.world,0,0,"kinematic")
  self.shape=py.newChainShape( true,self.poligono  )
	self.fixture=py.newFixture(self.collider,self.shape)
  
  self.fixture:setUserData( {data="destruible",obj=self, pos=10} )
  
  
  self.ox,self.oy=self.collider:getX(),self.collider:getY()
  
  --mesh
  for i=1,#self.poligono,2 do
    
    local u,v=1,1
    local x,y=self.poligono[i],self.poligono[i+1]
    
    if x>self.ox then
      u=1
    end
    
    
    if y<self.oy then
      v=1
    end
    
    table.insert(vertices,{x,y,u,v})
  end
  
  
  self.img=lg.newImage("assets/img/textura_1.png")
  
  self.mesh = self:poly2mesh(self.poligono)
  self.img:setWrap("repeat")
  self.mesh:setTexture(self.img)
  
  
  --self.mesh= lg.newMesh(vertices, "triangles", "static")

  --elf.mesh:setTexture(self.img)
  
  
  modelo_destruccion_otros.init(self,"destruible")
  
  self.otro_poligono=nil
end

function arrecife:update(dt)
  if self.otro_poligono then
    self:nuevo_poligono(self.otro_poligono)
  end
end

function arrecife:draw()
  lg.draw(self.mesh)
end

function arrecife:nuevo_poligono(poligono_enemigo)
  
  local nuevo_poligono = polybool(self.poligono, poligono_enemigo, "not")
  
  if #nuevo_poligono<4 then
    for i=1, #nuevo_poligono ,1 do
        arrecife(nuevo_poligono[i],self.entidades)
      
    end
  end
    
  self:remove() 

end

function arrecife:poligono_recorte(x,y)
  local dis=2.5
  self.otro_poligono =  {-5*dis+x,-8.66*dis+y,
  5*dis+x,-8.66*dis+y,
  10*dis+x,0*dis+y,
  5*dis+x,8.66*dis+y,
  -5*dis+x,8.66*dis+y,
  -10*dis+x,0*dis+y}
end

function arrecife:poly2mesh(points)
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

return arrecife