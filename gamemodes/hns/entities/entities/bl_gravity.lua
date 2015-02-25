ENT.Base = "base_hns_blocks"
ENT.PrintName = "Low Gravity"
ENT.Information = [[Low Gravity]]
ENT.Category = "hns_movement"
ENT.Color =  Color(50, 15, 151, 255)

if (SERVER) then

	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel("models/hns/Normal.mdl")
		self:SetMaterial("models/blocks/" .. self:GetClass() )
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then 
			phys:Wake() 
		end
	end

	
	function ENT:StartTouch( ent )
		if !IsValid(ent:GetGroundEntity()) or ent:GetGroundEntity():GetClass() != self:GetClass() then return end
		
         if ( IsValid(ent) and ent:IsPlayer() and ent:GetGroundEntity():GetClass() == self:GetClass() ) then	 
			ent:SetGravity( .25 )
        end
	end
	
	function ENT:EndTouch( ent )
		 if !ent:OnGround() then return end	
		
         if ( IsValid(ent) and ent:IsPlayer() and ent:GetGroundEntity():GetClass() != self:GetClass() ) then	 
			ent:SetGravity( 1 )
        end
	end

end
