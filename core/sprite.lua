require "core/transform"

Sprite = Transform:new()
Sprite.img = nil
Sprite.quad = nil

function Sprite:draw()
    if self.img == nil then return end
    
    if self.quad == nil then
        love.graphics.draw(
            self.img, 
            self.x,
            self.y,
            self.r,
            self.sx,
            self.sy,
            self.ox,
            self.oy
        )
    else
        love.graphics.draw(
            self.img, 
            self.quad,
            self.x,
            self.y,
            self.r,
            self.sx,
            self.sy,
            self.ox,
            self.oy
        )
    end
end