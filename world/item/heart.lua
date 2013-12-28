local class = require("middleclass.middleclass")
local Item = require("world.item.item")
local loader = require("love2d-assets-loader.Loader.loader")

local Heart = class("world.item.Heart", Item)

function Heart:initialize()
   Item.initialize(self)
end

function Heart:get_name()
   return "Heart"
end

function Heart:get_crate_image()
   return loader.Image["heart"]
end

function Heart:should_automatically_use()
   return true
end

function Heart:use(actor)
   actor:heal(10)
end

return Heart
