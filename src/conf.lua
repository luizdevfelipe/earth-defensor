function love.conf(t)  
  t.identity = nil
  t.version = "0.10.1"
  t.console = false
  t.accelerometerjoystick = true
  t.externalstorage = false
  t.gammacorrect = true
  
  t.window.title = "Meu Jogo"
  t.window.icon = nil
  t.window.width = 1280
  t.window.height = 768
  t.window.borderless = false
  t.window.resizable = true
  t.window.minwidth = 800
  t.window.minheight = 600
  t.window.fullscreen = false
  t.window.fullscreentype = "desktop"
  t.window.vsync = true
  t.window.msaa = 0
  t.window.display = 1
  t.window.highdpi = false
  t.window.x = nil
  t.window.y = nil 
  
  t.modules.audio = true
  t.modules.event = true
  t.modules.graphics = true
  t.modules.image = true
  t.modules.joystick = true
  t.modules.math = true
  t.modules.mouse = true
  t.modules.physics = true
  t.modules.sound = true
  t.modules.system = true
  t.modules.timer = true
  t.modules.touch = true
  t.modules.video = true
  t.modules.window = true
  t.modules.threads = true
end