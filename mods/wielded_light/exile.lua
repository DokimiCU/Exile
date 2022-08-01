-- Specifics for Exile game

-- Water
wielded_light.register_lightable_node("nodes_nature:freshwater_source",
	{groups={liquid=1,not_in_creative_inventory=1}}, "freshwater_")
wielded_light.register_lightable_node("nodes_nature:freshwater_flowing",
	{groups={liquid=1,floodable=0,not_in_creative_inventory=1}},
	 "freshwater_flowing_")
wielded_light.register_lightable_node("nodes_nature:salt_water_source",
	{groups={liquid=1,not_in_creative_inventory=1}}, "salt_water_")
wielded_light.register_lightable_node("nodes_nature:salt_water_flowing",
	{groups={liquid=1,floodable=0,not_in_creative_inventory=1}},
	 "salt_water_flowing_")

-- Trees
wielded_light.register_lightable_node("nodes_nature:tree_mark", nil, "trees_")

-- Ladders / Rope
wielded_light.register_lightable_node("ropes:ropeladder", nil, "ladder_")
wielded_light.register_lightable_node("ropes:rope", nil, "rope_")
wielded_light.register_lightable_node("tech:wooden_ladder", nil, "tech_")
wielded_light.register_lightable_node("artifacts:antiquorium_ladder", nil,
				      "artifacts_")

-- Tall plants
wielded_light.register_lightable_node("nodes_nature:cana", nil, "cana_")
wielded_light.register_lightable_node("nodes_nature:chalin", nil, "chalin_")
wielded_light.register_lightable_node("nodes_nature:gemedi", nil, "gemedi_")
wielded_light.register_lightable_node("nodes_nature:tiken", nil, "tiken_")
wielded_light.register_lightable_node("nodes_nature:kelp", nil, "kelp_")


-- Set light levels for wielded items
-- Original illumination mod set 4 light level ranges

-- faint, 4, 3-7
wielded_light.register_item_light('artifacts:sculpture_mg_bloom', 4)	--5
wielded_light.register_item_light('artifacts:sculpture_mg_dancers', 4)	--5
wielded_light.register_item_light('artifacts:sculpture_mg_bonsai', 4)	--5
wielded_light.register_item_light('artifacts:moonglass', 4)		--5
wielded_light.register_item_light('artifacts:moon_stone', 4)		--7
wielded_light.register_item_light('artifacts:star_stone', 4)		--3
-- dim, 8, 8-10
wielded_light.register_item_light('tech:torch', 8)			--8
-- mid, 12, 11-12

-- full, 14, 13-15
wielded_light.register_item_light('artifacts:sun_stone', 14)		--13
