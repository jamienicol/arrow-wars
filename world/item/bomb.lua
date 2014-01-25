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
local Explosion = require("world.explosion")
local Item = require("world.item.item")
local loader = require("loader")

local Bomb = class("world.item.Bomb", Item)

function Bomb:initialize()
   Item.initialize(self)
end

function Bomb:get_name()
   return "Bomb"
end

function Bomb:get_crate_image()
   return loader.Image["bomb"]
end

function Bomb:should_automatically_use()
   return false
end

function Bomb:use(agent)
   self._position = agent:get_position()

   self._countdown = 3

   agent._world:add(self)
end

function Bomb:update(dt)
   self._countdown = self._countdown - dt

   if self._countdown <= 0 then
      self._world:add(Explosion:new(self._position))

      self._world:remove(self)
   end
end

function Bomb:draw()
   local image = loader.Image["bomb"]
   love.graphics.draw(image,
                      self._position.x, self._position.y,
                      0,
                      1, 1,
                      image:getWidth() / 2,
                      image:getHeight() / 2)

   local font = loader.Font[22]
   love.graphics.setFont(font)
   love.graphics.setColor(255, 255, 255)
   love.graphics.printf(tostring(math.ceil(self._countdown)),
                        self._position.x - image:getWidth() / 2,
                        self._position.y - image:getHeight() / 2,
                        image:getWidth(),
                        "center")

end

return Bomb
