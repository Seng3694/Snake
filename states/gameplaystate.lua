require "core/gamestate"
require "states/pausestate"
require "core/color"
require "tiling/map"
require "snake/snake"
require "core/queue"
require "core/sprite"
require "core/label"

GamePlayState = GameState:new()

function GamePlayState:load(map)
    self.inputQueue = Queue:new()
    self.map = Map:new()
    self.map:load(Content["Maps"][map])
    self.map.sx = 3
    self.map.sy = 3
    self.snake = Snake:new()
    self.snake:load(self.map)
    self.snake.sx = 3
    self.snake.sy = 3
    self.tickTime = 0.175
    self.elapsed = 0.0
    self.apple = Sprite:new()
    self.apple.img = Content["Images"]["Apple"]
    self.apple.sx = 3
    self.apple.sy = 3
    self.score = 0
    self.started = false
    self.mapName = map

    local x, y = love.graphics.getDimensions()
    self.controlsLabel = Label:new()
    self.controlsLabel.text = "Move:  [WASD]\nPause: [SPACE]\nExit:  [ESCAPE]\nMute:  [M]"
    self.controlsLabel.font = Content["Fonts"]["Consolas"]
    self.controlsLabel.x = x - self.controlsLabel.font:getWidth(self.controlsLabel.text)
    self.controlsLabel.y = self.controlsLabel.font:getHeight(self.controlsLabel.text) + 20
    self.controlsLabel.ox = self.controlsLabel.font:getWidth(self.controlsLabel.text) / 2
    self.controlsLabel.oy = self.controlsLabel.font:getHeight(self.controlsLabel.text) / 2
    self.controlsLabel.color = 0xffb200ff

    self.scoreLabel = Label:new()
    self.scoreLabel.x = 10
    self.scoreLabel.y = 685
    self.scoreLabel.text = "Score: " .. self.score
    self.scoreLabel.font = Content["Fonts"]["Consolas"]
    self.scoreLabel.color = 0xffb200ff

    self.scoreAddLabel = Label:new()
    self.scoreAddLabel.y = 685
    self.scoreAddLabel.font = Content["Fonts"]["Consolas"]
    self.scoreAddLabel.color = 0xffb200ff

    self.highscoreLabel = Label:new()
    self.highscoreLabel.y = 685
    self.highscoreLabel.font = Content["Fonts"]["Consolas"]
    self.highscoreLabel.color = 0xffb200ff
    if userdata[self.mapName] then
        self.highscoreLabel.text = "Highscore: " .. userdata[self.mapName]
    else 
        self.highscoreLabel.text = "Highscore: " .. 0
    end
    self.highscoreLabel.x = x - self.highscoreLabel.font:getWidth(self.highscoreLabel.text) - 20

    if userdata.muted then
        self.muted = userdata.muted
    else
        self.muted = false
    end

    self.volume = 0.1
    self.scoreAdd = 0
    self.fadeTime = 1
    self.fadeElapsed = 2
    self:spawnApple()

    Content["Sounds"]["Background"]:setLooping(true)
    if self.muted then
        Content["Sounds"]["Background"]:setVolume(0)
    else
        Content["Sounds"]["Background"]:setVolume(self.volume)
    end
    Content["Sounds"]["Background"]:play()
end

function GamePlayState:update(dt)
    if self.started then 
        self.elapsed = self.elapsed + dt
        self.fadeElapsed = self.fadeElapsed + dt

        if self.elapsed >= self.tickTime then
            self.elapsed = 0.0

            local key = self.inputQueue:dequeue()

            if key == "left" or key == "a" then
                self.snake:move("left")
            end
            if key == "right" or key == "d" then
                self.snake:move("right")
            end
            if key == "up" or key == "w" then
                self.snake:move("up")
            end
            if key == "down" or key == "s" then
                self.snake:move("down")
            end

            self.snake:tick()

            local collides, arg = self.snake:collidesWithSnake()

            if collides == true then
                self.snake:cutSnakeAt(arg)
            end

            collides, arg = self.snake:collidesWithMap(self.map)
            
            if collides == true and arg == "solid" then
                if not userdata[self.mapName] or userdata[self.mapName] < self.score then
                    userdata[self.mapName] = self.score
                    love.filesystem.write("userdata.lua", table.show(userdata, "userdata"))
                end
                self:load(self.mapName)
            elseif collides == true and arg == "gothrough" then
                if self.snake.realDirection == "right" then
                    self.snake.head.x = 1
                elseif self.snake.realDirection == "left" then
                    self.snake.head.x = self.map.width - 2
                elseif self.snake.realDirection == "up" then
                    self.snake.head.y = self.map.height - 2
                elseif self.snake.realDirection == "down" then
                    self.snake.head.y = 1
                end
            end

            if self.snake:collidesWithApple(self.apple) then
                self.fadeElapsed = 0
                self.scoreAddLabel.color = band(self.scoreAddLabel.color, 0xffffff00) + 0xff
                self.scoreAdd = math.floor((10 * (math.pow(#self.snake.body, 2))))
                self.score = self.score + self.scoreAdd
                self.scoreLabel.text = "Score: " .. self.score
                self.snake:grow()
                self:spawnApple()
                self.snake.head:play("eat")
            end
        end
        
        self.snake:update(dt)

        if self.fadeElapsed <= self.fadeTime then
            local scoreWidth = self.scoreLabel.font:getWidth(self.scoreLabel.text)
            a = (1 - (self.fadeElapsed / self.fadeTime)) * 255
            self.scoreAddLabel.color = band(self.scoreAddLabel.color, 0xffffff00) + a
            self.scoreAddLabel.text = "+" .. self.scoreAdd
            self.scoreAddLabel.x = scoreWidth + 20 
        end
    end
end

function GamePlayState:draw()
    love.graphics.clear()
    self.map:draw()
    self.apple.x = self.apple.x * 16 * self.apple.sx
    self.apple.y = self.apple.y * 16 * self.apple.sy
    self.apple:draw()
    self.apple.x = self.apple.x / 16 / self.apple.sx
    self.apple.y = self.apple.y / 16 / self.apple.sy
    self.snake:draw()
    self.scoreLabel:draw()
    self.highscoreLabel:draw()

    if not self.started or self.paused then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle(
            "fill", 
            self.controlsLabel.x - self.controlsLabel.ox - 10, 
            self.controlsLabel.y - self.controlsLabel.oy - 10, 
            self.controlsLabel.ox * 2 + 20, 
            self.controlsLabel.oy * 2 * 4 + 20)
        love.graphics.reset()
        self.controlsLabel:draw()
    end

    if self.fadeElapsed <= self.fadeTime then
        self.scoreAddLabel:draw()
    end
end

function GamePlayState:keypressed(key)
    if key == "left" or key == "a" 
        or key == "right" or key == "d" 
        or key == "up" or key == "w" 
        or key == "down" or key == "s" then
            if self.inputQueue.count < 2 and self.inputQueue:peek() ~= key then
                self.inputQueue:enqueue(key)
            end
     end

    if key == "escape" then
        love.filesystem.write("userdata.lua", table.show(userdata, "userdata"))
        Content["Sounds"]["Background"]:stop()
        game.stateManager:pop()
    end

    if key == "space" then
        game.stateManager:push(PauseState:new())
    end

    if key == "m" then
        if self.muted then
            self.muted = false
            userdata.muted = self.muted
            Content["Sounds"]["Background"]:setVolume(self.volume)
        else 
            self.muted = true
            userdata.muted = self.muted
            Content["Sounds"]["Background"]:setVolume(0)
        end
    elseif self.started == false then
        self.started = true
    end
end

function GamePlayState:spawnApple()
    local x, y = 0
    local invalid = true
    while invalid do
        invalid = false
        x = love.math.random(0, self.map.width - 1)
        y = love.math.random(0, self.map.height - 1)

        if self.map:isSolidTile(x, y) or self.map:isGoThroughTile(x, y) then
            invalid = true
        elseif self.snake.head.x == x and self.snake.head.y == y then
            invalid = true
        else
            for i = 1, #self.snake.body, 1 do
                if self.snake.body[i].x == x and self.snake.body[i].y == y then
                    invalid = true
                    break
                end
            end
        end
    end

    self.apple.x = x
    self.apple.y = y
end