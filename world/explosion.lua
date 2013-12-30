local class = require("middleclass.middleclass")
local loader = require("love2d-assets-loader.Loader.loader")
local Shapes = require("hardoncollider.shapes")

local Explosion = class("world.Explosion")

function Explosion:initialize(position)

   self._position = position
   self._radius = 128

   -- damage per second caught in the blast
   self._damage = 50

   -- time remaining until the explosion disappears
   self._time_remaining = 0.5

   self._bbox = Shapes.newCircleShape(self._position.x,
                                      self._position.y,
                                      self._radius)
   self._bbox.type = "explosion"
   self._bbox.object = self
end

function Explosion:get_bbox()
   return self._bbox
end

function Explosion:on_collision(dt, shape, mtv_x, mtv_y)
   if shape.type == "actor" then
      local actor = shape.object
      actor:take_damage(self._damage * dt)
   end
end

function Explosion:update(dt)
   self._time_remaining = self._time_remaining - dt
   if self._time_remaining <= 0 then
      self._world:remove(self)
   end
end

function Explosion:draw()
   local image = loader.Image["explosion"]
   love.graphics.draw(image,
                      self._position.x, self._position.y,
                      0,
                      1, 1,
                      self._radius,
                      self._radius)
end

return Explosion