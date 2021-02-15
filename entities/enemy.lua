Enemy = Ship:extend()

function Enemy:new(x_start, y_start, dir_start)
    Enemy.super.new(self, x_start, y_start, dir_start)
    self:setColor({1,1,0})

    self.max_speed = 55
    self.radius = 10
    self.current_speed = 0
    self.roation_speed = 90 * math.pi / 180 -- deg / s
    self.size = 10
    self.team = Teams.red
    self.difficulty = 1
    self.sprite_image = nil
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    if false then self.current_speed = self.max_speed else self.current_speed = 0 end

    if false then
        self.coord:rotate(dt * self.roation_speed)
    elseif false then
        self.coord:rotate(-dt * self.roation_speed)
    end

    

    self:followCoord(dt, game_data.player.coord)
    if self:fire() then return "fire" end
end

function Enemy:draw()
    Enemy.super.draw(self)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', self:getX(), self:getY(), 100 *self.current_health / self.max_health, 10)
end

function Enemy:followCoord(dt, target_coord)
    local angle_error = self.coord:angleToCoord(target_coord) - self.coord:getT()
    -- TODO add this as a static function to Coord
    if angle_error > math.pi then
        angle_error = angle_error - 2 * math.pi
    elseif angle_error < -math.pi then
        angle_error = angle_error + 2 * math.pi
    end
    self:rateLimitedTurn(dt, angle_error + love.math.random()* 5 * math.pi / 180)
    self.coord:moveForward(self.max_speed * dt)
end