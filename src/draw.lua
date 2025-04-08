function love.draw()
  --  Carregamento da imagem da Galáxia  --
  love.graphics.draw(fundo.imagem, fundo.posX, fundo.posY, 0, fundo.tamX, fundo.tamY, fundo.oriX, fundo.oriY)
  
  --  Carregamento da imagem da Terra  --
  love.graphics.draw(terra.imagem, terra.posX, terra.posY, 0, 1, 1, terra.oriX, terra.oriY)
  
  --  Carregamento da imagem da Lua  --
  love.graphics.draw(lua.imagem, lua.posX, lua.posY, 0, 1, 1, lua.oriX, lua.oriY)
  -- Carregamento da Sombra da Lua --
  desenhoSombraLua(lua.posX, lua.posY, lua.oriX, lua.oriY, getAngulo(terra.posX, terra.posY, lua.posX, lua.posY))
  
  -- Tela inicial
  if startGame == 0 then
     telaInicial()
  end
  
  --Tela de Pause
   if pause and startGame ~= 0 then    
    telaDePause() 
  end
  
  -- Carregamento das imagens de meteoroides --
  for i, meteoroide in ipairs(meteoroides) do
    love.graphics.draw(meteoroideImg, meteoroide.x, meteoroide.y, 0, 1, 1, meteoroideImg:getWidth() / 2, meteoroideImg:getHeight() / 2)
  end
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
    gameOver = false
  end
  
  -- verifica se clicou sobre "Dois Jogadores"
  if isCliqueEmTexto(doisJogadoresX, doisJogadoresY, doisJogadoresWidth, doisJogadoresHeight) and botaoUmSolto then
    botaoUmSolto = false
    startGame = 2
    gameOver = false
  end  
end

function telaDePause()
 desfoqueFundo(150)
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
  -- Elaborar a lógica de troca entre sprites
  
  love.graphics.draw(sombrasAnim[sombraSprite], x, y, 0, 1, 1, oriX, oriY)
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