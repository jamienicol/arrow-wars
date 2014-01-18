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
local Explosion = require("world.explosion")
local Item = require("world.item.item")
local loader = require("love2d-assets-loader.Loader.loader")
local Shapes = require("hardoncollider.shapes")
local Vector = require("hump.vector")

local Missile = class("world.item.Missile", Item)

function Missile:initialize()
   Item.initialize(self)

   self._speed = 320
   self._rotation_speed = math.pi
   self._radius = 16
   self._collision_radius = 4
end

function Missile:get_name()
   return "Missile"
end

function Missile:get_crate_image()
   return loader.Image["missile"]
end

function Missile:should_automatically_use()
   return false
end

function Missile:_get_front()
   return self._position +
      self._facing_vec * (self._radius - self._collision_radius)
end

function Missile:_find_target(world)
   local shortest_distance = nil
   local target = nil
   for _, actor in pairs(world:get_actors()) do
      if actor ~= self._shooter then
         local distance = (self._position - actor:get_position()):len()

         if shortest_distance == nil or distance < shortest_distance then
            shortest_distance = distance
            target = actor
         end
      end
   end

   return target
end

function Missile:use(actor)
   self._shooter = actor

   self._facing_vec =
      Vector.new(0, -1):rotated(self._shooter:get_direction_facing())

   self._position = self._shooter:get_position() +
      self._facing_vec * (self._shooter:get_radius() + self._radius)

   local front = self:_get_front()
   self._bbox = Shapes.newCircleShape(front.x, front.y, self._collision_radius)
   self._bbox.type = "missile"
   self._bbox.object = self

   self._target = self:_find_target(self._shooter._world)
   if self._target then
      self._target.signals:register("on-death",
                                    function(actor)
                                       self._target = nil
                                    end)
   end

   self._shooter._world:add(self)
end

function Missile:get_bbox()
   return self._bbox
end

function Missile:update(dt)
   -- rotate towards the target, if there is one
   if self._target then
      local a = self._facing_vec
      local b = self._target:get_position() - self._position
      local desired_turn = math.atan2(a.x * b.y - a.y * b.x,
                                      a.x * b.x + a.y * b.y)
      local actual_turn = 0
      if desired_turn > 0 then
         actual_turn = math.min(desired_turn, self._rotation_speed * dt)
      elseif desired_turn < 0 then
         actual_turn = math.max(desired_turn, -self._rotation_speed * dt)
      end

      self._facing_vec:rotate_inplace(actual_turn)
   end

   self._position = self._position + self._facing_vec * self._speed * dt
   local front = self:_get_front()
   self._bbox:moveTo(front.x, front.y)
end

function Missile:on_collision(dt, shape, mtv_x, mtv_y)
   if shape.type == "edge" then
      self._world:remove(self)
      self._world:add(Explosion:new(self._position))

   elseif shape.type == "tile" then
      local tile = shape.object
      if tile.properties.air_passable == false then
         self._world:remove(self)
         self._world:add(Explosion:new(self._position))
      end

   elseif shape.type == "actor" then
      self._world:remove(self)
      self._world:add(Explosion:new(self._position))
   end

end

function Missile:draw()
   local image = loader.Image["missile"]
   love.graphics.draw(image,
                      self._position.x, self._position.y,
                      math.atan2(self._facing_vec.x, -self._facing_vec.y),
                      1, 1,
                      image:getWidth() / 2,
                      image:getHeight() / 2)
end

return Missile
