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

local Actor = require("world.actor")
local HumanActorController = require("world.humanactorcontroller")
local loader = require("love2d-assets-loader.Loader.loader")
local Vector = require("hump.vector")
local World = require("world.world")

local world

function love.load()
   loader.setBaseImageDir("data/images")
   loader.init()

   world = World:new()

   local actor = Actor:new()
   actor:set_position(Vector.new(400, 240))
   actor:set_max_speed(256)
   actor:set_controller(HumanActorController:new(actor))
   world:add(actor)
end

function love.update(dt)
   world:update(dt)
end

function love.draw()
   world:draw()
end
