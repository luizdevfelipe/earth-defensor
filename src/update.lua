function love.update(dt)
  carregamento()
  
  sombraRot = sombraRot + 1 * dt
  x, y = orbita(centroJanelaX, centroJanelaY, 250, sombraRot)
  
  lua.posX = x
  lua.posY = y

end

function orbita(centroX, centroY, raio, angulo)
    local x = centroX + math.cos(angulo) * raio
    local y = centroY + math.sin(angulo) * raio
    return x, y
end


function carregamento()  
  screenWidth, screenHeight = love.window.getMode()
  centroJanelaX = screenWidth / 2
  centroJanelaY = screenHeight / 2
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
  --  Atributos da Terra --
  
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
  --  Atributos Lua  --
  
  --  Atributos Fundo  --
  fundo = {
    imagem = fundoImagem,
    posX = centroJanelaX,
    posY = centroJanelaY,
    tamX = screenWidth / fundoImagem:getWidth(),
    tamY = screenHeight / fundoImagem:getHeight(),
    oriX = fundoImagem:getWidth() / 2 ,
    oriY = fundoImagem:getHeight() / 2
  }
  --  Atributos Fundo  --
end