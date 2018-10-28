require "core/stack"

GameStateManager = {}

function GameStateManager:new()
    local newObj = {
        states = Stack:new()
    }
    self.__index = self

    return setmetatable(newObj, self)
end

function GameStateManager:update(dt)
    if self.states.count > 0 then
        self.states:peek():update(dt)
    end
end

function GameStateManager:draw()
    for i = 1, self.states.count, 1 do
        if i < self.states.count and self.states.items[i + 1].transparent then
            self.states.items[i]:draw()
        else
            self.states.items[i]:draw()
        end
    end
end

function GameStateManager:push(state, ...)
    if state ~= nil then 
        self.states:push(state)
        self.states:peek():load(...)
    end
end

function GameStateManager:pop()
    self.states:pop()

    if self.states.count > 0 then
        self.states:peek():reload()
    end
end

function GameStateManager:keypressed(key)
    if self.states.count > 0 then
        self.states:peek():keypressed(key)
    end
end

function GameStateManager:keyreleased(key)
    if self.states.count > 0 then
        self.states:peek():keyreleased(key)
    end
end

function GameStateManager:mousemoved(x, y, dx, dy)
    if self.states.count > 0 then
        self.states:peek():mousemoved(x, y, dx, dy)
    end
end

function GameStateManager:mousepressed(x, y, button, presses)
    if self.states.count > 0 then
        self.states:peek():mousepressed(x, y, button, presses)
    end
end

function GameStateManager:mousereleased(x, y, button, presses)
    if self.states.count > 0 then
        self.states:peek():mousereleased(x, y, button, presses)
    end
end