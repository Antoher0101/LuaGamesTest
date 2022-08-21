Slider = Object:extend()

function Slider:new(image, text, xfunction, x, y, w, currentValue, marginBtw)
    self.image = image or nil
    self.x = x or 0
    self.y = y or 0
    self.width = w or 20
    self.text = love.graphics.newText(love.graphics.getFont(), text or "SAMPLETEXT")
    self.marginBtw = marginBtw or 10
    self.currentValue = currentValue or 0

    self.sliderStartPoint = self.x + self.text:getWidth()+self.marginBtw
    self.sliderEndPoint = self.sliderStartPoint + self.width
    self.HandleHeight = 7

    self.HandlePosition = {
        x1 = self.currentValue*self.width+self.sliderStartPoint,--self.x + self.text:getWidth()+self.marginBtw,
        y1 = self.y+(love.graphics.getFont():getHeight())-self.HandleHeight, 
        x2 = self.currentValue*self.width+self.sliderStartPoint+5, 
        y2 = self.y+(love.graphics.getFont():getHeight())+self.HandleHeight
    }
    self.grabbed = false

    self.func = xfunction
end

function Slider:update(dt)
    
end

function Slider:draw()
    
    love.graphics.draw(self.text, self.x, self.y+(love.graphics.getFont():getHeight()/2))
    --love.graphics.rectangle("line", self.box_pos.x1, self.box_pos.y1, self.width, self.height)
    love.graphics.line(
        self.sliderStartPoint, 
        self.y+(love.graphics.getFont():getHeight()), 
        self.sliderEndPoint, 
        self.y+(love.graphics.getFont():getHeight()))

    love.graphics.rectangle("fill",
    self.HandlePosition.x1,
    self.HandlePosition.y1,
    self.HandlePosition.x2 - self.HandlePosition.x1,
    self.HandlePosition.y2 - self.HandlePosition.y1)
end
function Slider:getState()
   return self.grabbed
end

function Slider:setState(s)
    self.grabbed = s
 end

function Slider:getValue()
   return self.currentValue
end

function Slider:setValue()
    self.func(self.currentValue)
end

function Slider:setHandle(v)
    
    if self.sliderStartPoint <= v and 
    self.sliderEndPoint >= v
    then
        local xt = self.HandlePosition.x1 +v
        self.HandlePosition = {
            x1 = v,
            y1 = self.y+(love.graphics.getFont():getHeight())-self.HandleHeight, 
            x2 = v +5, 
            y2 = self.y+(love.graphics.getFont():getHeight())+self.HandleHeight
        }
        self.currentValue = ((self.HandlePosition.x1-self.sliderStartPoint) / self.width)
    end
end
function Slider:getGlobalSlider()
    return self.globalHPosition
end
function Slider:getPosition()
    return self.HandlePosition
end