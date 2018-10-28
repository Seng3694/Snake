require "core/math"

function convertColor(rgba)
    return
        rshift(band(rgba, 0xff000000), 24) / 0xff,
        rshift(band(rgba, 0x00ff0000), 16) / 0xff,
        rshift(band(rgba, 0x0000ff00), 8) / 0xff,
        rshift(band(rgba, 0x000000ff), 0) / 0xff
end