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
local Bomb = require("world.item.bomb")
local gamestate = require("hump.gamestate")
local gui = require("quickie")
local Camera = require("hump.camera")
local Crate = require("world.item.crate")
local Heart = require("world.item.heart")
local HumanActorController = require("world.humanactorcontroller")
local loader = require("love2d-assets-loader.Loader.loader")
local Missile = require("world.item.missile")
local Shapes = require("hardoncollider.shapes")
local SimpleAIActorController = require("world.simpleaiactorcontroller")
local Vector = require("hump.vector")
local World = require("world.world")

local SurvivalMode = class("game.SurvivalMode")

function SurvivalMode:enter()
   self._world = World:new()

   self._status_font = love.graphics.newFont(20)

   self._human_actor = Actor:new()
   self:_place_actor_at_random_position(self._human_actor)
   self._human_actor:set_max_speed(256)
   self._human_actor:set_max_health(100)
   self._human_actor:set_health(100)
   self._human_actor:set_image(loader.Image["arrow-blue"])
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
   local item = self._human_actor:get_held_item()
   local item_name = item and item:get_name() or "None"
   local status_text = string.format("Health: %d\nScore: %d\nItem: %s",
                                     health,
                                     self._score,
                                     item_name)
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

function SurvivalMode:_place_actor_at_random_position(actor)
   local position
   repeat
      position = Vector.new(math.random(0, self._world:get_width()),
                            math.random(0, self._world:get_height()))

      local shape = Shapes.newCircleShape(position.x,
                                          position.y,
                                          actor:get_radius())
    until not self._world:does_shape_collide(shape)

    actor:set_position(position)
end

function SurvivalMode:_add_new_ai_actor()
   local ai = Actor:new()
   self:_place_actor_at_random_position(ai)
   ai:set_max_speed(128)
   ai:set_max_health(20)
   ai:set_health(20)
   ai:set_image(loader.Image["arrow-black"])
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

   if math.random() < 0.75 then
      local item
      local rand = math.random()
      if rand < 0.5 then
         item = Heart:new()
      elseif rand < 0.75 then
         item = Bomb:new()
      else
         item = Missile:new()
      end
      local crate = Crate:new(actor:get_position(), item)
      self._world:add(crate)
   end

   self:_add_new_ai_actor()

   if self._score % 5 == 0 then
      self:_add_new_ai_actor()
   end
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
