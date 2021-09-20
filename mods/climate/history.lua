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

--text = text:sub(1, -2) remove last character

function load_climate_history(chist)
   --get history from storage
   climate_history = chist or ""
end

function get_climate_history()
   print("got climate history",climate_history)
   return climate_history
end

--record a chunk of climate history
function record_climate_history(climate)
   local ch = 0
   dtime = minetest.get_timeofday()
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
   t = climate.active_temp
   if t < -30 or t > 60 then
      ch = ch + 8 -- kill: 1000
   elseif t >= 0 and t <= 40 then
      ch = ch + 2 -- grow: 0010
   end
   cstring=string.format("%x", ch)
   climate_history = cstring..climate_history
end


--read out a specified chunk from the history
local function history(age)
   local chunk = {sun=false,grow=false,rain=false,kill=false}
   len = #climate_history
   if len == 0 then
      return -- No history? Why did we get called then?
   end
   len = len + 1 -- modulo will skip the last character otherwise
   --age%len: if we run out of history, loop back and fake it from what we have
   x = tonumber("0x"..climate_history.sub(age%len, 1))
   --Wish I had lua 5.3 bit operators, but some distros (mine) have old lua
   if x > 8 then
      chunk.kill = true
      return chunk
   end
   if x > 4 then
      chunk.rain = true
      x = x - 4
   end
   if x > 2 then
      chunk.grow = true
      x = x - 2
   end
   if x > 1 then
      chunk.sun = true
   end
   return chunk
end


------------------------------
-- checks the climate record, and returns how much growth to simulate
-- a -1 indicates killing temperatures were reached, and the crop is dead
--This function is only valid for the surface, underground crops are separate
function crop_rewind(duration, timer_avg, mushroom)
   local growth_ticks
   timeradjust = 60/timer_avg -- how many growth ticks per 60 second chunk
   chunks = floor(duration / 600)
   for i = 0,chunks,1
   do
      local conditions = history(i)
      if conditions == nil then -- we don't have any history!
	 print("Warning! No climate history was found, but we tried anyway")
	 growth_ticks = 0
	 break
      end
      if conditions.kill == true then
	 growth_ticks = -1
	 break
      end
      if ( conditions.sun == true or mushroom == true )
      and conditions.grow == true then
	 growth_ticks = growth_ticks + ( 1 * timeradjust )
	 if conditions.rain == true then
	    growth_ticks = growth_ticks + ( 4 * timeradjust )
	 end
      end
   end
   return floor(growth_ticks)
end
