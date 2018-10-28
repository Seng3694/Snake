require "core/transform"
require "core/color"

Map = Transform:new()
Map.width = 0
Map.height = 0
Map.tilewidth = 0
Map.tileheight = 0

function Map:translateXYToIndex(x, y)
    return (y * self.width) + x
end

function Map:translateIndexToXY(i)
    return math.floor(i % self.width), math.floor(i / self.width)
end

function Map:load(tiledMap)
    self.canvas = love.graphics.newCanvas()
    self.canvas:setFilter("nearest", "nearest", 1)
    self.width = tiledMap.width
    self.height = tiledMap.height
    self.tilewidth = tiledMap.tilewidth
    self.tileheight = tiledMap.tileheight
    self.tilesets = {}
    local i = 1
    for _, ts in pairs(tiledMap.tilesets) do
        table.insert(
            self.tilesets, 
            Content["Tilesets"][ts.name]
        )

        self.tilesets[i].firstgid = ts.firstgid
        i = i + 1
    end

    self.tilelayers = {}
    self.objectgroups = {}

    for _, layer in pairs(tiledMap.layers) do
        if layer.type == "tilelayer" then
            table.insert(self.tilelayers, layer)
        elseif layer.type == "objectgroup" then
            table.insert(self.objectgroups, layer)
        end
    end
end

function Map:isSolidTile(x, y)
    local index = self:translateXYToIndex(x, y) + 1
    for _, layer in pairs(self.tilelayers) do
        local current = layer.data[index]
        for _, ts in pairs(self.tilesets) do 
            if ts.firstgid <= current and current <= ts.firstgid + ts.tilecount then
                for _, tile in pairs(ts.tiles) do
                    if tile.id + ts.firstgid == current then
                        return tile["type"] == "solid"
                    end
                end
            end
        end
    end
    return false
end

function Map:isGoThroughTile(x, y)
    local index = self:translateXYToIndex(x, y) + 1
    for _, layer in pairs(self.tilelayers) do
        local current = layer.data[index]
        for _, ts in pairs(self.tilesets) do 
            if ts.firstgid <= current and current <= ts.firstgid + ts.tilecount then
                for _, tile in pairs(ts.tiles) do
                    if tile.id + ts.firstgid == current then
                        return tile["type"] == "gothrough"
                    end
                end
            end
        end
    end
    return false
end

function Map:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(convertColor(0x00000000))
    for _, layer in pairs(self.tilelayers) do 
        for i = 1, #(layer.data), 1 do
            local x, y = self:translateIndexToXY(i - 1)
            local current = layer.data[i]
            for _, ts in pairs(self.tilesets) do 
                if ts.firstgid <= current and current <= ts.firstgid + ts.tilecount then
                    for _, tile in pairs(ts.tiles) do
                        if tile.id + ts.firstgid == current then
                            love.graphics.draw(
                                Content["Images"][ts.name],
                                tile.quad, 
                                x * tile.tilewidth, 
                                y * tile.tileheight
                            )
                        end
                    end
                end
            end
        end
    end
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

function Map:translateMapToWindow(x, y)
    return self.x + (x * self.tilewidth),
        self.y + (y * self.tileheight)
end

function Map:translateWindowToMap(x, y)
    local minX = self.x
    local maxX = self.x + (self.tilewidth * self.width)
    local minY = self.y
    local maxY = self.y + (self.tileheight * self.height)

    if x < minX or x > maxX then return nil, nil end
    if x < minY or x > maxY then return nil, nil end

    for yi = 0, self.height - 1, 1 do
        for xi = 0, self.width - 1, 1 do
            minX = self.x + xi * self.tilewidth 
            maxX = self.x + xi * self.tilewidth + self.tilewidth
            minY = self.y + yi * self.tileheight
            maxY = self.y + yi * self.tileheight + self.tileheight

            if x >= minX and x <= maxX and y >= minY and y <= maxY then
                return xi, yi
            end
        end
    end

    return nil, nil
end