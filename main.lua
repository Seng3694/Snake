require "core/game"
require "ext/serialization"
Content = require "content/resources"

function love.load()
    love.mouse.setVisible(false)

    local chunk, error = love.filesystem.load("userdata.lua")
    if not error then
        chunk()
    else
        userdata = {}
    end

    game = Game:new()
    game:load()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.keyreleased(key)
    game:keyreleased(key)
end

function love.mousemoved(x, y, dx, dy, isTouch)
    game:mousemoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button, isTouch, presses)
    game:mousepressed(x, y, button, presses)
end

function love.mousereleased(x, y, button, isTouch, presses)
    game:mousereleased(x, y, button, presses)
end