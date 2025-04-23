function love.draw()
  if musicaIntroducao:isPlaying() then
    desenharIntroducao()
  else 
    --  Carregamento da imagem da Galáxia  --
    love.graphics.draw(fundo.imagem, fundo.posX, fundo.posY, 0, fundo.tamX, fundo.tamY, fundo.oriX, fundo.oriY)
    
    --  Carregamento da imagem da Terra  --
    love.graphics.draw(terra.imagem, terra.posX, terra.posY, 0, 1, 1, terra.oriX, terra.oriY)
    
    --  Carregamento da imagem da Lua  --
    love.graphics.draw(lua.imagem, lua.posX, lua.posY, 0, 1, 1, lua.oriX, lua.oriY)
    -- Carregamento da Sombra da Lua --
    desenhoSombraLua(lua.posX, lua.posY, lua.oriX, lua.oriY, getAngulo(terra.posX, terra.posY, lua.posX, lua.posY))
    
     -- Carregamento dos detritos --
    for i, detrito in ipairs(detritos) do
      love.graphics.draw(detritoImg, detrito.x, detrito.y, 0, 1, 1, detritoImg:getWidth() / 2, detritoImg:getHeight() / 2)
    end
    
    -- Carregamento das imagens de meteoroides --
    for i, meteoroide in ipairs(meteoroides) do
      love.graphics.draw(meteoroideImg, meteoroide.x, meteoroide.y, 0, 1, 1, meteoroideImg:getWidth() / 2, meteoroideImg:getHeight() / 2)
    end
    
    -- Carregamento das imagens de SuperMeteoroides --
    for i, super in ipairs(superMeteoroides) do
      love.graphics.draw(metricasSupermeteoroides.img, super.x, super.y, 0, super.escala, super.escala, metricasSupermeteoroides.img:getWidth() / 2, metricasSupermeteoroides.img:getHeight() / 2)
    end
       
    if transparenciaTextoInfo < 255 then
      love.graphics.setFont(fontNormal)
      love.graphics.setColor(transparenciaTextoInfo, transparenciaTextoInfo, transparenciaTextoInfo, transparenciaTextoInfo)
      local instrucaoWidth = love.graphics.getFont():getWidth("Pressione W para alterar o movimento lunar")
      love.graphics.print("Pressione W para alterar o movimento lunar", centroJanelaX - instrucaoWidth / 2, screenHeight * 0.8)
    end
    
    if trocaDeFase  then
      telaDePotencializadores()
    end
    
    if gameOver then
      telaGameOver()
    end
    
    -- Tela inicial
    if startGame == 0 then
       telaInicial()
    end
    
    -- Exibe conteúdos que devem aparecer apenas durante o jogo --
    if not gameOver and not trocaDeFase and startGame ~= 0 then
      -- Carregamento da Barra de Vida
      barraDeVida() 
      
      -- Exibe a Onda atual do jogador --
      love.graphics.setFont(fontNormal)
      love.graphics.print("Onda: " .. onda, centroJanelaX - love.graphics.getFont():getWidth("Onda: " .. onda) / 2, screenHeight - 45)
    end
    
    --Tela de Pause
     if pause then    
      telaDePause() 
    end
  end
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
  
  desfoqueFundo(240)
  -- Exibe o texto "Escolha seu novo poder"
  love.graphics.setFont(fonteNegrito)
  local escolhaPoderWidth = love.graphics.getFont():getWidth("Escolha seu novo poder:")
  local escolhaPoderHeight = love.graphics.getFont():getHeight("Escolha seu novo poder:") - 10
  love.graphics.print("Escolha seu novo poder:", centroJanelaX - escolhaPoderWidth / 2, 60)
    
  -- Exibe o 1º quadrado com a habilidade --
  love.graphics.setLineWidth(larguraBorda)
  love.graphics.rectangle("line", centralizadoX - larguraRetangulo - espacoRetang, centralizadoY, larguraRetangulo, alturaRetangulo)
  love.graphics.setColor(0, 0, 0, 220)
  love.graphics.rectangle("fill", interior1QuadradoX, centralizadoY + larguraBorda / 2, larguraRetangulo - larguraBorda , alturaRetangulo - larguraBorda)
  -- Exibe o título da 1º habilidade --
  love.graphics.setFont(fonteMenu50)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print(
    potencializadores[potencializadoresSorteados[1]].titulo, 
    interior1QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth(potencializadores[potencializadoresSorteados[1]].titulo)) / 2, 
    centralizadoY
  )
  -- Exibe o 1º texto da habilidade --
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fontNormal20)
  love.graphics.printf( 
    retornaTextoPotencializador(1),
    interior1QuadradoX, 
    centroJanelaY - love.graphics.getFont():getHeight(retornaTextoPotencializador(1)) - 10,
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
  underlineTextHover(
    interior1QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
  )
  
  -- Exibe o 2º quadrado com a habilidade --
  love.graphics.rectangle("line", centralizadoX, centralizadoY, larguraRetangulo, alturaRetangulo)
  love.graphics.setColor(0, 0, 0, 220)
  love.graphics.rectangle("fill", centralizadoX + larguraBorda / 2, centralizadoY + larguraBorda / 2, larguraRetangulo - larguraBorda , alturaRetangulo - larguraBorda)
  -- Exibe o título da 2º habilidade --
  love.graphics.setFont(fonteMenu50)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print(
    potencializadores[potencializadoresSorteados[2]].titulo, 
    centralizadoX + larguraBorda / 2 + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth(potencializadores[potencializadoresSorteados[2]].titulo)) / 2, 
    centralizadoY
  )
  -- Exibe o 2º texto da habilidade --
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fontNormal20)
  love.graphics.printf( 
    retornaTextoPotencializador(2),
    centralizadoX + larguraBorda / 2,
    centroJanelaY - love.graphics.getFont():getHeight(retornaTextoPotencializador(1)) - 10,
    larguraRetangulo - larguraBorda,
    "justify"
  )
  -- Exibe o 2º botão de "Selecionar" --
  love.graphics.setFont(fonteMenu50)
  love.graphics.printf(
    "Selecionar", 
    centralizadoX + larguraBorda / 2, 
    textoSelecionarY, 
    larguraRetangulo - larguraBorda, 
    "center"
  )
  underlineTextHover(
    centralizadoX + larguraBorda / 2 + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
  )
 
 -- Exibe o 3º quadrado com a habilidade --
  love.graphics.rectangle("line", centralizadoX + larguraRetangulo + espacoRetang , centralizadoY, larguraRetangulo, alturaRetangulo)
  love.graphics.setColor(0, 0, 0, 220)
  love.graphics.rectangle("fill", centralizadoX + larguraRetangulo + espacoRetang + larguraBorda / 2, centralizadoY + larguraBorda / 2, larguraRetangulo - larguraBorda , alturaRetangulo - larguraBorda)
  -- Exibe o título da 3º habilidade --
  love.graphics.setFont(fonteMenu50)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print(
    potencializadores[potencializadoresSorteados[3]].titulo, 
    interior3QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth(potencializadores[potencializadoresSorteados[3]].titulo)) / 2, 
    centralizadoY
  )
  -- Exibe o 3º texto da habilidade --
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(fontNormal20)
  love.graphics.printf( 
    retornaTextoPotencializador(3),
    interior3QuadradoX, 
    centroJanelaY - love.graphics.getFont():getHeight(retornaTextoPotencializador(1)) - 10,
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
  underlineTextHover(
    interior3QuadradoX + (larguraRetangulo - larguraBorda - love.graphics.getFont():getWidth("Selecionar")) / 2, 
    textoSelecionarY - 8,
    love.graphics.getFont():getWidth("Selecionar"), 
    love.graphics.getFont():getHeight("Selecionar")
  )
 
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
  love.graphics.draw(terra.imagem, centroJanelaX - 100, centroJanelaY + 30 - movimentoTerraAnim, 0, 1, 1, terra.oriX, terra.oriY)
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
  
end

function barraDeVida()
  -- Fundo da barra de Vida
  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("fill", centroJanelaX - 103, 60, 206, 26)
  -- Barra de Vida em si
  love.graphics.setColor(34, 177, 76)
  if vidasTerra.valor > 3 then vidasTerra.valor = 3 end
  if vidasTerra.valor < 0 then vidasTerra.valor = 0 end
  love.graphics.rectangle("fill", centroJanelaX - 100, 63, (vidasTerra.valor * 200) / 3, 20)
  -- Recortes nas vidas principais
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", centroJanelaX - 100 / 3, 60, 4, 26)
  love.graphics.rectangle("fill", centroJanelaX + 100 / 3, 60, 4, 26)
  love.graphics.setColor(255,255,255)
end

function telaInicial()
  desfoqueFundo(180)
  -- Exibe o texto "Um Jogador"
  love.graphics.setFont(fonteMenu)
  local umJogadorWidth = love.graphics.getFont():getWidth("Um Jogador")
  local umJogadorHeight = love.graphics.getFont():getHeight("Um Jogador") - 10
  local umJogadorX = centroJanelaX - umJogadorWidth / 2
  local umJogadorY = centroJanelaY * 0.6
  love.graphics.print("Um Jogador", umJogadorX, umJogadorY)
  underlineTextHover(umJogadorX, umJogadorY, umJogadorWidth, umJogadorHeight)
  
  -- Exibe o texto de "Dois Jogadores"
  local doisJogadoresWidth = love.graphics.getFont():getWidth("Dois Jogadores")
  local doisJogadoresHeight = love.graphics.getFont():getHeight("Dois Jogadores") - 10
  local doisJogadoresX = centroJanelaX - doisJogadoresWidth / 2
  local doisJogadoresY = centroJanelaY 
  love.graphics.print("Dois Jogadores", doisJogadoresX, doisJogadoresY)
  underlineTextHover(doisJogadoresX, doisJogadoresY, doisJogadoresWidth, doisJogadoresHeight)
  
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
    love.graphics.draw(sombrasAnim[sombraSprite], x, y, 0, 1, 1, oriX, oriY)
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
  xMouse = love.mouse.getX()
  yMouse = love.mouse.getY()
  if xMouse >= x and xMouse < x + w and yMouse >= y and yMouse < y + h then
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", x, y + h, w, 5)
  end
end

-- Apresenta o "desfoque de fundo"
function desfoqueFundo(des)
  love.graphics.setColor(0,0,0, des)
  love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
  love.graphics.setColor(255, 255, 255)
end

function retornaTextoPotencializador(opcao)
  return string.format(potencializadores[potencializadoresSorteados[opcao]].descricao, potencializadores[potencializadoresSorteados[opcao]].vantagem, potencializadores[potencializadoresSorteados[opcao]].desvantagem)
end