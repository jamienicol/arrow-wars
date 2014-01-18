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
local Item = require("world.item.item")
local loader = require("love2d-assets-loader.Loader.loader")

local Heart = class("world.item.Heart", Item)

function Heart:initialize()
   Item.initialize(self)
end

function Heart:get_name()
   return "Heart"
end

function Heart:get_crate_image()
   return loader.Image["heart"]
end

function Heart:should_automatically_use()
   return true
end

function Heart:use(actor)
   actor:heal(10)
end

return Heart
