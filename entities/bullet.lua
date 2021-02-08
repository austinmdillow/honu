Bullet = Entity:extend()

function Bullet:new(damage, x_start, y_start, dir_start)
  Bullet.super.new(self, x_start, y_start, dir_start)
  self:setColor(COLORS.green)

  self.rotation_visual = 0
  self.max_speed = 800
  self.size = 10
  self.team = nil
  self.source_id = nil
  self.damage = damage or 10 -- default
  self.time_alive = 0
  self.time_to_death = 2
end

function Bullet:update(dt)
    self.time_alive = self.time_alive + dt
    self.coord:moveForward(self.max_speed * dt)
    self.rotation_visual = self.rotation_visual + self.rotation_speed * dt
end

function Bullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord:getT() + self.rotation_visual)
    love.graphics.rectangle('line', -1 * self.size / 2, -1 * self.size / 2, self.size, self.size)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
end

function Bullet:setDamage(dmg)
  self.damage = dmg
end

function Bullet:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Bullet:setTeamAndSource(team, source)
  self.team = team
  self.source = source
end

function Bullet:setId( new_id )
  self.source_id = new_id
end

-- the bullet has been around for too long
function Bullet:dead()
 return self.time_alive > self.time_to_death
end