--suicide.lua
--A chat command to allow users to start over

--Local table to store pending confirmations.  
local chat_confirm = {};
local timestamp = {}

local function killplayer(name)
   local player=minetest.get_player_by_name(name)
   local inv = player:get_inventory()
   if inv:is_empty("cloths") then
      -- no clothes, try to pull an exile letter and see if main's empty then
      local tmp = inv:remove_item("main", ItemStack("lore:exile_letter 1"))
      if not inv:is_empty("main") then
	 inv:add_item("main", tmp) -- he's got other stuff, put it back
      end
   end
   player:set_hp(0)
end

local function suicide_confirm (name, message)
	if (chat_confirm[name] == 'suicide') then
		if message == 'Yes' or message == "yes" then
			minetest.chat_send_all(name .. " succumbed to despair and gave in to their fate.")
			timestamp[name] = minetest.get_gametime()
			killplayer(name)
		else
			minetest.chat_send_player(name, "You've come to your senses and decided to keep trying")
		end
		chat_confirm[name] = nil
		return true
	end
	return false -- let other modules see it.
end

local function suicide (name, param)
	local nowtime = minetest.get_gametime()
	if timestamp[name] and ( timestamp[name] +300 ) > nowtime then
	   minetest.chat_send_player(name, "You can't use this command more than once per 5 minutes.")
	   return
	else
	   timestamp[name] = nil
	   minetest.chat_send_player(name, "Are you sure?  Reply with: Yes")
	   chat_confirm[name]="suicide";
	end
end

minetest.register_chatcommand("suicide",{
	privs = {
		interact = true,
	},
	func = suicide
})
minetest.register_chatcommand("killme",{
	privs = {
		interact = true,
	},
	func = suicide
})
minetest.register_chatcommand("respawn",{
	privs = {
		interact = true,
	},
	func = suicide
})


minetest.register_on_chat_message(suicide_confirm)

