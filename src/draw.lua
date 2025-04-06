function love.draw()
  --  Carregamento da imagem da Galáxia  --
  love.graphics.draw(fundo.imagem, fundo.posX, fundo.posY, 0, fundo.tamX, fundo.tamY, fundo.oriX, fundo.oriY)
  
  --  Carregamento da imagem da Terra  --
  love.graphics.draw(terra.imagem, terra.posX, terra.posY, 0, 1, 1, terra.oriX, terra.oriY)
  
  --  Carregamento da imagem da Lua  --
  love.graphics.draw(lua.imagem, lua.posX, lua.posY, 0, 1, 1, lua.oriX, lua.oriY)
  
  -- Carregamento das imagens de meteoroides --
  for i, meteoroide in ipairs(meteoroides) do
    love.graphics.draw(meteoroideImg, meteoroide.x, meteoroide.y, 0, 1, 1, meteoroideImg:getWidth() / 2, meteoroideImg:getHeight() / 2)
  end
  
  --Tela de Pause
   if pause then    
    telaDePause() 
  end
  
end

function telaDePause()
  -- Apresenta o "desfoque de fundo"
  love.graphics.setColor(0,0,0, 180)
  love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
  love.graphics.setColor(255, 255, 255)
  -- Exibe o texto de "Retomar"
  love.graphics.setFont(fonteMenu)
  local retomarWidth = love.graphics.getFont():getWidth("> Retomar")
  local retomarHeight = love.graphics.getFont():getHeight("> Retomar") - 10
  local retomarX = centroJanelaX - retomarWidth / 2
  local retomarY = centroJanelaY * 0.6
  love.graphics.print("> Retomar", retomarX, retomarY)
  underlineTextHover(retomarX, retomarY, retomarWidth, retomarHeight)
  -- verifica se clicou sobre "Retomar"
  if isCliqueEmTexto(retomarX, retomarY, retomarWidth, retomarHeight) then
    pause = not pause
  end
  -- Exibe o texto de "Voltar ao menu"
  local menuWidth = love.graphics.getFont():getWidth("> Voltar ao Menu")
  local menuHeight = love.graphics.getFont():getHeight("> Voltar ao Menu") - 10
  local menuX = centroJanelaX - menuWidth / 2
  local menuY = centroJanelaY 
  love.graphics.print("> Voltar ao Menu", menuX, menuY)
  underlineTextHover(menuX, menuY, menuWidth, menuHeight)
  -- verifica se clicou sobre "Retomar"
  if isCliqueEmTexto(menuX, menuY, menuWidth, menuHeight) then
    pause = not pause
  end  
  end

-- função que verifica se um texto foi clicado
function isCliqueEmTexto(x, y, w, h)
  xMouse = love.mouse.getX()
  yMouse = love.mouse.getY()
  return love.mouse.isDown("1") and xMouse >= x and xMouse < x + w and yMouse >= y and yMouse < y + h 
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