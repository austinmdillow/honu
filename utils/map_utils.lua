
function setupMapCallbacks(map, world)
  assert(map)


  function map.layers.sprite_layer:draw()
      for _, sprite in pairs(self.objects) do
        sprite:draw()
      end
  end


  function map.layers.sprite_layer:update(dt)
      for _, sprite in pairs(self.objects) do
        sprite:update(dt)
      end
  end
end



function verifyMap(map)
  assert(map.layers.spawn_layer)
  for key, spawn in pairs(map.layers.spawn_layer.objects) do
    print(spawn.x, spawn.y)
    assert(spawn.x)
    assert(spawn.y)
    assert(spawn.properties.delay)
    assert(spawn.properties.type)
  end
end