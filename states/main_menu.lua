main_menu = {}

-- creating the menuengine
local menuengine = require "lib.menuengine"
menuengine.stop_on_nil_functions = true

local main_menu_engine -- forcing scope to be local
local text = "" -- for text to be displayed at the bottom of the screen on button input
local text_print_time = love.timer.getTime()
local text_show_time = 3 -- how long text should be displayed for

-- Start Game
local function startGame()
  main_menu:setText("Start Game was selected!")
  Gamestate.switch(map_gameplay)
end

local function levelSelect()
  main_menu:setText("Level Select was selected!")
  Gamestate.push(level_menu)
  --game_data.current_level = game_data.current_level + 1
end

local function upgradeSelect()
  main_menu:setText("Upgrade was selected!")
  Gamestate.push(upgrade_menu)
end

local function loadFromSave()
  loadSave()
  main_menu:setText("Loaded game from save!")
end

-- Options
local function options()

end

-- Quit Game
local function quitGame()
  love.event.quit()
end

-- DRAW
function main_menu:draw()
    main_menu_engine:draw()

    love.graphics.print("Level: " .. game_data.current_level, FRAME_WIDTH / 2 - 10, 10)
    local current_time = love.timer.getTime()
    love.graphics.print(current_time, 100, 50)

    if current_time - text_print_time < text_show_time then
      love.graphics.print(text, 10, FRAME_HEIGHT - 20)
    end
end

-- UPDATE
function main_menu:update(dt)
    main_menu_engine:update(dt)
end



function main_menu:enter()
  print("Version " .. VERSION)
  for idx, level in pairs(save_data.level_stats) do
    for k, v in pairs(level) do
      print(idx, k, v)
    end
  end

  love.graphics.setFont(love.graphics.newFont(20))

  -- add all of the different menus
  main_menu_engine = menuengine.new(300,300)
  main_menu_engine:addEntry("Start Game", startGame)
  main_menu_engine:addEntry("Levels", levelSelect)
  main_menu_engine:addEntry("Upgrades", upgradeSelect)
  main_menu_engine:addEntry("Load Game", loadFromSave)
  main_menu_engine:addEntry("Options", options)
  main_menu_engine:addSep()
  main_menu_engine:addEntry("Quit Game", quitGame)

end


function loadSave()
  local save_data = SaveData.load("savefile")
  game_data.score = save_data.score
end

function main_menu:setText(t)
  text = t -- set the text
  text_print_time = love.timer.getTime()
end



function main_menu:mousemoved(x, y, dx, dy, istouch)
    menuengine.mousemoved(x, y)
end

function main_menu:keypressed(key, scancode, isrepeat)
    menuengine.keypressed(scancode)

    if scancode == "escape" then
        love.event.quit()
    end
end

return main_menu