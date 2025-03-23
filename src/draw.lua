function love.draw()
  --  Carregamento da imagem da Galáxia  --
  love.graphics.draw(fundo.imagem, fundo.posX, fundo.posY, 0, fundo.tamX, fundo.tamY, fundo.oriX, fundo.oriY)
  
  --  Carregamento da imagem da Terra  --
  love.graphics.draw(terra.imagem, terra.posX, terra.posY, 0, terra.tamX, terra.tamY, terra.oriX, terra.oriY)
  
  --  Carregamento da imagem da Lua  --
  love.graphics.draw(lua.imagem, lua.posX, lua.posY, 0, lua.tamX, lua.tamY, lua.oriX, lua.oriY)
  --  Carregamento da imagem da Sombra da Lua  --
  love.graphics.draw(sombra, lua.posX, lua.posY, sombraRot, lua.tamX, lua.tamY, lua.oriX, lua.oriY)
  
end