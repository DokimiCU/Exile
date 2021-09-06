

liquid_store = {}
liquid_store.liquids = {}
liquid_store.stored_liquids = {}



--Liquids that it is possible to put in a bucket
function liquid_store.register_liquid(source, flowing, force_renew)

	liquid_store.liquids[source] = {
		source = source,
		flowing = flowing,
		force_renew = force_renew,
	}

end



local function check_protection(pos, name, text)
	if minetest.is_protected(pos, name) then
		minetest.log("action", (name ~= "" and name or "A mod")
			.. " tried to " .. text
			.. " at protected position "
			.. minetest.pos_to_string(pos)
			.. " with a bucket")
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end



--Function for empty buckets to call on_use... as return (so gives item)
function liquid_store.on_use_empty_bucket(itemstack, user, pointed_thing)

	if pointed_thing.type == "object" then
		pointed_thing.ref:punch(user, 1.0, { full_punch_interval=1.0 }, nil)
		return user:get_wielded_item()
	elseif pointed_thing.type ~= "node" then
		-- do nothing if it's neither object nor node
		return
	end


	-- Check if pointing to a liquid source
	local node = minetest.get_node(pointed_thing.under)
	local liquiddef = liquid_store.liquids[node.name]
	local item_count = user:get_wielded_item():get_count()

	if liquiddef ~= nil
	and node.name == liquiddef.source then
		if check_protection(pointed_thing.under, user:get_player_name(),"take ".. node.name) then
			return nil
		end

		--find a registered stored liquid who has an empty that matches what we are using
		--and a source that matches our liquid
		local giving_back
		local empty = itemstack:get_name()


		for k, v in pairs(liquid_store.stored_liquids) do
			local m = v.nodename_empty
			local s = v.source
			if  m == empty and s == node.name then
				giving_back = v.nodename
				break
			end
		end


		if not giving_back then
			--nothing matches
			return nil
		end

		-- check if holding more than 1 empty bucket
		if item_count > 1 then

			-- if space in inventory add filled bucked, otherwise drop as item
			local inv = user:get_inventory()
			if inv:room_for_item("main", {name = giving_back}) then
				inv:add_item("main", giving_back)
			else
				local pos = user:get_pos()
				pos.y = math.floor(pos.y + 0.5)
				minetest.add_item(pos, giving_back)
			end

			-- set to return empty buckets minus 1
			giving_back = empty.." ".. tostring(item_count-1)
		end

		-- force_renew requires a source neighbour
		local source_neighbor = false
		if liquiddef.force_renew then
			source_neighbor =	minetest.find_node_near(pointed_thing.under, 1, liquiddef.source)
		end

		if not (source_neighbor and liquiddef.force_renew) then
			minetest.add_node(pointed_thing.under, {name = "air"})
		end

		return ItemStack(giving_back)

	else
		-- non-liquid nodes will have their on_punch triggered
		local node_def = minetest.registered_nodes[node.name]
		if node_def then
			node_def.on_punch(pointed_thing.under, node, user, pointed_thing)
		end
		return user:get_wielded_item()
	end

end




-- Register a new stored liquid...
--    source = name of the source node
--    nodename = name of the new bucket  (or nil if liquid is not takeable)
--    nodename_empty = name of the empty bucket
--    tiles  = textures of the new bucket
--    desc = text description of the bucket item
--    groups = (optional) groups of the bucket item, for example {water_bucket = 1}
--    force_renew = (optional) bool. Force the liquid source to renew if it has a
--                  source neighbour, even if defined as 'liquid_renewable = false'.
--                  Needed to avoid creating holes in sloping rivers.
-- This function can be called from any mod (that depends on liquid_store).
-- Also need to register the liquid itself seperately

function liquid_store.register_stored_liquid(source, nodename, nodename_empty, tiles, node_box, desc, groups)

	liquid_store.stored_liquids[nodename] = {
		nodename = nodename,
		source = source,
		nodename_empty = nodename_empty
	}


	if nodename ~= nil then
		minetest.register_node(nodename, {
			description = desc,
			tiles = tiles,
			drawtype = "nodebox",
			node_box = node_box,
			stack_max = 1,
			liquids_pointable = true,
			groups = groups,
			sounds = nodes_nature.node_sound_defaults(),

			on_use = function(itemstack, user, pointed_thing)
				-- Must be pointing to node
				if pointed_thing.type ~= "node" then
					return
				end

				local node = minetest.get_node_or_nil(pointed_thing.under)
				local ndef = node and minetest.registered_nodes[node.name]

				-- Call on_rightclick if the pointed node defines it
				if ndef and ndef.on_rightclick and
						not (user and user:is_player() and
						user:get_player_control().sneak) then
					return ndef.on_rightclick(
						pointed_thing.under,
						node, user,
						itemstack)
				end

				local lpos

				-- Check if pointing to a buildable node
				if ndef and ndef.buildable_to then
					-- buildable; replace the node
					lpos = pointed_thing.under
				else
					-- not buildable to; place the liquid above
					-- check if the node above can be replaced

					lpos = pointed_thing.above
					node = minetest.get_node_or_nil(lpos)
					local above_ndef = node and minetest.registered_nodes[node.name]

					if not above_ndef or not above_ndef.buildable_to then
						-- do not remove the bucket with the liquid
						return itemstack
					end
				end

				if check_protection(lpos, user
						and user:get_player_name()
						or "", "place "..source) then
					return
				end

				minetest.set_node(lpos, {name = source})

				-- More sophisticated inventory management.
				-- If original stack has more than one item, return the others to the player instead of destroying them
				if itemstack:get_count() > 1 then
					player_inv = user:get_inventory()
					if player_inv:room_for_item("main", nodename_empty) then
						player_inv:add_item("main", nodename_empty)
					else
						local player_pos = user:get_pos()
	   					minetest.add_item(pos, nodename_empty)
					end

					return ItemStack(itemstack:get_name().." "..(itemstack:get_count() - 1))
				else
					return ItemStack(nodename_empty)
				end
			end,
		})

	end
end




---------------------------------------------------------
--Register liquids
liquid_store.register_liquid(
	"nodes_nature:salt_water_source",
	"nodes_nature:salt_water_flowing",
	false)

liquid_store.register_liquid(
	"nodes_nature:freshwater_source",
	"nodes_nature:freshwater_flowing",
	false)
	--don't force renew or allows an infinite water supply exploit
