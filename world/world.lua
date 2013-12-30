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
local Actor = require("world.actor")
local AdvTiledLoader = require("AdvTiledLoader")
local Collider = require("hardoncollider")
local Shapes = require("hardoncollider.shapes")

local World = class("world.world")

function World:initialize()
   self._objects = {}
   self._objects_to_add = {}
   self._objects_to_remove = {}

   local loader = AdvTiledLoader.Loader
   loader.path = "data/maps/"
   loader.useSpriteBatch = true
   self._map = loader.load("map.tmx")

   self._collider = Collider(100,
                             function(...)
                                self:on_collision(...)
                             end,
                             function(...)
                                self:collision_stop(...)
                             end)

   for _, box in pairs(self:_create_edge_collision_boxes()) do
      self._collider:addShape(box)
      self._collider:setPassive(box)
   end

   for _, box in pairs(self:_create_tile_collision_boxes()) do
      self._collider:addShape(box)
      self._collider:setPassive(box)
   end
end

function World:_create_edge_collision_boxes()
   local top
   top = Shapes.newPolygonShape(-self._map.tileWidth,
                                -self._map.tileHeight,
                                self:get_width() + self._map.tileWidth,
                                -self._map.tileHeight,
                                self:get_width() + self._map.tileWidth,
                                0,
                                -self._map.tileWidth,
                                0)
   top.type = "edge"

   local bottom
   bottom = Shapes.newPolygonShape(-self._map.tileWidth,
                                   self:get_height(),
                                   self:get_width() + self._map.tileWidth,
                                   self:get_height(),
                                   self:get_width() + self._map.tileWidth,
                                   self:get_height() + self._map.tileHeight,
                                   -self._map.tileWidth,
                                   self:get_height() + self._map.tileHeight)
   bottom.type = "edge"

   local left
   left = Shapes.newPolygonShape(-self._map.tileWidth,
                                 -self._map.tileHeight,
                                 0,
                                 -self._map.tileHeight,
                                 0,
                                 self:get_height() + self._map.tileHeight,
                                 -self._map.tileWidth,
                                 self:get_height() + self._map.tileHeight)
   left.type = "edge"

   local right
   right = Shapes.newPolygonShape(self:get_width(),
                                  -self._map.tileHeight,
                                  self:get_width() + self._map.tileWidth,
                                  -self._map.tileHeight,
                                  self:get_width() + self._map.tileWidth,
                                  self:get_height() + self._map.tileHeight,
                                  self:get_width(),
                                  self:get_height() + self._map.tileHeight)
   right.type = "edge"

   return { top, bottom, left, right }
end

function World:_create_tile_collision_boxes()
   local boxes = {}

   for _, layer in pairs(self._map.layers) do
      for x, y, tile in layer:iterate() do
         if tile.properties.ground_passable == false or
            tile.properties.air_passable == false then
            local left = x * self._map.tileWidth
            local right = left + self._map.tileWidth
            local top = y * self._map.tileHeight
            local bottom = top + self._map.tileHeight
            local box = Shapes.newPolygonShape(left, top,
                                               right, top,
                                               right, bottom,
                                               left, bottom)
            box.type = "tile"
            box.object = tile
            table.insert(boxes, box)
         end
      end
   end

   return boxes
end

function World:does_shape_collide(shape)
   local collisions = false

   self._collider:addShape(shape)

   for _, neighbor in pairs(shape:neighbors()) do
      if shape:collidesWith(neighbor) then
         collisions = true
         break
      end
   end

   self._collider:remove(shape)

   return collisions
end

function World:get_width()
   return self._map.width * self._map.tileWidth
end

function World:get_height()
   return self._map.height * self._map.tileHeight
end

function World:add(object)
   self._objects_to_add[object] = object
end

function World:remove(object)
   self._objects_to_remove[object] = object
end

function World:get_actors()
   local actors = {}
   for object, _ in pairs(self._objects) do
      if object:isInstanceOf(Actor) then
         actors[object] = object
      end
   end
   return actors
end


function World:update(dt)
   for _, object in pairs(self._objects_to_add) do
      self._objects[object] = object
      self._objects_to_add[object] = nil

      object._world = self
      local bbox = object:get_bbox()
      if bbox then
         self._collider:addShape(bbox)
      end
   end

   for _, object in pairs(self._objects) do
      object:update(dt)
   end

   self._collider:update(dt)

   for _, object in pairs(self._objects_to_remove) do
      self._objects[object] = nil
      self._objects_to_remove[object] = nil

      object._world = nil
      local bbox = object:get_bbox()
      if bbox then
         self._collider:remove(bbox)
      end
   end
end

function World:on_collision(dt, shape_a, shape_b, mtv_x, mtv_y)

   local obj_a = shape_a.object
   if obj_a and obj_a.on_collision then
      obj_a:on_collision(dt, shape_b, mtv_x, mtv_y)
   end

   local obj_b = shape_b.object
   if obj_b and obj_b.on_collision then
      obj_b:on_collision(dt, shape_a, -mtv_x, -mtv_y)
   end
end

function World:collision_stop(dt, shape_a, shape_b)

   local obj_a = shape_a.object
   if obj_a and obj_a.collision_stop then
      obj_a:collision_stop(dt, shape_b)
   end

   local obj_b = shape_b.object
   if obj_b and obj_b.collision_stop then
      obj_b:collision_stop(dt, shape_a)
   end
end

function World:draw(camera)
   camera:attach()

   local viewport_width = love.graphics.getWidth() / camera.scale
   local viewport_height = love.graphics.getHeight() / camera.scale
   local viewport_left = camera.x - viewport_width / 2
   local viewport_top = camera.y - viewport_height / 2
   self._map:setDrawRange(viewport_left,
                          viewport_top,
                          viewport_width,
                          viewport_height)

   self._map:draw()

   for _, object in pairs(self._objects) do
      object:draw(dt)
   end

   camera:detach()
end

return World
