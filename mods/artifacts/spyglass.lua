-- Spyglass


--a quick look through
local function use_spyglass(player)

	player:set_fov(10, false)

	minetest.after(5, function()
			player:set_fov(0, false)
	end)

end


--  item
minetest.register_craftitem("artifacts:spyglass", {
	description = "Spyglass",
	inventory_image = "artifacts_spyglass.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		use_spyglass(user)
	end,
})
