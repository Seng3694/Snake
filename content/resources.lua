local json = require "ext/json"

local content = {
    ["Fonts"] = {
        ["Title"] = love.graphics.newFont("content/fonts/ARCADECLASSIC.ttf", 150),
        ["SubTitle"] = love.graphics.newFont("content/fonts/ARCADECLASSIC.ttf", 28),
        ["Consolas"] = love.graphics.newFont("content/fonts/consolab.ttf", 20)
    },

    ["Sounds"] = {
        ["Background"] = love.audio.newSource("content/audio/snake_soundtrack.wav", "static")
    },

    ["Images"] = {
        ["MapTiles"] = love.graphics.newImage("content/images/map_tiles.png"),
        ["SnakeBody"] = love.graphics.newImage("content/images/snake_body.png"),
        ["SnakeHead"] = love.graphics.newImage("content/images/snake_head.png"),
        ["Apple"] = love.graphics.newImage("content/images/apple.png")
    },

    ["Tilesets"] = {
        ["MapTiles"] = json.decode(love.filesystem.read("content/tilesets/map_tiles.json")),
        ["SnakeBody"] = json.decode(love.filesystem.read("content/tilesets/snake_body.json"))
    },

    ["Animations"] = {
        ["SnakeHead"] = json.decode(love.filesystem.read("content/animations/snake_head.json"))
    },

    ["Maps"] = {}
}

for _, file in pairs(love.filesystem.getDirectoryItems("content/maps")) do 
    if file:match(".+[.]lua" ) then
        local n = file:gsub(".lua", "")
        content["Maps"][n] = require("content/maps/" .. n)
    end
end

for k, v in pairs(content["Images"]) do
    v:setFilter("nearest", "nearest", 1)
end

for k, v in pairs(content["Fonts"]) do
    v:setFilter("nearest", "nearest", 1)
end

for k, v in pairs(content["Tilesets"]) do
    local tiles = {}

    for i = 0, v.tilecount - 1, 1 do
        local x = (i * v.tilewidth) % v.imagewidth
        local y = math.floor(((i * v.tilewidth) / v.imagewidth)) * v.tileheight 
        local tile = {}
        tile.quad = love.graphics.newQuad(
            x,
            y,
            v.tilewidth,
            v.tileheight,
            v.imagewidth,
            v.imageheight
        )
        tile.id = v.tiles[i + 1].id
        if v.tiles[i + 1].objectgroup then
            tile.name = v.tiles[i + 1].objectgroup.name
        end
        tile.x = x
        tile.y = y
        tile.tilewidth = v.tilewidth
        tile.tileheight = v.tileheight
        if v.tiles[i + 1].properties ~= nil  then
            for p = 1, #(v.tiles[i + 1].properties), 1 do
                local property = v.tiles[i + 1].properties[p]
                tile[property.name] = property.value
            end
        end
        
        table.insert(tiles, tile)
    end
    
    content["Tilesets"][k].tiles = tiles
end

for k, v in pairs(content["Animations"]) do
    for i = 1, #(v.frames), 1 do
        v.frames[i].quad = love.graphics.newQuad(
            v.frames[i].frame.x,
            v.frames[i].frame.y,
            v.frames[i].frame.w,
            v.frames[i].frame.h,
            v.meta.size.w,
            v.meta.size.h
        )
    end
end

return content