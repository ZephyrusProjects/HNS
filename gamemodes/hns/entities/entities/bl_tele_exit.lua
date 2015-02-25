ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Teleport"
ENT.Author = "Swifty"
ENT.Information = [[Teleport Exit.]]
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.Category = "hns_teleport"
ENT.TeleportNumber = 0 		--Don't set to nil. It's set to 0 for a check in the SaveBlocks function
ENT.BlockOwner = "base"

if ( SERVER ) then

	AddCSLuaFile()

	function ENT:Initialize()
		self.Entity:SetModel("models/props_junk/watermelon01.mdl")
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
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
		self.part3 = em:Add("effects/combinemuzzle2_dark",centr)
	 
		self.part1:SetDieTime(10000)
		self.part1:SetLifeTime(0)
		self.part1:SetStartSize(25)
		self.part1:SetEndSize(25)
		  
		self.part2:SetDieTime(10000)
		self.part2:SetLifeTime(0)
		self.part2:SetStartSize(25)
		self.part2:SetEndSize(25)
				
		self.part3:SetDieTime(10000)
		self.part3:SetLifeTime(0)
		self.part3:SetStartSize(25)
		self.part3:SetEndSize(25)
		
		em:Finish()
	end
	
	
	function ENT:OnRemove()
	   self.part1:SetDieTime(1)
	   self.part2:SetDieTime(1)
	   self.part3:SetDieTime(1)
	end
	
	function ENT:Think()
		if self.part1:GetDieTime() or self.part2:GetDieTime() <= 1 then
			self.part1:SetDieTime(10000)
			self.part2:SetDieTime(10000)
			self.part3:SetDieTime(10000)
		end
	end

	

	function ENT:Draw(ent)
		self:DrawShadow( false )
			
		local centr = self:GetPos()
		self.part1:SetPos(centr)
		self.part2:SetPos(centr)
		self.part3:SetPos(centr)
	end

end

