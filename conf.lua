
function love.conf(t)
    t.version = "11.2" 
    t.author="AdrianN"
    t.window.width = 920
    t.window.height = 640
    t.title="Eclipso"
    t.identity = "Eclipso"
    --t.release = true
    t.window.fullscreen = false 
    t.window.fullscreentype = "desktop"
    t.window.vsync = 1 
    t.modules.audio = false              -- Enable the audio module (boolean)
    t.modules.data = true               -- Enable the data module (boolean)
    t.modules.event = true              -- Enable the event module (boolean)
    t.modules.font = false               -- Enable the font module (boolean)
    t.modules.graphics = false           -- Enable the graphics module (boolean)
    t.modules.image = false              -- Enable the image module (boolean)
    t.modules.joystick = false          -- Enable the joystick module (boolean)
    t.modules.keyboard = false           -- Enable the keyboard module (boolean)
    t.modules.math = true               -- Enable the math module (boolean)
    t.modules.physics = true            -- Enable the physics module (boolean)
    t.modules.sound = false              -- Enable the sound module (boolean)
    t.modules.system = true             -- Enable the system module (boolean)
    t.modules.thread = false            -- Enable the thread module (boolean)
    t.modules.timer = true              -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
    t.modules.video = false             -- Enable the video module (boolean)
    t.modules.window = false             -- Enable the window module (boolean)
    t.modules.touch = false             -- Enable the touch module (boolean)
    t.modules.mouse = false              -- Enable the mouse module (boolean)

end