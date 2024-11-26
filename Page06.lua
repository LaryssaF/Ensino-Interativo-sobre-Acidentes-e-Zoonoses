local composer = require("composer")
local scene = composer.newScene()

-- Variáveis de controle do som
local somLigado = false
local somChannel
local somPage01
local somPageNew

function scene:create(event)
    local sceneGroup = self.view

    -- Fundo da página (Page06)
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/Page06.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY
    imgCapa.currentPage = "Page06" -- Propriedade para rastrear a página atual

    -- Raquete
    local raquete = display.newImageRect(sceneGroup, "assets/images/raquete.png", 250, 250)
    raquete.x = 100
    raquete.y = 300

    -- Mosquito
    local mosquito = display.newImageRect(sceneGroup, "assets/images/mosquito.png", 50, 50)
    mosquito.x = 240
    mosquito.y = 340

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/off.png", 20, 20)
    button.x = 30
    button.y = 40

    somPage01 = audio.loadSound("assets/audios/page03.mp3")
    somPageNew = audio.loadSound("assets/audios/page003.mp3") -- Som da nova página

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


    -- Função de shake para mudar a imagem e o áudio
    local function onShake(event)
        if math.abs(event.xGravity) > 0.5 or math.abs(event.yGravity) > 0.5 or math.abs(event.zGravity) > 0.5 then
            -- Troca a imagem de fundo
            imgCapa.fill = { type = "image", filename = "assets/images/Page006.png" }
            imgCapa.currentPage = "Page006" -- Atualiza a página atual

            -- Remove raquete e mosquito
            raquete:removeSelf()
            mosquito:removeSelf()

            -- Desliga o som
            if somLigado and somChannel then
                audio.stop(somChannel)
            end
            somLigado = false
            button.fill = { type = "image", filename = "assets/images/off.png" }

            -- Remove o listener de shake
            Runtime:removeEventListener("accelerometer", onShake)
        end
    end

    -- Ativa o acelerômetro
    system.activate("accelerometer")

    -- Adiciona o listener de acelerômetro
    Runtime:addEventListener("accelerometer", onShake)

    -- Botões de navegação
    local Proxima = display.newImageRect(sceneGroup, "assets/images/proxima.png", 90, 30)
    Proxima.x = 260
    Proxima.y = 440
    Proxima:addEventListener("tap", function()
        composer.gotoScene("Page07", { effect = "fromRight", time = 1000 })
    end)

    local Anterior = display.newImageRect(sceneGroup, "assets/images/anterior.png", 90, 30)
    Anterior.x = 60
    Anterior.y = 440
    Anterior:addEventListener("tap", function()
        composer.gotoScene("Page05", { effect = "fromLeft", time = 1000 })
    end)
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

function scene:destroy(event)
    local sceneGroup = self.view
    if somChannel then
        audio.dispose(somChannel)
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
