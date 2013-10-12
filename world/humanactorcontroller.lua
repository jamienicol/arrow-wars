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

local HumanActorController = class("world.HumanActorController")

function HumanActorController:initialize(actor)
   self._actor = actor

   self._options, self._control = love.filesystem.load("TLbind.lua")()
   self._options.keys = {
      up = "up",
      down = "down",
      left = "left",
      right = "right",
      lctrl = "strafe",
      [" "] = "shoot"
   }
end

function HumanActorController:update(dt)
   self._options:update()

   -- movement
   local displacement = Vector.new(0, 0)
   if self._control.up then
      displacement.y = displacement.y - 1
   end
   if self._control.down then
      displacement.y = displacement.y + 1
   end
   if self._control.left then
      displacement.x = displacement.x - 1
   end
   if self._control.right then
      displacement.x = displacement.x + 1
   end
   displacement = displacement:normalized() * self._actor._max_speed * dt
   self._actor:move(displacement)

   -- direction facing
   if not self._control.strafe and displacement:len() > 0 then
      self._actor:set_direction_facing(math.atan2(displacement.x,
                                                  -displacement.y))
   end

   -- shoot
   if self._control.tap.shoot then
      self._actor:shoot()
   end
end

return HumanActorController
