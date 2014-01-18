--[[
Copyright (C) 2014 Jamie Nicol <jamie@thenicols.net>

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
local loader = require("love2d-assets-loader.Loader.loader")

local PauseScreen = class("game.PauseScreen")

function PauseScreen:enter(previous)
   self._previous_state = previous

   self._title_font = loader.Font[45]
   self._menu_font = loader.Font[25]
   self._menu_width = 200
   self._menu_height = 36
end

function PauseScreen:keypressed(key, unicode)
   gui.keyboard.pressed(key, unicode)

   if key == "escape" then
      gamestate.pop()
   end
end

function PauseScreen:update(dt)

   love.graphics.setFont(self._title_font)

   gui.Label({text = "Paused",
              pos = {
                 love.graphics.getWidth() / 4,
                 32
              },
              size = {
                 love.graphics.getWidth() / 2,
                 "tight"
              },
              align="center"})

   gui.group.push({grow = "down",
                   pos = {
                      (love.graphics.getWidth() - self._menu_width) / 2,
                      love.graphics.getHeight() / 2
                   },
                   spacing = 4,
                   align="center"})

   love.graphics.setFont(self._menu_font)

   if gui.Button({text = "Resume",
                  size = {self._menu_width, self._menu_height}}) then
      gamestate.pop()
   end

   if gui.Button({text = "Quit",
                  size = {self._menu_width, self._menu_height}}) then
      local TitleScreen = require("game.titlescreen")
      gamestate.switch(TitleScreen:new())
   end

   gui.group.pop()
end

function PauseScreen:draw()
   self._previous_state:draw()

   gui.core.draw()
end

return PauseScreen
