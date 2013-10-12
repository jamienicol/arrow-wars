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
local loader = require("love2d-assets-loader.Loader.loader")

local Bullet = class("world.Bullet")

function Bullet:initialize(position, velocity)
   self._position = position
   self._velocity = velocity
end

function Bullet:update(dt)
   self._position = self._position + self._velocity * dt
end

function Bullet:draw()
   local image = loader.Image.bullet
   love.graphics.draw(image,
                      self._position.x, self._position.y,
                      0,
                      1, 1,
                      image:getWidth() / 2,
                      image:getHeight() / 2)
end

return Bullet
