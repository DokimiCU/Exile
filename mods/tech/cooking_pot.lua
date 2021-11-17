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

local pot_formspec = "size[8,4.1]"..
   "list[current_name;main;0,0;8,2]"..
   "list[current_player;main;0,2.3;8,4]"..
   "listring[current_name;main]"..
   "listring[current_player;main]"

local function pot_rightclick(pos, node, clicker, itemstack, pointed_thing)
   local meta = minetest.get_meta(pos)
   local itemname = itemstack:get_name()
   if meta:get_string("type") == "" then
      if itemname == "nodes_nature:freshwater_source" then
	 --TODO: add liquid stores
	 meta:set_string("type", "soup")
	 meta:set_string("infotext", "Soup pot")
	 meta:set_string("formspec", pot_formspec)
	 itemstack:take_item()
      end
      return itemstack
   end
   --TODO: use oil for fried food, saltwater for salted food (to preserve it)
   --show formspec of inventory
end

--on_receive_fields goes here, calculate total contents, and turn it into
-- portions of soup/etc when cooked

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
	on_construct = function(pos)
	   local meta = minetest.get_meta(pos)
	   meta:set_string("infotext", "Unprepared pot")
	   local inv = meta:get_inventory()
	   inv:set_size("main", 8*2)
	end,
	on_rightclick = function(...)
	   return pot_rightclick(...)
	end,
	on_dig = function(pos, node, digger)
	   local meta = minetest.get_meta(pos)
	   local inv = meta get_inventory()
	   if not inv:is_empty("main") then
	      return false
	   end
	   minetest.node_dig(pos, node, digger)
	end
})
