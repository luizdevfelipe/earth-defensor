function love.update(dt)
  carregamento()
  if not pause then    
    movimentoLua(dt)
    inimigos(dt)
  end
  
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
      posicaoXAleatoria = math.random(0, screenWidth - meteoroideImg:getWidth())
      if umLadoOuOutro == 1 then
        -- Se "um lado" o meteoroide aparecerá no topo da tela até seu centro, aumentado o seu Y
        novoMeteoroide = {x = posicaoXAleatoria, y = -meteoroideImg:getHeight(), posicao = "cima"}
      else
        -- Se "do outro" o meteoroide aparecerá no inferior da tela até seu centro, diminuindo o seu Y
        novoMeteoroide = {x = posicaoXAleatoria, y = screenHeight + meteoroideImg:getHeight(), posicao = "baixo"}
      end
    else
      -- Se Y é aleatório, o meteoroide aparecerá na esquerda ou direita da tela
      posicaoYAleatoria = math.random(0, screenHeight - meteoroideImg:getHeight())
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
     movimentoMeteoroides(dt, meteoroide)
     
     -- Verificar colisão com a Lua
     if isColisao(meteoroide.x, meteoroide.y, meteoroideImg:getHeight() / 2,
       lua.posX, lua.posY, lua.raio) then
       table.remove(meteoroides, i)
     end
     
     -- Verificar colisão com a Terra
     if isColisao(meteoroide.x, meteoroide.y, meteoroideImg:getHeight() / 2, 
       terra.posX, terra.posY, terra.raio) then
       table.remove(meteoroides, i)
     end
  end
  
end


-- função que atualiza as posições da Lua no jogo
function movimentoLua(dt)  
  orbitaLua = orbitaLua + velocidadeOrbita * dt * direcaoOrbita
  lua.posX, lua.posY = orbita(centroJanelaX, centroJanelaY, 250, orbitaLua)
end

function movimentoMeteoroides(dt, meteoroide)
  dist = distanciaDeDoisPontos(centroJanelaX, meteoroide.x, centroJanelaY, meteoroide.y)
  if dist > 1 then
    local dirX = (centroJanelaX - meteoroide.x) / dist
    local dirY = (centroJanelaY - meteoroide.y) / dist
    meteoroide.x = meteoroide.x + dirX * metricasMeteoroides.vel * dt
    meteoroide.y = meteoroide.y + dirY * metricasMeteoroides.vel * dt
  end
end

function distanciaDeDoisPontos(x1, x2, y1, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- função matemática para cálculo de posicionamento orbital
function orbita(centroX, centroY, raio, angulo)
    local x = centroX + math.cos(angulo) * raio
    local y = centroY + math.sin(angulo) * raio
    return x, y
end

-- função matemática para verificar se objetos colidiram
function isColisao(x1, y1, r1, x2, y2, r2)    
  return distanciaDeDoisPontos(x1, x2, y1, y2) <= (r1 + r2)
end

-- função de detecção das teclas pressionadas 
function love.keypressed(key)
   if key == "w" and direcaoOrbita == 1 then
    direcaoOrbita = direcaoOrbita * -1
  elseif key == "w" and direcaoOrbita == -1 then
    direcaoOrbita = direcaoOrbita * -1
  end
  
  if key == "escape" then
    pause = not pause
  end
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
      raio = terraImg:getWidth() / 2,
      oriX = terraImg:getWidth() / 2 ,
      oriY = terraImg:getHeight() / 2
  }
  --  Atributos da Terra --
  
  --  Atributos Lua  --
  lua = {
    imagem = luaImg,
    posX = centroJanelaX,
    posY = centroJanelaY,
    raio = luaImg:getWidth() / 2,
    oriX = luaImg:getWidth() / 2,
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
