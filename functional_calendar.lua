local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)
local path    = minetest.get_modpath(MODNAME).."/"

if  minetest.get_modpath("homedecor_office")
and minetest.get_modpath("calendar") then
	minetest.override_item("homedecor:calendar", {
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			if not clicker:is_player() then
				return itemstack
			end
			calendar.show_calendar(clicker:get_player_name())
			return itemstack
		end,
	})
end

