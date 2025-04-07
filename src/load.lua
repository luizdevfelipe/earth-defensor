-- Carregamento de variáveis que serão utilizadas de maneira constante
-- Ou devem ser resetadas após a finalização do jogo
function love.load() 
  terraImg = love.graphics.newImage("assets/images/terra.png")
  luaImg = love.graphics.newImage("assets/images/lua.png")
  sombra = love.graphics.newImage("assets/images/sombra.png")
  fundoImg = love.graphics.newImage("assets/images/fundo.jpeg")
  meteoroideImg = love.graphics.newImage("assets/images/meteoroide.png")
  fonteMenu = love.graphics.newFont("assets/fonts/Probeta-SemiBoldItalic.ttf", 100)
  --detritoImg = love.graphics.newImage("assets/images/detrito.png")
  
  sombrasAnim = {}
  for i = 1, 10, 1 do
    sombrasAnim[i] = love.graphics.newImage("assets/images/sombras/" .. i .. ".png")
  end
  
  
  math.randomseed(os.time())
  resetaJogo()
  botaoUmSolto = true
end

function resetaJogo()  
  orbitaLua = 0
  velocidadeOrbita = 3
  direcaoOrbita = 1
  -- 0 não há jogo, 1 um jogador, 2 dois jogadores
  startGame = 0
  gameOver = true
  pause = false
  -- Variáveis dos inimigos
  meteoroides = {}
  metricasMeteoroides = {
    vel = 300,
    qtd = 5,
    delay = 1,
    contagem = 1
  }
end
