----------------------------------------------------------
clothing = {
}

clothing.update_temp = function(self, player)
-- set clothing and update comfortable temperature range
--[[
clothing temp_min: subtracted from minimum temperature tolerance
clothing temp_max: added to maximum temperature tolerance

e.g. if current comfort range is 21 to 35 then...
temp_min: 6
temp_max: -8
new range = 15 to 28 (e.g. you put on a warm coat)

note: ranges are
-comfort zone: no energy drain
-stress zone: some energy drain
-danger zone: large energy drain
-extreme zone: direct damage

]]

-- default range, no clothes yet
   local temp_min = 20
   local temp_max = 30

   if not player then
		return
	end
	local name = player:get_player_name()
	local inv = player:get_inventory():get_list("cloths")
	for i=1, 5 do
		local stack = ItemStack(inv[i])
		if stack:get_count() == 1 then
			local def = stack:get_definition()
			-- set comfortable temperature range
			if def.temp_min and def.temp_max then
			   temp_min = temp_min - def.temp_min
			   temp_max = temp_max + def.temp_max
			end
		end
	end
	-- apply new temperature comfort range
	local meta = player:get_meta()
	meta:set_int("clothing_temp_min", temp_min)
	meta:set_int("clothing_temp_max", temp_max )
	sfinv.set_player_inventory_formspec(player)
end
