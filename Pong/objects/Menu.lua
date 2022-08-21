Menu = Object:extend()

function Menu:new(image)
    self.image = image or nil
     local shader_str = [[vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
                {
                    //vec4 texturecolor = Texel(tex, texture_coords);
                    return vec4(0.0,0.0,0.0,0.3);
                }
            ]]
    self.veil_shader = love.graphics.newShader(shader_str)

    -- Buttons init
    self.vibration_btn = CheckBox(nil, "ENABLE VIBRATION", toggleVibration, 10, 10, 20, 20, 19)
    self.autoplay_btn = CheckBox(nil, "ENABLE CHILL MODE", toggleAutoplay, 10, 40)
    self.volume_slider = Slider(nil, "MASTER SOUND", setVolume, 10, 70, 150, 1.0)
end

function Menu:update(dt)
    
end

function Menu:draw()
    love.graphics.setShader(self.veil_shader)
        love.graphics.rectangle("fill", 0, 0, x2, y2)
        if self.image then
            love.graphics.draw(self.image, 0, 0)
        end
    love.graphics.setShader()

    local fontHeight = love.graphics.getFont():getHeight()
    if joystick then
        love.graphics.printf("Press START to continue", 0, (y2 / 2) - (fontHeight / 2), x2, "center")
    else
        love.graphics.printf("Press ESC to continue", 0, (y2 / 2) - (fontHeight / 2), x2, "center")
    end

    -- buttons draw
    self.vibration_btn:draw()
    self.autoplay_btn:draw()
    self.volume_slider:draw()
end

function Menu:getVibrationButton()
    return self.vibration_btn
end

function Menu:getAutoplayButton()
    return self.autoplay_btn
end
function Menu:getVolumeSlider()
    return self.volume_slider
end