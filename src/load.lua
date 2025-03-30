-- Carregamento de variáveis que serão utilizadas de maneira constante
-- Ou devem ser resetadas após a finalização do jogo
function love.load() 
  terraImagem = love.graphics.newImage("assets/images/terra.png")
  luaImagem = love.graphics.newImage("assets/images/lua.png")
  sombra = love.graphics.newImage("assets/images/sombra.png")
  fundoImagem = love.graphics.newImage("assets/images/fundo.jpeg")
  
  sombraRot = 11.3
  orbitaLua = 0
  velocidadeOrbita = 1
  direcaoOrbita = 1
end