push = require 'push' --lib

WINDOW_WIDHT = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
--[[
    Starts the game, runs only once
]]
function love.load()
    --uncomment to test stuff
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    --smallFont = love.graphics.newFont('font.ttf', 8)
    --love.graphics.setFont(smallFont)
    --setup window with push, converts the window res to virtual res, test with higher virtual size
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDHT, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = false --[[test]]
    })

    scorePlayer1 = 0
    scorePlayer2 = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState = 'start'
end

function love.update(dt)
    --Player 1 movement
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + (PADDLE_SPEED * -1) * dt) --cannot pass end of screen
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20 , player1Y + PADDLE_SPEED * dt)
    end

    --Player 2 movement
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + (PADDLE_SPEED * -1) * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end 

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

function love.draw()
    push:apply('start')         --whatever between start and end gets out with virtual res
    --love.graphics.clear(40, 45, 52, 255)
    love.graphics.printf(   
        'Pong',              --text to render
        0,                      --STARTING X
        20,  --STARTING Y (-6 because font is 12px tall)
        VIRTUAL_WIDTH,           --n of pixel to center within
        'center')               --alignment mode (center,left,right)
    love.graphics.print(tostring(scorePlayer1), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(scorePlayer2), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/3)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    push:apply('end')
end