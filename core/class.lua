Class = {}

function Class:new()
    local newClass = {}
    self.__index = self
    return setmetatable(newClass, self)
end