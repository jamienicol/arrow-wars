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
local Collider = require("hardoncollider")
local Signal = require("hump.signal")
local Shapes = require("hardoncollider.shapes")
local Vector = require("hump.vector")

local Actor = class("world.Actor")

function Actor:initialize()
   self._max_speed = 0

   self._radius = 16

   self._controller = nil

   self._max_health = 0
   self._health = 0

   self.signals = Signal.new()

   self._bbox = Shapes.newCircleShape(0, 0, self._radius)
   self._bbox.type = "actor"
   self._bbox.object = self

   self:set_position(Vector.new(0, 0))

   self:set_direction_facing(0)
end

function Actor:get_position()
   return self._position
end

function Actor:set_position(position)
   self._prev_position = position
   self._position = position
   self._prev_velocity = Vector.new(0, 0)
   self._velocity = Vector.new(0, 0)
   self._bbox:moveTo(position.x, position.y)
end

function Actor:get_radius()
   return self._radius
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

function Actor:get_image()
   return self._image
end

function Actor:set_image(image)
   self._image = image
end

function Actor:get_controller()
   return self._controller
end

function Actor:set_controller(controller)
   self._controller = controller
end

function Actor:get_bbox()
   return self._bbox
end

function Actor:get_held_item()
   return self._held_item
end

function Actor:set_max_health(max_health)
   self._max_health = max_health
end

function Actor:set_health(health)
   self._health = health
end

function Actor:get_health()
   return self._health
end

function Actor:heal(amount)
   self._health = math.min(self._max_health, self._health + amount)
end

function Actor:take_damage(damage)
   self._health = math.max(0, self._health - damage)

   if self._health == 0 then
      self.signals:emit("on-death", self)
   end
end

function Actor:update(dt)
   self._prev_velocity = self._velocity
   self._velocity = (self._position - self._prev_position) / dt
   self._prev_position = self._position

   if self._controller then
      self._controller:update(dt)
   end
end

function Actor:move(displacement)
   self._position = self._position + displacement
   self._bbox:moveTo(self._position.x, self._position.y)
end

function Actor:shoot()
   local facing_vec = Vector.new(0, -1):rotated(self._direction_facing)

   local bullet = Bullet:new(self._prev_position + facing_vec * self._radius,
                             facing_vec * 640 + self._prev_velocity)
   self._world:add(bullet)
end

function Actor:use_item()
   self._held_item:use(self)
   self._held_item = nil
end

function Actor:on_collision(dt, shape, mtv_x, mtv_y)
   if shape.type == "edge" then
      self:move(Vector.new(mtv_x, mtv_y))

   elseif shape.type == "tile" then
      if shape.object.properties.ground_passable == false then
         self:move(Vector.new(mtv_x, mtv_y))
      end

   elseif shape.type == "actor" then
      self:move(Vector.new(mtv_x / 2, mtv_y / 2))

   elseif shape.type == "crate" then
      local crate = shape.object
      local item = crate:get_item()
      self._world:remove(crate)

      if item:should_automatically_use() then
         item:use(self)
      else
         self._held_item = item
      end
   end
end

function Actor:draw()
   love.graphics.draw(self._image,
                      self._position.x, self._position.y,
                      self._direction_facing,
                      1, 1,
                      self._image:getWidth() / 2,
                      self._image:getHeight() / 2)
end

return Actor
