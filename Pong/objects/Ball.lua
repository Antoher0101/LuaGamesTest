Ball = Object:extend()

function Ball:new(path, x, y, width, height)
    if path ~= nil then
        self.image = love.graphics.newImage(path)
        self.width = self.image:getWidth()
	    self.height = self.image:getHeight()
        self.yOrig = self.image:getWidth()/2
        self.xOrig = self.image:getHeight()/2
    end
    
    default_pos = {x = x-self.width/2, y = y-self.height/2}

	self.x = x-self.width/2 or 0
	self.y = y-self.height/2 or 0

    self.bounding_box = {}
    self.newbounding_box = {}
    self.newbounding_box.ball = true

    self.newPositionX = 0
    self.newPositionY = 0
    self.bounding_box.x1 = self.x
    self.bounding_box.y1 = self.y
	self.bounding_box.x2 = self.x + self.width
	self.bounding_box.y2 = self.y + self.height
    self.bounding_box.ball = true

    self.timeToRestart = 1
    self.timePassed = 0
    math.randomseed(os.clock())
	self.direction = {x = math.random(-100,100)/100, y = math.random(-100,100)/100}
end

function Ball:update(dt, colliders)

    if self.request_respawn  then
        self.timePassed = self.timePassed + 1 * dt
        if  self.timePassed > self.timeToRestart then
            self.request_respawn = false
            self.timePassed = 0
            math.randomseed(os.clock())
	        self.direction = {x = math.random(-100,100)/100, y = math.random(-100,100)/100}
        end
    end
    
    
    self.newPositionX = self.x
	self.newPositionY = self.y

    local norm = normalize(self.direction)

    self.newPositionX = self.x + dt * norm.x * ball_move_speed;
	self.newPositionY = self.y + dt * norm.y * ball_move_speed;
    self.newbounding_box.x1 = self.newPositionX
	self.newbounding_box.y1 = self.newPositionY
	self.newbounding_box.x2 = self.newPositionX + self.width
	self.newbounding_box.y2 = self.newPositionY + self.height

    for k,v in pairs(colliders) do
		if (isIntersect(self.newbounding_box, v)) then
            if v.player then
                local player_center = v.x1 + (v.x2-v.x1)/2
                local ball_center = self.x + self.width/2
                local k = (player_center-ball_center) / (v.x2-v.x1)*2

                if v.bot then love.audio.play(hit1)
                else love.audio.play(hit2) end

                if k < -1 then k = -1 end 
                if k > 1 then k = 1 end
                if joystick and not v.bot and enable_vibration then
                    local max_force = 0.5
                     local vibe_force = max_force*(1+k)/2

                    joystick:setVibration(vibe_force, max_force-vibe_force, 0.2)
                end
                self.direction.x = -k 
                self.direction.y = v.normal.y

               -- print("{ x = " .. self.direction.x .. "; y = " .. self.direction.y .. " }")
            else
                if v.normal.x ~= 0 then
                    self.direction.x = v.normal.x
                end
                if v.normal.y ~= 0 then
                    self.direction.y = v.normal.y
                end
            end
		end
	end

    self.x = self.newPositionX
    self.y = self.newPositionY
    self.bounding_box = self.newbounding_box
end

function Ball:draw()
    if not self.image then
	    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 4)
    else
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1)
    end
end

function Ball:getRect()
	return self.bounding_box
end

function normalize(vec)
    inv_length = 1.0 / math.sqrt(vec.x*vec.x + vec.y*vec.y) 
    if inv_length == math.huge or inv_length == -math.huge then
        return {x = 0, y = 0}
    end
    norm = {x = vec.x*inv_length, y = vec.y*inv_length}
    return norm
end

function Ball:Respawn()
    self.x = default_pos.x
	self.y = default_pos.y

    self.direction = {x = 0, y = 0}
    
    self.request_respawn = true
end