function love.load()
    target = {}    
    target.radius = 50
    target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
    score = 0
    offTarget = 0
    timer = 0
    gameState = 1 --1 in menu, 2 in game, 3 end game
    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    love.mouse.setVisible(false)
end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end 

    if timer < 0 then
       timer = 0    
       gameState = 3   
    end
end

function love.draw()

    love.graphics.draw(sprites.sky,0,0)

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(gameFont)
    love.graphics.print("On target " .. score, 5, 5)
    love.graphics.print("Off target " .. offTarget,5,40)
    love.graphics.print("Time " .. math.ceil(timer),5,80)
    
    
    if gameState == 1 then
        love.graphics.printf("Left click to start the game!", 0, 250, love.graphics.getWidth(), "center")
    elseif gameState == 3 and timer == 0 then
        love.graphics.printf("Your score is ".. score , 0, 250, love.graphics.getWidth(), "center")
    end
        if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x,y,button,istouch, presses)
    if (button == 1 or button == 2) and gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            if button == 1 then
                score = score + 1
            elseif button == 2 then            
                score = score + 2
                timer = timer - 1
            end
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        else
            if(score > 0) then
                score = score - 1
            end
            offTarget = offTarget + 1
        end
    elseif button == 1 and gameState == 1 or gameState == 3 then
        storeScore(score, offTarget)
        gameState = 2
        timer = 10
        score = 0
        offTarget = 0
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 -x1)^2 + (y2 - y1)^2)
end

function storeScore(oT, offT)
            -- Store record
            local storedScores = io.open("data.txt", "a")
            scoreToSave =  "On target " .. oT .. "| Off target " .. offT .. "\n"
            storedScores:write(scoreToSave)
            storedScores:close()
end