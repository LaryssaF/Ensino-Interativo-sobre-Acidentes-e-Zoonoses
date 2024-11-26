local composer = require("composer")
local scene = composer.newScene()

-- Variáveis para controle de som
local somLigado = false
local somChannel
local currentAudio
local somPage01 = audio.loadSound("assets/audios/page03.mp3")
local somPage02 = audio.loadSound("assets/audios/page003.mp3")

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

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo da página
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/Page03.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Define o áudio inicial
    currentAudio = somPage01

    -- Botão para ligar e desligar o som
    button = display.newImageRect(sceneGroup, "assets/images/off.png", 20, 20)
    button.x = 30
    button.y = 40
    button:addEventListener("tap", toggleSound)

    -- Botão para ir para a próxima página
    local Proxima = display.newImageRect(sceneGroup, "assets/images/proxima.png", 90, 30)
    Proxima.x = 260
    Proxima.y = 440

    -- Adiciona listener para o botão "Proxima"
    Proxima:addEventListener("tap", function()
        composer.gotoScene("Page04", { effect = "fromRight", time = 1000 })
    end)

    -- Botão para voltar à página anterior
    local Anterior = display.newImageRect(sceneGroup, "assets/images/anterior.png", 90, 30)
    Anterior.x = 60
    Anterior.y = 440

    -- Adiciona listener para o botão "Anterior"
    Anterior:addEventListener("tap", function()
        composer.gotoScene("Page02", { effect = "fromLeft", time = 1000 })
    end)

    -- Adicionando imagens extras
    local homem = display.newImageRect(sceneGroup, "assets/images/homem.png", 55, 55)
    homem.x = 77
    homem.y = 200

    local luvas = display.newImageRect(sceneGroup, "assets/images/luvas.png", 50, 50)
    luvas.x = 240
    luvas.y = 200

    local botas = display.newImageRect(sceneGroup, "assets/images/botas.png", 50, 50)
    botas.x = 240
    botas.y = 340

    local rede = display.newImageRect(sceneGroup, "assets/images/rede.png", 55, 55)
    rede.x = 160
    rede.y = 280

    local cobra = display.newImageRect(sceneGroup, "assets/images/cobra.png", 55, 55)
    cobra.x = 68
    cobra.y = 340

    -- Função para mover o homem
    local function moveHomem(event)
        if event.phase == "began" then
            display.currentStage:setFocus(homem)
            homem.isFocus = true
            homem.x0 = event.x - homem.x
            homem.y0 = event.y - homem.y
        elseif homem.isFocus then
            if event.phase == "moved" then
                homem.x = event.x - homem.x0
                homem.y = event.y - homem.y0
            elseif event.phase == "ended" or event.phase == "cancelled" then
                display.currentStage:setFocus(nil)
                homem.isFocus = false
            end
        end
        return true
    end

    -- Adiciona o listener de movimentação ao homem
    homem:addEventListener("touch", moveHomem)

    local function verificarColisao()
        -- Verifica colisão com a rede
        if rede and math.abs(homem.x - rede.x) < 30 and math.abs(homem.y - rede.y) < 30 then
            rede:removeSelf()
            rede = nil
        end
        -- Verifica colisão com as luvas
        if luvas and math.abs(homem.x - luvas.x) < 30 and math.abs(homem.y - luvas.y) < 30 then
            luvas:removeSelf()
            luvas = nil
        end
        -- Verifica colisão com as botas
        if botas and math.abs(homem.x - botas.x) < 30 and math.abs(homem.y - botas.y) < 30 then
            botas:removeSelf()
            botas = nil
        end
        -- Verifica colisão com a cobra
        if cobra and math.abs(homem.x - cobra.x) < 30 and math.abs(homem.y - cobra.y) < 30 then
            cobra:removeSelf()
            cobra = nil

            -- Troca o fundo
            imgCapa:removeSelf()
            imgCapa = display.newImageRect(sceneGroup, "assets/images/Page003.png", display.contentWidth, display.contentHeight)
            imgCapa.x = display.contentCenterX
            imgCapa.y = display.contentCenterY

            -- Atualiza o áudio para o som da nova página
            currentAudio = somPage02

            -- Reinicia o áudio se estiver ligado
            if somChannel then
                audio.stop(somChannel)
            end
            if somLigado then
                somChannel = audio.play(currentAudio, { loops = -1 })
            end
            --Readiciona os botões ao grupo da cena
            sceneGroup:insert(button)
            sceneGroup:insert(Proxima)
            sceneGroup:insert(Anterior)
        end
    end

    -- Listener de colisão
    Runtime:addEventListener("enterFrame", verificarColisao)
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
