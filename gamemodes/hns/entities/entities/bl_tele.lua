ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Teleport"
ENT.Author = "Swifty"
ENT.Information = [[Teleport Entrance.]]
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.Category = "hns_teleport"
ENT.TeleportNumber = 0 		--Don't set to nil. It's set to 0 for a check in the SaveBlocks function
ENT.TeleportPosition = nil
ENT.BlockOwner = "base"
 
 PrecacheParticleSystem("hunter_projectile_explosion_2i")

if ( SERVER ) then

	AddCSLuaFile()

	function ENT:Initialize()
		self.Entity:SetModel("models/props_junk/watermelon01.mdl")
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.TeleportPosition = self	--Prevents errors when the exit hasn't been placed yet

		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then 
			phys:Wake() 
		end
	end

	
	function ENT:SpawnFunction( ply, tr ) 
		if ( !tr.Hit ) then return end 
		 
		local SpawnPos = tr.HitPos + tr.HitNormal * 16
		 
		local ent = ents.Create( self.Classname ) 
		ent:SetPos( SpawnPos ) 
		ent:Spawn() 
		ent:Activate() 
		return ent 
	 end 
	 

	function ENT:Think(ent)
		local radius = 32
		local entList = ents.FindInSphere( self.Entity:GetPos() + Vector(0,0,24), radius )
		
		for k, v in pairs(entList) do
			if (v:IsPlayer() ) then
				v:SetPos(self.TeleportPosition:GetPos())
				v:EmitSound("hns/blinkarrival.wav", 360, 100)	
				ParticleEffect( "hunter_projectile_explosion_2i", self:GetPos(), Angle(0,0,0) )
				
				--Makes the player fly upward, when falling downward into a teleport
				local velocity = v:GetVelocity()
				if velocity.z <= 0 then 
					velocity.z = (velocity.z * -1) * 2
					v:SetVelocity(velocity)
				end
			end
		end
	end

end


function ENT:SetupDataTables()
	self:NetworkVar( "String", "0", "BlockOwner" )
end


if ( CLIENT ) then

	function ENT:Initialize()
		
		local owner = self:GetBlockOwner()
		self.BlockOwner = owner
	
		local centr = self:GetPos()
		local em = ParticleEmitter(centr)
		
		self.part1 = em:Add("effects/strider_muzzle",centr)
		self.part2 = em:Add("hns/strider_bulge_dudv_dx60",centr)	--We use a edited verion of this
	 
		self.part1:SetDieTime(10000)
		self.part1:SetLifeTime(0)
		self.part1:SetStartSize(25)
		self.part1:SetEndSize(25)
		  
		self.part2:SetDieTime(10000)
		self.part2:SetLifeTime(0)
		self.part2:SetStartSize(25)
		self.part2:SetEndSize(25)
		
		em:Finish()
	end
	

	function ENT:OnRemove()
		self.part1:SetDieTime(1)
		self.part2:SetDieTime(1)
	end
	
	function ENT:Think()
		if self.part1:GetDieTime() or self.part2:GetDieTime() <= 1 then
			self.part1:SetDieTime(10000)
			self.part2:SetDieTime(10000)
		end
	end


	function ENT:Draw()
		self:DrawShadow( false )
		self.part1:SetPos(self:GetPos())
		self.part2:SetPos(self:GetPos())
	end

end

