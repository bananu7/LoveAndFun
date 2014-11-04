function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  local pixelcode = [[
      vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
      {
          vec4 texcolor = Texel(texture, texture_coords);
          //return texcolor * color;
          //color *= clamp(screen_coords.x / 600, 0, 1);
          //color *= clamp(abs(screen_coords.x-400) / 200, 0, 1);
          //color *= clamp(abs(screen_coords.y-300) / 150, 0, 1);
          
          float x = screen_coords.x - 400;
          float y = screen_coords.y - 300;
          float len = sqrt(x*x + y*y);
          color *= clamp(len / 200, 0, 1);
          
          return color;
      }
  ]]

  local vertexcode = [[
      vec4 position( mat4 transform_projection, vec4 vertex_position )
      {
          return transform_projection * vertex_position;
      }
  ]]

  shader = love.graphics.newShader(pixelcode, vertexcode)
end

function love.update(dt)

end

function love.keypressed(k)
   if k == 'escape' then
      love.event.quit()
   end
end

circles = { }
nextColor = { 255, 255, 255 }

function randomColor()
  return { 
    math.random(0,255),
    math.random(0,255),
    math.random(0,255),
    255
  }
end

function love.mousereleased(x, y, button)
  local color = nextColor
  circles[#circles + 1] = { x = x, y = y, color = color }
  
  nextColor = randomColor()
end


function love.draw()
  love.graphics.setShader(shader)
  
  --love.graphics.setColor(20,255,0,128)
  --love.graphics.print("Hello Ruda", 100, 100)
  
  local x = love.mouse.getX() 
  local y = love.mouse.getY()
  love.graphics.setColor(nextColor)
  love.graphics.circle("fill", x, y, 10, 10)
  
  for _,circle in ipairs(circles) do
    love.graphics.setColor(circle.color)
    love.graphics.circle("fill", circle.x, circle.y, 10, 10)
  end
  
  -- graphlines
  for i=1,#circles-1 do
    for j=i,#circles do
      local a = circles[i]
      local b = circles[j]
      local c = {
        (a.color[1] + b.color[1]) / 2,
        (a.color[2] + b.color[2]) / 2,
        (a.color[3] + b.color[3]) / 2,
        255
      }
      love.graphics.setColor(c)
      love.graphics.line(a.x, a.y, b.x, b.y)
    end
  end
end
