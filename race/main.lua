function randomColor()
  return { 
    math.random(0,255),
    math.random(0,255),
    math.random(0,255),
    255
  }
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  -- WARNING - this needs to be rough for Intel HD4400
  love.graphics.setPointStyle("rough")
  
  playerCount = 2
  currentPlayer = 1
  boardSizeX = 10 -- in tiles
  boardSizeY = 10
  boardOffsetX = 10 -- in pixels
  boardOffsetY = 10
  tileSizeX = math.floor((love.graphics.getWidth() - boardOffsetX) / boardSizeX) -- in pixels
  tileSizeY = math.floor((love.graphics.getHeight() - boardOffsetY) / boardSizeY)
  
  players = {}
  for i = 1,playerCount do
    local px = 5
    local py = 3 + i
    
    players[i] = { 
      lines = { {x = px, y = py} },
    
      vx = 0,
      vy = 0,
      name = "player_" .. i,
      color = randomColor(),
    }
  end
end

function love.update(dt)

end

function love.keypressed(k)
   if k == 'escape' then
      love.event.quit()
   end
end

function advancePlayer()
  local function nextPlayer(p)
    p = p + 1
    if p > playerCount then
      return 1
    else
      return p
    end
  end
  
  currentPlayer = nextPlayer(currentPlayer)
end

function drawPlayers()
  local function setPlayerColor(player)
    love.graphics.setColor(player.color)
  end
  
  local function drawPlayerLines(player)
    if #player.lines < 2 then
      return
    end
    
    for i = 1, #player.lines - 1 do
      local p1 = getScreenCoordFromBoardCoord(player.lines[i])
      local p2 = getScreenCoordFromBoardCoord(player.lines[i+1])
      
      love.graphics.line(
        p1.x,
        p1.y,
        p2.x,
        p2.y
      )
    end
  end
  
  local function drawPlayerPoint(player)
    love.graphics.setPointSize(20)
    local p = player.lines[#player.lines]
    local pScreen = getScreenCoordFromBoardCoord(p)
    love.graphics.point(pScreen.x, pScreen.y)
  end
  
  for _,p in ipairs(players) do
    setPlayerColor(p)
    drawPlayerLines(p)
    drawPlayerPoint(p)
  end
end

function getBoardCoordFromScreenCoord(s)  
  -- adding half makes it stick to tile edges (i.e. line crosses)
  return {
    x = math.floor((s.x - boardOffsetX ) / tileSizeX + 0.5) + 1,
    y = math.floor((s.y - boardOffsetY) / tileSizeY + 0.5) + 1
  }
end

function getScreenCoordFromBoardCoord(c)
  return {
    x = (c.x - 1) * tileSizeX + boardOffsetX,
    y = (c.y - 1) * tileSizeY + boardOffsetY
  }
end

function love.mousereleased(x, y, button)
  local c = getBoardCoordFromScreenCoord({ x = x, y = y })
  table.insert(players[currentPlayer].lines, c)
  advancePlayer()
end

function isValidMove(playerId, position)
end

function love.draw()  
  --love.graphics.setColor(20,255,0,128)
  --love.graphics.print("Hello Ruda", 100, 100)
  
  --local x = love.mouse.getX() 
  --local y = love.mouse.getY()
  
  -- drawing size of a tile in pixels
  
  love.graphics.setColor(128,128,128,255)
  love.graphics.setPointSize(2)
  -- offset simply adds left-top margin to the board
  for x = 1, boardSizeX do
    for y = 1, boardSizeY do
      local p = getScreenCoordFromBoardCoord({ x = x, y = y })
      
      love.graphics.point(p.x, p.y)
    end
  end
  
  drawPlayers()
end
