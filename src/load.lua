-- Carregamento de variáveis que serão utilizadas de maneira constante
-- Ou devem ser resetadas após a finalização do jogo
function love.load() 
  debug = false -- variável que permite pular de fase com "j"
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
  meteoroidesImgs = {
    meteoroideImg = love.graphics.newImage("assets/images/meteoroide.png"),
    meteoroide_darkImg = love.graphics.newImage("assets/images/meteoroide_dark.png"),
    meteoroide2Img = love.graphics.newImage("assets/images/meteoroide2.png")
  }
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
  setinhasIco = love.graphics.newImage("assets/images/icons/setinhas.png")
  wIco = love.graphics.newImage("assets/images/icons/w.png")
  brilhoEstrela = love.graphics.newImage("assets/images/brilho.png")
  moldura_vida = love.graphics.newImage("assets/images/moldura_vida.png")
  terra_vida_bar = love.graphics.newImage("assets/images/terra_vida_bar.png")
  cycleIco = love.graphics.newImage("assets/images/icons/cycle.png")
  skinIco = love.graphics.newImage("assets/images/icons/skin.png")
  -- Carregamentos de arquivos da pasta assets --
  -- Carregamento das variáveis da Animação
  colisaoMeteoroideFrames = {
    -- Cada frame tem w:180 e h: 180
    love.graphics.newQuad(0, 0, 160, 158, 498, 158),
    love.graphics.newQuad(160, 0, 153, 158, 498, 158),
    love.graphics.newQuad(313, 0, 185, 158, 498, 158)
  }
  introducao = true  -- variável que indica que a animação ainda deve iniciar
  resetaTemposAnimacaoIntro()
  carregamentoEstrelas()
  -- Carregamento de variáveis para a Sombra da Lua
  sombrasAnim = {}
  sombraSprite = 1
  for i = 1, 10, 1 do
    sombrasAnim[i] = love.graphics.newImage("assets/images/sombras/" .. i .. ".png")
  end
  -- Carregamento de variáveis para a Sombra da Lua
  -- Carregamento de variáveis de "rachadura" da Lua --
  rachaduraAnim = {}
  rachaduraSprite = 0
  for i = 1, 3, 1 do
    rachaduraAnim[i] = love.graphics.newImage("assets/images/rachaduras/" .. i .. ".png")
  end
  -- Carregamento de variáveis de "rachadura" da Lua --
    -- Carregamento de variáveis da Terra Destruída --
  terraDestruidaAnim = {}
  terraDestruidaSprite = 0
  for i = 1, 2, 1 do
    terraDestruidaAnim[i] = love.graphics.newImage("assets/images/terras/" .. i .. ".png")
  end
  -- Carregamento de variáveis da Terra Destruída --
  -- Carregamento de variáveis que não se alteram com as partidas
  math.randomseed(os.time())
  resetaJogo()
  botaoUmSolto = true
  optionsScreen = false
  skinScreen = false
  isGameMusic = true
  volumeGeral = 0.5
  -- Variáveis para definição das skins dos personagens --
  skinTerra = 0
  skinLua = 0
  valoresCoresSkins = {
    terra = {
      love.graphics.newImage("assets/images/terras/skins/skin_neve.png"),
      love.graphics.newImage("assets/images/terras/skins/skin_deserto.png"),
      {100, 230, 100}
      
    },
    lua = {
      {180, 0, 0},
      {58, 148, 255},
      {255, 182, 41}
    }
  }
  -- Variáveis para definição das skins dos personagens --
  alterarVolume() -- função que altera o volume de todos os aúdios
  -- Carregamento de variáveis que não se alteram com as partidas
end

function resetaJogo()
  -- verifica se essas teclas foram pressionadas, apagando o texto auxiliar --
  pressionouW = false
  pressionouSetas = false
  transparenciaTextoInfo = 255 -- transparência colocada sobre o texto --
  botaoSelectModo = true -- varia entre os modos de jogo no menu usando teclado
  botaoSelectPotencializador = 2 -- varia entre a escolha de um novo potencializador
  cycleRot = 0 -- variável de rotação suave do botão de ciclo de habilidades
  canCycle = false -- variável que permite fazer a troca de potencializadores
  
   --  Atributos da Terra --
  terraDestruidaSprite = 0
  escalaTerraImg = 0.35
  terra = {
      imagem = terraImg,
      posX = centroJanelaX,
      posY = centroJanelaY,
      raio = (terraImg:getWidth()*escalaTerraImg) / 2,
      oriX = (terraImg:getWidth()*escalaTerraImg) / 2 ,
      oriY = (terraImg:getHeight()*escalaTerraImg) / 2,
      vel = { valor = 200 }
  }
  --  Atributos da Terra --
  
  --  Atributos Lua --
  rachaduraSprite = 0
  escalaLuaImg = 0.097
  lua = {
    imagem = luaImg,
    posX = 0,
    posY = 0,
    raio = (luaImg:getWidth()*escalaLuaImg) / 2,
    distanciaTerra = { valor = 265 },
    oriX = (luaImg:getWidth()*escalaLuaImg) / 2,
    oriY = (luaImg:getHeight()*escalaLuaImg) / 2,
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
  resistenciaLunar = { valor = 16 } -- valor padrão que indica quantos meteoritos a Lua resiste colidir até ficar lenta
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
  distAtracaoGravLimite = 430
  tempoAtivoAtracaoGravLimite = 4 * 60
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
    vel = { valor = 45 },
    qtd = { valor = 0 }, -- possibilita passagem por referência --
    delay = { valor = 1.5 }, -- intervalo padrão de criação
    contagem = 1, -- variável de "cronometro" para uma nova criação
    dano = { valor = 1 },
    destruidos = 0,
    colisoes = 2,
    escala = { valor = 2 }
  }
  -- Variáveis dos Meteoroides --
  meteoroides = {}
  metricasMeteoroides = {
    id = 0,
    tipo = "normal",
    img = meteoroidesImgs.meteoroideImg,
    vel = { valor = 60 },
    qtd = { valor = 3 }, -- tabela possibilita passagem por referência --
    delay = { valor = 0.5 },
    contagem = 1,
    dano = { valor =  0.15 },
    destruidos = 0,
    escala = { valor = 1 }
  }
  -- Variáveis dos Detritos --
  detritos = {}
  metricasDetrito = {
    img = detritoImg,
    destruidos = 0,
    qtd = 3,
    vel = { valor = 50 }
  }
  
  potencializadores = {
    {
      titulo = "Velocidade Lunar", 
      descricao = "A Lua recebe um incremento de %d%% em sua velocidade, mas %d%% de Meteoroides extras aparecem.", 
      vantagem = 40, 
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
      titulo = "Reconstrução Emergencial", 
      descricao = "Pequenos reparos concedem %d%% da vida fundamental da Terra, isso afeta %d%% do tempo de recarga do Controle Gravitacional.", 
      vantagem = 10, 
      desvantagem = 5,
      alvoVantagem = vidasTerra,
      alvoDesvantagem = intervaloControleGravitacional,
      peso = 6
    },
    {
      titulo = "Recuperação Total", 
      descricao = "A Terra recebe toda da sua vida fundamental, como consequência a velocidade de inimigos aumenta em 10%%", 
      vantagem = 3000, 
      desvantagem = 10,
      alvoVantagem = vidasTerra,
      alvoDesvantagem = metricasMeteoroides.vel,
      peso = 1
    },
    {
      titulo = "Máquinas Aceleradas", 
      descricao = "As máquinas usadas na recuperação de impactos passam a trabalhar %d%% mais rápido aumentando a taxa de regeneração, mas a poluição gerada contribui para os danos causados por Meteoroides em %d%%.", 
      vantagem = 25, 
      desvantagem = 5,
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
      titulo = "Blindagem da Terra", 
      descricao = "Uma camada extra de proteção reduz %d%% dos dados causados por meteoroides, os esforços dedicados a sua construção afetam %d%% da taxa de recuperação de vida.", 
      vantagem = -15, 
      desvantagem = -4,
      alvoVantagem = metricasMeteoroides.dano,
      alvoDesvantagem = taxaRegeneracao,
      peso = 5
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
      vantagem = 20, 
      desvantagem = 5,
      alvoVantagem = distanciaAtracaoGravitacional,
      alvoDesvantagem = intervaloAtracaoGravitacional,
      peso = 1
    },
     {
      titulo = "Frenesi da Lua", 
      descricao = "A Lua fica muito agitada afetando sua gravidade que por consequência reduz %d%% do tempo de intervalo da habilidade Atração Gravitacional, no entanto a agitação reduz sua eficiência em %d%%.", 
      vantagem = -15, 
      desvantagem = -4,
      alvoVantagem = intervaloAtracaoGravitacional,
      alvoDesvantagem = resistenciaLunar,
      peso = 5
    },
     {
      titulo = "Mais Atrativo", 
      descricao = "A máquina de controle lunar recebe melhorias na duração da Atração Gravitacional que aumenta %d%%, isso atrai corpos celestes distantes reduzindo o intervalo com que aparecem em %d%%.", 
      vantagem = 18, 
      desvantagem = -5,
      alvoVantagem = duracaoAtracaoGravitacional,
      alvoDesvantagem = metricasMeteoroides.delay,
      peso = 3
    },
    {
      titulo = "Atração Veloz", 
      descricao = "A cada novo impacto a Lua absorve parte da energia, com isso a velocidade de Atração Gravitacional tem um ganho de %d%%, porém a duração do efeito é reduzida em %d%%.", 
      vantagem = 15, 
      desvantagem = -3,
      alvoVantagem = velAtracaoGravitacional,
      alvoDesvantagem = duracaoAtracaoGravitacional,
      peso = 6
    },
    {
      titulo = "Lua Guiada", 
      descricao = "O sistema de Controle Gravitacional é completamente refeito, com isso há ganho de %d%% na distância de atuação, como consequência o seu intervalo é aumentado em %d%%.", 
      vantagem = 35, 
      desvantagem = 5,
      alvoVantagem = distanciaControleGravitacional,
      alvoDesvantagem = intervaloControleGravitacional,
      peso = 1
    },
    {
    titulo = "Recarga Rápida", 
    descricao = "Otimizações no sistema de Controle Gravitacional reduzem o tempo de recarga da habilidade em %d%%, mas %d%% da sua velocidade também é reduzida.", 
    vantagem = -15, 
    desvantagem = -5,
    alvoVantagem = intervaloControleGravitacional,
    alvoDesvantagem = velControleGravitacional,
    peso = 3
    },
  }  
end

-- Função chamada toda troca de onda --
function resetaRodada()  
  -- Metricas Definidas de acordo com rodadas Fáceis, Médias e Difíceis --
  if onda <= 10 then
    metricasSupermeteoroides.qtd.valor = 1
    metricasMeteoroides.qtd.valor = 3 + onda
    percentualAumentoMetricas = 1
  elseif onda <= 20 then
    metricasSupermeteoroides.qtd.valor = 2 
    metricasMeteoroides.qtd.valor = round(1.2 * onda)
    percentualAumentoMetricas = 1 + (2/100)
  else
    metricasSupermeteoroides.qtd.valor = 3
    metricasMeteoroides.qtd.valor = round(2 * onda)
    percentualAumentoMetricas = 1 + (5/100)
  end
  
  -- caso seja 2 jogadores uma dificuldade a mais
  if startGame == 2 and onda >= 11 then
    percentualAumentoMetricas = percentualAumentoMetricas + (1/100)
  end
    
  taxaRegeneracao.valor = taxaRegeneracao.valor * percentualAumentoMetricas
  
  velocidadeOrbita.valor = velocidadeOrbita.valor * percentualAumentoMetricas
  resistenciaLunar.valor = resistenciaLunar.valor * percentualAumentoMetricas
  taxaReducaoEficienciaLunar.valor = taxaReducaoEficienciaLunar.valor * percentualAumentoMetricas -- nerf
  tempoLentidaoLunar.valor = tempoLentidaoLunar.valor * percentualAumentoMetricas -- nerf
  taxaReducaoTempoLentidaoLunar.valor = taxaReducaoTempoLentidaoLunar.valor * percentualAumentoMetricas
  efeitoLentidao.valor = efeitoLentidao.valor * percentualAumentoMetricas -- nerf
  
  duracaoAtracaoGravitacional.valor = duracaoAtracaoGravitacional.valor * percentualAumentoMetricas
  distanciaAtracaoGravitacional.valor = distanciaAtracaoGravitacional.valor * percentualAumentoMetricas
  velAtracaoGravitacional.valor = velAtracaoGravitacional.valor * percentualAumentoMetricas
  
  velControleGravitacional.valor = velControleGravitacional.valor * percentualAumentoMetricas
  distanciaControleGravitacional.valor = distanciaControleGravitacional.valor
  
  metricasMeteoroides.vel.valor = metricasMeteoroides.vel.valor  * percentualAumentoMetricas
  metricasMeteoroides.dano.valor = metricasMeteoroides.dano.valor * percentualAumentoMetricas
  metricasSupermeteoroides.vel.valor = metricasSupermeteoroides.vel.valor * percentualAumentoMetricas
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
  -- Carregamento das variáveis da Animação  
end

function alterarVolume()
  musicaIntroducao:setVolume(volumeGeral)
  somColisao:setVolume(volumeGeral)
  musicaMenu:setVolume(volumeGeral)
  musicaIniciais:setVolume(volumeGeral)
  musicaIntermediarios:setVolume(volumeGeral)
  musicaFinais:setVolume(volumeGeral)
end

function round(n)
  return math.floor(n + 0.5)
end

function carregamentoEstrelas()
  estrelasBrilhantes = {}
  for i = 1, 25, 1 do
    table.insert(estrelasBrilhantes, {x = math.random(10, screenWidth), y = math.random(10, screenHeight), brilhoMax = math.random(100, 245), brilhoAtual = 0, estado = 'acendendo', rotacao = math.random(0, 360)})
  end
  
  estrelaCadente = {x = math.random(200, screenWidth - 200), y = math.random(50, screenHeight - 50), brilhoMax = math.random(100, 245)}
  if estrelaCadente.x > screenWidth / 2 then
    estrelaCadente.direcao = 'left'
  else
    estrelaCadente.direcao = 'right'
  end
  
end