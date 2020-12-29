----------------------------------------------------------
--COOKING POT



----------------------------------------------------------
--[[
Food capacity

Display:
Food %
Cooking progress %

Click with food item to add to pot -> ^food vProgress

Heat to cook

Click with hand to eat -> vFood %


Save to inv meta

]]



---------------------
local pot_box = {
	{-0.375, -0.1875, -0.375, 0.375, -0.0625, 0.375}, -- NodeBox1
	{-0.3125, -0.3125, -0.3125, 0.3125, -0.1875, 0.3125}, -- NodeBox2
	{-0.25, -0.4375, -0.25, 0.25, -0.3125, 0.25}, -- NodeBox3
	{-0.3125, -0.0625, -0.3125, 0.3125, 0, 0.3125}, -- NodeBox4
	{-0.25, 0, -0.25, 0.25, 0.0625, 0.25}, -- NodeBox5
	{-0.125, 0.0625, -0.0625, -0.0625, 0.1875, 0.0625}, -- NodeBox6
	{0.0625, 0.0625, -0.0625, 0.125, 0.1875, 0.0625}, -- NodeBox7
	{-0.0625, 0.125, -0.0625, 0.0625, 0.1875, 0.0625}, -- NodeBox8
	{0.25, -0.4375, 0.25, 0.375, -0.3125, 0.375}, -- NodeBox9
	{0.25, -0.5, 0.25, 0.4375, -0.4375, 0.4375}, -- NodeBox10
	{0.25, -0.5, -0.4375, 0.4375, -0.4375, -0.25}, -- NodeBox11
	{-0.4375, -0.5, -0.4375, -0.25, -0.4375, -0.25}, -- NodeBox12
	{-0.4375, -0.5, 0.25, -0.25, -0.4375, 0.4375}, -- NodeBox13
	{0.25, -0.4375, -0.375, 0.375, -0.3125, -0.25}, -- NodeBox14
	{-0.375, -0.4375, -0.375, -0.25, -0.3125, -0.25}, -- NodeBox15
	{-0.375, -0.4375, 0.25, -0.25, -0.3125, 0.375}, -- NodeBox16
	{-0.4375, -0.0625, -0.0625, -0.3125, 0.0625, 0.0625}, -- NodeBox23
	{0.3125, -0.0625, -0.0625, 0.4375, 0.0625, 0.0625}, -- NodeBox24
}

minetest.register_node("tech:cooking_pot", {
	description = "Cooking Pot (WIP!)",
	tiles = {"tech_pottery.png",
	"tech_pottery.png",
	"tech_pottery.png",
	"tech_pottery.png",
	"tech_pottery.png"},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_bulky,
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = pot_box,
	},
	groups = {dig_immediate = 3, pottery = 1},
	sounds = nodes_nature.node_sound_stone_defaults(),
})
