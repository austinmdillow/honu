Gun = Object:extend()


function Gun:new(fire_rate, damage, cooldown_rate)
  self.ammo = 10
  self.max_ammo = nil
  self.unlimited_ammo = true
  self.fire_rate = fire_rate or 2
  self.last_fire_time = love.timer.getTime()
  self.damage = damage or 10
  self.cooldown_rate = cooldown_rate or 2
  self.current_heat = 0
  self.max_heat = 10
  self.overheated = false
  self.overheat_capable = true
  self.label = "gun default"
  self.color = {1,0,0} -- not used as the gun shouldn't be drawn
  
end

function Gun:fire(ship_coord)
  if love.timer.getTime() - self.last_fire_time > (1 / self.fire_rate) then
    --print("Gun: " ..self.ammo, self.current_heat)
    if self.ammo > 0 or self.unlimited_ammo then -- if we have ammo
      if not self:getOverheat() then -- if the gun isn't overheated
        self.current_heat = self.current_heat + 1
        if self.unlimited_ammo == false then
          self.ammo = self.ammo - 1
        end
        self.last_fire_time = love.timer.getTime()
        return {Bullet(self.damage, ship_coord)} -- return a default bullet
      end
    end
  end
  return nil
end

-- returns the overheated state and the percentage of overheat level
function Gun:getOverheat()
  return self.overheated, self.current_heat / self.max_heat
end

function Gun:update(dt)
  self:updateOverheat(dt)
end

-- called every loop in order to update the overheat levels
function Gun:updateOverheat(dt)
  self.current_heat = math.max(self.current_heat - dt * self.cooldown_rate, 0)
  if self.current_heat >= self.max_heat then
    self.overheated = true
  end

  -- disbales the overheated flag
  if self.overheated and self.current_heat == 0 then
    self.overheated = false
  end
end

function Gun:getAmmo()
  return self.ammo
end

function Gun:getUnlimitedAmmo()
  return self.unlimited_ammo
end

function Gun:setUnlimitedAmmo(b)
  if b == true then
    self.unlimited_ammo = true
  elseif b == false then
    self.unlimited_ammo = false
  else
    print("ERROR: unknown value to setUnlimitedAmmo")
  end
end

function Gun:__tostring()
  return self.label .. ": ammo = " .. self.ammo
end