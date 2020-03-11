-------------------------------------------------------
local modpath = minetest.get_modpath("exile_env_sounds")

--dofile(modpath .. "/flowing_water.lua")
--dofile(modpath .. "/beach_waves.lua")


local ran = math.random
local min = math.min

------------------------------------------------
local radius = 8 -- Water node search radius around player

-- End of parameters


----------------------------------------------
--
local function posav(npos, num)
  local posav = vector.new()
  for _, pos in ipairs(npos) do
		posav.x = posav.x + pos.x
		posav.y = posav.y + pos.y
		posav.z = posav.z + pos.z
	end
	posav = vector.divide(posav, num)

  return 	posav
end



-- Update sound for player

local function update_sound(player)
	local player_name = player:get_player_name()
	local ppos = player:get_pos()

	local areamin = vector.subtract(ppos, radius)
	local areamax = vector.add(ppos, radius)

  --flowing water
  if ran()<0.7 then
  	local water_nodes = {"nodes_nature:freshwater_flowing", "nodes_nature:salt_water_flowing"}
  	local wpos, _ = minetest.find_nodes_in_area(areamin, areamax, water_nodes)
  	local waters = #wpos
  	if waters <= 2 then
  		return
  	end

  	-- Find average position of water positions
  	minetest.sound_play(
  		"env_sounds_water",
  		{
  			pos = posav(wpos, waters),
  			to_player = player_name,
  			gain = min(0.04 + waters * 0.004, 0.4),
  		}
  	)
  end

  --beach sounds
  if ran()<0.7 then
    if ppos.y > radius or ppos.y < -radius then
  		return
  	end

    local water_nodes = {"nodes_nature:salt_water_flowing", "nodes_nature:salt_water_source"}
    local wpos, _ = minetest.find_nodes_in_area(areamin, areamax, water_nodes)
    local waters = #wpos
    if waters <= 9 then
      return
    end

    local ground_nodes = {"group:crumbly", "group:cracky"}
    local gpos = minetest.find_node_near(ppos, 2, ground_nodes)
    if not gpos then
      return
    end

    -- Find average position of water positions
    minetest.sound_play(
      "env_sounds_waves",
      {
        pos = posav(wpos, waters),
        to_player = player_name,
        gain = min(0.06 + waters * 0.006, 1),
      }
    )
  end


end


-- Update sound 'on joinplayer'

minetest.register_on_joinplayer(function(player)
	update_sound(player)
end)


-- Cyclic sound update

local function cyclic_update()
	for _, player in pairs(minetest.get_connected_players()) do
		update_sound(player)
	end
	minetest.after(4, cyclic_update)
end

minetest.after(0, cyclic_update)
