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

local Bullet = require("world.bullet")
local class = require("middleclass.middleclass")
local loader = require("love2d-assets-loader.Loader.loader")
local Vector = require("hump.vector")

local Actor = class("world.Actor")

function Actor:initialize()
   self:set_position(Vector.new(0, 0))
   self._direction_facing = 0

   self._max_speed = 0

   self._radius = 16

   self._controller = nil
end

function Actor:get_position()
   return self._position
end

function Actor:set_position(position)
   self._prev_position = position
   self._position = position
end

function Actor:get_direction_facing()
   return self._direction_facing
end

function Actor:set_direction_facing(direction_facing)
   self._direction_facing = direction_facing
end

function Actor:get_max_speed()
   return self._max_speed
end

function Actor:set_max_speed(max_speed)
   self._max_speed = max_speed
end

function Actor:get_controller()
   return self._controller
end

function Actor:set_controller(controller)
   self._controller = controller
end

function Actor:update(dt)
   self._velocity = (self._position - self._prev_position) / dt
   self._prev_position = self._position

   if self._controller then
      self._controller:update(dt)
   end
end

function Actor:shoot()
   local facing_vec = Vector.new(0, -1):rotated(self._direction_facing)

   local bullet = Bullet:new(self._position + facing_vec * self._radius,
                             facing_vec * 640 + self._velocity)
   self._world:add(bullet)
end

function Actor:draw()
   local image = loader.Image.arrow
   love.graphics.draw(image,
                      self._position.x, self._position.y,
                      self._direction_facing,
                      1, 1,
                      image:getWidth() / 2,
                      image:getHeight() / 2)
end

return Actor
