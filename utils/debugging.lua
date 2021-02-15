function drawDebugInfo()
  local start_x = FRAME_WIDTH - 150
  local fps = love.timer.getFPS()
  local stats = love.graphics.getStats( )
  love.graphics.setColor(1,0,0)
  love.graphics.print("FPS " .. fps, start_x, 5)
  love.graphics.print("Stats " .. collectgarbage("count"), start_x, 25)
end


function printTableContents(table_in)
  print("Printing Table: ", table_in)
  for k, v in pairs(table_in) do
    print(k,v)
  end
end
