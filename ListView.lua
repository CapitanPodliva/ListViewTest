ListView = Core.class(Sprite)

function ListView:init(width, height, sprite)
	ListView.setSize(sprite, width, height)
	self:addChild(sprite)
	self.spriteY = sprite:getY()
	if application:getDeviceInfo() ~= "Android" and application:getDeviceInfo() ~= "iOS" then 	
		if application:getOrientation() == "landscape" then 
			self.heightDiff = self:getHeight() - application:getContentHeight()
		elseif application:getOrientation() == "portrait" then
			self.heightDiff = self:getHeight() - application:getContentWidth()
		end
	else 
		if application:getOrientation() == "portrait" then 
			self.heightDiff = application:getContentHeight()
		elseif application:getOrientation() == "landscape" then
			self.heightDiff = application:getContentWidth()
		end
	end
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

function ListView:setSpriteY(newY)
	self.spriteY = newY
end

function ListView:setSize(newWidth, newHeight)
	self:setScale(1,1)
	self:setScale(newWidth/self:getWidth(), newHeight/self:getHeight())
end

function ListView:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		self.startY = event.y
	end
end

function ListView:onMouseUp(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
	end
end

function ListView:onMouseMove(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		self.endY = event.y
		self.pathY = self.endY - self.startY
		local newY = self:getY() - self.pathY
		
		if math.abs(self.pathY) > 100 then
			self.pathY = (self.pathY > 0 and 100 or -100)
		end
		
		if math.abs(self.startY - event.y) > 10 then
			self:setPosition(self:getX(), (newY > self.spriteY and self.spriteY or ((math.abs(newY) > self.heightDiff) and -self.heightDiff or newY)) )	
		end
	end
end