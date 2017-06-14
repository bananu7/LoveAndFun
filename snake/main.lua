function love.load()
  snake = {}
  snake.segments = { {x = 10, y = 10 } }
  snake.len = 1
  snake.dx = 1
  snake.dy = 0
  
  apple = { x = 5, y = 5 }
  
  gridsize = { x = 20, y = 20 }
  tilesize = { x = 20, y = 20 }
  
  -- to slow down
  cnt = 0
end

function love.keypressed(key)
  if key == "up" then
    snake.dx = 0
    snake.dy = -1
  elseif key == "down" then
    snake.dx = 0
    snake.dy = 1
  elseif key == "left" then
    snake.dx = -1
    snake.dy = 0
  elseif key == "right" then
    snake.dx = 1
    snake.dy = 0
  end
end

function love.update()
  -- slow down
  if cnt < 10 then
    cnt = cnt + 1
    return
  else
    cnt = 0
  end
  
  -- move all segments
  for i = snake.len, 2, -1 do
    snake.segments[i] = { x = snake.segments[i-1].x, y = snake.segments[i-1].y }
  end
  
  -- move head
  snake.segments[1].x = snake.segments[1].x + snake.dx
  snake.segments[1].y = snake.segments[1].y + snake.dy
  
  -- wrap around the board
  if snake.segments[1].x > gridsize.x then
    snake.segments[1].x = 0
  end
  if snake.segments[1].y > gridsize.y then
    snake.segments[1].y = 0
  end
  if snake.segments[1].x < 0 then
    snake.segments[1].x = gridsize.x - 1
  end
  if snake.segments[1].y < 0 then
    snake.segments[1].y = gridsize.y - 1
  end
  
  -- check collision
  for i = 2, snake.len do
    if snake.segments[1].x == snake.segments[i].x and
       snake.segments[1].y == snake.segments[i].y then
      snake.len = 1
      break
    end
  end
  
  -- eat apple
  if snake.segments[1].x == apple.x and
     snake.segments[1].y == apple.y then
      snake.len = snake.len + 1
      snake.segments[snake.len] = { x = apple.x, y = apple.y }      
      apple.x = love.math.random(0, gridsize.x-1)
      apple.y = love.math.random(0, gridsize.y-1)
  end
end

function love.draw()
  -- clear
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, gridsize.x * tilesize.x, gridsize.y * tilesize.y)
  
  -- snake
  love.graphics.setColor(255, 0, 0)
  for i = 1, snake.len do
    local s = snake.segments[i]
    love.graphics.rectangle("fill", s.x * tilesize.x, s.y * tilesize.y, tilesize.x, tilesize.y)
  end
  
  -- apple
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("fill", apple.x * tilesize.x, apple.y * tilesize.y, tilesize.x, tilesize.y)
end