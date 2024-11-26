local composer = require("composer")
local scene = composer.newScene()

-- Variáveis de controle do som
local somLigado = false
local somChannel
local somPage01
local somPageNew

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo da página (Page04)
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/Page04.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/off.png", 20, 20)
    button.x = 30
    button.y = 40

    -- Botão para ir para a próxima página
    local Proxima = display.newImageRect(sceneGroup, "assets/images/proxima.png", 90, 30)
    Proxima.x = 260
    Proxima.y = 440

    -- Adiciona listener para o botão "Proxima"
    Proxima:addEventListener("tap", function()
        composer.gotoScene("Page05", { effect = "fromRight", time = 1000 })
    end)

    -- Botão para voltar à página anterior
    local Anterior = display.newImageRect(sceneGroup, "assets/images/anterior.png", 90, 30)
    Anterior.x = 60
    Anterior.y = 440

    -- Adiciona listener para o botão "Anterior"
    Anterior:addEventListener("tap", function()
        composer.gotoScene("Page03", { effect = "fromLeft", time = 1000 })
    end)

    -- Adicionar as aranhas
    local aranha1 = display.newImageRect(sceneGroup, "assets/images/aranha.png", 50, 50)
    aranha1.x = display.contentCenterX - 100 
    aranha1.y = display.contentCenterY 

    local aranha2 = display.newImageRect(sceneGroup, "assets/images/aranha.png", 50, 50) 
    aranha2.x = display.contentCenterX + 100 
    aranha2.y = display.contentCenterY 

    somPage01 = audio.loadSound("assets/audios/page04.mp3")
    somPageNew = audio.loadSound("assets/audios/page004.mp3") -- Som da nova página

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
            somChannel = audio.play(somPage01, { loops = -1 })
        end
    end

    button:addEventListener("tap", toggleSound)

    -- Variáveis para verificar os toques
    local aranha1Touched = false
    local aranha2Touched = false

    -- Função de verificação de toques simultâneos
    local function onTouch(event)
        if event.phase == "began" then
            -- Verifica se a aranha 1 foi tocada
            if event.target == aranha1 then
                aranha1Touched = true
            end
            -- Verifica se a aranha 2 foi tocada
            if event.target == aranha2 then
                aranha2Touched = true
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            -- Reseta o toque quando o usuário tira o dedo
            if event.target == aranha1 then
                aranha1Touched = false
            end
            if event.target == aranha2 then
                aranha2Touched = false
            end
        end

        -- Se ambas as aranhas foram tocadas simultaneamente
        if aranha1Touched and aranha2Touched then
            -- As aranhas desaparecem
            aranha1:removeSelf()
            aranha2:removeSelf()

            -- Muda o fundo
            imgCapa.fill = { type = "image", filename = "assets/images/Page004.png" }

            -- O áudio da Page004 estará desligado por padrão
            if somChannel then
                audio.stop(somChannel) -- Para o áudio de Page04
            end
        end

        return true
    end

    -- Adiciona os listeners de toque nas aranhas
    aranha1:addEventListener("touch", onTouch)
    aranha2:addEventListener("touch", onTouch)
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
