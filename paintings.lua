local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)
local path    = minetest.get_modpath(MODNAME).."/"

if minetest.get_modpath("homedecor_pictures_and_paintings") then
	local wood_tex = homedecor.textures.default_wood
	local p_cbox = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, 0.4375, 0.5, 0.5, 0.5 }
		}
	}
	for i=21,90,1 do
		homedecor.register("painting_"..i, {
			description = S("Decorative painting #@1", i),
			mesh = "homedecor_painting.obj",
			tiles = {
				wood_tex,
				"homedecor_blank_canvas.png",
				"homedecor_painting"..i..".png"
			},
			selection_box = p_cbox,
			walkable = false,
			groups = {snappy=3, dig_tree = 3},
			_sound_def = {
				key = "node_sound_wood_defaults",
			},
		})
	end
end

-- TODO recipes
