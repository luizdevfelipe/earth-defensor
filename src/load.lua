-- Carregamento de variáveis que serão utilizadas de maneira constante
-- Ou devem ser resetadas após a finalização do jogo
function love.load() 
  -- Definição de variáveis com o tamanho da tela do jogo --
  screenWidth, screenHeight = love.window.getMode()
  centroJanelaX = screenWidth / 2
  centroJanelaY = screenHeight / 2
  -- Definição de variáveis com o tamanho da tela do jogo --
  -- Carregamentos de arquivos da pasta assets --
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
  -- Carregamentos de arquivos da pasta assets --
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
  -- Carregamento das variáveis da Animação
  -- Carregamento de variáveis para a Sombra da Lua
  sombrasAnim = {}
  sombraSprite = 1
  for i = 1, 10, 1 do
    sombrasAnim[i] = love.graphics.newImage("assets/images/sombras/" .. i .. ".png")
  end
  -- Carregamento de variáveis para a Sombra da Lua
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
      titulo = "Máquinas Aceleradas", 
      descricao = "As máquinas usadas na recuperação de impactos passam a trabalhar %d%% mais rápido aumentando a taxa de regeneração, mas a poluição gerada contribui para os danos causados por Meteoroides em %d%%.", 
      vantagem = 20, 
      desvantagem = 25,
      alvoVantagem = taxaRegeneracao,
      alvoDesvantagem = metricasMeteoroides.dano,
      peso = 5
    },
  }  
  
   --  Atributos da Terra --
  terra = {
      imagem = terraImg,
      posX = centroJanelaX,
      posY = centroJanelaY,
      raio = terraImg:getWidth() / 2,
      oriX = terraImg:getWidth() / 2 ,
      oriY = terraImg:getHeight() / 2,
      vel = { valor = 400 }
  }
  --  Atributos da Terra --
  
  --  Atributos Lua  --
  lua = {
    imagem = luaImg,
    posX = 0,
    posY = 0,
    raio = luaImg:getWidth() / 2,
    distanciaTerra = { valor = 250 },
    oriX = luaImg:getWidth() / 2,
    oriY = luaImg:getHeight() / 2,
  }
  --  Atributos Lua  --
  -- Carregamento de variáveis que não se alteram com as partidas
end

function resetaJogo()
  potencializadoresSorteados = nil -- variável para armazenar os potencializadores a serem escolhidos
  pesos = {} -- variável para armazenar os pesos de probabilidades
  trocaDeFase = false
  onda = 1
  vidasTerra = { valor = 3 }
  velocidadeRegeneracao = 0.5 -- intervalo padrão para regeneração da Terra
  tempoRegeneracao = velocidadeRegeneracao -- variável que tem o tempo alterado verificando momento de regenerar 
  taxaRegeneracao = { valor = 0.05 } -- valor padrão usado no momento de recuperação da vida da Terra
  orbitaLua = 0 -- valor usado para definir a posição atual da Lua
  
  velocidadeOrbita = { valor = 1.5 }
  resistenciaLunar = { valor = 10 } -- valor padrão que indica quantos meteoritos a Lua resiste colidir até ficar lenta
  eficienciaLunar = resistenciaLunar.valor -- variável durante o jogo, esse valor indica o momento de aplicar a lentidão
  taxaReducaoEficienciaLunar = { valor = 1 }
  tempoLentidaoLunar = { valor = 3.5 }  -- valor do tempo de lentidão aplicado sobre o cálculo da órbita lunar
  lentidaoLunarRestante = tempoLentidaoLunar.valor -- variável, indicará o tempo restante do efeito de Lentidão
  taxaReducaoTempoLentidaoLunar = { valor = 4 } -- valor usado para reduzir o tempo restante de lentidão
  efeitoLentidao = { valor = 2 } -- valor aplicado sobre a velocidade da orbita 
  
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
    qtd = { valor = 0 }, -- possibilita passagem por referência --
    delay = 1, -- intervalo padrão de criação
    contagem = 1, -- variável de "cronometro" para uma nova criação
    dano = { valor = 1 },
    destruidos = 0,
    colisoes = 2,
    escala = { valor = 2 }
  }
  -- Variáveis dos Meteoroides --
  meteoroides = {}
  metricasMeteoroides = {
    id = "normal",
    img = meteoroideImg,
    vel = { valor = 120 },
    qtd = { valor = 8 }, -- tabela possibilita passagem por referência --
    delay = 1.5,
    contagem = 1,
    dano = { valor =  0.2 },
    destruidos = 0,
    escala = { valor = 1 }
  }
  -- Variáveis dos Detritos --
  detritos = {}
  metricasDetrito = {
    img = detritoImg,
    destruidos = 0,
    qtd = 3
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