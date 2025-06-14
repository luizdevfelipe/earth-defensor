function love.draw()
  if musicaIntroducao:isPlaying() then
    desenharIntroducao()
  else 
    --  Carregamento da imagem da Galáxia  --    
    love.graphics.setColor(255, (vidasTerra.valor * 255) / 3, (vidasTerra.valor * 255) / 3)
    love.graphics.draw(fundo.imagem, fundo.posX, fundo.posY, 0, fundo.tamX, fundo.tamY, fundo.oriX, fundo.oriY)
    
    -- Carregamento das estrelas no céu --
    efeitoEstrelas()
    
    --  Carregamento da imagem da Terra  --
    love.graphics.draw(terra.imagem, terra.posX - terra.oriX, terra.posY - terra.oriY, 0, escalaTerraImg, escalaTerraImg)
     if skinTerra > 0 then
       if type(valoresCoresSkins.terra[skinTerra]) == "table" then
        love.graphics.setColor(valoresCoresSkins.terra[skinTerra][1], valoresCoresSkins.terra[skinTerra][2], valoresCoresSkins.terra[skinTerra][3])
        love.graphics.draw(terra.imagem, terra.posX - terra.oriX, terra.posY - terra.oriY, 0, escalaTerraImg, escalaTerraImg)
       else
        love.graphics.draw(valoresCoresSkins.terra[skinTerra], terra.posX - terra.oriX, terra.posY - terra.oriY, 0, escalaTerraImg, escalaTerraImg)
       end
    end
    if terraDestruidaSprite >= 1 then
      love.graphics.draw(terraDestruidaAnim[terraDestruidaSprite], terra.posX - terra.oriX, terra.posY - terra.oriY, 0, escalaTerraImg, escalaTerraImg)
    end
    
    --  Carregamento da imagem da Lua  --
    if skinLua > 0 then
      love.graphics.setColor(valoresCoresSkins.lua[skinLua][1], valoresCoresSkins.lua[skinLua][2], valoresCoresSkins.lua[skinLua][3])
    end
    if rachaduraSprite >= 1 then
      love.graphics.draw(rachaduraAnim[rachaduraSprite], lua.posX - lua.oriX, lua.posY - lua.oriY, 0, escalaLuaImg, escalaLuaImg)
    else
      love.graphics.draw(lua.imagem, lua.posX - lua.oriX, lua.posY - lua.oriY, 0, escalaLuaImg, escalaLuaImg)
    end
    love.graphics.setColor(255, 255, 255)
    -- Carregamento da Sombra da Lua --
    desenhoSombraLua(lua.posX, lua.posY, lua.oriX, lua.oriY, getAngulo(terra.posX, terra.posY, lua.posX, lua.posY))
    
     -- Carregamento dos detritos --
    for i, detrito in ipairs(detritos) do
      rotacaoInimigo(detrito)
      love.graphics.draw(detritoImg, detrito.x, detrito.y,  math.rad(detrito.rotacao), 1, 1, detritoImg:getWidth() / 2, detritoImg:getHeight() / 2)
    end
    
    -- Carregamento das imagens de meteoroides --
    for id, meteoroide in pairs(meteoroides) do
      rotacaoInimigo(meteoroide)
      love.graphics.draw(meteoroide.img, meteoroide.x, meteoroide.y, math.rad(meteoroide.rotacao), 1, 1, meteoroidesImgs.meteoroideImg:getWidth() / 2, meteoroidesImgs.meteoroideImg:getHeight() / 2)
    end
    
    -- Carregamento das imagens de SuperMeteoroides --
    for id, super in pairs(superMeteoroides) do
      rotacaoInimigo(super, 0.3)
      love.graphics.draw(metricasSupermeteoroides.img, super.x, super.y, math.rad(super.rotacao), super.escala, super.escala, metricasSupermeteoroides.img:getWidth() / 2, metricasSupermeteoroides.img:getHeight() / 2)
    end
       
    -- Carregamento das animações de colisões --
    for i, animacao in ipairs(animacoesColisoes) do
      animacao.delay = animacao.delay - 1 
      -- math.pi compensa a imagem ser voltada para a esquerda e não para direita como é o padrão do Love para 0 rad
      love.graphics.draw(colisaoAnimAtlas, colisaoMeteoroideFrames[animacao.frame], animacao.x, animacao.y, animacao.angulo)
      
      if animacao.delay <= 0 then
        animacao.frame = animacao.frame + 1
        animacao.delay = 10
        
        if animacao.frame > 3 then
          table.remove(animacoesColisoes, i)
        end
        
      end
    end
       
    if transparenciaTextoInfo > 0 and startGame ~= 0 then
      love.graphics.setFont(fontNormal)
      love.graphics.setColor(transparenciaTextoInfo, transparenciaTextoInfo, transparenciaTextoInfo, transparenciaTextoInfo)
      local instrucaoWidth = love.graphics.getFont():getWidth("Pressione W para alterar o movimento lunar:")
      love.graphics.print("Pressione W para alterar o movimento lunar:", centroJanelaX - instrucaoWidth / 2, screenHeight * 0.8)
      love.graphics.draw(wIco, (centroJanelaX - instrucaoWidth / 2) + instrucaoWidth + wIco:getWidth()/2 + 5, screenHeight * 0.8 + wIco:getWidth()/2, 0, 1, 1, wIco:getWidth()/2, wIco:getHeight()/2)
      if startGame == 2 then
        local instrucaoWidth = love.graphics.getFont():getWidth("Pressione as setas para controlar o movimento da Terra:")
        love.graphics.print("Pressione as setas para controlar o movimento da Terra:", centroJanelaX - instrucaoWidth / 2, screenHeight * 0.85)
        love.graphics.draw(setinhasIco, (centroJanelaX - instrucaoWidth / 2) + instrucaoWidth + setinhasIco:getWidth()/2, screenHeight * 0.85 + 10, 0, 1, 1, setinhasIco:getWidth()/2, setinhasIco:getHeight()/2)
      end
    end
    
    -- Exibe conteúdos que devem aparecer apenas durante o jogo --
    if not gameOver and not trocaDeFase and startGame ~= 0 then
      -- Carregamento da Barra de Vida
      barraDeVida() 
      
      -- Carregamento do botão de Atração Gravitacional --
      exibeBotaoAtracaoGravitacional()
    
      -- Carregamento do botão de Controle Gravitacional --
      exibeBotaoControleGravitacional()
      
      -- Exibe a Onda atual do jogador --
      love.graphics.setFont(fontNormal)
      love.graphics.print("Onda: " .. onda, centroJanelaX - love.graphics.getFont():getWidth("Onda: " .. onda) / 2, screenHeight - 45)
    end
    
    if trocaDeFase and not gameOver and not pause and not optionsScreen then
      telaDePotencializadores()
    end
    
    if gameOver then
      telaGameOver()
    end
    
    -- Tela inicial
    if startGame == 0 and not optionsScreen and not skinScreen then
      telaInicial() 
    end
    
    -- Tela de opções --
    if optionsScreen then
      telaDeOpcoes()
    end
    
    -- Tela de Skins --
    if skinScreen then
      telaDeSkins()
    end  
        
    --Tela de Pause
     if pause and not optionsScreen then    
      telaDePause()
    end
    
    -- função para rederizar um cursor personalizado --
    mostraCursor()
  end
end

function efeitoEstrelas()
  for i, estrela in ipairs(estrelasBrilhantes) do
    if estrela.estado == 'acendendo' then
      estrela.brilhoAtual = estrela.brilhoAtual + 1
      if estrela.brilhoAtual >= estrela.brilhoMax then
        estrela.estado = 'apagando'
      end
    elseif estrela.estado == 'apagando' then
      estrela.brilhoAtual = estrela.brilhoAtual - 1
      if estrela.brilhoAtual <= 0 then
        estrela.estado = 'acendendo'
      end
    end
    
    estrela.rotacao = estrela.rotacao + 0.01
    if estrela.rotacao >= 360 then estrela.rotacao = 0 end
    
    love.graphics.setColor(255, (vidasTerra.valor * 255) / 3, (vidasTerra.valor * 255) / 3, estrela.brilhoAtual)
    love.graphics.draw(brilhoEstrela, estrela.x, estrela.y, estrela.rotacao, 0.1, 0.1, brilhoEstrela:getWidth()/2, brilhoEstrela:getHeight()/2)
    
  end
  
  if estrelaCadente.direcao == 'left' then
    deslocamento = 1
  elseif estrelaCadente.direcao == 'right' then
    deslocamento = -1
  end
  
  love.graphics.setColor(255, 255, 255, estrelaCadente.brilhoMax)
  
  love.graphics.setLineWidth(7)
  love.graphics.line(estrelaCadente.x, estrelaCadente.y, estrelaCadente.x + 4*deslocamento, estrelaCadente.y)

  love.graphics.setLineWidth(6)
  love.graphics.line(estrelaCadente.x + 4*deslocamento, estrelaCadente.y, estrelaCadente.x + 8*deslocamento, estrelaCadente.y)

  love.graphics.setLineWidth(5)
  love.graphics.line(estrelaCadente.x + 8*deslocamento, estrelaCadente.y, estrelaCadente.x + 12*deslocamento, estrelaCadente.y)

  love.graphics.setLineWidth(4)
  love.graphics.line(estrelaCadente.x + 12*deslocamento, estrelaCadente.y, estrelaCadente.x + 16*deslocamento, estrelaCadente.y)

  love.graphics.setLineWidth(3)
  love.graphics.line(estrelaCadente.x + 16*deslocamento, estrelaCadente.y, estrelaCadente.x + 24*deslocamento, estrelaCadente.y)

  love.graphics.setLineWidth(2)
  love.graphics.line(estrelaCadente.x + 24*deslocamento, estrelaCadente.y, estrelaCadente.x + 32*deslocamento, estrelaCadente.y)

    
  estrelaCadente.x = estrelaCadente.x + 5*deslocamento*-1
  estrelaCadente.brilhoMax = estrelaCadente.brilhoMax  - 1
  
  if estrelaCadente.brilhoMax <= 0 then
    estrelaCadente = {x = math.random(200, screenWidth - 200), y = math.random(50, screenHeight - 50), brilhoMax = math.random(100, 245)}
    if estrelaCadente.x > screenWidth / 2 then
      estrelaCadente.direcao = 'left'
    else
      estrelaCadente.direcao = 'right'
    end
  end
  
  love.graphics.setColor(255, 255, 255, 255)
end

function telaDePotencializadores()
  local larguraRetangulo = 300
  local alturaRetangulo = 400
  local larguraBorda = 8
  local centralizadoX = centroJanelaX - larguraRetangulo / 2
  local centralizadoY = centroJanelaY - alturaRetangulo / 2
  local espacoRetang = 30
  local interior1QuadradoX = centralizadoX - larguraRetangulo - espacoRetang + larguraBorda / 2
  local interior3QuadradoX = centralizadoX + larguraRetangulo + espacoRetang + larguraBorda / 2
  local textoSelecionarY = centroJanelaY + alturaRetangulo / 2 - love.graphics.getFont():getHeight("Selecionar") - 10
  local marginTopTexto = - 60
  local cycleImgY = screenHeight - cycleIco:getHeight() + 30
    
  desfoqueFundo(240)
  -- Exibe o texto "Escolha seu novo poder"
  love.graphics.setFont(fonteNegrito)
  local escolhaPoderWidth = love.graphics.getFont():getWidth("Escolha seu novo poder:")
  local escolhaPoderHeight = love.graphics.getFont():getHeight("Escolha seu novo poder:") - 10
  love.graphics.print("Escolha seu novo poder:", centroJanelaX - escolhaPoderWidth / 2, 60)
    
  -- Exibe o 1º quadrado com a habilidade --
  corRaridadePotencializador(1)
  love.graphics.setLineWidth(larguraBorda)
  love.graphics.rectangle("line", centralizadoX - larguraRetangulo - espacoRetang, centralizadoY, larguraRetangulo, alturaRetangulo)
  love.graphics.setColor(0, 0, 0, 220)
  love.graphics.rectangle("fill", interior1QuadradoX, centralizadoY + larguraBorda / 2, larguraRetangulo - larguraBorda , alturaRetangulo - larguraBorda)
  -- Exibe o título da 1º habilidade --
  love.graphics.setFont(fonteMenu35)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print(
    potencializadores[potencializadoresSorteados[1]].titulo, 
    interior1QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth(potencializadores[potencializadoresSorteados[1]].titulo)) / 2, 
    centralizadoY + 10
  )
  
  -- Exibe a raridade do potencializador --
  corRaridadePotencializador(1)
  love.graphics.setFont(fonteNegrito)
  love.graphics.print(
    textoRaridadePotencializador(1), 
    interior1QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth(textoRaridadePotencializador(1)) / 2) / 2, 
    centralizadoY + love.graphics.getFont():getHeight(textoRaridadePotencializador(1)) / 2,
    0, 0.5, 0.5
  )
  
  -- Exibe o 1º texto da habilidade --
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fontNormal20)
  love.graphics.printf( 
    retornaTextoPotencializador(1),
    interior1QuadradoX, 
    centroJanelaY - love.graphics.getFont():getHeight(retornaTextoPotencializador(1)) + marginTopTexto,
    larguraRetangulo - larguraBorda,
    "justify"
  )
  -- Exibe o 1º botão de "Selecionar" --
  love.graphics.setFont(fonteMenu50)
  love.graphics.print(
    "Selecionar", 
    interior1QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY
  )
  local hover1 = underlineTextHover(
    interior1QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
  )
  if hover1 then botaoSelectPotencializador = 1 end
  keyboardSelectedText(
    interior1QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8, 
    love.graphics.getFont():getWidth("Selecionar"),
    botaoSelectPotencializador == 1
  )
  
  -- Exibe o 2º quadrado com a habilidade --
  corRaridadePotencializador(2)
  love.graphics.rectangle("line", centralizadoX, centralizadoY, larguraRetangulo, alturaRetangulo)
  love.graphics.setColor(0, 0, 0, 220)
  love.graphics.rectangle("fill", centralizadoX + larguraBorda / 2, centralizadoY + larguraBorda / 2, larguraRetangulo - larguraBorda , alturaRetangulo - larguraBorda)
  -- Exibe o título da 2º habilidade --
  love.graphics.setFont(fonteMenu35)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print(
    potencializadores[potencializadoresSorteados[2]].titulo, 
    centralizadoX + larguraBorda / 2 + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth(potencializadores[potencializadoresSorteados[2]].titulo)) / 2, 
    centralizadoY + 10
  )
  -- Exibe o 2º texto da habilidade --
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fontNormal20)
  love.graphics.printf( 
    retornaTextoPotencializador(2),
    centralizadoX + larguraBorda / 2,
    centroJanelaY - love.graphics.getFont():getHeight(retornaTextoPotencializador(1)) + marginTopTexto,
    larguraRetangulo - larguraBorda,
    "justify"
  )
  
  -- Exibe a raridade do 2º potencializador --
  corRaridadePotencializador(2)
  love.graphics.setFont(fonteNegrito)
  love.graphics.print(
    textoRaridadePotencializador(2), 
    centralizadoX + larguraBorda / 2 + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth(textoRaridadePotencializador(2)) / 2) / 2,
    centralizadoY + love.graphics.getFont():getHeight(textoRaridadePotencializador(2)) / 2,
    0, 0.5, 0.5
  )
  
  -- Exibe o 2º botão de "Selecionar" --
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fonteMenu50)
  love.graphics.printf(
    "Selecionar", 
    centralizadoX + larguraBorda / 2, 
    textoSelecionarY, 
    larguraRetangulo - larguraBorda, 
    "center"
  )
  local hover2 = underlineTextHover(
    centralizadoX + larguraBorda / 2 + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
  )
  if hover2 then botaoSelectPotencializador = 2 end
  keyboardSelectedText(
    centralizadoX + larguraBorda / 2 + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8, 
    love.graphics.getFont():getWidth("Selecionar"),
    botaoSelectPotencializador == 2
  )
 
 -- Exibe o 3º quadrado com a habilidade --
 corRaridadePotencializador(3)
  love.graphics.rectangle("line", centralizadoX + larguraRetangulo + espacoRetang , centralizadoY, larguraRetangulo, alturaRetangulo)
  love.graphics.setColor(0, 0, 0, 220)
  love.graphics.rectangle("fill", centralizadoX + larguraRetangulo + espacoRetang + larguraBorda / 2, centralizadoY + larguraBorda / 2, larguraRetangulo - larguraBorda , alturaRetangulo - larguraBorda)
  -- Exibe o título da 3º habilidade --
  love.graphics.setFont(fonteMenu35)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print(
    potencializadores[potencializadoresSorteados[3]].titulo, 
    interior3QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth(potencializadores[potencializadoresSorteados[3]].titulo)) / 2, 
    centralizadoY + 10
  )
  
  -- Exibe a raridade do 3º potencializador --
  corRaridadePotencializador(3)
  love.graphics.setFont(fonteNegrito)
  love.graphics.print(
    textoRaridadePotencializador(3), 
    interior3QuadradoX + (larguraRetangulo - larguraBorda - larguraBorda - love.graphics.getFont():getWidth(textoRaridadePotencializador(3)) / 2) / 2, 
    centralizadoY + love.graphics.getFont():getHeight(textoRaridadePotencializador(3)) / 2,
    0, 0.5, 0.5
  )
  
  -- Exibe o 3º texto da habilidade --
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fontNormal20)
  love.graphics.printf( 
    retornaTextoPotencializador(3),
    interior3QuadradoX, 
    centroJanelaY - love.graphics.getFont():getHeight(retornaTextoPotencializador(1)) + marginTopTexto,
    larguraRetangulo - larguraBorda,
    "justify"
  )
  -- Exibe o 3º botão de "Selecionar" --
  love.graphics.setFont(fonteMenu50)
  love.graphics.printf(
    "Selecionar", 
    interior3QuadradoX, 
    textoSelecionarY, 
    larguraRetangulo - larguraBorda, 
    "center"
  )
  local hover3 = underlineTextHover(
    interior3QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
  )
  if hover3 then botaoSelectPotencializador = 3 end
  keyboardSelectedText(
    interior3QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8, 
    love.graphics.getFont():getWidth("Selecionar"),
    botaoSelectPotencializador == 3
  )
 
  -- Exibe o botão de troca de Habilidades --
  if canCycle then
    if isMouseHover(centroJanelaX - cycleIco:getWidth()/2, cycleImgY - cycleIco:getHeight()/2, cycleIco:getWidth(), cycleIco:getHeight()) then 
      cycleRot = 90 
    else
      cycleRot = 0
    end
    love.graphics.draw(cycleIco, centroJanelaX, cycleImgY, math.rad(cycleRot), 1, 1, cycleIco:getWidth()/2, cycleIco:getHeight()/2)
  end
  
 
  -- Verifica se selecionou a 1º habilidade -- 
  if isCliqueEmTexto(
    interior1QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
    ) and botaoUmSolto then
    botaoUmSolto = false
    potencializadorEscolhido(potencializadoresSorteados[1])
  end 
  
  -- Verifica se selecionou a 2º habilidade --   
  if isCliqueEmTexto(
    centralizadoX + larguraBorda / 2 + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
    ) and botaoUmSolto then
    botaoUmSolto = false
    potencializadorEscolhido(potencializadoresSorteados[2])
  end 
  
  -- Verifica se selecionou a 3º habilidade --   
  if isCliqueEmTexto(
    interior3QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
    ) and botaoUmSolto then
    botaoUmSolto = false
    potencializadorEscolhido(potencializadoresSorteados[3])
  end 
  
  -- Verifica se selecionou a "Novas habilidades" --   
  if isCliqueEmTexto(
    centroJanelaX - cycleIco:getWidth()/2, 
    cycleImgY - cycleIco:getHeight()/2,
    cycleIco:getWidth(), 
    cycleIco:getHeight()
    ) and botaoUmSolto and canCycle then
    botaoUmSolto = false
    potencializadoresSorteados = sortearUnicosComPeso(3, pesos)
    canCycle = false
  end 
  
  love.graphics.setColor(255, 255, 255, 255)
end

function telaGameOver()
  desfoqueFundo(240)
  -- Exibe o texto "Derrota"
  love.graphics.setFont(fonteNegrito)
  local derrotaWidth = love.graphics.getFont():getWidth("Derrota!")
  local derrotaHeight = love.graphics.getFont():getHeight("Derrota!") - 10
  local derrotaX = centroJanelaX - derrotaWidth / 2
  local derrotaY = centroJanelaY * 0.2
  love.graphics.print("Derrota!", derrotaX, derrotaY)
  -- Exibe o texto de "Onda Alcançada"
  local ondaWidth = love.graphics.getFont():getWidth("Onda Alcançada: " .. onda)
  local ondaHeight = love.graphics.getFont():getHeight("Onda Alcançada: " .. onda) - 10
  local ondaX = centroJanelaX - ondaWidth / 2
  local ondaY = centroJanelaY * 0.6
  love.graphics.print("Onda Alcançada: " .. onda, ondaX, ondaY)
  
  -- Exibe o texto "Recorde" --
  love.graphics.setFont(fontNormal)
  local valores = leituraPontuacao()
  if startGame == 1 then
    record = valores[1]
  elseif startGame == 2 then
    record = valores[2]
  end
  local recordWidth = love.graphics.getFont():getWidth("Máxima alcançada: " .. record)
  local recordHeight = love.graphics.getFont():getHeight("Máxima alcançada: " .. record) - 10
  local recordX = centroJanelaX - recordWidth / 2
  local recordY = (centroJanelaY * 0.6) + 100
  love.graphics.print("Máxima alcançada: " .. record, recordX, recordY)
  
  -- Estatísticas da partida --
  love.graphics.setFont(fontNormal)
  local destruidosWidth = love.graphics.getFont():getWidth("Foram destruídos:")
  love.graphics.print("Foram destruídos:", centroJanelaX - destruidosWidth / 2, centroJanelaY)
  -- Meteoroides --
  love.graphics.print(metricasMeteoroides.destruidos .. " Meteoroides", centroJanelaX , centroJanelaY + 50)
  -- Supermeteoroides --
  love.graphics.print(metricasSupermeteoroides.destruidos .. " Supermeteoroides", centroJanelaX , centroJanelaY + 100)
  -- Detritos --
  love.graphics.print(metricasDetrito.destruidos .. " Detritos", centroJanelaX , centroJanelaY + 150)
  -- Exibe o texto de "Voltar ao Menu Principal"
  local menuWidth = love.graphics.getFont():getWidth("Voltar ao Menu Principal")
  local menuHeight = love.graphics.getFont():getHeight("Voltar ao Menu Principal") - 10
  local menuX = centroJanelaX - menuWidth / 2
  local menuY = screenHeight * 0.9
  love.graphics.print("Voltar ao Menu Principal", menuX, menuY)
  underlineTextHover(menuX, menuY, menuWidth, menuHeight+5)
  
  -- verifica se clicou sobre "Voltar ao Menu Principal"
  if isCliqueEmTexto(menuX, menuY, menuWidth, menuHeight) and botaoUmSolto then
    botaoUmSolto = false
    resetaJogo()
  end  
end

function desenharIntroducao()
  love.graphics.setBackgroundColor(0,0,0)
  --  Carregamento da imagem da Terra  --
  love.graphics.setColor(transparenciaTerraAnim,transparenciaTerraAnim,transparenciaTerraAnim,transparenciaTerraAnim)
  love.graphics.draw(terra.imagem, centroJanelaX - terra.oriX - 100, centroJanelaY - terra.oriY + 30 - movimentoTerraAnim, 0, escalaTerraImg, escalaTerraImg)
  --  Carregamento da imagem da Lua  --
  love.graphics.setColor(transparenciaLuaAnim, transparenciaLuaAnim, transparenciaLuaAnim, transparenciaLuaAnim)
  love.graphics.draw(protetoraImg, centroJanelaX - 100 + terra.raio, centroJanelaY - 60 - movimentoLuaAnim, 0, 1, 1, protetoraImg:getWidth() / 2, protetoraImg:getHeight() / 2)
  -- Carregamento da imagem do Meteoroide --
  love.graphics.setColor(transparenciaMeteoroAnim,transparenciaMeteoroAnim,transparenciaMeteoroAnim,transparenciaMeteoroAnim)
  love.graphics.draw(meteoroImg, centroJanelaX + 230, centroJanelaY * 0.5, 0, 1, 1, meteoroImg:getWidth() / 2, meteoroImg:getHeight() / 2)
  
  -- Texto dos Créditos --
  love.graphics.setColor(transparenciaCreditosAnim,transparenciaCreditosAnim,transparenciaCreditosAnim,transparenciaCreditosAnim)
  love.graphics.setFont(fonteMenu)
  local tituloWidth = love.graphics.getFont():getWidth("Earth Defensor")
  local tituloX = centroJanelaX - tituloWidth / 2
  local tituloY = screenHeight * 0.7
  love.graphics.print("Earth Defensor", tituloX, tituloY)
  
  love.graphics.setFont(fontNormal)
  local autorWidth = love.graphics.getFont():getWidth("luizdevfelipe")
  local autorX = centroJanelaX - autorWidth / 2
  local autorY = screenHeight * 0.85
  love.graphics.print("luizdevfelipe", autorX, autorY)
  
  -- Botão de pular cutscene --
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(enterIco, screenWidth - enterIco:getWidth() - 30, screenHeight - enterIco:getHeight() - 50)
  
  if tempoPularAnim < 150 then
    local largura = 150 - tempoPularAnim
    love.graphics.rectangle('fill', screenWidth - enterIco:getWidth() - 30, screenHeight - 25, enterIco:getWidth() * (largura/149), 3)
  end
  
end

function barraDeVida()
  -- Fundo da barra de Vida
  love.graphics.setColor(255,255,255)
  local vidaBarX = centroJanelaX - 55 - moldura_vida:getWidth() / 2
  local vidaBarY =  60 + 15 - moldura_vida:getHeight()*0.5 / 2
  love.graphics.draw(terra_vida_bar, vidaBarX + 50, vidaBarY, 0, 0.6, 0.6)
  love.graphics.draw(moldura_vida, vidaBarX, vidaBarY, 0, 1, 0.5)
  love.graphics.rectangle("fill", centroJanelaX - 203, 60, 406, 29)
  -- Barra de Vida em si
  love.graphics.setColor(34, 177, 76)
  if vidasTerra.valor > 3 then vidasTerra.valor = 3 end
  if vidasTerra.valor < 0 then vidasTerra.valor = 0 end
  love.graphics.rectangle("fill", centroJanelaX - 200, 63, (vidasTerra.valor * 400) / 3, 23)
  -- Recortes nas vidas principais
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", centroJanelaX - 200 / 3, 60, 4, 29)
  love.graphics.rectangle("fill", centroJanelaX + 200 / 3, 60, 4, 29)
  love.graphics.setColor(255,255,255)
end

function telaInicial()
  desfoqueFundo(180)
  -- Exibe o texto Earth Defensor --
  love.graphics.setFont(fonteNegrito)
  local earthDefensorWidth = love.graphics.getFont():getWidth("Earth Defensor")
  local earthDefensorHeight = love.graphics.getFont():getHeight("Earth Defensor") - 10
  local earthDefensorX = centroJanelaX - earthDefensorWidth / 2
  local earthDefensorY = centroJanelaY * 0.2
  love.graphics.print("Earth Defensor", earthDefensorX, earthDefensorY)
  
  -- Exibe o texto "Um Jogador"
  love.graphics.setFont(fonteMenu)
  local umJogadorWidth = love.graphics.getFont():getWidth("Um Jogador")
  local umJogadorHeight = love.graphics.getFont():getHeight("Um Jogador") - 10
  local umJogadorX = centroJanelaX - umJogadorWidth / 2
  local umJogadorY = centroJanelaY * 0.6
  love.graphics.print("Um Jogador", umJogadorX, umJogadorY)
  local hover1P = underlineTextHover(umJogadorX, umJogadorY, umJogadorWidth, umJogadorHeight)
  if hover1P then botaoSelectModo = true end
  keyboardSelectedText(umJogadorX, umJogadorY, umJogadorWidth, botaoSelectModo)
  
  -- Exibe o texto de "Dois Jogadores"
  local doisJogadoresWidth = love.graphics.getFont():getWidth("Dois Jogadores")
  local doisJogadoresHeight = love.graphics.getFont():getHeight("Dois Jogadores") - 10
  local doisJogadoresX = centroJanelaX - doisJogadoresWidth / 2
  local doisJogadoresY = centroJanelaY 
  love.graphics.print("Dois Jogadores", doisJogadoresX, doisJogadoresY)
  local hover2P = underlineTextHover(doisJogadoresX, doisJogadoresY, doisJogadoresWidth, doisJogadoresHeight)
  if hover2P then botaoSelectModo = false end
  keyboardSelectedText(doisJogadoresX, doisJogadoresY, doisJogadoresWidth, not botaoSelectModo)
  
  -- Botão de créditos que reapresenta a animação inicial --
  love.graphics.setFont(fontNormal)
  local creditosWidth = love.graphics.getFont():getWidth("Créditos")
  local creditosHeight = love.graphics.getFont():getHeight("Créditos") - 10
  local creditosX = 30
  local creditosY = screenHeight - creditosHeight - 30 
  love.graphics.print("Créditos", creditosX, creditosY)
  underlineTextHover(creditosX, creditosY, creditosWidth, creditosHeight + 5)
  
  -- Botão de sair do jogo --
  love.graphics.setFont(fonteMenu)
  local sairWidth = love.graphics.getFont():getWidth("Sair") / 2
  local sairHeight = love.graphics.getFont():getHeight("Sair") / 2 - 10
  local sairX = centroJanelaX - sairWidth / 2
  local sairY = screenHeight - sairHeight - 30 
  love.graphics.print("Sair", sairX,  sairY, 0, 0.5, 0.5)
  underlineTextHover(sairX, sairY, sairWidth, sairHeight + 5)
  
  -- Exibe e verifica se clicou sobre o botão --
  botaoDeOpcoes()
  
  -- Exibe e verifica se cicou sobre o botão --
  botaoDeSkins()
  
  -- verifica se clicou sobre "Um Jogador"
  if isCliqueEmTexto(umJogadorX, umJogadorY, umJogadorWidth, umJogadorHeight) and botaoUmSolto then
    botaoUmSolto = false
    startGame = 1
  end
  
  -- verifica se clicou sobre "Dois Jogadores"
  if isCliqueEmTexto(doisJogadoresX, doisJogadoresY, doisJogadoresWidth, doisJogadoresHeight) and botaoUmSolto then
    botaoUmSolto = false
    startGame = 2
  end  
  
  -- verifica se clicou sobre "Créditos"
  if isCliqueEmTexto(creditosX, creditosY, creditosWidth, creditosHeight) and botaoUmSolto then
    botaoUmSolto = false
    introducao = true
    resetaTemposAnimacaoIntro()
  end
  
  -- verifica se clicou sobre "Sair"
  if isCliqueEmTexto(sairX, sairY, sairWidth, sairHeight) and botaoUmSolto then
    botaoUmSolto = false
    love.event.quit()
  end
  
end

function botaoDeOpcoes()
  -- Exibe o botão de opções --
  local larguraOptionsIco = optionsIco:getWidth()
  local alturaOptionsIco = optionsIco:getHeight()
  local optionsIcoX = screenWidth - larguraOptionsIco -30
  local optionsIcoY = screenHeight - alturaOptionsIco -30
  love.graphics.draw(optionsIco, optionsIcoX, optionsIcoY, 0, 1, 1)
  
  -- verifica se clicou sobre o "Botão de opções" -- 
  if isCliqueEmTexto(optionsIcoX, optionsIcoY, larguraOptionsIco, alturaOptionsIco) and botaoUmSolto then
    botaoUmSolto = false
    optionsScreen = true
  end  
end

function botaoDeSkins()
  -- Exibe o botão de opções --
  local larguraSkinIco = skinIco:getWidth()
  local alturaSkinIco = skinIco:getHeight()
  local skinIcoX = screenWidth - larguraSkinIco - 180
  local skinIcoY = screenHeight - alturaSkinIco -30
  love.graphics.draw(skinIco, skinIcoX, skinIcoY, 0, 1, 1)
  
  -- verifica se clicou sobre o "Botão de opções" -- 
  if isCliqueEmTexto(skinIcoX, skinIcoY, larguraSkinIco, alturaSkinIco) and botaoUmSolto then
    botaoUmSolto = false
    skinScreen = true
  end  
end

function telaDeOpcoes()
  desfoqueFundo(180)
  love.graphics.setFont(fonteNegrito)
  -- Exibe o texto da resolução da tela --
  local resolucaoWidth = love.graphics.getFont():getWidth("Resolução: " .. screenWidth .. 'x' .. screenHeight)
  local resolucaoHeight = love.graphics.getFont():getHeight("Resolução: " .. screenWidth .. 'x' .. screenHeight) - 10
  local resolucaoX = centroJanelaX - resolucaoWidth / 2
  local resolucaoY = centroJanelaY * 0.1
  love.graphics.print("Resolução: " .. screenWidth .. 'x' .. screenHeight, resolucaoX, resolucaoY)
  
  -- Exibe o texto "Tela Cheia" --
  local telaCheiaWidth = love.graphics.getFont():getWidth("Tela Cheia: ")
  local telaCheiaHeight = love.graphics.getFont():getHeight("Tela Cheia: ") - 10
  local telaCheiaX = centroJanelaX - telaCheiaWidth / 2
  local telaCheiaY = centroJanelaY * 0.3
  love.graphics.print("Tela Cheia: ", telaCheiaX, telaCheiaY)
  -- Exibe ícone de status da "Tela Cheia"
  if love.window.getFullscreen() then
    love.graphics.draw(enableIco, telaCheiaX + telaCheiaWidth, telaCheiaY + 12)
  else
    love.graphics.draw(disabledIco, telaCheiaX + telaCheiaWidth, telaCheiaY + 12)
  end
 
 -- Exibe o texto de Volume -- 
  local volumeWidth = love.graphics.getFont():getWidth("Volume: ")
  local volumeHeight = love.graphics.getFont():getHeight("Volume: ") - 10
  local volumeX = centroJanelaX - volumeWidth / 2
  local volumeY = centroJanelaY * 0.5
  love.graphics.print("Volume: ", volumeX, volumeY)
  
  -- Exibe a barra de ajuste de volume --
  love.graphics.setColor(255, 255, 255)
  local barraVolX = volumeX + volumeWidth + 10
  local barraVolY = volumeY + volumeHeight / 2 + 6
  love.graphics.rectangle('fill', barraVolX, barraVolY, 200, 12)  
  love.graphics.rectangle('fill', barraVolX - 20 + (200 * volumeGeral), barraVolY - 15, 40, 40)
  
  if isCliqueEmTexto(barraVolX - 20 + (200 * volumeGeral), barraVolY - 15, 40, 40) or 
     isCliqueEmTexto(barraVolX, barraVolY, 200, 12) then
    mouseX = love.mouse.getX()
    local novoVolume = (mouseX - barraVolX) / 200
    volumeGeral = math.max(0, math.min(1, novoVolume))
    
    alterarVolume()
  end

  -- Exibe o texto de música habilitada --
  local musicaWidth = love.graphics.getFont():getWidth("Musica: ")
  local musicaHeight = love.graphics.getFont():getHeight("Musica: ") - 10
  local musicaX = centroJanelaX - musicaWidth / 2
  local musicaY = centroJanelaY * 0.7
  love.graphics.print("Musica: ", musicaX, musicaY)
  
  -- Exibe o ícone de status da "Música"
  if isGameMusic then
    love.graphics.draw(enableIco, musicaX + musicaWidth, musicaY + 12)
  else
    love.graphics.draw(disabledIco, musicaX + musicaWidth, musicaY + 12)
  end
  
  -- Exibe o botão de retorno --
  local larguraReturnIco = returnIco:getWidth()
  local alturaReturnIco = returnIco:getHeight()
  local returnIcoX = screenWidth - larguraReturnIco -30
  local returnIcoY = screenHeight - alturaReturnIco -30
  love.graphics.draw(returnIco, returnIcoX, returnIcoY, 0, 1, 1)
  
  -- verifica se clicou sobre o "Botão de Tela Cheia" -- 
  if isCliqueEmTexto(telaCheiaX + telaCheiaWidth, telaCheiaY + 12, enableIco:getWidth(), enableIco:getHeight()) and botaoUmSolto then
    botaoUmSolto = false
    toggleFullscreen()
  end 
  
  -- verifica se clicou sobre o "Botão de Musica" -- 
  if isCliqueEmTexto(musicaX + musicaWidth, musicaY + 12, enableIco:getWidth(), enableIco:getHeight()) and botaoUmSolto then
    botaoUmSolto = false
    isGameMusic = not isGameMusic
  end 
  
  -- verifica se clicou sobre o "Botão de retorno" -- 
  if isCliqueEmTexto(returnIcoX, returnIcoY, larguraReturnIco, alturaReturnIco) and botaoUmSolto then
    botaoUmSolto = false
    optionsScreen = false
  end  
  
end

-- Exibe a tela de escolha de skins para personagens
function telaDeSkins()
  desfoqueFundo(180)
  
  valores = leituraPontuacao()
  local maiorOnda = valores[1]
  
  local escalaMoldura = 0.3
  local largura = moldura_skins:getWidth()*escalaMoldura - 10
  local altura = moldura_skins:getHeight()*escalaMoldura - 10
  
  local retanguloPosY = 250
  local retangulo2PosY = 500
  local retanguloPadraoPosY = screenHeight - altura - 100
  
  if screenHeight < 1080 then
    largura = moldura_skins:getWidth()*escalaMoldura - 35
    altura = moldura_skins:getHeight()*escalaMoldura - 30
    retanguloPosY = 140
    retangulo2PosY = 355
    retanguloPadraoPosY = 570
    escalaMoldura = 0.27
  end
  
  local retanguloPosX = centroJanelaX - largura*2 
  
  local retangulo2PosX =  centroJanelaX - largura/2
  local skinLua2PosX = retangulo2PosX + 4 + largura/2 - lua.imagem:getHeight()*escalaLuaImg/2
  
  local retangulo3PosX = centroJanelaX + largura
  local skinLua3PosX = retangulo3PosX + 4 + largura/2 - lua.imagem:getHeight()*escalaLuaImg/2
 
  local skinSegundaLinhaY = retangulo2PosY + lua.imagem:getHeight()*escalaLuaImg/2 + 40
  
  local retanguloLuaPadraoPosX = (centroJanelaX - largura*2) + largura/2
  
  local skinLuaPadraoPosX = retanguloLuaPadraoPosX + 4 + largura/2 - lua.imagem:getHeight()*escalaLuaImg/2
  local skinPadraoPosY = retanguloPadraoPosY + lua.imagem:getHeight()*escalaLuaImg/2 + 40
  
  local retanguloTerraPadraoPosX = (centroJanelaX + largura) - largura/2
  local skinTerraPadraoPosX = retanguloTerraPadraoPosX + 4 + largura/2 - lua.imagem:getHeight()*escalaLuaImg/2
  
  local skinLuaPosX = retanguloPosX + 4 + largura/2 - lua.imagem:getHeight()*escalaLuaImg/2
  local skinLuaPosY = retanguloPosY + lua.imagem:getHeight()*escalaLuaImg/2 + 40
  
  function isSkinSelecionadaTexto(skinSelecionada, posicaoSkin, ondaMinima, posX, posY)
    love.graphics.setFont(fontNormal20)
    love.graphics.setColor(255,255,255,255)
    if skinSelecionada == posicaoSkin then
      love.graphics.setColor(34, 177, 76)
      love.graphics.printf( 
        'Selecionado',
        posX + 7,
        posY + altura - 50,
        largura - 10,
        "center"
      )
    elseif maiorOnda >= ondaMinima then
      love.graphics.printf( 
        'Selecionar',
        posX + 7,
        posY + altura - 50,
        largura - 10,
        "center"
      )
    else 
      love.graphics.printf( 
      'Recorde: '..ondaMinima,
      posX + 7,
      posY + altura - 50,
      largura - 10,
      "center"
      )
    end
  end
  
  love.graphics.setFont(fonteNegrito)
  -- Exibe o texto "Skins" --
  local skinsWidth = love.graphics.getFont():getWidth("Skins")
  local skinsHeight = love.graphics.getFont():getHeight("Skins") - 10
  local skinsX = centroJanelaX - skinsWidth / 2
  local skinsY = centroJanelaY * 0.1
  love.graphics.print("Skins", skinsX, skinsY)
  
  -- Texto LUA SANGUE --
  isSkinSelecionadaTexto(skinLua, 1, 15, retanguloPosX, retanguloPosY)
  love.graphics.draw(moldura_skins, retanguloPosX, retanguloPosY, 0, escalaMoldura, escalaMoldura)
  love.graphics.printf( 
    'Lua de Sangue',
    retanguloPosX + 10,
    retanguloPosY + 60,
    largura - 10,
    "center"
  )
  
  love.graphics.setColor(valoresCoresSkins.lua[1][1], valoresCoresSkins.lua[1][2], valoresCoresSkins.lua[1][3])
  love.graphics.draw(lua.imagem, skinLuaPosX, skinLuaPosY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.setColor(255, 255, 255)
  
  -- Texto LUA AZUL -- 
  isSkinSelecionadaTexto(skinLua, 2, 25, retangulo2PosX, retanguloPosY)
  love.graphics.draw(moldura_skins, retangulo2PosX, retanguloPosY, 0, escalaMoldura, escalaMoldura)
  love.graphics.printf( 
    'Lua Azul',
    retangulo2PosX + 10,
    retanguloPosY + 60,
    largura - 10,
    "center"
  )
  
  love.graphics.setColor(valoresCoresSkins.lua[2][1], valoresCoresSkins.lua[2][2], valoresCoresSkins.lua[2][3])
  love.graphics.draw(lua.imagem, skinLua2PosX, skinLuaPosY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.setColor(255, 255, 255)
  
  -- Texto LUA DOURADA -- 
  isSkinSelecionadaTexto(skinLua, 3, 35, retangulo3PosX, retanguloPosY)
  love.graphics.draw(moldura_skins, retangulo3PosX, retanguloPosY, 0, escalaMoldura, escalaMoldura)
  love.graphics.printf( 
    'Lua Dourada',
    retangulo3PosX + 10,
    retanguloPosY + 60,
    largura - 10,
    "center"
  )
  
  love.graphics.setColor(valoresCoresSkins.lua[3][1], valoresCoresSkins.lua[3][2], valoresCoresSkins.lua[3][3])
  love.graphics.draw(lua.imagem, skinLua3PosX, skinLuaPosY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.setColor(255, 255, 255)
  
  -- Texto TERRA GELADA -- 
  isSkinSelecionadaTexto(skinTerra, 1, 20, retanguloPosX, retangulo2PosY)
  love.graphics.draw(moldura_skins, retanguloPosX, retangulo2PosY, 0, escalaMoldura, escalaMoldura)
  love.graphics.printf( 
    'Terra Gelada',
    retanguloPosX + 10,
    retangulo2PosY + 60,
    largura - 10,
    "center"
  )
  
  love.graphics.draw(terra.imagem, skinLuaPosX, skinSegundaLinhaY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.draw(valoresCoresSkins.terra[1], skinLuaPosX, skinSegundaLinhaY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.setColor(255, 255, 255)
  
  -- Texto TERRA SUBMERSA -- 
  isSkinSelecionadaTexto(skinTerra, 2, 30, retangulo2PosX, retangulo2PosY)
  love.graphics.draw(moldura_skins, retangulo2PosX, retangulo2PosY, 0, escalaMoldura, escalaMoldura)
  love.graphics.printf( 
    'Terra Desértica',
    retangulo2PosX + 10,
    retangulo2PosY + 60,
    largura - 10,
    "center"
  )
  
  love.graphics.draw(terra.imagem, skinLua2PosX, skinSegundaLinhaY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.draw(valoresCoresSkins.terra[2], skinLua2PosX, skinSegundaLinhaY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.setColor(255, 255, 255)
  
   -- Texto TERRA RADIOATIVA -- 
  isSkinSelecionadaTexto(skinTerra, 3, 45, retangulo3PosX, retangulo2PosY)
  love.graphics.draw(moldura_skins, retangulo3PosX, retangulo2PosY, 0, escalaMoldura, escalaMoldura)
  love.graphics.printf( 
    'Terra Radioativa',
    retangulo3PosX + 10,
    retangulo2PosY + 60,
    largura - 10,
    "center"
  )
  
  love.graphics.setColor(valoresCoresSkins.terra[3][1], valoresCoresSkins.terra[3][2], valoresCoresSkins.terra[3][3])
  love.graphics.draw(terra.imagem, skinLua3PosX, skinSegundaLinhaY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.setColor(255, 255, 255)
  
  -- Texto LUA PADRÃO -- 
  isSkinSelecionadaTexto(skinLua, 0, 0, retanguloLuaPadraoPosX, retanguloPadraoPosY)
  love.graphics.draw(moldura_skins, retanguloLuaPadraoPosX, retanguloPadraoPosY, 0, escalaMoldura, escalaMoldura)
  love.graphics.printf( 
    'Lua Padrão',
    retanguloLuaPadraoPosX + 10,
    retanguloPadraoPosY + 60,
    largura - 10,
    "center"
  )
  
  love.graphics.draw(lua.imagem, skinLuaPadraoPosX, skinPadraoPosY, 0, escalaLuaImg, escalaLuaImg)
     
   -- Texto TERRA PADRÃO-- 
  isSkinSelecionadaTexto(skinTerra, 0, 0, retanguloTerraPadraoPosX, retanguloPadraoPosY)
  love.graphics.draw(moldura_skins, retanguloTerraPadraoPosX, retanguloPadraoPosY, 0, escalaMoldura, escalaMoldura)
  love.graphics.printf( 
    'Terra Padrão',
    retanguloTerraPadraoPosX + 10,
    retanguloPadraoPosY + 60,
    largura - 10,
    "center"
  )
  
  love.graphics.draw(terra.imagem, skinTerraPadraoPosX, skinPadraoPosY, 0, escalaLuaImg, escalaLuaImg)
  love.graphics.setColor(255, 255, 255)
  
  -- Exibe o botão de retorno --
  local larguraReturnIco = returnIco:getWidth()
  local alturaReturnIco = returnIco:getHeight()
  local returnIcoX = screenWidth - larguraReturnIco -30
  local returnIcoY = screenHeight - alturaReturnIco -30
  love.graphics.draw(returnIco, returnIcoX, returnIcoY, 0, 1, 1)
  
  -- Verifica se selecionou a 1º Skin -- 
  if isCliqueEmTexto(
    retanguloPosX, 
    retanguloPosY,
    largura, 
    altura
    ) and botaoUmSolto and maiorOnda >= 15 then
    botaoUmSolto = false
    skinLua = 1
  end 
  
  -- Verifica se selecionou a 2º Skin -- 
  if isCliqueEmTexto(
    retangulo2PosX, 
    retanguloPosY,
    largura, 
    altura
    ) and botaoUmSolto and maiorOnda >= 25 then
    botaoUmSolto = false
    skinLua = 2
  end 
  
  -- Verifica se selecionou a 3º Skin -- 
  if isCliqueEmTexto(
    retangulo3PosX, 
    retanguloPosY,
    largura, 
    altura
    ) and botaoUmSolto and maiorOnda >= 35 then
    botaoUmSolto = false
    skinLua = 3
  end 
  
  -- Verifica se selecionou a 4º Skin -- 
  if isCliqueEmTexto(
    retanguloPosX, 
    retangulo2PosY,
    largura, 
    altura
    ) and botaoUmSolto and maiorOnda >= 20 then
    botaoUmSolto = false
    skinTerra = 1
  end 
  
  -- Verifica se selecionou a 5º Skin -- 
  if isCliqueEmTexto(
    retangulo2PosX, 
    retangulo2PosY,
    largura, 
    altura
    ) and botaoUmSolto and maiorOnda >= 30 then
    botaoUmSolto = false
    skinTerra = 2
  end 
  
  -- Verifica se selecionou a 6º Skin -- 
  if isCliqueEmTexto(
    retangulo3PosX, 
    retangulo2PosY,
    largura, 
    altura
    ) and botaoUmSolto and maiorOnda >= 45 then
    botaoUmSolto = false
    skinTerra = 3
  end 
  
  -- Verifica se selecionou a Lua Padrão -- 
  if isCliqueEmTexto(
    retanguloLuaPadraoPosX, 
    retanguloPadraoPosY,
    largura, 
    altura
    ) and botaoUmSolto then
    botaoUmSolto = false
    skinLua = 0
  end 
  
  -- Verifica se selecionou a Terra Padrão -- 
  if isCliqueEmTexto(
    retanguloTerraPadraoPosX, 
    retanguloPadraoPosY,
    largura, 
    altura
    ) and botaoUmSolto then
    botaoUmSolto = false
    skinTerra = 0
  end 
  
  -- verifica se clicou sobre o "Botão de retorno" -- 
  if isCliqueEmTexto(returnIcoX, returnIcoY, larguraReturnIco, alturaReturnIco) and botaoUmSolto then
    botaoUmSolto = false
    skinScreen = false
  end  
end

function telaDePause()
 desfoqueFundo(220)
  -- Exibe o texto de "Retomar"
  love.graphics.setFont(fonteMenu)
  local retomarWidth = love.graphics.getFont():getWidth("> Retomar")
  local retomarHeight = love.graphics.getFont():getHeight("> Retomar") - 10
  local retomarX = centroJanelaX - retomarWidth / 2
  local retomarY = centroJanelaY * 0.6
  love.graphics.print("> Retomar", retomarX, retomarY)
  underlineTextHover(retomarX, retomarY, retomarWidth, retomarHeight) 
  
  -- Exibe o texto de "Voltar ao menu"
  local menuWidth = love.graphics.getFont():getWidth("> Voltar ao Menu")
  local menuHeight = love.graphics.getFont():getHeight("> Voltar ao Menu") - 10
  local menuX = centroJanelaX - menuWidth / 2
  local menuY = centroJanelaY 
  love.graphics.print("> Voltar ao Menu", menuX, menuY)
  underlineTextHover(menuX, menuY, menuWidth, menuHeight)
  
  botaoDeOpcoes()
  
  -- verifica se clicou sobre "Retomar"
  if isCliqueEmTexto(retomarX, retomarY, retomarWidth, retomarHeight) and botaoUmSolto then
    botaoUmSolto = false
    pause = not pause
  end
 
  -- verifica se clicou sobre "Voltar ao menu"
  if isCliqueEmTexto(menuX, menuY, menuWidth, menuHeight) and botaoUmSolto then
    botaoUmSolto = false
    resetaJogo()
  end  
end

function desenhoSombraLua(x, y, oriX, oriY, angulo)
  -- Lógica de carregamento das sombras do lado direto
  if angulo <= 195 and angulo >= 185 then
    sombraSprite = 1
  elseif angulo < 185 and angulo >= 170 then
    sombraSprite = 2
  elseif angulo < 170 and angulo >= 155 then
    sombraSprite = 3
  elseif angulo < 155 and angulo >= 145 then
    sombraSprite = 4
  elseif angulo < 145 and angulo >= 135 then
    sombraSprite = 5
  elseif angulo < 135 and angulo >= 125 then
    sombraSprite = 6
  elseif angulo < 125 and angulo >= 105 then
    sombraSprite = 7
  elseif angulo < 105 and angulo >= 75 then
    sombraSprite = 8
  elseif angulo < 75 and angulo >= 60 then
    sombraSprite = 9
  elseif angulo < 60 and angulo >= 0 then
    sombraSprite = 10 
  end
  -- Lógica de carregamento das sombras do lado esquerdo
  if angulo <= 360 and angulo >= 350 then
    sombraSprite = 9
  elseif angulo < 350 and angulo >= 340 then
    sombraSprite = 8
  elseif angulo < 340 and angulo >= 330 then
    sombraSprite = 7
  elseif angulo < 330 and angulo >= 320 then
    sombraSprite = 6
  elseif angulo < 320 and angulo >= 300 then
    sombraSprite = 5
  elseif angulo < 300 and angulo >= 290 then
    sombraSprite = 4
  elseif angulo < 290 and angulo >= 280 then
    sombraSprite = 3
  elseif angulo < 280 and angulo >= 270 then
    sombraSprite = 2
  elseif angulo < 270 and angulo >= 260 then
    sombraSprite = 1
  end
  
  if sombraSprite > 0 then
    love.graphics.draw(sombrasAnim[sombraSprite], x + 2, y + 2, 0, 1, 1, oriX, oriY)
  end 
  sombraSprite = 0
end

-- função que verifica se um texto foi clicado
function isCliqueEmTexto(x, y, w, h)
  xMouse = love.mouse.getX()
  yMouse = love.mouse.getY()
  return love.mouse.isDown(1) and xMouse >= x and xMouse < x + w and yMouse >= y and yMouse < y + h 
end

-- função que adiciona um "underline" sobre o texto que o usuário passa o mouse
function underlineTextHover(x, y, w, h)
  if isMouseHover(x, y, w, h) then
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", x, y + h, w, 5)
    return true
  end
  return false
end

function isMouseHover(x, y, w, h)
  xMouse = love.mouse.getX()
  yMouse = love.mouse.getY()
  if xMouse >= x and xMouse < x + w and yMouse >= y and yMouse < y + h then
    return true
  end
  return false
end

-- Apresenta o "desfoque de fundo"
function desfoqueFundo(des)
  love.graphics.setColor(0,0,0, des)
  love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
  love.graphics.setColor(255, 255, 255)
end

-- Função que retorna o texto da descrição dos potencializadores formatado de acordo com vantagens e desvantagens --
function retornaTextoPotencializador(opcao)
  return string.format(potencializadores[potencializadoresSorteados[opcao]].descricao, potencializadores[potencializadoresSorteados[opcao]].vantagem, potencializadores[potencializadoresSorteados[opcao]].desvantagem)
end

-- Função que define a cor de desenho baseado na raridade do potencializador --
function corRaridadePotencializador(opcao)
  if potencializadores[potencializadoresSorteados[opcao]].peso == 10 then
    love.graphics.setColor(111, 237, 35) -- comum
  elseif potencializadores[potencializadoresSorteados[opcao]].peso == 6 then
    love.graphics.setColor(28, 156, 21) -- incomum
  elseif potencializadores[potencializadoresSorteados[opcao]].peso == 5 then
    love.graphics.setColor(11, 130, 237) -- raro
  elseif potencializadores[potencializadoresSorteados[opcao]].peso == 3 then
    love.graphics.setColor(201, 29, 182) -- épico
  elseif potencializadores[potencializadoresSorteados[opcao]].peso == 1 then
    love.graphics.setColor(237, 196, 35) -- lendário
  end
end

-- Função que retorna o texto relativo a raridade do potencializador --
function textoRaridadePotencializador(opcao)
  if potencializadores[potencializadoresSorteados[opcao]].peso == 10 then
    return "Comum"
  elseif potencializadores[potencializadoresSorteados[opcao]].peso == 6 then
    return "Incomum"
  elseif potencializadores[potencializadoresSorteados[opcao]].peso == 5 then
    return "Raro"
  elseif potencializadores[potencializadoresSorteados[opcao]].peso == 3 then
    return "Épico"
  elseif potencializadores[potencializadoresSorteados[opcao]].peso == 1 then
    return "Lendário"
  end
end

-- Função responsável por gerenciar o botão que ativa "Atração Gravitacional"
function exibeBotaoAtracaoGravitacional()
  -- Exibe a imagem do botão -- 
  love.graphics.setColor(255, 255, 255, 130)
  love.graphics.draw(atracaoImg, 300, screenHeight - 300, 0, 1, 1, atracaoImg:getWidth() / 2, atracaoImg:getHeight() / 2)
  -- Define os valores para exibir o texto -- 
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fonteNegrito)
  
  if (tempoAtracaoGravitacional > 0) then
    love.graphics.print(
      string.format("%.1f", tempoAtracaoGravitacional / 60) .. 's', 
      300, screenHeight - 300, 
      0, 0.4, 0.4, 
      love.graphics.getFont():getWidth(string.format("%.1f", tempoAtracaoGravitacional / 60) .. 's') / 2,
      love.graphics.getFont():getHeight(string.format("%.1f", tempoAtracaoGravitacional / 60) .. 's') / 2)
  elseif isAtracaoGravitacional then
    love.graphics.print('--', 300, screenHeight - 300, 0, 0.4, 0.4, love.graphics.getFont():getWidth('--') / 2, love.graphics.getFont():getHeight('--') / 2)
  else
    love.graphics.print('E', 300, screenHeight - 300, 0, 0.4, 0.4, love.graphics.getFont():getWidth('E') / 2, love.graphics.getFont():getHeight('E') / 2)
  end
  
  love.graphics.setColor(255, 255, 255, 255)
end

function exibeBotaoControleGravitacional()
  -- Exibe a imagem do botão -- 
  love.graphics.setColor(255, 255, 255, 130)
  love.graphics.draw(controleGravImg, 150, screenHeight - 400, 0, 1, 1, controleGravImg:getWidth() / 2, controleGravImg:getHeight() / 2)
  -- Define os valores para exibir o texto -- 
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fonteNegrito)
  
  if (tempoControleGravitacional > 0) then
    love.graphics.print(
      string.format("%.1f", tempoControleGravitacional / 60) .. 's', 
      150, screenHeight - 400, 
      0, 0.4, 0.4, 
      love.graphics.getFont():getWidth(string.format("%.1f", tempoControleGravitacional / 60) .. 's') / 2,
      love.graphics.getFont():getHeight(string.format("%.1f", tempoControleGravitacional / 60) .. 's') / 2)
  elseif isControleGravitacional then
    love.graphics.print('--', 150, screenHeight - 400, 0, 0.4, 0.4, love.graphics.getFont():getWidth('--') / 2, love.graphics.getFont():getHeight('--') / 2)
  else
    love.graphics.print('Q', 150, screenHeight - 400, 0, 0.4, 0.4, love.graphics.getFont():getWidth('Q') / 2, love.graphics.getFont():getHeight('Q') / 2)
  end
  
  love.graphics.setColor(255, 255, 255, 255)
end

function mostraCursor()
  if pause or trocaDeFase or startGame == 0 or gameOver then
    love.graphics.draw(imagemCursor, love.mouse.getX(), love.mouse.getY(), 0, 1, 1, 0, imagemCursor:getHeight())
  end
end

function rotacaoInimigo(inimigo, vel)
  if not pause and not trocaDeFase and startGame ~= 0 and not gameOver then
    if vel == nil then vel = inimigo.velocidadeRotacao end
    inimigo.rotacao = inimigo.rotacao + vel
    if inimigo.rotacao >= 360 then inimigo.rotacao = 0 end
  end
end

function keyboardSelectedText(x, y, width, active)
  if active then
    love.graphics.print("-|", x - love.graphics.getFont():getWidth('-|'), y)
    love.graphics.print("|-", x + width + 5, y)
  end
end