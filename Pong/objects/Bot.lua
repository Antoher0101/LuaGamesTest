Bot = Object:extend()

function Bot:new(image, x, y, width, height)
	if image then
		self.image = love.graphics.newImage(image)
		self.sx = width / self.image:getWidth()
		self.sy = self.sx
	end
	self.x = x or 0
	self.y = y-self.image:getHeight()+1 or 0
	self.width = width or 50
	self.height = height or 5
	self.speed = 400
 
	self.bounding_box = {}
	self.newbounding_box = {}

	self.newbounding_box.normal = {x = 1, y = 1}
	self.newbounding_box.bot = true
	self.newbounding_box.player = true

	self.bounding_box.x1 = self.x
    self.bounding_box.y1 = self.y
	self.bounding_box.x2 = self.x + self.width
	self.bounding_box.y2 = self.y + self.height

	self.bounding_box.normal = {x = 1, y = 1}
	self.bounding_box.bot = true
	self.bounding_box.player = true

	self.isCollided = false

	self.newPositionX = 0
	self.newPositionY = 0
end

function Bot:update(dt, colliders, navigate)
	self.isCollided = false
	self.newPositionX = self.x
	self.newPositionY = self.y

	if autoplay then
		self.speed = ball_move_speed
	end
	
    local ball_coord = navigate.x1+(navigate.x2-navigate.x1)/2
    if (ball_coord < self.x) then
        self.newPositionX = self.x - dt * self.speed;
    end
    if (ball_coord > self.x + self.width) then
        self.newPositionX = self.x + dt * self.speed;
    end

	self.newbounding_box.x1 = self.newPositionX
	self.newbounding_box.y1 = self.newPositionY
	self.newbounding_box.x2 = self.newPositionX + self.width
	self.newbounding_box.y2 = self.newPositionY + self.height

    

	for k,v in pairs(colliders) do
		if (isIntersect(self.newbounding_box, v) and not v.bot) then
			self.isCollided = true
		end
	end

	if not self.isCollided  then 
		self.x = self.newPositionX
		self.y = self.newPositionY
		self.bounding_box = self.newbounding_box
	end
end

function Bot:draw()
	if self.image then
		love.graphics.draw(self.image,self.x, self.y, 0, self.sx, self.sy)
	else
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 4)
	end
end

function Bot:getRect()
	return self.bounding_box
end
