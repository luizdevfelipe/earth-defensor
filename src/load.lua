-- Carregamento de variáveis que serão utilizadas de maneira constante
-- Ou devem ser resetadas após a finalização do jogo
function love.load() 
  -- Carregamentos de arquivos da pasta assets
  terraImg = love.graphics.newImage("assets/images/terra.png")
  luaImg = love.graphics.newImage("assets/images/lua.png")
  sombra = love.graphics.newImage("assets/images/sombra.png")
  fundoImg = love.graphics.newImage("assets/images/fundo.jpeg")
  meteoroideImg = love.graphics.newImage("assets/images/meteoroide.png")
  superImg = love.graphics.newImage("assets/images/super.png")
  fonteNegrito = love.graphics.newFont("assets/fonts/SpecialGothicExpandedOne-Regular.ttf", 70)
  fonteMenu = love.graphics.newFont("assets/fonts/Probeta-SemiBoldItalic.ttf", 100)
  fonteMenu50 = love.graphics.newFont("assets/fonts/Probeta-SemiBoldItalic.ttf", 50)
  fontNormal = love.graphics.newFont("assets/fonts/Roboto-VariableFont_wdth,wght.ttf", 40)
  fontNormal20 = love.graphics.newFont("assets/fonts/Roboto-VariableFont_wdth,wght.ttf", 20)
  detritoImg = love.graphics.newImage("assets/images/detrito.png")
  musicaIntroducao = love.audio.newSource("assets/audio/Midnight Trace - Jimena Contreras.mp3")
  meteoroImg = love.graphics.newImage("assets/images/meteoro.png")
  protetoraImg = love.graphics.newImage("assets/images/protetora.png")
  -- Carregamento das variáveis da Animação
  introducao = false
  movimentoTerraAnim = 0
  movimentoLuaAnim = 0
  transparenciaTerraAnim = 60
  transparenciaMeteoroAnim = 0
  intervaloMeteoroAnim = 70
  transparenciaLuaAnim = 0
  intervaloLuaAnim = 56
  intervaloCreditosAnim = 40
  transparenciaCreditosAnim = 0
  transparenciaTextoInfo = 0
  -- Carregamento de variáveis para a Sombra da Lua
  sombrasAnim = {}
  sombraSprite = 1
  for i = 1, 10, 1 do
    sombrasAnim[i] = love.graphics.newImage("assets/images/sombras/" .. i .. ".png")
  end
  -- Carregamento de variáveis que não se alteram com as partidas
  math.randomseed(os.time())
  resetaJogo()
  botaoUmSolto = true
  potencializadores = {
    {
      titulo = "Velocidade Lunar", 
      descricao = "A Lua recebe um incremento de %d%% em sua velocidade, mas %d%% de Meteoroides extras aparecem.", 
      vantagem = 5, 
      desvantagem = 6,
      alvoVantagem = velocidadeOrbita,
      alvoDesvantagem = metricasMeteoroides.qtd,
      peso = 1
    },
    {
      titulo = "Reconstrução da Terra", 
      descricao = "A Terra recebe %d%% da sua vida fundamental, em troca a velocidade dos inimigos aumenta em %d%%", 
      vantagem = 20, 
      desvantagem = 5,
      alvoVantagem = vidasTerra,
      alvoDesvantagem = metricasMeteoroides.vel,
      peso = 2
    },
    {
      titulo = "Fúria Lunar", 
      descricao = "A Lua destrói todos os meteoros ao encostar, com um limite de %d, porém a Terra sofre %d ponto de dano ao final do efeito.", 
      vantagem = 5, 
      desvantagem = 1,
      alvoVantagem = metricasMeteoroides.qtd,
      alvoDesvantagem = vidasTerra,
      peso = 5
    },
  }  
  potencializadoresSorteados = nil
  
end

function resetaJogo()
  pesos = {}
  trocaDeFase = false
  onda = 1
  vidasTerra = { valor = 3 }
  velocidadeRegeneracao = 0.5
  tempoRegeneracao = velocidadeRegeneracao
  taxaRegeneracao = 0.05
  orbitaLua = 0
  velocidadeOrbita = {valor = 1.5}
  direcaoOrbita = 1
  -- 0 não há jogo, 1 um jogador, 2 dois jogadores
  startGame = 0
  gameOver = false
  pause = false
  
  -- Variáveis dos Supermeteoroides --
  superMeteoroides = {}
  metricasSupermeteoroides = {
    id = "super",
    img = superImg,
    vel = { valor = 100 },
    qtd = { valor = 1 }, -- possibilita passagem por referência --
    delay = 1, -- intervalo padrão de criação
    contagem = 1, -- variável de "cronometro" para uma nova criação
    dano = 1,
    destruidos = 0,
    colisoes = 2
  }
  -- Variáveis dos Meteoroides --
  meteoroides = {}
  metricasMeteoroides = {
    id = "normal",
    img = meteoroideImg,
    vel = { valor = 120 },
    qtd = { valor = 5 }, -- tabela possibilita passagem por referência --
    delay = 1.5,
    contagem = 1,
    dano = 0.2,
    destruidos = 0
  }
  -- Variáveis dos Detritos --
  detritos = {}
  metricasDetrito = {
    img = detritoImg,
    destruidos = 0,
    qtd = 2
  }
end

function resetaRodada()  
  -- Metricas Definidas de acordo com rodadas Fáceis, Médias e Difíceis --
  if onda <= 10 then
    metricasSupermeteoroides.qtd.valor = 1
    metricasMeteoroides.qtd.valor = 3 + onda - 1
  elseif onda <= 20 then
    metricasSupermeteoroides.qtd.valor = 1
    metricasMeteoroides.qtd.valor = 3 + onda
  else
    metricasSupermeteoroides.qtd.valor = 3
    metricasMeteoroides.qtd.valor = 3 * onda
  end
end