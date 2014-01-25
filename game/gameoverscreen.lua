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
local gamestate = require("hump.gamestate")
local gui = require("quickie")
local loader = require("loader")

local GameOverScreen = class("game.GameOverScreen")

function GameOverScreen:enter(previous, score)
   self._score = score

   self._title_font = loader.Font[45]
   self._text_font = loader.Font[25]
end

function GameOverScreen:keypressed(key, unicode)
   if key == 'return' then
      local TitleScreen = require("game.titlescreen")
      gamestate.switch(TitleScreen:new())
   end
end

function GameOverScreen:update(dt)

   love.graphics.setFont(self._title_font)
   gui.Label({text = "Game Over",
              pos = {
                 love.graphics.getWidth() / 4,
                 32
              },
              size = {
                 love.graphics.getWidth() / 2,
                 "tight"
              },
              align="center"})

   love.graphics.setFont(self._text_font)
   gui.Label({text = string.format("You scored %d", self._score),
              pos = {
                 love.graphics.getWidth() / 4,
                 love.graphics.getHeight() / 2
              },
              size = {
                 love.graphics.getWidth() / 2,
                 "tight"
              },
              align="center"})
end

function GameOverScreen:draw()
   gui.core.draw()
end

return GameOverScreen
