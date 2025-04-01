function love.update(dt)
  carregamento()
  movimentoLua(dt)
  inimigos(dt)
  
end

function inimigos(dt)
  metricasMeteoroides.contagem = metricasMeteoroides.contagem - 1 * dt
  if metricasMeteoroides.contagem < 0 and metricasMeteoroides.qtd > 0 then
    metricasMeteoroides.contagem = metricasMeteoroides.delay
    --metricasMeteoroides.qtd = metricasMeteoroides.qtd - 1
    
    cimaOuBaixo = math.random(0, 1)
    umLadoOuOutro = math.random(0, 1)
    
    if cimaOuBaixo == 1 then
      -- Se X é aleatório, o meteoroide aparecerá na parte inferior ou superior da tela
      posicaoXAleatoria = math.random(meteoroideImg:getWidth(), screenWidth - meteoroideImg:getWidth())
      if umLadoOuOutro == 1 then
        -- Se "um lado" o meteoroide aparecerá no topo da tela até seu centro, aumentado o seu Y
        novoMeteoroide = {x = posicaoXAleatoria, y = -meteoroideImg:getHeight(), posicao = "cima"}
      else
        -- Se "do outro" o meteoroide aparecerá no inferior da tela até seu centro, diminuindo o seu Y
        novoMeteoroide = {x = posicaoXAleatoria, y = screenHeight + meteoroideImg:getHeight(), posicao = "baixo"}
      end
    else
      -- Se Y é aleatório, o meteoroide aparecerá na esquerda ou direita da tela
      posicaoYAleatoria = math.random(meteoroideImg:getHeight(), screenHeight - meteoroideImg:getHeight())
      if umLadoOuOutro == 1 then
        -- Se "um lado" o meteoroide aparecerá da esquerda até o centro da tela, aumentado o seu X
        novoMeteoroide = {x = -meteoroideImg:getWidth(), y = posicaoYAleatoria, posicao = "esquerda"}
      else
        -- Se "do outro" o meteoroide aparecerá da direita até o centro da tela, diminuindo o seu X
        novoMeteoroide = {x = screenWidth + meteoroideImg:getWidth(), y = posicaoYAleatoria, posicao = "direita"}
      end
    end    
    
    table.insert(meteoroides, novoMeteoroide)
  end
  
  
  for i, meteoroide in ipairs(meteoroides) do
    if meteoroide.posicao == "cima" then
      meteoroide.y = meteoroide.y + metricasMeteoroides.vel * dt
      -- Caso o meteoroide não colida em nada
      if meteoroide.y > screenHeight then
        table.remove(meteoroides, i)
      end
    elseif meteoroide.posicao == "baixo" then
      meteoroide.y = meteoroide.y - metricasMeteoroides.vel * dt
      -- Caso o meteoroide não colida em nada
      if meteoroide.y < 0 then
        table.remove(meteoroides, i)
      end
    elseif meteoroide.posicao == "esquerda" then
      meteoroide.x = meteoroide.x + metricasMeteoroides.vel * dt
      -- Caso o meteoroide não colida em nada
      if meteoroide.x > screenWidth then
        table.remove(meteoroides, i)
      end
    elseif meteoroide.posicao == "direita" then
      meteoroide.x = meteoroide.x - metricasMeteoroides.vel * dt
      -- Caso o meteoroide não colida em nada
      if meteoroide.x < 0 then
        table.remove(meteoroides, i)
      end
    end
  end
  

end

-- função que atualiza as posições da Lua no jogo
function movimentoLua(dt)  
  orbitaLua = orbitaLua + velocidadeOrbita * dt * direcaoOrbita
  lua.posX, lua.posY = orbita(centroJanelaX, centroJanelaY, 250, orbitaLua)
end

-- função de detecção das teclas pressionadas 
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

function isColisao(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- Variáveis que devem ser atualizadas durante a execução
function carregamento()  
  screenWidth, screenHeight = love.window.getMode()
  centroJanelaX = screenWidth / 2
  centroJanelaY = screenHeight / 2
  --  Atributos da Terra --
  terra = {
      imagem = terraImg,
      posX = centroJanelaX,
      posY = centroJanelaY,
      oriX = terraImg:getWidth() / 2 ,
      oriY = terraImg:getHeight() / 2
  }
  --  Atributos da Terra --
  
  --  Atributos Lua  --
  lua = {
    imagem = luaImg,
    posX = centroJanelaX,
    posY = centroJanelaY,
    tamX = 0.16,
    tamY = 0.16,
    oriX = luaImg:getWidth() / 2 ,
    oriY = luaImg:getHeight() / 2
  }
  --  Atributos Lua  --
  
  --  Atributos Fundo  --
  fundo = {
    imagem = fundoImg,
    posX = centroJanelaX,
    posY = centroJanelaY,
    tamX = screenWidth / fundoImg:getWidth(),
    tamY = screenHeight / fundoImg:getHeight(),
    oriX = fundoImg:getWidth() / 2 ,
    oriY = fundoImg:getHeight() / 2
  }
  --  Atributos Fundo  --
end
