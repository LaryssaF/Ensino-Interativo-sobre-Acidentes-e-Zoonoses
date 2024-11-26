local composer = require("composer")

local scene = composer.newScene()

-- Criação do som e da variável para controlar o som globalmente
local somCapa
local somChannel
local somLigado = false

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem da Capa
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/capa.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Botão para ir para a Page01
    local Avancar = display.newImageRect(sceneGroup, "assets/images/proxima1.png", 141, 50)
    Avancar.x = 160
    Avancar.y = 400 

    -- Adiciona um listener para o botão Avancar
    Avancar:addEventListener('tap', function()
        composer.gotoScene("Page01", {effect = "fromRight", time = 1000})
    end)

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/off.png", 20, 20)  
    button.x = 30
    button.y = 40  

    -- Carrega o som da capa (apenas uma vez)
    if not somCapa then
        somCapa = audio.loadSound("assets/audios/capa.mp3")
    end

    -- Função para ligar e desligar o som
    local function toggleSound()
        if somLigado then
            -- Desliga o som
            somLigado = false
            button.fill = { type="image", filename="assets/images/off.png" }  -- Muda a imagem para som desligado
            if somChannel then
                audio.pause(somChannel)
            end
        else
            -- Liga o som
            somLigado = true
            button.fill = { type="image", filename="assets/images/on.png" }  -- Muda a imagem para som ligado
            somChannel = audio.play(somCapa, { loops = -1 })  -- Toca em loop
        end
    end
    button:addEventListener("tap", toggleSound)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Pause o som quando a cena for ocultada
        if somChannel then
            audio.pause(somChannel)
        end
    elseif (phase == "did") then
        -- Inicia o som se estiver ligado após a transição da cena
        if somLigado then
            somChannel = audio.play(somCapa, { loops = -1 })
        end
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
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
    local sceneGroup = self.view
    -- Libera o som se necessário
    if somChannel then
        audio.dispose(somChannel)
    end
    if somCapa then
        audio.dispose(somCapa)
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
