upgrade_menu = {}

local upgrade_progression = {
  speed_1 = {
    x = 100,
    y = 100,
    title = "speed number 1",
    cost = 5,
    next = {"speed_2"},
    flag = "speed",
    multiplier = 1.2

  },
  speed_2 = {
    x = 400,
    y = 200,
    title = "Speed number 2",
    cost = 10,
    flag = "speed",
    multiplier = 1.2
  },
  armor_1 = {
    x = 400,
    y = 400,
    title = "armor 1",
    previous = nil,
    next = {"armor_2", "armor_3"},
    cost = 4,
    flag = "max_health",
    multiplier = 1.2
  },
  armor_2 = {
    x = 600,
    y = 200,
    title = "armor 2",
    prerequisite = "crafting_1",
    cost = 23
  },
  armor_3 = {
    x = 700,
    y = 500,
    title = "armor 3",
    prerequisite = "crafting_1",
    cost = 23
  },
  crafting_1 = {
    x = 100,
    y = 600,
    title = "Crafting ability",
    next = {"magnet_1"},
    previous = nil,
    cost = 5
  },
  magnet_1 = {
    x = 400,
    y = 620,
    title = "Attract Coins",
    cost = 1,
    next = {"magnet_2"},
    flag = "magnetism",
    increase = 100
  },
  magnet_2 = {
    x = 600,
    y = 620,
    title = "Attract Coins",
    cost = 1,
    flag = "magnetism",
    previous = "magnet_1",
    multiplier = 1.2
  },
  shotgun = {
    x = 0,
    y = 0,
    title = "Big Gun",
    cost = 1,
    flag = "shotgun",
    previous = "magnet_1",
    multiplier = 1
  }
}

upgrade_list = {}

function upgrade_menu:init()
  
  upgrade_menu.window_x = -100
  upgrade_menu.window_y = 1
  upgrade_menu.camera = Camera(FRAME_WIDTH / 2, FRAME_HEIGHT / 2)
  upgrade_menu.grabbed = false
  upgrade_menu.camera.smoother = Camera.smooth.damped(10)

  upgrade_menu.mouse_start_x, upgrade_menu.mouse_start_y = 0, 0

  upgrade_menu.window_x_max = 500 + FRAME_WIDTH / 2
  upgrade_menu.window_x_min = 0 + FRAME_WIDTH / 2
  upgrade_menu.window_y_max = 100 + FRAME_HEIGHT / 2
  upgrade_menu.window_y_min = -400 + FRAME_HEIGHT / 2

  upgrade_manager:loadUpgrades(upgrade_progression)

  for key, upgrade in pairs(upgrade_list) do
    print(key, upgrade)
  end
end

function upgrade_menu:update(dt)
  --upgrade_menu.camera:lockPosition(upgrade_menu.window_x, upgrade_menu.window_y, camera.smoother)
  upgrade_manager:update(dt) -- updates all nodes in the list

  if love.mouse.isDown(1) then -- if the mouse is down
    if not upgrade_menu.grabbed then -- we are grabbing for the first time
      -- set the coordinates of the grabbed location (reference frame is irrelevant)
      upgrade_menu.mouse_start_x, upgrade_menu.mouse_start_y = love.mouse.getPosition()
      upgrade_menu.grabbed = true
    end
    local mouse_x, mouse_y = love.mouse.getPosition() -- get the new mouse coordinates
    upgrade_menu.camera:move(upgrade_menu.mouse_start_x - mouse_x, upgrade_menu.mouse_start_y - mouse_y) -- compare to the last frame
    upgrade_menu.mouse_start_x, upgrade_menu.mouse_start_y = mouse_x, mouse_y -- update for the next comparision 

    -- limit how far we can look around the frame
    local camera_x, camera_y = upgrade_menu.camera:position()
    upgrade_menu.camera:lookAt( math.max(upgrade_menu.window_x_min, math.min(upgrade_menu.window_x_max, camera_x)) 
    , math.max(upgrade_menu.window_y_min, math.min(upgrade_menu.window_y_max, camera_y))  )

  else
    upgrade_menu.grabbed = false -- if the mouse isn't down, then set grabbed to true
  end
end

function upgrade_menu:draw()
  upgrade_menu.camera:attach() -- attach the camera for dragging arond


  love.graphics.setColor(COLORS.orange)
  love.graphics.print("Up", 10, 10)

  for key, upgrade in pairs(upgrade_manager:getNodeList()) do
    upgrade:draw()
    love.graphics.setColor(COLORS.yellow)
    upgrade_menu:drawConnections(upgrade)
    
  end

  upgrade_menu.camera:detach() -- detach the cameras

  drawUpgradeHud()
  drawDebugInfo()
end

function upgrade_menu:mousereleased(x,y, mouse_btn)
  upgrade_manager:mousereleased(x, y, mouse_btn)
end

function upgrade_menu:keypressed(key)
  if key == "escape" then
    Gamestate.pop()
  end
end

-- draws the connections from the passed upgrade to the next ones
function upgrade_menu:drawConnections(upgrade)
-- draw the arrows between the boxes
  local lead_in = 50
  for _, next_upgrade in pairs(upgrade.next) do
    local start_x = upgrade:getX() + upgrade.width
    local start_y = upgrade:getY() + upgrade.height / 2
    local end_x = next_upgrade:getX()
    local end_y = next_upgrade:getY() + next_upgrade.height / 2
    local curve = love.math.newBezierCurve({start_x,start_y, start_x + lead_in,start_y, end_x - lead_in, end_y, end_x,end_y})
    love.graphics.line(curve:render())
  end
end



return upgrade_menu