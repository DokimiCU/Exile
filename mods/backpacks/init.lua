backpacks = {}

-- Internationalization
local S = minetest.get_translator("backpacks")

local function get_formspec(pos, w, h)
	local main_offset = 0.85 + h

	local formspec = {
		"size[8,7]",
		"list[current_name;main;0,0.3;"..w..","..h.."]",
		"list[current_player;main;0,"..main_offset..";8,2]",
		"listring[current_name;main]",
		"listring[current_player;main]",}

	return table.concat(formspec, "")
end

local on_construct = function(pos, width, height)
	local meta = minetest.get_meta(pos)

	meta:set_string("infotext", S("Backpack"))
	local form = get_formspec(pos, width, height)
	meta:set_string("formspec", form)

	local inv = meta:get_inventory()
	inv:set_size("main", width*height)
end

local after_place_node = function(pos, placer, itemstack, pointed_thing)
	if minetest.is_player(placer) == true then
	   local node = minetest.get_node(pos)
	   local face = { x = 0, y = 0, z = 1}
	   local axis = { x = 0, y = 1, z = 0}
	   local ldir = placer:get_look_horizontal()
	   ldir = vector.rotate_around_axis(face, axis, ldir)
	   local ndir = minetest.dir_to_wallmounted(ldir)
	   local color = minetest.strip_param2_color(node.param2,
						     "colorwallmounted")
	   node.param2 = color + ndir
	   minetest.swap_node(pos, node)
	end
	local meta = minetest.get_meta(pos)
	local stuff = minetest.deserialize(itemstack:get_metadata())
	if stuff then
		meta:from_table(stuff)
	end
	itemstack:take_item()
end

local on_dig = function(pos, node, digger, width, height)
	if minetest.is_protected(pos, digger:get_player_name()) then
		return false
	end
	local meta = minetest.get_meta(pos)
	local desc = meta:get_string('description')---
	local inv = meta:get_inventory()
	local list = {}
	for i, stack in ipairs(inv:get_list("main")) do
		if stack:get_name() == "" then
			list[i] = ""
		else
			list[i] = stack:to_string()
		end
	end
	local new_list = {inventory = {main = list},
			fields = {infotext = S("Backpack"), formspec = get_formspec(pos, width, height), meta:set_string("description", desc)}}
	local new_list_as_string = minetest.serialize(new_list)
	local new = ItemStack(node)
	new:set_metadata(new_list_as_string)
	local color = minetest.strip_param2_color(node.param2,
						  "colorwallmounted")
	new:get_meta():set_int("palette_index", color)
	local player_inv = digger:get_inventory()
	if player_inv:room_for_item("main", new) then
		player_inv:add_item("main", new)
		minetest.remove_node(pos)
	end
end

local allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	if not string.match(stack:get_name(), "backpacks:") then
		return stack:get_count()
	else
		return 0
	end
end

wallmount_box = {
   type = "fixed",
   fixed = {
      {-0.4375, -0.375, -0.5, 0.4375, 0.375, 0.5}, -- NodeBox1
      {0.125, -0.5, -0.375, 0.375, -0.4375, 0.3125}, -- NodeBox2
      {-0.375, -0.5, -0.375, -0.125, -0.4375, 0.3125}, -- NodeBox3
      {0.125, -0.4375, 0.1875, 0.375, -0.375, 0.375}, -- NodeBox4
      {-0.375, -0.4375, 0.1875, -0.125, -0.375, 0.375}, -- NodeBox5
      {0.125, -0.4375, -0.375, 0.375, -0.375, -0.25}, -- NodeBox6
      {-0.375, -0.4375, -0.375, -0.125, -0.375, -0.25}, -- NodeBox7
      {-0.3125, 0.375, -0.375, 0.3125, 0.4375, 0.1875}, -- NodeBox8
      {-0.25, 0.4375, -0.315, 0.25, 0.5, 0.125}, -- NodeBox9
   }
}


-- backpacks
function backpacks.register_backpack(name, desc, texture, width, height, groups, sounds)

	minetest.register_node(":backpacks:backpack_"..name, {
		description = desc,
		tiles = { -- rotated onto its back for correct wallmounted dirs
		   texture.."^backpacks_backpack_front.png",     -- Front
		   texture.."^backpacks_backpack_back.png",      -- Back
		   texture.."^backpacks_backpack_sides-rotated.png",-- Right Side
		   texture.."^backpacks_backpack_sides-rotated.png",-- Left Side
		   texture.."^backpacks_backpack_topbottom.png", -- Top
		   texture.."^backpacks_backpack_topbottom.png", -- Bottom
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "colorwallmounted",
		palette = "natural_dyes.png",
		node_box = wallmount_box,
		groups = groups,
		stack_max = 1,
		sounds = sounds,
		on_construct = function(pos)
			on_construct(pos, width, height)
		end,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			after_place_node(pos, placer, itemstack, pointed_thing)
		end,
		on_dig = function(pos, node, digger)
			on_dig(pos, node, digger, width, height)
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			return allow_metadata_inventory_put(pos, listname, index, stack, player)
		end,
	})
end
