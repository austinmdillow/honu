function checkCollisions()
    local start_time_col = love.timer.getTime()
    local num_checks = 0
    for idx_bullet, bullet in pairs(game_data.bullet_list) do
        local bullet_x, bullet_y = bullet:getXY()

        num_checks = num_checks + 1
        if bullet.source ~= game_data.local_player then
            if game_data.local_player.coord:distanceToPoint(bullet_x, bullet_y) < game_data.local_player.hitbox + bullet.size then
                game_data.local_player:damage(bullet.damage)
                screen:shake(20)
                sounds.hit_1:play()
                game_data.bullet_list[idx_bullet] = nil
            end 
        end

        for idx, enemy in pairs(game_data.enemy_list) do
            num_checks = num_checks + 1
            -- there was a hit
            if enemy.team ~= bullet.team and enemy.coord:distanceToPoint(bullet_x, bullet_y) < enemy.hitbox + bullet.size then
                game_data.bullet_list[idx_bullet] = nil
                sounds.hit_2:clone():play()
                if enemy:damage(bullet.damage) then -- the bullet killed the enemy
                    game_data.enemy_list[idx] = nil
                    screen:shake(50)
                    print("KILLLLEEDDD")
                    game_data.level_score = game_data.level_score + enemy.difficulty
                    game_data.level_kills = game_data.level_kills + 1
                    table.insert(game_data.item_list, Item(enemy:getXY()))
                end
            end
        end

    end

    for idx_item, item in pairs(game_data.item_list) do
        num_checks = num_checks + 1
        if item.coord:distanceToCoord(game_data.local_player.coord) < item.size + game_data.local_player.size then
            game_data.item_list[idx_item] = nil
            game_data.level_score = game_data.level_score + 1
            game_data.coins = game_data.coins + 1
        end
    end
    local end_time_col = love.timer.getTime()
    --print("Checks " .. num_checks) -- print out the number of checks that had to happen in checkCollisions()
end