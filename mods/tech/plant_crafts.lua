------------------------------------
--PLANT CRAFTS
--crafts directly using vegetation
--also food processing
-----------------------------------


---------------------------------------
--Craft items


minetest.register_node("tech:stick", {
 description = "Stick",
 drawtype = "nodebox",
 node_box = {
	 type ="fixed",
	 fixed = {{-0.0625, -0.5, -0.0625, 0.125, 0.5, 0.125}},
 },
 --inventory_image = "tech_stick_inv.png",
 --wield_image = "tech_stick_inv.png",
 tiles = {"tech_stick.png"},
 stack_max = minimal.stack_max_medium,
 paramtype = "light",
 paramtype2 = "wallmounted",
 climbable = true,
 sunlight_propagates = true,
 groups = {choppy=2, dig_immediate=2, flammable=1, attached_node=1, temp_pass = 1},
 drop = "tech:stick",
 sounds = nodes_nature.node_sound_wood_defaults(),

})




---------------------------------------
--Food processing



-----------
--Maraka washing functions
local function set_maraka_wash(pos, length, interval)
	-- count
	local meta = minetest.get_meta(pos)
	meta:set_int("washing", length)
	--check  interval
	minetest.get_node_timer(pos):start(interval)
end



local function wash_maraka(pos, name, length)
	local meta = minetest.get_meta(pos)
	local washing = meta:get_int("washing")

	--check if wet,
	if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then

    if washing <= 0 then
      --finished
      minetest.set_node(pos, {name = name})
      return false
    else
      --do washing
      meta:set_int("washing", washing - 1)
      return true
    end

  else
    --no water
    return true
	end

end




--bitter maraka flour
-- unusable flour. Requires water treatment.
minetest.register_node('tech:maraka_flour_bitter', {
	description = 'Bitter Maraka Flour',
  tiles = {"tech_flour_bitter.png"},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	groups = {crumbly = 3, dig_immediate = 3, falling_node = 1, flammable = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
  on_construct = function(pos)
    --length(i.e. difficulty of wash), interval for checks (speed)
    set_maraka_wash(pos, 20, 10)
  end,
  on_timer = function(pos, elapsed)
    --finished product, length
    return wash_maraka(pos, "tech:maraka_flour", 15)
  end,
})

-- maraka flour
--usable flour.
minetest.register_node('tech:maraka_flour', {
	description = 'Maraka Flour',
  tiles = {"tech_flour.png"},
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	groups = {crumbly = 3, dig_immediate = 3, falling_node = 1, flammable = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
})





--Bread baking functions
local function set_bake_bread(pos, length, interval)
	-- and firing count
	local meta = minetest.get_meta(pos)
	meta:set_int("baking", length)
	--check heat interval
	minetest.get_node_timer(pos):start(interval)
end



local function bake_bread(pos, name, length, heat)
	local meta = minetest.get_meta(pos)
	local baking = meta:get_int("baking")

	--check if wet stop
	if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then
		return true
	end

  --exchange accumulated heat
  climate.heat_transfer(pos)

	--check if above firing temp
	local temp = climate.get_point_temp(pos)
	local fire_temp = heat

	if baking <= 0 then
		--finished firing
		minetest.set_node(pos, {name = name})
    minetest.check_for_falling(pos)
		return false
  elseif temp < fire_temp then
    --not lit yet
    return true
	elseif temp > fire_temp * 2 then
		--too hot, burn
		minetest.set_node(pos, {name = "air"})
    --Smoke
    minetest.sound_play("tech_fire_small",{pos=pos, max_hear_distance = 10, loop=false, gain=0.1})
    minetest.add_particlespawner({
      amount = 2,
      time = 0.5,
      minpos = {x = pos.x - 0.1, y = pos.y, z = pos.z - 0.1},
      maxpos = {x = pos.x + 0.1, y = pos.y + 0.5, z = pos.z + 0.1},
      minvel = {x= 0, y= 0, z= 0},
      maxvel = {x= 0.01, y= 0.06, z= 0.01},
      minacc = {x= 0, y= 0, z= 0},
      maxacc = {x= 0.01, y= 0.1, z= 0.01},
      minexptime = 3,
      maxexptime = 10,
      minsize = 1,
      maxsize = 4,
      collisiondetection = true,
      vertical = true,
      texture = "tech_smoke.png",
    })
		return false
	elseif temp >= fire_temp then
		--do firing
		meta:set_int("baking", baking - 1)
		return true
	end

end

--maraka cake, prior to baking
minetest.register_node("tech:maraka_cake_unbaked", {
	description = "Unbaked Maraka Cake",
	tiles = {"tech_flour.png"},
	stack_max = minimal.stack_max_medium,
  paramtype = "light",
  paramtype2 = "wallmounted",
  sunlight_propagates = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.3, 0.3},
	},
	groups = {crumbly = 3, dig_immediate = 3, temp_pass = 1, heatable = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
  on_construct = function(pos)
    --length(i.e. difficulty), interval for checks (speed)
    set_bake_bread(pos, 6, 6)
  end,
  on_timer = function(pos, elapsed)
    --finished product, length, heat
    return bake_bread(pos, "tech:maraka_cake", 10, 160)
  end,
})


--maraka cake,baked
minetest.register_node("tech:maraka_cake", {
	description = "Maraka Cake",
	tiles = {"tech_flour_bitter.png"},
	stack_max = minimal.stack_max_medium * 4,
  paramtype = "light",
  sunlight_propagates = true,
  --paramtype2 = "wallmounted",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.28, -0.5, -0.28, 0.28, -0.32, 0.28},
	},
	groups = {crumbly = 3, falling_node = 1, dig_immediate = 3, flammable = 1,  temp_pass = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
  on_use = function(itemstack, user, pointed_thing)
    --hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
    return HEALTH.use_item(itemstack, user, 0, 0, 18, 18, 0)
  end,
})




-----------
--Anperla
minetest.register_node("tech:peeled_anperal_tuber", {
	description = "Peeled Anperla Tuber",
	tiles = {"tech_flour.png"},
	stack_max = minimal.stack_max_medium,
  paramtype = "light",
  sunlight_propagates = true,
	drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {-0.15, -0.5, -0.15,  0.15, -0.35, 0.15},
  },
	groups = {snappy = 3, falling_node = 1, dig_immediate = 3, temp_pass = 1, heatable = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
  on_construct = function(pos)
    --length(i.e. difficulty), interval for checks (speed)
    set_bake_bread(pos, 5, 6)
  end,
  on_timer = function(pos, elapsed)
    --finished product, length, heat
    return bake_bread(pos, "tech:cooked_anperal_tuber", 7, 100)
  end,
})

minetest.register_node("tech:cooked_anperal_tuber", {
	description = "Cooked Anperla Tuber",
	tiles = {"tech_flour_bitter.png"},
	stack_max = minimal.stack_max_medium * 2,
  paramtype = "light",
  sunlight_propagates = true,
	drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {-0.15, -0.5, -0.15,  0.15, -0.35, 0.15},
  },
	groups = {crumbly = 3, falling_node = 1, dig_immediate = 3, flammable = 1,  temp_pass = 1},
	sounds = nodes_nature.node_sound_dirt_defaults(),
  on_use = function(itemstack, user, pointed_thing)
    --hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
    return HEALTH.use_item(itemstack, user, 0, 4, 14, 14, 0)
  end,
})




------------------------------------------
--Vegetable Oils


--vegetable oil
minetest.register_craftitem("tech:vegetable_oil", {
	description = "Vegetable Oil",
	inventory_image = "tech_vegetable_oil.png",
	stack_max = minimal.stack_max_medium *2,
	groups = {flammable = 1},

  --yes... we are letting you drink cooking oil...
  --...although it is worse than just eating the seeds
  on_use = function(itemstack, user, pointed_thing)
    --hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
    return HEALTH.use_item(itemstack, user, 0, 0, 8, -32, 0)
  end,
})

---------------------------------------
--Medicines

--Herbal medicine (removes energy cost of plants healing effects)
minetest.register_craftitem("tech:herbal_medicine", {
	description = "Herbal Medicine",
	inventory_image = "tech_herbal_medicine.png",
	stack_max = minimal.stack_max_medium *2,
	groups = {flammable = 1},

  on_use = function(itemstack, user, pointed_thing)
    --hp_change, thirst_change, hunger_change, energy_change, temp_change, replace_with_item
    return HEALTH.use_item(itemstack, user, 5, 0, 0, 0, 0)
  end,
})



---------------------------------------
--Recipes

--
--Hand crafts (inv)
--

--Sticks from woody plants
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:stick 2",
	items = {"group:woody_plant"},
	level = 1,
	always_known = true,
})


--peel tubers
crafting.register_recipe({
	type = "crafting_spot",
	output = "tech:peeled_anperal_tuber",
	items = {"nodes_nature:anperla_seed"},
	level = 1,
	always_known = true,
})


--
--mortar and pestle
--

--grind maraka flour
crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:maraka_flour_bitter",
	items = {'nodes_nature:maraka_nut 48'},
	level = 1,
	always_known = true,
})

--make maraka cakes
crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:maraka_cake_unbaked 24",
	items = {'tech:maraka_flour'},
	level = 1,
	always_known = true,
})

--make herbal_medicine
crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:herbal_medicine",
	items = {'nodes_nature:hakimi', 'nodes_nature:merki', 'nodes_nature:moss'},
	level = 1,
	always_known = true,
})


--squeeze oil
crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "tech:vegetable_oil",
	items = {'nodes_nature:vansano_seed 16'},
	level = 1,
	always_known = true,
})

--
--chopping_block
--

--Sticks from woody plants
crafting.register_recipe({
	type = "chopping_block",
	output = "tech:stick 2",
	items = {"group:woody_plant"},
	level = 1,
	always_known = true,
})

--sticks from tree
crafting.register_recipe({
	type = "chopping_block",
	output = "tech:stick 24",
	items = {"group:log"},
	level = 1,
	always_known = true,
})
