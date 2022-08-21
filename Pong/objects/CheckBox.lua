CheckBox = Object:extend()

function CheckBox:new(image, text, toggle_function, x, y, w, h, marginLeft, checked)
    self.image = image or nil
    self.x = x or 0
    self.y = y or 0
    self.width = w or 20
    self.height = h or 20
    self.text = love.graphics.newText(love.graphics.getFont(), text or "SAMPLETEXT")
    self.marginLeft = marginLeft or 10
    
    self.box_pos = {
        x1 = self.x + self.text:getWidth() + self.marginLeft,
        y1 = self.y, 
        x2 = self.x + self.text:getWidth() + self.marginLeft + self.width, 
        y2 = self.y + self.height
    }
    

    self.func = toggle_function
    self.checked = checked or false
end

function CheckBox:update(dt)
    
end

function CheckBox:draw()
   
    love.graphics.draw(self.text, self.x, self.y+(self.height/2-love.graphics.getFont():getHeight()/2))
    love.graphics.rectangle("line", self.box_pos.x1, self.box_pos.y1, self.width, self.height)
    
    if self.checked then
        love.graphics.line(
        self.box_pos.x1 + 4,
        self.box_pos.y1 + 4, 
        self.box_pos.x1+self.height - 4, 
        self.box_pos.y1+self.width - 4)
        love.graphics.line(
        self.box_pos.x1+self.width - 4,
        self.box_pos.y1 + 4, 
        self.box_pos.x1 + 4, 
        self.box_pos.y1+self.width - 4)
    end
end
function CheckBox:toggle()
    self.checked = not self.checked
    self.func()
end

function CheckBox:getState()
    return self.checked
end

function CheckBox:getPosition()
    return self.box_pos
end