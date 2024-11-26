local composer = require("composer")
local scene = composer.newScene()

-- Variáveis para o som e controle global
local somChannel
local somLigado = false  -- Começa com o som desligado
local somPage01 = audio.loadSound("assets/audios/page01.mp3")
local somPage001 = audio.loadSound("assets/audios/page001.mp3")

-- Variáveis do fundo e do som atual
local currentBackground = "assets/images/Page01.png"
local currentAudio = somPage01

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Variável para armazenar a referência ao fundo
    local imgFundo

    -- Carrega o fundo inicial (Page01)
    imgFundo = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    imgFundo.fill = { type = "image", filename = currentBackground }

    -- Função para alternar o fundo e o áudio
    local function toggleBackground()
        if currentBackground == "assets/images/Page01.png" then
            currentBackground = "assets/images/Page001.png"
            currentAudio = somPage001 -- Atualiza para o som do Page001
        else
            currentBackground = "assets/images/Page01.png"
            currentAudio = somPage01 -- Atualiza para o som do Page01
        end

        -- Atualiza a textura do fundo
        imgFundo.fill = { type = "image", filename = currentBackground }

        -- Atualiza o som se estiver ligado
        if somLigado then
            audio.stop(somChannel) -- Para o som atual
            somChannel = audio.play(currentAudio, { loops = -1 }) -- Toca o novo som
        end
    end

    -- Botão "Info"
    local imgI = display.newImageRect(sceneGroup, "assets/images/Info.png", 25, 25)
    imgI.x = 40
    imgI.y = 380

    -- Adiciona listener para alternar o fundo
    imgI:addEventListener("tap", toggleBackground)

    -- Botão para ir para a próxima página (Page02)
    local Proxima = display.newImageRect(sceneGroup, "assets/images/proxima.png", 90, 30)
    Proxima.x = 260
    Proxima.y = 440

    -- Adiciona listener para o botão "Proxima"
    Proxima:addEventListener("tap", function()
        composer.gotoScene("Page02", { effect = "fromRight", time = 1000 })
    end)

    -- Botão para voltar à página anterior (Capa)
    local Anterior = display.newImageRect(sceneGroup, "assets/images/anterior.png", 90, 30)
    Anterior.x = 60
    Anterior.y = 440

    -- Adiciona listener para o botão "Anterior"
    Anterior:addEventListener("tap", function()
        composer.gotoScene("Capa", { effect = "fromLeft", time = 1000 })
    end)

    -- Variável para o botão de som
    local button

    -- Função para ligar e desligar o som
    local function toggleSound()
        if somLigado then
            somLigado = false
            button.fill = { type = "image", filename = "assets/images/off.png" }
            if somChannel then
                audio.pause(somChannel) -- Pausa o som atual
            end
        else
            somLigado = true
            button.fill = { type = "image", filename = "assets/images/on.png" }
            somChannel = audio.play(currentAudio, { loops = -1 }) -- Toca o som do fundo atual
        end
    end

    -- Criação do botão para ligar e desligar o som
    button = display.newImageRect(sceneGroup, "assets/images/off.png", 20, 20)
    button.x = 30
    button.y = 40
    button:addEventListener("tap", toggleSound)
end

-- show()
function scene:show(event)
    local phase = event.phase

    if (phase == "did") then
        -- Inicia o som se estiver ligado após a transição da cena
        if somLigado then
            somChannel = audio.play(currentAudio, { loops = -1 })
        end
    end
end

-- hide()
function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        -- Pausa o som antes de a cena ser removida
        if somChannel then
            audio.pause(somChannel)
        end
    elseif (phase == "did") then
        -- Não é necessário fazer nada aqui
    end
end

-- destroy()
function scene:destroy(event)
    -- Libera os recursos de áudio
    if somChannel then
        audio.dispose(somChannel)
    end
    if somPage01 then
        audio.dispose(somPage01)
    end
    if somPage001 then
        audio.dispose(somPage001)
    end
end

-- Scene event function listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
