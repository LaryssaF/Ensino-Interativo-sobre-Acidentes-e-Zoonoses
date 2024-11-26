local composer = require("composer")
local scene = composer.newScene()

-- Variáveis de controle do som
local somLigado = false
local somChannel
local somPage01

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo da página (Page05)
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/Page05.png", display.contentWidth, display.contentHeight)
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
        composer.gotoScene("Page06", { effect = "fromRight", time = 1000 })
    end)

    -- Botão para voltar à página anterior
    local Anterior = display.newImageRect(sceneGroup, "assets/images/anterior.png", 90, 30)
    Anterior.x = 60
    Anterior.y = 440

    -- Adiciona listener para o botão "Anterior"
    Anterior:addEventListener("tap", function()
        composer.gotoScene("Page04", { effect = "fromLeft", time = 1000 })
    end)

    local somPage05 = audio.loadSound("assets/audios/page05.mp3")  

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
            somChannel = audio.play(somPage05, { loops = -1 }) -- Toca o som da página com loop
        end
    end

    -- Adiciona listener de som
    button:addEventListener("tap", toggleSound)

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
