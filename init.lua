local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

-- Translation support
local S = minetest.get_translator("iadecor")

-- Global
iadecor = {}

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

if  minetest.get_modpath("church_candles")
and minetest.get_modpath("wine") then
	wine:add_item({ {"church_candles:honey_jar", "wine:glass_mead"} })
end

print ("[MOD] IA Decor loaded")
