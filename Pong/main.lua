push = require 'push' --lib
Class = require 'class'
require 'Paddle'
require 'Ball'

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
    --love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')
    math.randomseed(os.time())
    --smallFont = love.graphics.newFont('font.ttf', 8)
    --love.graphics.setFont(smallFont)

    sounds = {
        ['menu_move'] = love.audio.newSource('sounds/menu_move.wav', 'static'),
        ['menu_slct'] = love.audio.newSource('sounds/menu_slct.wav', 'static'),
        ['paddle_hit'] = love.audio.newSource('sounds/pad_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }


    --setup window with push, converts the window res to virtual res, test with higher virtual size
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDHT, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = false --[[test]]
    })

    scorePlayer1 = 0
    scorePlayer2 = 0
    --put score in player class
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    --place ball in the middle of screen
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    --arrowPos
    points = { VIRTUAL_WIDTH / 2 - 50, 112, VIRTUAL_WIDTH / 2 - 50, 102, VIRTUAL_WIDTH/ 2 - 30 , 107 } 
    menuOp = 0



    gameState = 'menu'
end

function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)

        if servingPlayer == 1 then
            ball.dx = math.random(190, 200)
        else 
            ball.dx = -math.random(190, 200)
        end
    elseif gameState == 'play' then
        if ball:collides(player1) then
            sounds.paddle_hit:play()
            ball.dx = -ball.dx * 1.1
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
        end
        
        if ball:collides(player2) then
            sounds.paddle_hit:play()
            ball.dx = -ball.dx * 1.1
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
        end

        --detect lower bound collision
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end
    elseif gameState == 'menu' then
        
    end

    --Keeping track of score
    if ball.x < 0 then 
        sounds.score:play()
        servingPlayer = 1
        scorePlayer2 = scorePlayer2 + 1
        ball:reset()
        gameState = 'serve'
    end

    if ball.x > VIRTUAL_WIDTH then
        sounds.score:play()
        servingPlayer = 2
        scorePlayer1 = scorePlayer1 + 1
        ball:reset()
        gameState = 'serve'
    end
    
    --Player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    --Player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else 
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end


    player1:update(dt)
    player2:update(dt)
end 

function love.keypressed(key)
    if key == 'escape' then
        if(gameState == 'menu') then
            love.event.quit()
        else 
            love.event.quit()
        end
    elseif key == 'enter' or key == 'return' then
        sounds.menu_slct:play()
        if gameState == 'start' or gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'menu' then
            if menuOp == 0 then
                gameState = 'start'
            elseif menuOp == 1 then
                gameState = 'options'
            else
                love.event.quit()
            end
        else    
            gameState = 'start'
            ball:reset()
        end

    elseif key == 'up' then
        if gameState == 'menu' then
            sounds.menu_move:play()
            if menuOp ~=0 then
                menuOp = menuOp - 1
                for key, value in ipairs( points ) do
                    if key % 2 == 0 then
                        points[key] = points[key] - 15
                    end
                end
            else 
                menuOp = 2
                for key, value in ipairs( points ) do
                    if key % 2 == 0 then
                        points[key] = points[key] + 30 --reset
                    end
                end
            end
        end

    elseif key == 'down' then
        if gameState == 'menu' then
            sounds.menu_move:play()
            if menuOp ~= 2 then
                menuOp = menuOp + 1
                for key, value in ipairs( points ) do
                    if key % 2 == 0 then
                        points[key] = points[key] + 15
                    end
                end
            else
                menuOp = 0
                for key, value in ipairs( points ) do
                    if key % 2 == 0 then
                        points[key] = points[key] - 30 --reset
                    end
                end
            end
        end
    end
end

function love.draw()
    push:apply('start')         --whatever between start and end gets out with virtual res
    --love.graphics.clear(40, 45, 52, 255)
    love.graphics.printf(   
            'Pong',                 --text to render
            0,                      --STARTING X
            20,                     --STARTING Y (-6 because font is 12px tall)
            VIRTUAL_WIDTH,          --n of pixel to center within
            'center'                --alignment mode (center,left,right)
    )
    if(gameState == 'start' or gameState == 'play' or gameState == 'serve') then               
        love.graphics.print(tostring(scorePlayer1), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT/3)
        love.graphics.print(tostring(scorePlayer2), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/3)
        player1:render()
        player2:render()
        ball:render()

        displayFPS()
    elseif gameState == 'menu' then
        startMenu() 
    else
        optionsMenu()
    end
    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function startMenu()
    if (gameState == 'menu') then
        push:apply('start')
        love.graphics.polygon('fill', points)

        --arrowPos needs to be stored somewhere, 3 points because of triangle
        --love.graphics.clear(40, 45, 52, 255)   
        --test
        --add diff font for menu options       
        --add triangle to indicate menu option hovered   
        love.graphics.printf(
            'Start',
            0,
            100,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.printf(
            'Options',
            0,
            115,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.printf(
            'Exit',
            0,
            130,
            VIRTUAL_WIDTH,
            'center'
        )
        push:apply('end')
    end
end

function optionsMenu()
    push:apply('start')
    love.graphics.printf(
        'Options',
        0,
        100,
        VIRTUAL_WIDTH,
        'center'
    )
    push:apply('end')
end