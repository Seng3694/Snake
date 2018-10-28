function getVectorLength(x, y)
    return math.sqrt((math.pow(x, 2) + math.pow(y, 2)))
end 

function normalizeVector(x, y)
    local length = getVectorLength(x, y)
    if lenght > 0 then
        return 
            x / length,
            y / length
    end
    return x, y
end

function getVectorAngleRad(x, y)
    return math.atan2(x, y)
end 

function getVectorAngleDeg(x, y)
    return getVectorAngleRad(x, y) * 180 / math.pi
end

function radToDeg(rad)
    return rad * 180 / math.pi
end

function degToRad(deg)
    return deg * math.pi / 180
end

function lshift(number, shift)
    return number * 2 ^ shift
end

function  rshift(number, shift)
    return math.floor(number / 2 ^ shift)
end

function band(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
      if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
          result = result + bitval      -- set the current bit
      end
      bitval = bitval * 2 -- shift left
      a = math.floor(a/2) -- shift right
      b = math.floor(b/2)
    end
    return result
end

function lerp(startX, startY, endX, endY, value)
    return 
        startX + value * (endX - startX),
        startY + value * (endY - startY)
end

function lerp2(startX, startY, anchorX, anchorY, endX, endY, value)
    local x1, y1 = lerp(startX, startY, anchorX, anchorY, value)
    local x2, y2 = lerp(anchorX, anchorY, endX, endY, value)
    return lerp(x1, y1, x2, y2, value)
end

function clamp(value, low, high)
    if value < low then return low
    elseif value > high then return high
    else return value end
end

function overflowclamp(value, low, high)
    if value < low then return high 
    elseif value > high then return low
    else return value end
end