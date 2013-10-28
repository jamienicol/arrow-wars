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
local Camera = require("hump.camera")
local HumanActorController = require("world.humanactorcontroller")
local Vector = require("hump.vector")
local World = require("world.world")

local SurvivalMode = class("game.SurvivalMode")

function SurvivalMode:enter()
   self._world = World:new()

   self._actor = Actor:new()
   self._actor:set_position(Vector.new(400, 240))
   self._actor:set_max_speed(256)
   self._actor:set_controller(HumanActorController:new(self._actor))
   self._world:add(self._actor)

   self._camera = Camera.new()
end

function SurvivalMode:update(dt)
   self._world:update(dt)
end

function SurvivalMode:draw()
   local camera_x =
      math.max(love.graphics.getWidth() / 2,
               math.min(self._world:get_width() -
                           love.graphics.getWidth() / 2,
                        self._actor:get_position().x))
   local camera_y =
      math.max(love.graphics.getHeight() / 2,
               math.min(self._world:get_height() -
                           love.graphics.getHeight() / 2,
                        self._actor:get_position().y))
   self._camera:lookAt(camera_x, camera_y)

   self._world:draw(self._camera)
end

return SurvivalMode
