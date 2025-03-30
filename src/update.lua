function love.update(dt)
  carregamento()
  movimentoLua(dt)
  
end

-- função que atualiza as posições da Lua no jogo
function movimentoLua(dt)  
  sombraRot = sombraRot + velocidadeOrbita * dt * direcaoOrbita
  orbitaLua = orbitaLua + velocidadeOrbita * dt * direcaoOrbita
  lua.posX, lua.posY = orbita(centroJanelaX, centroJanelaY, 250, orbitaLua)
end

--[[ 
 função de detecção das teclas pressionadas
 diferente de love.keyboard essa callback só é executada uma vez
 após uma tecla é pressionada 
]]
function love.keypressed(key)
   if key == "d" and direcaoOrbita == 1 then
    direcaoOrbita = direcaoOrbita * -1
  elseif key == "a" and direcaoOrbita == -1 then
    direcaoOrbita = direcaoOrbita * -1
  end
end

-- função matemática para cálculo de posicionamento orbital
function orbita(centroX, centroY, raio, angulo)
    local x = centroX + math.cos(angulo) * raio
    local y = centroY + math.sin(angulo) * raio
    return x, y
end

-- Variáveis que devem ser atualizadas durante a execução
function carregamento()  
  screenWidth, screenHeight = love.window.getMode()
  centroJanelaX = screenWidth / 2
  centroJanelaY = screenHeight / 2
  --  Atributos da Terra --
  terra = {
      imagem = terraImagem,
      posX = centroJanelaX,
      posY = centroJanelaY,
      tamX = 0.45,
      tamY = 0.45,
      oriX = terraImagem:getWidth() / 2 ,
      oriY = terraImagem:getHeight() / 2
  }
  --  Atributos da Terra --
  
  --  Atributos Lua  --
  lua = {
    imagem = luaImagem,
    posX = centroJanelaX,
    posY = centroJanelaY,
    tamX = 0.16,
    tamY = 0.16,
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
