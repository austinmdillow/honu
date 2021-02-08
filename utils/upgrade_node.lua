Upgrade = Object:extend()


function Upgrade:new(x_home, y_home)
  self.drift_time = 0 -- keep track of time for the sin functions
  self.x_home = x_home
  self.y_home = y_home
  self.x = self.x_home
  self.x_vel = 0
  self.y = self.y_home
  self.previous = {} -- what is needed for this unlock
  self.next = {} -- what this upgrade will unlock
  self.cost = 100 -- how much this upgrade will cost
  self.title = "default upgrade"
  self.description = "This is a placeholder for a more detailed description"
  self.width = 100
  self.height = 150
  self.unlocked = false
  self.oscillation_offset_x = love.math.random(2 * math.pi)
  self.oscillation_offset_y = love.math.random(2 * math.pi)
  self.oscillation_amount_x = love.math.random(-10, 10)
  self.oscillation_amount_y = love.math.random(-10, 10)
end

function Upgrade:update(dt)
  
  if dt < 1 / 5 then -- make sure we don't do these calcs in a paused state
    -- osciallate in a sinusoidal pattern
    self.drift_time = self.drift_time + dt
    self.x = self.x_home + self.oscillation_amount_x * math.cos(self.drift_time + self.oscillation_offset_x)
    self.y = self.y_home + self.oscillation_amount_y * math.cos(self.drift_time + self.oscillation_offset_y)
  end
end

function Upgrade:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.setColor(.6,.6,.6)
  love.graphics.rectangle('fill', 0, 0, self.width, self.height)

  -- draw unlocked vs locked
  if self.unlocked then
    love.graphics.setColor(COLORS.green)
  else
    love.graphics.setColor(COLORS.red)
  end
  love.graphics.rectangle('line', 0, 0, self.width, self.height)

  -- draw tex_homet
  love.graphics.setColor(COLORS.blue)
  love.graphics.print(self.title, 10, 10)
  love.graphics.pop()
end

function Upgrade:pointInBox_home(x, y)
  return PointWithinRectangle(self.x, self.y, self.width, self.height, x, y)
end 

function Upgrade:mousereleased(x,y, mouse_btn)
  if self:pointInBox_home(x, y) then
    --print("Upgrade: mouse released inside ", self)
    self:printConnections()

    if self.unlocked == true then
      print("Already unlocked")
      return false
    end

    if not self:hasPreviousUnlocked() then -- check prerequisites met
      print("Prior upgrade needs to be unlocked")
      return false
    end

    if self.cost > game_data.coins then -- check that player has enough money
      print("Item costs " .. self.cost ..", need " .. self.cost - game_data.coins .. " more")
      return false
    end
    -- check if unlock is available
    if self:hasPreviousUnlocked() then
      local title = "Confirm Upgrade"
      local message = "Are you sure you want to spend " .. self.cost .. " coins to upgrade?"
      local buttons = {"Hell yeah!", "No thanks", escapebutton = 0, enterbutton = 0}
      local pressedbutton = love.window.showMessageBox(title, message, buttons, "warning")
      if pressedbutton == 1 then
        game_data.coins = game_data.coins - self.cost
        self.unlocked = true
      end
      return true
    end
  end
  return false
end

function Upgrade:setTitle(title)
  assert(type(title) == "string")
  self.title = title
end

function Upgrade:setCost(cost)
  assert(type(cost) == "number")
  self.cost = cost
end

function Upgrade:setPrevious(upgrade)
  assert(upgrade:is(Upgrade))
  self.previous = upgrade
end

function Upgrade:setNext(upgrade)
  assert(upgrade:is(Upgrade))
  self.next = upgrade
end

function Upgrade:setResult(flag, multiplier, increase)
  if flag ~= nil then
    self.flag = flag
    self.multiplier = multiplier or 1
    self.increase = increase or 0
  end
end

function Upgrade:calculateIncrease(existing)
  local e = existing or 0
  return e * self.multiplier + self.increase
end

function Upgrade:getModifiers()
  return self.multiplier, self.increase
end

function Upgrade:isUnlocked()
  return self.unlocked
end

function Upgrade:hasPreviousUnlocked()
  if next(self.previous) == nil then
    return true
  end

  for i, prev in pairs(self.previous) do
      if prev:isUnlocked() then
        return true
      end
  end
  return false -- if we got here then this upgrade doesn't have any previous unlocked
end

function Upgrade:getPosition()
  return self:getX(), self:getY()
end

function Upgrade:getY()
  return self.y
end

function Upgrade:getX()
  return self.x
end

-- print all of the upgrades that this one connects to
function Upgrade:printConnections()
  print("Listing Upgrade Connections for ", self)
  print("Next")
  for _, next_upgrade in pairs(self.next) do
    print(next_upgrade)
  end
  print("Prev")
  for _, previous_upgrade in pairs(self.previous) do
    print(previous_upgrade)
  end
end

function Upgrade:__tostring()
  return "Upgrade:" .. self.title .. ", costing: " .. self.cost
end