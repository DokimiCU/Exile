--suicide.lua
--A chat command to allow users to start over

--Local table to store pending confirmations.  
local chat_confirm = {};



local function suicide_confirm (name, message)
	if (chat_confirm[name] == 'suicide') then
		if message == 'Yes' then
			local player=minetest.get_player_by_name(name)
			minetest.chat_send_all(name .. " slipped on a banana peel and broke their neck.")
			player:set_hp(0);
		else
			minetest.chat_send_player(name, "You've come to your senses and decided to keep trying")
		end
		chat_confirm[name] = nil
		return true
	end
	return false -- let other modules see it.
end


local function suicide (name, param) 
	minetest.chat_send_player(name, "Are you sure?  Reply with: Yes")
	chat_confirm[name]="suicide";
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

