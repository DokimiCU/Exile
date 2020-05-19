----------------------------------------------------------
--CLOTHING



----------------------------------------------------------------
--PRIMITIVE
--from crude woven fibres,

--Hat
minetest.register_craftitem("tech:woven_hat", {
	description = "Woven Hat",
	inventory_image = "tech_inv_woven_hat.png",
	uv_image = "tech_uv_woven_hat.png",
	stack_max = 1,
	groups = {clothing = 1, clothing_hat = 1,},
	temp_min = 1,
	temp_max = 1,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})


crafting.register_recipe({
	type = "weaving_frame",
	output = "tech:woven_hat",
	items = {'group:fibrous_plant 24'},
	level = 1,
	always_known = true,
})

--Cape
minetest.register_craftitem("tech:woven_cape", {
	description = "Woven Cape",
	inventory_image = "tech_inv_woven_cape.png",
	uv_image = "tech_uv_woven_cape.png",
	groups = {cape = 1, clothing_cape=1},
	temp_min = 2,
	temp_max = 1,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "weaving_frame",
	output = "tech:woven_cape",
	items = {'group:fibrous_plant 48'},
	level = 1,
	always_known = true,
})


--Poncho
minetest.register_craftitem("tech:woven_poncho", {
	description = "Woven Poncho",
	inventory_image = "tech_inv_woven_poncho.png",
	uv_image = "tech_uv_woven_poncho.png",
	stack_max = 1,
	groups = {clothing = 1, clothing_shirt = 1,},
	temp_min = 2,
	temp_max = 1,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "weaving_frame",
	output = "tech:woven_poncho",
	items = {'group:fibrous_plant 48'},
	level = 1,
	always_known = true,
})



--Leggings
minetest.register_craftitem("tech:woven_leggings", {
	description = "Woven Leggings",
	inventory_image = "tech_inv_woven_leggings.png",
	uv_image = "tech_uv_woven_leggings.png",
	groups = {clothing = 1, clothing_pants=1},
	temp_min = 1,
	temp_max = 0,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "weaving_frame",
	output = "tech:woven_leggings",
	items = {'group:fibrous_plant 36'},
	level = 1,
	always_known = true,
})



----------------------------------------------------------------
--FABRIC
--from loom woven fabric
--two types:
-- thick: better for winter, but needs more material, bad in summer
--light: better for summer

--Light Hat
minetest.register_craftitem("tech:light_fabric_hat", {
	description = "Light Fabric Hat",
	inventory_image = "tech_inv_light_fabric_hat.png",
	uv_image = "tech_uv_light_fabric_hat.png",
	stack_max = 1,
	groups = {clothing = 1, clothing_hat = 1,},
	temp_min = 2,
	temp_max = 1,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "loom",
	output = "tech:light_fabric_hat",
	items = {'tech:fine_fabric'},
	level = 1,
	always_known = true,
})


--Thick Hat
minetest.register_craftitem("tech:thick_fabric_hat", {
	description = "Thick Fabric Hat",
	inventory_image = "tech_inv_thick_fabric_hat.png",
	uv_image = "tech_uv_thick_fabric_hat.png",
	stack_max = 1,
	groups = {clothing = 1, clothing_hat = 1,},
	temp_min = 4,
	temp_max = -1,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "loom",
	output = "tech:thick_fabric_hat",
	items = {'tech:fine_fabric 2'},
	level = 1,
	always_known = true,
})


--light Cape
minetest.register_craftitem("tech:light_fabric_cape", {
	description = "Light Fabric Cape",
	inventory_image = "tech_inv_light_fabric_cape.png",
	uv_image = "tech_uv_light_fabric_cape.png",
	groups = {cape = 1, clothing_cape=1},
	temp_min = 3,
	temp_max = 3,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "loom",
	output = "tech:light_fabric_cape",
	items = {'tech:fine_fabric 3'},
	level = 1,
	always_known = true,
})

--Thick Cape
minetest.register_craftitem("tech:thick_fabric_cape", {
	description = "Thick Fabric Cape",
	inventory_image = "tech_inv_thick_fabric_cape.png",
	uv_image = "tech_uv_thick_fabric_cape.png",
	groups = {cape = 1, clothing_cape=1},
	temp_min = 6,
	temp_max = -2,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "loom",
	output = "tech:thick_fabric_cape",
	items = {'tech:fine_fabric 6'},
	level = 1,
	always_known = true,
})


--Light Trousers
minetest.register_craftitem("tech:light_fabric_trousers", {
	description = "Light Fabric Trousers",
	inventory_image = "tech_inv_light_fabric_trousers.png",
	uv_image = "tech_uv_light_fabric_trousers.png",
	groups = {clothing = 1, clothing_pants=1},
	temp_min = 3,
	temp_max = 2,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "loom",
	output = "tech:light_fabric_trousers",
	items = {'tech:fine_fabric 4'},
	level = 1,
	always_known = true,
})


--Thick Trousers
minetest.register_craftitem("tech:thick_fabric_trousers", {
	description = "Thick Fabric Trousers",
	inventory_image = "tech_inv_thick_fabric_trousers.png",
	uv_image = "tech_uv_thick_fabric_trousers.png",
	groups = {clothing = 1, clothing_pants=1},
	temp_min = 6,
	temp_max = -2,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "loom",
	output = "tech:thick_fabric_trousers",
	items = {'tech:fine_fabric 8'},
	level = 1,
	always_known = true,
})


--Light Tunic
minetest.register_craftitem("tech:light_fabric_tunic", {
	description = "Light Fabric Tunic",
	inventory_image = "tech_inv_light_fabric_tunic.png",
	uv_image = "tech_uv_light_fabric_tunic.png",
	stack_max = 1,
	groups = {clothing = 1, clothing_shirt = 1,},
	temp_min = 3,
	temp_max = 2,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "loom",
	output = "tech:light_fabric_tunic",
	items = {'tech:fine_fabric 4'},
	level = 1,
	always_known = true,
})


--Thick Tunic
minetest.register_craftitem("tech:thick_fabric_tunic", {
	description = "Thick Fabric Tunic",
	inventory_image = "tech_inv_thick_fabric_tunic.png",
	uv_image = "tech_uv_thick_fabric_tunic.png",
	stack_max = 1,
	groups = {clothing = 1, clothing_shirt = 1,},
	temp_min = 6,
	temp_max = -2,
	on_equip = clothing.default_equip,
	on_unequip = clothing.default_unequip
})

crafting.register_recipe({
	type = "loom",
	output = "tech:thick_fabric_tunic",
	items = {'tech:fine_fabric 8'},
	level = 1,
	always_known = true,
})
