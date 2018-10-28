require "core/class"

Stack = Class:new()
Stack.items = {}
Stack.count = 0

function Stack:push(item)
    self.count = self.count + 1
    table.insert(self.items, item)
end

function Stack:pop()
    if self.count > 0 then
        local item = self.items[self.count]
        table.remove(self.items, self.count)
        self.count = self.count - 1
        return item
    end
end

function Stack:peek()
    if self.count > 0 then
        return self.items[self.count]
    end
end

function Stack:clear()
    self.items = {}
    self.count = 0
end