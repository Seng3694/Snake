require "core/sprite"

--play modes:
--forward, backward
--
--repeat modes:
--pong, circle

AnimatedSprite = Sprite:new()
AnimatedSprite.frame = 1
AnimatedSprite.elapsed = 0.0
AnimatedSprite.frames = nil
AnimatedSprite.playmode = "forward"
AnimatedSprite.repeating = true
AnimatedSprite.repeatmode = "circle"
AnimatedSprite.playing = false
AnimatedSprite.default = nil
AnimatedSprite.animations = {}

function AnimatedSprite:load(key, animation)
    if self.default == nil then self.default = key end
    self.animations[key] = animation
end

function AnimatedSprite:play(key, playmode, repeating, repeatmode, stopother)
    if stopother == nil then stopother = true end

    if stopother or self.playing == false then
        self.frames = self.animations[key].frames
        self.elapsed = 0.0
        self.frame = 1
        self.playmode = playmode or "forward"
        self.repeating = repeating and true or false
        self.repeatmode = repeatmode or "cirlce"
        self.playing = true
    end
end

function AnimatedSprite:update(dt)
    if self.playing then
        self.elapsed = self.elapsed + (dt * 1000)
        if self.elapsed >= self.frames[self.frame].duration then 
            self.elapsed = 0
            if self.playmode == "forward" then
                self.frame = self.frame + 1
                if self.frame > #(self.frames) then
                    if self.repeatmode == "circle" then
                        self.frame = 1
                    elseif self.repeatmode == "pong" then
                        self.frame = self.frame - 1
                        self.playmode = "backward"
                    end  
                    if self.repeating == false then
                        self.playing = false
                        self.frame = 1
                    end
                end
            elseif self.playmode == "backward" then
                self.frame = self.frame - 1
                if self.frame == 0 then
                    if self.repeatmode == "circle" then
                        self.frame = #(self.frames)
                    elseif self.repeatmode == "pong" then
                        self.frame = self.frame + 1
                        self.playmode = "forward"
                    end  
                    if self.repeating == false then 
                        self.playing = false
                    end
                end
            end
        end
    end
end

function AnimatedSprite:draw()
    if self.img == nil then return end

    if self.frames == nil then
        self.frames = self.animations[self.default].frames
        self.frame = 1
    end

    if self.frames[self.frame].quad == nil then  
        love.graphics.draw(
            self.img, 
            self.x,
            self.y,
            self.r,
            self.sx,
            self.sy,
            self.ox,
            self.oy
        )
    else
        love.graphics.draw(
            self.img, 
            self.frames[self.frame].quad,
            self.x,
            self.y,
            self.r,
            self.sx,
            self.sy,
            self.ox,
            self.oy
        )
    end
end