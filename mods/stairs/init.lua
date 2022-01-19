-- Minetest 0.4 mod: stairs
-- See README.txt for licensing and other information.


-- Global namespace for functions

stairs = {}


-- Get setting for replace ABM

local replace = minetest.settings:get_bool("enable_stairs_replace_abm")

local function rotate_and_place(itemstack, placer, pointed_thing)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0

	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end

		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1

		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
				or (fpos < -0.5 and fpos > -0.999999999) then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	return minetest.item_place(itemstack, placer, pointed_thing, param2)
end


-- Register stair
-- Node will be called stairs:stair_<subname>

function stairs.register_stair(subname, recipeitem, craft_station, recycle, groups, images, description,
		stack_size, sounds, worldaligntex, droptype)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	minetest.register_node(":stairs:stair_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = stair_images,
		stack_max = stack_size,
		paramtype = "light",
		paramtype2 = "facedir",
		drop = droptype,
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	-- for replace ABM
	if replace then
		minetest.register_node(":stairs:stair_" .. subname .. "upside_down", {
			replace_name = "stairs:stair_" .. subname,
			groups = {slabs_replace = 1},
		})
	end

	if recipeitem then
		-- Recipes
		crafting.register_recipe({
			type = craft_station,
			output = "stairs:stair_" .. subname.. " 2",
			items = {recipeitem},
			level = 1,
			always_known = true,
		})

		-- Recycle recipe
		if recycle == "true" then
			crafting.register_recipe({
				type = "mixing_spot",
				output = recipeitem,
				items = {"stairs:stair_" .. subname.. " 2"},
				level = 1,
				always_known = true,
			})
		end

	end
end


-- Register slab
-- Node will be called stairs:slab_<subname>

function stairs.register_slab(subname, recipeitem, craft_station, recycle, groups, images, description,
		stack_size, sounds, worldaligntex, droptype)
	-- Set world-aligned textures
	local slab_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			slab_images[i] = {
				name = image,
			}
			if worldaligntex then
				slab_images[i].align_style = "world"
			end
		else
			slab_images[i] = table.copy(image)
			if worldaligntex and image.align_style == nil then
				slab_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.slab = 1
	minetest.register_node(":stairs:slab_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = slab_images,
		stack_max = stack_size,
		paramtype = "light",
		paramtype2 = "facedir",
		drop = droptype,
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			local under = minetest.get_node(pointed_thing.under)
			local wield_item = itemstack:get_name()
			local player_name = placer and placer:get_player_name() or ""
			local creative_enabled = (creative and creative.is_enabled_for
					and creative.is_enabled_for(player_name))

			if under and under.name:find("^stairs:slab_") then
				-- place slab using under node orientation
				local dir = minetest.dir_to_facedir(vector.subtract(
					pointed_thing.above, pointed_thing.under), true)

				local p2 = under.param2

				-- Placing a slab on an upside down slab should make it right-side up.
				if p2 >= 20 and dir == 8 then
					p2 = p2 - 20
				-- same for the opposite case: slab below normal slab
				elseif p2 <= 3 and dir == 4 then
					p2 = p2 + 20
				end

				-- else attempt to place node with proper param2
				minetest.item_place_node(ItemStack(wield_item), placer, pointed_thing, p2)
				if not creative_enabled then
					itemstack:take_item()
				end
				return itemstack
			else
				return rotate_and_place(itemstack, placer, pointed_thing)
			end
		end,
	})

	-- for replace ABM
	if replace then
		minetest.register_node(":stairs:slab_" .. subname .. "upside_down", {
			replace_name = "stairs:slab_".. subname,
			groups = {slabs_replace = 1},
		})
	end

	if recipeitem then
		-- Recipes
		crafting.register_recipe({
			type = craft_station,
			output = "stairs:slab_" .. subname.. " 2",
			items = {recipeitem},
			level = 1,
			always_known = true,
		})

		-- Recycle recipe
		if recycle == "true" then
			crafting.register_recipe({
				type = "mixing_spot",
				output = recipeitem,
				items = {"stairs:slab_" .. subname.. " 2"},
				level = 1,
				always_known = true,
			})
		end

	end
end


-- Optionally replace old "upside_down" nodes with new param2 versions.
-- Disabled by default.

if replace then
	minetest.register_abm({
		label = "Slab replace",
		nodenames = {"group:slabs_replace"},
		interval = 16,
		chance = 1,
		action = function(pos, node)
			node.name = minetest.registered_nodes[node.name].replace_name
			node.param2 = node.param2 + 20
			if node.param2 == 21 then
				node.param2 = 23
			elseif node.param2 == 23 then
				node.param2 = 21
			end
			minetest.set_node(pos, node)
		end,
	})
end


-- Register inner stair
-- Node will be called stairs:stair_inner_<subname>

function stairs.register_stair_inner(subname, recipeitem, craft_station, recycle, groups, images,
		description, stack_size, sounds, worldaligntex, droptype)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	minetest.register_node(":stairs:stair_inner_" .. subname, {
		description = "Inner " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		stack_max = stack_size,
		paramtype = "light",
		paramtype2 = "facedir",
		drop = droptype,
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
				{-0.5, 0.0, -0.5, 0.0, 0.5, 0.0},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	if recipeitem then
		-- Recipes
		crafting.register_recipe({
			type = craft_station,
			output = "stairs:stair_inner_" .. subname.. " 2",
			items = {recipeitem},
			level = 1,
			always_known = true,
		})

		-- Recycle recipe
		if recycle == "true" then
			crafting.register_recipe({
				type = "mixing_spot",
				output = recipeitem,
				items = {"stairs:stair_inner_" .. subname.. " 2"},
				level = 1,
				always_known = true,
			})
		end

	end
end


-- Register outer stair
-- Node will be called stairs:stair_outer_<subname>

function stairs.register_stair_outer(subname, recipeitem, craft_station, recycle, groups, images,
		description, stack_size, sounds, worldaligntex, droptype)
	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	minetest.register_node(":stairs:stair_outer_" .. subname, {
		description = "Outer " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		stack_max = stack_size,
		paramtype = "light",
		paramtype2 = "facedir",
		drop = droptype,
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.0, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})

	if recipeitem then
		-- Recipes
		crafting.register_recipe({
			type = craft_station,
			output = "stairs:stair_outer_" .. subname.. " 2",
			items = {recipeitem},
			level = 1,
			always_known = true,
		})

		-- Recycle recipe
		if recycle == "true" then
			crafting.register_recipe({
				type = "mixing_spot",
				output = recipeitem,
				items = {"stairs:stair_outer_" .. subname.. " 2"},
				level = 1,
				always_known = true,
			})
		end

	end
end


-- Stair/slab registration function.
-- Nodes will be called stairs:{stair,slab}_<subname>

function stairs.register_stair_and_slab(subname, recipeitem, craft_station,
		recycle, groups, images, desc_stair, desc_slab, stack_size,
		sounds, worldaligntex, droptypemain)
        local droptype = nil
        local droptypesub = ""
        if droptypemain ~= nil then
	   -- 50% chance to drop the whole node if no stair/slabs exist
	   droptype = { max_items = 1,items = {
			   {rarity = 2, items = {droptypemain} }
		      }}
	   --Else remove the modname so we can build the stairs names if they do
	   droptypesub = string.split(droptypemain,":")[2]
	end
        local stexist = minetest.registered_nodes["stairs:stair_"..droptypesub]
        if stexist then droptype = "stairs:stair_"..droptypesub end
	stairs.register_stair(subname, recipeitem, craft_station, recycle, groups, images, desc_stair, stack_size,
		sounds, worldaligntex, droptype)
        if stexist then droptype = "stairs:stair_inner_"..droptypesub end
	stairs.register_stair_inner(subname, recipeitem, craft_station, recycle, groups, images, desc_stair, stack_size,
		sounds, worldaligntex, droptype)
        if stexist then droptype = "stairs:stair_outer_"..droptypesub end
	stairs.register_stair_outer(subname, recipeitem, craft_station, recycle, groups, images, desc_stair, stack_size,
		sounds, worldaligntex, droptype)
        if stexist then droptype = "stairs:slab_"..droptypesub end
	stairs.register_slab(subname, recipeitem, craft_station, recycle, groups, images, desc_slab, stack_size,
		sounds, worldaligntex, droptype)
end
