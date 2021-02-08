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

function MapSpawner:new(map, level)
  assert(map)
  assert(level)
  self.map = map
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


-- DEPRICATED
function MapSpawner:spawn(enemy_obj, type, x, y)
  x = x or love.math.random(500)
  y = y or love.math.random(500)
  print(x, y)
  game_data.current_enemy_number = game_data.current_enemy_number + 1
  local tmp_enemy = nil
  if self.sequence.type == "fighter" then
    tmp_enemy = EnemyFighter(x, y)
  else
    tmp_enemy = Enemy(x, y)
  end
  tmp_enemy.id = game_data.current_enemy_number
  table.insert(game_data.enemy_list, tmp_enemy)
  self.wave_spawns = self.wave_spawns + 1
  self.level_spawns = self.level_spawns + 1
  self.last_spawn_time = 0
end

function MapSpawner:update(dt)
    self.map_time = self.map_time + dt -- keep track of how long it's been since we loaded in this map
    self.last_spawn_time = self.last_spawn_time + dt

    if self.sequence ~= nil then
      assert(self.sequence.wave_num == self.current_wave)
      if self.last_spawn_time > self.sequence.time_spacing and game_data.enemies_alive < self.sequence.max_alive and self.wave_spawns < self.sequence.total_enemies then
        self:spawn()
      end

      if self.wave_spawns >= self.sequence.total_enemies and game_data.enemies_alive == 0 then -- check if we need to switch to another wave
        self.wave_spawns = 0
        self.current_wave = self.current_wave + 1
        self.sequence = spawn_sequences[self.current_level][self.current_wave]
      end
    end
end

function MapSpawner:spawnFromMap()
  print("printing spwan Layers")
  for _, spawn_point in pairs(self.map.layers.spawn_layer.objects) do
    print(_, spwan_point, spawn_point.x)
    self:spawnEnemyFromPoint(spawn_point, self.map.layers.sprite_layer.objects)
    print("Enemy layer")
    for k, v in pairs(self.map.layers.sprite_layer.objects) do
      print(k, v)
    end
  end
end

-- spawn an enemy at a given point
function MapSpawner:spawnEnemyFromPoint(point, spawn_table)
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
  table.insert(spawn_table, tmp_enemy)
  self.wave_spawns = self.wave_spawns + 1
  self.level_spawns = self.level_spawns + 1
  self.last_spawn_time = 0
end

function MapSpawner:getWave()
  return self.current_wave
end

function MapSpawner:completed()
  return self.sequence == nil
end

function MapSpawner:getLevel()
  return self.current_level
end