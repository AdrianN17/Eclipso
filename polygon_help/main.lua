
function love.load()

	image = love.graphics.newImage("animales_marinos.png")
	quad = love.graphics.newQuad(525, 26, 350, 286,image:getDimensions())

	scale= 0.5

	ox,oy=400,400

	points={}

end

function love.mousepressed(x,y,button)
	table.insert(points,{x,y})
end

function love.keypressed(key)
	if key=="t" then
		points={}
	end

	if key=="g" then
		for i, p in ipairs(points) do
			print(p[1] - ox  .. " , " ..  p[2] - oy)
		end
	end
end

function love.draw()
	local x,y,w,h = quad:getViewport( )
  
  	love.graphics.draw(image,quad,ox,oy,0,scale,scale,w/2,h/2)

  	for i, p in ipairs(points) do
  		love.graphics.circle("fill", p[1], p[2], 2)
  	end
end