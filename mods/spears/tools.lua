function spears_register_spear(spear_type, desc, base_damage, toughness, material, exilectype)

	minetest.register_tool("spears:spear_" .. spear_type, {
		description = desc .. " spear",
                wield_image = "spears_spear_" .. spear_type .. ".png^[transform4",
		inventory_image = "spears_spear_" .. spear_type .. ".png",
		wield_scale= {x = 1.5, y = 1.5, z = 1.5},
		on_secondary_use = function(itemstack, user, pointed_thing)
			spears_throw(itemstack, user, pointed_thing)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
		on_place = function(itemstack, user, pointed_thing)
			spears_throw(itemstack, user, pointed_thing)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
		tool_capabilities = {
			full_punch_interval = 1.5,
			max_drop_level=1,
			damage_groups = {fleshy=base_damage},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {flammable = 1}
	})

	local SPEAR_ENTITY = spears_set_entity(spear_type, base_damage, toughness)

	minetest.register_entity("spears:spear_" .. spear_type .. "_entity", SPEAR_ENTITY)

	if minetest.get_modpath("default") then
	   minetest.register_craft({
		output = 'spears:spear_' .. spear_type,
		recipe = {
			{'group:stick', 'group:stick', material},
		}
	   })

	   minetest.register_craft({
		output = 'spears:spear_' .. spear_type,
		recipe = {
			{material, 'group:stick', 'group:stick'},
		}
	   })
	elseif minetest.get_modpath("minimal") then
	   crafting.register_recipe({
		 type = exilectype,
		 output = 'spears:spear_' .. spear_type,
		 items = {'tech:stick 2', material},
		 level = 1,
		 always_known = true,
	   })
	end
end

if minetest.get_modpath("default") then
   if not DISABLE_STONE_SPEAR then
      spears_register_spear('stone', 'Stone', 4, 20, 'group:stone')
   end
   if not DISABLE_STEEL_SPEAR then
      spears_register_spear('steel', 'Steel', 6, 30, 'default:steel_ingot')
   end
   if not DISABLE_COPPER_SPEAR then
      spears_register_spear('copper', 'Copper', 5, 35, 'default:copper_ingot')
   end
   if not DISABLE_BRONZE_SPEAR then
      spears_register_spear('bronze', 'Bronze', 6, 35, 'default:bronze_ingot')
   end
   if not DISABLE_OBSIDIAN_SPEAR then
      spears_register_spear('obsidian', 'Obsidian', 8, 30, 'default:obsidian')
   end
   if not DISABLE_DIAMOND_SPEAR then
      spears_register_spear('diamond', 'Diamond', 8, 40, 'default:diamond')
   end
   if not DISABLE_GOLD_SPEAR then
      spears_register_spear('gold', 'Golden', 5, 40, 'default:gold_ingot')
   end
elseif minetest.get_modpath("minimal") then
   spears_register_spear('stone', 'Stone', 8, 20, 'tech:stone_chopper',
			 "crafting_spot")
   spears_register_spear('steel', 'Iron', 14, 30, 'tech:iron_ingot', "anvil")
end
