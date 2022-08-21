Background = Object:extend()

function Background:new(path, x, y, sx, sy)
    self.image = love.graphics.newImage(path)

    self.x = x or 0
    self.y = y or 0
	self.sx = sx or 1.0
	self.sy = sy or 1.0

    if self.image:getWidth() < x2 then
       self.sx = self.sx * (x2 / self.image:getWidth())
    end
    if self.image:getWidth() < x2 then
        self.sy = self.sy * (y2 / self.image:getHeight())
    end
end

function Background:draw()
    love.graphics.draw(self.image,self.x,self.y, 0, self.sx, self.sy)
end