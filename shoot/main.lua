function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
 
  shipSprite = love.graphics.newImage "images/ship.png"
  shipfwd = {
    love.graphics.newImage "images/ship_fwd1.png",
    love.graphics.newImage "images/ship_fwd2.png"
  }
  
  bulletSprite = love.graphics.newImage "images/bullet_green.png"
  asteroidSprite = love.graphics.newImage "images/asteroid_big.png"
  
  -- background
  bg = love.graphics.newImage("images/bg.png")
  -- allow it to span on whole screen
  bg:setWrap('repeat','repeat')
  -- resize to screen size
  screenWidth = love.graphics.getWidth()
  screnHeight = love.graphics.getHeight()
  bgWidth = bg:getWidth()
  bgHeight = bg:getHeight()
  
  imageFrame = love.graphics.newQuad(
    0, 0, screenWidth, screnHeight + bgHeight, bgWidth, bgHeight 
  )
  bgy = 0
  
  player = {
    x = 500, y = 500,
    vx = 0, vy = 0,
  }

  objects = { }
  asteroidTimer = 0
  score = 0
end

function love.keypressed(k)
    if k == 'escape' then
      love.event.quit()
    end
   
    if k == ' ' then
      table.insert(objects, {
            x = player.x,
            y = player.y,
            vx = 0,
            vy = -600,
            sprite = bulletSprite
          })
    end
end

function randomColor()
  return { 
    math.random(0,255),
    math.random(0,255),
    math.random(0,255),
    255
  }
end

function rectCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return (x1 <= x2+w2 and
          x2 <= x1+w1 and
          y1 <= y2+h2 and
          y2 <= y1+h1)
end

function love.update(dt)
  if love.keyboard.isDown("left") then
    player.vx = player.vx - 30
  end
  if love.keyboard.isDown("right") then
    player.vx = player.vx + 30
  end
  if love.keyboard.isDown("up") then
    player.vy = player.vy - 30
  end
  if love.keyboard.isDown("down") then
    player.vy = player.vy + 30
  end
    
  player.x = player.x + player.vx * dt
  player.y = player.y + player.vy * dt
  
  player.vx = player.vx * 0.95
  player.vy = player.vy * 0.95
  
  for _,object in ipairs(objects) do
    object.x = object.x + object.vx * dt
    object.y = object.y + object.vy * dt
    if object.vy < 0 and object.y < 0 then
      object.delete = true
    end
    if object.vy > 0 and object.y > screenWidth then
      object.delete = true
    end
  end
  
  -- spawn asteroids
  if asteroidTimer > 1 then
    asteroidTimer = 0
    table.insert(objects, {
      x = math.random(0, 800),
      y = -100,
      vx = 0,
      vy = 300,
      sprite = asteroidSprite
    })
  end
  asteroidTimer = asteroidTimer + dt
  
  -- check collisions
  for i=1, #objects-1 do
    for j=i+1, #objects do
      local a = objects[i]
      local b = objects[j]
      
      if rectCollision(a.x, a.y, a.sprite:getWidth(), a.sprite:getHeight(),
                       b.x, b.y, b.sprite:getWidth(), b.sprite:getHeight())
      then
        a.delete = true
        b.delete = true
        score = score + 1
      end
    end
  end
  
  -- delete unnecessary objects
  for index,object in ipairs(objects) do
    if object.delete then
      table.remove(objects, index)
    end
  end
  
  bgy = bgy + 30 * dt
  if bgy > bgHeight then
    bgy = bgy - bgHeight
  end
end

function love.draw()  
  love.graphics.draw(bg, imageFrame, 0, math.floor(bgy-bgHeight))
  
  love.graphics.print("Score: " .. tostring(score), 10, 10)
  
  if (player.vy < -20) then
    local r = math.random(1,2)
    love.graphics.draw(shipfwd[r], player.x, player.y, 0, 1);
  else
    love.graphics.draw(shipSprite, player.x, player.y, 0, 1);
  end
  
  for _,object in ipairs(objects) do
    love.graphics.draw(object.sprite, object.x, object.y, 0, 1);
  end
end
