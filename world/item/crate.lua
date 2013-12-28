local class = require("middleclass.middleclass")
local Shapes = require("hardoncollider.shapes")

local Crate = class("world.item.Crate")

function Crate:initialize(position, item)
   self._position = position
   self._radius = 16

   self._item = item

   self._bbox = Shapes.newCircleShape(self._position.x,
                                      self._position.y,
                                      self._radius)
   self._bbox.type = "crate"
   self._bbox.object = self
end

function Crate:get_position()
   return self._position
end

function Crate:get_item()
   return self._item
end

function Crate:get_bbox()
   return self._bbox
end

function Crate:update(dt)
end

function Crate:draw()
   local image = self._item:get_crate_image()
   love.graphics.draw(image,
                      self._position.x, self._position.y,
                      0,
                      1, 1,
                      image:getWidth() / 2,
                      image:getHeight() / 2)

end

return Crate
