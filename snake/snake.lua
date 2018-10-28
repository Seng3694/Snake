require "core/color"
require "core/sprite"
require "core/animatedsprite"
require "core/transform"
require "core/math"

Snake = Transform:new()

local tailQuad = nil
local curveBodyQuad = nil
local straightBodyQuad = nil

local straightTopDownRot = degToRad(0)
local straightLeftRightRot = degToRad(90)

local curveLeftDownRot = degToRad(270)
local curveLeftUpRot = degToRad(180)
local curveRightUpRot = degToRad(90)
local curveRightDownRot = degToRad(0)

local tailTopDownRot = degToRad(180)
local tailRightLeftRot = degToRad(90)
local tailDownTopRot = degToRad(0)
local tailLeftRightRot = degToRad(270)

local headDownRot = degToRad(0)
local headLeftRot = degToRad(90)
local headUpRot = degToRad(180)
local headRightRot = degToRad(270)

function Snake:load(map)
    for _, tile in pairs(Content["Tilesets"]["SnakeBody"].tiles) do
        if tile.name == "straight" then
            straightBodyQuad = tile.quad
        elseif tile.name == "curve" then
            curveBodyQuad = tile.quad
        elseif tile.name == "tail" then
            tailQuad = tile.quad
        end
    end

    self.canvas = love.graphics.newCanvas()
    self.canvas:setFilter("nearest", "nearest", 1)
    self.body = {}
    self.map = map

    for _, layer in pairs(map.objectgroups) do
        if layer.name == "SnakeLayer" then
            for _, obj in pairs(layer.objects) do
                if obj.type == "head" then
                    self.head = AnimatedSprite:new()
                    self.head.x, self.head.y = 
                        map:translateWindowToMap(map.x + obj.x + 1, map.y + obj.y + 1)
                    self.head:load("eat", Content["Animations"]["SnakeHead"])
                    self.head.ox = 8
                    self.head.oy = 8
                elseif obj.type == "body" then
                    table.insert(
                        self.body, 
                        tonumber(obj.name), 
                        Sprite:new()
                    )
                    self.body[tonumber(obj.name)].x, self.body[tonumber(obj.name)].y =
                        map:translateWindowToMap(map.x + obj.x + 1, map.y + obj.y + 1)
                    self.body[tonumber(obj.name)].ox, self.body[tonumber(obj.name)].oy = 8, 8
                end
            end
        end
    end

    if self.head.x == self.body[1].x then
        if self.head.y > self.body[1].y then
            self.direction = "down"
        else
            self.direction = "up"
        end
    elseif self.head.y == self.body[1].y then
        if self.head.x > self.body[1].x then
            self.direction = "right"
        else
            self.direction = "left"
        end
    end
    

    self.realDirection = self.direction
    self:adjustDirections()

    self.head.img = Content["Images"]["SnakeHead"]
    for _, p in pairs(self.body) do
        p.img = Content["Images"]["SnakeBody"]
    end
end

function Snake:move(direction)
    if direction == "up" and self.realDirection ~= "down" then
        self.direction = "up"
    elseif direction == "down" and self.realDirection ~= "up" then
        self.direction = "down"
    elseif direction == "right" and self.realDirection ~= "left" then
        self.direction = "right"
    elseif direction == "left" and self.realDirection ~= "right" then
        self.direction = "left"
    end
end

function Snake:tick()
    self.realDirection = self.direction

    for i = #self.body, 2, -1 do
        self.body[i].x = self.body[i - 1].x
        self.body[i].y = self.body[i - 1].y
    end

    self.body[1].x = self.head.x
    self.body[1].y = self.head.y

    if self.realDirection == "up" then
        self.head.y = self.head.y - 1
    elseif self.realDirection == "down" then
        self.head.y = self.head.y + 1
    elseif self.realDirection == "right" then
        self.head.x = self.head.x + 1
    elseif self.realDirection == "left" then
        self.head.x = self.head.x - 1
    end

    self:adjustDirections()
end

function Snake:adjustDirections()
    for i = #self.body, 1, -1 do
        if i == #self.body then
            self.body[i].quad = tailQuad
            local dir = nil
            if #self.body > 1 and i > 1 then
                dir = self:getRelativeDirection(self.body[i - 1], self.body[i])
            else
                dir = self:getRelativeDirection(self.head, self.body[i])
            end
            if dir == "left" then
                self.body[i].r = tailLeftRightRot
            elseif dir == "right" then
                self.body[i].r = tailRightLeftRot
            elseif dir == "up" then
                self.body[i].r = tailTopDownRot
            elseif dir == "down" then
                self.body[i].r = tailDownTopRot
            end
        else
            local dir1 = nil
            local dir2 = nil
            
            if #self.body > 2 and i > 1 then
                dir1 = self:getRelativeDirection(self.body[i], self.body[i - 1])
                dir2 = self:getRelativeDirection(self.body[i], self.body[i + 1])
            else
                dir1 = self:getRelativeDirection(self.body[i], self.head)
                dir2 = self:getRelativeDirection(self.body[i], self.body[i + 1])
            end
            
            if dir1 == "up" and dir2 == "down" or dir1 == "down" and dir2 == "up" then
                self.body[i].quad = straightBodyQuad
                self.body[i].r = straightTopDownRot
            elseif dir1 == "left" and dir2 == "right" or dir1 == "right" and dir2 == "left" then 
                self.body[i].quad = straightBodyQuad
                self.body[i].r = straightLeftRightRot
            elseif (dir1 == "left" and dir2 == "up") or (dir2 == "left" and dir1 == "up") then
                self.body[i].quad = curveBodyQuad
                self.body[i].r = curveLeftUpRot
            elseif (dir1 == "left" and dir2 == "down") or (dir2 == "left" and dir1 == "down") then
                self.body[i].quad = curveBodyQuad
                self.body[i].r = curveLeftDownRot
            elseif (dir1 == "right" and dir2 == "up") or (dir2 == "right" and dir1 == "up") then
                self.body[i].quad = curveBodyQuad
                self.body[i].r = curveRightUpRot
            elseif (dir1 == "right" and dir2 == "down") or (dir2 == "right" and dir1 == "down") then
                self.body[i].quad = curveBodyQuad
                self.body[i].r = curveRightDownRot
            end
        end
    end

    if self.realDirection == "up" then
        self.head.r = headUpRot
    elseif self.realDirection == "down" then
        self.head.r = headDownRot
    elseif self.realDirection == "right" then
        self.head.r = headRightRot
    elseif self.realDirection == "left" then
        self.head.r = headLeftRot
    end
end

function Snake:update(dt)
    self.head:update(dt)
end

function Snake:getRelativeDirection(p1, p2)
    if p1.x == p2.x then
        if p1.y == 1 and p2.y == self.map.height - 2 then
            return "up"
        elseif p1.y == self.map.height - 2 and p2.y == 1 then
            return "down"
        elseif p1.y > p2.y then
            return "up"
        else
            return "down"
        end
    elseif p1.y == p2.y then
        if p1.x == 1 and p2.x == self.map.width -2 then
            return "right"
        elseif p1.x == self.map.width - 2 and p2.x == 1 then
            return "left"
        elseif p1.x > p2.x then
            return "right"
        else
            return "left"
        end
    end
end

function Snake:grow()
    local new = Sprite:new()
    new.img = Content["Images"]["SnakeBody"]
    new.x, new.y = self.body[#self.body].x, self.body[#self.body].y
    new.ox, new.oy = 8, 8
    new.quad = self.body[#self.body].quad
    new.r = self.body[#self.body].r
    table.insert(self.body, new)
end

function Snake:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(convertColor(0x00000000))
    for _, p in pairs(self.body) do
        p.x = (p.x * 16) + p.ox
        p.y = (p.y * 16) + p.oy
        p:draw()
        p.x = (p.x - p.ox) / 16
        p.y = (p.y - p.oy) / 16
    end
    
    self.head.x = (self.head.x * 16) + self.head.ox
    self.head.y = (self.head.y * 16) + self.head.oy
    self.head:draw()
    self.head.x = (self.head.x - self.head.ox) / 16
    self.head.y = (self.head.y -self.head.oy) / 16
    love.graphics.setCanvas()

    love.graphics.draw(
        self.canvas, 
        self.x,
        self.y,
        self.r,
        self.sx,
        self.sy,
        self.ox,
        self.oy
    )
end

function Snake:collidesWithMap(map)
    if map:isSolidTile(self.head.x, self.head.y) then
        return true, "solid"
    elseif map:isGoThroughTile(self.head.x, self.head.y) then
        return true, "gothrough"
    else
        return false, nil
    end

end

function Snake:collidesWithSnake()
    for i = 1, #self.body, 1 do
        if self.body[i].x == self.head.x and self.body[i].y == self.head.y then
            return true, i
        end
    end 
    return false
end

function Snake:collidesWithApple(apple)
    return self.head.x == apple.x and self.head.y == apple.y
end

function Snake:cutSnakeAt(index)
    while #self.body >= index do
        table.remove(self.body, #self.body)
    end
end