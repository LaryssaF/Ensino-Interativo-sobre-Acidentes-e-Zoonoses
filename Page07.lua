local composer = require("composer")
local scene = composer.newScene()

-- Variáveis globais para som
local somLigado = false
local somChannel
local somPage07

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo da página (Page07)
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/Page07.png", display.contentWidth, display.contentHeight)
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
        composer.gotoScene("Contracapa", { effect = "fromRight", time = 1000 })
    end)

    -- Botão para voltar à página anterior
    local Anterior = display.newImageRect(sceneGroup, "assets/images/anterior.png", 90, 30)
    Anterior.x = 60
    Anterior.y = 440

    -- Adiciona listener para o botão "Anterior"
    Anterior:addEventListener("tap", function()
        composer.gotoScene("Page06", { effect = "fromLeft", time = 1000 })
    end)

    -- Carrega o som da página
    somPage07 = audio.loadSound("assets/audios/page07.mp3")

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
            somChannel = audio.play(somPage07, { loops = -1 })
        end
    end

    -- Adiciona listener ao botão de som
    button:addEventListener("tap", toggleSound)

    -- Adiciona imagem de morcego
    local morcego = display.newImageRect(sceneGroup, "assets/images/morcegos.png", 50, 50)
    morcego.x = 50
    morcego.y = 250

    -- Adiciona imagem de cachorro
    local cachorro = display.newImageRect(sceneGroup, "assets/images/cachorro1.png", 100, 100)
    cachorro.x = 80
    cachorro.y = 350

    -- Função para o morcego picar o cachorro e desaparecer
    local function morcegoPicaCachorro()
        transition.to(morcego, {
            time = 500,
            x = cachorro.x,
            y = cachorro.y,
            onComplete = function()
                morcego:removeSelf()
                morcego = nil
                cachorro:removeSelf()
                cachorro = display.newImageRect(sceneGroup, "assets/images/cachorro2.png", 100, 100)
                cachorro.x = 80
                cachorro.y = 350

                -- Inicia movimento contínuo
                local function cachorroMove()
                    transition.to(cachorro, {
                        time = 1000,
                        x = display.contentWidth - 100,
                        onComplete = function()
                            cachorro.xScale = -1
                            transition.to(cachorro, {
                                time = 1000,
                                x = 80,
                                onComplete = function()
                                    cachorro.xScale = 1
                                    cachorroMove()
                                end
                            })
                        end
                    })
                end
                cachorroMove()
            end
        })
    end

    -- Listener para o morcego
    morcego:addEventListener("tap", morcegoPicaCachorro)
end

-- show()
function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        -- Reinicia o som ao entrar na cena se o som estava ligado
        if somLigado then
            somChannel = audio.play(somPage07, { loops = -1 })
        end
    end
end

-- hide()
function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
        -- Para o som ao sair da cena
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
    -- Libera o som carregado
    if somPage07 then
        audio.dispose(somPage07)
        somPage07 = nil
    end
end

-- Listeners para eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
