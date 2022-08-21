Wall = Object:extend()


function Wall:new(path, x, y, width, height, normal)
    
    if path ~= nil then
        self.image = love.graphics.newImage(path)
        self.width = self.image:getWidth()
	    self.height = self.image:getHeight()
    else 
        self.width = width or 50
        self.height = height or 5
    end
	self.x = x or 0
	self.y = y or 0
    
    self.bounding_box = {}
    self.newbounding_box = {}
    self.newPositionX = 0
    self.newPositionY = 0
    self.bounding_box.x1 = self.x
    self.bounding_box.y1 = self.y
	self.bounding_box.x2 = self.x + self.width
	self.bounding_box.y2 = self.y + self.height
	self.bounding_box.normal = {x = normal.x, y = normal.y}
	
end

function Wall:update(dt, colliders)
    self.newPositionX = self.x
	self.newPositionY = self.y
	if love.keyboard.isDown( "left" ) then
		self.newPositionX = self.x - dt * 300;
	end
	if love.keyboard.isDown( "right" ) then
		self.newPositionX = self.x + dt * 300;
	end
	if love.keyboard.isDown( "up" ) then
		self.newPositionY = self.y - dt * 300;
	end
	if love.keyboard.isDown( "down" ) then
		self.newPositionY = self.y + dt * 300;
	end 
end

function Wall:draw()
    if not self.image then
	    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 4)
    else
        love.graphics.draw(self.image, self.x, self.y)
    end
end

function Wall:getRect()
	return self.bounding_box
end