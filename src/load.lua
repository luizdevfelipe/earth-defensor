-- Carregamento de variáveis que serão utilizadas de maneira constante
-- Ou devem ser resetadas após a finalização do jogo
function love.load() 
  terraImg = love.graphics.newImage("assets/images/terra.png")
  luaImg = love.graphics.newImage("assets/images/lua.png")
  sombra = love.graphics.newImage("assets/images/sombra.png")
  fundoImg = love.graphics.newImage("assets/images/fundo.jpeg")
  meteoroideImg = love.graphics.newImage("assets/images/meteoroide.png")
  detritoImg = love.graphics.newImage("assets/images/detrito.png")
  
  math.randomseed(os.time())
  sombraRot = 11.3
  orbitaLua = 0
  velocidadeOrbita = 1
  direcaoOrbita = 1
  
  -- Variáveis dos inimigos
  meteoroides = {}
  metricasMeteoroides = {
    qtd = 5,
    delay = 1,
    contagem = 1
  }
end