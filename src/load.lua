-- Carregamento de variáveis que serão utilizadas de maneira constante
-- Ou devem ser resetadas após a finalização do jogo
function love.load() 
  -- Definição de variáveis com o tamanho da tela do jogo --
  screenWidth, screenHeight = love.window.getMode()
  screenWidthAtual, screenHeightAtual = love.window.getMode()
  centroJanelaX = screenWidth / 2
  centroJanelaY = screenHeight / 2
  local icon = love.image.newImageData("assets/images/icons/favicon.png")
  love.window.setIcon(icon)
  -- Definição de variáveis com o tamanho da tela do jogo --
  -- Configurações para o cursor sdo mouse --
  love.mouse.setVisible(false)
  -- Configurações para o cursor sdo mouse --
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
  fonteMenu35 = love.graphics.newFont("assets/fonts/Probeta-SemiBoldItalic.ttf", 35)
  fontNormal = love.graphics.newFont("assets/fonts/Roboto-VariableFont_wdth,wght.ttf", 40)
  fontNormal20 = love.graphics.newFont("assets/fonts/Roboto-VariableFont_wdth,wght.ttf", 20)
  detritoImg = love.graphics.newImage("assets/images/detrito.png")
  musicaIntroducao = love.audio.newSource("assets/audio/Midnight Trace - Jimena Contreras.mp3")
  somColisao = love.audio.newSource("assets/audio/Big Explosion Distant.mp3")
  meteoroImg = love.graphics.newImage("assets/images/meteoro.png")
  protetoraImg = love.graphics.newImage("assets/images/protetora.png")
  atracaoImg = love.graphics.newImage("assets/images/atracao.png")
  controleGravImg = love.graphics.newImage("assets/images/controle.png")
  optionsIco = love.graphics.newImage("assets/images/icons/options.png")
  disabledIco = love.graphics.newImage("assets/images/icons/disabled.png")
  enableIco = love.graphics.newImage("assets/images/icons/enable.png")
  returnIco = love.graphics.newImage("assets/images/icons/return.png")
  imagemCursor = love.graphics.newImage("assets/images/icons/cursor.png")
  enterIco = love.graphics.newImage("assets/images/icons/enter.png")
  colisaoAnimAtlas = love.graphics.newImage("assets/images/colisaoAnim.png")
  musicaMenu = love.audio.newSource("assets/audio/Galactic Bass - John Patitucci.mp3")
  musicaIntermediarios = love.audio.newSource("assets/audio/Pong the Atmosphere - Dan _Lebo_ Lebowitz, Tone Seeker.mp3")
  musicaIniciais = love.audio.newSource("assets/audio/Smooth and Cool - Nico Staf.mp3")
  musicaFinais = love.audio.newSource("assets/audio/Press Fuse - French Fuse.mp3")
  -- Cada frame tem w:180 e h: 180
  colisaoMeteoroideFrames = {
    love.graphics.newQuad(0, 0, 160, 158, 498, 158),
    love.graphics.newQuad(160, 0, 153, 158, 498, 158),
    love.graphics.newQuad(313, 0, 185, 158, 498, 158)
  }
  -- Carregamentos de arquivos da pasta assets --
  -- Carregamento das variáveis da Animação
  introducao = true  -- variável que indica que a animação ainda deve iniciar
  resetaTemposAnimacaoIntro()
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
  optionsScreen = false
  isGameMusic = true
  volumeGeral = 0.5
  alterarVolume() -- função que altera o volume de todos os aúdios
  potencializadores = {
    {
      titulo = "Velocidade Lunar", 
      descricao = "A Lua recebe um incremento de %d%% em sua velocidade, mas %d%% de Meteoroides extras aparecem.", 
      vantagem = 80, 
      desvantagem = 6,
      alvoVantagem = velocidadeOrbita,
      alvoDesvantagem = metricasMeteoroides.qtd,
      peso = 1
    },
    {
      titulo = "Reconstrução da Terra", 
      descricao = "A Terra recebe %d%% da sua vida fundamental, em troca a velocidade dos inimigos aumenta em %d%%", 
      vantagem = 30, 
      desvantagem = 5,
      alvoVantagem = vidasTerra,
      alvoDesvantagem = metricasMeteoroides.vel,
      peso = 3
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
    {
      titulo = "Blindagem da Lua", 
      descricao = "Uma camada extra de proteção adiciona %d%% mais resistência para a Lua contra detritos que causam lentidão, entretanto o peso adicional reduz sua velocidade em %d%%.", 
      vantagem = 20, 
      desvantagem = -1,
      alvoVantagem = resistenciaLunar,
      alvoDesvantagem = velocidadeOrbita,
      peso = 6
    },
    {
      titulo = "Construtores Lunares", 
      descricao = "Construtores são enviados para Lua, isso aumenta a recuperação contra lentidão aplicada sobre ela em %d%%, com menos contrutores a recuperação da vida da Terra é reduzida em %d%%.", 
      vantagem = 20, 
      desvantagem = -15,
      alvoVantagem = taxaReducaoTempoLentidaoLunar,
      alvoDesvantagem = taxaRegeneracao,
      peso = 10
    },
    {
      titulo = "Impulso meteórico", 
      descricao = "Alguns detritos passam a impulsionar a Lua o que reduz %d%% da lentidão aplicada sobre ela, mas quando implicam lentidão ela é mais forte aumentando %d%% do tempo de lentidão.", 
      vantagem = -20, 
      desvantagem = 10,
      alvoVantagem = efeitoLentidao,
      alvoDesvantagem = tempoLentidaoLunar,
      peso = 10
    },
    {
      titulo = "Eficiência da Lua", 
      descricao = "A lua passa por uma análise que aumenta sua eficiência isso reduz %d%% os danos causados por detritos. A análise feita custa recursos, o que reduz %d%% da taxa de regeneração terrestre.", 
      vantagem = -20, 
      desvantagem = -5,
      alvoVantagem = taxaReducaoEficienciaLunar,
      alvoDesvantagem = taxaRegeneracao,
      peso = 10
    },
    {
      titulo = "Magnetismo Lunar", 
      descricao = "Uma melhoria feita na Lua faz com que a intensidade da Atração Gravitacional aumente %d%% puxando inimigos mais distântes. Essa melhoria interfere no intervalo da habilidade que aumenta em %d%%.", 
      vantagem = 30, 
      desvantagem = 10,
      alvoVantagem = distanciaAtracaoGravitacional,
      alvoDesvantagem = intervaloAtracaoGravitacional,
      peso = 4
    },
  }  
  -- Carregamento de variáveis que não se alteram com as partidas
end

function resetaJogo()
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
    meteoroideAlvo = { id = nil, tipo = nil },
  }
  --  Atributos Lua  --
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
  taxaReducaoEficienciaLunar = { valor = 1 } -- valor padrão usado para "descontar" a eficiência quando colide
  tempoLentidaoLunar = { valor = 3.5 }  -- valor do tempo de lentidão aplicado sobre o cálculo da órbita lunar
  lentidaoLunarRestante = tempoLentidaoLunar.valor -- variável, indicará o tempo restante do efeito de Lentidão
  taxaReducaoTempoLentidaoLunar = { valor = 4 } -- valor usado para reduzir o tempo restante de lentidão
  efeitoLentidao = { valor = 2 } -- valor aplicado sobre a velocidade da orbita 
  
  intervaloAtracaoGravitacional = { valor = 2 * 60 } -- tempo padrão de espera para usar a habilidade
  tempoAtracaoGravitacional = intervaloAtracaoGravitacional.valor -- variável que calcula o tempo restante para poder usar a hab
  duracaoAtracaoGravitacional = { valor = 2 * 60 } -- tempo padrão que a habilidade fica ativa
  tempoAtracaoGravitacionalAtiva = duracaoAtracaoGravitacional.valor -- variável que calcula o tempo ativo da habilidade
  distanciaAtracaoGravitacional = { valor = 300 }
  isAtracaoGravitacional = false
  velAtracaoGravitacional = { valor = 200 }
  
  intervaloControleGravitacional = { valor = 5 * 60 } -- tempo padrão de espera para usar a habilidade
  tempoControleGravitacional = intervaloControleGravitacional.valor -- variável que calcula o tempo restante para poder usar a hab
  isControleGravitacional = false
  velControleGravitacional = { valor = 400 }
  distanciaControleGravitacional = { valor = 450 }
  
  direcaoOrbita = 1
  -- 0 não há jogo, 1 um jogador, 2 dois jogadores
  startGame = 0
  gameOver = false
  pause = false
  
  -- x = posição X do inimigo, y = posição Y do inimigo, frame = o quadro a ser desenhado
  animacoesColisoes = {}
 
  -- Variáveis dos Supermeteoroides --
  superMeteoroides = {}
  metricasSupermeteoroides = {
    id = 0,
    tipo = "super",
    img = superImg,
    vel = { valor = 1000 },
    qtd = { valor = 0 }, -- possibilita passagem por referência --
    delay = 0, -- intervalo padrão de criação
    contagem = 1, -- variável de "cronometro" para uma nova criação
    dano = { valor = 0 },
    destruidos = 0,
    colisoes = 2,
    escala = { valor = 2 }
  }
  -- Variáveis dos Meteoroides --
  meteoroides = {}
  metricasMeteoroides = {
    id = 0,
    tipo = "normal",
    img = meteoroideImg,
    vel = { valor = 1000 },
    qtd = { valor = 2 }, -- tabela possibilita passagem por referência --
    delay = 0.0,
    contagem = 1,
    dano = { valor =  0.0 },
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

function resetaTemposAnimacaoIntro()
  tempoPularAnim = 150 -- variável que contém o tempo restante que a tecla deve ser pressionada
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
end

function alterarVolume()
  musicaIntroducao:setVolume(volumeGeral + 0.2)
  somColisao:setVolume(volumeGeral + 0.2)
  musicaMenu:setVolume(volumeGeral)
  musicaIniciais:setVolume(volumeGeral - 0.5)
  musicaIntermediarios:setVolume(volumeGeral - 0.5)
  musicaFinais:setVolume(volumeGeral - 0.5)
end