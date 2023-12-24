local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)
local path    = minetest.get_modpath(MODNAME).."/"

if minetest.get_modpath("church_cross") then
	local nam, def, grp
	for _, basename in ipairs({"gold", "steel",}) do
		nam              = "church_cross:cross_"..basename
		def              = minetest.registered_nodes[nam]
		grp              = table.copy(def.groups)
		grp.church_cross = 1
		minetest.override_item("church_cross:cross_"..basename, {
			on_rotate = function(pos, node, user, mode, new_param2)
			end,
			groups = grp,
		})

		nam              = "church_cross:wallcross_"..basename
		def              = minetest.registered_nodes[nam]
		grp              = table.copy(def.groups)
		grp.church_cross = 1
		minetest.override_item("church_cross:wallcross_"..basename, {
			on_rotate = function(pos, node, user, mode, new_param2)
			end,
			groups = grp,
		})
	end

	for _, basename in ipairs({"stone", "wood",}) do
		nam              = "church_cross:cross_"..basename
		def              = minetest.registered_nodes[nam]
		grp              = table.copy(def.groups)
		grp.church_cross = 1
		minetest.override_item("church_cross:cross_"..basename, {
			on_rotate = function(pos, node, user, mode, new_param2)
			end,
			groups = grp,
		})
	end

	iadecor.register_cross = function( basename, texture, description, craft_from, mat_sounds, wallcross, normalcross )
		local group_def = {cracky = 3, oddly_breakable_by_hand = 2, church_cross = 1,};

		if normalcross then
			minetest.register_node('iadecor:cross_'..basename, {
				description = description.. ' Cross',
				tiles = {texture },
				drawtype = 'nodebox',
				paramtype = 'light',
				paramtype2 = 'facedir',
				light_source = 7,
				sunlight_propagates = true,
				is_ground_content = false,
				buildable_to = false,
				--on_rotate = screwdriver.rotate_simple,
				groups = group_def,
				sounds = mat_sounds,
				node_box = {
					type = 'fixed',
					fixed = {
						{-0.0625, -0.5, -0.0625, 0.0625, 0.4375, 0.0625},
						{-0.25, 0.0625, -0.0625, 0.25, 0.1875, 0.0625},
					}
				},
				selection_box = {
					type = 'fixed',
					fixed = {
						{-0.375, -0.5, -0.0625, 0.375, 0.5, 0.0625},
					},
				},
			})
		end

		if wallcross then
			minetest.register_node('iadecor:wallcross_'..basename, {
				description = description.. ' Wall Cross',
				tiles = {texture },
				--groups = {oddly_breakable_by_hand = 3},
				groups = group_def,
				drawtype = 'nodebox',
				paramtype = 'light',
				paramtype2 = 'facedir',
				sunlight_propagates = true,
				is_ground_content = false,
				buildable_to = false,
				light_source = 7,
				sounds = mat_sounds,
				--on_rotate = screwdriver.rotate_simple, --no upside down crosses :)
				node_box = {
					type = 'fixed',
					fixed = {
						{-0.0625, -0.3125, 0.4375, 0.0625, 0.3125, 0.5},
						{-0.1875, 0, 0.4375, 0.1875, 0.125, 0.5},
					}
				},
				selection_box = {
					type = 'fixed',
					fixed = {
						{-0.25, -0.5, 0.375, 0.25, 0.375, 0.5},
					}
				}
			})
		end

		-----------
		-- Crafting
		-----------
		if normalcross then
			minetest.register_craft({
				output = 'iadecor:cross_'..basename,
				recipe = {
					{'', craft_from, ''},
					{'default:stick', 'default:stick', 'default:stick'},
					{'', 'default:stick', ''}
				}
			})
		end
	
		if wallcross then
			minetest.register_craft({
				output = 'iadecor:wallcross_'..basename,
				recipe = {
					{'iadecor:cross_'..basename},
				}
			})
		end
	end

	----------
	-- Cooking
	----------
	--minetest.register_craft({
	--	type = 'cooking',
	--	output = 'default:gold_ingot',
	--	recipe = 'church_cross:wallcross_gold',
	--	cooktime = 5,
	--})

	--------------------------
	-- Register Node Materials
	--------------------------

	local metal_sounds = nil
	local stone_sounds = nil
	local wood_sounds = nil
	if minetest.get_modpath("sounds") then
		metal_sounds = sounds.node_metal()
		stone_sounds = sounds.node_stone()
		wood_sounds = sounds.node_wood()
	elseif minetest.get_modpath("default") then
		metal_sounds = default.node_sound_metal_defaults()
		stone_sounds = default.node_sound_stone_defaults()
		wood_sounds = default.node_sound_wood_defaults()
	elseif minetest.get_modpath("hades_sounds") then
		metal_sounds = hades_sounds.node_sound_metal_defaults()
		stone_sounds = hades_sounds.node_sound_stone_defaults()
		wood_sounds = hades_sounds.node_sound_wood_defaults()
	end

	local items = {
		gold_ingot = "default:gold_ingot",
		steel_ingot = "default:steel_ingot",
		stone = "default:stone",
		wood = "default:stick",
	}

	if minetest.get_modpath("hades_core") then
		items.gold_ingot = "hades_core:gold_ingot"
		items.steel_ingot = "hades_core:steel_ingot"
		items.stone = "hades_core:stone"
		items.wood = "hades_core:stick"
	end

	iadecor.register_cross( 'stone', 'default_stone.png', 'Stone', items.stone, stone_sounds, true, false)
	iadecor.register_cross( 'wood', 'default_pine_wood.png^[transformR90', 'Wood', items.wood, wood_sounds, true, false)
	minetest.register_alias("iadecor:cross_stone", "church_cross:cross_stone")
	minetest.register_alias("iadecor:cross_wood",  "church_cross:cross_wood")
	--minetest.register_alias("church_cross:cross_stone", "iadecor:cross_stone")
	--minetest.register_alias("church_cross:cross_wood", "iadecor:cross_wood")
end

