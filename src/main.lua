--  Variáveis Globais  --
screenWidth, screenHeight = love.window.getMode()
centroJanelaX = screenWidth / 2
centroJanelaY = screenHeight / 2

function love.load() 
  terraImagem = love.graphics.newImage("assets/images/terra.png")
  luaImagem = love.graphics.newImage("assets/images/lua.png")
  sombra = love.graphics.newImage("assets/images/sombra.png")
  
  --  Atributos da Terra --
  terra = {
      imagem = terraImagem,
      posX = centroJanelaX,
      posY = centroJanelaY,
      tamX = 0.5,
      tamY = 0.5,
      oriX = terraImagem:getWidth() / 2 ,
      oriY = terraImagem:getHeight() / 2
  }
  
  --  Atributos Lua  --
  lua = {
    imagem = luaImagem,
    posX = centroJanelaX + 300,
    posY = centroJanelaY + 100,
    tamX = 0.2,
    tamY = 0.2,
    oriX = luaImagem:getWidth() / 2 ,
    oriY = luaImagem:getHeight() / 2
  }
  sombraRot = 0
end

function love.update(dt)
  sombraRot = sombraRot + 1 * dt
  x, y = orbita(centroJanelaX, centroJanelaY, 250, sombraRot)
  
  lua.posX = x
  lua.posY = y

end

function love.draw()
  love.graphics.setBackgroundColor(255,255,255)
  
  --  Carregamento da imagem da Terra  --
  love.graphics.draw(terra.imagem, terra.posX, terra.posY, 0, terra.tamX, terra.tamY, terra.oriX, terra.oriY)
  
  --  Carregamento da imagem da Lua  --
  love.graphics.draw(lua.imagem, lua.posX, lua.posY, 0, lua.tamX, lua.tamY, lua.oriX, lua.oriY)
  --  Carregamento da imagem da Sombra da Lua  --
  love.graphics.draw(sombra, lua.posX, lua.posY, sombraRot, lua.tamX, lua.tamY, lua.oriX, lua.oriY)
  
end

function orbita(centroX, centroY, raio, angulo)
    local x = centroX + math.cos(angulo) * raio
    local y = centroY + math.sin(angulo) * raio
    return x, y
end