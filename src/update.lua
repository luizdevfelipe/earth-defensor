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
    deUmLadoOuDoOutro = math.random(0, 1)
    
    if cimaOuBaixo then
      -- Se for X aleatório o meteoroide tem o Y reduzido até chegar ao centro
      posicaoXAleatoria = math.random(meteoroideImg:getWidth(), love.graphics.getWidth() - meteoroideImg:getWidth())
      if deUmLadoOuDoOutro then
        novoMeteoroide = {x = posicaoXAleatoria, y = -meteoroideImg:getHeight()}
      else
        novoMeteoroide = {x = posicaoXAleatoria, y = screenHeight + meteoroideImg:getHeight()}
      end
    else
      -- Se for Y aleatório o meteoroide tem o X aumentado até chegar ao centro
      posicaoYAleatoria = math.random(meteoroideImg:getHeight(), love.graphics.getHeight() - meteoroideImg:getHeight())
      if deUmLadoOuDoOutro then
        novoMeteoroide = {x = -meteoroideImg:getWidth(), y = posicaoYAleatoria}
      else
        novoMeteoroide = {x = screenWidth + meteoroideImg:getWidth(), y = posicaoYAleatoria}
      end
    end    
    
    table.insert(meteoroides, novoMeteoroide)
  end
  
  --[[ 
  for m, meteoroide in ipairs(meteoroides) do
    meteoroide.y = inimigo.y + 200 * dt
    if inimigo.x > 850 then
      table.remove(inimigos, i)
    end
  end
  ]]

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
      imagem = terraImg,
      posX = centroJanelaX,
      posY = centroJanelaY,
      tamX = 0.45,
      tamY = 0.45,
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
