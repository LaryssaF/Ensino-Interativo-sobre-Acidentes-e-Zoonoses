local composer = require("composer") 
local scene = composer.newScene()

-- Variáveis de controle do som
local somLigado = false
local somChannel
local somPage01

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo inicial da página (Contracapa)
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/Contracapa.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/off.png", 20, 20)
    button.x = 30
    button.y = 40

    -- Botão "Info"
    local imgInfo = display.newImageRect(sceneGroup, "assets/images/Info.png", 25, 25)
    imgInfo.x = 260
    imgInfo.y = 390

    -- Botão para ir para a próxima página
    local Proxima = display.newImageRect(sceneGroup, "assets/images/inicio.png", 90, 30)
    Proxima.x = 260
    Proxima.y = 440

    -- Adiciona listener para o botão "Proxima"
    Proxima:addEventListener("tap", function()
        composer.gotoScene("Capa", { effect = "fromRight", time = 1000 })
    end)

    -- Botão para voltar à página anterior
    local Anterior = display.newImageRect(sceneGroup, "assets/images/anterior.png", 90, 30)
    Anterior.x = 60
    Anterior.y = 440

    -- Adiciona listener para o botão "Anterior"
    Anterior:addEventListener("tap", function()
        composer.gotoScene("Page07", { effect = "fromLeft", time = 1000 })
    end)

    local somPage01 = audio.loadSound("assets/audios/contracapa.mp3")  -- Som para Page04

    local function toggleSound()
        if somLigado then
            somLigado = false
            button.fill = { type = "image", filename = "assets/images/off.png" }
            if somChannel then
                audio.pause(somChannel)
            end
        else
            somLigado = true
            button.fill = { type = "image", filename = "assets/images/on.png" }
            somChannel = audio.play(somPage01, { loops = -1 }) -- Reproduz o som 
        end
    end

    -- Adiciona listener de som
    button:addEventListener("tap", toggleSound)

    -- Função para retornar ao estado inicial (Contracapa)
    local function returnToCover()
        imgCapa.fill = { type = "image", filename = "assets/images/Contracapa.png" } -- Retorna ao fundo inicial
        button.isVisible = true -- Mostra botão de som
        imgInfo.isVisible = true -- Mostra botão Info
        imgX.isVisible = false -- Esconde botão "X"
    end

    -- Função para mudar o fundo ao clicar em "Info"
    local function changeBackground()
        imgCapa.fill = { type = "image", filename = "assets/images/pop.png" } -- Altera a imagem do fundo
        button.isVisible = false -- Esconde botão de som
        imgInfo.isVisible = false -- Esconde botão Info

        -- Cria botão "X" para retornar ao estado inicial
        imgX = display.newImageRect(sceneGroup, "assets/images/x.png", 25, 25)
        imgX.x = 290
        imgX.y = 165
        imgX:addEventListener("tap", returnToCover)
    end

    -- Adiciona listener para o botão "Info"
    imgInfo:addEventListener("tap", changeBackground)
end

-- show()
function scene:show(event)
    local phase = event.phase

    if (phase == "did") then
        if somLigado then
            somChannel = audio.play(somPage01, { loops = -1 })
        end
    end
end

-- hide()
function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        if somChannel then
            audio.stop(somChannel)
            somChannel = nil
        end
        somLigado = false
        if button then
            button.fill = { type = "image", filename = "assets/images/off.png" }
        end
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    if somChannel then
        audio.dispose(somChannel)
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
