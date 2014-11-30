map = { }
sizeX = 5
sizeY = sizeX
lastLevel = 1

levels = {
  { 
    0,0,0,0,0,
    0,1,0,0,0,
    1,1,1,0,0,
    0,1,0,0,0,
    0,0,0,0,0
  },
  { 
    0,0,0,0,0, 
    0,1,0,1,0,
    1,0,0,1,0,
    0,1,1,0,0,
    0,0,0,0,0 
  },
}

function decodeLevels() 
  for _,level in ipairs(levels) do
    for i = 0,sizeX * sizeY - 1 do
      level[i] = (level[i+1] == 1) and true or false 
    end
  end
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  decodeLevels()
  map = levels[1]
end

function love.update(dt)
end

function love.keypressed(k)
   if k == 'escape' then
      love.event.quit()
   end
end

function isVictory() 
  for i = 0,sizeX*sizeY-1 do
    if map[i] then
      return false
    end
  end
  return true
end

function love.mousereleased(x, y, button)
  local nx = x / love.graphics.getWidth()
  local ny = y / love.graphics.getHeight()
  
  local px = math.floor(nx * sizeX)
  local py = math.floor(ny * sizeY)
  
  local function flipMap(x,y)
    if x >= 0 and y >= 0 and x < sizeX and y < sizeY then
      map[y*sizeX + x] = not map[y*sizeX + x]
    end
  end
  
  flipMap(px, py)
  flipMap(px-1, py)
  flipMap(px+1, py)
  flipMap(px, py-1)
  flipMap(px, py+1)
  
  if isVictory() then
    lastLevel = lastLevel + 1
    if lastLevel > #levels then
      lastLevel = 1
    end
    
    map = levels[lastLevel]
  end
end

function love.draw()
  local white = {255,255,255,255}
  local black = {0,0,0,255}
  
  for i = 0,sizeX*sizeY-1 do
    if map[i] then
      love.graphics.setColor(white)
    else
      love.graphics.setColor(black)
    end
    
    local px = love.graphics.getWidth() / sizeX
    local py = love.graphics.getHeight() / sizeY
    
    local x = i % sizeX 
    local y = math.floor(i / sizeX)
    
    love.graphics.rectangle("fill", x * px, y * py, px, py)
  end 
end
