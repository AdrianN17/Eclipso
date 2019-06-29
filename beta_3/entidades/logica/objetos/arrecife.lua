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
      
      --mesh
      --table.insert(vertices,{data.x,data.y-y,0,1,255, 255, 255})
    end
  else
    self.poligono = polygon
  end
  
  
  
	self.entidades:add_obj("destruible",self)
  
  self.collider=py.newBody(self.entidades.world,0,0,"kinematic")
  self.shape=py.newChainShape( true,self.poligono  )
	self.fixture=py.newFixture(self.collider,self.shape)
  
  self.fixture:setUserData( {data="destruible",obj=self, pos=10} )
  
  --self.mesh= lg.newMesh(vertices, "fan")
  --self.mesh:setTexture(img.objetos["image"])
  
  
  modelo_destruccion_otros.init(self,"destruible")
  
  self.otro_poligono=nil
end

function arrecife:update(dt)
  if self.otro_poligono then
    self:nuevo_poligono(self.otro_poligono)
  end
  
  --[[local lista = self.collider:getContacts( )

  for i, contact in ipairs(lista) do
    local fix1,fix2=contact:getFixtures()
    
    if fix1 and fix2 then
      if fix1:getUserData().data == "destruible" and fix2:getUserData().data == "bala" then
        local x1, y1, x2, y2 = contact:getPositions( )
        
        if x1 and y1 then
          local poly = self:poligono_recorte(x1,y1)
          
          local obj = fix2:getUserData()
          
          
          obj.obj:remove()
          
          self:nuevo_poligono(poly)
        end
      end
    end
    
  end]]
end

function arrecife:draw()
  --lg.draw(self.mesh, self.ox,self.oy)
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

return arrecife