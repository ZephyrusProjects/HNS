ENT.Base = "base_hns_blocks"
ENT.PrintName = "Booster"
ENT.Information = [[Booster Strip.]]
ENT.Category = "hns_movement"
ENT.Color =  Color(0, 128, 128, 255)

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
	
		if ( IsValid(ent) and ent:IsPlayer() ) then
			ent:SetPos( ent:GetPos() + Vector(0,0,8) )		--Lift them up a little bit
			
			local forward = ent:GetForward()
		          forward.z = 0.0			--Prevents player from flying upward while looking up
			
			ent:SetVelocity(forward * 300 + Vector(0,0,275))
		end
	end
		
end
