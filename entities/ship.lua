Ship = Entity:extend()

local hitbox_debug = true

function Ship:new(x_start, y_start)
  Ship.super.new(self, x_start, y_start, dir_start)
  self:setColor(COLORS.red)
  self.max_speed = 100
  self.radius = 10
  self.current_speed = 0
  self.roation_speed = 3
  self.size = 10
  self.last_fire_time = love.timer.getTime() -- last time since a bullet was fired
  self.fire_rate = 2 -- bullets per second
  self.hitbox = self.size * 2
  self.sprite_image = nil
  self.equipped_weapon = Gun()
  self.pSystem = love.graphics.newParticleSystem(Sprites.particle_image, 255)
  self:setupParticleSystem()

end

function Ship:update(dt)
    self.equipped_weapon:update(dt)
    if self.pSystem ~= nil then
      self.pSystem:setEmissionRate(self.current_speed / 10)
      self.pSystem:setSpeed(100,self.current_speed * 2)
      self.pSystem:update(dt)
      self.pSystem:moveTo(self.coord.x, self.coord.y)
    end
end

function Ship:draw()
  love.graphics.push() -- push 1
  
  love.graphics.translate(self.coord.x, self.coord.y)
  love.graphics.rotate(self.coord:getT())

  if self.sprite_image ~= nil then
    love.graphics.setColor(1,1,1)
    love.graphics.scale(0.2, 0.2)
    love.graphics.draw(self.sprite_image, self.sprite_image:getWidth()/2, -self.sprite_image:getHeight()/2, math.pi/2)
  else
    love.graphics.setColor(self.color)
    love.graphics.polygon('line', self.size * -1, self.size * -1, 0, 0, self.size * -1, self.size * 1, self.size * 3, 0)
    love.graphics.circle('fill', -5, 0, 4 * self.current_speed / self.max_speed)
  end
  
  if hitbox_debug then
    love.graphics.setColor(COLORS.red)
    love.graphics.circle('line', 0, 0, self.hitbox)
  end
  love.graphics.pop() -- pop 1
  if self.pSystem ~= nil then
    love.graphics.draw(self.pSystem, 0,0)
  end
end

function Ship:fire()
  local fire_result = self.equipped_weapon:fire(self.coord) -- get the bullet object from the equipped gun
  if fire_result ~= nil then -- if we actually fired something
    for idx, tmp_bullet in pairs(fire_result) do -- loop through the bullet list we get back (if there are multiple)
      tmp_bullet:setTeamAndSource(self.team, self)
      table.insert(game_data.bullet_list, tmp_bullet)
    end
    return true -- if we were able to fire the weapon
  end
  return false
end

function Ship:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Ship:rateLimitedTurn(dt, angle) -- the desired amount of turning
  local rotation_amount = 0
  if angle >= 0 then
    rotation_amount = math.min(dt * self.roation_speed, angle)
  else
    rotation_amount = math.max(-dt * self.roation_speed, angle)
  end
  self.coord:rotate(rotation_amount)
end

function Ship:dead()
  return self.current_health < 0
end

function Ship:setupParticleSystem()
  self.pSystem:setParticleLifetime(1, 2) -- Particles live at least 2s and at most 5s.
	self.pSystem:setEmissionRate(10)
  self.pSystem:setSizeVariation(1)
  self.pSystem:setSizes(3)
  self.pSystem:setSpeed(100,100)
  self.pSystem:setSpin(1,1)
  self.pSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.
end

function Ship:getSpeed()
  return self.current_speed
end

function Ship:__tostring()
  return "Ship:" .. self.id .. ", pos: " .. self.coord:getX() .. ", " .. self.coord:getY()
end