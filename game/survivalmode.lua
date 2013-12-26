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
local gamestate = require("hump.gamestate")
local gui = require("quickie")
local Camera = require("hump.camera")
local HumanActorController = require("world.humanactorcontroller")
local SimpleAIActorController = require("world.simpleaiactorcontroller")
local Vector = require("hump.vector")
local World = require("world.world")

local SurvivalMode = class("game.SurvivalMode")

function SurvivalMode:enter()
   self._world = World:new()

   self._status_font = love.graphics.newFont(20)

   self._human_actor = Actor:new()
   self._human_actor:set_position(Vector.new(400, 240))
   self._human_actor:set_max_speed(256)
   self._human_actor:set_max_health(60)
   self._human_actor:set_health(60)
   local human_controller = HumanActorController:new(self._human_actor)
   self._human_actor:set_controller(human_controller)
   self._world:add(self._human_actor)

   self._human_actor.signals:register("on-death",
                                      function(actor)
                                         self:_on_human_actor_death(actor)
                                      end)

   self._score = 0

   self:_add_new_ai_actor()

   self._camera = Camera.new()
end

function SurvivalMode:update(dt)
   self._world:update(dt)

   local health = math.ceil(self._human_actor:get_health())
   local status_text = string.format("Health: %d\nScore: %d",
                                     health,
                                     self._score)
   local _, num_lines = self._status_font:getWrap(status_text,
                                                  love.graphics.getWidth())
   love.graphics.setFont(self._status_font)
   gui.Label({text = status_text,
              pos = {
                 32,
                 love.graphics.getHeight() - 32 -
                    self._status_font:getHeight() * num_lines
              },
              size = {"tight", "tight"},
              align = "bottom"})
end

function SurvivalMode:_add_new_ai_actor()
   local ai = Actor:new()
   ai:set_position(Vector.new(800, 240))
   ai:set_max_speed(128)
   ai:set_max_health(20)
   ai:set_health(20)
   local ai_controller = SimpleAIActorController:new(ai, self._human_actor)
   ai:set_controller(ai_controller)
   self._world:add(ai)

   ai.signals:register("on-death",
                       function(actor)
                          self:_on_ai_actor_death(actor)
                       end)
end

function SurvivalMode:_on_human_actor_death(actor)
   local GameOverScreen = require("game.gameoverscreen")
   gamestate.switch(GameOverScreen:new(), self._score)
end

function SurvivalMode:_on_ai_actor_death(actor)
   self._world:remove(actor)

   self._score = self._score + 1

   self:_add_new_ai_actor()
end

function SurvivalMode:draw()
   local camera_x =
      math.max(love.graphics.getWidth() / 2,
               math.min(self._world:get_width() -
                           love.graphics.getWidth() / 2,
                        self._human_actor:get_position().x))
   local camera_y =
      math.max(love.graphics.getHeight() / 2,
               math.min(self._world:get_height() -
                           love.graphics.getHeight() / 2,
                        self._human_actor:get_position().y))
   self._camera:lookAt(camera_x, camera_y)

   self._world:draw(self._camera)

   gui.core.draw()
end

return SurvivalMode
