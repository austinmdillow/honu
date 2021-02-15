map_gameplay = {}


function map_gameplay:enter()
    -- TODO reload the entire map when we re-enter the world
    map_gameplay.level_map = Sti("assets/maps/test_map.lua", {'bump'})
    map_gameplay.level_world = Bump.newWorld(32)
    setupMap(map_gameplay.level_map, map_gameplay.level_world)
    game_data.level_score = 0 --reset the score for this level
    game_data.level_kills = 0 -- not used
    game_data.player:reset() -- give the player back their health
    --game_data.bullet_list = {} -- empty out the agents in the field
    --game_data.enemy_list = {}
    game_data.item_list = {}
    map_gameplay.events_list = {}
    game_data.player:setXYT(500, 500, 0) -- this should get replaced

    map_gameplay.spawner = MapSpawner(map_gameplay.level_map, map_gameplay.level_world, game_data.current_level)
    game_data.player:setupBump(map_gameplay.level_world)
    game_data.player:setupMap(map_gameplay.level_map)
end

function map_gameplay:update(dt)

    --lovebird.update()
    screen:update(dt)
    

    if (not game_data.gameplay_paused) then
        map_gameplay.level_map:update(dt)

        local dx,dy = game_data.player.coord.x - camera.x, game_data.player:getY() - camera.y
        --camera:move(dx/2, dy/2)
        camera:lockPosition(game_data.player.coord.x, game_data.player.coord.y, camera.smoother)

        for key, item in pairs(game_data.item_list) do
            item:update(dt)
        end

        -- updatee other odds and ends
        checkMapCollisions()
        map_gameplay.spawner:update(dt)
        updateHud(dt)
        checkEndLevel(1)
        map_gameplay:checkEvents()
    end

end

-- Drawing time
function map_gameplay:draw()
    camera:attach()
    love.graphics.setColor(1,1,1, .7)
    love.graphics.draw(background)

    screen:apply(dt)

    --game_data.player:draw()

    -- Draw the Enemies
    for index, enemy in pairs(game_data.enemy_list) do
        --enemy:draw()
    end

    -- Draw the bullets
    for index, bullet in pairs(game_data.bullet_list) do
        --bullet:draw()
    end

    -- Draw the items
    for index, item in pairs(game_data.item_list) do
        item:draw()
    end
    drawBoundaries()

    --map:draw()
    local tx = camera.x - love.graphics.getWidth() / 2
	local ty = camera.y - love.graphics.getHeight() / 2
    camera:detach()
    map_gameplay.level_map:draw(-tx, -ty, camera.scale, camera.scale)
    love.graphics.setColor(COLORS.red)
    map_gameplay.level_map:bump_draw(-tx, -ty, camera.scale, camera.scale)
    
    

    drawHUD()

    if game_data.mode == "server" then
        drawServerDebug()
    elseif game_data.mode == "single" then
        --drawDebugInfo()
    end

    drawDebugInfo()

end

function map_gameplay:checkEvents()
    map_gameplay.events_list = {}
    for _, trigger in pairs(map_gameplay.level_map.layers.triggers.objects) do
        if trigger.properties.active == true then
            if trigger.shape == "rectangle" then
                if PointWithinRectangle(trigger.x, trigger.y, trigger.width, trigger.height, game_data.player:getX(), game_data.player:getY()) then
                    print("Inside a Trigger ", trigger.properties.trigger_name)
                    trigger.properties.active = false
                    table.insert(map_gameplay.events_list, trigger.properties.trigger_name)
                end
            end
        end
    end
end

function map_gameplay:keypressed(key)
    if key == "e" then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        --table.insert(game_data.enemy_list, game_data.current_enemy_number, Enemy(500,500))
        local tmp_enemy = Enemy(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        game_data.enemy_list[game_data.current_enemy_number] = tmp_enemy
    end

    if key == "q" then
        game_data.current_enemy_number = game_data.current_enemy_number + 1
        --table.insert(game_data.enemy_list, game_data.current_enemy_number, Enemy(500,500))
        local tmp_enemy = EnemyFighter(love.math.random(500), love.math.random(500))
        tmp_enemy.id = game_data.current_enemy_number
        table.instert(game_data.enemy_list, tmp_enemy)
    end

    if game_data.mode == "single" then
        local result = game_data.player:keypressed(key)
    end

    if key == "s" then
        print("saving")
        local tmp_save_data = {}
        tmp_save_data.score = game_data.score
        print(SaveData.save(tmp_save_data, "savefile"))
    end

    if key == "i" then
        table.insert(game_data.item_list, Item(100, 100))
    end

    if key == "p" then
        game_data.gameplay_paused = not game_data.gameplay_paused
    end

    if key == "escape" then
        Gamestate.switch(main_menu)
    end

    if key == "]" then
        game_data.player:setXYandBump(300,500)
    end

    if key == "[" then
        for idx_item, item in pairs(game_data.item_list) do
            print(idx_item, item)
        end
    end
end

function checkEndLevel(level_number)

    if game_data.player:dead() then
        print("Player has died")
        Gamestate.switch(death_screen)
    end

    if map_gameplay.spawner:completed() then
        if save_data.level_stats[game_data.current_level] == nil then -- create a new entry to save level data
            save_data.level_stats[game_data.current_level] = {}
        end
        save_data.level_stats[game_data.current_level].completed = true
        save_data.level_stats[game_data.current_level].kills = game_data.level_kills -- change to get from the spawner
        save_data.level_stats[game_data.current_level].score = game_data.level_score
        game_data.current_level = game_data.current_level + 1
        Gamestate.switch(after_action, game_data.current_level - 1, game_data.level_score, game_data.level_kills)
    end

end

function checkMapCollisions()
    local start_time_col = love.timer.getTime()
    local num_checks = 0
    local bullet_list = map_gameplay.level_map.layers.bullet_layer.objects

    local items_col, len = map_gameplay.level_world:getItems()
    for ii, kk in pairs(items_col) do 
        print(ii, kk)
    end
    for idx_bullet, bullet in pairs(bullet_list) do
        local bullet_x, bullet_y = bullet:getXY()
        -- for each collision that a bullet has
        for idx_collisions, collision in pairs(bullet:getCollisions()) do
            if collision.other.layer ~= nil then -- this means that we are colliding with an object from the tilemap
                print("Tile colisions ", bullet)
                bullet:cleanup() --remove the bullet from the bump world
                bullet_list[idx_bullet] = nil -- remove the bullet from the list
                break
            end
        end

        local entity_list = map_gameplay.level_map.layers.sprite_layer.objects
        for idx_entity, entity in pairs(entity_list) do
            num_checks = num_checks + 1
            -- there was a hit
            --print("collisions hit ", entity, bullet.team)
            if entity.team ~= bullet.team and entity.coord:distanceToPoint(bullet_x, bullet_y) < entity.hitbox + bullet.size then
                bullet:cleanup() -- TODO: THIS CAN BREAK IF THE BULLET ALSO HITS A WALL
                bullet_list[idx_bullet] = nil
                -- there is a hit
                print("Entity Collision ", bullet)
                
                Sounds.hit_2:clone():play()

                if entity:damage(bullet.damage) then -- the bullet killed the enemy
                    if entity == game_data.player then
                        print("Platerere deado")
                    else
                        entity_list[idx_entity] = nil
                        entity:cleanup()
                        screen:shake(50)
                        game_data.level_score = game_data.level_score + entity.difficulty
                        game_data.level_kills = game_data.level_kills + 1
                        table.insert(game_data.item_list, Item(entity:getXY()))
                    end
                end
            end
        end
        print("End of Check ", bullet)

    end

    for idx_item, item in pairs(game_data.item_list) do
        num_checks = num_checks + 1
        if item.coord:distanceToCoord(game_data.player.coord) < item.size + game_data.player.size then
            game_data.item_list[idx_item] = nil
            game_data.level_score = game_data.level_score + 1
            game_data.coins = game_data.coins + 1
        end
    end
    local end_time_col = love.timer.getTime()
    --print("Checks " .. num_checks) -- print out the number of checks that had to happen in checkCollisions()
end

function drawBoundaries()
    love.graphics.setColor(1,1,1)
    love.graphics.polygon('line', 0,0, game_data.map_properties.width,0, game_data.map_properties.width,game_data.map_properties.height, 0,game_data.map_properties.height)
end

return gameplay