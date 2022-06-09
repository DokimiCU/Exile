--
-- Register Egg
--for capturing and respawing unique animals
--

local create_mob = function(placer, itemstack, name, pos)
	local meta = itemstack:get_meta()
	local meta_table = meta:to_table()
	local memory
	if meta_table.fields.memory then
		memory=minetest.deserialize(meta_table.fields.memory)

	end
	local sdata = minetest.serialize(meta_table)
	local mob = minetest.add_entity(pos, name, sdata)

	local ent = mob:get_luaentity()
	if memory then
		for key,value in pairs(memory) do
			mobkit.remember(ent,key,value)
		end
	end
	itemstack:take_item() -- since mob is unique we remove egg once spawned
	return ent
end



local pos_to_spawn = function(name, pos)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	if minetest.registered_entities[name] and minetest.registered_entities[name].visual_size.x then
		if minetest.registered_entities[name].visual_size.x >= 32 and
			minetest.registered_entities[name].visual_size.x <= 48 then
				y = y + 2
		elseif minetest.registered_entities[name].visual_size.x > 48 then
			y = y + 5
		else
			y = y + 1
		end
	end
	local spawn_pos = { x = x, y = y, z = z}
	return spawn_pos
end


--use stunning weapon plus chance to catch
animals.stun_catch_mob = function(self, clicker,chance)
	local item = clicker:get_wielded_item()
	item = item:get_name()
	item = minetest.get_item_group(item,"club")

	if item ~=0 then
		--hit
		mobkit.make_sound(self,'punch')
		--catch chance
		if math.random() < chance then
			mobkit.make_sound(self,'punch')
			animals.capture(self, clicker)
		end
	end
end





animals.register_egg = function(name, desc, inv_img, stack, energy)
	local grp = {spawn_egg = 1}
	minetest.register_craftitem(name, { -- register new spawn egg containing mob information
		description = desc,
		inventory_image = inv_img,
		--groups = {},
		stack_max = stack,
		on_place = function(itemstack, placer, pointed_thing)
			local spawn_pos = pointed_thing.above
			-- am I clicking on something with existing on_rightclick function?
			local under = minetest.get_node(pointed_thing.under)
			local def = minetest.registered_nodes[under.name]
			if def and def.on_rightclick then
				return def.on_rightclick(pointed_thing.under, under, placer, itemstack)
			end
			if spawn_pos and not minetest.is_protected(spawn_pos, placer:get_player_name()) then
				if not minetest.registered_entities[name] then
					return
				end
				spawn_pos = pos_to_spawn(name, spawn_pos)
				local ent = create_mob(placer, itemstack, name, spawn_pos)
				--set energy value
				if not mobkit.recall(ent,'energy') then
					--# of seconds it will survive without food
					mobkit.remember(ent,'energy',energy)
				end
			end
			return itemstack
		end,
	})
end





animals.capture = function(self, clicker)
	local new_stack = ItemStack(self.name) 	-- add special mob egg with all mob information
	local stack_meta = new_stack:get_meta()
	--local sett ="---TABLE---: "
	--local sett = ""
	--local i = 0
	for key, value in pairs(self) do
		local what_type = type(value)
		if what_type ~= "function"
		and what_type ~= "nil"
		and what_type ~= "userdata"
		then
			if what_type == "boolean" or what_type == "number" then
				value = tostring(value)
			end
			if key == 'memory' then 
				value = minetest.serialize(value)
			end
			stack_meta:set_string(key, value)
		end
	end


	local inv = clicker:get_inventory()
	local pname = clicker:get_player_name()
	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
	else
		minetest.add_item(clicker:get_pos(), new_stack)
	end

	self.object:remove()
	return stack_meta
end
