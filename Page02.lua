local composer = require("composer")
local scene = composer.newScene()

-- Variáveis para controle de som
local somLigado = false
local somChannel
local currentAudio
local somPage01 = audio.loadSound("assets/audios/page02.mp3")
local somPage02 = audio.loadSound("assets/audios/page002.mp3")

local button -- Botão para controle de som

-- Função para ligar e desligar o som
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
        somChannel = audio.play(currentAudio, { loops = -1 })
    end
end

function scene:create(event)
    local sceneGroup = self.view

    -- Fundo da página
    local imgFundo = display.newImageRect(sceneGroup, "assets/images/Page02.png", display.contentWidth, display.contentHeight)
    imgFundo.x = display.contentCenterX
    imgFundo.y = display.contentCenterY

    -- Define o áudio inicial
    currentAudio = somPage01

    -- Botão para ir para a próxima página
    local Proxima = display.newImageRect(sceneGroup, "assets/images/proxima.png", 90, 30)
    Proxima.x = 260
    Proxima.y = 440
    Proxima:addEventListener("tap", function()
        composer.gotoScene("Page03", { effect = "fromRight", time = 1000 })
    end)

    -- Botão para voltar à página anterior
    local Anterior = display.newImageRect(sceneGroup, "assets/images/anterior.png", 90, 30)
    Anterior.x = 60
    Anterior.y = 440
    Anterior:addEventListener("tap", function()
        composer.gotoScene("Page01", { effect = "fromLeft", time = 1000 })
    end)

    -- Escorpião e Copo
    local escorpiao = display.newImageRect(sceneGroup, "assets/images/escorpiao.png", 190, 190)
    escorpiao.x = 170
    escorpiao.y = 380

    local copo = display.newImageRect(sceneGroup, "assets/images/copo.png", 150, 160)
    copo.x = 170
    copo.y = 220

    -- Botão para controle de som
    button = display.newImageRect(sceneGroup, "assets/images/off.png", 20, 20)
    button.x = 30
    button.y = 40
    button:addEventListener("tap", toggleSound)

    -- Função para o clique no copo
    local function onCopoClick(event)
        transition.to(copo, {
            y = escorpiao.y + 100,
            time = 500,
            transition = easing.outQuad,
            onComplete = function()
                escorpiao:removeSelf()
                copo.x = escorpiao.x
                copo.y = escorpiao.y
                imgFundo.fill = { type = "image", filename = "assets/images/Page002.png" }
                currentAudio = somPage02
                if somLigado then
                    audio.stop(somChannel)
                    somChannel = audio.play(currentAudio, { loops = -1 })
                end
                copo:removeSelf()
                copo = nil
            end
        })
    end
    copo:addEventListener("tap", onCopoClick)
end

function scene:show(event)
    local phase = event.phase
    if phase == "did" and somLigado then
        somChannel = audio.play(currentAudio, { loops = -1 })
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
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

function scene:destroy(event)
    if somPage01 then audio.dispose(somPage01) end
    if somPage02 then audio.dispose(somPage02) end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
