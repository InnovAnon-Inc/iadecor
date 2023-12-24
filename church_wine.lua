local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)
local path    = minetest.get_modpath(MODNAME).."/"

if  minetest.get_modpath("church_candles")
and minetest.get_modpath("wine") then
	-- 1 comb                       = 2 honey
	-- 2 honey           + 1 bottle = 1 honey bottle = 1 comb + 1 bottle
	-- 2 comb  + 2 honey + 2 bottle = 1 honey jar    = 3 comb + 2 bottle
--	wine:add_item({ {
--		{"church_candles:honey_bottled", "church_candles:honey_bottled", "church_candles:honey_bottled",},
--		"wine:glass_mead"
--	} })
--	wine:add_item({ {
--		"church_candles:honey_jar",
--		"wine:glass_mead"
--	} })
	wine:add_item({ {
		"church_candles:honey",
		"wine:glass_mead"
	} })
end

