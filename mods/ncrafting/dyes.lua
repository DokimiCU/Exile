--dyes.lua

local spins = 24 -- how many 1/4 turns to stir before dye takes hold
local stirspeed = 0.25 -- How many second per 1/4 turn
local stirringplayers = {}

local dyelist = { ["red"] = 1, ["crimson"] = 4, ["yellow"] = 7,
   ["green"] = 10, ["blue"] = 13, ["indigo"] = 16 , ["black"] = 19 }
-- can be overwritten by an old stored version, to ensure dyes don't reshuffle

local dyecolor = { [0] = "#ffffff", -- white or none
     [ 1] = "#710e13", [ 2] = "#a84176", [ 3] = "#b576a8", -- red
     [ 4] = "#5d2007", [ 5] = "#8c3c3e", [ 6] = "#cfa0a9", -- crimson
     [ 7] = "#938a34", [ 8] = "#a9b074", [ 9] = "#b7b38f", -- yellow
     [10] = "#263e28", [11] = "#5d806f", [12] = "#90b1a6", -- green
     [13] = "#245eaa", [14] = "#3c76a9", [15] = "#6fa4cd", -- blue
     [16] = "#444171", [17] = "#607597", [18] = "#8f86af", -- indigo
     [19] = "#1c1b1b", [20] = "#3c3b3b", [21] = "#5f5e5e", -- black/grey
   }

function dye_to_colorstring(palette)
   if not palette then return end
   if palette > 31 then -- this is from a colorwallmounted param2
      minetest.log("warning", "dye_to_colorstring run on a param2 palette value not divided by 8!")
      palette = math.floor(palette / 8)
   end
   if dyecolor[palette] then
      return dyecolor[palette]
   else
      return ""
   end
end

for name, number in pairs(dyelist) do
minetest.register_craftitem(":ncrafting:dye_"..name, {
   description = name.." dye",
   inventory_image = "blank_dye.png",
   color = dye_to_colorstring(number),
   _ncrafting_dye_color = number
})
end

-----------------------------------------------
-- Dye creation

local dye_candidates -- list of all unused plants that existed at world creation
--[[
table: "plants:tulip_yellow" = {
   ["weight"] = 2, -- value of dye_candidate grp, increases odds of being a dye
   ["dcolor"] = "yellow" -- dominant color, higher odds of blue/green/yellow }
]]--
local dye_source = {} -- table of selected dye plants, and table
--[[
table: "plants:daisy" = {
   ["color"]  = "white", -- selected color
   ["method"] = "soak", -- method of creating the dye }
]]--

local methods = { "cook", "soak", "burn" }
local methodstring = {
   ["cook"] = "treated by cooking",
   ["soak"] = "treated by soaking",
   ["burn"] = "treated by burning",
}

local neighbors = {
   ["red"] = { "indigo", "red", "crimson" },
   ["crimson"] = { "red", "crimson", "yellow" },
   ["yellow"] = { "crimson", "yellow", "green" },
   ["green"] = { "yellow", "green", "blue" },
   ["blue"] = { "green", "blue", "indigo" },
   ["indigo"] = { "blue", "indigo", "red" },
}
local undefined_dyes = table.copy(dyelist)

function ncrafting.set_treatment(meta, action)
   local valid_method = false
   for i = 1,#methods do
      if action == methods[i] then
	   valid_method = true
      end
   end
   if valid_method == false then return end
   meta:set_string("ncrafting:bundle_treatment", action)
end

local function is_neighbor(col1, col2)
   if col2 == nil or not neighbors[col1] then return false end
   for i = 1, #neighbors[col1] do
      if neighbors[col1] and neighbors[col1][i] == col2 then
	 return true
      end
   end
   return false
end

local function CandidateList()
   -- Gathers a list of all plants that have not been chosen
   -- as a dye source yet
   dye_candidates = ncrafting.loadstore("dye_candidates") or {}

   for nm, def in pairs(minetest.registered_nodes) do
      if def.groups.ncrafting_dye_candidate ~= nil then
	 if dye_source[nm] == nil then
	    dye_candidates[nm] = {}
	    dye_candidates[nm].dcolor = def._ncrafting_dye_dcolor or "none"
	    dye_candidates[nm].weight = def.groups.ncrafting_dye_candidate
	 else -- this plant is used for a color, remove color from the todo list
	    undefined_dyes[dye_source[nm].color] = nil
	 end
      end
   end
end

local function NewRollTable(color)
   local NewTable = {}
   local i = 1
   for nm, tab in pairs(dye_candidates) do
      for j = 1, tab.weight do -- put the names in the hat
	 NewTable[i] = nm
	 i = i + 1
	 if is_neighbor(color, tab.dcolor) then -- 2x odds if neighboring colors
	    NewTable[i] = nm
	    i = i + 1
	 end
      end
   end
   return NewTable
end

local function GenerateDyes(seed) -- Generate dye_sources based on mapgen seed
   local rando = PcgRandom(seed)
   for dye, _ in pairs(undefined_dyes) do
      minetest.log("action","Generating "..dye.." dye")
      -- create tables to roll on for any new dyes
      local rolltable = NewRollTable(dye)
      local max = #rolltable
      if max and max > 0 then
	 local select = rolltable[rando:next(1, max)]
	 dye_source[select] = {}
	 dye_source[select].color = dye
	 dye_source[select].method = methods[rando:next(1, #methods)]
	 dye_candidates[select] = nil -- remove used plants from the list
      end
   end

  -- Displays current world's dye source, turn on info level logging to see it
  local stringy = ""
   for k, v in pairs(dye_source) do
      stringy = stringy .. k .. " = ".. v.color .. " by ".. v.method .."\n"
   end
   minetest.log("info", "Dye sources:")
   minetest.log("info", stringy)
end

local function SelectSeed()
   local doworldseed = minetest.settings:get("ncrafting_worldseed")
   if doworldseed == nil then
      doworldseed = true
   end
   if doworldseed == true then
      minetest.log("action","Dye generation phase -- using the world seed")
      return minetest.get_mapgen_setting("seed")
   else
      minetest.log("action","Dye generation phase -- using a random seed")
      return math.random() * 100000000000000
   end
end

minetest.register_on_mods_loaded(function()
      dye_source = ncrafting.loadstore64("dye_source") or {}
      CandidateList()
      GenerateDyes(SelectSeed())
      ncrafting.savestore("dye_candidates", dye_candidates)
      ncrafting.savestore64("dye_source", dye_source)
      minetest.log("action","Dye generation finished")
end)

-----------------------------------------------
-- Bundled plants

bundlelist = {["none"] = 0}
for k, v in pairs(dyelist) do
   bundlelist[k] = v
end

-- Generate a readable name to be set on infotext, for easier tracking
local function bundlename(meta, plant, treatment)
   local fmt_plant = ""
   local fmt_treatment
   if plant == nil then
      plant = meta:get_string("ncrafting:bundled_plant")
   end
   if treatment == nil and meta then
      treatment = meta:get_string("ncrafting:bundle_treatment")
   end
   if minetest.registered_nodes[plant] then
      fmt_plant = "of "..minetest.registered_nodes[plant].description
   end
   if treatment and treatment ~= "" then
      fmt_treatment = methodstring[treatment]
   else
      fmt_treatment = ", untreated"
   end
   return "bundle "..fmt_plant..fmt_treatment
end

bundledef = {
   description = "Bundle of plants",
   inventory_image = "tech_retted_cana_bundle.png", -- #TODO: proper texture
   tiles = { {name="tech_retted_cana_bundle.png"} },
   drawtype = "normal",
   stack_max = minimal.stack_max_bulky*2,
   paramtype = "light",
   paramtype2 = "none",
   groups = { dig_immediate = 3, heatable = 50, _ncrafting_bundle = 1,
	      falling_node = 1},
   after_place_node = function(pos, placer, itemstack, pointed_thing)
      local meta = minetest.get_meta(pos)
      local imeta = itemstack:get_meta()
      local plant = imeta:get_string("ncrafting:bundled_plant")
      local treatment = imeta:get_string("ncrafting:bundle_treatment")
      meta:set_string("ncrafting:bundled_plant", plant)
      meta:set_string("ncrafting:bundle_treatment", treatment)
      meta:set_string("infotext", bundlename(nil, plant, treatment))
   end,
   preserve_metadata = function(pos, oldnode, oldmeta, drops)
      local bundled_plant = oldmeta["ncrafting:bundled_plant"] or "none"
      local treatment = oldmeta["ncrafting:bundle_treatment"]
      local stack_meta = drops[1]:get_meta()
      stack_meta:set_string("ncrafting:bundled_plant", bundled_plant)
      stack_meta:set_string("ncrafting:bundle_treatment", treatment)
      stack_meta:set_string("description", bundlename(nil, bundled_plant,
						      treatment))
  end,
}

for name, number in pairs(bundlelist) do
   local nbdef = table.copy(bundledef)
   nbdef.color = dye_to_colorstring(number)
   nbdef._ncrafting_dcolor = name
   local tbdef = table.copy(nbdef) -- don't want the nbdef.on_construct in here
   nbdef.on_construct = function(pos, width, height)
      local meta = minetest.get_meta(pos)
      meta:set_string("soaking", 100) -- 10 minutes @ 6 seconds a pop
      -- any other methods need to have meta strings set in here + timer events
      ncrafting.start_bake(pos, 15) -- 1.5 minutes to bake
   end
   nbdef.on_timer = function(pos, elapsed)
      local selfname = minetest.get_node(pos).name
      local continue
      local color = string.sub(selfname,18)
      local meta = minetest.get_meta(pos)
      local oldtreat = meta:get_string("ncrafting:bundle_treatment") or ""
      continue = ncrafting.do_soak(pos, "ncrafting:bundle_treated_"..color)
      if continue then
	 continue = ncrafting.do_bake(pos, elapsed,
				     160, 15,
				     "ncrafting:bundle_treated_"..color, --cooked
				     "ncrafting:bundle_treated_blue") --burned
      end
      local newtreat = meta:get_string("ncrafting:bundle_treatment") or ""
      if oldtreat ~= newtreat then -- one of the possible treatments was used
	 meta:set_string("infotext", bundlename(meta))
      end
      return continue
   end

   minetest.register_node(":ncrafting:bundle_"..name, nbdef)
   tbdef.on_construct = function(pos, width, height)
      local meta = minetest.get_meta(pos)
      meta:set_string("infotext",  bundlename(meta))
      ncrafting.start_bake(pos, 15) -- 1.5 minutes to bake
   end
   tbdef.on_timer = function(pos, elapsed)
      local selfname = minetest.get_node(pos).name
      local color = string.sub(selfname,26)
      local continue = ncrafting.do_bake(pos, elapsed,
					 160, 15,
					 "ncrafting:bundle_treated_"..
					 color, --cooked
					 "ncrafting:bundle_treated_black")
      if not continue then -- we've burned, change the infotext
	 local meta = minetest.get_meta(pos)
	 meta:set_string("infotext",  bundlename(meta))
      end
      return continue
   end
   tbdef.description = "Treated bundle of plants"
   tbdef.color = dye_to_colorstring(number)
   tbdef.groups.not_in_creative_inventory = 1
   tbdef._ncrafting_dcolor = name
   tbdef._ncrafting_bundle = 2
   minetest.register_node(":ncrafting:bundle_treated_"..name, tbdef)
end

-----------------------------------------------
-- Dyer's Table

local table_formspec_base = "formspec_version[5]" ..
   "size[11,5.5]" ..
   "label[4.55,0.5;Dyers' Table]" ..
   "list[current_name;craft;3,1.2;1,1]" ..
   "list[current_name;craftresult;7,1.2;1,1]" ..
   "list[current_player;main;0.66,2.9;8,2;0]"..
   "listring[current_name;craft]"..
   "listring[current_name;craftresult]"..
   "listring[current_player;main]"


local table_formspec = {}
table_formspec[0] = table_formspec_base.. -- Empty state
 "image_button[4.9,1.2;1.2,1;blank.png;nocommand;-  ;false;true;blank.png]"
table_formspec[1] = table_formspec_base..
 "image_button[4.9,1.2;1.2,1;button25.png;nocommand;-  ;false;true;button25.png]"
table_formspec[2] = table_formspec_base..
 "image_button[4.9,1.2;1.2,1;button50.png;nocommand;-  ;false;true;button50.png]"
table_formspec[3] = table_formspec_base..
 "image_button[4.9,1.2;1.2,1;button75.png;nocommand;-  ;false;true;button75.png]"
table_formspec[4] = table_formspec_base.. -- Ready to make a bundle
 "image_button[4.9,1.2;1.2,1;buttonGO.png;dyebundle;->;false;true;blank.png]"
table_formspec[5] = table_formspec_base.. -- Ready to test a treated bundle
 "image_button[4.9,1.2;1.2,1;buttonGO.png;dyetest;??;false;true;blank.png]"

local function adjust_button(pos)
   local meta = minetest.get_meta(pos)
   local inv  = meta:get_inventory()
   local craftslot = inv:get_stack("craft", 1)
   local count = craftslot:get_count() or 0
   if craftslot:get_definition()._ncrafting_bundle == 2 then
      count = 5
   end
   if not inv:is_empty("craftresult", 1) then
      count = 0
   end
   local newspec = table_formspec[count]
   meta:set_string("formspec", newspec)
end

minetest.register_node(":ncrafting:dye_table", {
	description = "Dyer's Table\n(Used to create dyes)",
	short_description = "Dyer's Table",
	tiles = { {name="tech_stick.png"}
	},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_bulky*2,
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
	   type = "fixed",
	   fixed = {
	      {-0.4375, -0.5, -0.4375, -0.3125, 0.1875, -0.375}, -- Post1
	      {0.3125, -0.5, -0.4375, 0.4375, 0.1875, -0.375}, -- Post2
	      {-0.4375, -0.5, 0.375, -0.3125, 0.1875, 0.4375}, -- Post3
	      {0.3125, -0.5, 0.375, 0.4375, 0.1875, 0.4375}, -- Post4
	      {-0.5, 0.0625, -0.375, 0.5, 0.125, -0.3125}, -- Cross1
	      {-0.5, 0.0625, 0.3125, 0.5, 0.125, 0.375}, -- Cross2
	      {-0.4375, 0.125, -0.5, -0.3125, 0.1875, 0.5}, -- Plank1
	      {-0.25, 0.125, -0.5, -0.125, 0.1875, 0.5}, -- Plank2
	      {-0.0625, 0.125, -0.5, 0.0625, 0.1875, 0.5}, -- Plank3
	      {0.125, 0.125, -0.5, 0.25, 0.1875, 0.5}, -- Plank4
	      {0.3125, 0.125, -0.5, 0.4375, 0.1875, 0.5}, -- Plank5
	   }
	},
	groups = {flammable = 1, temp_pass = 1, dig_immediate=3},
	--sounds = nodes_nature.node_sound_stone_defaults(),
	on_dig = function(pos, node, digger)
	   local inv = minetest.get_meta(pos):get_inventory()
	   if inv:is_empty("craft") and inv:is_empty("craftresult") then
	      minetest.node_dig(pos, node, digger)
	      return true
	   end
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		minimal.protection_after_place_node(pos, placer, itemstack, pointed_thing)
	   local meta = minetest.get_meta(pos)
	   meta:set_string("formspec", table_formspec[0])
	   local inv = meta:get_inventory()
	   inv:set_size("craft", 1)
	   inv:set_size("craftresult", 1)
	end,
	allow_metadata_inventory_put = function(
	      pos, listname, index, stack, player)
	   if listname == "craftresult" then -- can only add to input slot
	      return 0
	   end
	   local def = stack:get_definition()
	   local meta = minetest.get_meta(pos)
	   if def.groups.ncrafting_dye_candidate then -- plants to be bundled
	      local craftslot = meta:get_inventory():get_stack(listname, index)
	      local invcount = craftslot:get_count() or 0
	      local max = 4 - invcount
	      return max
	   end
	   if def._ncrafting_bundle == 2 then -- bundle to be checked
	      local craftslot = meta:get_inventory():get_stack(listname, index)
	      local invcount = craftslot:get_count() or 0
	      return 1 - invcount
	   end
	   return 0
	end,
	on_metadata_inventory_put = function(pos, listname, index,
					     stack, player)
	   adjust_button(pos)
	end,
	on_metadata_inventory_take = function(pos, listname, index,
					      stack, player)
	   adjust_button(pos)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
	   local meta = minetest.get_meta(pos)
	   local inv = meta:get_inventory()
	   if fields.dyebundle then -- bundle 4 plants together
	      local plants = inv:get_stack("craft", 1)
	      local pdef = plants:get_definition()
	      local plantname = pdef.name
	      local dcolor = pdef._ncrafting_dye_dcolor or "none"
	      local bundle = ItemStack("ncrafting:bundle_"..dcolor)
	      local imeta = bundle:get_meta()
	      imeta:set_string("ncrafting:bundled_plant", plantname)
	      imeta:set_string("description", bundlename(nil, plantname, nil))
	      inv:set_stack("craftresult", 1, bundle)
	      inv:set_stack("craft", 1, ItemStack(""))
	   end
	   if fields.dyetest then -- Try to turn treated bundle into a dye
	      local bundle = inv:get_stack("craft", 1)
	      local bmeta = bundle:get_meta()
	      local plants = bmeta:get_string("ncrafting:bundled_plant")
	      local treatment = bmeta:get_string("ncrafting:bundle_treatment")
	      local result = ""
	      if dye_source[plants] then
		 if dye_source[plants].method == treatment then
		    result = "ncrafting:dye_"..dye_source[plants].color.." 2"
		 else
		    minetest.sound_play("snappy.ogg", {pos = pos,
						       max_hear_distance = 8})
		 end
	      end
	      inv:set_stack("craftresult", 1, ItemStack(result))
	      inv:set_stack("craft", 1, ItemStack(""))
	   end
	   adjust_button(pos)
	end,
})

-----------------------------------------------
-- Dye pot

--#TODO: Add a way to dump a dye pot, or put water in to clear the dye

local pot_formspec = "size[8,4.1]"..
   "list[current_name;main;4,0;1,1]"..
   "list[current_player;main;0,2.3;8,4]"..
   "listring[current_name;main]"..
   "listring[current_player;main]"

local function clear_pot(pos)
   local meta = minetest.get_meta(pos)
   meta:set_string("formspec", pot_formspec)
   local inv = meta:get_inventory()
   inv:set_size("main", 1)
end

local spin_table = { [2] = 5, [5] = 3, [3] = 4,  [4] = 2 }

local function dyepot_stir(pos, puncher)
   local function not_dyable(material,dyecol)
      local shade = material:get_int("palette_index") / 8
      if dyecol == 0 or dyecol == 31 or dyecol == nil or --invalid dye colors
	 shade > 0 and ( -- not fresh cloth and...
	 (shade - 1) / 3 ~= (dyecol -1 ) / 3 or -- different colors
	 shade <= dyecol ) then -- material's dark as/darker than dye pot
	 return true
      else
	 return false
      end
   end
   local function drain_dyepot(curcolor)
      curcolor = curcolor + 1 -- increase color to next lighter shade
      if curcolor % 3 == 1 then -- have we left the color band?
	 curcolor = 0 -- no more dye left
      end
      return curcolor
   end
   local node = minetest.get_node(pos)
   local meta = minetest.get_meta(pos)
   local inv = meta:get_inventory()
   if inv:is_empty("main") then
      minetest.node_dig(pos, node, puncher)
      return true
   end
   local color = minetest.strip_param2_color(node.param2,
					     "colorwallmounted")
   local rotation = node.param2 - color
   color = color / 8 -- param2 is 8-248, shift right to 0-32 for ease of use
   local stack = inv:get_stack("main", 1)
   local stackmeta = stack:get_meta()
   if not_dyable(stackmeta, color) then return end

   local soak = meta:get_int("dye_soak") or 1
   if soak >= spins then -- finish after defined # of spin steps have stirred it
      stackmeta:set_string("palette_index",color*8)
      inv:set_stack("main", 1, stack)
      color = drain_dyepot(color)
      meta:set_int("dye_soak", 1)
   else
      meta:set_int("dye_soak", soak + 1)
   end
   node.param2 = color*8 + spin_table[rotation]
   minetest.swap_node(pos, node)
   return false
end

local function check_punch(pos, node, puncher, name)
   local playerpos = puncher:get_pos()
   playerpos.y = playerpos.y + 1 -- players look from the upper node, not lower
   local lookdir = vector.multiply(puncher:get_look_dir(), 2)
   local pointed = vector.add(playerpos, lookdir)
   local ray = minetest.raycast(playerpos, pointed, false)
   local hit = nil
   for pointed_thing in ray do
      if vector.equals(pointed_thing.under, pos) == true then
	 hit = pointed_thing.under
      end
   end
   local click = puncher:get_player_control().LMB
   if click and hit then
      stirringplayers[name] = minetest.after(stirspeed, check_punch, pos,
					     node, puncher, name)
      dyepot_stir(pos, puncher)
   elseif stirringplayers[name] then
      stirringplayers[name]:cancel()
      stirringplayers[name] = nil
   end
end

local function dyepot_punch(pos, node, puncher, pointed_thing)
   local name = puncher:get_player_name()
   if stirringplayers[name] then -- disallow multiple punches
      return
   end
   dyepot_stir(pos, puncher)
   stirringplayers[name] = minetest.after(stirspeed, check_punch, pos,
					  node, puncher, name)
end

local function add_dye(pos, stack, def)
--if a dye is added, set the pot's color
   local node = minetest.get_node(pos)
   local potdye = minetest.strip_param2_color(node.param2,
					   "colorwallmounted")
   local rot = node.param2 - potdye
   potdye = potdye / 8
   local dye = def._ncrafting_dye_color
   if potdye == 0 or potdye == 31 or
      math.floor((potdye - 1) / 3) == -- 123 -1 -> 012 = band #0, 345 = band #1
      math.floor((dye - 1) / 3) then -- same color of dye?
      node.param2 = dye * 8 + rot
      minetest.swap_node(pos, node)
      return true
   end
   return false
end

minetest.register_node(":ncrafting:dye_pot", {
	description = "Dye Pot",
	tiles = {
        -- Textures of node; +Y, -Y, +X, -X, +Z, -Z
	   {name="tech_pottery.png^[transform0", color="white"}, --spin 4
	   {name="tech_pottery.png^[transform2", color="white"}, --spin 5
	   {name="tech_pottery.png^[transform3", color="white"}, --spin 2
	   {name="tech_pottery.png^[transform1", color="white"}, --spin 3
	   {name="pottery_flat.png", color="white"}, -- top
	   {name="pottery_flat.png", color="white"}, -- bottom
	},
	overlay_tiles = {"", "", "", "", "dye_pot_top.png", "",
	},
	drawtype = "nodebox",
	stack_max = minimal.stack_max_bulky*2,
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	place_param2 = 250,
	palette = "natural_dyes.png",
	node_box = {
	   type = "fixed",
	   fixed = {
	      {-0.25, -0.25, 0.375, 0.25, 0.25, 0.5}, -- NodeBox1
	      {-0.375, -0.375, -0.25, 0.375, 0.375, 0.3125}, -- NodeBox2
	      {-0.3125, -0.3125, -0.375, 0.3125, 0.3125, -0.25}, -- NodeBox3
	      {-0.25, -0.25, -0.5, 0.25, 0.25, -0.375}, -- NodeBox4
	      {-0.3125, -0.3125, 0.3125, 0.3125, 0.3125, 0.375}, -- NodeBox5
	      {-0.125, 0.0625, 0, -0.0625, 0.125, 0.5625}, -- NodeBox6
	   }
        },
	liquids_pointable = true,
	groups = {pottery = 1, temp_pass = 1},
	--sounds = nodes_nature.node_sound_stone_defaults(),
	on_punch = dyepot_punch,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		minimal.protection_after_place_node(pos, placer, itemstack, pointed_thing)
	   local node = minetest.get_node(pos)
	   local color = tonumber(itemstack:get_meta():get_string(
				     "palette_index")) or 31*8
	   node.param2 = 2 + color
	   minetest.swap_node(pos, node)
	   clear_pot(pos)
	end,
	allow_metadata_inventory_put = function(
	      pos, listname, index, stack, player)
	   local def = stack:get_definition()
	   local palette = def.palette
	   if def._ncrafting_dye_color then
	      if add_dye(pos, stack, def) then
		 return 1
	      end
	      return 0
	   end
	   if not palette or not ( palette == "natural_dyes.png" ) then
	      return 0 -- this is not a dyeable or dyeing object
	   end
	   if def.mod_origin == "nodecrafting" then
	      return 0 -- this is a dye pot or bundle
	   end
	   return 2 -- it's a valid dyeable item
	end,
	on_metadata_inventory_put = function(pos, listname, index,
					     stack, player)
	   local def = stack:get_definition()
	   if def._ncrafting_dye_color then
	      local inv = minetest.get_inventory({type="node", pos=pos})
	      inv:remove_item(listname, stack)
	   end
	   minetest.get_meta(pos):set_string("dye_soak", 1)
	end,
})
