function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  --love.graphics.setDefaultFilter("nearest", "nearest", 0)
  
  font = love.graphics.newFont("consolas.ttf", 16)
  
  shipSprite = love.graphics.newImage("images/ship.png")
  shipUpSprite = love.graphics.newImage("images/ship_eng_up.png")
 
  position = { x = 400, y = 500 }
  rotation = 0
  velocity = { x = 0, y = 0 }
  
  engineOn = false
  fuel = 500
  
  -- constants
  fuelPerSecond = 50
  gravity = -9.81
  engineThrust = 20 -- per second
  
  terrain = generateTerrain()
end

math.random = love.math.random

function love.keypressed(key)
  if key == 'escape' then
      love.event.quit()
  end
end

function love.update(dt)
  engineOn = love.keyboard.isDown(' ')
  --[[
  local actEngineTrust = Point(-math.cos(rotation) * engineTrust,
                               -math.sin(rotation) * engineTrust)
  local temp = (gravity + actEngineTrust) * dt
  position = posistion + dt*(velocity + temp/2)
  velocity = velocity + temp
  ]]
  -------
  
  if love.keyboard.isDown('right') then
    rotation = rotation + 0.5 * dt
  end
  if love.keyboard.isDown('left') then
    rotation = rotation - 0.5 * dt
  end
  
  position.x = position.x + velocity.x * dt
  position.y = position.y + velocity.y * dt
  
  if engineOn then
    velocity.x = velocity.x - math.cos(rotation + math.pi/2) * engineThrust * dt
    velocity.y = velocity.y + math.sin(rotation + math.pi/2) * engineThrust * dt
    
    fuel = fuel - fuelPerSecond * dt
  end
  
  velocity.y = velocity.y + gravity*dt
  
  -- end condition  
  for i=1,#terrain do
    if terrain[i][1] > position.x then
      local x1 = terrain[i-1][1]
      local x2 = terrain[i][1]
      local y1 = terrain[i-1][2]
      local y2 = terrain[i][2]
      
      local e = (position.x - x1) / (x2 - x1)
      local ty = (y2 - y1) * e + y1
      
      if (position.y-15) <= ty then
        engineOn = false
        love.update = function () end
      end
      
     break
    end
  end
end

function generateTerrain()
  segments = { }
  
  table.insert(segments, { 0, 100 })
  
  local x = 0
  while true do
    local plane = math.random(0,1)
    local lastX = segments[#segments][1]
    local lastY = segments[#segments][2]
    
    if plane == 1 then
      table.insert(segments, { lastX + 50, lastY })
      x = x + 50
    else
      local yDiff = math.random(-30, 30)
      table.insert(segments, { lastX + 10, lastY + yDiff })
      x = x + 10
    end
    
    if x > 800 then break end
  end
  
  return segments
end

function drawTerrain(terrain)
  love.graphics.setColor(180, 180, 180, 255)
  
  for i=1, #terrain-1 do
    love.graphics.line(terrain[i][1], 600-terrain[i][2], terrain[i+1][1], 600-terrain[i+1][2])
  end
end

function love.draw()
  local sprite
  if engineOn then
    sprite = shipUpSprite
  else
    sprite = shipSprite
  end

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(sprite, position.x, 600-position.y, rotation, 1, 1, 16, 10)
  
  drawTerrain(terrain)
  
  love.graphics.setColor(30, 250, 30, 255)
  love.graphics.setFont(font);
  love.graphics.print("Fuel:     " .. tostring(fuel), 10, 10)
  love.graphics.print("Velocity: " .. tostring(velocity.y), 10, 30)
  love.graphics.print("Rotation: " .. tostring(rotation), 10, 50)
end
