
------------------------------------
--TOOLS
--for debug, and gameplay
------------------------------------




------------------------------------
--LIGHT METER
--get positon light
------------------------------------

local light_meter = function(user, pointed_thing)

  local name =user:get_player_name()
  local pos = user:get_pos()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "LIGHT MEASUREMENT:"))

  local measure = ((minetest.get_node_light({x = pos.x, y = pos.y, z = pos.z})) or 0)

  minetest.chat_send_player(name, minetest.colorize("#cc6600","LIGHT LEVEL = "..measure))
  --minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})

end


minetest.register_craftitem("artifacts:light_meter", {
	description = "Light Meter",
	inventory_image = "artifacts_light_meter.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		light_meter(user, pointed_thing)
	end,
})

------------------------------------
--TEMPERATURE PROBE
--get node temperature
------------------------------------

local temp_probe = function(user, pointed_thing)

  if pointed_thing.type ~= "node" then
    return
  end

  local under = minetest.get_node(pointed_thing.under)

  local node_name = under.name
  local nodedef = minetest.registered_nodes[node_name]
  if not nodedef then
    return
  end


  local name =user:get_player_name()
  local pos = user:get_pos()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "OBJECT TEMPERATURE MEASUREMENT:"))

  local temp = climate.get_point_temp(pointed_thing.under)
  local measure = climate.get_temp_string(temp, user:get_meta())
  minetest.chat_send_player(name, minetest.colorize("#cc6600","TEMPERATURE = "))
  minetest.chat_send_player(name, minetest.colorize("#cc6600", measure))
  --minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})

end


minetest.register_craftitem("artifacts:temp_probe", {
	description = "Temperature Probe",
	inventory_image = "artifacts_temp_probe.png",
  wield_image = "artifacts_temp_probe.png^[transformR90",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		temp_probe(user, pointed_thing)
	end,
})




------------------------------------
--FUEL PROBE
--get burn progress
------------------------------------

local fuel_probe = function(user, pointed_thing)

  if pointed_thing.type ~= "node" then
    return
  end

  local under = minetest.get_node(pointed_thing.under)

  local node_name = under.name
  local nodedef = minetest.registered_nodes[node_name]
  if not nodedef then
    return
  end


  local name =user:get_player_name()
  local pos = user:get_pos()


  local meta = minetest.get_meta(pointed_thing.under)
  local measure = meta:get_int("fuel")

  if measure <= 0 then
    minetest.chat_send_player(name, minetest.colorize("#cc6600","NOT MEASURABLE!"))
  else
    minetest.chat_send_player(name, minetest.colorize("#00ff00", "BURN UNITS REMAINING:"))
    minetest.chat_send_player(name, minetest.colorize("#cc6600", measure))
  end

end


minetest.register_craftitem("artifacts:fuel_probe", {
	description = "Fuel Probe",
	inventory_image = "artifacts_fuel_probe.png",
  wield_image = "artifacts_fuel_probe.png^[transformR90",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		fuel_probe(user, pointed_thing)
	end,
})

------------------------------------
--SMELTER PROBE
--get smelting progress
------------------------------------

local smelter_probe = function(user, pointed_thing)

  if pointed_thing.type ~= "node" then
    return
  end

  local under = minetest.get_node(pointed_thing.under)

  local node_name = under.name
  local nodedef = minetest.registered_nodes[node_name]
  if not nodedef then
    return
  end


  local name =user:get_player_name()
  local pos = user:get_pos()


  local meta = minetest.get_meta(pointed_thing.under)
  local measure = meta:get_int("roast")

  if measure <= 0 or node_name ~= 'tech:iron_and_slag' then
    minetest.chat_send_player(name, minetest.colorize("#cc6600","NOT MEASURABLE!"))
  else
    minetest.chat_send_player(name, minetest.colorize("#00ff00", "SMELTING UNITS REMAINING:"))
    minetest.chat_send_player(name, minetest.colorize("#cc6600", measure))
  end

end


minetest.register_craftitem("artifacts:smelter_probe", {
	description = "Smelter Probe",
	inventory_image = "artifacts_smelter_probe.png",
  wield_image = "artifacts_smelter_probe.png^[transformR90",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		smelter_probe(user, pointed_thing)
	end,
})



------------------------------------
--POTTERS PROBE
--get  progress
------------------------------------

local potters_probe = function(user, pointed_thing)

  if pointed_thing.type ~= "node" then
    return
  end

  local under = minetest.get_node(pointed_thing.under)

  local node_name = under.name
  local nodedef = minetest.registered_nodes[node_name]
  if not nodedef then
    return
  end


  local name =user:get_player_name()
  local pos = user:get_pos()


  local meta = minetest.get_meta(pointed_thing.under)
  local measure = meta:get_int("firing")

  if measure <= 0 then
    minetest.chat_send_player(name, minetest.colorize("#cc6600","NOT MEASURABLE!"))
  else
    minetest.chat_send_player(name, minetest.colorize("#00ff00", "FIRING UNITS REMAINING:"))
    minetest.chat_send_player(name, minetest.colorize("#cc6600", measure))
  end

end


minetest.register_craftitem("artifacts:potters_probe", {
	description = "Potter's Probe",
	inventory_image = "artifacts_potters_probe.png",
  wield_image = "artifacts_potters_probe.png^[transformR90",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		potters_probe(user, pointed_thing)
	end,
})


------------------------------------
--CHEFS PROBE
--get cooking progress
------------------------------------

local chefs_probe = function(user, pointed_thing)

  if pointed_thing.type ~= "node" then
    return
  end

  local under = minetest.get_node(pointed_thing.under)

  local node_name = under.name
  local nodedef = minetest.registered_nodes[node_name]
  if not nodedef then
    return
  end


  local name =user:get_player_name()
  local pos = user:get_pos()


  local meta = minetest.get_meta(pointed_thing.under)
  local measure = meta:get_int("baking")

  if measure <= 0 then
    minetest.chat_send_player(name, minetest.colorize("#cc6600","NOT MEASURABLE!"))
  else
    minetest.chat_send_player(name, minetest.colorize("#00ff00", "COOKING UNITS REMAINING:"))
    minetest.chat_send_player(name, minetest.colorize("#cc6600", measure))
  end

end


minetest.register_craftitem("artifacts:chefs_probe", {
	description = "Chef's Probe",
	inventory_image = "artifacts_chefs_probe.png",
  wield_image = "artifacts_chefs_probe.png^[transformR90",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		chefs_probe(user, pointed_thing)
	end,
})


------------------------------------
--FARMERS PROBE
--get growth progress
------------------------------------

local farmers_probe = function(user, pointed_thing)

  if pointed_thing.type ~= "node" then
    return
  end

  local under = minetest.get_node(pointed_thing.under)

  local node_name = under.name
  local nodedef = minetest.registered_nodes[node_name]
  if not nodedef then
    return
  end


  local name =user:get_player_name()
  local pos = user:get_pos()


  local meta = minetest.get_meta(pointed_thing.under)
  local measure = meta:get_int("growth")

  if measure <= 0 then
    minetest.chat_send_player(name, minetest.colorize("#cc6600","NOT MEASURABLE!"))
  else
    minetest.chat_send_player(name, minetest.colorize("#00ff00", "GROWTH UNITS REMAINING:"))
    minetest.chat_send_player(name, minetest.colorize("#cc6600", measure))
  end

end


minetest.register_craftitem("artifacts:farmers_probe", {
	description = "Farmer's Probe",
	inventory_image = "artifacts_farmers_probe.png",
  wield_image = "artifacts_farmers_probe.png^[transformR90",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		farmers_probe(user, pointed_thing)
	end,
})




------------------------------------
--ANTIQUORIUM CHISEL
--able to dig granite etc, no good for anything else.
------------------------------------
minetest.register_tool("artifacts:antiquorium_chisel", {
	description = "Antiquorium Chisel",
	inventory_image = "artifacts_antiquorium_chisel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 3,
		groupcaps={
			cracky = {times={[1]=6.5, [2]=5.5, [3]=4.50}, uses=3000, maxlevel=3},
		},
		damage_groups = {fleshy = 1},
	},
	sound = {breaks = "tech_tool_breaks"},
})



------------------------------------
--SPYGLASS
-- temporary zoom
------------------------------------

--a quick look through
local function use_spyglass(player)

	player:set_fov(10, false)

	minetest.after(5, function()
			player:set_fov(0, false)
	end)

end


--  item
minetest.register_craftitem("artifacts:spyglass", {
	description = "Spyglass",
	inventory_image = "artifacts_spyglass.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		use_spyglass(user)
	end,
})



--crashes when used on non-mobkit entities, bug testing tool only!
------------------------------------
--ANIMAL PROBE
--get condition of an animal
------------------------------------

local animal_probe = function(user, pointed_thing)

  if pointed_thing.type ~= "object" then
    return
  end

  local ent = pointed_thing.ref:get_luaentity()

  local r_ent_e = mobkit.recall(ent,'energy')
  local r_ent_a = mobkit.recall(ent,'age')

  if not r_ent_e or not r_ent_a then
    return
  end


  local name =user:get_player_name()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "ANIMAL CONDITION:"))

  minetest.chat_send_player(name, minetest.colorize("#cc6600","Age: "..r_ent_a.. " sec    Energy: "..r_ent_e.." units"))

end

minetest.register_craftitem("artifacts:animal_probe", {
	description = "Animal Probe",
	inventory_image = "artifacts_animal_probe.png",
  wield_image = "artifacts_animal_probe.png^[transformR90",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		animal_probe(user, pointed_thing)
	end,
})
