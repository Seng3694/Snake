require "core/class"

Queue = Class:new()
Queue.items = {}
Queue.count = 0

function Queue:enqueue(item)
    self.count = self.count + 1
    table.insert(self.items, item)
end

function Queue:dequeue()
    if self.count > 0 then
        local item = self.items[1]
        table.remove(self.items, 1)
        self.count = self.count - 1
        return item
    end
end

function Queue:peek()
    if self.count > 0 then
        return self.items[1]
    end
end

function Queue:clear()
    self.items = {}
    self.count = 0
end