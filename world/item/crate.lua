--[[
Copyright (C) 2013 Jamie Nicol <jamie@thenicols.net>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

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
