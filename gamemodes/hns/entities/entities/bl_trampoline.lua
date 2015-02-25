ENT.Base = "base_hns_blocks"
ENT.PrintName = "Trampoline"
ENT.Information = [[Jump like Jordan]]
ENT.Category = "hns_movement"
ENT.Color =   Color(255, 0, 255, 255)
ENT.TrampPower = 8

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
		 	ent:SetVelocity( Vector(0,0,self.TrampPower * 50) )
        end
	end
	
end
