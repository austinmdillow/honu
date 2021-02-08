Player = Ship:extend()

function Player:new(x_start, y_start)
  Player.super.new(self, x_start, y_start, dir_start)
  self:setColor(COLORS.red)
  self.max_speed_base = 550
  self.max_speed = self.max_speed_base
  self.cruise_speed = 250
  self.min_speed = 50
  self.boost = 100
  self.max_boost = 400
  self.over_boosted = false
  self.radius = 10
  self.current_speed = 0
  self.roation_speed = 3
  self.size = 5
  self.team = Teams.blue
  self.shield_enabled = true
  self.shield_health = 100
  self.shield_recharge_rate = 5
  self.shield_max = 110
  self.inventory = {Gun(2, 80)} -- currently a default gun, may want to change
  self.equipped_weapon = self.inventory[1]
  self.invincible = false
  

  self.sprite_image = Sprites.player_image
  self.timer = Timer.new() -- not sure if this is used
  self.damage_color = {1,0,0,0} -- not used
  
  
end

function Player:grow() -- not used
  print("in grow")
  self.timer:tween(1, self.damage_color, {1, 0, 0, 1}, 'in-out-quad', self:shrink())
end

function Player:shrink() -- not used
  print("in shrink")
      self.timer:tween(1, self.damage_color, {1, 0, 0, 0}, 'in-out-quad')
end

-- called before the player starts a new level and such
function Player:reset() -- need to add info
  self.shield_health = 0
  self.current_health = 100
  print("Upgrade mods")
  print(upgrade_manager:getModifiers("speed"))
  self.max_speed = self.max_speed_base * upgrade_manager:getModifiers("speed")
  if upgrade_manager:isUnlocked("shotgun") then -- this should be handeled by an inventory system that tracks upgrade events
    self.inventory[3] = Shotgun()
  end
end

function Player:update(dt)
    Player.super.update(self, dt)
    self.timer:update(dt)
    self:updateBoost(dt)
    if outOfBounds(self.coord) then
      self:damage(dt*20)
    end

    if love.keyboard.isDown("up") and not self.over_boosted then
      self.boost = self.boost - 100*dt
      self.current_speed = math.min(self.current_speed + 500 * dt, self.max_speed)
    elseif love.keyboard.isDown("down") then
      self.current_speed = self.min_speed
    else 
      self.current_speed = math.max(self.current_speed - 200*dt, self.cruise_speed)
    end
    local rotation_speed_const = 1
    if love.keyboard.isDown("right") then
        self.coord:rotate(dt * (self.roation_speed + rotation_speed_const * (self.cruise_speed - self.current_speed) / self.cruise_speed))
    elseif love.keyboard.isDown("left") then
        self.coord:rotate(-dt * (self.roation_speed + rotation_speed_const * (self.cruise_speed - self.current_speed) / self.cruise_speed))
    end


    if self.shield_enabled then
      self.shield_health = math.min(self.shield_max, self.shield_health + self.shield_recharge_rate * dt)
    end

    

    self.coord:moveForward(self.current_speed * dt)
    self.pSystem:update(dt)
    self.pSystem:moveTo(self.coord.x, self.coord.y)

    self.pSystem:setDirection(self.coord:getT() + math.pi)

    if love.keyboard.isDown("space") and self.equipped_weapon:is(Machinegun) then
      print("Machine")
      self:fire()
    end
end

function Player:draw()
  Player.super.draw(self)
  love.graphics.setColor(self.damage_color)
  love.graphics.circle('fill', self.coord.x, self.coord.y, 200)
end

function Player:updateBoost(dt)
  if self.boost < 1 then
    self.over_boosted = true
  end

  -- if we need to refill
  if self.boost < self.max_boost then
      self.boost = math.min(self.max_boost, self.boost + dt * 25)
  else
    self.over_boosted = false
  end
end

function Player:damage(amount)
  -- take damage to shield first
  if self.invincible then
    return false
  end
  if self.shield_enabled then
    local shield_residual = self.shield_health - amount -- how much is left in the shield after a hit
    self.shield_health = math.max(0, shield_residual)
    if shield_residual < 0 then -- if the shield took too much damage
      self.current_health = self.current_health + shield_residual
    end
  else -- if we dont have a shield
    self.current_health = self.current_health - amount
  end

  if self.current_health <= 0 then
    return true
  else
    return false
  end

  

end

function Player:keypressed(key)
  if key == "space" and not love.keyboard.isDown("up") then
    self:fire()
  end

  if key == "u" then
    self.equipped_weapon:setUnlimitedAmmo(not self.equipped_weapon:getUnlimitedAmmo())
  end

  if key == "i" then
    self.invincible = not self.invincible
  end

  if key == "1" then
    if self.inventory[1] ~= nil then
      self.equipped_weapon = self.inventory[1]
    end
  end
  if key == "2" then
    self.equipped_weapon = Machinegun()
  end
  if key == "3" then
    if self.inventory[3] ~= nil then
    self.equipped_weapon = self.inventory[3]
    print(self.equipped_weapon)
    end
  end
end