death_screen = {}


function death_screen:draw()
  love.graphics.print("End... press ENTER to continue", 20, FRAME_HEIGHT - 20)
end

function death_screen:keypressed(key)
  if key == "return" then
    Gamestate.switch(main_menu)
  end
end

return death_screen