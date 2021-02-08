function onUpdateCallback(data, client)
  --print(#game_data.client_list)
  local index = client:getIndex()
  if game_data.client_list[index] ~= nil then
      game_data.client_list[index]:setXYT(data.x, data.y, data.t)
  else
      print("NIL")
  end
end

function onBulletCallback(data, client)
  local index = client:getIndex()
  local connect_id = client:getConnectId()
  local tmp_bullet = Bullet(data.x, data.y, data.t)
  tmp_bullet:setId(connect_id)
  table.insert(game_data.bullet_list, tmp_bullet)
end

function onNewConnectionCallback(data, client)
  -- Send a message back to the connected client
  local start_x_avg, start_y_avg = 150, 150
  local start_jitter = 50
  local start_x, start_y = love.math.random(start_x_avg - start_jitter, start_x_avg + start_jitter), love.math.random(start_y_avg - start_jitter, start_y_avg + start_jitter)
  local index = client:getIndex()
  local connect_id = client:getConnectId()
  
  print("Connected to a client with id ", client:getConnectId(), client:getAddress(), index)
  local tmp_player = Player(start_x, start_y)
  game_data.client_list[index] = Player(100,100)
  game_data.client_list[index]:setColorRandom()
  start_time = love.timer.getTime()
end

function sendClientStartInfo(client)
  local msg = "Hello from the server!"
  client:send("initData", msg)
end