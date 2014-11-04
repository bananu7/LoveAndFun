
local Matrix = { }

--[[
  
  
  | 1 2 3 |
  | 4 5 6 |
  | 7 8 9 |

]]

function Matrix.mul(opA, opB)
  function mulMatrixMatrix(ma, mb)
    local r = Matrix()
    
    r[1] = ma[1]*mb[1] + ma[2]*mb[4] + ma[3]*mb[7]
    r[2] = ma[1]*mb[2] + ma[2]*mb[5] + ma[3]*mb[8]
    r[3] = ma[1]*mb[3] + ma[2]*mb[6] + ma[3]*mb[9]
    
    r[4] = ma[4]*mb[1] + ma[5]*mb[4] + ma[6]*mb[7]
    r[5] = ma[4]*mb[2] + ma[5]*mb[5] + ma[6]*mb[8]
    r[6] = ma[4]*mb[3] + ma[5]*mb[6] + ma[6]*mb[9]
    
    -- those are not needed in simple 2D transformations
    r[7] = ma[7]*mb[1] + ma[8]*mb[4] + ma[9]*mb[7]
    r[8] = ma[7]*mb[2] + ma[8]*mb[5] + ma[9]*mb[8]
    r[9] = ma[7]*mb[3] + ma[8]*mb[6] + ma[9]*mb[9]
    return r
  end

  function mulMatrixVector(m, v)
    local x = m[1]*v.x + m[2]*v.y + m[3]
    local y = m[4]*v.x + m[5]*v.y + m[6]
    return { x = x, y = y }
  end
  
  if opB.x then
    return mulMatrixVector(opA, opB)
  else
    return mulMatrixMatrix(opA, opB)
  end
end
-- common operations

function Matrix.rotation(arc)
  return Matrix {
    math.cos(arc), -math.sin(arc), 0,
    math.sin(arc),  math.cos(arc), 0,
                0,              0, 1
  }
end

function Matrix.translation(v)
  return Matrix {
    1, 0, v.x,
    0, 1, v.y,
    0, 0,   1
  }
end

function Matrix.identity()
  return Matrix {
    1, 0, 0,
    0, 1, 0,
    0, 0, 1
  }
end

Matrix.__mul = Matrix.mul
function Matrix.__call(_, val)
  val = val or { }
  setmetatable(val, Matrix)
  return val
end
setmetatable(Matrix, Matrix)

return Matrix
  
  