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
local AdvTiledLoader = require("AdvTiledLoader")

local World = class("world.world")

function World:initialize()
   self._objects = {}

   local loader = AdvTiledLoader.Loader
   loader.path = "data/maps/"
   loader.useSpriteBatch = true
   self._map = loader.load("map.tmx")
end

function World:get_width()
   return self._map.width * self._map.tileWidth
end

function World:get_height()
   return self._map.height * self._map.tileHeight
end

function World:add(object)
   table.insert(self._objects, object)

   object._world = self
end

function World:update(dt)
   for _, object in ipairs(self._objects) do
      object:update(dt)
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

   for _, object in ipairs(self._objects) do
      object:draw(dt)
   end

   camera:detach()
end

return World
