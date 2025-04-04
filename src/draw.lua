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
  love.graphics.setColor(0,0,0, 180)
  love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("> Retornar", centroJanelaX - love.graphics.getFont():getWidth("> Retornar"), centroJanelaY)
end