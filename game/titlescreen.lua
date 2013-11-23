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

local gamestate = require("hump.gamestate")
local gui = require("quickie")
local SurvivalMode = require("game.survivalmode")

local TitleScreen = class("game.TitleScreen")

function TitleScreen:enter()
   self._title_font = love.graphics.newFont(45)
   self._menu_font = love.graphics.newFont(25)
   self._menu_width = 200
   self._menu_height = 36
end

function TitleScreen:keypressed(key, unicode)
   gui.keyboard.pressed(key, unicode)
end

function TitleScreen:update(dt)

   love.graphics.setFont(self._title_font)

   gui.Label({text = "Arrow Wars",
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

   if gui.Button({text = "Play",
                  size = {self._menu_width, self._menu_height}}) then
      gamestate.switch(SurvivalMode:new())
   end

   if gui.Button({text = "Quit",
                  size = {self._menu_width, self._menu_height}}) then
      love.event.quit()
   end

   gui.group.pop()
end

function TitleScreen:draw()
   gui.core.draw()
end

return TitleScreen
