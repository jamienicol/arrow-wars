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

local gamestate = require("hump.gamestate")
local gui = require("quickie")
local loader = require("love2d-assets-loader.Loader.loader")

local TitleScreen = require("game.titlescreen")

function love.load()
   math.randomseed(os.time())

   gui.keyboard.cycle.next = {key = "down"}
   gui.keyboard.cycle.prev = {key = "up"}

   loader.setBaseImageDir("data/images")
   loader.init()

   gamestate.registerEvents()
   gamestate.switch(TitleScreen:new())
end
