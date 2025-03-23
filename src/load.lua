function love.load() 
  terraImagem = love.graphics.newImage("assets/images/terra.png")
  luaImagem = love.graphics.newImage("assets/images/lua.png")
  sombra = love.graphics.newImage("assets/images/sombra.png")
  
  --  Atributos da Terra --
  terra = {
      imagem = terraImagem,
      posX = centroJanelaX,
      posY = centroJanelaY,
      tamX = 0.5,
      tamY = 0.5,
      oriX = terraImagem:getWidth() / 2 ,
      oriY = terraImagem:getHeight() / 2
  }
  
  --  Atributos Lua  --
  lua = {
    imagem = luaImagem,
    posX = centroJanelaX + 300,
    posY = centroJanelaY + 100,
    tamX = 0.2,
    tamY = 0.2,
    oriX = luaImagem:getWidth() / 2 ,
    oriY = luaImagem:getHeight() / 2
  }
  sombraRot = 0
end