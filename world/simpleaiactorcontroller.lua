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
local Vector = require("hump.vector")

local SimpleAIActorController = class("world.SimpleAIActorController")

function SimpleAIActorController:initialize(actor, target)
   self._actor = actor
   self._target = target

   self._shoot_rate = 1
end

function SimpleAIActorController:update(dt)
   -- movement
   local target_displacement =
      self._target:get_position() - self._actor:get_position()

   -- angle from -pi to pi, increasing clockwise with zero facing up
   local target_angle = math.atan2(target_displacement.x,
                                   -target_displacement.y)

   -- limit direction to vertical, horizontal, and diagonal
   local direction
   if target_angle > -1/8 * math.pi and target_angle < 1/8 * math.pi then
      direction = Vector.new(0, -1)
   elseif target_angle > 1/8 * math.pi and target_angle < 3/8 * math.pi then
      direction = Vector.new(1, -1)
   elseif target_angle > 3/8 * math.pi and target_angle < 5/8 * math.pi then
      direction = Vector.new(1, 0)
   elseif target_angle > 5/8 * math.pi and target_angle < 7/8 * math.pi then
      direction = Vector.new(1, 1)
   elseif target_angle > 7/8 * math.pi or target_angle < -7/8 * math.pi then
      direction = Vector.new(0, 1)
   elseif target_angle > -7/8 * math.pi and target_angle < -5/8 * math.pi then
      direction = Vector.new(-1, 1)
   elseif target_angle > -5/8 * math.pi and target_angle < -3/8 * math.pi then
      direction = Vector.new(-1, 0)
   elseif target_angle > -3/8 * math.pi and target_angle < -1/8 * math.pi then
      direction = Vector.new(-1, -1)
   end
   local displacement = direction:normalized() * self._actor._max_speed * dt
   self._actor:move(displacement)

   -- direction facing
   if displacement:len() > 0 then
      self._actor:set_direction_facing(math.atan2(displacement.x,
                                                  -displacement.y))
   end

   -- shoot
   if self._shoot_rate * dt > math.random() then
      self._actor:shoot()
   end
end

return SimpleAIActorController
