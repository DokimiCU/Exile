local S = minetest.get_translator("schemedit")
local F = minetest.formspec_escape

local schemedit = {}

-- Directory delimeter fallback (normally comes from builtin)
if not DIR_DELIM then
	DIR_DELIM = "/"
end
local export_path_full = table.concat({minetest.get_worldpath(), "schems"}, DIR_DELIM)

-- truncated export path so the server directory structure is not exposed publicly
local export_path_trunc = table.concat({S("<world path>"), "schems"}, DIR_DELIM)

local text_color = "#D79E9E"
local text_color_number = 0xD79E9E

schemedit.markers = {}

-- [local function] Renumber table
local function renumber(t)
	local res = {}
	for _, i in pairs(t) do
		res[#res + 1] = i
	end
	return res
end

---
--- Formspec API
---

local contexts = {}
local form_data = {}
local tabs = {}
local forms = {}
local displayed_waypoints = {}

-- Sadly, the probabilities presented in Lua (0-255) are not identical to the REAL probabilities in the
-- schematic file (0-127). There are two converter functions to convert from one probability type to another.
-- This mod tries to retain the “Lua probability” as long as possible and only switches to “schematic probability”
-- on an actual export to a schematic.

function schemedit.lua_prob_to_schematic_prob(lua_prob)
	return math.floor(lua_prob / 2)
end

function schemedit.schematic_prob_to_lua_prob(schematic_prob)
	return schematic_prob * 2

end

-- [function] Add form
function schemedit.add_form(name, def)
	def.name = name
	forms[name] = def

	if def.tab then
		tabs[#tabs + 1] = name
	end
end

-- [function] Generate tabs
function schemedit.generate_tabs(current)
	local retval = "tabheader[0,0;tabs;"
	for _, t in pairs(tabs) do
		local f = forms[t]
		if f.tab ~= false and f.caption then
			retval = retval..f.caption..","

			if type(current) ~= "number" and current == f.name then
				current = _
			end
		end
	end
	retval = retval:sub(1, -2) -- Strip last comma
	retval = retval..";"..current.."]" -- Close tabheader
	return retval
end

-- [function] Handle tabs
function schemedit.handle_tabs(pos, name, fields)
	local tab = tonumber(fields.tabs)
	if tab and tabs[tab] and forms[tabs[tab]] then
		schemedit.show_formspec(pos, name, forms[tabs[tab]].name)
		return true
	end
end

-- [function] Show formspec
function schemedit.show_formspec(pos, player, tab, show, ...)
	if forms[tab] then
		if type(player) == "string" then
			player = minetest.get_player_by_name(player)
		end
		local name = player:get_player_name()

		if show ~= false then
			if not form_data[name] then
				form_data[name] = {}
			end

			local form = forms[tab].get(form_data[name], pos, name, ...)
			if forms[tab].tab then
				form = form..schemedit.generate_tabs(tab)
			end

			minetest.show_formspec(name, "schemedit:"..tab, form)
			contexts[name] = pos

			-- Update player attribute
			if forms[tab].cache_name ~= false then
				player:set_attribute("schemedit:tab", tab)
			end
		else
			minetest.close_formspec(pname, "schemedit:"..tab)
		end
	end
end

-- [event] On receive fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local formname = formname:split(":")

	if formname[1] == "schemedit" and forms[formname[2]] then
		local handle = forms[formname[2]].handle
		local name = player:get_player_name()
		if contexts[name] then
			if not form_data[name] then
				form_data[name] = {}
			end

			if not schemedit.handle_tabs(contexts[name], name, fields) and handle then
				handle(form_data[name], contexts[name], name, fields)
			end
		end
	end
end)

-- Helper function. Scans probabilities of all nodes in the given area and returns a prob_list
schemedit.scan_metadata = function(pos1, pos2)
	local prob_list = {}

	for x=pos1.x, pos2.x do
	for y=pos1.y, pos2.y do
	for z=pos1.z, pos2.z do
		local scanpos = {x=x, y=y, z=z}
		local node = minetest.get_node_or_nil(scanpos)

		local prob, force_place
		if node == nil or node.name == "schemedit:void" then
			prob = 0
			force_place = false
		else
			local meta = minetest.get_meta(scanpos)

			prob = tonumber(meta:get_string("schemedit_prob")) or 255
			local fp = meta:get_string("schemedit_force_place")
			if fp == "true" then
				force_place = true
			else
				--!!!
				force_place = true
				--force_place = false
			end
		end

		local hashpos = minetest.hash_node_position(scanpos)
		prob_list[hashpos] = {
			pos = scanpos,
			prob = prob,
			force_place = force_place,
		}
	end
	end
	end

	return prob_list
end

-- Sets probability and force_place metadata of an item.
-- Also updates item description.
-- The itemstack is updated in-place.
local function set_item_metadata(itemstack, prob, force_place)
	local smeta = itemstack:get_meta()
	local prob_desc = "\n"..S("Probability: @1", prob or
			smeta:get_string("schemedit_prob") or S("Not Set"))
	-- Update probability
	if prob and prob >= 0 and prob < 255 then
		smeta:set_string("schemedit_prob", tostring(prob))
	elseif prob and prob == 255 then
		-- Clear prob metadata for default probability
		prob_desc = ""
		smeta:set_string("schemedit_prob", nil)
	else
		prob_desc = "\n"..S("Probability: @1", smeta:get_string("schemedit_prob") or
				S("Not Set"))
	end

	-- Update force place
	if force_place == true then
		smeta:set_string("schemedit_force_place", "true")
	elseif force_place == false then
		smeta:set_string("schemedit_force_place", nil)
	end

	-- Update description
	local desc = minetest.registered_items[itemstack:get_name()].description
	local meta_desc = smeta:get_string("description")
	if meta_desc and meta_desc ~= "" then
		desc = meta_desc
	end

	local original_desc = smeta:get_string("original_description")
	if original_desc and original_desc ~= "" then
		desc = original_desc
	else
		smeta:set_string("original_description", desc)
	end

	local force_desc = ""
	if smeta:get_string("schemedit_force_place") == "true" then
		force_desc = "\n"..S("Force placement")
	end

	desc = desc..minetest.colorize(text_color, prob_desc..force_desc)

	smeta:set_string("description", desc)

	return itemstack
end

---
--- Formspec Tabs
---

schemedit.add_form("main", {
	tab = true,
	caption = S("Main"),
	get = function(self, pos, name)
		local meta = minetest.get_meta(pos):to_table().fields
		local strpos = minetest.pos_to_string(pos)
		local hashpos = minetest.hash_node_position(pos)

		local border_button
		if meta.schem_border == "true" and schemedit.markers[hashpos] then
			border_button = "button[3.5,7.5;3,1;border;"..F(S("Hide border")).."]"
		else
			border_button = "button[3.5,7.5;3,1;border;"..F(S("Show border")).."]"
		end

		-- TODO: Show information regarding volume, pos1, pos2, etc... in formspec
		local form = [[
			size[7,8]
			label[0.5,-0.1;]]..F(S("Position: @1", strpos))..[[]
			label[3,-0.1;]]..F(S("Owner: @1", name))..[[]

			field[0.8,1;5,1;name;]]..F(S("Schematic name:"))..[[;]]..F(meta.schem_name or "")..[[]
			button[5.3,0.69;1.2,1;save_name;]]..F(S("Save"))..[[]
			tooltip[save_name;]]..F(S("Save schematic name"))..[[]
			field_close_on_enter[name;false]

			button[0.5,1.5;6,1;export;]]..F(S("Export schematic"))..[[]
			textarea[0.8,2.5;6.2,5;;]]..F(S("The schematic will be exported as a .mts file and stored in\n@1",
			export_path_trunc .. DIR_DELIM .. "<name>.mts."))..[[;]
			field[0.8,7;2,1;x;]]..F(S("X size:"))..[[;]]..meta.x_size..[[]
			field[2.8,7;2,1;y;]]..F(S("Y size:"))..[[;]]..meta.y_size..[[]
			field[4.8,7;2,1;z;]]..F(S("Z size:"))..[[;]]..meta.z_size..[[]
			field_close_on_enter[x;false]
			field_close_on_enter[y;false]
			field_close_on_enter[z;false]

			button[0.5,7.5;3,1;save;]]..F(S("Save size"))..[[]
		]]..
		border_button
		if minetest.get_modpath("doc") then
			form = form .. "image_button[6.4,-0.2;0.8,0.8;doc_button_icon_lores.png;doc;]" ..
			"tooltip[doc;"..F(S("Help")).."]"
		end
		return form
	end,
	handle = function(self, pos, name, fields)
		local realmeta = minetest.get_meta(pos)
		local meta = realmeta:to_table().fields
		local hashpos = minetest.hash_node_position(pos)

		if fields.doc then
			doc.show_entry(name, "nodes", "schemedit:creator", true)
			return
		end

		-- Toggle border
		if fields.border then
			if meta.schem_border == "true" and schemedit.markers[hashpos] then
				schemedit.unmark(pos)
				meta.schem_border = "false"
			else
				schemedit.mark(pos)
				meta.schem_border = "true"
			end
		end

		-- Save size vector values
		if (fields.save or fields.key_enter_field == "x" or
				fields.key_enter_field == "y" or fields.key_enter_field == "z")
				and (fields.x and fields.y and fields.z and fields.x ~= ""
				and fields.y ~= "" and fields.z ~= "") then
			local x, y, z = tonumber(fields.x), tonumber(fields.y), tonumber(fields.z)

			if x then
				meta.x_size = math.max(x, 1)
			end
			if y then
				meta.y_size = math.max(y, 1)
			end
			if z then
				meta.z_size = math.max(z, 1)
			end
		end

		-- Save schematic name
		if fields.save_name or fields.key_enter_field == "name" and fields.name and
				fields.name ~= "" then
			meta.schem_name = fields.name
		end

		-- Export schematic
		if fields.export and meta.schem_name and meta.schem_name ~= "" then
			local pos1, pos2 = schemedit.size(pos)
			pos1, pos2 = schemedit.sort_pos(pos1, pos2)
			local path = export_path_full .. DIR_DELIM
			minetest.mkdir(path)

			local plist = schemedit.scan_metadata(pos1, pos2)
			local probability_list = {}
			for hash, i in pairs(plist) do
				local prob = schemedit.lua_prob_to_schematic_prob(i.prob)
				if i.force_place == true then
					prob = prob + 128
				end

				table.insert(probability_list, {
					pos = minetest.get_position_from_hash(hash),
					prob = prob,
				})
			end

			local slist = minetest.deserialize(meta.slices)
			local slice_list = {}
			for _, i in pairs(slist) do
				slice_list[#slice_list + 1] = {
					ypos = pos.y + i.ypos,
					prob = schemedit.lua_prob_to_schematic_prob(i.prob),
				}
			end

			local filepath = path..meta.schem_name..".mts"
			local res = minetest.create_schematic(pos1, pos2, probability_list, filepath, slice_list)

			if res then
				minetest.chat_send_player(name, minetest.colorize("#00ff00",
						S("Exported schematic to @1", filepath)))
			else
				minetest.chat_send_player(name, minetest.colorize("red",
						S("Failed to export schematic to @1", filepath)))
			end
		end

		-- Save meta before updating visuals
		local inv = realmeta:get_inventory():get_lists()
		realmeta:from_table({fields = meta, inventory = inv})

		-- Update border
		if not fields.border and meta.schem_border == "true" then
			schemedit.mark(pos)
		end

		-- Update formspec
		if not fields.quit then
			schemedit.show_formspec(pos, minetest.get_player_by_name(name), "main")
		end
	end,
})

schemedit.add_form("slice", {
	caption = S("Y Slices"),
	tab = true,
	get = function(self, pos, name, visible_panel)
		local meta = minetest.get_meta(pos):to_table().fields

		self.selected = self.selected or 1
		local selected = tostring(self.selected)
		local slice_list = minetest.deserialize(meta.slices)
		local slices = ""
		for _, i in pairs(slice_list) do
			local insert = F(S("Y = @1; Probability = @2", tostring(i.ypos), tostring(i.prob)))
			slices = slices..insert..","
		end
		slices = slices:sub(1, -2) -- Remove final comma

		local form = [[
			size[7,8]
			table[0,0;6.8,6;slices;]]..slices..[[;]]..selected..[[]
		]]

		if self.panel_add or self.panel_edit then
			local ypos_default, prob_default = "", ""
			local done_button = "button[5,7.18;2,1;done_add;"..F(S("Done")).."]"
			if self.panel_edit then
				done_button = "button[5,7.18;2,1;done_edit;"..F(S("Done")).."]"
				if slice_list[self.selected] then
					ypos_default = slice_list[self.selected].ypos
					prob_default = slice_list[self.selected].prob
				end
			end

			form = form..[[
				field[0.3,7.5;2.5,1;ypos;]]..F(S("Y position (max. @1):", (meta.y_size - 1)))..[[;]]..ypos_default..[[]
				field[2.8,7.5;2.5,1;prob;]]..F(S("Probability (0-255):"))..[[;]]..prob_default..[[]
				field_close_on_enter[ypos;false]
				field_close_on_enter[prob;false]
			]]..done_button
		end

		if not self.panel_edit then
			form = form.."button[0,6;2,1;add;"..F(S("+ Add slice")).."]"
		end

		if slices ~= "" and self.selected and not self.panel_add then
			if not self.panel_edit then
				form = form..[[
					button[2,6;2,1;remove;]]..F(S("- Remove slice"))..[[]
					button[4,6;2,1;edit;]]..F(S("+/- Edit slice"))..[[]
				]]
			else
				form = form..[[
					button[2,6;2,1;remove;]]..F(S("- Remove slice"))..[[]
					button[4,6;2,1;edit;]]..F(S("+/- Edit slice"))..[[]
				]]
			end
		end

		return form
	end,
	handle = function(self, pos, name, fields)
		local meta = minetest.get_meta(pos)
		local player = minetest.get_player_by_name(name)

		if fields.slices then
			local slices = fields.slices:split(":")
			self.selected = tonumber(slices[2])
		end

		if fields.add then
			if not self.panel_add then
				self.panel_add = true
				schemedit.show_formspec(pos, player, "slice")
			else
				self.panel_add = nil
				schemedit.show_formspec(pos, player, "slice")
			end
		end

		local ypos, prob = tonumber(fields.ypos), tonumber(fields.prob)
		if (fields.done_add or fields.done_edit) and fields.ypos and fields.prob and
		fields.ypos ~= "" and fields.prob ~= "" and ypos and prob and
				 ypos <= (meta:get_int("y_size") - 1) and prob >= 0 and prob <= 255 then
			local slice_list = minetest.deserialize(meta:get_string("slices"))
			local index = #slice_list + 1
			if fields.done_edit then
				index = self.selected
			end

			slice_list[index] = {ypos = ypos, prob = prob}

			meta:set_string("slices", minetest.serialize(slice_list))

			-- Update and show formspec
			self.panel_add = nil
			schemedit.show_formspec(pos, player, "slice")
		end

		if fields.remove and self.selected then
			local slice_list = minetest.deserialize(meta:get_string("slices"))
			slice_list[self.selected] = nil
			meta:set_string("slices", minetest.serialize(renumber(slice_list)))

			-- Update formspec
			self.selected = 1
			self.panel_edit = nil
			schemedit.show_formspec(pos, player, "slice")
		end

		if fields.edit then
			if not self.panel_edit then
				self.panel_edit = true
				schemedit.show_formspec(pos, player, "slice")
			else
				self.panel_edit = nil
				schemedit.show_formspec(pos, player, "slice")
			end
		end
	end,
})

schemedit.add_form("probtool", {
	cache_name = false,
	caption = S("Schematic Node Probability Tool"),
	get = function(self, pos, name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		local probtool = player:get_wielded_item()
		if probtool:get_name() ~= "schemedit:probtool" then
			return
		end

		local meta = probtool:get_meta()
		local prob = tonumber(meta:get_string("schemedit_prob"))
		local force_place = meta:get_string("schemedit_force_place")

		if not prob then
			prob = 255
		end
		if force_place == nil or force_place == "" then
			force_place = "false"
		end
		local form = "size[5,4]"..
			"label[0,0;"..F(S("Schematic Node Probability Tool")).."]"..
			"field[0.75,1;4,1;prob;"..F(S("Probability (0-255)"))..";"..prob.."]"..
			"checkbox[0.60,1.5;force_place;"..F(S("Force placement"))..";" .. force_place .. "]" ..
			"button_exit[0.25,3;2,1;cancel;"..F(S("Cancel")).."]"..
			"button_exit[2.75,3;2,1;submit;"..F(S("Apply")).."]"..
			"tooltip[prob;"..F(S("Probability that the node will be placed")).."]"..
			"tooltip[force_place;"..F(S("If enabled, the node will replace nodes other than air and ignore")).."]"..
			"field_close_on_enter[prob;false]"
		return form
	end,
	handle = function(self, pos, name, fields)
		if fields.submit then
			local prob = tonumber(fields.prob)
			if prob then
				local player = minetest.get_player_by_name(name)
				if not player then
					return
				end
				local probtool = player:get_wielded_item()
				if probtool:get_name() ~= "schemedit:probtool" then
					return
				end

				local force_place = self.force_place == true

				set_item_metadata(probtool, prob, force_place)

				-- Repurpose the tool's wear bar to display the set probability
				probtool:set_wear(math.floor(((255-prob)/255)*65535))

				player:set_wielded_item(probtool)
			end
		end
		if fields.force_place == "true" then
			self.force_place = true
		elseif fields.force_place == "false" then
			self.force_place = false
		end
	end,
})

---
--- API
---

--- Copies and modifies positions `pos1` and `pos2` so that each component of
-- `pos1` is less than or equal to the corresponding component of `pos2`.
-- Returns the new positions.
function schemedit.sort_pos(pos1, pos2)
	if not pos1 or not pos2 then
		return
	end

	pos1, pos2 = table.copy(pos1), table.copy(pos2)
	if pos1.x > pos2.x then
		pos2.x, pos1.x = pos1.x, pos2.x
	end
	if pos1.y > pos2.y then
		pos2.y, pos1.y = pos1.y, pos2.y
	end
	if pos1.z > pos2.z then
		pos2.z, pos1.z = pos1.z, pos2.z
	end
	return pos1, pos2
end

-- [function] Prepare size
function schemedit.size(pos)
	local pos1   = vector.new(pos)
	local meta   = minetest.get_meta(pos)
	local node   = minetest.get_node(pos)
	local param2 = node.param2
	local size   = {
		x = meta:get_int("x_size"),
		y = math.max(meta:get_int("y_size") - 1, 0),
		z = meta:get_int("z_size"),
	}

	if param2 == 1 then
		local new_pos = vector.add({x = size.z, y = size.y, z = -size.x}, pos)
		pos1.x = pos1.x + 1
		new_pos.z = new_pos.z + 1
		return pos1, new_pos
	elseif param2 == 2 then
		local new_pos = vector.add({x = -size.x, y = size.y, z = -size.z}, pos)
		pos1.z = pos1.z - 1
		new_pos.x = new_pos.x + 1
		return pos1, new_pos
	elseif param2 == 3 then
		local new_pos = vector.add({x = -size.z, y = size.y, z = size.x}, pos)
		pos1.x = pos1.x - 1
		new_pos.z = new_pos.z - 1
		return pos1, new_pos
	else
		local new_pos = vector.add(size, pos)
		pos1.z = pos1.z + 1
		new_pos.x = new_pos.x - 1
		return pos1, new_pos
	end
end

-- [function] Mark region
function schemedit.mark(pos)
	schemedit.unmark(pos)

	local id = minetest.hash_node_position(pos)
	local owner = minetest.get_meta(pos):get_string("owner")
	local pos1, pos2 = schemedit.size(pos)
	pos1, pos2 = schemedit.sort_pos(pos1, pos2)

	local thickness = 0.2
	local sizex, sizey, sizez = (1 + pos2.x - pos1.x) / 2, (1 + pos2.y - pos1.y) / 2, (1 + pos2.z - pos1.z) / 2
	local m = {}
	local low = true
	local offset

	-- XY plane markers
	for _, z in ipairs({pos1.z - 0.5, pos2.z + 0.5}) do
		if low then
			offset = -0.01
		else
			offset = 0.01
		end
		local marker = minetest.add_entity({x = pos1.x + sizex - 0.5, y = pos1.y + sizey - 0.5, z = z + offset}, "schemedit:display")
		if marker ~= nil then
			marker:set_properties({
				visual_size={x=(sizex+0.01) * 2, y=sizey * 2},
			})
			marker:get_luaentity().id = id
			marker:get_luaentity().owner = owner
			table.insert(m, marker)
		end
		low = false
	end

	low = true
	-- YZ plane markers
	for _, x in ipairs({pos1.x - 0.5, pos2.x + 0.5}) do
		if low then
			offset = -0.01
		else
			offset = 0.01
		end

		local marker = minetest.add_entity({x = x + offset, y = pos1.y + sizey - 0.5, z = pos1.z + sizez - 0.5}, "schemedit:display")
		if marker ~= nil then
			marker:set_properties({
				visual_size={x=(sizez+0.01) * 2, y=sizey * 2},
			})
			marker:set_yaw(math.pi / 2)
			marker:get_luaentity().id = id
			marker:get_luaentity().owner = owner
			table.insert(m, marker)
		end
		low = false
	end

	schemedit.markers[id] = m
	return true
end

-- [function] Unmark region
function schemedit.unmark(pos)
	local id = minetest.hash_node_position(pos)
	if schemedit.markers[id] then
		local retval
		for _, entity in ipairs(schemedit.markers[id]) do
			entity:remove()
			retval = true
		end
		return retval
	end
end

---
--- Mark node probability values near player
---

-- Show probability and force_place status of a particular position for player in HUD.
-- Probability is shown as a number followed by “[F]” if the node is force-placed.
-- The distance to the node is also displayed below that. This can't be avoided and is
-- and artifact of the waypoint HUD element. TODO: Hide displayed distance.
function schemedit.display_node_prob(player, pos, prob, force_place)
	local wpstring
	if prob and force_place == true then
		wpstring = string.format("%d [F]", prob)
	elseif prob then
		wpstring = prob
	elseif force_place == true then
		wpstring = "[F]"
	end
	if wpstring then
		return player:hud_add({
			hud_elem_type = "waypoint",
			name = wpstring,
			text = "m", -- For the distance artifact
			number = text_color_number,
			world_pos = pos,
		})
	end
end

-- Display the node probabilities and force_place status of the nodes in a region.
-- By default, this is done for nodes near the player (distance: 5).
-- But the boundaries can optionally be set explicitly with pos1 and pos2.
function schemedit.display_node_probs_region(player, pos1, pos2)
	local playername = player:get_player_name()
	local pos = vector.round(player:get_pos())

	local dist = 5
	-- Default: 5 nodes away from player in any direction
	if not pos1 then
		pos1 = vector.subtract(pos, dist)
	end
	if not pos2 then
		pos2 = vector.add(pos, dist)
	end
	for x=pos1.x, pos2.x do
		for y=pos1.y, pos2.y do
			for z=pos1.z, pos2.z do
				local checkpos = {x=x, y=y, z=z}
				local nodehash = minetest.hash_node_position(checkpos)

				-- If node is already displayed, remove it so it can re replaced later
				if displayed_waypoints[playername][nodehash] then
					player:hud_remove(displayed_waypoints[playername][nodehash])
					displayed_waypoints[playername][nodehash] = nil
				end

				local prob, force_place
				local meta = minetest.get_meta(checkpos)
				prob = tonumber(meta:get_string("schemedit_prob"))
				force_place = meta:get_string("schemedit_force_place") == "true"
				local hud_id = schemedit.display_node_prob(player, checkpos, prob, force_place)
				if hud_id then
					displayed_waypoints[playername][nodehash] = hud_id
					displayed_waypoints[playername].display_active = true
				end
			end
		end
	end
end

-- Remove all active displayed node statuses.
function schemedit.clear_displayed_node_probs(player)
	local playername = player:get_player_name()
	for nodehash, hud_id in pairs(displayed_waypoints[playername]) do
		player:hud_remove(hud_id)
		displayed_waypoints[playername][nodehash] = nil
		displayed_waypoints[playername].display_active = false
	end
end

minetest.register_on_joinplayer(function(player)
	displayed_waypoints[player:get_player_name()] = {
		display_active = false	-- If true, there *might* be at least one active node prob HUD display
					-- If false, no node probabilities are displayed for sure.
	}
end)

minetest.register_on_leaveplayer(function(player)
	displayed_waypoints[player:get_player_name()] = nil
end)

-- Regularily clear the displayed node probabilities and force_place
-- for all players who do not wield the probtool.
-- This makes sure the screen is not spammed with information when it
-- isn't needed.
local cleartimer = 0
minetest.register_globalstep(function(dtime)
	cleartimer = cleartimer + dtime
	if cleartimer > 2 then
		local players = minetest.get_connected_players()
		for p = 1, #players do
			local player = players[p]
			local pname = player:get_player_name()
			if displayed_waypoints[pname].display_active then
				local item = player:get_wielded_item()
				if item:get_name() ~= "schemedit:probtool" then
					schemedit.clear_displayed_node_probs(player)
				end
			end
		end
		cleartimer = 0
	end
end)

---
--- Registrations
---

-- [priv] schematic_override
minetest.register_privilege("schematic_override", {
	description = S("Allows you to access schemedit nodes not owned by you"),
	give_to_singleplayer = false,
})

-- [node] Schematic creator
minetest.register_node("schemedit:creator", {
	description = S("Schematic Creator"),
	_doc_items_longdesc = S("The schematic creator is used to save a region of the world into a schematic file (.mts)."),
	_doc_items_usagehelp = S("To get started, place the block facing directly in front of any bottom left corner of the structure you want to save. This block can only be accessed by the placer or by anyone with the “schematic_override” privilege.").."\n"..
S("To save a region, use the block, enter the size and a schematic name and hit “Export schematic”. The file will always be saved in the world directory. Note you can use this name in the /placeschem command to place the schematic again.").."\n\n"..
S("The other features of the schematic creator are optional and are used to allow to add randomness and fine-tuning.").."\n\n"..
S("Y slices are used to remove entire slices based on chance. For each slice of the schematic region along the Y axis, you can specify that it occurs only with a certain chance. In the Y slice tab, you have to specify the Y slice height (0 = bottom) and a probability from 0 to 255 (255 is for 100%). By default, all Y slices occur always.").."\n\n"..
S("With a schematic node probability tool, you can set a probability for each node and enable them to overwrite all nodes when placed as schematic. This tool must be used prior to the file export."),
	tiles = {"schemedit_creator_top.png", "schemedit_creator_bottom.png",
			"schemedit_creator_sides.png"},
	groups = { dig_immediate = 2},
	paramtype2 = "facedir",
	is_ground_content = false,

	after_place_node = function(pos, player)
		local name = player:get_player_name()
		local meta = minetest.get_meta(pos)

		meta:set_string("owner", name)
		meta:set_string("infotext", S("Schematic Creator").."\n"..S("(owned by @1)", name))
		meta:set_string("prob_list", minetest.serialize({}))
		meta:set_string("slices", minetest.serialize({}))

		local node = minetest.get_node(pos)
		local dir  = minetest.facedir_to_dir(node.param2)

		meta:set_int("x_size", 1)
		meta:set_int("y_size", 1)
		meta:set_int("z_size", 1)

		-- Don't take item from itemstack
		return true
	end,
	can_dig = function(pos, player)
		local name = player:get_player_name()
		local meta = minetest.get_meta(pos)
		if meta:get_string("owner") == name or
				minetest.check_player_privs(player, "schematic_override") == true then
			return true
		end

		return false
	end,
	on_rightclick = function(pos, node, player)
		local meta = minetest.get_meta(pos)
		local name = player:get_player_name()
		if meta:get_string("owner") == name or
				minetest.check_player_privs(player, "schematic_override") == true then
			-- Get player attribute
			local tab = player:get_attribute("schemedit:tab")
			if not forms[tab] or not tab then
				tab = "main"
			end

			schemedit.show_formspec(pos, player, tab, true)
		end
	end,
	after_destruct = function(pos)
		schemedit.unmark(pos)
	end,
})

minetest.register_tool("schemedit:probtool", {
	description = S("Schematic Node Probability Tool"),
	_doc_items_longdesc =
S("This is an advanced tool which only makes sense when used together with a schematic creator. It is used to finetune the way how nodes from a schematic are placed.").."\n"..
S("It allows you to set two things:").."\n"..
S("1) Set probability: Chance for any particular node to be actually placed (default: always placed)").."\n"..
S("2) Enable force placement: These nodes replace node other than air and ignore when placed in a schematic (default: off)"),
	_doc_items_usagehelp = "\n"..
S("BASIC USAGE:").."\n"..
S("Punch to configure the tool. Select a probability (0-255; 255 is for 100%) and enable or disable force placement. Now place the tool on any node to apply these values to the node. This information is preserved in the node until it is destroyed or changed by the tool again. This tool has no effect on schematic voids.").."\n"..
S("Now you can use a schematic creator to save a region as usual, the nodes will now be saved with the special node settings applied.").."\n\n"..
S("NODE HUD:").."\n"..
S("To help you remember the node values, the nodes with special values are labelled in the HUD. The first line shows probability and force placement (with “[F]”). The second line is the current distance to the node. Nodes with default settings and schematic voids are not labelled.").."\n"..
S("To disable the node HUD, unselect the tool or hit “place” while not pointing anything.").."\n\n"..
S("UPDATING THE NODE HUD:").."\n"..
S("The node HUD is not updated automatically and may be outdated. The node HUD only updates the HUD for nodes close to you whenever you place the tool or press the punch and sneak keys simutanously. If you sneak-punch a schematic creator, then the node HUD is updated for all nodes within the schematic creator's region, even if this region is very big."),
	wield_image = "schemedit_probtool.png",
	inventory_image = "schemedit_probtool.png",
	liquids_pointable = true,
	groups = { disable_repair = 1 },
	on_use = function(itemstack, user, pointed_thing)
		local ctrl = user:get_player_control()
		-- Simple use
		if not ctrl.sneak then
			-- Open dialog to change the probability to apply to nodes
			schemedit.show_formspec(user:get_pos(), user, "probtool", true)

		-- Use + sneak
		else
			-- Display the probability and force_place values for nodes.

			-- If a schematic creator was punched, only enable display for all nodes
			-- within the creator's region.
			local use_creator_region = false
			if pointed_thing and pointed_thing.type == "node" and pointed_thing.under then
				punchpos = pointed_thing.under
				local node = minetest.get_node(punchpos)
				if node.name == "schemedit:creator" then
					local pos1, pos2 = schemedit.size(punchpos)
					pos1, pos2 = schemedit.sort_pos(pos1, pos2)
					schemedit.display_node_probs_region(user, pos1, pos2)
					return
				end
			end

			-- Otherwise, just display the region close to the player
			schemedit.display_node_probs_region(user)
		end
	end,
	on_secondary_use = function(itemstack, user, pointed_thing)
		schemedit.clear_displayed_node_probs(user)
	end,
	-- Set note probability and force_place and enable node probability display
	on_place = function(itemstack, placer, pointed_thing)
		-- Use pointed node's on_rightclick function first, if present
		local node = minetest.get_node(pointed_thing.under)
		if placer and not placer:get_player_control().sneak then
			if minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_rightclick then
				return minetest.registered_nodes[node.name].on_rightclick(pointed_thing.under, node, placer, itemstack) or itemstack
			end
		end

		-- This sets the node probability of pointed node to the
		-- currently used probability stored in the tool.
		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		-- Schematic void are ignored, they always have probability 0
		if node.name == "schemedit:void" then
			return itemstack
		end
		local nmeta = minetest.get_meta(pos)
		local imeta = itemstack:get_meta()
		local prob = tonumber(imeta:get_string("schemedit_prob"))
		local force_place = imeta:get_string("schemedit_force_place")

		if not prob or prob == 255 then
			nmeta:set_string("schemedit_prob", nil)
		else
			nmeta:set_string("schemedit_prob", prob)
		end
		if force_place == "true" then
			nmeta:set_string("schemedit_force_place", "true")
		else
			nmeta:set_string("schemedit_force_place", nil)
		end

		-- Enable node probablity display
		schemedit.display_node_probs_region(placer)

		return itemstack
	end,
})

minetest.register_node("schemedit:void", {
	description = S("Schematic Void"),
	_doc_items_longdesc = S("This is an utility block used in the creation of schematic files. It should be used together with a schematic creator. When saving a schematic, all nodes with a schematic void will be left unchanged when the schematic is placed again. Technically, this is equivalent to a block with the node probability set to 0."),
	_doc_items_usagehelp = S("Just place the schematic void like any other block and use the schematic creator to save a portion of the world."),
	tiles = { "schemedit_void.png" },
	drawtype = "nodebox",
	is_ground_content = false,
	paramtype = "light",
	walkable = false,
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{ -4/16, -4/16, -4/16, 4/16, 4/16, 4/16 },
		},
	},
	groups = { dig_immediate = 3},
})

-- [entity] Visible schematic border
minetest.register_entity("schemedit:display", {
	visual = "upright_sprite",
	textures = {"schemedit_border.png"},
	visual_size = {x=10, y=10},
	pointable = false,
	physical = false,
	glow = minetest.LIGHT_MAX,

	on_step = function(self, dtime)
		if not self.id then
			self.object:remove()
		elseif not schemedit.markers[self.id] then
			self.object:remove()
		end
	end,
	on_activate = function(self)
		self.object:set_armor_groups({immortal = 1})
	end,
})

-- [chatcommand] Place schematic
minetest.register_chatcommand("placeschem", {
	description = S("Place schematic at the position specified or the current player position (loaded from @1)", export_path_trunc),
	privs = {debug = true},
	params = S("<schematic name>[.mts] [<x> <y> <z>]"),
	func = function(name, param)
		local schem, p = string.match(param, "^([^ ]+) *(.*)$")
		local pos = minetest.string_to_pos(p)

		if not schem then
			return false, S("No schematic file specified.")
		end

		if not pos then
			pos = minetest.get_player_by_name(name):get_pos()
		end

		-- Automatiically add file name suffix if omitted
		local schem_full
		if string.sub(schem, string.len(schem)-3, string.len(schem)) == ".mts" then
			schem_full = schem
		else
			schem_full = schem .. ".mts"
		end

		local success = minetest.place_schematic(pos, export_path_full .. DIR_DELIM .. schem_full, "random", nil, false)

		if success == nil then
			return false, S("Schematic file could not be loaded!")
		else
			return true
		end
	end,
})
