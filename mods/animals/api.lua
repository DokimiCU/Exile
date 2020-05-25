local random = math.random
local pi = math.pi
local time = os.time
local sqrt = math.sqrt

local abs = math.abs
local floor = math.floor
local ceil = math.ceil
local max = math.max
local min = math.min
local tan = math.tan
local pow = math.pow




--------------------------------------------------------------------------
--basic
--------------------------------------------------------------------------


-- returns 2D angle from self to target in radians
local function get_yaw_to_object(pos, opos)
  local ankat = pos.x - opos.x
  local gegkat = pos.z - opos.z
  local yaw = math.atan2(ankat, gegkat)
  return yaw
end


--flee sound (has to be in water!)
local function flee_sound(self)
	if not self.isinliquid then
		return
	end
	mobkit.make_sound(self,'flee')
end

--------------------------------------------------------------------------
--Life and death
--------------------------------------------------------------------------

----------------------------------------------------
-- drop on death what is definded in the entity table
function animals.handle_drops(self)
   if not self.drops then
     return
   end

   for _,item in ipairs(self.drops) do

     local amount = random (item.min, item.max)
     local chance = random(1,100)
     local pos = self.object:get_pos()
     pos.x = pos.x + random(-1,1)
     pos.z = pos.z + random(-1,1)

     if chance < (100/item.chance) then
       --leave time for death animation to end
       minetest.after(5, function()
         minetest.add_item(pos, item.name.." "..tostring(amount))
       end)
     end

   end
 end

----------------------------------------------------
--core health
function animals.core_hp(self)
  --default drowing and fall damage
  mobkit.vitals(self)
  --die from damage
  local hp = self.hp
  if hp <= 0 then
    mobkit.clear_queue_high(self)
    animals.handle_drops(self)
    mobkit.hq_die(self)
    return false
  else
    return true
  end
end



function animals.core_hp_water(self)

  if not self.isinliquid then
    mobkit.hurt(self,1)
  end

  --die from damage
  local hp = self.hp
  if hp <= 0 then
    mobkit.clear_queue_high(self)
    animals.handle_drops(self)
    mobkit.hq_die(self)
    return false
  else
    return true
  end
end

----------------------------------------------------
--core health, energy and age
function animals.core_life(self, lifespan, pos)

  local energy = mobkit.recall(self,'energy')
  local age = mobkit.recall(self,'age')

  --stops some crashes in creative?
  if not energy then
    energy = 1
  end
  if not age then
    age = 0
  end

  age = age + 1
  energy = energy - 1

  --die from exhaustion, old age
  if energy <=0 or age > lifespan then
    mobkit.clear_queue_high(self)
    animals.handle_drops(self)
    mobkit.hq_die(self)
    return nil
  end

  --temperature stress
  local temp = climate.get_point_temp(pos)
  if temp < self.min_temp or temp > self.max_temp then
    energy = energy - 1
  end


  --heal using energy
  if self.hp < self.max_hp and energy > 10 then
    mobkit.heal(self,1)
    energy = energy - 1
  end

  return age, energy
end



----------------------------------------------------
--put an egg in the world, return energy
function animals.place_egg(pos, egg_name, energy, energy_egg, medium)
  local p = mobkit.get_node_pos(pos)
  if minetest.get_node(p).name == medium then
    local posu = {x = p.x, y = p.y - 1, z = p.z}
    local n = mobkit.nodeatpos(posu)
    if n and n.walkable then
      minetest.set_node(p, {name = egg_name})
      energy = energy - energy_egg
      return energy
    end
  end

end


----------------------------------------------------
--release offspring from an egg (called from timers)
function animals.hatch_egg(pos, medium_name, replace_name, name, energy_egg, young_per_egg)

  local air = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, {medium_name})
  --if can't find the stuff this mob moves through then it dies
	if #air < 1 then
		minetest.set_node(pos, {name = replace_name})
		return false
	end

  local cnt = 0
  local start_e = energy_egg/young_per_egg

  while cnt < young_per_egg do
    local ran_pos = air[random(#air)]
    local ent = minetest.add_entity(ran_pos, name)
    minetest.sound_play("animals_hatch_egg", {pos = pos, gain = 0.2, max_hear_distance = 6})
    ent = ent:get_luaentity()
    mobkit.remember(ent,'energy', start_e)
    mobkit.remember(ent,'age',0)

    cnt = cnt + 1
  end

  minetest.set_node(pos, {name = replace_name})
  return false

end

 --------------------------------------------------------------------------
 --Movement
 --------------------------------------------------------------------------



----------------------------------------------
--roam to places with equal or lesser darkness
function animals.hq_roam_dark(self,prty)
	local func=function(self)
		if mobkit.is_queue_empty_low(self) and self.isonground then
			local pos = mobkit.get_stand_pos(self)
			local neighbor = random(8)

			local height, tpos, liquidflag = mobkit.is_neighbor_node_reachable(self,neighbor)

			if height and not liquidflag then
       local light = minetest.get_node_light(pos, 0.5)
       local lightn = minetest.get_node_light(tpos, 0.5)
       if lightn <= light then
         mobkit.dumbstep(self,height,tpos,0.3)
       end
     end
		end
	end
	mobkit.queue_high(self,func,prty)
end




 ---------------------------------------------------
--(currently duplicated in mobkit, but only as a local function)
local function aqua_radar_dumb(pos,yaw,range,reverse)
 range = range or 4

 local function okpos(p)
   local node = mobkit.nodeatpos(p)
   if node then
     if node.drawtype == 'liquid' then
       local nodeu = mobkit.nodeatpos(mobkit.pos_shift(p,{y=1}))
       local noded = mobkit.nodeatpos(mobkit.pos_shift(p,{y=-1}))
       if (nodeu and nodeu.drawtype == 'liquid') or (noded and noded.drawtype == 'liquid') then
         return true
       else
         return false
       end
     else
       local h,l = mobkit.get_terrain_height(p)
       if h then
         local node2 = mobkit.nodeatpos({x=p.x,y=h+1.99,z=p.z})
         if node2 and node2.drawtype == 'liquid' then return true, h end
       else
         return false
       end
     end
   else
     return false
   end
 end

 local fpos = mobkit.pos_translate2d(pos,yaw,range)
 local ok,h = okpos(fpos)
 if not ok then
   local ffrom, fto, fstep
   if reverse then
     ffrom, fto, fstep = 3,1,-1
   else
     ffrom, fto, fstep = 1,3,1
   end
   for i=ffrom, fto, fstep  do
     local ok,h = okpos(mobkit.pos_translate2d(pos,yaw+i,range))
     if ok then
       return yaw+i,h
     end
     ok,h = okpos(mobkit.pos_translate2d(pos,yaw-i,range))
     if ok then
       return yaw-i,h
     end
   end
   return yaw+pi,h
 else
   return yaw, h
 end
end




---------------------------------------------------
-- turn around  from tgtob and swim away until out of sight
function animals.hq_swimfrom(self,prty,tgtobj,speed)
  local timer = time() + 30

  local func = function(self)
    if time() > timer then
      return true
    end

    if not mobkit.is_alive(tgtobj) then
      return true
    end

    local pos = mobkit.get_stand_pos(self)
    local opos = tgtobj:get_pos()

    local yaw = get_yaw_to_object(pos, opos) - (pi/2)
    local distance = vector.distance(pos,opos)

    if (distance/1.5) < self.view_range then
      local swimto, height = aqua_radar_dumb(pos,yaw,3)
      if height and height > pos.y then
        local vel = self.object:get_velocity()
        vel.y = vel.y+0.1
        self.object:set_velocity(vel)
      end

      mobkit.hq_aqua_turn(self,51,swimto,speed)

    else
      return true
    end
    timer = timer - 1

  end
  mobkit.queue_high(self,func,prty)
 end

 ---------------------------------------------------
 -- chase tgtob and swim until somewhat out of sight
 function animals.hq_swimafter(self,prty,tgtobj,speed)
   local timer = time() + 15

   local func = function(self)
     if time() > timer then
       return true
     end

     if not mobkit.is_alive(tgtobj) then
       return true
     end

     local pos = mobkit.get_stand_pos(self)
     local opos = tgtobj:get_pos()

     local yaw = get_yaw_to_object(pos, opos) -pi
     local distance = vector.distance(pos,opos)

     if distance < self.view_range/3 then
       local swimto, height = aqua_radar_dumb(pos,yaw,3)
       if height and height > pos.y then
         local vel = self.object:get_velocity()
         vel.y = vel.y+0.1
         self.object:set_velocity(vel)
       end

       mobkit.hq_aqua_turn(self,51,swimto,speed)

     else
       return true
     end

   end
   mobkit.queue_high(self,func,prty)
 end





--------------------------------------------------------------------------
--Attack and feeding
--------------------------------------------------------------------------

----------------------------------------------------------------
--on_punch
function animals.on_punch(self, tool_capabilities, puncher, prty, chance)
  if mobkit.is_alive(self) then
    --do damage
    mobkit.clear_queue_high(self)
    mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
    mobkit.make_sound(self,'punch')

    --fight or flight
    animals.fight_or_flight(self, puncher, prty, chance)

  end
end


function animals.on_punch_water(self, tool_capabilities, puncher, prty, chance)
  if mobkit.is_alive(self) then
    --do damage
    mobkit.clear_queue_high(self)
    mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
    mobkit.make_sound(self,'punch')

    --fight or flight
    animals.fight_or_flight_water(self, puncher, prty, chance)

  end
end

----------------------------------------------------------------
--attack or run vs player
function animals.fight_or_flight_plyr(self, plyr, prty, chance)
  --fight chance, or run away (don't do it attach bc buggers physics)
  if random()< chance and plyr:get_attach() == nil then
    mobkit.hq_warn(self,prty,plyr)
  else
    mobkit.animate(self,'fast')
    mobkit.make_sound(self,'warn')
    mobkit.hq_runfrom(self,prty, plyr)
  end
end

--attack or run vs entity
function animals.fight_or_flight(self, threat, prty, chance)
  --fight chance, or run away
  if random()< chance then
    mobkit.hq_warn(self,prty, threat)
  else
    mobkit.animate(self,'fast')
    mobkit.make_sound(self,'warn')
    mobkit.hq_runfrom(self,prty, threat)
  end
end




----attack or run vs player in water
function animals.fight_or_flight_plyr_water(self, plyr, prty, chance)
  --ignore chance, or run away
  if random()< chance and plyr:get_attach() == nil then
    mobkit.hq_aqua_attack(self, prty, plyr, self.max_speed)
  else
    mobkit.animate(self,'fast')
    animals.hq_swimfrom(self, prty, plyr, self.max_speed)
    flee_sound(self)
  end
end

----attack or run vs player in water
function animals.fight_or_flight_water(self, threat, prty, chance)
  --ignore chance, or run away
  if random()< chance then
    mobkit.hq_aqua_attack(self, prty, threat, self.max_speed)
  else
    mobkit.animate(self,'fast')
    animals.hq_swimfrom(self, prty, threat, self.max_speed)
    flee_sound(self)
  end
end

----------------------------------------------------------------
--Find and Flee predators
function animals.predator_avoid(self, prty, chance)

  for  _, pred in ipairs(self.predators) do
    local thr = mobkit.get_closest_entity(self,pred)
    if thr then
      animals.fight_or_flight(self, thr, prty, chance)
      return true
    end
  end
end


function animals.predator_avoid_water(self, prty, chance)

  for  _, pred in ipairs(self.predators) do
    local thr = mobkit.get_closest_entity(self,pred)
    if thr then
      animals.fight_or_flight_water(self, thr, prty, chance)
      return true
    end
  end
end

----------------------------------------------------------------
--Find and hunt prey
function animals.prey_hunt(self, prty)

  for  _, prey in ipairs(self.prey) do
    local tgtobj = mobkit.get_closest_entity(self,prey)
    if tgtobj then
      animals.hq_attack_eat(self,prty,tgtobj)
      return true
    end
  end
end


function animals.prey_hunt_water(self, prty)

  for  _, prey in ipairs(self.prey) do
    local tgtobj = mobkit.get_closest_entity(self,prey)
    if tgtobj then
      mobkit.animate(self,'fast')
      flee_sound(self)
      animals.hq_aqua_attack_eat(self, prty, tgtobj, self.max_speed)
      return true
    end
  end
end

----------------------------------------------------------------
--territorial behaviour
--avoid those in better condition
function animals.territorial(self, energy, eat)

  for  _, riv in ipairs(self.rivals) do

    local rival = mobkit.get_closest_entity(self, riv)

    if rival then

      --flee if hurt
      if self.hp < self.max_hp/4 then
        mobkit.animate(self,'fast')
        mobkit.make_sound(self,'warn')
        mobkit.hq_runfrom(self, 25, rival)
        return true
      end

      --contest! The more energetic one wins
      local r_ent = rival:get_luaentity()
      local r_ent_e = mobkit.recall(r_ent,'energy')

      if energy > r_ent_e then
        if eat then
          animals.hq_attack_eat(self, 25, rival)
        end
        return true
      else
        mobkit.animate(self,'fast')
        mobkit.make_sound(self,'warn')
        mobkit.hq_runfrom(self,25,rival)
        return true
      end
    end

  end

end


--water version
function animals.territorial_water(self, energy, eat)

  for  _, riv in ipairs(self.rivals) do

    local rival = mobkit.get_closest_entity(self, riv)

    if rival then

      --flee if hurt
      if self.hp < self.max_hp/4 then
        mobkit.animate(self,'fast')
        flee_sound(self)
        animals.hq_swimfrom(self, 25, rival ,self.max_speed)
        return true
      end

      --contest! The more energetic one wins
      local r_ent = rival:get_luaentity()
      local r_ent_e = mobkit.recall(r_ent,'energy')

      --not clear why some have nil, but it happens
      if r_ent_e == nil then
        return
      end

      if energy > r_ent_e then
        if eat then
          animals.hq_aqua_attack_eat(self, 25, rival, self.max_speed)
          flee_sound(self)
        else
          --harass
          mobkit.animate(self,'fast')
          animals.hq_swimafter(self, 15, rival, self.max_speed)
          flee_sound(self)
        end
        return true
      else
        mobkit.animate(self,'fast')
        flee_sound(self)
        animals.hq_swimfrom(self, 25, rival ,self.max_speed)
        return true
      end
    end

  end

end



----------------------------------------------------------------
--like mobkit version, but including removal of prey and gaining energy
--to hit is to catch... for predators, where the chewing does the killing
function animals.hq_aqua_attack_eat(self,prty,tgtobj,speed)
 local timer = time() + 12

	local tyaw = 0
	local prvscanpos = {x=0,y=0,z=0}
	local init = true
	local tgtbox = tgtobj:get_properties().collisionbox

	local func = function(self)
  if time() > timer then
    return true
  end

		if not mobkit.is_alive(tgtobj) then
    return true
  end

		if init then
			mobkit.animate(self,'fast')
			mobkit.make_sound(self,'attack')
			init = false
		end

		local pos = mobkit.get_stand_pos(self)
		local yaw = self.object:get_yaw()
		local scanpos = mobkit.get_node_pos(mobkit.pos_translate2d(pos,yaw,speed))
		if not vector.equals(prvscanpos,scanpos) then
			prvscanpos=scanpos
			local nyaw,height = aqua_radar_dumb(pos,yaw,speed*0.5)
			if height and height > pos.y then
				local vel = self.object:get_velocity()
				vel.y = vel.y+1
				self.object:set_velocity(vel)
			end
			if yaw ~= nyaw then
				tyaw=nyaw
				mobkit.hq_aqua_turn(self,prty+1,tyaw,speed)
				return
			end
		end

		local tpos = tgtobj:get_pos()
		local tyaw=minetest.dir_to_yaw(vector.direction(pos,tpos))
		mobkit.turn2yaw(self,tyaw,3)
		local yaw = self.object:get_yaw()
		if mobkit.timer(self,1) then
			if not mobkit.is_in_deep(tgtobj) then return true end
			local vel = self.object:get_velocity()
			if tpos.y>pos.y+0.5 then self.object:set_velocity({x=vel.x,y=vel.y+0.5,z=vel.z})
			elseif tpos.y<pos.y-0.5 then self.object:set_velocity({x=vel.x,y=vel.y-0.5,z=vel.z}) end
		end
		if mobkit.is_pos_in_box(mobkit.pos_translate2d(pos,yaw,self.attack.range),tpos,tgtbox) then	--bite
    mobkit.make_sound(self,'bite')
			tgtobj:punch(self.object,1,self.attack)
			mobkit.hq_aqua_turn(self,prty,yaw-pi,speed)
    if random()>0.2 then
      local ent = tgtobj:get_luaentity()
      local ent_e = (mobkit.recall(ent,'energy') or 1)
      local self_e = (mobkit.recall(self,'energy') or 1)
      mobkit.remember(self,'energy', ent_e + self_e)
      ent.object:remove()
      return true
    end
		end
		mobkit.go_forward_horizontal(self,speed)
	end
  mobkit.queue_high(self,func,prty)
end





---------------------------------------------------
--like mobkit version, but including removal of prey and gaining energy
--to hit is to catch... for predators, where the chewing does the killing
local function lq_jumpattack_eat(self,height,target)
	local phase=1
	local timer=0.5
	local tgtbox = target:get_properties().collisionbox
	local func=function(self)
		if not mobkit.is_alive(target) then return true end
		if self.isonground then
			if phase==1 then	-- collision bug workaround
				local vel = self.object:get_velocity()
				vel.y = -mobkit.gravity*sqrt(height*2/-mobkit.gravity)
				self.object:set_velocity(vel)
				mobkit.make_sound(self,'charge')
				phase=2
			else
				mobkit.lq_idle(self,0.3)
				return true
			end
		elseif phase==2 then
			local dir = minetest.yaw_to_dir(self.object:get_yaw())
			local vy = self.object:get_velocity().y
			dir=vector.multiply(dir,6)
			dir.y=vy
			self.object:set_velocity(dir)
			phase=3
		elseif phase==3 then	-- in air
			local tgtpos = target:get_pos()
			local pos = self.object:get_pos()
			-- calculate attack spot
			local yaw = self.object:get_yaw()
			local dir = minetest.yaw_to_dir(yaw)
			local apos = mobkit.pos_translate2d(pos,yaw,self.attack.range)

			if mobkit.is_pos_in_box(apos,tgtpos,tgtbox) then	--bite
				target:punch(self.object,1,self.attack)
					-- bounce off
				local vy = self.object:get_velocity().y
				self.object:set_velocity({x=dir.x*-3,y=vy,z=dir.z*-3})
					-- play attack sound if defined
				mobkit.make_sound(self,'attack')
				phase=4
        if random()>0.2 then
          local ent = target:get_luaentity()
          local ent_e = (mobkit.recall(ent,'energy') or 1)
          local self_e = (mobkit.recall(self,'energy') or 1)
          mobkit.remember(self,'energy', ent_e + self_e)
          ent.object:remove()
          return true
        end
			end
		end
	end
	mobkit.queue_low(self,func)
end





function animals.hq_attack_eat(self,prty,tgtobj)
  local timer = time() + 12

	local func = function(self)
    if time() > timer then
      return true
    end

		if not mobkit.is_alive(tgtobj) then return true end

		if mobkit.is_queue_empty_low(self) then
			local pos = mobkit.get_stand_pos(self)
--			local tpos = tgtobj:get_pos()
			local tpos = mobkit.get_stand_pos(tgtobj)
			local dist = vector.distance(pos,tpos)
			if dist > 3 then
				return true
			else
				mobkit.lq_turn2pos(self,tpos)
        --!! placeholder crash fix
				--local height = 0.35--tgtobj:is_player() and 0.35 or tgtobj:get_luaentity().height*0.6
        local height = tgtobj:get_luaentity().height*0.6 or 0.35
				if tpos.y+height>pos.y then
					lq_jumpattack_eat(self,tpos.y+height-pos.y,tgtobj)

				else
					mobkit.lq_dumbwalk(self,mobkit.pos_shift(tpos,{x=random()-0.5,z=random()-0.5}))
				end
			end
		end
	end
	mobkit.queue_high(self,func,prty)
end
