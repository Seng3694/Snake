require "core/gamestate"
require "states/gameplaystate"
require "core/color"
require "core/label"
require "core/math"

TitleState = GameState:new()

function TitleState:load()
    self.title = Label:new()
    self.title.font = Content["Fonts"]["Title"]
    self.title.text = "Snake"
    local x, y = love.graphics.getDimensions()
    self.title.x = 0
    self.title.y = 0
    self.title.ox = self.title.font:getWidth(self.title.text) / 2
    self.title.oy = self.title.font:getHeight(self.title.text) / 2
    self.title.color = 0x00ff10ff

    self.startX = 80
    self.startY = y - 50
    self.anchorX = x - 100
    self.anchorY = y - 70
    self.destX = x / 2
    self.destY = y / 2 - 50
    self.lerpIndex = 0
    self.destinationReached = false
    self.lerpSpeed = 0.8

    self.pressStartText = Label:new()
    self.pressStartText.x = x / 2
    self.pressStartText.y = y / 2 + 40
    self.pressStartText.font = Content["Fonts"]["SubTitle"]
    self.pressStartText.text = "enter  to  start"
    self.pressStartText.ox = self.pressStartText.font:getWidth(self.pressStartText.text) / 2
    self.pressStartText.oy = self.pressStartText.font:getHeight(self.pressStartText.text) / 2
    self.pressStartText.color = 0x265e19ff

    self.mapTable = {}

    local i = 1
    for k, __ in pairs(Content["Maps"]) do
        self.mapTable[i] = k
        i = i + 1
    end

    self.mapSelector = Label:new()
    self.mapSelector.x = x / 2
    self.mapSelector.y = y / 2 + 10
    self.mapSelector.font = Content["Fonts"]["SubTitle"]
    self.selectedMap = 1
    self.mapSelector.text = self.mapTable[self.selectedMap]
    self.mapSelector.ox = self.mapSelector.font:getWidth(self.mapSelector.text) / 2
    self.mapSelector.oy = self.mapSelector.font:getHeight(self.mapSelector.text) / 2
    self.mapSelector.color = 0xffb200ff

    self.mapSelectorL = Label:new()
    self.mapSelectorL.font = Content["Fonts"]["SubTitle"]
    self.mapSelectorL.text = self.mapTable[overflowclamp(self.selectedMap - 1, 1, #self.mapTable)]
    self.mapSelectorL.x = x / 2 - self.mapSelector.font:getWidth(self.mapSelector.text) / 2 - self.mapSelectorL.font:getWidth(self.mapSelectorL.text) / 2 - 20
    self.mapSelectorL.y = y / 2 + 10
    self.mapSelectorL.ox = self.mapSelectorL.font:getWidth(self.mapSelectorL.text) / 2
    self.mapSelectorL.oy = self.mapSelectorL.font:getHeight(self.mapSelectorL.text) / 2
    self.mapSelectorL.color = 0xffb20066

    self.mapSelectorR = Label:new()
    self.mapSelectorR.font = Content["Fonts"]["SubTitle"]
    self.mapSelectorR.text = self.mapTable[overflowclamp(self.selectedMap + 1, 1, #self.mapTable)]
    self.mapSelectorR.x = x / 2 + self.mapSelector.font:getWidth(self.mapSelector.text) / 2 + self.mapSelectorR.font:getWidth(self.mapSelectorR.text) / 2 + 20
    self.mapSelectorR.y = y / 2 + 10
    self.mapSelectorR.ox = self.mapSelectorR.font:getWidth(self.mapSelectorR.text) / 2
    self.mapSelectorR.oy = self.mapSelectorR.font:getHeight(self.mapSelectorR.text) / 2
    self.mapSelectorR.color = 0xffb20066
end

function TitleState:update(dt)
    if not self.destinationReached then
        if self.lerpIndex >= 1 then
            self.destinationReached = true
        end

        self.title.x, self.title.y = lerp2(self.startX, self.startY, self.anchorX, self.anchorY, self.destX, self.destY, self.lerpIndex)
        self.lerpIndex = self.lerpIndex + dt * self.lerpSpeed
    end
end

function TitleState:draw()
    love.graphics.clear(convertColor(0x001100ff))
    self.title:draw()

    if self.destinationReached then
        self.pressStartText:draw()
        self.mapSelector:draw()
        self.mapSelectorL:draw()
        self.mapSelectorR:draw()
    end
end

function TitleState:keypressed(key)
    if key == "left" or key == "a" then
        self.selectedMap = overflowclamp(self.selectedMap - 1, 1, #self.mapTable)
        self.mapSelector.text = self.mapTable[self.selectedMap]
        self.mapSelector.ox = self.mapSelector.font:getWidth(self.mapSelector.text) / 2
        self.mapSelector.oy = self.mapSelector.font:getHeight(self.mapSelector.text) / 2
        
        self.mapSelectorL.text = self.mapTable[overflowclamp(self.selectedMap - 1, 1, #self.mapTable)]
        self.mapSelectorL.ox = self.mapSelectorL.font:getWidth(self.mapSelector.text) / 2
        self.mapSelectorL.oy = self.mapSelectorL.font:getHeight(self.mapSelector.text) / 2
        
        self.mapSelectorR.text = self.mapTable[overflowclamp(self.selectedMap + 1, 1, #self.mapTable)]
        self.mapSelectorR.ox = self.mapSelectorR.font:getWidth(self.mapSelector.text) / 2
        self.mapSelectorR.oy = self.mapSelectorR.font:getHeight(self.mapSelector.text) / 2
    
    end
    if key == "right" or key == "d" then
        self.selectedMap = overflowclamp(self.selectedMap + 1, 1, #self.mapTable)
        self.mapSelector.text = self.mapTable[self.selectedMap]
        self.mapSelector.ox = self.mapSelector.font:getWidth(self.mapSelector.text) / 2
        self.mapSelector.oy = self.mapSelector.font:getHeight(self.mapSelector.text) / 2

        self.mapSelectorL.text = self.mapTable[overflowclamp(self.selectedMap - 1, 1, #self.mapTable)]
        self.mapSelectorL.ox = self.mapSelectorL.font:getWidth(self.mapSelector.text) / 2
        self.mapSelectorL.oy = self.mapSelectorL.font:getHeight(self.mapSelector.text) / 2
        
        self.mapSelectorR.text = self.mapTable[overflowclamp(self.selectedMap + 1, 1, #self.mapTable)]
        self.mapSelectorR.ox = self.mapSelectorR.font:getWidth(self.mapSelector.text) / 2
        self.mapSelectorR.oy = self.mapSelectorR.font:getHeight(self.mapSelector.text) / 2
    end

    if self.destinationReached and key == "return" then
        game.stateManager:push(GamePlayState:new(), self.mapSelector.text)
    end

    if not self.destinationReached and key == "return" then
        self.lerpIndex = 1
    end

    if key == "escape" then
        game.stateManager:pop()
    end
end