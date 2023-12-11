local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

-- Translation support
local S = minetest.get_translator("iamobs")

-- Global
iadecor = {}

-- NPCs
--dofile(path .. "npc.lua")
minetest.override_item("homedecor:calendar", {
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		if not clicker:is_player() then
			return itemstack
		end
		calendar.show_calendar(clicker:get_player_name())
		return itemstack
	end,
})

print ("[MOD] IA Decor loaded")
