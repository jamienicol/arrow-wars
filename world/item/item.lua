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

local Item = class("world.item.Item")

function Item:initialize()
end

function Item:get_name()
   return ""
end

function Item:get_crate_image()
   return nil
end

function Item:should_automatically_use()
   return false
end

function Item:get_bbox()
   return nil
end

function Item:update(dt)
end

function Item:draw()
end

return Item
