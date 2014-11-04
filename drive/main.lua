Point = require "point"
Matrix = require "matrix"

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  --love.graphics.setDefaultFilter("nearest", "nearest", 0)
 
  carSprite = love.graphics.newImage "images/car.png"
 
  player = {
    x = 500, y = 500,
    v = Point(0,0),
    r = 0, rv = 0,
    tr = 0, -- steering wheel (front wheels) rotation
    mass = 100, --[kg]
    maxTireFriction = 1000, --[N]
    length = 50. -- pixels, length between the rear and front axle
  }
  handbrake = false
  slip = false
  skidmarks = { }
  
  love.graphics.setBackgroundColor(100, 100, 100)
end

function love.keypressed(k)
    if k == 'escape' then
      love.event.quit()
    end
end

function transformToSpace(spaceOrigin, spaceRotation, p)  
  
  local translation = Matrix.translation(spaceOrigin)
  local rotation = Matrix.rotation(spaceRotation - math.pi/2)
  
  local p2 = translation * rotation * p
  return p2
end

function love.update(dt)
  if love.keyboard.isDown("left") then
    player.tr = -2
  elseif love.keyboard.isDown("right") then
    player.tr = 2
  else
    player.tr = 0
  end
  
  if love.keyboard.isDown("up") then
    player.v = player.v + 300 * dt
  end
  if love.keyboard.isDown("down") then
    player.v = player.v - 160 * dt
  end
  
  handbrake = love.keyboard.isDown(' ')
  
  --if player.v < 0 then player.v = 0 end 
  player.v = player.v * 0.99
  
  -- calculate the radius of the circle
  
  -- calculate required turning force
  -- F = dp / dt
  local currV = player.v
  local desiredDirection = player.v:getDirection() + player.tr
  local desiredV = player.v:newByDirectionChange(desiredDirection)
  local deltaV = desiredV - currV
  
  if deltaV:getMagnitude() * player.mass > player.maxTireFriction then
    slip = true
  end
  
  player.r = player.r + player.tr * dt
  
  --player.x = player.x + player.vx * dt
  --player.y = player.y + player.vy * dt
  player.x = player.x - math.cos(player.r) * player.v * dt
  player.y = player.y - math.sin(player.r) * player.v * dt
  
  if handbrake or slip then
    local leftTireMark = transformToSpace(player, player.r, Point(-15, 25))
    local rightTireMark = transformToSpace(player, player.r, Point(15, 25))
    
    table.insert(skidmarks, leftTireMark)
    table.insert(skidmarks, rightTireMark)
  end
end

function love.draw()
  love.graphics.setColor(50,50,50,255)
  for _,mark in ipairs(skidmarks) do
    love.graphics.circle("fill", mark.x, mark.y, 3, 10)
  end
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(carSprite, player.x, player.y, player.r - math.pi/2, 1, 1, 32, 32);
end



