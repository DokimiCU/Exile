------------------------------------
--PANDORA's BOX
--Are you sure you want to open that?
--This is for things that are strange, dangerous, creepy, insane, generally misguided etc
------------------------------------


------------------------------------
--BAD GOOD IDEAS and GOOD BAD IDEAS
--things that might even be useful, but are slightly problematic
------------------------------------

--Meta-Stim Injector
-- because you want to be a god
local function inject_metastim(itemstack, player, pointed_thing)
  --local meta = player:get_meta()
  player:set_hp(1)
  local pos = player:get_pos()

  HEALTH.add_new_effect(player, {"Meta-Stim", 1})
  --I am a GOD!
  minetest.sound_play( {name="health_superpower", gain=1}, {pos=pos, max_hear_distance=20})
  minetest.add_particlespawner({
    amount = 80,
    time = 18,
    minpos = {x=pos.x+7, y=pos.y+7, z=pos.z+7},
    maxpos = {x=pos.x-7, y=pos.y-7, z=pos.z-7},
    minvel = {x = -5,  y = -5,  z = -5},
    maxvel = {x = 5, y = 5, z = 5},
    minacc = {x = -3, y = -3, z = -3},
    maxacc = {x = 3, y = 3, z = 3},
    minexptime = 0.2,
    maxexptime = 1,
    minsize = 0.5,
    maxsize = 2,
    texture = "health_superpower.png",
    glow = 15,
  })

  itemstack:add_wear(65535/(20-1))

  return itemstack

end


minetest.register_tool('artifacts:metastim', {
    description = 'Meta-Stim Injector',
    inventory_image = 'artifacts_metastim.png',
		on_use = inject_metastim,
})

------------------------------------
--CURIOSITIES
------------------------------------


------------------------------------
--THE DANGEROUS AND EVIL
------------------------------------
