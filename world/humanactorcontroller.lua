--[[
Copyright (C) 2013-2014 Jamie Nicol <jamie@thenicols.net>

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
local cock = require("cock")
local Vector = require("hump.vector")

local HumanActorController = class("world.HumanActorController")

function HumanActorController:initialize(actor)
   self._actor = actor

   local control_map = {
      default = {
         up = { { "keyboard", "up" } },
         down = { { "keyboard", "down" } },
         left = { { "keyboard", "left" } },
         right = { { "keyboard", "right" } },
         strafe = { { "keyboard", "lctrl" }, { "keyboard", "lshift" } },
         shoot = { { "keyboard", " ", "positive", "positive" } },
         use_item = { { "keyboard", "return", "positive", "positive" } }
      }
   }

   self._control = cock.new()
   self._control:setControls(control_map)
   self._control:setDefault("default")
end

function HumanActorController:update(dt)

   -- movement
   local displacement = Vector.new(0, 0)
   displacement.y = displacement.y - self._control.current.up
   displacement.y = displacement.y + self._control.current.down
   displacement.x = displacement.x - self._control.current.left
   displacement.x = displacement.x + self._control.current.right

   displacement = displacement:normalized() * self._actor._max_speed * dt
   self._actor:move(displacement)

   -- direction facing
   if self._control.current.strafe == 0 and displacement:len() > 0 then
      self._actor:set_direction_facing(math.atan2(displacement.x,
                                                  -displacement.y))
   end

   -- shoot
   if self._control.current.shoot > 0 then
      self._actor:shoot()
   end

   -- use item
   if self._control.current.use_item > 0 and self._actor._held_item then
      self._actor:use_item()
   end
end

return HumanActorController
