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
--

----------------------------------------------------------------------
-- returns 2D angle from self to target in radians
local function get_yaw_to_object(pos, opos)
  local ankat = pos.x - opos.x
  local gegkat = pos.z - opos.z
  local yaw = math.atan2(ankat, gegkat)
  return yaw
end



-------------------------------------------------------------------
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


----------------------------------------------------------------
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
        mobkit.remember(self,'energy',(ent_e/10) + self_e)
        ent.object:remove()
        return true
      end
 		end
 		mobkit.go_forward_horizontal(self,speed)
 	end
 	mobkit.queue_high(self,func,prty)
 end











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
          mobkit.remember(self,'energy',(ent_e/10) + self_e)
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
				local height = tgtobj:is_player() and 0.35 or tgtobj:get_luaentity().height*0.6
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
----------------------------------------------------------------
--[[




-- find if there is a node between pos1 and pos2
-- water = true means water = obstacle
-- returns distance to obstacle in nodes or nil

function water_life.find_collision(pos1,pos2,water)
    local ray = minetest.raycast(pos1, pos2, false, water)
            for pointed_thing in ray do
                --minetest.chat_send_all(dump(pointed_thing))
                if pointed_thing.type == "node" then
                    local dist = math.floor(vector.distance(pos1,pointed_thing.under))
                    return dist
                end
            end
            return nil
end


-- radar function for obstacles lying in front of an entity
-- use water = true if water should be an obstacle

function water_life.radar(pos, yaw, radius, water)

    if not radius or radius < 1 then radius = 16 end
    local left = 0
    local right = 0
    if not water then water = false end
    for j = 0,3,1 do
        for i = 0,4,1 do
            local pos2 = mobkit.pos_translate2d(pos,yaw+(i*pi/16),radius)
            local pos3 = mobkit.pos_translate2d(pos,yaw-(i*pi/16),radius)
            --minetest.set_node(pos2,{name="default:stone"})
            if water_life.find_collision(pos,{x=pos2.x, y=pos2.y + j*2, z=pos2.z}, water) then
                left = left + 5 - i
            end
            if water_life.find_collision(pos,{x=pos3.x, y=pos3.y + j*2, z=pos3.z},water) then
                right = right + 5 - i
            end
        end
    end
    local up =0
    local down = 0
    for j = -4,4,1 do
        for i = -3,3,1 do
            local k = i
            local pos2 = mobkit.pos_translate2d(pos,yaw+(i*pi/16),radius)
            local collide = water_life.find_collision(pos,{x=pos2.x, y=pos2.y + j, z=pos2.z}, water)
            if k < 0 then k = k * -1 end
            if collide and j <= 0 then
                down = down + math.floor((7+j-k)*collide/radius*2)
            elseif collide and j >= 0 then
                up = up + math.floor((7-j-k)*collide/radius*2)
            end
        end
    end
    local under = water_life.find_collision(pos,{x=pos.x, y=pos.y - radius, z=pos.z}, water)
    if not under then under = radius end
    local above = water_life.find_collision(pos,{x=pos.x, y=pos.y + radius, z=pos.z}, water)
    if not above then above = radius end
    if water_life.radar_debug then
        minetest.chat_send_all("left = "..left.."   right = "..right.."   up = "..up.."   down = "..down.."   under = "..under.."   above = "..above)
    end
    return left, right, up, down, under, above
end

]]
