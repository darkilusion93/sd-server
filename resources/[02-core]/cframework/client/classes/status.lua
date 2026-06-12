function CreateStatus(name, default, color, tickCallback, frameCallback)
	local self = {}

	self.val          = default
	self.name         = name
	self.default      = default
	self.color        = color
	self.tickCallback = tickCallback
    self.frameCallback = frameCallback

	self._set = function(k, v)
		self[k] = v
	end

	self._get = function(k)
		return self[k]
	end

	self.onTick = function()
		self.tickCallback(self)
	end

    self.onFrameTick = function()
		self.frameCallback(self)
	end

	self.set = function(val)
		self.val = val
	end

	self.add = function(val)
        if val > 0 then
            if self.val + val > 1000000 then
                self.val = 1000000
            else
                self.val = self.val + val
            end
        else
            if self.val + val < 0 then
                self.val = 0
            else
                self.val = self.val + val
            end
        end
	end

	self.remove = function(val)
		if self.val - val < 0 then
			self.val = 0
		else
			self.val = self.val - val
		end
	end

	self.getPercent = function()
		return (self.val / 1000000) * 100
	end

	return self
end
