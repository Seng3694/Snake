require "core/transform"
require "core/color"

Label = Transform:new()
Label.text = ""
Label.font = nil
Label.color = 0x000000ff

function Label:draw()
    if self.font == nil or self.text == nil then return end

    love.graphics.setFont(self.font)
    love.graphics.setColor(convertColor(self.color))
    love.graphics.print(self.text, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy)
    love.graphics.reset()
end