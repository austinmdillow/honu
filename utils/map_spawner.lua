-- The MapSpawner handles what and when to spawn enemies based on the current level.
-- It must be updated in the game loop
-- spawn_sequences hold all info needed to spawn enemis
MapSpawner = Object:extend()

local spawn_sequences = {
  { 
    level = 1,
    {
      wave_num = 1,
      total_enemies = 1,
      type = "fighter",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = .6,
      max_alive = 3
    },
    {
      wave_num = 2,
      total_enemies = 1,
      type = "fighter",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = 3,
      max_alive = 3
    }
  },

  { 
    level = 2,
    {
      wave_num = 1,
      total_enemies = 2,
      type = "default",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = .6,
      max_alive = 3
    },
    {
      wave_num = 2,
      total_enemies = 3,
      type = "fighter",
      spawn_location = {
        x = 400,
        y = 10,
        t = 0
      },
      time_spacing = 3,
      max_alive = 3
    }
  }
}

function MapSpawner:new(map, world, level)
  assert(map)
  assert(level)
  self.map = map
  self.world = world
  self.current_level = level
  self.current_wave = 1
  assert(spawn_sequences[self.current_level].level == level)
  self.sequence = spawn_sequences[self.current_level][self.current_wave]
  self.last_spawn_time = 0
  self.wave_spawns = 0
  self.level_spawns = 0
  self.map_time = 0
  self:spawnFromMap()
end


function MapSpawner:update(dt)
    self.map_time = self.map_time + dt -- keep track of how long it's been since we loaded in this map
    self.last_spawn_time = self.last_spawn_time + dt
end

function MapSpawner:spawnFromMap()
  print("printing spwan Layers")
  for _, spawn_point in pairs(self.map.layers.spawn_layer.objects) do
    print(_, spawn_point, spawn_point.x, spawn_point.y)
    if spawn_point.properties.type == "player" then
      print("spawning Player")
      table.insert(self.map.layers.sprite_layer.objects, game_data.player)
      game_data.player:setXY(spawn_point.x, spawn_point.y)

    elseif self.map_time > spawn_point.properties.delay then
      self:spawnEnemyFromPoint(spawn_point)
    end
  end
end

-- spawn an enemy at a given point
function MapSpawner:spawnEnemyFromPoint(point)
  local x = point.x
  local y = point.y
  local type = point.type or "default"
  print("Spawning ", x, y, point)
  assert(x)
  assert(y)
  
  local tmp_enemy = nil
  if point == "fighter" then
    tmp_enemy = EnemyFighter(x, y)
  else
    tmp_enemy = Enemy(x, y)
  end

  tmp_enemy.id = game_data.current_enemy_number
  tmp_enemy:setupMap(self.map)
  tmp_enemy:setupBump(self.world)
  table.insert(self.map.layers.sprite_layer.objects, tmp_enemy)
  self.wave_spawns = self.wave_spawns + 1
  self.level_spawns = self.level_spawns + 1
  self.last_spawn_time = 0
end

function MapSpawner:getWave()
  return self.current_wave
end

function MapSpawner:completed()
  return false -- TODO always returns false
  --return self.sequence == nil
end

function MapSpawner:getLevel()
  return self.current_level
end