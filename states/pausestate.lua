require "core/gamestate"
require "core/color"
require "core/label"
require "core/math"

PauseState = GameState:new()

function PauseState:load()
    self.transparent = true
    self.pauseLabel = Label:new()
    self.pauseLabel.font = Content["Fonts"]["SubTitle"]
    self.pauseLabel.text = "Pause"
    local x, y = love.graphics.getDimensions()
    self.pauseLabel.x = x / 2
    self.pauseLabel.y = y / 2 - 30
    self.pauseLabel.ox = self.pauseLabel.font:getWidth(self.pauseLabel.text) / 2
    self.pauseLabel.oy = self.pauseLabel.font:getHeight(self.pauseLabel.text) / 2
    self.pauseLabel.color = 0xffb200dd
end

function PauseState:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
    love.graphics.reset()
    self.pauseLabel:draw()
end

function PauseState:keypressed(key)
    if key == "space" then
        game.stateManager:pop()
    end
    if key == "escape" then
        game.stateManager:pop()
        game.stateManager:pop()
        Content["Sounds"]["Background"]:stop()
    end
end