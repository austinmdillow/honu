--love.filesystem.setRequirePath( "..?.lua;?/init.lua" )


Object = require "lib.mylove.classic"
Camera = require "lib.hump.camera"
smoothie = Camera.smooth.damped(.1)
screen = require "lib.shack.shack"
 
Gamestate = require "lib.hump.gamestate"
SaveData = require "lib.savedata.saveData"
lovebird = require "lib.mylove.lovebird"
Timer = require "lib.hump.timer"
reflowprint = require "lib.reflowprint.init"
Sti = require "lib.sti"

require "lib.mylove.colors"
require "lib.mylove.intersections"
require "lib.mylove.entity"
require "lib.mylove.coord"
require "lib.hump.gamestate"
require "lib.menuengine"


require "entities.ship"
require "entities.player"
require "entities.bullet"
require "entities.enemy"
require "entities.enemy_fighter"
require "entities.item"
require "entities.definitions"

require "weapons.gun"
require "weapons.machinegun"
require "weapons.shotgun"


require "utils.serverCallbacks"
require "utils.debugging"
require "utils.hud"
require "utils.spawner"
require "utils.map_spawner"
require "utils.map_utils"
require "utils.upgrade_node"
require "utils.upgrade_manager"
require "utils.interractions"


require "assets.resources"

-- all gamestates
local main_menu = require("states.main_menu")
local gameplay = require("states.gameplay")
local map_gameplay = require("states.map_gameplay")
local death_screen = require("states.death_screen")
local upgrade_menu = require("states.upgrade_menu")
local level_menu = require("states.level_menu")
local after_action = require("states.after_action")

upgrade_manager = UpgradeManager()

VERSION = "0.1" -- not used at all

game_data = { -- where we store all global variables related to gameplay
    mode = "single",
    --client_list = {},
    local_player = nil,
    score = 0,
    coins = 100,
    current_level = 1,
    --level_score = 0,
    enemy_list = {},
    current_enemy_number = 0,
    enemies_alive = 0,
    bullet_list = {},
    item_list = {},
    map_properties = {
        width = 2000,
        height = 1000
    },
    gameplay_paused = false,
}

-- default save values that will be loaded and written
save_data = {
    score = 0,
    level_stats = {
        {
            kills = 0,
            completed = false,
            score = 0
        }
    }
}

local debug_data = {
    rxtx_alpha = .1,
    last_rx = 0,
    rx_rate = 0,
    last_tx = 0,
    tx_rate = 0
}

local start_time = love.timer.getTime()
FRAME_WIDTH, FRAME_HEIGHT = love.graphics.getDimensions()

function love.load()
    delta_t = 0
    if game_data.mode == "single" then
        game_data.local_player = Player(200, 200)
    elseif game_data.mode == "online" then
        -- Creating a server on any IP, port 22122
        server = sock.newServer("192.168.0.10", 22122)
        
        -- Called when someone connects to the server
        server:on("connect", onNewConnectionCallback)

        server:on("update", onUpdateCallback)

        server:on("bullet", onBulletCallback)

        server:on("disconnect", function(data, client)
            -- Send a message back to the connected client
            local msg = "failed"
        end)
    end
    camera = Camera(400,400)
    camera.smoother = Camera.smooth.damped(3)
    Gamestate.registerEvents()
    Gamestate.switch(main_menu)
    print(save_data.level_stats[1].kills)
end



function love.update(dt)
     
end


function love.draw()
    
end


function outOfBounds(coord)
    if coord.x < 0 or coord.x > game_data.map_properties.width then
        return true
    end

    if coord.y < 0 or coord.y > game_data.map_properties.height then
        return true
    end

    return false
end

-- Global actions for a key press
function love.keypressed(key)

end