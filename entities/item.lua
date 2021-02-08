Item = Object:extend()

function Item:new(x_start, y_start)
  if type(x_start) == "table" then
    if x_start:is(Coord) then
      self.coord = Coord(x_start.x, x_start.y, x_start.t)
    end
  else
    self.coord = Coord(x_start, y_start, t_start)
  end
  self.image = Sprites.coin_image -- default image for an item
  assert(self.image ~= nil, "Item image is nil")
  self.isGarbage = false -- if true, it will be garbage collected in the map
  self.drop_time = love.timer.getTime()
  self.time_to_die = nil
  self.size = 10
  --print("Item Image", self.image)
end

function Item:setImage(im)
  self.image = im
end

function Item:update(dt)
  if self.time_to_die ~= nil and love.timer.getTime() - self.drop_time > self.time_to_die then
    cleanMe()
  end
  if upgrade_manager:isUnlocked("magnetism") then
    local mod_m, mod_a = upgrade_manager:getModifiers("magnetism")
    local force = mod_m * mod_a
    local distance = self.coord:distanceToCoord(game_data.local_player.coord)
    local range = 300
    if distance < range then
      local dx, dy = self.coord:normalVectorToCoord(game_data.local_player.coord)
      local speed = (distance - range) * (force)/ (-range) * dt
      print(speed)
      self.coord:setXY(dx + self.coord:getX(), dy + self.coord:getY())
    end
  end 
end

function Item:garbage()
  return self.isGarbage
end

function Item:cleanMe()
  self.isGarbage = true
end

function Item:drawIcon(x_loc, y_loc)

end

function Item:draw()
  if self.coord ~= nil and self.image ~= nil then
    img_width, img_height = self.image:getDimensions()
    love.graphics.setColor(COLORS.white)
    love.graphics.draw(self.image, self.coord.x - img_width / 2, self.coord.y - img_height / 2)
  end
end

function Item:setPosition(x_set, y_set)
  if self.coord == nil then
    self.coord = Coord(x_set, y_set, 0)
  end
end

function Item:print()
  print(type(self), self, self.image)
end