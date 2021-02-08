after_action = {}

function after_action:enter(previous, level, points, kills)
  after_action.write_time = 0
  after_action.frame_time = 5
  after_action.line1_write_time = 3
  after_action.line2_write_time = 2
  after_action.line3_write_time = 2
  after_action.line1 = "Level " .. level .. " completed"
  after_action.line2 = "Earned  " .. points .. "  points"
  after_action.line3 = "Destroyed  " .. kills .. "  enemies"


end


function after_action:draw()
  love.graphics.setFont(arcade_font)
  reflowprint(after_action.write_time / after_action.line1_write_time - 1 , after_action.line1, 100, 100, 500, 200, 1, 1)
  reflowprint(after_action.write_time / after_action.line2_write_time - 2, after_action.line2, 100, 300, 500, 200, 1, 1)
  reflowprint(after_action.write_time / after_action.line3_write_time, after_action.line3, 100, 500, 500, 200, 1, 1)

end

function after_action:update(dt)
  after_action.write_time = after_action.write_time + dt

  if after_action.write_time / after_action.frame_time > 1.5 then
    Gamestate.switch(main_menu)
  end

end

return after_action