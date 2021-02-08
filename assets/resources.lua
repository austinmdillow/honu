-- All Sprites (images)
Sprites = {}
--Sprites.background = love.graphics.newImage()
--Sprites.player_img = love.graphics.newImage("assets/sp.png")
Sprites.coin_image = love.graphics.newImage("assets/coin_item-1.png")
Sprites.player_image = love.graphics.newImage("assets/Spaceship_01_ORANGE.png")
Sprites.enemy_image = love.graphics.newImage("assets/Spaceship_02_RED.png")
Sprites.enemy_fighter_image = love.graphics.newImage("assets/Spaceship_02_RED.png")
Sprites.particle_image = love.graphics.newImage("assets/particle.png")

background = love.graphics.newImage("assets/space.jpg")


-- Font time
Fonts = {}
Fonts.arcade_font = love.graphics.newFont("assets/fonts/ARCADECLASSIC.TTF", 40)

-- Sounds
Sounds = {}
Sounds.hit_1 = love.audio.newSource("assets/sounds/hit_1.wav", "static")
Sounds.hit_2 = love.audio.newSource("assets/sounds/hit_2.wav", "static")

-- Tile Maps
Maps = {}
Maps.test_map = Sti("assets/maps/test_map.lua", {'bump'})

ITEM_PIX_WIDTH = 32