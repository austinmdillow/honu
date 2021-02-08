Player = Ship:extend()

function Player:new(x_start, y_start)
  Player.super.new(self, x_start, y_start, dir_start)
  self.max_speed = 100
  self.color = {1,0,0}
  self.radius = 10
  self.current_speed = 0
  self.roation_speed = 3
  self.size = 5
end

function Player:update(dt)
    if love.keyboard.isDown("up") then self.current_speed = self.max_speed else self.current_speed = 0 end

    if love.keyboard.isDown("right") then
        self.coord:rotate(dt * self.roation_speed)
    elseif love.keyboard.isDown("left") then
        self.coord:rotate(-dt * self.roation_speed)
    end

    self.coord:moveForward(self.current_speed * dt)
end

function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord:getT())
    love.graphics.polygon('line', self.size * -1, self.size * -1, 0, 0, self.size * -1, self.size * 1, self.size * 3, 0)
    love.graphics.circle('fill', 0, 0, 1)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
end

function Player:keypressed(key)
  if key == " " then
    return self:fire()
  end
end