function love.conf(t)
    t.version = "11.1"
    t.console = false

    t.window.title = "Snake"
    t.window.width = 720
    t.window.height = 720
    t.window.vsync = 1

    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false
end