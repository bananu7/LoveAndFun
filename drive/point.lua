local Point = { x = 0, y = 0 }

-- Get a vec
function Point:getMagnitude()
  return math.sqrt(self.x * self.x + self.y * self.y)
end
function Point:getDirection()
  return math.atan2(self.y, self.x);
end

function Point:newByMagnitudeChange(newMagnitude)
  local oldMagnitude = self:getMagnitude()
  local d = newMagnitude / oldMagnitude
  
  return Point(self.x * d, self.y * d)
end
function Point:newByDirectionChange(newDirection)
  local cs = math.cos(newDirection)
  local sn = math.sin(newDirection)

  local nx = self.x * cs - self.y * sn
  local ny = self.x * sn + self.y * cs
  return Point(nx, ny)
end

setmetatable(Point, Point)

function Point.__call(_, x, y)
  local p = { }
  if x and y then
    p.x = x; p.y = y
  end
  
  setmetatable(p, Point)
  return p
end

function Point.mul(opA, opB)
  function mulVecNum(vec, num)
    return Point(vec.x * num, vec.y * num)
  end
  
  if type(opB) == "number" then
    return mulVecNum(opA, opB)
  else
    return mulVecNum(opB, opA)
  end  
end

function Point.sub(opA, opB)
  function subVecVec(vA, vB)
    return Point(vA.x - vB.x, vA.y - vB.y)
  end
  -- TODO nums
  return subVecVec(opA,opB)
end

Point.__mul = Point.mul

return Point