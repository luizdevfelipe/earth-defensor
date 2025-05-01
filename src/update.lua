function love.update(dt)
  carregamento(dt)
  if introducao or musicaIntroducao:isPlaying() then
    animacaoIntroducao(dt)
  else
    if not pause and not trocaDeFase and startGame ~= 0 and not gameOver then    
      -- Execução de funções que fazem o processamento do jogo --
      verificaEficienciaLunar(dt)
      movimentoLua(dt)
      inimigos(meteoroides, metricasMeteoroides, dt)    
      inimigos(superMeteoroides, metricasSupermeteoroides, dt)
      colisaoDetritos()
      regeneracaoPassiva(dt)
      verificaTrocaDeFase()
      gerenciarHabilidades(dt)
      if startGame == 2 then
        movimentoTerra(dt)
      end
      
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
    metricas.id = metricas.id + 1
    
    cimaOuBaixo = math.random(0, 1)
    umLadoOuOutro = math.random(0, 1)
    
    if cimaOuBaixo == 1 then
      -- Se X é aleatório, o meteoroide aparecerá na parte inferior ou superior da tela
      posicaoXAleatoria = math.random(0, screenWidth - metricas.img:getWidth())
      if umLadoOuOutro == 1 then
        -- Se "um lado" o meteoroide aparecerá no topo da tela até seu centro, aumentado o seu Y
        novoInimigo = {id = metricas.id, x = posicaoXAleatoria, y = -metricas.img:getHeight(), posicao = "cima"}
      else
        -- Se "do outro" o meteoroide aparecerá no inferior da tela até seu centro, diminuindo o seu Y
        novoInimigo = {id = metricas.id, x = posicaoXAleatoria, y = screenHeight + metricas.img:getHeight(), posicao = "baixo"}
      end
    else
      -- Se Y é aleatório, o meteoroide aparecerá na esquerda ou direita da tela
      posicaoYAleatoria = math.random(0, screenHeight - metricas.img:getHeight())
      if umLadoOuOutro == 1 then
        -- Se "um lado" o meteoroide aparecerá da esquerda até o centro da tela, aumentado o seu X
        novoInimigo = {id = metricas.id, x = -metricas.img:getWidth(), y = posicaoYAleatoria, posicao = "esquerda"}
      else
        -- Se "do outro" o meteoroide aparecerá da direita até o centro da tela, diminuindo o seu X
        novoInimigo = {id = metricas.id, x = screenWidth + metricas.img:getWidth(), y = posicaoYAleatoria, posicao = "direita"}
      end
    end    
    
    if metricas.tipo == "super" then
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
    if metricas.tipo == "super" then
       -- Verifica se houve a colisao
      if isColisao(inimigo.x, inimigo.y, (metricas.img:getHeight() / 2) * metricas.escala.valor,
      lua.posX, lua.posY, lua.raio) then
        if not inimigo.colisaoAnterior then
          -- faz com que seja apenas descontado vidas dele até a destruição
          inimigo.vidas = inimigo.vidas - 1
          inimigo.escala = inimigo.escala - 0.5
          -- Caso a colisão tenha sido com a habilidade o alvo é redefinido --
          if isControleGravitacional and lua.meteoroideAlvo.id == inimigo.id then
            lua.meteoroideAlvo.index = nil
            isControleGravitacional = false
          end          
          -- caso as vidas acabem ele é removido --
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
        -- Caso o meteoroide destruído tenha sido derrotado com a habilidade o alvo é redefinido --
        if isControleGravitacional and lua.meteoroideAlvo.id == inimigo.id then
          lua.meteoroideAlvo.index = nil
          isControleGravitacional = false
        end
        table.remove(inimigos, i)
        metricas.destruidos = metricas.destruidos + 1
        inimigo.colisaoAnterior = true
      else
        inimigo.colisaoAnterior = false
      end
    end
    
     -- Verificar colisão com a Terra
     if isColisao(inimigo.x, inimigo.y, (metricas.img:getHeight() / 2) * metricas.escala.valor, 
      terra.posX, terra.posY, terra.raio) then
       -- Caso o inimigo destruído pela Terra estava marcado pela habilidade ela é redefinida --
      if isControleGravitacional and lua.meteoroideAlvo.id == inimigo.id then
        print('alvo da habilidade detido pela terra')
        lua.meteoroideAlvo.index = nil
        isControleGravitacional = false
      end
      vidasTerra.valor = vidasTerra.valor - metricas.dano.valor
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
       eficienciaLunar = eficienciaLunar - taxaReducaoEficienciaLunar.valor
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
  
  print(varVantagem.valor)
  print(varDesvantagem.valor)
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
      vidasTerra.valor = vidasTerra.valor + taxaRegeneracao.valor
      if vidasTerra.valor > 3 then
        vidasTerra.valor = 3
      end
    elseif vidasTerra.valor > 1 then
      vidasTerra.valor = vidasTerra.valor + taxaRegeneracao.valor
      if vidasTerra.valor > 2 then
        vidasTerra.valor = 2
      end  
    else 
      vidasTerra.valor = vidasTerra.valor + taxaRegeneracao.valor
      if vidasTerra.valor > 1 then
        vidasTerra.valor = 1
      end
    end
    tempoRegeneracao = velocidadeRegeneracao
  end
end

-- Função que atualiza as posições da Lua no jogo
function movimentoLua(dt) 
  local velocidade = velocidadeOrbita.valor
  
  if lentidaoLunarRestante > 0 and eficienciaLunar <= 0 then
    velocidade = math.abs(velocidade - efeitoLentidao.valor)
  end
    
  -- Verifica se a habilidade está ativada e um novo alvo será escolhido --
  if isControleGravitacional and lua.meteoroideAlvo.index == nil then
    print('um novo alvo será escolhido')
    local menorDistMeteor = nil
    local menorDistSuperMeteor = nil
    
    for i, meteoroide in ipairs(meteoroides) do
      -- Calcula a distância entre o meteoroide e a Lua -- 
      distLua = distanciaDeDoisPontos(lua.posX, meteoroide.x, lua.posY, meteoroide.y)
      if menorDistMeteor == nil or distLua < menorDistMeteor then
        menorDistMeteor = distLua
        lua.meteoroideAlvo.tipo = 'normal'
        lua.meteoroideAlvo.id = meteoroide.id
        lua.meteoroideAlvo.index = i
        print('o alvo será meteoroide')
      end
    end
    
    for i, super in ipairs(superMeteoroides) do
      -- Calcula a distância entre o meteoroide e a Lua -- 
      distLua = distanciaDeDoisPontos(lua.posX, super.x, lua.posY, super.y)
      if menorDistSuperMeteor == nil or distLua < menorDistSuperMeteor then
        menorDistSuperMeteor = distLua
        
        if menorDistMeteor == nil or menorDistSuperMeteor <= menorDistMeteor then
          lua.meteoroideAlvo.tipo = 'super'
          lua.meteoroideAlvo.id = super.id
          lua.meteoroideAlvo.index = i
          print('o alvo será super')
        end
      end
    end
    
    
  -- Habilidade está ativa e um alvo foi determinado -- 
  elseif isControleGravitacional and  lua.meteoroideAlvo.index ~= nil then
    
    if lua.meteoroideAlvo.tipo == 'normal' then
      for _, normal in ipairs(meteoroides) do
        if normal.id == lua.meteoroideAlvo.id then
          alvo = normal
          break
        end
      end
    elseif lua.meteoroideAlvo.tipo == 'super' then
      for _, super in ipairs(superMeteoroides) do
        if super.id == lua.meteoroideAlvo.id then
          alvo = super
          break
        end
      end
    end
      
    if alvo ~= nil then
      distLua = distanciaDeDoisPontos(alvo.x, lua.posX, alvo.y, lua.posY)
      if distLua > 1 then
        dirX = (alvo.x - lua.posX) / distLua
        dirY = (alvo.y - lua.posY) / distLua
        lua.posX = lua.posX + dirX * velControleGravitacional.valor * dt
        lua.posY = lua.posY + dirY * velControleGravitacional.valor * dt
      end
    else
      isControleGravitacional = false
      tempoControleGravitacional = intervaloControleGravitacional.valor   
      lua.meteoroideAlvo.index = nil
    end
  else
    orbitaLua = orbitaLua + velocidade * dt * direcaoOrbita
    lua.posX, lua.posY = orbita(terra.posX, terra.posY, lua.distanciaTerra.valor, orbitaLua)
  end
end
-- Função que realiza o movimento da Terra no modo de Dois Jogadores
function movimentoTerra(dt)
  if love.keyboard.isDown("left") and (terra.posX - terra.vel.valor * dt) > lua.distanciaTerra.valor then
    terra.posX = terra.posX - terra.vel.valor * dt
  end
    
  if love.keyboard.isDown("right") and (terra.posX + terra.vel.valor * dt) < screenWidth - lua.distanciaTerra.valor then
    terra.posX = terra.posX + terra.vel.valor * dt
  end
  
  if love.keyboard.isDown("up") and (terra.posY - terra.vel.valor * dt) > lua.distanciaTerra.valor then
    terra.posY = terra.posY - terra.vel.valor * dt
  end
  
  if love.keyboard.isDown("down") and (terra.posY + terra.vel.valor *dt) < screenHeight - lua.distanciaTerra.valor then
    terra.posY = terra.posY + terra.vel.valor *dt
  end
end

function verificaEficienciaLunar(dt)
  if eficienciaLunar <= 0 then
    if lentidaoLunarRestante > 0 then
      lentidaoLunarRestante = lentidaoLunarRestante - taxaReducaoTempoLentidaoLunar.valor * dt
    else
      lentidaoLunarRestante = tempoLentidaoLunar.valor
      eficienciaLunar = resistenciaLunar.valor
    end
  end
end

function gerenciarHabilidades(dt)
  -- Verifica se Atração Gravitacional está ativa --
  if isAtracaoGravitacional then
    -- Redução o tempo de duração --
    tempoAtracaoGravitacionalAtiva = tempoAtracaoGravitacionalAtiva - 1
    if tempoAtracaoGravitacionalAtiva <= 0 then
      isAtracaoGravitacional = false
      tempoAtracaoGravitacional = intervaloAtracaoGravitacional.valor
      tempoAtracaoGravitacionalAtiva = duracaoAtracaoGravitacional.valor
    end
  else
    tempoAtracaoGravitacional = tempoAtracaoGravitacional - 1    
  end
  
  -- Verifica se Controle Gravitacional não está ativa --
  if not isControleGravitacional and tempoControleGravitacional >= 0 then
    tempoControleGravitacional = tempoControleGravitacional - 1
  end
    
end

function movimentoMeteoroides(dt, meteoroide, metrica)

  local distTerra = distanciaDeDoisPontos(terra.posX, meteoroide.x, terra.posY, meteoroide.y)
  if distTerra > 1 then
    local dirX = (terra.posX - meteoroide.x) / distTerra
    local dirY = (terra.posY - meteoroide.y) / distTerra
    meteoroide.x = meteoroide.x + dirX * metrica.vel.valor * dt
    meteoroide.y = meteoroide.y + dirY * metrica.vel.valor * dt
  end
  
  -- Verifica se a habilidade está ativada --
  if isAtracaoGravitacional then
    -- Calcula a distância entre o meteoroide e a Lua -- 
    distLua = distanciaDeDoisPontos(lua.posX, meteoroide.x, lua.posY, meteoroide.y)
    -- Se estiver no raio da habilidade ele será atraído --
    if distLua > 1 and distLua < 500 then
      local dirX = (lua.posX - meteoroide.x) / distLua
      local dirY = (lua.posY - meteoroide.y) / distLua
      
      meteoroide.x = meteoroide.x + dirX * velAtracaoGravitacional.valor * dt
      meteoroide.y = meteoroide.y + dirY * velAtracaoGravitacional.valor * dt
    end
  end
  
end

function distanciaDeDoisPontos(x1, x2, y1, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function getAngulo(x1, y1, x2, y2)
  local a = math.deg( math.atan2(y2 - y1, x2 - x1) )
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
  
  if key == "e" and not isAtracaoGravitacional and tempoAtracaoGravitacional <= 0 then
    isAtracaoGravitacional = true
  end
  
  if key == "q" and not isControleGravitacional and tempoControleGravitacional <= 0 then
    isControleGravitacional = true
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
  
  -- Apresentação do movimento da Lua no menu --
  if startGame == 0 then
    terra.posX = centroJanelaX
    terra.posY = centroJanelaY
    
     orbitaLua = orbitaLua + 0.5 * dt * 1
     lua.posX, lua.posY = orbita(terra.posX, terra.posY, lua.distanciaTerra.valor, orbitaLua)
  end
  -- Apresentação do movimento da Lua no menu --  
end
