ENT.Base = "base_hns_blocks"
ENT.PrintName = "Death"
ENT.Color =  Color( 0, 0, 0, 255)

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
		if ent:HasGodMode() then return end		--Prevents us from killing builders and plyrs w/ power ups
		
		if ( IsValid(ent) and ent:IsPlayer() ) then
			ent:Kill()
		end
	end
 
end
