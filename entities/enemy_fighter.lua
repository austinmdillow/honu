EnemyFighter = Enemy:extend()

function EnemyFighter:new(x_start, y_start, dir_start)
    EnemyFighter.super.new(self, x_start, y_start, dir_start)
    self.max_speed = 320
    self.color = {1,1,0}
    self.radius = 10
    self.current_speed = 0
    self.roation_speed = 45 * math.pi / 180 -- deg / s
    self.size = 40
    self.difficulty = 2
    self.sprite_image = sprites.enemy_fighter_image
    self.equipped_weapon = Gun(5, 10, 2)
end


function EnemyFighter:draw()
    EnemyFighter.super.draw(self)
end