Entity = Object:extend()

function Entity:new(x_start, y_start, t_start)
  if type(x_start) == "table" then
    if x_start:is(Coord) then
      self.coord = Coord(x_start.x, x_start.y, x_start.t)
    end
  else
    self.coord = Coord(x_start, y_start, t_start)
  end

  self.max_speed = 100
  self.current_speed = 0
  self.rotation_speed = math.pi / 2
  self.max_health = 100
  self.current_health = self.max_health
  self.size = 2
  self.color = {1,0,0}

  self.id = nil
end

function Entity:update(dt)

    -- print("Entity location ", self.coord.x, self.coord.y)
end

function Entity:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord.t)
    love.graphics.circle('fill', 0, 0, 1)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
end

function Entity:print()
  print("ID ", self.id, self.coord)
end

function Entity:getX()
	return self.coord.x
end

function Entity:getY()
	return self.coord.y
end

function Entity:getT()
    return self.coord.t
end

function Entity:getXY()
  return self.coord:getX(), self.coord:getY()
end

function Entity:getXYT()
  return self.coord:getX(), self.coord:getY(), self.coord:getY()
end

function Entity:setXY(x, y)
	self.coord.x = x
	self.coord.y = y
end

function Entity:setXYT(x, y, t)
    self:setXY(x, y)
    self.coord.t = t
end

function Entity:rotate(rotation)
  self.coord:rotate(rotation)
end

function Entity:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Entity:getColor()
	return self.color
end

function Entity:setColor(color_input)
  self.color[1] = color_input[1]
  self.color[2] = color_input[2]
  self.color[3] = color_input[3]
end

function Entity:keypressed(key)
  if key == " " then
    print("space is down")
  end
end

function Entity:damage(amount)
  self.current_health = self.current_health - amount
  if self.current_health <= 0 then
    return true
  else
    return false
  end
end