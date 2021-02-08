level_menu = {}

function level_menu:init()
  level_menu.num_levels = 8
  

end

function level_menu:enter()
end

function level_menu:update(dt)
end

function level_menu:draw()
  love.graphics.setColor(COLORS.red)
  print("Level menu draw")
  local num_columns = 4
  love.graphics.print("Level Selector", 0, 0)
  -- using zero indexing here for column and row numbers
  for i=1,level_menu.num_levels do
    local row = math.floor((i - 1) / 4)
    local col = i - row * num_columns - 1
    print(row, col)
    if save_data.level_stats[i] ~= nil and save_data.level_stats[i].completed == true then
      love.graphics.setColor(COLORS.green)
    else
      love.graphics.setColor(COLORS.red)
    end
    love.graphics.rectangle('fill', 100 + 200 * col, 100 + 200 * row, 100, 100)
    love.graphics.setColor(COLORS.black)
    love.graphics.print("L" .. i, 100 + 200 * col + 20, 100 + 200 * row + 20)
  end

end

function level_menu:keypressed(key)
  if key == "escape" then
    Gamestate.pop()
  end
end

return level_menu