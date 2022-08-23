local x0 = 0
local y0 = 0
local width, height = love.graphics.getDimensions()

time = 0
local speed = 1.5
function love.load()
    bgm = love.audio.newSource("sounds/tetris.wav", "static")
    bgm:setLooping(true)
    love.audio.play(bgm)
    love.audio.setVolume(0.2)
end

function love.update(dt)
    time = time + dt
    if time > speed then
        time = 0



    end
end

function love.draw()
    love.graphics.clear(135,206,250)

    love.graphics.setShader(grid_shader)
    for i = 0, width, width/10 do
        love.graphics.line(i,0,i,height)
    end
    for i = 0, height, width/10 do
        love.graphics.line(0,i,width,i)
    end
    love.graphics.setShader()

end