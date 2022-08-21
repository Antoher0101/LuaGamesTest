Object = require 'libraries/classic'

x1 = 0
x2 = love.graphics.getWidth()
y1 = 0
y2 = love.graphics.getHeight()

local colliders = {}
local score = { p1 = 0, p2 = 0 }
 
local paddle_width = 75
local paddle_padding = 40
ball_move_speed = 300
 
autoplay = false
 
local delay = 10
 
enable_vibration = false
 
local start = false

function toggleVibration()
    enable_vibration = not enable_vibration
end
function toggleAutoplay()
    autoplay = not autoplay
end
function setVolume(v)
    love.audio.setVolume(v)
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    time = 0
    mousePointF = 0
	local object_files = {}
	recursiveEnumerate('objects', object_files)
    requireFiles(object_files)
	
    CheckJoytickConnection()

    shader = love.graphics.newShader("shaders/shader.frag")
    paddle_shader = love.graphics.newShader("shaders/paddle_shader.frag")
    text_shader = love.graphics.newShader("shaders/text_shader.frag")

    menu = Menu()
    bg = Background("sprites/vaporBackground.jpg", -100, -100, 1.3, 1.4)

	player1 = Player("sprites/paddle1.png", (x2-paddle_width)/2,y2-paddle_padding, paddle_width)
	bot1 = Bot("sprites/paddle2.png", (x2-paddle_width)/2, paddle_padding, paddle_width)

    leftWall = Wall(nil, 0, 0, 1, y2, {x = 1, y = 0})
    rightWall = Wall(nil, x2, 0, 1, y2, {x = -1, y = 0});
    topWall = Wall(nil, 0, 0, x2, 1, {x = 0, y = 1})
    bottomWall = Wall(nil, 0, y2, x2, 1, {x = 0, y = -1});
    
    ball = Ball("sprites/bullet.png", x2/2,y2/2)

    addColliders(player1:getRect())
    addColliders(bot1:getRect())

    addColliders(leftWall:getRect())
    addColliders(rightWall:getRect())
    -- addColliders(topWall:getRect())
    -- addColliders(bottomWall:getRect())

    -- sound
    bgm = love.audio.newSource("sounds/bgm.wav", "stream")
    love.audio.play(bgm)
    bgm:setLooping(true) 

    hit1 = love.audio.newSource("sounds/kick1.wav", "static")
    hit2 = love.audio.newSource("sounds/kick2.wav", "static")

    -- font
    scoreFont = love.graphics.newFont(150)
    defaultFont = love.graphics.newFont()
end
function love.keypressed(key, unicode)
    if key == 'escape' then pause = not pause end
    if key == 'r' then ball:Respawn() end
    if key == 'space' then start = true end
end
function love.gamepadpressed(joystick, button)
    if button == 'start' then pause = not pause end
    if button == 'x' or button == 'a' then start = true end
end
function love.update(dt) 
    if dt > 0.03 then
        dt = 0
    end
    time = time + dt;

    if time >= delay and not pause then
        delay = delay + delay
        if autoplay then
            ball_move_speed = ball_move_speed + 500
        else
            ball_move_speed = ball_move_speed + 100
        end
    end

	shader:send("iTime",time)
    
    if pause then
        draggingSlider()
        return
    end
    CheckBox:update(dt)
    colliders[1] = player1:getRect()
    colliders[2] = bot1:getRect()
    if start then
        ball:update(dt, colliders)
    end

    if ball:getRect().y1 > y2 then
        score.p2 = score.p2 + 1
        ball:Respawn()
    end
    if ball:getRect().y1 < y1 then
        score.p1 = score.p1 + 1
        ball:Respawn()
    end

	player1:update(dt, colliders, ball:getRect())
	bot1:update(dt, colliders, ball:getRect())
end

function love.draw()
    -- draw bg
    love.graphics.setShader(shader)
    bg:draw()
    love.graphics.setShader()
    
    -- draw score
    love.graphics.setShader(text_shader)
    text = love.graphics.newText(scoreFont,score.p2)
    love.graphics.draw(text, x2/2-text:getWidth()/2, 50)
    text = love.graphics.newText(scoreFont,score.p1)
    love.graphics.draw(text, x2/2-text:getWidth()/2, y2-50-text:getHeight())
    love.graphics.setShader()
    -- draw paddles
    love.graphics.setShader(paddle_shader)
    player1:draw()
    bot1:draw()
    love.graphics.setShader()

    ball:draw()

    if pause == true then
        menu:draw()
    elseif not start then
        if joystick then
            love.graphics.printf("Press X to start", x2/2-50, y2/2-100, 100, "center")
        else
            love.graphics.printf("Press SPACE to start", x2/2-50, y2/2-100, 100, "center")
        end
    end
end

function addColliders(cld)
    colliders[#colliders+1] = cld
end

function love.mousepressed(x, y, button)
    if pause and mouseHitTest(x, y, menu:getVibrationButton():getPosition()) then
        menu:getVibrationButton():toggle()
    end
    if pause and mouseHitTest(x, y, menu:getAutoplayButton():getPosition()) then
        menu:getAutoplayButton():toggle()
    end
    if pause and mouseHitTest(x, y, menu:getVolumeSlider():getPosition()) then
        menu:getVolumeSlider():setState(true)
        mousePointF = love.mouse.getX()
    end
    if button == 2 then
        pause = not pause
    end
end
function love.mousereleased(x,y)
    if menu:getVolumeSlider():getState() then
        menu:getVolumeSlider():setState(false)
        menu:getVolumeSlider():setValue()
    end
end
function draggingSlider()
    if menu:getVolumeSlider():getState() then
        local mouseDelta = love.mouse.getX() - mousePointF  
        menu:getVolumeSlider():setHandle(love.mouse.getX())
    end
end
function mouseHitTest(mx, my, p)
    if (mx >= p.x1 and mx <= p.x2 and my >= p.y1 and my <= p.y2) then
        return true
    end
    return false
end

function CheckJoytickConnection()
    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
end













function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end