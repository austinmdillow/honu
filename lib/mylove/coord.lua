Coord = Object:extend()

function Coord:new(x, y, t)
      self.x = x or 0
      self.y = y or 0
      self.t = t or math.pi / 2
end

function Coord:angleToPoint(x, y)
    return math.atan2(y-self.y, x-self.x)
end

function Coord:angleToCoord(coord)
    return math.atan2(coord.y-self.y, coord.x-self.x)
end

function Coord:polarToCartesianOffset(r, theta)
    return self.x + r * math.cos(theta), self.y + r * math.sin(theta)
end

function Coord:distanceToPoint(x, y)
    return math.sqrt((x - self.x)^2 + (y - self.y)^2)
end


function Coord:distanceToCoord(coord)
    return math.sqrt((coord.x - self.x)^2 + (coord.y - self.y)^2)
end

function Coord:moveAlongt(dist)
    return self.x + dist * math.cos(self.t), self.y + dist * math.sin(self.t)
end

function Coord:moveForward(dist)
    self.x = self.x + dist * math.cos(self.t)
    self.y = self.y + dist * math.sin(self.t)
end

-- positive rotation is clockwise
function Coord:rotate(rotation)
    self.t = self.t + rotation
    if self.t > math.pi then
        self.t = self.t - 2 * math.pi
    elseif self.t < -math.pi then
        self.t = self.t + 2 * math.pi
    end
end

function Coord:setXY(new_x, new_y)
    self.x = new_x
    self.y = new_y
end

function Coord:getX()
    return self.x
end

function Coord:getY()
    return self.y
end

function Coord:getT()
    return self.t
end

function Coord:normalVectorToCoord(coord)
  local x_vec = coord.x - self.x
  local y_vec = coord.y - self.y
  local magnitude = math.sqrt(x_vec ^ 2 + y_vec ^ 2)
  return x_vec / magnitude, y_vec / magnitude
end