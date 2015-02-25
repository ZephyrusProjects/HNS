--I heavily modified the TTT grenade base. Thanks for the base Badking!

AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")

AccessorFunc( ENT, "thrower", "Thrower")

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ExplodeTime")
	self:NetworkVar("Int", 1, "DetType")
end

function ENT:Initialize()
	self:SetModel(self.Model)
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	
	if SERVER then
		self:SetExplodeTime(0)
		self:SetDetType(self:GetDetType(Int))
	end
   
end



function InveseVector(vector)

	vector.x = vector.x * -1
	vector.y = vector.y * -1
	vector.z = vector.z * -1
	
	return vector
end

function ENT:SetLaserDirection(data, phys)

	--These vectors are used to draw a straight line in every direction
	--from the grenade
	local vectorTable = {
		Vector(-1000, 0, 0),
		Vector(1000, 0, 0),
		Vector(0, -1000, 0),
		Vector(0, 1000, 0),
		Vector(0, 0, -1000),
		Vector(0, 0, 1000) }

		local grenPos = self:LocalToWorld(self:OBBCenter())
		local correctVector = nil	--Store the vector that draws the shortest line
		
		--Draws a line in every direction from the grenade. Then calcultes the length of
		--each line. Once we find what vector gave us the shortest line, we will invert that
		--vector and use it to draw the laser.
		for k, v in pairs(vectorTable) do
			local tracedata = {}
			tracedata.start = grenPos
			tracedata.endpos = tracedata.start + (v * 12)   --If it's more then 12 units away, it's safe to say we don't want it.
			tracedata.filter = self					--So the trace doesn't hit the grenade and stop.
			local trace = util.TraceLine(tracedata)
			
			local traceLength = trace.HitPos - tracedata.start
				  traceLength = math.Round(traceLength:Length())
			
			if traceLength <= 12 then
				correctVector = v
			end
		
		end
		
		InveseVector(correctVector)			--Reverse the correct vector so we draw away from the wall
		self:SetNetworkedVector("laserVector", correctVector)
			
end



function ENT:PhysicsCollide(data, phys)
		
	local EntHit = data.HitEntity
	if !(IsValid(EntHit) or EntHit:IsWorld()) then return end
	
	local spos = self:GetPos()
	local tr = util.TraceLine({start=spos, endpos=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self.thrower})
	
	if self:GetDetType() == 2 then		--impact
		if EntHit:IsWorld() then
			self:Explode(tr)
		end
	end
		
		    
	if (self:GetDetType() == 3) then      --Trip mine
		if EntHit:IsWorld() then
			if IsValid(phys) then
				phys:EnableMotion( false )	
					self:SetLaserDirection(data, phys)
				timer.Simple(1, function() 
					self:StartUp()		--Draw the laser
				end)
				self:EmitSound( "hns/mine_combined.wav", 360, 100)

			end
		end
	end
		
		
	if (self:GetDetType() == 4) then      --proximity
		if tr.Hit and tr.HitWorld then
			if IsValid(phys) then
				phys:EnableMotion( false )
				self:EmitSound( "hns/mine_deploy.wav", 360, 100)		
				timer.Simple(.15, function() self:EmitSound( "npc/roller/mine/combine_mine_deploy1.wav", 360, 100) end)	
				timer.Simple(2, function() self:SetNWBool("ActivateProximity", true)  end)	
			end
		end
	end
				
end

 
function ENT:SetDetonateTimer(length)
	self:SetDetonateExact( CurTime() + length )
end

function ENT:SetDetonateExact(t)
	self:SetExplodeTime(t or CurTime())
end


-- override to describe what happens when the nade explodes
function ENT:Explode(tr)
	ErrorNoHalt("ERROR: BaseGrenadeProjectile explosion code not overridden!\n")
end



function ENT:StartUp()
	
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = self:GetPos() + self:GetNWVector("laserVector")

	trace.filter = self
	trace.mask = MASK_NPCWORLDSTATIC
	
	local tr = util.TraceLine( trace )

	local ent = ents.Create( "hns_laser" )
	ent:SetPos( self:GetPos() + self:GetRight()  + self:GetForward() + self:GetUp() )
	ent:Spawn()
	ent:SetLaserVector( tr.HitPos )	
	ent:SetParent( self )
	
	self.Laser = ent

end



if SERVER then

	function ENT:Think()

	   local etime = self:GetExplodeTime() or 0
	   if etime != 0 and etime < CurTime() then
		  -- if thrower disconnects before grenade explodes, just don't explode
		  if SERVER and (not IsValid(self:GetThrower())) then
			 self:Remove()
			 etime = 0
			 return
		  end

		  -- find the ground if it's near and pass it to the explosion
		  local spos = self:GetPos()
		  local tr = util.TraceLine({start=spos, endpos=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self.thrower})

		  local success, err = pcall(self.Explode, self, tr)
		  if not success then
			 -- prevent effect spam on Lua error
			 self:Remove()
			 ErrorNoHalt("ERROR CAUGHT: ttt_basegrenade_proj: " .. err .. "\n")
		  end
	   end

		
		if self:GetNWBool("ActivateProximity") then		--proximity
			local spos = self:GetPos()
			local tr = util.TraceLine({start=spos, endpos=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self.thrower})	
			local radius = 160

			local entList = ents.FindInSphere( self:GetPos(), radius )
			
			for k, v in pairs(entList) do
				if (v:IsPlayer() && v != self.Owner && v:Team() != self.Owner:Team()) then
					self:EmitSound("weapons/grenade/tick1.wav", 360, 100)
					self:EmitSound("weapons/grenade/tick1.wav", 360, 100)
					self:EmitSound("weapons/grenade/tick1.wav", 360, 100)
					self:Explode(tr)
					break
				end
			end
		end
		
	end

end


if CLIENT then

	function ENT:Draw()
		self:DrawModel() 	
	end   
	
end

