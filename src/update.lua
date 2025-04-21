function love.update(dt)
  carregamento(dt)
  if introducao or musicaIntroducao:isPlaying() then
    animacaoIntroducao(dt)
  else
    if not pause and not trocaDeFase and startGame == 1 and not gameOver then    
      -- Execução de funções que fazem o processamento do jogo --
      movimentoLua(dt)
      inimigos(meteoroides, metricasMeteoroides, dt)    
      inimigos(superMeteoroides, metricasSupermeteoroides, dt)
      colisaoDetritos()
      regeneracaoPassiva(dt)
      verificaTrocaDeFase()
      
      
      -- Apresenta o texto informativo --
      if transparenciaTextoInfo < 255 then
        transparenciaTextoInfo = transparenciaTextoInfo + 40 * dt
      end
    end
  
    if not love.mouse.isDown(1) then
      botaoUmSolto = true
    end
  end
end

function animacaoIntroducao(dt)
  if not musicaIntroducao:isPlaying() then
    musicaIntroducao:play()
    introducao = false
  end
  
  if movimentoTerraAnim < 30 then
    movimentoTerraAnim = movimentoTerraAnim + 22 * dt
  end
  
  if transparenciaTerraAnim < 255 then
    transparenciaTerraAnim = transparenciaTerraAnim + 55 * dt
    if transparenciaTerraAnim > 255 then
      transparenciaTerraAnim = 255
    end
  end
  
  intervaloMeteoroAnim = intervaloMeteoroAnim - 10 * dt
  if transparenciaMeteoroAnim < 255 and intervaloMeteoroAnim <= 0 then
    transparenciaMeteoroAnim = transparenciaMeteoroAnim + 55 * dt
    if transparenciaMeteoroAnim > 255 then
      transparenciaMeteoroAnim = 255
    end
  end
    
  intervaloLuaAnim = intervaloLuaAnim - 5 * dt
  if transparenciaLuaAnim < 255 and intervaloLuaAnim <= 0 then
    transparenciaLuaAnim = transparenciaLuaAnim + 60 * dt
    movimentoLuaAnim = movimentoLuaAnim + 22 * dt
    if movimentoLuaAnim > 75 then
      movimentoLuaAnim = 75 
    end
    if transparenciaLuaAnim > 255 then
      transparenciaLuaAnim = 255
    end
  end
  
  intervaloCreditosAnim = intervaloCreditosAnim - 2 * dt
  if transparenciaCreditosAnim < 255 and intervaloCreditosAnim <= 0 then
    transparenciaCreditosAnim = transparenciaCreditosAnim + 55 * dt
    if transparenciaCreditosAnim > 255 then
      transparenciaCreditosAnim = 255
    end
  end
  
end

function inimigos(inimigos, metricas, dt)
  -- Intervalo de criação de inimigos --
  metricas.contagem = metricas.contagem - 1 * dt
  -- Irá criar um novo inimigo dentro do jogo --
  if metricas.contagem < 0 and round(metricas.qtd.valor) > 0 then
    metricas.contagem = metricas.delay
    metricas.qtd.valor = round(metricas.qtd.valor) - 1
    
    cimaOuBaixo = math.random(0, 1)
    umLadoOuOutro = math.random(0, 1)
    
    if cimaOuBaixo == 1 then
      -- Se X é aleatório, o meteoroide aparecerá na parte inferior ou superior da tela
      posicaoXAleatoria = math.random(0, screenWidth - metricas.img:getWidth())
      if umLadoOuOutro == 1 then
        -- Se "um lado" o meteoroide aparecerá no topo da tela até seu centro, aumentado o seu Y
        novoInimigo = {x = posicaoXAleatoria, y = -metricas.img:getHeight(), posicao = "cima"}
      else
        -- Se "do outro" o meteoroide aparecerá no inferior da tela até seu centro, diminuindo o seu Y
        novoInimigo = {x = posicaoXAleatoria, y = screenHeight + metricas.img:getHeight(), posicao = "baixo"}
      end
    else
      -- Se Y é aleatório, o meteoroide aparecerá na esquerda ou direita da tela
      posicaoYAleatoria = math.random(0, screenHeight - metricas.img:getHeight())
      if umLadoOuOutro == 1 then
        -- Se "um lado" o meteoroide aparecerá da esquerda até o centro da tela, aumentado o seu X
        novoInimigo = {x = -metricas.img:getWidth(), y = posicaoYAleatoria, posicao = "esquerda"}
      else
        -- Se "do outro" o meteoroide aparecerá da direita até o centro da tela, diminuindo o seu X
        novoInimigo = {x = screenWidth + metricas.img:getWidth(), y = posicaoYAleatoria, posicao = "direita"}
      end
    end    
    
    if metricas.id == "super" then
      novoInimigo.vidas = metricas.colisoes
      novoInimigo.escala = metricas.escala.valor
    end
    
    novoInimigo.colisaoAnterior = false
    
    table.insert(inimigos, novoInimigo)
  end
    
  -- Irá verificar se houve colisões dos inimigos e entre a Lua e Terra --
  for i, inimigo in ipairs(inimigos) do
    -- Movimenta os inimigos antes de verificar a colisão --
     movimentoMeteoroides(dt, inimigo, metricas)
     
     -- Verificar colisão com a Lua
     -- No caso de supermeteoroide
     if metricas.id == "super" then
       -- Verifica se houve a colisao
      if isColisao(inimigo.x, inimigo.y, (metricas.img:getHeight() / 2) * metricasSupermeteoroides.escala.valor,
      lua.posX, lua.posY, lua.raio) then
        if not inimigo.colisaoAnterior then
          -- faz com que seja apenas descontado vidas dele até a destruição
          inimigo.vidas = inimigo.vidas - 1
          inimigo.escala = inimigo.escala - 0.5
          if inimigo.vidas <= 0 then
            table.remove(inimigos, i)
            metricas.destruidos = metricas.destruidos + 1
          end
          inimigo.colisaoAnterior = true
        end
      else
        inimigo.colisaoAnterior = false
      end
    else 
      -- No caso de meteoroide
      if isColisao(inimigo.x, inimigo.y, metricas.img:getHeight() / 2,
      lua.posX, lua.posY, lua.raio) then
        -- "transformar" meteoroide em detrito
        criarDetrito(inimigo.x, inimigo.y)
        table.remove(inimigos, i)
        metricas.destruidos = metricas.destruidos + 1
        inimigo.colisaoAnterior = true
      else
        inimigo.colisaoAnterior = false
      end
    end
    
     -- Verificar colisão com a Terra
     if isColisao(inimigo.x, inimigo.y, metricas.img:getHeight() / 2, 
       terra.posX, terra.posY, terra.raio) then
       vidasTerra.valor = vidasTerra.valor - metricas.dano
       metricas.destruidos = metricas.destruidos + 1
       table.remove(inimigos, i)
     end
  end
    
end

-- Função para o criação dos Detritos
function criarDetrito(x, y)
  for i = 1, metricasDetrito.qtd, 1 do
    novoDetrito = {x = x + math.random(-40 - i^2, 40 + i^2), y = y + math.random(-40 - i^2, 40 + i^2)}
    table.insert(detritos, novoDetrito)
  end
end

-- Função para detecção de colisão e destruição dos detritos
function colisaoDetritos()
  for i, detrito in ipairs(detritos) do
     -- Verificar colisão com a Lua
     if isColisao(detrito.x, detrito.y, detritoImg:getHeight() / 2,
       lua.posX, lua.posY, lua.raio) then
       metricasDetrito.destruidos = metricasDetrito.destruidos + 1
       table.remove(detritos, i)
     end
     
     -- Verificar colisão com a Terra
     if isColisao(detrito.x, detrito.y, detritoImg:getHeight() / 2, 
       terra.posX, terra.posY, terra.raio) then
       metricasDetrito.destruidos = metricasDetrito.destruidos + 1
       table.remove(detritos, i)
     end
    
    for j, meteoroide in ipairs(meteoroides) do
      if isColisao(detrito.x, detrito.y, detritoImg:getHeight() / 2,
       meteoroide.x, meteoroide.y, meteoroideImg:getHeight() / 2) then
       metricasDetrito.destruidos = metricasDetrito.destruidos + 1
       table.remove(detritos, i)
     end
    end    
  end
end

function verificaTrocaDeFase()
  if (round(metricasSupermeteoroides.qtd.valor) == 0 and next(superMeteoroides) == nil) and (round(metricasMeteoroides.qtd.valor) == 0 and next(meteoroides) == nil) then
    trocaDeFase = true
    
    for i = 1, #potencializadores do 
      pesos[i] = potencializadores[i].peso
    end
    
    potencializadoresSorteados = sortearUnicosComPeso(3, pesos)
  end
end

function potencializadorEscolhido(escolha)
  trocaDeFase = false
  onda = onda + 1
  resetaRodada()
  
  varVantagem = potencializadores[escolha].alvoVantagem
  varDesvantagem = potencializadores[escolha].alvoDesvantagem
  varVantagem.valor = varVantagem.valor + varVantagem.valor * (potencializadores[escolha].vantagem / 100)
  varDesvantagem.valor = varDesvantagem.valor + varDesvantagem.valor * (potencializadores[escolha].desvantagem / 100)
end

-- Função para regeneração passiva da vida da Terra
function regeneracaoPassiva(dt)
  -- Verifica se o jogador perdeu
  if vidasTerra.valor <= 0 then
    vidasTerra.valor = 0
    gameOver = true
  end
  -- Lógica de regeneração da vida da Terra
  tempoRegeneracao = tempoRegeneracao - dt
  if tempoRegeneracao <= 0 then
    if vidasTerra.valor <= 3 and vidasTerra.valor > 2 then
      vidasTerra.valor = vidasTerra.valor + taxaRegeneracao
      if vidasTerra.valor > 3 then
        vidasTerra.valor = 3
      end
    elseif vidasTerra.valor > 1 then
      vidasTerra.valor = vidasTerra.valor + taxaRegeneracao
      if vidasTerra.valor > 2 then
        vidasTerra.valor = 2
      end  
    else 
      vidasTerra.valor = vidasTerra.valor + taxaRegeneracao
      if vidasTerra.valor > 1 then
        vidasTerra.valor = 1
      end
    end
    tempoRegeneracao = velocidadeRegeneracao
  end
end

-- Função que atualiza as posições da Lua no jogo
function movimentoLua(dt)  
  orbitaLua = orbitaLua + velocidadeOrbita.valor * dt * direcaoOrbita
  lua.posX, lua.posY = orbita(centroJanelaX, centroJanelaY, 250, orbitaLua)
end

function movimentoMeteoroides(dt, meteoroide, metrica)
  dist = distanciaDeDoisPontos(centroJanelaX, meteoroide.x, centroJanelaY, meteoroide.y)
  if dist > 1 then
    local dirX = (centroJanelaX - meteoroide.x) / dist
    local dirY = (centroJanelaY - meteoroide.y) / dist
    meteoroide.x = meteoroide.x + dirX * metrica.vel.valor * dt
    meteoroide.y = meteoroide.y + dirY * metrica.vel.valor * dt
  end
end

function distanciaDeDoisPontos(x1, x2, y1, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function getAngulo(x1, y1, x2, y2)
  local a = math.floor( math.deg( math.atan2(x2 - x1, y2 - y1) ) )
  if a < 0 then 
    a = a + 360 
  end
  return a
end

function round(n)
  return math.floor(n + 0.5)
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
  
  if key == "escape" and startGame ~= 0 and not gameOver then
    pause = not pause
  end
end

-- Função para retornar N valores aleatórios com probabilidades diferentes
function sortearUnicosComPeso(qtd, pesos)
  -- Cria pool ponderada
  local pool = {}
  for valor, peso in pairs(pesos) do
    for i = 1, peso do
      table.insert(pool, valor)
    end
  end

  local resultado = {}
  local sorteados = {}

  while #resultado < qtd and #pool > 0 do
    -- Sorteia da pool
    local index = math.random(#pool)
    local valor = pool[index]

    -- Adiciona se ainda não foi sorteado
    if not sorteados[valor] then
      table.insert(resultado, valor)
      sorteados[valor] = true
    end

    -- Remove todas as ocorrências desse valor da pool
    for i = #pool, 1, -1 do
      if pool[i] == valor then
        table.remove(pool, i)
      end
    end
  end

  return resultado
end

-- Variáveis que devem ser atualizadas durante a execução
function carregamento(dt)  
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
  if startGame == 0 then
     orbitaLua = orbitaLua + 0.5 * dt * 1
  end
  lua.posX, lua.posY = orbita(centroJanelaX, centroJanelaY, 250, orbitaLua)
end
