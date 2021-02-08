Shotgun = Gun:extend()

function Shotgun:new()
  Shotgun.super.new(self)
  self.ammo = 100
  self.max_ammo = nil
  self.max_speed = 100
  self.unlimited_ammo = true
  self.fire_rate = 4
  self.last_fire_time = love.timer.getTime()
  self.damage = 50
  self.cooldown_rate = 1
  self.current_heat = 0
  self.max_heat = 4
  self.overheated = false
  self.overheat_capable = true
  self.label = "shotgun"
  self.shots = 3
  self.spread = .1
end

function Shotgun:update(dt)
  Shotgun.super.update(self, dt)
end


function Shotgun:fire(ship_coord)
  if love.timer.getTime() - self.last_fire_time > (1 / self.fire_rate) then
    --print("Gun: " ..self.ammo, self.current_heat)
    if self.ammo > 0 or self.unlimited_ammo then -- if we have ammo
      if not self:getOverheat() then -- if the gun isn't overheated
        self.current_heat = self.current_heat + 1
        if self.unlimited_ammo == false then
          self.ammo = self.ammo - 1
        end
        self.last_fire_time = love.timer.getTime()

        local bullet_list = {} -- the list of bullets that will be returned to the ship
        for i=1,self.shots,1 do -- for each shot that needs to be fired
          local tmp_bullet = Bullet(self.damage, ship_coord)
          local rotation = i * self.spread - self.spread * (self.shots + 1) /2
          tmp_bullet:rotate(rotation)
          tmp_bullet:setColor(COLORS.blue)
          tmp_bullet.rotation_speed = 3 * math.pi
          table.insert(bullet_list, tmp_bullet)
        end
        return bullet_list
      end
    end
  end
  return nil -- indicates that nothing was fired
end