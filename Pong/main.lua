push = require 'push' --lib

WINDOW_WIDHT = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
--[[
    Inicializa o jogo, só roda uma vez
]]
function love.load()
    --uncomment to test stuff
    love.graphics.setDefaultFilter('nearest', 'nearest')
    --setup window with push, converts the window res to virtual res, test with higher virtual size
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDHT, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = true --[[test = false later]]
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')         --whatever between start and end gets out with virtual res
    love.graphics.printf(   
        'Pong 2D',              --text to render
        0,                      --STARTING X
        VIRTUAL_HEIGHT / 2 - 6,  --STARTING Y (-6 because font is 12px tall)
        VIRTUAL_WIDTH,           --n of pixel to center within
        'center')               --alignment mode (center,left,right)
    push:apply('end')
end