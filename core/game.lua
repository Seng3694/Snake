require "core/gamestatemanager"
require "states/gameplaystate"
require "states/titlestate"
require "content/resources"

Game = {}

function Game:new()
    local newObj = {
        stateManager = GameStateManager:new()
    }
    self.__index = self

    return setmetatable(newObj, self)
end

function Game:load()
    self.stateManager:push(TitleState:new())
end

function Game:update(dt)
    for e in love.event.poll() do
        if e == "quit" then
            love.event.quit()
        end
    end

    self.stateManager:update(dt)

    if self.stateManager.states.count == 0 then
        love.event.quit()
    end
end

function Game:draw()
    self.stateManager:draw()
end

function Game:keypressed(key)
    self.stateManager:keypressed(key)
end

function Game:keyreleased(key)
    self.stateManager:keyreleased(key)
end

function Game:mousemoved(x, y, dx, dy)
    self.stateManager:mousemoved(x, y, dx, dy)
end

function Game:mousepressed(x, y, button, presses)
    self.stateManager:mousepressed(x, y, button, presses)
end

function Game:mousereleased(x, y, button, presses)
    self.stateManager:mousereleased(x, y, button, presses)
end