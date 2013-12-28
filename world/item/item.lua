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
