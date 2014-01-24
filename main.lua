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

local gamestate = require("hump.gamestate")
local gui = require("quickie")
local loader = require("love2d-assets-loader.Loader.loader")

local TitleScreen = require("game.titlescreen")

function love.load()
   math.randomseed(os.time())

   gui.keyboard.cycle.next = {key = "down"}
   gui.keyboard.cycle.prev = {key = "up"}
   gui.core.style.Button = function(state, title, x, y, w, h)
      local f = assert(love.graphics.getFont())

      x = x + (w - f:getWidth(title)) / 2
      y = y + (h - f:getHeight(title)) / 2

      if state == "normal" then
         love.graphics.setColor({255, 255, 255})
      else
         love.graphics.setColor({255, 215, 63})
      end

      love.graphics.print(title, x, y)
   end
   gui.core.style.Label = function(state, text, align, x, y, w, h)
      local f = assert(love.graphics.getFont())

      x = x + (w - f:getWidth(text)) / 2
      y = y + (h - f:getHeight(text)) / 2

      love.graphics.setColor({255, 255, 255})

      love.graphics.print(text, x, y)
   end

   loader.setBaseImageDir("data/images")
   loader.init()

   gamestate.switch(TitleScreen:new())
end

function love.update(dt)
   gamestate.update(dt)
end

function love.keypressed(key, unicode)
   gamestate.keypressed(key, unicode)
end

function love.draw()
   gamestate.draw()
end
