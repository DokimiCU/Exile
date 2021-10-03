---------------------------------------------------------
--HISTORY
--A record of recent climatic conditions

--History is kept in a hexadecimal string for relatively compact storage
--We have to record four things: sunlight, rainfall, growing temperatures
-- and crop killing temperatures

--We only store data once every 600 ticks (60 seconds), it changes every
--60-120 seconds anyway. In-game days take 20 minutes so that's
-- 20 chunks of data per day, 140 per week 1600 bytes for a season
-- 6400 (6kb) for a year -- Maybe set that as max? Do we need two+ years?

--Also assumes sunlight between 0.3 and 0.7 timeofday; plants should check
-- whether they can have sun before calling crop_rewind
--  ^ minetest.get_natural_light(pos, [timeofday=]0.5)

local floor = math.floor
climate_history = ""

function load_climate_history(chist)
   --get history from storage
   climate_history = chist or ""
end

function get_climate_history()
   return climate_history
end

--record a chunk of climate history
function record_climate_history(climate)
   local ch = 0
   local dtime = minetest.get_timeofday()
   if dtime >= 0.25 and dtime <= 0.75 then
      ch = ch + 1 -- sunlight: 0001
   end
   local w = climate.active_weather.name
   if (w == 'overcast_heavy_rain'
	  or w == 'overcast_rain'
	  or w == 'thunderstorm'
       or w == 'superstorm') then
      ch = ch + 4 -- rain: 0100
   end
   local t = climate.active_temp
   if t < -30 or t > 60 then
      ch = ch + 8 -- kill: 1000
   elseif t >= 0 and t <= 40 then
      ch = ch + 2 -- grow: 0010
   end
   local cstring=string.format("%x", ch)
   climate_history = cstring..climate_history
end


--read out a specified chunk from the history
local function history(age)
   local chunk = {sun=false,grow=false,rain=false,kill=false}
   local len = #climate_history
   if len == 0 then
      return -- No history? Why did we get called then?
   end
   --age%len: if we run out of history, loop back and fake it from what we have
   age = age%(len)
   local x = tonumber("0x"..string.sub(climate_history, age+1, age+1))
   -- age+1, strings don't start counting at 0 in lua because someone hates programmers

   --Wish I had lua 5.3 bit operators, but some distros (mine) have old lua
   if x >= 8 then
      chunk.kill = true
      return chunk
   end
   if x >= 4 then
      chunk.rain = true
      x = x - 4
   end
   if x >= 2 then
      chunk.grow = true
      x = x - 2
   end
   if x >= 1 then
      chunk.sun = true
   end
   return chunk
end


------------------------------
-- checks the climate record, and returns how much growth to simulate
-- a -1 indicates killing temperatures were reached, and the crop is dead
--This function is only valid for the surface, underground crops are separate
function crop_rewind(duration, timer_avg, mushroom)
   local growth_ticks = 0
   local timeradjust = 60/timer_avg -- how many growth ticks per 60 second chunk
   local chunks = floor(duration / 60)
   for i = 0,chunks,1 do
      local conditions = history(i)
      if conditions == nil then -- we don't have any history!
	 growth_ticks = 0
	 return growth_ticks
      end
      if conditions.kill == true then
	 growth_ticks = -1
	 return growth_ticks
      end
      if ( conditions.sun == true or mushroom == true )
      and conditions.grow == true then
	 if conditions.rain == true then
	    growth_ticks = growth_ticks + ( 4 * timeradjust )
	 else
	    growth_ticks = growth_ticks + ( 1 * timeradjust )
	 end
      end
   end
   return floor(growth_ticks)
end

function exiledatestring()
   local days = minetest.get_day_count()
   local time = minetest.get_timeofday()
   local year = floor((days)/80)+1
   local cdays = (days)%80 -- days into the current year
   local seasonnumber = floor((cdays)/20)+1
   local sdays = cdays%20+1 --days into the current season
   local season = "Birth"
   if seasonnumber == 2 then
      season = "Thirst"
   elseif seasonnumber == 3 then
      season = "Retreat"
   elseif seasonnumber == 4 then
      season = "Hunger"
   end
   local timestr = "small hours"
   if time >= 0.75 then
      timestr = "evening"
   elseif time >= 0.5 then
      timestr = "afternoon"
   elseif time >= 0.25 then
      timestr = "morning"
   end
   return ("It is the "..timestr.." of day "..sdays.." of the season of "..season..", in the year of our exile "..year)
end

minetest.register_chatcommand("date", {
	params = "",
	description = "Shows the current date and year of exile.",
	privs = {},
	func = function(name, param)
	   minetest.chat_send_player(name, exiledatestring())
	end,
})
