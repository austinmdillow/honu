
function setupMap(m, w)
    assert(m, w)
    verifyMap(m)
    setupMapPhysics(m, w)
    setupMapCallbacks(m)
end   

    

function setupMapCallbacks(map, world)
  assert(map)


    function map.layers.sprite_layer:draw()
        for _, sprite in pairs(self.objects) do
            sprite:draw()
        end
    end

    function map.layers.sprite_layer:update(dt)
        local sprite_count = 0
        for _, sprite in pairs(self.objects) do
            sprite:update(dt)
            sprite_count = sprite_count + 1 -- count the number of enemies for debugging
        end
        game_data.sprites_alive = sprite_count -- update the number of enemies alive for debugging
    end


    function map.layers.bullet_layer:draw()
        for _, bullet in pairs(self.objects) do
            bullet:draw()
        end
    end

    function map.layers.bullet_layer:update(dt)
        for _, bullet in pairs(self.objects) do
            bullet:update(dt)
            if outOfBounds(bullet.coord) or bullet:isDead() then
                bullet:cleanup()
                map.layers.bullet_layer.objects[_] = nil
            end
        end
    end
end


function setupMapPhysics(map, world)
  map:bump_init(world)
end


-- verify that the map is structured the way we expect it to be
function verifyMap(map)

  --verify the structure and contents of the spawn_layer
  assert(map.layers.spawn_layer)
  for key, spawn in pairs(map.layers.spawn_layer.objects) do
    print(spawn.x, spawn.y)
    assert(spawn.x)
    assert(spawn.y)
    assert(spawn.properties.type)
  end

  assert(map.layers.item_layer)
  for key, item in pairs(map.layers.item_layer.objects) do
    print(item.x, item.y)
    assert(item.x)
    assert(item.y)
    assert(item.properties.type)
  end
end