local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)
local path    = minetest.get_modpath(MODNAME).."/"

local make_on_use = function(def, bug_node)
	assert(def ~= nil)
	assert(bug_node ~= nil)
	return function(itemstack, user, pointed_thing)
		assert(itemstack ~= nil)
		assert(user ~= nil)
		assert(pointed_thing ~= nil) -- TODO
		print('on use')
		-- TODO if pointed_thing is player or food
		--print('user: '..user)
		--print('pointed thing type: '..pointed_thing.type)
		if pointed_thing.type == "object" then
			print('pointed_thing object')
			local ref = pointed_thing.ref
			local ent = ref:get_luaentity()
			if ref:is_player() then
				print('pointed_thing ref is player')
			end
			if ent ~= nil and ent:is_player() then
				print('pointed_thing ent is player')
			end
			if ref:is_player() or (ent ~= nil and ent:is_player()) then
				print('pointed_thing player')

				-- TODO this doesn't seem to be doing damage
				ent:on_punch(user, nil, nil, nil, 1)

				-- TODO shit out the bugs after some time
				--local meta = ref:get_meta()
				--meta:set_int(bug_node, 1)
				--local pos = pointed_thing.above
				--if pos == nil then pos = pointed_thing.under end
				local pos = ref:get_pos()
				if pos == nil then pos = ent:get_pos() end
				assert(pos ~= nil)
				local lower_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
				if minetest.is_protected(pos, ref:get_player_name()) or
					minetest.get_node(lower_pos).name ~= "air" then
					return
				end
	
				local upper_pos = {x = pos.x, y = pos.y + 2, z = pos.z}
				local firefly_pos
	
				if not minetest.is_protected(upper_pos, ref:get_player_name()) and
						minetest.get_node(upper_pos).name == "air" then
					firefly_pos = upper_pos
				elseif not minetest.is_protected(lower_pos, ref:get_player_name()) then
					firefly_pos = lower_pos
				end
	
				if firefly_pos then
					--minetest.set_node(pos, {name = "vessels:glass_bottle"})
					minetest.set_node(firefly_pos, {name = bug_node})
					minetest.get_node_timer(firefly_pos):start(1)
				end

				itemstack:set_name("vessels:glass_bottle")
			end
		end
		--if def.on_use ~= nil then
		--	return def.on_use(itemstack, user, pointed_thing)
		--end
		return itemstack
	end
end










































if  minetest.get_modpath("church_candles")
and minetest.get_modpath("fireflies") then
	local def = minetest.registered_nodes["church_candles:busybees"]
	local grp = table.copy(def.groups)
	grp.catchable = 1
	minetest.override_item("church_candles:busybees", {
		groups = grp,
		pointable = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
		},
	})

	local image = "church_candles_hive_bee.png"
	--image = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:64x64]:18,29="..image.."\\^\\[resize\\:23x23"
	--image = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:44x44]:18,29="..image.."\\^\\[resize\\:23x23"
	image = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:64x64]:20,33="..image.."\\^\\[resize\\:18x18"
	--local anim = "church_candles_hive_busybees.png"
	--anim = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:64x64]:7,27="..anim.."\\^\\[resize\\:23x23"
	minetest.register_node("iadecor:busybees_bottle", {
		description = S("Busy Bees in a Bottle"),
		inventory_image = image, 
		wield_image = image,
		tiles = {{
			--name = anim, -- TODO put it in the jar
			--animation = {
			--	type = "vertical_frames",
			--	aspect_w = 16,
			--	aspect_h = 16,
			--	length = 2,
			--},
			name = "fireflies_bottle_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5
			},
		}},
		drawtype = "plantlike",
		paramtype = "light",
		sunlight_propagates = true,
		--light_source = 9,
		walkable = false,
		groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
		selection_box = {
			type = "fixed",
			fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
		},
		sounds = default.node_sound_glass_defaults(),
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			local lower_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
			if minetest.is_protected(pos, player:get_player_name()) or
					minetest.get_node(lower_pos).name ~= "air" then
				return
			end
	
			local upper_pos = {x = pos.x, y = pos.y + 2, z = pos.z}
			local firefly_pos
	
			if not minetest.is_protected(upper_pos, player:get_player_name()) and
					minetest.get_node(upper_pos).name == "air" then
				firefly_pos = upper_pos
			elseif not minetest.is_protected(lower_pos, player:get_player_name()) then
				firefly_pos = lower_pos
			end
	
			if firefly_pos then
				minetest.set_node(pos, {name = "vessels:glass_bottle"})
				minetest.set_node(firefly_pos, {name = "church_candles:busybees"})
				minetest.get_node_timer(firefly_pos):start(1)
			end
		end,
		on_use = make_on_use(minetest.registered_nodes["fireflies:firefly_bottle"], "church_candles:busybees"),--"bees"),
	})

	minetest.register_craft( {
		output = "iadecor:busybees_bottle",
		recipe = {
			{"church_candles:busybees"},
			{"vessels:glass_bottle"}
		}
	})
end

if  minetest.get_modpath("church_candles")
and minetest.get_modpath("butterflies") then

	for _, color in ipairs({"white", "red", "violet",}) do
		local image = "butterflies_butterfly_"..color..".png"
		image = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:64x64]:20,33="..image.."\\^\\[resize\\:18x18"
		minetest.register_node("iadecor:butterfly_bottle_"..color, {
			description = S(color.." Butterfly in a Bottle"),
			inventory_image = image, 
			wield_image = image,
			tiles = {{
				name = "fireflies_bottle_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 1.5
				},
				--name = "butterflies_butterfly_"..name.."_animated.png",
				--animation = {
				--	type = "vertical_frames",
				--	aspect_w = 16,
				--	aspect_h = 16,
				--	length = 3
				--},
			}},
			drawtype = "plantlike",
			paramtype = "light",
			sunlight_propagates = true,
			--light_source = 9,
			walkable = false,
			groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
			selection_box = {
				type = "fixed",
				fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
			},
			sounds = default.node_sound_glass_defaults(),
			on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				local lower_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
				if minetest.is_protected(pos, player:get_player_name()) or
						minetest.get_node(lower_pos).name ~= "air" then
					return
				end
	
				local upper_pos = {x = pos.x, y = pos.y + 2, z = pos.z}
				local firefly_pos
	
				if not minetest.is_protected(upper_pos, player:get_player_name()) and
						minetest.get_node(upper_pos).name == "air" then
					firefly_pos = upper_pos
				elseif not minetest.is_protected(lower_pos, player:get_player_name()) then
					firefly_pos = lower_pos
				end
	
				if firefly_pos then
					minetest.set_node(pos, {name = "vessels:glass_bottle"})
					minetest.set_node(firefly_pos, {name = "butterflies:butterfly_"..color})
					minetest.get_node_timer(firefly_pos):start(1)
				end
			end,
			on_use = make_on_use(minetest.registered_nodes["fireflies:firefly_bottle"], "butterflies:butterfly_"..color),--"butterflies"),
		})

		minetest.register_craft( {
			output = "iadecor:butterfly_bottle_"..color,
			recipe = {
				{"butterflies:butterfly_"..color},
				{"vessels:glass_bottle"},
			}
		})
	end
end

if minetest.get_modpath("fireflies") then
	local name = "fireflies:firefly_bottle"
	minetest.override_item(name, {
		on_use = make_on_use(minetest.registered_nodes[name], "fireflies:firefly"),--"fireflies"),
	})
end
