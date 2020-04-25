
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
  local pos = user:getpos()

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
--THERMOMETER
--get ambient position temperature
------------------------------------

local thermometer = function(user, pointed_thing)

  local name =user:get_player_name()
  local pos = user:getpos()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "AMBIENT TEMPERATURE MEASUREMENT:"))

  local measure = climate.get_point_temp(pos)

  minetest.chat_send_player(name, minetest.colorize("#cc6600","TEMPERATURE = "..measure))
  --minetest.sound_play("ecobots2_tool_good", {gain = 0.2, pos = pos, max_hear_distance = 5})

end


minetest.register_craftitem("artifacts:thermometer", {
	description = "Thermometer",
	inventory_image = "artifacts_thermometer.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		thermometer(user, pointed_thing)
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
  local pos = user:getpos()

	minetest.chat_send_player(name, minetest.colorize("#00ff00", "OBJECT TEMPERATURE MEASUREMENT:"))

  local measure = climate.get_point_temp(pointed_thing.under)

  minetest.chat_send_player(name, minetest.colorize("#cc6600","TEMPERATURE = "..measure))
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
  local pos = user:getpos()


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
