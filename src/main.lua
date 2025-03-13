--  Variáveis Globais  --
screenWidth, screenHeight = love.window.getMode()

function love.load() 
  terraImagem = love.graphics.newImage("assets/images/terra.png")
  
  --  Atributos da Terra --
  terra = {
      imagem = terraImagem,
      posX = screenWidth / 2,
      posY = screenHeight / 2,
      tamX = 0.5,
      tamY = 0.5,
      oriX = terraImagem:getWidth() / 2 ,
      oriY = terraImagem:getHeight() / 2
  }
end

function love.update(dt)
  
end

function love.draw()
  --  Carregamento da imagem da Terra  --
  love.graphics.draw(terra.imagem, terra.posX, terra.posY, 0, terra.tamX, terra.tamY, terra.oriX, terra.oriY)
end